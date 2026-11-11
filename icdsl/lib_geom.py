"""Library `geom`: relative geometry for hand-built standard cells (`stdcell` blocks).

Every shape has a name and is defined relative to other shapes; `min` resolves to the
rule value for the layers involved, so an agent never needs a raw design-rule number.

    stdcell <name> width=<cols> [height=2.72] [taps=yes|no] [nwell_y=<um>]
       template objects: cell, vgnd, vpwr (met1 rails), vgnd_li, vpwr_li, ptap, ntap, nwell

    <n> = rect    <layer> [w=] [h=] <x-spec> <y-spec> [net=]
            x-spec: left= | right= | cx= | right_of=<obj> | left_of=<obj> | xspan=(a, b) | in=<obj>
            y-spec: bottom= | top= | cy= | above=<obj> | below=<obj> | yspan=(a, b) | in=<obj>
            space=min|<um> (gap for *_of/above/below), align=center|top|bottom|left|right
    <n> = enclose <obj|[objs]> <layer> [by=min|minx|<um>|(x, y)] [left= right= top= bottom=] [net=]
    <n> = cross   <obj> <layer> [w=] [dir=v|h] [ext=min|<um>|(lo, hi)] <x-spec|y-spec> [net=]
    <n> = contact <cut> [in=<obj>] <x-spec> <y-spec> [net=]
    <n> = array   <cut> in=<obj> [dir=y|x] [space=min] [margin=min] [cx=|cy=] [span=(a, b)] [net=]
    <n> = strap   <layer> from=<obj> to=<obj> [w=min] [cx=|cy=] [net=]
    <n> = copy    <obj> [dx=] [dy=]
    <n> = mirror  <obj> axis=<x um>
    net    <net> <obj> <obj> ...
    port   <net> in|out|inout|power|ground [on=<obj>]
    device <name> nmos|pmos w= l= [nf=] d= g= s= [b=]        (reference netlist for LVS)
    route / wire / keepout / limit                          (library route, optional)
"""
from __future__ import annotations

from . import drc_lite
from . import tech as T
from .build import BuildScope, Layout
from .devices import tap_strip
from .geom import Rect, Shape
from .lib_route import RoutePlan
from .router import PinGroup, Router
from .syntax import ICLError, Min, Point, check_keys, did_you_mean, ident, nm

G = T.GRID
LAYERS = ("nwell", "diff", "tap", "poly", "licon", "npc", "nsdm", "psdm", "li", "mcon", "m1", "via", "m2",
          "via2", "m3", "via3", "m4")
CUTS = ("licon", "mcon", "via", "via2", "via3")
POS_KEYS = {"left", "right", "cx", "right_of", "left_of", "xspan", "bottom", "top", "cy", "above", "below",
            "yspan", "in", "space", "gap", "xspace", "yspace", "align", "at"}


def _s5(v):
    return int(round(v / 5.0)) * 5


class Named:
    def __init__(self, name, layer, rects, net=None, line=0):
        self.name, self.layer, self.rects, self.net, self.line = name, layer, list(rects), net, line

    def bbox(self):
        b = self.rects[0]
        for r in self.rects[1:]:
            b = b.union(r)
        return b

    def shapes(self):
        return [Shape(self.layer, r, self.net, self.name) for r in self.rects]

    def pin_shapes(self):
        return self.shapes()

    def icl_xy(self):
        b = self.bbox()
        return Point(b.cx / 1000, b.cy / 1000)

    def icl_attr(self, a, line):
        b = self.bbox()
        m = {"left": b.x0, "right": b.x1, "bottom": b.y0, "top": b.y1, "cx": b.cx, "cy": b.cy, "w": b.w, "h": b.h}
        if a in m:
            return m[a] / 1000
        if a == "layer":
            return self.layer
        if a == "net":
            return self.net
        if a == "n":
            return len(self.rects)
        raise ICLError(f"'{self.name}' has no attribute '{a}'", line,
                       did_you_mean(a, list(m) + ["layer", "net", "n"]))

    def __repr__(self):
        return f"<{self.layer} {self.name}>"


class GeomBuilder:
    def __init__(self, design, block):
        self.design, self.block = design, block
        self.L = Layout(block.name, kind="stdcell")
        self.scope = BuildScope()
        self.scope.names.update(getattr(design, 'params', {}))
        self.plan = RoutePlan()
        self.objs = {}
        self.devices = []
        self.ports = []
        self.lines = {}

    def err(self, msg, line=None, hint=""):
        return ICLError(f"stdcell {self.block.name}: {msg}", self.block.head.line if line is None else line, hint)

    # ------------------------------------------------------------- driver
    def build(self):
        hd = self.block.head
        check_keys(hd, {"width", "height", "taps", "nwell_y", "power", "ground", "route_grid"}, "stdcell")
        self.rgrid = nm(self.scope.eval(hd.kw.get("route_grid", "0.115"), hd.line))
        if "width" not in hd.kw:
            raise ICLError("stdcell needs width=<columns of 0.46 um>", hd.line)
        self.W = int(self.scope.eval(hd.kw["width"], hd.line)) * G
        self.H = nm(self.scope.eval(hd.kw.get("height", "2.72"), hd.line))
        self.L.power = hd.kw.get("power", "VPWR")
        self.L.ground = hd.kw.get("ground", "VGND")
        self._template(hd)
        for st in self.block.body:
            if self.plan.handles(st.verb):
                self.plan.add(st, self.scope)
                continue
            fn = getattr(self, "st_" + st.verb, None)
            if fn is None:
                verbs = [m[3:] for m in dir(self) if m.startswith("st_")] + ["route", "wire", "keepout", "limit"]
                raise ICLError(f"unknown statement '{st.verb}' in a stdcell", st.line,
                               did_you_mean(st.verb, verbs) or "stdcell statements: " + ", ".join(sorted(verbs)))
            fn(st)
        L = self.L
        L.width, L.height = self.W, self.H
        for o in self.objs.values():
            if o.layer != "boundary":
                L.shapes += o.shapes()
        if self.plan.specs or self.plan.wires or self.plan.star:
            self._route()
        self._ports()
        self._pin_access()
        L.shapes.append(Shape("boundary", Rect(0, 0, self.W, self.H), None, "boundary"))
        pre = drc_lite.attribute(drc_lite.run(L.shapes), L.shapes, self.lines)
        L.info["precheck"] = pre
        L.info["shapes"] = {n: f"{o.layer:5s} {o.bbox()} net={o.net or '-'} (line {o.line})"
                            for n, o in self.objs.items() if o.line}
        L.info["geom_objects"] = {n: {"layer": o.layer, "bbox_um": [round(v / 1000, 3) for v in
                                                               (o.bbox().x0, o.bbox().y0, o.bbox().x1, o.bbox().y1)],
                                 "net": o.net, "line": o.line}
                             for n, o in self.objs.items() if o.rects and o.layer != "boundary"}
        try:
            from . import conncheck
            devs = [(d[0], d[1], d[5], d[6], d[7]) for d in self.devices for _ in range(d[4])]
            L.info["conn"] = conncheck.analyse(L.shapes, devs, {n: o.line for n, o in self.objs.items()},
                                               (L.power, L.ground) if hasattr(L, "ground") else ("VPWR", "VGND"))
        except Exception as e:                      # diagnostics must never break a build
            L.info["conn"] = {"error": repr(e)[:200]}
        if pre:
            L.warnings.append(f"fast pre-check found {len(pre)} rule issue(s): " +
                              "; ".join(f"{v['rule']} at {v['box_um']} near {', '.join(v['objects'][:3])}"
                                        for v in pre[:6]))
        self._netlist()
        return L

    def _template(self, hd):
        self.scope.names["minx"] = "minx"
        W, H = self.W, self.H
        pw, gn = self.L.power, self.L.ground
        add = lambda n, layer, r, net=None: self._put(Named(n, layer, [r], net, 0))
        add("cell", "boundary", Rect(0, 0, W, H))
        add("vgnd", "m1", Rect(0, -240, W, 240), gn)
        add("vpwr", "m1", Rect(0, H - 240, W, H + 240), pw)
        taps = hd.kw.get("taps", "yes") in ("yes", "true", "1")
        if taps:
            for kind, y, net in (("ptap", 0, gn), ("ntap", H, pw)):
                S = tap_strip(kind, net, W, y, kind)
                for lay in ("tap", "licon", "mcon"):
                    rs = [s.rect for s in S if s.layer == lay]
                    self._put(Named(kind if lay == "tap" else f"{kind}_{lay}", lay, rs, net, 0))
                li = [s.rect for s in S if s.layer == "li"][0]
                self._put(Named("vgnd_li" if kind == "ptap" else "vpwr_li", "li", [li], net, 0))
                th = T.R["licon.size"] + 2 * T.R["licon.diff_enc1"]
                e = T.R["sdm.enc_diff"]
                imp = "psdm" if kind == "ptap" else "nsdm"
                self._put(Named(f"{kind}_imp", imp, [Rect(0, y - th // 2 - e, W, y + th // 2 + e)], None, 0))
        else:
            add("vgnd_li", "li", Rect(0, -85, W, 85), gn)
            add("vpwr_li", "li", Rect(0, H - 85, W, H + 85), pw)
        ny = nm(self.scope.eval(hd.kw["nwell_y"], hd.line)) if "nwell_y" in hd.kw else int(round(H * 0.48 / 5)) * 5
        add("nwell", "nwell", Rect(0, ny, W, H + 145 + 180 if taps else H + 190))
        for n in ("cell",):
            self.objs[n].layer = "boundary"

    def _put(self, o):
        self.objs[o.name] = o
        self.scope.names[o.name] = o
        if o.line:
            self.lines[o.name] = o.line

    def _new(self, st, layer, rects, net=None):
        if not st.target:
            st.target = f"{st.verb}_line{st.line}"   # unnamed shape: fine as long as nothing refers to it
        if st.target in self.objs:
            raise ICLError(f"'{st.target}' already defined (line {self.objs[st.target].line})", st.line,
                           f"every name is defined once - rename this one (e.g. '{st.target}2 = ...')")
        rr = []
        for r in rects:
            for v in (r.x0, r.y0, r.x1, r.y1):
                if v % 5:
                    raise ICLError(f"{st.target}: coordinate {v/1000} um is off the 5 nm grid", st.line)
            rr.append(r)
        o = Named(st.target, layer, rr, net, st.line)
        self._put(o)
        return o

    # ------------------------------------------------------------- helpers
    def _layer(self, s, line, cuts_only=False):
        if s not in LAYERS:
            raise ICLError(f"unknown layer '{s}'", line, did_you_mean(s, LAYERS) or f"layers: {', '.join(LAYERS)}")
        if cuts_only and s not in CUTS:
            raise ICLError(f"'{s}' is not a cut layer ({', '.join(CUTS)})", line)
        return s

    def _obj(self, expr, line):
        v = self.scope.eval(expr, line)
        if isinstance(v, list):
            for x in v:
                if not isinstance(x, Named):
                    raise ICLError(f"expected shapes, got {x!r}", line)
            return v
        if not isinstance(v, Named):
            raise ICLError(f"expected a shape name, got {v!r}", line)
        return v

    def _num(self, st, key, default=None, rule=None):
        if key not in st.kw:
            return default
        v = self.scope.eval(st.kw[key], st.line)
        if isinstance(v, Min):
            if rule is None:
                raise ICLError(f"'{key}=min' has no rule meaning here", st.line)
            return rule + nm(v.off)
        if isinstance(v, Named):
            raise ICLError(f"'{key}=' needs a number (did you mean {v.name}.cx / .left / ...?)", st.line)
        return nm(v)

    def _net(self, st):
        return ident(st.kw["net"], "net", st.line) if "net" in st.kw else None

    def _place(self, st, layer, w, h, size_from_target=None):
        """Resolve x/y position keywords -> Rect."""
        if "gap" in st.kw and "space" not in st.kw:      # level-2 vocabulary: gap == space
            st.kw["space"] = st.kw.pop("gap")
        kw = st.kw
        x0 = x1 = y0 = y1 = None
        inside = self._obj(kw["in"], st.line) if "in" in kw else None
        if isinstance(inside, list):
            inside = inside[0]
        # ---- x
        xk = [k for k in ("left", "right", "cx", "right_of", "left_of", "xspan") if k in kw]
        yk = [k for k in ("bottom", "top", "cy", "above", "below", "yspan") if k in kw]
        if "at" in kw:
            p = self.scope.eval(kw["at"], st.line)
            p = p.icl_xy() if hasattr(p, "icl_xy") else p
            if "cx" not in kw:
                kw = dict(kw, cx=str(p[0]))
                xk.append("cx")
            if "cy" not in kw:
                kw = dict(kw, cy=str(p[1]))
                yk.append("cy")
        if len([k for k in xk if k != "xspan"]) > 2 or ("left" in kw and "right" in kw and w is not None):
            raise ICLError("too many horizontal constraints (give w + one of left/right/cx/right_of/left_of, "
                           "or left + right)", st.line)
        ref = None
        if "xspan" in kw:
            a, b = self.scope.eval(kw["xspan"], st.line)
            x0, x1 = nm(a), nm(b)
        elif "left" in kw and "right" in kw:
            x0, x1 = self._num(st, "left"), self._num(st, "right")
        elif "right_of" in kw or "left_of" in kw:
            k = "right_of" if "right_of" in kw else "left_of"
            ref = self._obj(kw[k], st.line)
            ref = ref[0] if isinstance(ref, list) else ref
            rs = T.rule_space(layer, ref.layer)
            sp = self._num(st, "xspace", self._num(st, "space", rs, rs), rs)
            if w is None:
                raise ICLError("w= is needed with right_of/left_of", st.line)
            if k == "right_of":
                x0 = ref.bbox().x1 + sp
                x1 = x0 + w
            else:
                x1 = ref.bbox().x0 - sp
                x0 = x1 - w
        elif xk:
            if w is None:
                raise ICLError("w= is needed (or give both left= and right=)", st.line)
            if "left" in kw:
                x0 = self._num(st, "left")
                x1 = x0 + w
            elif "right" in kw:
                x1 = self._num(st, "right")
                x0 = x1 - w
            else:
                c = self._num(st, "cx")
                x0 = c - w // 2
                x1 = x0 + w
        elif inside is not None and w is not None:
            c = inside.bbox().cx
            x0 = c - w // 2
            x1 = x0 + w
        # ---- y
        if "yspan" in kw:
            a, b = self.scope.eval(kw["yspan"], st.line)
            y0, y1 = nm(a), nm(b)
        elif "bottom" in kw and "top" in kw:
            y0, y1 = self._num(st, "bottom"), self._num(st, "top")
        elif "above" in kw or "below" in kw:
            k = "above" if "above" in kw else "below"
            r2 = self._obj(kw[k], st.line)
            r2 = r2[0] if isinstance(r2, list) else r2
            rs = T.rule_space(layer, r2.layer)
            sp = self._num(st, "yspace", self._num(st, "space", rs, rs) if "xspace" not in st.kw else rs, rs)
            if h is None:
                raise ICLError("h= is needed with above/below", st.line)
            if k == "above":
                y0 = r2.bbox().y1 + sp
                y1 = y0 + h
            else:
                y1 = r2.bbox().y0 - sp
                y0 = y1 - h
            if ref is None and not xk:
                ref = r2
        elif yk:
            if h is None:
                raise ICLError("h= is needed (or give both bottom= and top=)", st.line)
            if "bottom" in kw:
                y0 = self._num(st, "bottom")
                y1 = y0 + h
            elif "top" in kw:
                y1 = self._num(st, "top")
                y0 = y1 - h
            else:
                c = self._num(st, "cy")
                y0 = c - h // 2
                y1 = y0 + h
        elif inside is not None and h is not None:
            c = inside.bbox().cy
            y0 = c - h // 2
            y1 = y0 + h
        # ---- alignment with the reference for the unspecified axis
        al = kw.get("align", "center")
        if x0 is None and ref is not None and w is not None:
            rb = ref.bbox()
            x0 = {"center": rb.cx - w // 2, "left": rb.x0, "right": rb.x1 - w}.get(al, rb.cx - w // 2)
            x1 = x0 + w
        if y0 is None and ref is not None and h is not None:
            rb = ref.bbox()
            y0 = {"center": rb.cy - h // 2, "bottom": rb.y0, "top": rb.y1 - h}.get(al, rb.cy - h // 2)
            y1 = y0 + h
        if x0 is None:
            raise ICLError("no horizontal position: give left=, right=, cx=, right_of=, left_of=, xspan= or in=",
                           st.line)
        if y0 is None:
            raise ICLError("no vertical position: give bottom=, top=, cy=, above=, below=, yspan= or in=", st.line)
        x0, y0 = _s5(x0), _s5(y0)
        x1, y1 = x0 + _s5(x1 - x0), y0 + _s5(y1 - y0)
        if x1 <= x0 or y1 <= y0:
            raise ICLError(f"resulting rectangle is empty ({x0/1000},{y0/1000})-({x1/1000},{y1/1000})", st.line)
        return Rect(x0, y0, x1, y1)

    # ------------------------------------------------------------- shape verbs
    def st_let(self, st):
        """name = <expression>: bind a value (number, point, object) for later expressions."""
        if st.target in self.scope.names:
            raise ICLError(f"'{st.target}' is already defined", st.line)
        self.scope.names[st.target] = self.scope.eval(st.args[0], st.line)

    def st_rect(self, st):
        check_keys(st, POS_KEYS | {"w", "h", "net"}, "rect")
        if len(st.args) != 1:
            raise ICLError("usage: <name> = rect <layer> [w=] [h=] <position> [net=]", st.line)
        layer = self._layer(st.args[0], st.line)
        w = self._num(st, "w", None, T.rule_width(layer))
        h = self._num(st, "h", None, T.rule_width(layer))
        self._new(st, layer, [self._place(st, layer, w, h)], self._net(st))

    def st_enclose(self, st):
        check_keys(st, {"by", "left", "right", "top", "bottom", "net"}, "enclose")
        if len(st.args) != 2:
            raise ICLError("usage: <name> = enclose <obj|[objs]> <layer> [by=min|minx|<um>|(x,y)]", st.line)
        tg = self._obj(st.args[0], st.line)
        tg = tg if isinstance(tg, list) else [tg]
        layer = self._layer(st.args[1], st.line)
        bb = tg[0].bbox()
        for t in tg[1:]:
            bb = bb.union(t.bbox())
        e0 = max(T.rule_enc(layer, t.layer)[0] for t in tg)
        e1 = max(T.rule_enc(layer, t.layer)[1] for t in tg)
        by = self.scope.eval(st.kw.get("by", "min"), st.line)
        if isinstance(by, Min):
            mx, my = e0 + nm(by.off), max(e0, e1) + nm(by.off)
        elif by == "minx" or (isinstance(by, str) and by == "minx"):
            mx, my = max(e0, e1), e0
        elif isinstance(by, Point):
            mx, my = nm(by[0]), nm(by[1])
        elif isinstance(by, (int, float)):
            mx = my = nm(by)
        else:
            raise ICLError("by= must be min, a number, or (x, y)", st.line)
        m = {"left": mx, "right": mx, "bottom": my, "top": my}
        for k in m:
            if k in st.kw:
                v = self.scope.eval(st.kw[k], st.line)
                m[k] = (e0 + nm(v.off)) if isinstance(v, Min) else nm(v)
        r = Rect(bb.x0 - m["left"], bb.y0 - m["bottom"], bb.x1 + m["right"], bb.y1 + m["top"])
        if len(tg) > 1 and layer in ("poly", "li", "m1", "m2", "m3") and not self._net(st):
            nets = {t.net for t in tg if t.net}
            if len(nets) != 1:
                raise ICLError(f"enclose of {len(tg)} objects on {layer} makes ONE rectangle over all of them - that "
                               f"connects (shorts) {', '.join(t.name for t in tg)}", st.line,
                               f"enclose each one separately (e.g. `x1 = enclose {tg[0].name} {layer} ...`), or add "
                               f"net=<name> if they really are one net. One rectangle over several objects is right for "
                               f"npc/nsdm/psdm, not for conductors")
        self._new(st, layer, [r], self._net(st) or (tg[0].net if len(tg) == 1 and layer in ("li", "m1", "m2", "poly") else None))

    def scope_minx(self):
        return "minx"

    def st_cross(self, st):
        check_keys(st, POS_KEYS | {"w", "dir", "ext", "net"}, "cross")
        if len(st.args) != 2:
            raise ICLError("usage: <name> = cross <obj> <layer> [w=] [dir=v|h] [ext=min] <position>", st.line)
        tgs = self._obj(st.args[0], st.line)
        tgs = tgs if isinstance(tgs, list) else [tgs]
        tg = Named("+".join(t.name for t in tgs), tgs[0].layer, [t.bbox() for t in tgs])
        layer = self._layer(st.args[1], st.line)
        d = st.kw.get("dir", "v")
        rule = T.EXT.get((layer, tg.layer), 0)
        ext = self.scope.eval(st.kw.get("ext", "min"), st.line)
        if isinstance(ext, Min):
            lo = hi = rule + nm(ext.off)
        elif isinstance(ext, Point) or isinstance(ext, tuple):
            lo, hi = nm(ext[0]), nm(ext[1])
        else:
            lo = hi = nm(ext)
        w = self._num(st, "w", T.rule_width(layer), T.rule_width(layer))
        bb = tg.bbox()
        along = ("bottom", "top", "cy", "above", "below", "yspan") if d == "v" else \
            ("left", "right", "cx", "right_of", "left_of", "xspan")
        bad = [k for k in along if k in st.kw]
        if bad:
            raise ICLError(f"cross: '{bad[0]}=' conflicts with crossing - a {'vertical' if d == 'v' else 'horizontal'} "
                           f"cross spans the crossed objects plus ext= at each end", st.line,
                           "drop it; use ext=(lo, hi) to lengthen one end, or a plain rect for other shapes")
        if d == "v":
            sub = type(st)(st.line, st.verb, st.target, [], {k: v for k, v in st.kw.items()
                                                            if k in ("left", "right", "cx", "right_of", "left_of", "xspan", "space", "at")}, st.text)
            sub.kw["yspan"] = f"({(bb.y0 - lo)/1000}, {(bb.y1 + hi)/1000})"
            if not any(k in sub.kw for k in ("left", "right", "cx", "right_of", "left_of", "xspan", "at")):
                sub.kw["cx"] = str(bb.cx / 1000)
            r = self._place(sub, layer, w, None)
        else:
            sub = type(st)(st.line, st.verb, st.target, [], {k: v for k, v in st.kw.items()
                                                            if k in ("bottom", "top", "cy", "above", "below", "yspan", "space", "at")}, st.text)
            sub.kw["xspan"] = f"({(bb.x0 - lo)/1000}, {(bb.x1 + hi)/1000})"
            if not any(k in sub.kw for k in ("bottom", "top", "cy", "above", "below", "yspan", "at")):
                sub.kw["cy"] = str(bb.cy / 1000)
            r = self._place(sub, layer, None, w)
        self._new(st, layer, [r], self._net(st))

    def st_contact(self, st):
        check_keys(st, POS_KEYS | {"net"}, "contact")
        if len(st.args) != 1:
            raise ICLError("usage: <name> = contact <cut> [in=<obj>] <position>", st.line)
        cut = self._layer(st.args[0], st.line, cuts_only=True)
        sz = T.CUT_SIZE[cut]
        self._new(st, cut, [self._place(st, cut, sz, sz)], self._net(st))

    def st_array(self, st):
        check_keys(st, {"in", "dir", "space", "margin", "cx", "cy", "net", "left_of", "right_of", "gap", "between",
                        "span"}, "array")
        if "between" in st.kw or ("left_of" in st.kw and "right_of" in st.kw):
            if "between" in st.kw:
                two = self._obj(st.kw.pop("between"), st.line)
                if not isinstance(two, list) or len(two) != 2:
                    raise ICLError("array between= takes two objects: between=[g1, g2]", st.line)
                a, b = sorted(two, key=lambda o: o.bbox().cx)
            else:
                a = self._obj(st.kw.pop("right_of"), st.line)
                b = self._obj(st.kw.pop("left_of"), st.line)
                a = a[0] if isinstance(a, list) else a
                b = b[0] if isinstance(b, list) else b
            cut0 = self._layer(st.args[0], st.line, cuts_only=True) if st.args else "licon"
            g0 = T.rule_space(cut0, a.layer)
            room = b.bbox().x0 - a.bbox().x1
            need = T.CUT_SIZE[cut0] + 2 * g0
            if room < need:
                raise ICLError(f"array: only {room/1000:.3f} um between {a.name} and {b.name}; a {cut0} column needs "
                               f"{need/1000:.3f} um ({g0/1000:.3f} + {T.CUT_SIZE[cut0]/1000:.2f} + {g0/1000:.3f})",
                               st.line, f"move {b.name} right (e.g. left=({a.name}.right + {need/1000:.3f})) or drop "
                                        "this contact if the node between them is a series node")
            st.kw["cx"] = str((a.bbox().x1 + b.bbox().x0) / 2000)
            st.kw.setdefault("dir", "y")
        if len(st.args) != 1 or "in" not in st.kw:
            raise ICLError("usage: <name> = array <cut> in=<obj> [dir=y|x] [space=min] [margin=min] [cx=|cy=]", st.line)
        cut = self._layer(st.args[0], st.line, cuts_only=True)
        tg = self._obj(st.kw["in"], st.line)
        tg = tg[0] if isinstance(tg, list) else tg
        sz = T.CUT_SIZE[cut]
        sp = self._num(st, "space", T.rule_space(cut), T.rule_space(cut))
        e0, e1 = T.rule_enc(tg.layer, cut)
        mg = self._num(st, "margin", max(e0, e1), max(e0, e1))
        bb = tg.bbox()
        beside = "left_of" in st.kw or "right_of" in st.kw
        if "cx" in st.kw and "cy" not in st.kw:
            beside = True                   # an x position means a vertical column at that x
        d = st.kw.get("dir", "y" if (beside or bb.h >= bb.w) else "x")
        if "cy" in st.kw and "cx" not in st.kw and not ("left_of" in st.kw or "right_of" in st.kw):
            d = st.kw.get("dir", "x")       # a y position means a horizontal row at that y
        lo, hi = (bb.y0 + mg, bb.y1 - mg) if d == "y" else (bb.x0 + mg, bb.x1 - mg)
        if "span" in st.kw:                 # restrict the column/row to part of the object
            sv = self.scope.eval(st.kw["span"], st.line)
            if not isinstance(sv, (tuple, list)) or len(sv) != 2:
                raise ICLError("array span= takes two coordinates: span=(from, to)", st.line)
            lo, hi = max(lo, nm(min(sv))), min(hi, nm(max(sv)))
        span = hi - lo
        n = (span - sz) // (sz + sp) + 1
        if n < 1:
            raise ICLError(f"array: no {cut} fits in {tg.name} ({span/1000:.3f} um usable along {d}"
                           f"{' within span=' if 'span' in st.kw else ''}; one cut needs "
                           f"{sz/1000:.3f} um + margin {mg/1000:.3f} um each side)", st.line)
        tot = n * sz + (n - 1) * sp
        rects = []
        side = "left_of" if "left_of" in st.kw else "right_of" if "right_of" in st.kw else None
        if side:
            ref = self._obj(st.kw[side], st.line)
            ref = ref[0] if isinstance(ref, list) else ref
            g = self._num(st, "gap", T.rule_space(cut, ref.layer), T.rule_space(cut, ref.layer))
            rb = ref.bbox()
            pos = rb.x0 - g - sz // 2 if side == "left_of" else rb.x1 + g + sz // 2
            if d == "y":
                st.kw.setdefault("cx", str(pos / 1000))
            else:
                pos = rb.y0 - g - sz // 2 if side == "left_of" else rb.y1 + g + sz // 2
                st.kw.setdefault("cy", str(pos / 1000))
        if d == "y":
            cx = _s5(self._num(st, "cx", bb.cx) - sz // 2) + sz // 2
            y = lo + (span - tot) // 2
            y -= y % 5
            for i in range(n):
                rects.append(Rect(cx - sz // 2, y + i * (sz + sp), cx - sz // 2 + sz, y + i * (sz + sp) + sz))
        else:
            cy = _s5(self._num(st, "cy", bb.cy) - sz // 2) + sz // 2
            x = lo + (span - tot) // 2
            x -= x % 5
            for i in range(n):
                rects.append(Rect(x + i * (sz + sp), cy - sz // 2, x + i * (sz + sp) + sz, cy - sz // 2 + sz))
        self._new(st, cut, rects, self._net(st) or tg.net)

    def st_strap(self, st):
        check_keys(st, {"from", "to", "w", "cx", "cy", "net"}, "strap")
        if len(st.args) != 1 or "from" not in st.kw or "to" not in st.kw:
            raise ICLError("usage: <name> = strap <layer> from=<obj> to=<obj> [w=min] [cx=|cy=]", st.line)
        layer = self._layer(st.args[0], st.line)
        a = self._obj(st.kw["from"], st.line)
        b = self._obj(st.kw["to"], st.line)
        a, b = (a[0] if isinstance(a, list) else a).bbox(), (b[0] if isinstance(b, list) else b).bbox()
        w = self._num(st, "w", T.rule_width(layer), T.rule_width(layer))
        ox0, ox1 = max(a.x0, b.x0), min(a.x1, b.x1)
        oy0, oy1 = max(a.y0, b.y0), min(a.y1, b.y1)
        if "cx" in st.kw or (ox1 > ox0 and "cy" not in st.kw):
            cx = _s5(self._num(st, "cx", (ox0 + ox1) // 2 if ox1 > ox0 else (a.cx + b.cx) // 2) - w // 2) + w // 2
            r = Rect(cx - w // 2, min(a.y0, b.y0), cx - w // 2 + w, max(a.y1, b.y1))
        elif "cy" in st.kw or oy1 > oy0:
            cy = _s5(self._num(st, "cy", (oy0 + oy1) // 2) - w // 2) + w // 2
            r = Rect(min(a.x0, b.x0), cy - w // 2, max(a.x1, b.x1), cy - w // 2 + w)
        else:
            raise ICLError("strap: the two objects do not line up horizontally or vertically; give cx= or cy=",
                           st.line)
        self._new(st, layer, [r], self._net(st))

    def st_copy(self, st):
        check_keys(st, {"dx", "dy", "net"}, "copy")
        src = self._obj(st.args[0], st.line)
        src = src[0] if isinstance(src, list) else src
        dx, dy = self._num(st, "dx", 0), self._num(st, "dy", 0)
        self._new(st, src.layer, [r.moved(dx, dy) for r in src.rects], self._net(st) or src.net)

    def st_mirror(self, st):
        check_keys(st, {"axis", "net"}, "mirror")
        src = self._obj(st.args[0], st.line)
        src = src[0] if isinstance(src, list) else src
        a2 = 2 * nm(self.scope.eval(st.kw["axis"], st.line))
        self._new(st, src.layer, [Rect(a2 - r.x1, r.y0, a2 - r.x0, r.y1) for r in src.rects],
                  self._net(st) or src.net)

    def st_well(self, st):
        """well y=<um>: move the bottom edge of the template n-well (the n/p split of the cell)."""
        check_keys(st, {"y"}, "well")
        if "y" not in st.kw:
            raise ICLError("usage: well y=<um>   (bottom edge of the n-well)", st.line)
        y = nm(self.scope.eval(st.kw["y"], st.line))
        nw = self.objs["nwell"]
        r = nw.rects[0]
        if y >= r.y1:
            raise ICLError(f"well y={y/1000} um is above the top of the n-well", st.line)
        nw.rects[0] = Rect(r.x0, y, r.x1, r.y1)
        nw.line = st.line
        self.lines["nwell"] = st.line

    def st_net(self, st):
        if len(st.args) < 2:
            raise ICLError("usage: net <net> <obj> <obj> ...", st.line)
        net = ident(st.args[0], "net", st.line)
        for a in st.args[1:]:
            o = self._obj(a, st.line)
            for x in (o if isinstance(o, list) else [o]):
                x.net = net

    def st_port(self, st):
        check_keys(st, {"on", "dir"}, "port")
        if not st.args:
            raise ICLError("usage: port <net> in|out|inout|power|ground [on=<obj>]", st.line)
        net = ident(st.args[0], "port", st.line)
        d = st.args[1] if len(st.args) > 1 else st.kw.get("dir", "inout")
        on = self._obj(st.kw["on"], st.line) if "on" in st.kw else None
        if d == "power":
            self.L.power = net
            on = on or self.objs["vpwr"]
        if d == "ground":
            self.L.ground = net
            on = on or self.objs["vgnd"]
        if on is None:                     # placed after routing, on the routed metal of the net
            self.ports.append((net, d, None, st.line))
            self.L.port_order.append(net)
            return
        on = on[0] if isinstance(on, list) else on
        if on.layer not in ("li", "m1", "m2", "m3", "m4"):
            raise ICLError(f"port {net}: pins go on li or metal, '{on.name}' is {on.layer}", st.line)
        on.net = on.net or net
        if on.net != net:
            raise ICLError(f"port {net}: shape '{on.name}' already belongs to net {on.net}", st.line)
        self.ports.append((net, d, on, st.line))
        self.L.port_order.append(net)

    def st_device(self, st):
        check_keys(st, {"w", "l", "nf", "d", "g", "s", "b"}, "device")
        if len(st.args) != 2 or st.args[1] not in ("nmos", "pmos"):
            raise ICLError("usage: device <name> nmos|pmos w=<um> l=<um> [nf=] d= g= s= [b=]", st.line)
        for k in ("w", "l", "d", "g", "s"):
            if k not in st.kw:
                raise ICLError(f"device {st.args[0]}: missing {k}=", st.line)
        kind = st.args[1]
        b = st.kw.get("b", self.L.ground if kind == "nmos" else self.L.power)
        self.devices.append((st.args[0], kind, nm(self.scope.eval(st.kw["w"], st.line)),
                             nm(self.scope.eval(st.kw["l"], st.line)), int(st.kw.get("nf", "1")),
                             st.kw["d"], st.kw["g"], st.kw["s"], b))

    # ------------------------------------------------------------- finishing
    def _route(self):
        L = self.L
        rt = Router(Rect(0, 0, self.W, self.H), self.rgrid, layers=T.ROUTE_LAYERS)
        rt.max_expand = 60000          # a standard cell is small: a longer search means no path
        rt.time_budget = 45.0
        rt.reserve_pins = True                     # pin access first (dense cells)
        for s in L.shapes:
            rt.add_shape(s)
        pins = {}
        conds = [o for o in self.objs.values() if o.net and o.layer in ("li", "m1", "m2", "m3", "m4")]
        cuts = [o for o in self.objs.values() if o.layer in ("mcon", "via", "via2", "via3")]
        parent = {o.name: o.name for o in conds}

        def find(n):
            while parent[n] != n:
                parent[n] = parent[parent[n]]
                n = parent[n]
            return n

        def touch(a, b):
            return any(r.touches(q) for r in a.rects for q in b.rects)
        for i, a in enumerate(conds):
            for b in conds[i + 1:]:
                if a.net == b.net and a.layer == b.layer and touch(a, b):
                    parent[find(a.name)] = find(b.name)
        for c in cuts:
            lo, hi = next(k for k, v in T.CUTS.items() if v == c.layer)
            on = [o for o in conds if o.layer in (lo, hi) and any(r.overlaps(q) for r in o.rects for q in c.rects)]
            for a in on[1:]:
                if a.net == on[0].net:
                    parent[find(a.name)] = find(on[0].name)
        groups = {}
        for o in conds:
            groups.setdefault(find(o.name), []).append(o)
        for root, objs in groups.items():
            net = objs[0].net
            shp = [x for o in objs for x in o.shapes()]
            pins.setdefault(net, []).append(PinGroup(net, "+".join(o.name for o in objs), [], shp))
        for net, gs in pins.items():               # discourage routing over other nets' pins
            for g in gs:
                for sh in g.shapes:
                    r = sh.rect
                    for c in range(-(-(r.x0 - rt.G // 2) // rt.G), (r.x1 + rt.G // 2) // rt.G + 1):
                        for rr in range(-(-(r.y0 - rt.G // 2) // rt.G), (r.y1 + rt.G // 2) // rt.G + 1):
                            rt.penalty[(c, rr)].add(net)
        rt.best_effort = True                      # report unroutable nets, still build the rest
        self.plan.execute(rt, pins, self.scope, route_all=False,
                          err=lambda m, line, hint="": self.err(m, line, hint))
        for (n, msg, line) in getattr(rt, "failed", []):
            hint = ("give that pin room (make the li reach further from the rail / other pins), join the net with an "
                    "li strap instead, or remove a met1 pin placed right next to it") if "access point" in msg else \
                "give the router room or connect this net with li straps"
            L.warnings.append(f"ROUTING FAILED (line {line}): {msg} - net {n} is left unconnected; {hint}")
            L.info.setdefault("route_failed", []).append({"net": n, "error": msg, "line": line})
        L.routes = rt.routes
        for nr in rt.routes.values():
            L.shapes += nr.shapes
        L.route_report = self.plan.report

    def _ports(self):
        L = self.L
        if not any(p[1] == "power" for p in self.ports):
            self.ports.append((L.power, "power", self.objs["vpwr"], 0))
            L.port_order.append(L.power)
        if not any(p[1] == "ground" for p in self.ports):
            self.ports.append((L.ground, "ground", self.objs["vgnd"], 0))
            L.port_order.append(L.ground)
        for (net, d, on, line) in self.ports:
            if on is None:
                nr = (L.routes or {}).get(net)
                metal = [x for x in (nr.shapes if nr else []) if x.layer in ("m1", "m2")]
                if not metal:
                    lis = [o for o in self.objs.values() if o.net == net and o.layer == "li" and o.line]
                    if lis:
                        li = max(lis, key=lambda o: o.bbox().w * o.bbox().h).name
                        hint = (f"net {net} is a single li piece, so there was nothing to route; put the pin on it: "
                                f"`{net.lower()}m = contact mcon in={li}`, `{net.lower()}p = enclose {net.lower()}m m1 "
                                f"by=0.06 net={net}`, `port {net} out on={net.lower()}p`")
                    else:
                        hint = (f"no li shape carries net={net}: label the drain strips with net={net} and add "
                                f"`route {net} layers=m1,m2`, or give on=<met1 shape>")
                    raise ICLError(f"port {net}: no routed metal to put the pin on", line, hint)
                pad = max(metal, key=lambda x: (x.layer == "m1", min(x.rect.w, x.rect.h), x.rect.w * x.rect.h))
                L.ports.append((net, d, Shape(pad.layer, pad.rect, net, f"port:{net}")))
                continue
            r = on.rects[0]
            L.ports.append((net, d, Shape(on.layer, r, net, f"port:{net}")))
        seen = {p[0] for p in self.ports}
        for o in self.objs.values():
            if o.net and o.net not in seen and o.layer in ("li", "m1", "m2"):
                seen.add(o.net)
                r = o.rects[0]
                L.labels.append((o.net, o.layer, r.cx, r.cy))

    def _pin_access(self):
        """Can a parent router (0.46 um grid, met1/met2) land on every signal port?"""
        from .router import NetSpec
        rt = Router(Rect(0, 0, self.W, self.H), G // 2, layers=T.ROUTE_LAYERS)    # floorplan default grid
        for s in self.L.shapes:
            rt.add_shape(s)
        for (net, d, sh) in self.L.ports:
            if d in ("power", "ground"):
                continue
            sp = NetSpec(net, layers=["m1", "m2"])
            acc = [a for a in rt.access_for(net, sh, sp.layers) if rt.stack_ok(net, a, sp)]
            if not acc:
                cand = rt.access_for(net, sh, sp.layers)
                why = ""
                if cand and cand[0].stub:
                    for (l, r) in cand[0].stub[2]:
                        b = rt.blocker(net, l, r, sp)
                        if b:
                            why = f" (blocked by {b[2].owner} on {l})"
                            break
                self.L.warnings.append(f"port {net}: no legal met1/met2 access point for a parent router "
                                       f"(0.23 um grid){why}; "
                                       f"put the pin on met1 (contact mcon in=<li> + enclose ... m1 by=0.06) "
                                       f"or keep met1 clear above it")

    def _netlist(self):
        L = self.L
        lines = [f".subckt {L.name} " + " ".join(L.port_order)]
        model = {"nmos": "sky130_fd_pr__nfet_01v8", "pmos": "sky130_fd_pr__pfet_01v8"}
        for (name, kind, w, l, nf, d, g, s, b) in self.devices:
            for i in range(nf):
                a, c = (s, d) if i % 2 == 0 else (d, s)
                lines.append(f"X{name}_{i} {c} {g} {a} {b} {model[kind]} w={w/1000:g} l={l/1000:g}")
        lines.append(".ends")
        L.spice = "\n".join(lines) + "\n"
