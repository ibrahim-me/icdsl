"""Library `assembly` (+ patterns): `cell` blocks built from PCells.

Declarations
    port  <net> in|out|inout|power|ground
    nmos|pmos <name> w= l= [nf=] d= g= s= [b=]
    inst  <name> <cell> <port>=<net> ...
Patterns (one diffusion strip / matched groups)
    abut           <dev> <dev> ... [name=]                 shared diffusion, devices side by side
    interdigitate  <dev> <dev> ... pattern=ABBA [dummies=1] [name=]
    common_centroid <dev> <dev> pattern=ABBA/BAAB [dummies=1] [name=]   one strip per '/' row
Taps
    tap  <name> kind=ptap|ntap net=<net> [cols=<n>]
    guardring <name> around=[objs] kind=ptap|ntap net=<net> [space=<um>]
Placement (free mode; objects are devices, patterns, taps, instances)
    place <obj> at=(x, y) | right_of=<obj> | left_of=<obj> | above=<obj> | below=<obj>
          [gap=min|<um>] [align=origin|bottom|top|center|left|right] [flip=x|y]
    mirror <obj> of=<obj> axis=<x um>        mirror image placement (for symmetric pairs)
    move  <obj> dx=<um> dy=<um>
Row template mode (automatic rails/taps/wells)
    row <item> ... [gap=] [space=] [strap=top|bottom]
"""
from __future__ import annotations

from dataclasses import dataclass

import klayout.db as kdb

from . import tech as T
from .build import BuildScope, Inst, Layout, ObjRef, PinRef, xform_shape
from .devices import Dev, DeviceError, MosArray, build_array, implants, single, tap_bar
from .geom import Pin, Rect, Shape, rect_c
from .lib_route import RoutePlan
from .router import NetSpec, PinGroup, Router
from .syntax import ICLError, Min, check_keys, did_you_mean, ident, nm

G = T.GRID
WALL = {"diff": 180, "tap": 180, "poly": 105, "licon": 85, "li": 85, "npc": 135,
        "mcon": 95, "m1": 70, "m2": 70, "nsdm": 0, "psdm": 0, "nwell": 0}


# ------------------------------------------------------------------ compaction
def _classes(s):
    return (s.layer,) + tuple(s.kinds)


def _pair_space(table, a, b):
    best = None
    for ca in _classes(a):
        for cb in _classes(b):
            v = T.spacing(table, ca, cb)
            if v is not None and (best is None or v > best):
                best = v
    return best


FREE_SPACE = dict(T.SPACE_V)
FREE_SPACE.update({("nsdm", "nsdm"): 0, ("psdm", "psdm"): 0, ("nwell", "diff_n"): 340,
                   ("nwell", "tap_p"): 130, ("tap", "tap"): 270, ("m1", "m1"): 140,
                   ("nsdm", "diff_p"): 125, ("psdm", "diff_n"): 125, ("nsdm", "tap_p"): 125,
                   ("psdm", "tap_n"): 125})


def required_offset(fixed, moving, axis, table):
    """Smallest d such that `moving` shifted by +d along axis is legal w.r.t. `fixed`."""
    need = None
    for b in moving:
        for a in fixed:
            s = _pair_space(table, a, b)
            if s is None:
                continue
            ra, rb = a.rect, b.rect
            if axis == "x":
                og = max(rb.y0 - ra.y1, ra.y0 - rb.y1)
                d = ra.x1 + s - rb.x0
            else:
                og = max(rb.x0 - ra.x1, ra.x0 - rb.x1)
                d = ra.y1 + s - rb.y0
            if (s > 0 and og >= s) or (s == 0 and og >= 0):
                continue
            if need is None or d > need:
                need = d
    return need


def violations(A, B, table):
    """Pairs of shapes from A and B closer than their spacing rule (for placement errors)."""
    out = []
    for a in A:
        for b in B:
            s = _pair_space(table, a, b)
            if s is None:
                continue
            dx = max(b.rect.x0 - a.rect.x1, a.rect.x0 - b.rect.x1, 0)
            dy = max(b.rect.y0 - a.rect.y1, a.rect.y0 - b.rect.y1, 0)
            overl = a.rect.overlaps(b.rect)
            d = max(dx, dy)
            if (s > 0 and d < s) or (s == 0 and overl):
                out.append((a, b, d, s))
    return out


def ceil_grid(v):
    return -(-v // G) * G


# ------------------------------------------------------------------ placeable objects
@dataclass
class Obj:
    name: str
    kind: str                 # array | tap | ring | inst
    shapes: list              # local frame
    pins: list                # Pin (local)
    line: int = 0
    x: int = 0
    y: int = 0
    orient: str = "R0"
    placed: bool = False
    array: MosArray = None
    inst: Inst = None
    net: str = ""
    anchor: tuple = None      # (ref object, above|below|right_of|left_of|rigid): how it was placed
    members: tuple = ()       # rings: the objects they enclose

    def gshapes(self):
        if self.inst is not None:
            return self.inst.shapes()
        return [xform_shape(s, self.orient, self.x, self.y) for s in self.shapes]

    def gpins(self):
        if self.inst is not None:
            out = []
            for (pn, d, s) in self.inst.cell.ports:
                out.append(Pin(self.inst.map_net(pn), xform_shape(s, self.inst.orient, self.inst.x, self.inst.y,
                                                                 net=self.inst.map_net(pn)), [], f"{self.name}.{pn}"))
            return out
        return [Pin(p.net, xform_shape(p.shape, self.orient, self.x, self.y), [], p.name) for p in self.pins]

    def bbox(self):
        if self.inst is not None:
            return self.inst.bbox()
        r = None
        for s in self.gshapes():
            if s.layer in ("nwell",):
                continue
            r = s.rect if r is None else r.union(s.rect)
        return r


class AssemblyBuilder:
    def __init__(self, design, block):
        self.design, self.block = design, block
        self.L = Layout(block.name, kind="cell")
        self.scope = BuildScope()
        self.scope.names.update(getattr(design, 'params', {}))
        self.plan = RoutePlan()
        self.devs = {}
        self.objs = {}            # name -> Obj
        self.dev_obj = {}         # device -> Obj name
        self.rows = []
        self.ports = []
        self.port_sides = {}
        self.free_stmts = 0

    def err(self, msg, line=None, hint=""):
        return ICLError(f"cell {self.block.name}: {msg}", self.block.head.line if line is None else line, hint)

    # ------------------------------------------------------------- driver
    def build(self):
        hd = self.block.head
        check_keys(hd, {"height", "width"}, "cell")
        self.params = hd.kw
        self._declare_supplies()
        for st in self.block.body:
            fn = getattr(self, "st_" + st.verb, None)
            if fn is None:
                if self.plan.handles(st.verb):
                    self.plan.add(st, self.scope)
                    continue
                verbs = [m[3:] for m in dir(self) if m.startswith("st_")] + ["route", "wire", "keepout", "limit"]
                raise ICLError(f"unknown statement '{st.verb}' in a cell", st.line,
                               did_you_mean(st.verb, verbs) or "cell statements: " + ", ".join(sorted(verbs)))
            fn(st)
        if self.rows and self.free_stmts:
            raise self.err("a cell uses either 'row' statements (automatic template) or "
                           "'place'/pattern statements (free placement), not both")
        self._lint()
        if self.rows:
            from .lib_rows import RowTemplate
            RowTemplate(self).run()
        else:
            self._free_finish()
        self._netlist()
        self.L.info["routes"] = self.plan.report
        self.L.route_report = self.plan.report
        return self.L

    def _declare_supplies(self):
        pass

    # ------------------------------------------------------------- declarations
    def st_let(self, st):
        """name = <expression>: bind a value (number, point, object) for later expressions."""
        if st.target in self.scope.names:
            raise ICLError(f"'{st.target}' is already defined", st.line)
        self.scope.names[st.target] = self.scope.eval(st.args[0], st.line)

    def st_port(self, st):
        check_keys(st, {"dir", "side", "layer"})
        if not st.args:
            raise ICLError("usage: port <net> [in|out|inout|power|ground]", st.line)
        net = ident(st.args[0], "port", st.line)
        d = st.args[1] if len(st.args) > 1 else st.kw.get("dir", "inout")
        if d not in ("in", "out", "inout", "power", "ground"):
            raise ICLError(f"bad port direction '{d}'", st.line, did_you_mean(d, ["in", "out", "inout", "power", "ground"]))
        if any(p[0] == net for p in self.ports):
            raise ICLError(f"port '{net}' declared twice", st.line)
        self.ports.append((net, d, st.line))
        self.L.port_order.append(net)
        if "side" in st.kw:
            side = st.kw["side"]
            if side not in ("left", "right", "top", "bottom"):
                raise ICLError(f"port side must be left|right|top|bottom, got '{side}'", st.line)
            lay = st.kw.get("layer", "m2")
            if lay not in T.ROUTE_LAYERS:
                raise ICLError(f"port layer must be one of {T.ROUTE_LAYERS}", st.line)
            self.port_sides[net] = (side, lay, st.line)
        if d == "power":
            if self.L.power:
                raise ICLError("only one power port per cell", st.line)
            self.L.power = net
        if d == "ground":
            if self.L.ground:
                raise ICLError("only one ground port per cell", st.line)
            self.L.ground = net

    def _dev(self, st, kind):
        check_keys(st, {"w", "l", "nf", "d", "g", "s", "b"}, kind)
        if len(st.args) != 1:
            raise ICLError(f"usage: {kind} <name> w=<um> l=<um> [nf=<n>] d=<net> g=<net> s=<net>", st.line)
        name = ident(st.args[0], kind, st.line)
        for req in ("w", "l", "d", "g", "s"):
            if req not in st.kw:
                raise ICLError(f"{kind} {name}: missing '{req}='", st.line)
        if name in self.devs or name in self.objs:
            raise ICLError(f"name '{name}' already used", st.line)
        w = nm(self.scope.eval(st.kw["w"], st.line))
        l = nm(self.scope.eval(st.kw["l"], st.line))
        try:
            nf = int(self.scope.eval(st.kw.get("nf", "1"), st.line))
        except (TypeError, ValueError):
            raise ICLError(f"{name}: nf must be an integer", st.line)
        sup = self.L.ground if kind == "nmos" else self.L.power
        if not sup:
            raise ICLError(f"{name}: declare the cell's 'power' and 'ground' ports before devices", st.line)
        nets = {k: ident(st.kw[k], k, st.line) for k in ("d", "g", "s")}
        nets["b"] = ident(st.kw.get("b", sup), "b", st.line)
        if nets["b"] != sup:
            raise ICLError(f"{name}: body must be '{sup}' (got b={nets['b']})", st.line,
                           "nmos bodies are the substrate (ground taps), pmos bodies the n-well (power taps); "
                           "omit b= or set it to that net")
        self.devs[name] = Dev(name, kind, w, l, nf, nets, st.line)
        self.scope.names[name] = self._devref(name)

    def st_nmos(self, st):
        self._dev(st, "nmos")

    def st_pmos(self, st):
        self._dev(st, "pmos")

    def _devref(self, name):
        def bbox():
            o = self._obj_of(name, 0, create=False)
            return o.bbox() if o else Rect(0, 0, 0, 0)

        def pins():
            o = self._obj_of(name, 0, create=False)
            if o is None:
                return {}
            out = {}
            for t, shs in o.array.dev_pins.get(name, {}).items():
                out[t] = PinRef(f"{name}.{t}", [xform_shape(s, o.orient, o.x, o.y) for s in shs],
                                self.devs[name].nets[t])
            return out
        def org(axis):
            o = self._obj_of(name, 0, create=False)
            return 0.0 if o is None else (o.x if axis == "x" else o.y) / 1000
        return ObjRef(name, "device", bbox, pins, {"x": lambda: org("x"), "y": lambda: org("y")})

    def st_inst(self, st):
        if len(st.args) != 2:
            raise ICLError("usage: inst <name> <cell> <port>=<net> ...", st.line)
        name, cell = ident(st.args[0], "inst", st.line), st.args[1]
        if name in self.devs or name in self.objs:
            raise ICLError(f"name '{name}' already used", st.line)
        child = self.design.build(cell, st.line)
        for pin in st.kw:
            if pin not in child.port_order:
                raise ICLError(f"{name}: cell '{cell}' has no port '{pin}'", st.line,
                               did_you_mean(pin, child.port_order) or f"ports: {' '.join(child.port_order)}")
        conns = {k: ident(v, k, st.line) for k, v in st.kw.items()}
        for pn in child.port_order:
            if pn not in conns:
                bulk = child.info.get("bulk", {}).get(pn)
                if (pn == child.power or bulk == "power") and self.L.power:
                    conns[pn] = self.L.power
                elif (pn == child.ground or bulk == "ground") and self.L.ground:
                    conns[pn] = self.L.ground
                else:
                    raise ICLError(f"{name}: port '{pn}' of '{cell}' is not connected", st.line, f"add {pn}=<net>")
        ins = Inst(name, child, 0, 0, "R0", conns, st.line)
        o = Obj(name, "inst", [], [], st.line, inst=ins)
        self.objs[name] = o

        def pins():
            return {pn: PinRef(f"{name}.{pn}", ins.port_shapes(pn), conns[pn]) for pn in child.port_order}
        self.scope.names[name] = ObjRef(name, "instance", o.bbox, pins,
                                        {"x": lambda o=o: o.x / 1000, "y": lambda o=o: o.y / 1000})

    # ------------------------------------------------------------- objects
    def _obj_of(self, name, line, create=True):
        """Object holding device `name` (creates a single-device array on first use)."""
        if name in self.objs:
            return self.objs[name]
        if name in self.dev_obj:
            return self.objs[self.dev_obj[name]]
        if name in self.devs:
            if not create:
                return None
            d = self.devs[name]
            arr = single(d, "top", d.line)
            arr.dummy_gate = self.L.ground if d.kind == "nmos" else self.L.power
            return self._new_array(name, arr, line)
        raise ICLError(f"unknown object '{name}'", line, did_you_mean(name, list(self.devs) + list(self.objs)))

    def _new_array(self, oname, arr, line):
        try:
            build_array(arr)
        except DeviceError as e:
            raise ICLError(str(e), line)
        o = Obj(oname, "array", arr.shapes + implants(arr), arr.pins, line, array=arr)
        self.objs[oname] = o
        for d in arr.devs:
            self.dev_obj[d] = oname
        if oname not in self.devs:
            self.scope.names[oname] = ObjRef(oname, "pattern", o.bbox, lambda: {},
                                             {"x": lambda o=o: o.x / 1000, "y": lambda o=o: o.y / 1000})
        return o

    def _pattern(self, st, verb):
        self.free_stmts += 1
        check_keys(st, {"pattern", "dummies", "name"}, verb)
        devs = [ident(a, verb, st.line) for a in st.args]
        if len(devs) < 1:
            raise ICLError(f"usage: {verb} <dev> <dev> ... pattern=...", st.line)
        for d in devs:
            if d not in self.devs:
                raise ICLError(f"{verb}: unknown device '{d}'", st.line, did_you_mean(d, self.devs))
            if d in self.dev_obj:
                raise ICLError(f"{verb}: device '{d}' is already part of {self.dev_obj[d]}", st.line,
                               "declare patterns before placing / reusing their devices")
        ds = [self.devs[d] for d in devs]
        if len({d.kind for d in ds}) > 1 or len({d.w for d in ds}) > 1 or len({d.l for d in ds}) > 1:
            raise ICLError(f"{verb}: devices must have the same type, w and l "
                           f"(got {[(d.name, d.kind, d.w/1000, d.l/1000) for d in ds]})", st.line,
                           "w is per finger: match the unit device and use nf= for ratios")
        letters = {chr(ord("A") + i): d.name for i, d in enumerate(ds)}
        dummies = int(self.scope.eval(st.kw.get("dummies", "0"), st.line))
        if verb == "abut":
            rows = ["".join(chr(ord("A") + i) * d.nf for i, d in enumerate(ds))]
        else:
            if "pattern" not in st.kw:
                raise ICLError(f"{verb}: needs pattern=, e.g. pattern=ABBA", st.line)
            rows = st.kw["pattern"].strip("\"'").split("/")
            if verb == "interdigitate" and len(rows) != 1:
                raise ICLError("interdigitate takes a single-row pattern; use common_centroid for A.../B... rows", st.line)
            if verb == "common_centroid" and len(rows) < 2:
                raise ICLError("common_centroid needs at least two rows, e.g. pattern=ABBA/BAAB", st.line)
        # check finger counts and centroid
        for i, d in enumerate(ds):
            ch = chr(ord("A") + i)
            cnt = sum(r.count(ch) for r in rows)
            if cnt != d.nf:
                raise ICLError(f"{verb}: pattern uses {d.name} ({ch}) {cnt} times but it has nf={d.nf}", st.line,
                               "the number of letters must equal each device's nf")
        bad = set("".join(rows)) - set(letters)
        if bad:
            raise ICLError(f"{verb}: pattern letter(s) {sorted(bad)} have no device "
                           f"(letters map in order: {letters})", st.line)
        if verb == "common_centroid":
            cents = {}
            for i, d in enumerate(ds):
                ch = chr(ord("A") + i)
                pts = [(x, y) for y, r in enumerate(rows) for x, c in enumerate(r) if c == ch]
                cents[d.name] = (sum(p[0] for p in pts) / len(pts), sum(p[1] for p in pts) / len(pts))
            cs = list(cents.values())
            if any(abs(c[0] - cs[0][0]) > 1e-9 or abs(c[1] - cs[0][1]) > 1e-9 for c in cs):
                self.L.warnings.append(f"line {st.line}: pattern {st.kw['pattern']} is not common-centroid: "
                                       + ", ".join(f"{k} at ({v[0]:.2f},{v[1]:.2f})" for k, v in cents.items()))
        oname = st.kw.get("name") or "_".join(devs) + ("_cc" if verb == "common_centroid" else "_id")
        oname = ident(oname, "name", st.line)
        sup = self.L.ground if ds[0].kind == "nmos" else self.L.power
        parts = []
        for ri, r in enumerate(rows):
            fingers = ["dummy"] * dummies + [letters[c] for c in r] + ["dummy"] * dummies
            sub = {d.name: Dev(d.name, d.kind, d.w, d.l, r.count(chr(ord('A') + i)), d.nets, d.line)
                   for i, d in enumerate(ds)}
            arr = MosArray(f"{oname}_r{ri}" if len(rows) > 1 else oname, ds[0].kind, ds[0].w, ds[0].l,
                           fingers, {k: v for k, v in sub.items() if v.nf}, line=st.line, dummy_gate=sup)
            try:
                build_array(arr)
            except DeviceError as e:
                raise ICLError(str(e), st.line)
            parts.append(arr)
        if len(parts) == 1:
            o = Obj(oname, "array", parts[0].shapes + implants(parts[0]), parts[0].pins, st.line, array=parts[0])
        else:
            # stack the rows vertically (bottom row first), compacted, on the grid
            shapes, pins, merged = [], [], MosArray(oname, ds[0].kind, ds[0].w, ds[0].l, [], {}, line=st.line)
            merged.dev_pins = {d.name: {"g": [], "s": [], "d": []} for d in ds}
            y = 0
            placed = []
            for ri, arr in enumerate(parts[::-1]):
                sh = arr.shapes + implants(arr)
                if placed:
                    dmin = required_offset(placed, sh, "y", FREE_SPACE) or 0
                    y = ceil_grid(dmin)
                mv = [s.moved(0, y) for s in sh]
                placed += mv
                shapes += mv
                pins += [Pin(p.net, p.shape.moved(0, y), [(a, b + y) for a, b in p.access], p.name) for p in arr.pins]
                for d, tp in arr.dev_pins.items():
                    for t, ss in tp.items():
                        merged.dev_pins[d][t] += [s.moved(0, y) for s in ss]
                merged.fingers += arr.fingers
                merged.dummies += arr.dummies
            merged.devs = {d.name: d for d in ds}
            merged.parts = parts
            o = Obj(oname, "array", shapes, pins, st.line, array=merged)
        self.objs[oname] = o
        for d in devs:
            self.dev_obj[d] = oname
        o.array.devs = {d.name: d for d in ds}
        o.array.pattern = rows
        self.scope.names[oname] = ObjRef(oname, "pattern", o.bbox, lambda: {},
                                         {"x": lambda o=o: o.x / 1000, "y": lambda o=o: o.y / 1000})
        return o

    def st_abut(self, st):
        self._pattern(st, "abut")

    def st_interdigitate(self, st):
        self._pattern(st, "interdigitate")

    def st_common_centroid(self, st):
        self._pattern(st, "common_centroid")

    def st_tap(self, st):
        self.free_stmts += 1
        check_keys(st, {"kind", "net", "cols"}, "tap")
        if len(st.args) != 1 or "kind" not in st.kw or "net" not in st.kw:
            raise ICLError("usage: tap <name> kind=ptap|ntap net=<net> [cols=<n>]", st.line)
        name = ident(st.args[0], "tap", st.line)
        kind = st.kw["kind"]
        if kind not in ("ptap", "ntap"):
            raise ICLError(f"tap kind must be ptap or ntap, got '{kind}'", st.line)
        cols = int(self.scope.eval(st.kw.get("cols", "2"), st.line))
        net = ident(st.kw["net"], "net", st.line)
        sh = tap_bar(kind, net, 0, (cols - 1) * G, 0, name)
        m1 = [s for s in sh if s.layer == "m1"]
        o = Obj(name, "tap", sh, [Pin(net, m1[0], [], f"{name}")], st.line, net=net)
        self.objs[name] = o
        self.scope.names[name] = ObjRef(name, "tap", o.bbox, lambda o=o: {"net": PinRef(o.name, [s for s in o.gshapes() if s.layer == "m1"], o.net)})

    def st_guardring(self, st):
        self.free_stmts += 1
        check_keys(st, {"around", "kind", "net", "space"}, "guardring")
        if len(st.args) != 1 or "around" not in st.kw or "kind" not in st.kw or "net" not in st.kw:
            raise ICLError("usage: guardring <name> around=[obj, ...] kind=ptap|ntap net=<net> [space=<um>]", st.line)
        name = ident(st.args[0], "guardring", st.line)
        kind = st.kw["kind"]
        net = ident(st.kw["net"], "net", st.line)
        targets = self.scope.eval(st.kw["around"], st.line)
        if not isinstance(targets, list):
            targets = [targets]
        def build():
            inner = []
            for t in targets:
                o = self._obj_of(t.name, st.line, create=False) if hasattr(t, "name") else None
                if o is None or not o.placed:
                    raise ICLError(f"guardring: '{getattr(t, 'name', t)}' is not placed yet", st.line,
                                   "place the enclosed objects before the guard ring")
                inner += o.gshapes()
            bb = None
            for s in inner:
                if s.layer != "nwell":
                    bb = s.rect if bb is None else bb.union(s.rect)
            ring_probe = tap_bar(kind, net, 0, 0, 0, name)
            extra = nm(self.scope.eval(st.kw["space"], st.line)) if "space" in st.kw else 0
            # margin so a bar centred on the ring line clears all contents
            half = max(max(abs(s.rect.x0), abs(s.rect.x1), abs(s.rect.y0), abs(s.rect.y1)) for s in ring_probe
                       if s.layer not in ("nwell",))
            need = 0
            for s in inner:
                for r in ring_probe:
                    sp = _pair_space(FREE_SPACE, s, r)
                    if sp is not None:
                        need = max(need, sp)
            m = need + half + extra
            x0 = (bb.x0 - m) // G * G
            y0 = (bb.y0 - m) // G * G
            x1 = ceil_grid(bb.x1 + m)
            y1 = ceil_grid(bb.y1 + m)
            sh = tap_bar(kind, net, x0, x1, y0, name) + tap_bar(kind, net, x0, x1, y1, name)
            hb = {}
            for s in sh:                                             # horizontal bars' extent per layer
                hb[s.layer] = s.rect if s.layer not in hb else hb[s.layer].union(s.rect)
            side_l = tap_bar(kind, net, y0, y1, 0, name)          # full height: overlaps the corners
            for s in side_l:
                r = s.rect
                if s.layer in ("licon", "mcon") and (r.x0 + r.x1) // 2 in (y0, y1):
                    continue                                         # corner cuts already exist
                if s.layer == "nwell":
                    continue
                lo, hi = r.x0, r.x1                                  # becomes the y-extent after transposing
                if s.layer in hb:                                    # don't stick out past the corners
                    lo, hi = max(lo, hb[s.layer].y0), min(hi, hb[s.layer].y1)
                sh.append(Shape(s.layer, Rect(x0 + r.y0, lo, x0 + r.y1, hi), s.net, name, s.kinds))
                sh.append(Shape(s.layer, Rect(x1 + r.y0, lo, x1 + r.y1, hi), s.net, name, s.kinds))
            if kind == "ntap":
                sh = [s for s in sh if s.layer != "nwell"]
                tb = None
                for s in sh:
                    if s.layer == "tap":
                        tb = s.rect if tb is None else tb.union(s.rect)
                sh.append(Shape("nwell", tb.bloat(T.R["nwell.enc_ntap"]), net, name))
            return sh, half, need

        tnames = {getattr(t, "name", None) for t in targets}
        inside = {oo.name for oo in self.objs.values() if oo.placed and
                  (oo.name in tnames or any(d in tnames for d in getattr(oo.array, "devs", {}) or {}))}
        moves = []
        for _ in range(80):
            sh, half, need = build()
            conflict = None
            for oo in self.objs.values():
                if not oo.placed:
                    continue
                bad = violations(oo.gshapes(), sh, FREE_SPACE)
                if oo.name in inside:
                    bad = [v for v in bad if v[0].layer != "nwell" and v[1].layer != "nwell"]
                if bad:
                    conflict = (oo, bad[0])
                    break
            if conflict is None:
                break
            oo, (a, b, d, sp) = conflict
            plan = self._make_room(oo, inside)
            if plan is None or len(moves) > 60:
                need_more = max(0, sp - d) / 1000
                raise ICLError(f"guardring {name} does not fit: its {b.layer} comes {d/1000:.3f} um from "
                               f"{oo.name} ({a.layer}), rule needs {sp/1000:.3f} um", st.line,
                               f"the ring needs about {(2 * half + need) / 1000:.2f} um of free space around the "
                               f"enclosed objects; {oo.name} is not placed relative to them, so it cannot be moved "
                               f"automatically - place {oo.name} with above=/below=/right_of=/left_of= one of "
                               f"{', '.join(sorted(inside))} (the ring then pushes it away), or leave "
                               f"{(2 * half + need) / 1000 + need_more:.2f} um more space")
            root, dirn = plan
            step = max(G, ceil_grid(sp - d))
            self._shift_subtree(root, dirn, step)
            moves.append((root, dirn, step))
        if moves:
            tot = {}
            for (r, dn, stp) in moves:
                tot[(r, dn)] = tot.get((r, dn), 0) + stp
            self.L.warnings.append(f"guardring {name}: made room by moving " + ", ".join(
                f"{r} (and what is placed relative to it) {dn.replace('_of', '')} by {v/1000:.2f} um"
                for (r, dn), v in tot.items()))
        m1 = [s for s in sh if s.layer == "m1"]
        o = Obj(name, "ring", sh, [Pin(net, s, [], name) for s in m1], st.line, placed=True, net=net)
        o.members = tuple(sorted(inside))
        self.objs[name] = o
        self.scope.names[name] = ObjRef(name, "guardring", o.bbox, lambda o=o: {"net": PinRef(o.name, [s for s in o.gshapes() if s.layer == "m1"], o.net)})

    # ------------------------------------------------------------- placement
    def _target(self, expr, line):
        v = self.scope.eval(expr, line)
        if not hasattr(v, "name"):
            raise ICLError(f"expected an object, got {v!r}", line)
        return self._obj_of(v.name, line)

    def _placed_shapes(self, exclude=None):
        out = []
        for o in self.objs.values():
            if o.placed and o is not exclude:
                out += o.gshapes()
        return out

    # ------------------------------------------------------------- making room (guard rings)
    def _make_room(self, blocker, inside):
        """Which placed subtree to push so a ring around `inside` clears `blocker`: (root, direction)."""
        blockers = {blocker.name} | set(getattr(blocker, "members", ()) or ())

        def walk(o, targets):
            seen = set()
            child = o
            while child.anchor and child.name not in seen:
                seen.add(child.name)
                parent, dirn = child.anchor
                if parent in targets and dirn != "rigid":
                    return child.name, dirn
                child = self.objs[parent]
            return None
        for bname in blockers:                 # the blocker hangs off the ring's contents: push it away
            r = walk(self.objs[bname], inside)
            if r and r[0] not in inside:
                return r
        for m in inside:                       # the contents hang off the blocker: push them away
            r = walk(self.objs[m], blockers)
            if r:
                return r
        for m in inside:                       # siblings: push the contents further along their own placement
            c, seen = self.objs[m], set()
            while c.anchor and c.name not in seen:
                seen.add(c.name)
                parent, dirn = c.anchor
                if parent not in inside:
                    if dirn != "rigid" and not (self._subtree(c.name) & blockers):
                        return c.name, dirn
                    break
                c = self.objs[parent]
        return None

    def _subtree(self, root):
        out = set()
        for o in self.objs.values():
            seen, c = set(), o
            while c is not None and c.name not in seen:
                seen.add(c.name)
                if c.name == root:
                    out.add(o.name)
                    break
                c = self.objs.get(c.anchor[0]) if c.anchor else None
        for o in self.objs.values():           # rings whose contents all move go along
            if o.kind == "ring" and o.members and set(o.members) <= out:
                out.add(o.name)
        return out

    def _shift_subtree(self, root, dirn, step):
        dx, dy = {"above": (0, 1), "below": (0, -1), "right_of": (1, 0), "left_of": (-1, 0)}[dirn]
        names = self._subtree(root)
        for _ in range(60):
            for n in names:
                o = self.objs[n]
                self._set_pos(o, o.x + dx * step, o.y + dy * step)
            moving = [s for n in names for s in self.objs[n].gshapes()]
            rest = [s for o in self.objs.values() if o.placed and o.name not in names for s in o.gshapes()]
            if not violations(rest, moving, FREE_SPACE):
                return
            step = G

    def st_place(self, st):
        self.free_stmts += 1
        check_keys(st, {"at", "right_of", "left_of", "above", "below", "gap", "align", "flip"}, "place")
        if len(st.args) != 1:
            raise ICLError("usage: place <obj> at=(x,y) | right_of=<obj> | above=<obj> ... [gap=] [align=]", st.line)
        o = self._obj_of(ident(st.args[0], "place", st.line), st.line)
        if o.placed:
            raise ICLError(f"'{o.name}' is already placed (line {o.line})", st.line, "use 'move' to adjust it")
        if "flip" in st.kw:
            f = st.kw["flip"]
            if f not in ("x", "y"):
                raise ICLError("flip must be x (mirror left-right) or y (mirror up-down)", st.line)
            o.orient = "MY" if f == "x" else "MX"
            if o.inst is not None:
                o.inst.orient = o.orient
        rel = [k for k in ("at", "right_of", "left_of", "above", "below") if k in st.kw]
        if len(rel) != 1:
            raise ICLError("place needs exactly one of at= / right_of= / left_of= / above= / below=", st.line)
        k = rel[0]
        if k == "at":
            p = self.scope.eval(st.kw["at"], st.line)
            if hasattr(p, "icl_xy"):
                p = p.icl_xy()
            self._set_pos(o, round(p[0] * 1000 / G) * G, round(p[1] * 1000 / G) * G)
        else:
            ref = self._target(st.kw[k], st.line)
            if not ref.placed:
                raise ICLError(f"'{ref.name}' must be placed before '{o.name}' can be placed relative to it", st.line)
            align = st.kw.get("align", "origin")
            gap = self.scope.eval(st.kw.get("gap", "min"), st.line)
            self._place_rel(o, ref, k, gap, align, st.line)
            o.anchor = (ref.name, k)
        o.placed = True
        self._check_clear(o, st.line)

    def _set_pos(self, o, x, y):
        o.x, o.y = x, y
        if o.inst is not None:
            o.inst.x, o.inst.y = x, y

    def _local_bbox(self, o):
        self._set_pos(o, 0, 0)
        return o.bbox()

    def _place_rel(self, o, ref, k, gap, align, line):
        if o.inst is not None or ref.inst is not None:
            from .lib_floorplan import place_block
            return place_block(self, o, ref, k, gap, align, line)
        horiz = k in ("right_of", "left_of")
        rb = ref.bbox()
        lb = self._local_bbox(o)
        # cross-axis alignment
        if horiz:
            amap = {"origin": ref.y, "bottom": rb.y0 - lb.y0, "top": rb.y1 - lb.y1, "center": rb.cy - lb.cy}
            if align not in amap:
                raise ICLError(f"align for right_of/left_of: {', '.join(amap)}", line)
            cy = amap[align]
            cy = round(cy / G) * G
            self._set_pos(o, 0, cy)
        else:
            amap = {"origin": ref.x, "left": rb.x0 - lb.x0, "right": rb.x1 - lb.x1, "center": rb.cx - lb.cx}
            if align not in amap:
                raise ICLError(f"align for above/below: {', '.join(amap)}", line)
            cx = round(amap[align] / G) * G
            self._set_pos(o, cx, 0)
        mine = o.gshapes()
        others = ref.gshapes()
        sgn = 1 if k in ("right_of", "above") else -1
        axis = "x" if horiz else "y"
        if sgn > 0:
            d = required_offset(others, mine, axis, FREE_SPACE)
        else:
            # mirror the problem: moving towards -axis
            fl = [Shape(s.layer, _neg(s.rect, axis), s.net, s.owner, s.kinds) for s in others]
            ml = [Shape(s.layer, _neg(s.rect, axis), s.net, s.owner, s.kinds) for s in mine]
            d = required_offset(fl, ml, axis, FREE_SPACE)
        mb = o.bbox()
        if sgn > 0:
            touch = (rb.x1 - mb.x0) if horiz else (rb.y1 - mb.y0)
        else:
            touch = (mb.x1 - rb.x0) if horiz else (mb.y1 - rb.y0)
        dmin = d if d is not None else touch
        if isinstance(gap, Min):
            dd = dmin + nm(gap.off)
        else:
            want = touch + nm(gap)
            if want < dmin:
                raise ICLError(f"gap={gap} um between {o.name} and {ref.name} is below the legal minimum "
                               f"{(dmin - touch)/1000:.3f} um (set by the spacing rules of their layers)", line,
                               "use gap=min, or a larger gap")
            dd = want
        dd = ceil_grid(dd) if dd >= 0 else -((-dd) // G) * G
        if horiz:
            self._set_pos(o, sgn * dd, o.y)
        else:
            self._set_pos(o, o.x, sgn * dd)
        # also clear everything else that is already placed: push further if needed
        for _ in range(50):
            bad = violations(self._placed_shapes(exclude=o), o.gshapes(), FREE_SPACE)
            if not bad:
                break
            if horiz:
                self._set_pos(o, o.x + sgn * G, o.y)
            else:
                self._set_pos(o, o.x, o.y + sgn * G)

    def _check_clear(self, o, line):
        if o.inst is not None or any(x.inst is not None for x in self.objs.values() if x.placed and x is not o):
            from .lib_floorplan import block_violations
            bad = block_violations(self._placed_shapes(exclude=o), o.gshapes(), limit=1)
        else:
            bad = violations(self._placed_shapes(exclude=o), o.gshapes(), FREE_SPACE)
        if bad:
            a, b, d, s = bad[0]
            raise ICLError(f"'{o.name}' overlaps/violates spacing with {a.owner}: {a.layer} vs {b.layer} "
                           f"{d/1000:.3f} um < {s/1000:.3f} um", line,
                           "use right_of=/above= (rule-aware), or move it")

    def st_mirror(self, st):
        self.free_stmts += 1
        check_keys(st, {"of", "axis"}, "mirror")
        if len(st.args) != 1 or "of" not in st.kw or "axis" not in st.kw:
            raise ICLError("usage: mirror <obj> of=<placed obj> axis=<x um>", st.line)
        o = self._obj_of(ident(st.args[0], "mirror", st.line), st.line)
        ref = self._target(st.kw["of"], st.line)
        if not ref.placed:
            raise ICLError(f"'{ref.name}' must be placed first", st.line)
        ax2 = 2 * nm(self.scope.eval(st.kw["axis"], st.line))
        if ax2 % G:
            raise ICLError(f"mirror axis {ax2/2000:.3f} um must lie on the 0.23 um half-grid", st.line,
                           "anchor it on an object origin (always on grid), e.g. axis=(MPA.x + 1.38), "
                           "or use a multiple of 0.23")
        o.orient = {"R0": "MY", "MY": "R0", "MX": "R180", "R180": "MX"}[ref.orient]
        if o.inst is not None:
            o.inst.orient = o.orient
        self._set_pos(o, ax2 - ref.x, ref.y)
        o.placed = True
        o.mirror_of = (ref.name, ax2)
        o.anchor = (ref.name, "rigid")
        self._check_clear(o, st.line)

    def st_pair(self, st):
        """pair <A> <B> axis=<x> [above=<obj>|below=<obj>|at_y=<y>] [gap=min|<um>] [vgap=<um>]
        A goes left of the axis, B is its mirror image; the gap across the axis is the legal minimum."""
        self.free_stmts += 1
        check_keys(st, {"axis", "above", "below", "at_y", "gap", "vgap"}, "pair")
        if len(st.args) != 2 or "axis" not in st.kw:
            raise ICLError("usage: pair <A> <B> axis=<x um> [above=<obj>|below=<obj>|at_y=<um>] [gap=min]", st.line)
        a = self._obj_of(ident(st.args[0], "pair", st.line), st.line)
        b = self._obj_of(ident(st.args[1], "pair", st.line), st.line)
        ax = self.scope.eval(st.kw["axis"], st.line)
        ax2 = 2 * nm(ax)
        if ax2 % G:
            raise ICLError(f"pair axis {ax} um must lie on the 0.23 um half-grid", st.line,
                           "use the centre of an existing object (e.g. axis=MT.cx) or a multiple of 0.23")
        if b.placed:
            raise ICLError(f"pair: '{b.name}' is already placed - the second object is placed as the mirror image "
                           f"of the first", st.line)
        if a.placed:                       # A placed already: B becomes its mirror image about the axis
            if set(st.kw) - {"axis"}:
                raise ICLError(f"pair: '{a.name}' is already placed, so only axis= applies", st.line,
                               f"either leave {a.name} unplaced and let pair place both, or drop the other keys")
            b.orient = {"R0": "MY", "MY": "R0", "MX": "R180", "R180": "MX"}[a.orient]
            if b.inst is not None:
                b.inst.orient = b.orient
            self._set_pos(b, ax2 - a.x, a.y)
            if violations(a.gshapes(), b.gshapes(), FREE_SPACE) or a.bbox().x1 > ax2 // 2:
                raise ICLError(f"pair: '{a.name}' reaches across the axis x={ax2/2000:.3f} um, so its mirror "
                               f"image would overlap it", st.line,
                               f"place {a.name} further left of the axis, or leave it unplaced and let pair "
                               "find the closest legal spacing")
            b.placed = True
            b.mirror_of = (a.name, ax2)
            b.anchor = (a.name, "rigid")
            self._check_clear(b, st.line)
            return
        gap = self.scope.eval(st.kw.get("gap", "min"), st.line)
        extra = 0 if isinstance(gap, Min) else nm(gap)
        b.orient = "MY" if a.orient == "R0" else "R0"
        if b.inst is not None:
            b.inst.orient = b.orient
        # horizontal: slide A left until A and mirror(A) are legal (+ extra)
        lb = self._local_bbox(a)
        x = (ax2 // 2 - lb.x1) // G * G
        for _ in range(400):
            self._set_pos(a, x, 0)
            self._set_pos(b, ax2 - x, 0)
            bb_a, bb_b = a.bbox(), b.bbox()
            if not violations(a.gshapes(), b.gshapes(), FREE_SPACE) and bb_b.x0 - bb_a.x1 >= extra:
                break
            x -= G
        # vertical
        y = 0
        rel = [k for k in ("above", "below", "at_y") if k in st.kw]
        if len(rel) > 1:
            raise ICLError("pair: give at most one of above= / below= / at_y=", st.line)
        if rel and rel[0] == "at_y":
            y = round(nm(self.scope.eval(st.kw["at_y"], st.line)) / G) * G
        elif rel:
            ref = self._target(st.kw[rel[0]], st.line)
            both = a.gshapes() + b.gshapes()
            fixed = ref.gshapes()
            if rel[0] == "above":
                d = required_offset(fixed, both, "y", FREE_SPACE)
                y = ceil_grid(d if d is not None else ref.bbox().y1 - min(s.rect.y0 for s in both))
            else:
                fl = [Shape(s.layer, _neg(s.rect, "y"), s.net, s.owner, s.kinds) for s in fixed]
                ml = [Shape(s.layer, _neg(s.rect, "y"), s.net, s.owner, s.kinds) for s in both]
                d = required_offset(fl, ml, "y", FREE_SPACE)
                y = -ceil_grid(d if d is not None else max(s.rect.y1 for s in both) - ref.bbox().y0)
        sgn = -1 if rel and rel[0] == "below" else 1
        if "vgap" in st.kw and rel and rel[0] != "at_y":
            y += sgn * ceil_grid(nm(self.scope.eval(st.kw["vgap"], st.line)))
        for _ in range(200):
            self._set_pos(a, x, y)
            self._set_pos(b, ax2 - x, y)
            others = self._placed_shapes(exclude=None)
            if not violations(others, a.gshapes() + b.gshapes(), FREE_SPACE):
                break
            y += sgn * G
        a.placed = b.placed = True
        b.mirror_of = (a.name, ax2)
        b.anchor = (a.name, "rigid")
        if rel and rel[0] in ("above", "below"):
            a.anchor = (self._target(st.kw[rel[0]], st.line).name, rel[0])

    def st_move(self, st):
        self.free_stmts += 1
        check_keys(st, {"dx", "dy"}, "move")
        o = self._obj_of(ident(st.args[0], "move", st.line), st.line)
        if not o.placed:
            raise ICLError(f"'{o.name}' is not placed yet", st.line)
        dx = round(nm(self.scope.eval(st.kw.get("dx", "0"), st.line)) / G) * G
        dy = round(nm(self.scope.eval(st.kw.get("dy", "0"), st.line)) / G) * G
        self._set_pos(o, o.x + dx, o.y + dy)
        self._check_clear(o, st.line)

    def st_row(self, st):
        check_keys(st, {"gap", "space", "strap"}, "row")
        self.rows.append(st)

    # ------------------------------------------------------------- lint
    def _lint(self):
        L = self.L
        uses = {}
        for d in self.devs.values():
            for t in ("d", "g", "s"):
                uses.setdefault(d.nets[t], []).append(f"{d.name}.{t}")
        for o in self.objs.values():
            if o.inst is not None:
                for pn, net in o.inst.conns.items():
                    uses.setdefault(net, []).append(f"{o.name}.{pn}")
        ports = {p[0] for p in self.ports}
        for net, us in sorted(uses.items()):
            if len(us) == 1 and net not in ports and net not in (L.power, L.ground):
                hint = did_you_mean(net, [n for n in list(uses) + list(ports) if n != net])
                L.warnings.append(f"net '{net}' has a single connection ({us[0]}) - dangling" + (f"; {hint}" if hint else ""))
        for d in self.devs.values():
            if d.nets["d"] == d.nets["s"]:
                L.warnings.append(f"{d.name}: drain and source are both '{d.nets['d']}'")
        for (p, dr, line) in self.ports:
            if dr not in ("power", "ground") and p not in uses:
                raise ICLError(f"port '{p}' is not connected to any device", line, did_you_mean(p, uses))

    # ------------------------------------------------------------- free mode
    def _free_finish(self):
        L = self.L
        has_p = any(d.kind == "pmos" for d in self.devs.values())
        has_n = any(d.kind == "nmos" for d in self.devs.values())
        if (has_p and not L.power) or (has_n and not L.ground) or not (L.power or L.ground):
            need = [x for x, h, v in (("'power'", has_p, L.power), ("'ground'", has_n, L.ground)) if h and not v]
            raise self.err(f"needs a {' and a '.join(need) or 'power or ground'} port")
        for d in self.devs:
            if d not in self.dev_obj:
                raise self.err(f"device '{d}' is not placed", self.devs[d].line,
                               f"add e.g. 'place {d} right_of=<obj>' or 'place {d} at=(0,0)'")
        for o in self.objs.values():
            if not o.placed:
                raise self.err(f"'{o.name}' is declared but never placed", o.line)
        shapes = []
        for o in self.objs.values():
            if o.inst is None:
                shapes += o.gshapes()
            else:
                L.insts.append(o.inst)
        self._wells(shapes)
        L.shapes += shapes
        # bounding box / grid region
        allsh = L.all_shapes(True)
        bb = None
        for s in allsh:
            bb = s.rect if bb is None else bb.union(s.rect)
        x0, y0 = (bb.x0 // G - 1) * G, (bb.y0 // G - 1) * G
        x1, y1 = ceil_grid(bb.x1) + G, ceil_grid(bb.y1) + G
        size = getattr(self, "size", None)
        if size:
            if bb.x0 < 0 or bb.y0 < 0 or bb.x1 > size[0] or bb.y1 > size[1]:
                raise self.err(f"content {bb} does not fit in the {size[0]/1000} x {size[1]/1000} um area",
                               None, "enlarge width=/height= or move blocks")
            x0, y0, x1, y1 = 0, 0, size[0], size[1]
        # shift everything so the cell origin is (0, 0)
        for s in L.shapes:
            s.rect = s.rect.moved(-x0, -y0)
        for ins in L.insts:
            ins.x -= x0
            ins.y -= y0
        for o in self.objs.values():
            self._set_pos(o, o.x - x0, o.y - y0)
        L.width, L.height = x1 - x0, y1 - y0
        self._route_free()
        self._ports_and_labels()
        L.shapes.append(Shape("boundary", Rect(0, 0, L.width, L.height), None, "boundary"))
        L.info["objects"] = {o.name: {"kind": o.kind, "at_um": [o.x / 1000, o.y / 1000], "orient": o.orient,
                                      "bbox_um": list(o.bbox().um()), "line": getattr(o, "line", 0)}
                             for o in self.objs.values()}

    def _wells(self, shapes):
        """Merge implants / n-wells, check body ties."""
        L = self.L
        # n-wells closer than 2.8 um are bridged (one well, one tap) unless n-devices sit in between
        for lay, close in (("nwell", max(T.R["nwell.space"], 2800)), ("nsdm", T.R["sdm.space"]),
                           ("psdm", T.R["sdm.space"])):
            mine = [s for s in shapes if s.layer == lay]
            if not mine:
                continue
            reg = kdb.Region()
            for s in mine:
                reg.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
            reg.merge()
            closed = reg.sized(close // 2).sized(-(close // 2))
            # never let closing creep over things the layer must not touch
            other = "psdm" if lay == "nsdm" else "nsdm" if lay == "psdm" else None
            forb = kdb.Region()
            if lay == "nwell":
                for s in shapes:
                    if "diff_n" in s.kinds or "tap_p" in s.kinds:
                        forb.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
                forb = forb.sized(T.R["nwell.space_ndiff"])
            elif other:
                for s in shapes:
                    if s.layer == other:
                        forb.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
            additions = closed - reg
            bad_add = additions.interacting(forb)
            if not bad_add.is_empty():
                closed = reg + additions.not_interacting(forb)
                closed.merge()
                gap_bb = bad_add.bbox()
                L.warnings.append(f"{lay}: regions closer than {close/1000:.2f} um could not be merged near "
                                  f"({gap_bb.center().x/1000:.2f},{gap_bb.center().y/1000:.2f}) um because of other "
                                  f"devices in between - expect a {lay} spacing DRC; move those objects apart")
            # repair necks narrower than the minimum width (grow them, never into forbidden areas)
            minw = T.WIDTH[lay]
            for _ in range(3):
                bad = closed.width_check(minw)
                if bad.is_empty():
                    break
                grow = kdb.Region()
                for ep in bad.each():
                    bb = ep.bbox()
                    if bb.width() < minw:
                        d = (minw - bb.width() + 9) // 10 * 5
                        bb = kdb.Box(bb.left - d, bb.bottom, bb.right + d, bb.top)
                    if bb.height() < minw:
                        d = (minw - bb.height() + 9) // 10 * 5
                        bb = kdb.Box(bb.left, bb.bottom - d, bb.right, bb.top + d)
                    grow.insert(bb)
                grow -= forb
                if grow.is_empty():
                    break
                closed = (closed + grow).merged()
            if not closed.width_check(minw).is_empty():
                b0 = closed.width_check(minw).bbox()
                L.warnings.append(f"{lay}: a region narrower than {minw/1000:.2f} um remains near "
                                  f"({b0.center().x/1000:.2f},{b0.center().y/1000:.2f}) um; move the objects there "
                                  f"together or further apart")
            shapes[:] = [s for s in shapes if s.layer != lay]
            for poly in closed.each():
                for tr in poly.decompose_trapezoids(0):
                    b = tr.bbox()
                    shapes.append(Shape(lay, Rect(b.left, b.bottom, b.right, b.top), None, "well" if lay == "nwell" else "implant"))
        # body ties (on merged well regions)
        def region(pred):
            r = kdb.Region()
            for x in shapes:
                if pred(x):
                    r.insert(kdb.Box(x.rect.x0, x.rect.y0, x.rect.x1, x.rect.y1))
            return r
        taps_p = [x for x in shapes if "tap_p" in x.kinds]
        if any(d.kind == "nmos" for d in self.devs.values()) and not taps_p:
            raise self.err("no substrate tap: nmos bodies would float", None,
                           f"add 'tap TP kind=ptap net={L.ground}' (and place it), or a ptap guardring")
        wells = region(lambda x: x.layer == "nwell")
        wells.merge()
        for o in self.objs.values():
            if o.array is None or o.array.kind != "pmos":
                continue
            pd = kdb.Region()
            for x in o.gshapes():
                if x.layer == "diff":
                    pd.insert(kdb.Box(x.rect.x0, x.rect.y0, x.rect.x1, x.rect.y1))
            taps = []
            for wp in wells.interacting(pd).each():          # every well island of this object needs a tap
                one = kdb.Region(wp)
                here = [t for t in shapes if "tap_n" in t.kinds and
                        not one.interacting(kdb.Region(kdb.Box(t.rect.x0, t.rect.y0, t.rect.x1, t.rect.y1))).is_empty()]
                if not here:
                    b = wp.bbox()
                    raise self.err(f"the n-well of '{o.name}' at ({b.left/1000:.2f}..{b.right/1000:.2f}, "
                                   f"{b.bottom/1000:.2f}..{b.top/1000:.2f}) um has no n-tap", o.line,
                                   f"add 'tap TN kind=ntap net={L.power}' placed next to it (gap=min keeps it in the "
                                   "same well), or an ntap guardring around the pmos devices")
                taps += here
            if any(t.net != L.power for t in taps):
                raise self.err(f"the n-well of '{o.name}' is tapped to {taps[0].net}, but pmos bodies are "
                               f"{L.power}", o.line)
        self._latchup(shapes)

    def _latchup(self, shapes):
        """sky130 LU.2/LU.3: every n-diffusion within 15 um of a p-tap, every p-diffusion within 15 um of an
        n-tap. Too far is an error naming the device; close to the limit is a warning (it breaks first when
        the devices grow, e.g. at a larger W in a sweep)."""
        lim, warn = 15000, 11000
        ntaps = [x.rect for x in shapes if "tap_n" in x.kinds]
        ptaps = [x.rect for x in shapes if "tap_p" in x.kinds]
        worst = {}
        for x in shapes:
            if x.layer != "diff":
                continue
            taps = ptaps if "diff_n" in x.kinds else ntaps if "diff_p" in x.kinds else None
            if not taps:
                continue
            r = x.rect
            # farthest point of the diffusion from its nearest tap (corners suffice for rectangles)
            far = 0
            for (px, py) in ((r.x0, r.y0), (r.x0, r.y1), (r.x1, r.y0), (r.x1, r.y1)):
                d = min(max(t.x0 - px, px - t.x1, 0) ** 2 + max(t.y0 - py, py - t.y1, 0) ** 2 for t in taps) ** 0.5
                far = max(far, d)
            if far > worst.get(x.owner, (0,))[0]:
                worst[x.owner] = (far, "p-tap" if "diff_n" in x.kinds else "n-tap")
        for owner, (d, kind) in sorted(worst.items(), key=lambda kv: -kv[1][0]):
            if d > lim:
                raise self.err(f"'{owner}' has diffusion {d/1000:.1f} um from the nearest {kind} (latch-up rule "
                               f"needs < 15 um)", None, f"add a {kind} next to {owner} (a tap row placed beside it, or a "
                               "guard ring)")
            if d > warn:
                self.L.warnings.append(f"latch-up margin: '{owner}' reaches {d/1000:.1f} um from the nearest {kind} "
                                       f"(limit 15 um) - it will fail when the devices grow (larger W in a sweep); "
                                       f"add a {kind} closer to it")
                break

    def _route_free(self):
        L = self.L
        region = Rect(0, 0, L.width, L.height)
        rg = getattr(self, "route_grid", G)
        rt = Router(region, rg, layers=T.ROUTE_LAYERS)
        for s in L.all_shapes(True):
            rt.add_shape(s)
        pins = self._pin_groups(rt)
        from .router import Access
        nc, nr = L.width // rg, L.height // rg
        for net, (side, lay, line) in self.port_sides.items():
            if side in ("left", "right"):
                c = 1 if side == "left" else nc - 1
                acc = [Access(c, r, lay, (), lay) for r in range(1, nr)]
            else:
                r = 1 if side == "bottom" else nr - 1
                acc = [Access(c, r, lay, (), lay) for c in range(1, nc)]
            pins.setdefault(net, []).append(PinGroup(net, f"port:{net}@{side}", acc, []))
        self.plan.execute(rt, pins, self.scope, supplies={}, default_layers=("m1", "m2"),
                          err=lambda m, line, hint="": self.err(m, line, hint))
        self.router = rt
        L.routes = rt.routes
        for nr in rt.routes.values():
            L.shapes += nr.shapes
        for o in self.objs.values():
            for p in o.gpins():
                pass

    def _pin_groups(self, rt):
        pins = {}
        for o in self.objs.values():
            for p in o.gpins():
                if p.net is None:
                    continue
                pins.setdefault(p.net, []).append(PinGroup(p.net, p.name, [], [p.shape]))
        # pins already connected by the same shape are one group; merge groups that share geometry
        for net, gs in pins.items():
            merged = []
            for g in gs:
                for m in merged:
                    if any(a.layer == b.layer and a.rect.touches(b.rect) for a in g.shapes for b in m.shapes):
                        m.shapes += g.shapes
                        m.name += "+" + g.name
                        break
                else:
                    merged.append(g)
            pins[net] = merged
        for net, gs in pins.items():
            for g in gs:
                g.access = []
                for s in g.shapes:
                    g.access += rt.access_for(net, s, T.ROUTE_LAYERS)
                    if s.layer in ("li", "m1"):
                        # discourage other nets from running over this pin (incl. off-grid landings)
                        r = s.rect
                        for c in range(-(-(r.x0 - rt.G // 2) // rt.G), (r.x1 + rt.G // 2) // rt.G + 1):
                            for rr in range(-(-(r.y0 - rt.G // 2) // rt.G), (r.y1 + rt.G // 2) // rt.G + 1):
                                rt.penalty[(c, rr)].add(net)
        self.pins = pins
        return pins

    # ------------------------------------------------------------- ports / labels / netlist
    def _ports_and_labels(self):
        L = self.L
        rt = self.router
        labelled = set()
        for (net, d, line) in self.ports:
            sh = None
            nr = L.routes.get(net)
            if net in self.port_sides and nr:
                side, lay, _ = self.port_sides[net]
                key = {"left": lambda p: p[0], "right": lambda p: -p[0], "bottom": lambda p: p[1],
                       "top": lambda p: -p[1]}[side]
                ends = sorted([p for p in nr.pins_used if p[2] == lay], key=key)
                if ends:
                    x, y, _ = ends[0]
                    w = max(T.rule_width(lay) * 2, 300)
                    pr = rect_c(x, y, w, w)
                    s = Shape(lay, pr, net, f"port:{net}")
                    if rt.clear(net, lay, pr):
                        L.shapes.append(s)
                    else:
                        s = Shape(lay, rect_c(x, y, T.rule_width(lay), T.rule_width(lay)), net, f"port:{net}")
                    L.ports.append((net, d, s))
                    labelled.add(net)
                    continue
            cands = [s for s in (nr.shapes if nr else []) if s.layer in ("m1", "m2", "m3", "m4")]
            if not cands:
                cands = [g.shapes[0] for g in self.pins.get(net, []) if g.shapes and g.shapes[0].layer in T.ROUTE_LAYERS]
            if cands:
                cands.sort(key=lambda s: (T.ROUTE_LAYERS.index(s.layer), s.rect.cx, s.rect.cy))
                s = cands[len(cands) // 2] if d not in ("power", "ground") else cands[0]
                sh = Shape(s.layer, s.rect, net, f"port:{net}")
            else:
                # unrouted single pin on li: drop a contact + pad
                for g in self.pins.get(net, []):
                    for a in g.access:
                        if a.layer == "m1" and rt.stack_ok(net, a, NetSpec(net)):
                            nr2 = rt.routes.setdefault(net, __import__("icdsl.router", fromlist=["NetRoute"]).NetRoute(net))
                            new = rt._commit(nr2, NetSpec(net), [(a.c, a.r, "m1")], a, None)
                            L.shapes += new
                            m1 = [s for s in new if s.layer == "m1"][0]
                            sh = Shape("m1", m1.rect, net, f"port:{net}")
                            break
                    if sh:
                        break
            if sh is None:
                raise self.err(f"port '{net}': no metal to put the pin on", line)
            L.ports.append((net, d, sh))
            labelled.add(net)
        for net, gs in self.pins.items():
            if net in labelled or net is None:
                continue
            for g in gs:
                s = g.shapes[0]
                L.labels.append((net, s.layer if s.layer in ("li", "m1", "m2", "m3", "m4") else "li", s.rect.cx, s.rect.cy))
                break

    def _netlist(self):
        L = self.L
        lines = [f".subckt {L.name} " + " ".join(L.port_order)]
        for o in self.objs.values():
            if o.array is not None:
                arr = o.array
                parts = getattr(arr, "parts", [arr])
                for part in parts:
                    for i, f in enumerate(part.fingers):
                        a, b = part.net_after(i), part.net_before(i + 1)
                        if f == "dummy":
                            lines.append(f"X{part.name}_dmy{i} {a} {part.dummy_gate} {b} {part.dummy_gate} "
                                         f"{part.model} w={part.w/1000:g} l={part.l/1000:g}")
                            continue
                        d = part.devs[f]
                        lines.append(f"X{f}_{part.name}_{i} {b} {d.nets['g']} {a} {d.nets['b']} {d.model} "
                                     f"w={d.w/1000:g} l={d.l/1000:g}")
            elif o.inst is not None:
                ins = o.inst
                lines.append(f"X{o.name} " + " ".join(ins.conns[p] for p in ins.cell.port_order) + f" {ins.cell.name}")
                for (n, txt) in ins.cell.subckts + [(ins.cell.name, ins.cell.spice)]:
                    if all(n != m for m, _ in L.subckts):
                        L.subckts.append((n, txt))
        lines.append(".ends")
        L.spice = "\n".join(lines) + "\n"


def _neg(r, axis):
    return Rect(-r.x1, r.y0, -r.x0, r.y1) if axis == "x" else Rect(r.x0, -r.y1, r.x1, -r.y0)
