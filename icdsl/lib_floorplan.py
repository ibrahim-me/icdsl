"""Library `floorplan`: place pre-built blocks, predict inter-block DRC, chip-level routing.

    floorplan <name> [width=<um>] [height=<um>]
        port  <net> in|out|inout|power|ground [side=left|right|top|bottom] [layer=m3]
        inst  <name> <cell | pdk:<std cell>> <port>=<net> ...      (alias: block)
        place <inst> at=(x, y) | right_of= | left_of= | above= | below= [gap=min|<um>] [align=] [flip=]
        mirror / pair / move                                      (same as in cells)
        proximity <instA> <instB>                                 report facing layers and legal gaps
        route / wire / keepout / limit                            (library route; default layers m1,m2,m3)

Placement between blocks is DRC-aware: with gap=min a block is abutted when every
facing layer either keeps its spacing or merges legally (same well / implant / same-net
rail); otherwise it is pushed out to the smallest legal gap and the binding rule is
reported. An explicit gap= that would violate a rule is an error naming the rule.
"""
from __future__ import annotations

from . import tech as T
from .geom import Shape
from .lib_assembly import FREE_SPACE, AssemblyBuilder, _neg, _pair_space, ceil_grid
from .syntax import ICLError, Min, check_keys, ident, nm

G = T.GRID
FLOOR_SPACE = dict(FREE_SPACE)
FLOOR_SPACE.update({("m2", "m2"): 140, ("m3", "m3"): 300, ("m4", "m4"): 300, ("via", "via"): 170,
                    ("via2", "via2"): 200, ("via3", "via3"): 200, ("nwell", "nwell"): 1270,
                    ("nsdm", "nsdm"): 380, ("psdm", "psdm"): 380, ("li", "li"): 170, ("poly", "poly"): 210})
MERGE = {"nwell", "nsdm", "psdm"}
NET_MERGE = {"li", "m1", "m2", "m3", "m4", "tap"}
RULE_NAME = {"nwell": "n-well spacing (nwell.2a) - or abut so the wells merge",
             "nsdm": "nsdm spacing (nsd.2)", "psdm": "psdm spacing (psd.2)", "diff": "diffusion spacing (difftap.3)",
             "tap": "tap spacing (difftap.3)", "poly": "poly spacing (poly.2)", "li": "li spacing (li.3)",
             "m1": "met1 spacing (m1.2)", "m2": "met2 spacing (m2.2)", "m3": "met3 spacing (m3.2)",
             "m4": "met4 spacing (m4.2)", "licon": "licon spacing", "mcon": "mcon spacing (ct.2)"}


def _gap(a, b):
    dx = max(b.x0 - a.x1, a.x0 - b.x1, 0)
    dy = max(b.y0 - a.y1, a.y0 - b.y1, 0)
    return max(dx, dy)


def block_violations(A, B, table=FLOOR_SPACE, limit=None):
    """Spacing violations between two shape sets, allowing legal merges at abutment."""
    out = []
    same = {}
    for x in list(A) + list(B):
        if x.layer in NET_MERGE and x.net is not None:
            same.setdefault((x.layer, x.net), []).append(x)
    for a in A:
        for b in B:
            s = _pair_space(table, a, b)
            if s is None:
                continue
            g = _gap(a.rect, b.rect)
            overl = a.rect.overlaps(b.rect)
            if a.layer == b.layer and g == 0:
                if a.layer in MERGE:
                    continue
                if a.layer in NET_MERGE and a.net is not None and a.net == b.net:
                    continue
            if a.layer == b.layer and a.layer in NET_MERGE and a.net is not None and a.net == b.net and g < s:
                # same net, bridged by a third same-net shape -> one merged polygon
                if any(c is not a and c is not b and c.rect.touches(a.rect) and c.rect.touches(b.rect)
                       for c in same.get((a.layer, a.net), ())):
                    continue
            if (s > 0 and g < s) or (s == 0 and overl):
                out.append((a, b, g, s))
                if limit and len(out) >= limit:
                    return out
    return out


def binding_offset(fixed, moving, axis, table=FLOOR_SPACE):
    """Like required_offset, also returning the shape pair that sets it."""
    need, why = None, None
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
                need, why = d, (a, b, s)
    return need, why


def edge_profile(shapes, bbox, side, reach=3000):
    """Distance from a block edge to the nearest shape of each layer (within `reach`)."""
    prof = {}
    for s in shapes:
        r = s.rect
        d = {"right": bbox.x1 - r.x1, "left": r.x0 - bbox.x0, "top": bbox.y1 - r.y1, "bottom": r.y0 - bbox.y0}[side]
        if d <= reach and s.layer not in ("boundary",):
            prof[s.layer] = min(prof.get(s.layer, 10 ** 9), d)
    return dict(sorted(prof.items(), key=lambda kv: kv[1]))


def describe(why):
    a, b, s = why
    lay = a.layer if a.layer == b.layer else f"{a.layer}/{b.layer}"
    rn = RULE_NAME.get(a.layer, "") if a.layer == b.layer else ""
    return f"{lay} {s/1000:.3f} um ({a.owner} vs {b.owner}){' - ' + rn if rn else ''}"


def place_block(b, o, ref, k, gap, align, line):
    """Block-aware relative placement used by assembly/floorplan builders."""
    horiz = k in ("right_of", "left_of")
    sgn = 1 if k in ("right_of", "above") else -1
    axis = "x" if horiz else "y"
    rb = ref.bbox()
    b._set_pos(o, 0, 0)
    lb = o.bbox()
    if horiz:
        amap = {"origin": ref.y, "bottom": rb.y0 - lb.y0, "top": rb.y1 - lb.y1, "center": rb.cy - lb.cy}
    else:
        amap = {"origin": ref.x, "left": rb.x0 - lb.x0, "right": rb.x1 - lb.x1, "center": rb.cx - lb.cx}
    if align not in amap:
        raise ICLError(f"align for {k}: {', '.join(amap)}", line)
    cross = int(round(amap[align] / 5.0)) * 5         # blocks keep exact alignment (5 nm grid)
    b._set_pos(o, 0, cross) if horiz else b._set_pos(o, cross, 0)
    mb = o.bbox()
    touch = ((rb.x1 - mb.x0) if horiz else (rb.y1 - mb.y0)) if sgn > 0 else \
        ((mb.x1 - rb.x0) if horiz else (mb.y1 - rb.y0))

    def at(d):
        if horiz:
            b._set_pos(o, sgn * d, cross)
        else:
            b._set_pos(o, cross, sgn * d)

    others = b._placed_shapes(exclude=o)
    if not isinstance(gap, Min):
        want = touch + nm(gap)
        at(want)
        bad = block_violations(others, o.gshapes(), limit=1)
        if bad:
            a, bb, g, s = bad[0]
            at(touch)
            fixed = ref.gshapes()
            mine = o.gshapes()
            if sgn < 0:
                fixed = [Shape(x.layer, _neg(x.rect, axis), x.net, x.owner, x.kinds) for x in fixed]
                mine = [Shape(x.layer, _neg(x.rect, axis), x.net, x.owner, x.kinds) for x in mine]
            d, why = binding_offset(fixed, mine, axis)
            raise ICLError(f"gap={gap} between {o.name} and {ref.name} violates {a.layer}/{bb.layer} spacing: "
                           f"{g/1000:.3f} um < {s/1000:.3f} um ({a.owner} vs {bb.owner})", line,
                           f"minimum legal gap is {max(0, (d or 0)) / 1000:.3f} um (binding: {describe(why) if why else '-'})"
                           ", or use gap=min to let the tool abut / space it")
        b.L.info.setdefault("proximity", []).append(f"{o.name} {k} {ref.name}: gap {nm(gap)/1000:.3f} um as requested")
        return
    # 1. try abutment (wells / implants / same-net rails merge)
    at(touch)
    bad = block_violations(others, o.gshapes(), limit=1)
    if not bad:
        b.L.info.setdefault("proximity", []).append(
            f"{o.name} {k} {ref.name}: abutted (facing wells/implants/same-net rails merge legally)")
        return
    a0, b0, g0, s0 = bad[0]
    # 2. smallest legal separation
    at(0)
    fixed = ref.gshapes()
    mine = o.gshapes()
    if sgn < 0:
        fixed = [Shape(x.layer, _neg(x.rect, axis), x.net, x.owner, x.kinds) for x in fixed]
        mine = [Shape(x.layer, _neg(x.rect, axis), x.net, x.owner, x.kinds) for x in mine]
    d, why = binding_offset(fixed, mine, axis)
    dd = ceil_grid(max(d if d is not None else touch, touch))
    at(dd)
    for _ in range(400):
        if not block_violations(b._placed_shapes(exclude=o), o.gshapes(), limit=1):
            break
        dd += G
        at(dd)
    b.L.info.setdefault("proximity", []).append(
        f"{o.name} {k} {ref.name}: cannot abut ({a0.layer}/{b0.layer} would be {g0/1000:.3f} < {s0/1000:.3f} um: "
        f"{a0.owner} vs {b0.owner}); placed at the minimum legal gap {(dd - touch)/1000:.3f} um, "
        f"binding rule: {describe(why) if why else '-'}")


class FloorplanBuilder(AssemblyBuilder):
    def __init__(self, design, block):
        super().__init__(design, block)
        self.L.kind = "floorplan"

    def err(self, msg, line=None, hint=""):
        return ICLError(f"floorplan {self.block.name}: {msg}", self.block.head.line if line is None else line, hint)

    def build(self):
        hd = self.block.head
        check_keys(hd, {"width", "height", "route_grid"}, "floorplan")
        self.route_grid = nm(self.scope.eval(hd.kw.get("route_grid", "0.23"), hd.line))
        self.size = None
        if "width" in hd.kw or "height" in hd.kw:
            if not ("width" in hd.kw and "height" in hd.kw):
                raise ICLError("give both width= and height= (um)", hd.line)
            self.size = (nm(self.scope.eval(hd.kw["width"], hd.line)), nm(self.scope.eval(hd.kw["height"], hd.line)))
        self.params = {}
        # chip-level default routing layers
        if not any(st.verb == "route" and "*" in st.args for st in self.block.body):
            self.plan.star = {"layers": "m1,m2,m3", "_line": hd.line}
        return super().build()

    def st_block(self, st):
        self.st_inst(st)

    def st_nmos(self, st):
        raise ICLError("floorplans place blocks, not transistors: put devices in a cell and instantiate it", st.line)

    st_pmos = st_nmos

    def st_proximity(self, st):
        check_keys(st, set(), "proximity")
        if len(st.args) != 2:
            raise ICLError("usage: proximity <instA> <instB>", st.line)
        a = self._obj_of(ident(st.args[0], "proximity", st.line), st.line)
        b = self._obj_of(ident(st.args[1], "proximity", st.line), st.line)
        if not (a.placed and b.placed):
            raise ICLError("proximity: place both blocks first", st.line)
        ra, rb = a.bbox(), b.bbox()
        horiz = not (ra.x0 < rb.x1 and rb.x0 < ra.x1)
        if horiz:
            left, right = (a, b) if ra.cx <= rb.cx else (b, a)
            sides = ("right", "left")
            gap = right.bbox().x0 - left.bbox().x1
        else:
            left, right = (a, b) if ra.cy <= rb.cy else (b, a)
            sides = ("top", "bottom")
            gap = right.bbox().y0 - left.bbox().y1
        axis = "x" if horiz else "y"
        A, B = left.gshapes(), right.gshapes()
        pa = edge_profile(A, left.bbox(), sides[0])
        pb = edge_profile(B, right.bbox(), sides[1])
        # legal gap if the right/upper block were slid towards the other one
        shift = -gap
        Bm = [Shape(s.layer, s.rect.moved(shift, 0) if horiz else s.rect.moved(0, shift), s.net, s.owner, s.kinds)
              for s in B]
        abut_bad = block_violations(A, Bm, limit=1)
        d, why = binding_offset(A, Bm, axis)
        mn = max(0, d or 0)
        lines = [f"{left.name}|{right.name} ({'side by side' if horiz else 'stacked'}): current gap {gap/1000:.3f} um",
                 "  abutment: " + ("legal (facing layers merge or keep their spacing)" if not abut_bad else
                                   f"illegal - {abut_bad[0][0].layer}/{abut_bad[0][1].layer} "
                                   f"{abut_bad[0][2]/1000:.3f} < {abut_bad[0][3]/1000:.3f} um "
                                   f"({abut_bad[0][0].owner} vs {abut_bad[0][1].owner})"),
                 f"  minimum legal separation: {mn/1000:.3f} um" + (f" (binding: {describe(why)})" if why else ""),
                 f"  {left.name} {sides[0]} edge layers (um from edge): " +
                 ", ".join(f"{k}@{v/1000:.2f}" for k, v in list(pa.items())[:10]),
                 f"  {right.name} {sides[1]} edge layers (um from edge): " +
                 ", ".join(f"{k}@{v/1000:.2f}" for k, v in list(pb.items())[:10])]
        if gap < mn and abut_bad:
            lines.append("  WARNING current gap is below the legal minimum - expect DRC errors")
        self.L.info.setdefault("proximity", []).extend(lines)
