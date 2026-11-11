"""Judge a layout given only as GDS (no ICL objects): connectivity from the drawn layers and the
text labels, transistor fingers assigned to the benchmark devices (internal nets matched by
binding), then the same constraint checks as bench/l2_judge.py."""
from __future__ import annotations

import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "bench"))

import klayout.db as kdb  # noqa: E402

from icdsl import tech as T  # noqa: E402
from icdsl.geom import Rect, Shape  # noqa: E402

DRAW = {v: k for k, v in T.GDS.items()}
TEXT_LAYER = {67: "li", 68: "m1", 69: "m2", 70: "m3", 71: "m4", 66: "poly"}
FOOTPRINT = {"diff", "tap", "poly", "licon", "li", "mcon", "m1", "via", "m2"}


def read(gds, top):
    ly = kdb.Layout()
    ly.read(gds)
    if abs(ly.dbu - 0.001) > 1e-9:               # work in nm whatever database unit the file uses
        ly.transform(kdb.DCplxTrans(ly.dbu / 0.001))
        ly.dbu = 0.001
    c = ly.cell(top)
    if c is None:
        raise ValueError(f"no cell '{top}' in {gds} (cells: {[x.name for x in ly.each_cell()][:8]})")
    shapes, labels = [], []
    for li in ly.layer_indexes():
        info = ly.get_info(li)
        key = (info.layer, info.datatype)
        it = c.begin_shapes_rec(li)
        while not it.at_end():
            sh = it.shape()
            tr = it.trans()
            if sh.is_text():
                if info.layer in TEXT_LAYER:
                    t = sh.text.transformed(tr)
                    labels.append((TEXT_LAYER[info.layer], t.x, t.y, t.string))
            elif key in DRAW and (sh.is_box() or sh.is_polygon() or sh.is_path()):
                poly = sh.polygon.transformed(tr)
                for tz in poly.decompose_trapezoids(0):
                    b = tz.bbox()
                    shapes.append(Shape(DRAW[key], Rect(b.left, b.bottom, b.right, b.top), None, "gds"))
            it.next()
    for (lay, x, y, txt) in labels:
        shapes.append(Shape(lay, Rect(x - 1, y - 1, x + 1, y + 1), txt, "label:" + txt))
    return shapes, labels


def footprint(shapes):
    xs = [s.rect for s in shapes if s.layer in FOOTPRINT and not s.owner.startswith("label")]
    if not xs:
        return 0, 0, None
    b = xs[0]
    for r in xs[1:]:
        b = b.union(r)
    return b.w / 1000, b.h / 1000, b


def assign_fingers(trs, devices):
    """trs: conncheck transistors; returns ({device: [(x,y)]}, stray list).

    Exact backtracking: unlabelled layout nets ('?N') are bound to reference nets consistently
    (one-to-one), each device gets exactly nf fingers."""
    nets_ref = {n for d in devices for n in (d["d"], d["g"], d["s"])}
    real = [t for t in trs if len(t["sd"]) == 2 and t["sd"][0] != t["sd"][1]]
    # most constrained first: fully named fingers, then by how many devices could take them
    order = sorted(range(len(real)), key=lambda i: sum(n.startswith("?") for n in [real[i]["gate"]] + real[i]["sd"]))
    left = {d["name"]: d.get("nf", 1) for d in devices}
    assign = {}

    def options(t, bind, rbind):
        out = []
        for d in devices:
            if d["kind"] != t["kind"] or left[d["name"]] <= 0:
                continue
            for a, b in ((t["sd"][0], t["sd"][1]), (t["sd"][1], t["sd"][0])):
                nb, nr, ok = dict(bind), dict(rbind), True
                for lay, want in ((t["gate"], d["g"]), (a, d["d"]), (b, d["s"])):
                    if lay == want:
                        continue
                    if lay.startswith("?") and want in nets_ref:
                        if nb.get(lay, want) != want or nr.get(want, lay) != lay:
                            ok = False
                            break
                        nb[lay], nr[want] = want, lay
                        continue
                    ok = False
                    break
                if ok:
                    out.append((d["name"], nb, nr))
                    break
        return out
    calls = [0]

    def dfs(k, bind, rbind):
        calls[0] += 1
        if calls[0] > 200000:
            return False
        if k == len(order):
            return True
        t = real[order[k]]
        for name, nb, nr in options(t, bind, rbind):
            left[name] -= 1
            assign[order[k]] = name
            if dfs(k + 1, nb, nr):
                return True
            left[name] += 1
            del assign[order[k]]
        return False
    fg = defaultdict(list)
    stray = []
    if dfs(0, {}, {}):
        for i, name in assign.items():
            fg[name].append((real[i]["x_um"], real[i]["y_um"]))
    else:                                  # no consistent assignment: fall back to greedy, report the rest
        bind, rbind = {}, {}
        for i in order:
            opts = options(real[i], bind, rbind)
            if opts:
                name, bind, rbind = opts[0]
                left[name] -= 1
                fg[name].append((real[i]["x_um"], real[i]["y_um"]))
            else:
                stray.append(real[i])
    return fg, stray


def rails(shapes, labels):
    """L1 template: VGND met1 rail across the cell at y=0, VPWR at y=2.72."""
    m1 = kdb.Region()
    for s in shapes:
        if s.layer == "m1" and not s.owner.startswith("label"):
            m1.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
    m1.merge()
    w, h, fb = footprint(shapes)
    out = []
    for net, y in (("VGND", 0), ("VPWR", 2720)):
        ok = False
        for p in m1.each():
            b = p.bbox()
            if b.bottom <= y <= b.top and fb is not None and b.left <= fb.x0 + 10 and b.right >= fb.x1 - 10:
                if any(lab[3] == net and p.inside(kdb.Point(lab[1], lab[2])) for lab in labels if lab[0] == "m1"):
                    ok = True
        out.append({"constraint": {"type": "rail", "net": net}, "ok": ok,
                    "detail": f"{net} met1 rail across the whole cell at y={y/1000:g} um, labelled {net}: "
                              f"{'yes' if ok else 'NO'}"})
    return out


def spacing_gds(nets, c):
    """Wire-to-wire distance of two nets from geometry alone: their metal (m1..m4), minus the escape zone
    (within `min` of either net's contacts/vias - pin landings), must keep `min` apart."""
    a, b = c["nets"]
    dmin = int(round(c["min"] * 1000))
    zone = kdb.Region()
    for n in (a, b):
        for cut in ("licon", "mcon", "via", "via2", "via3"):
            zone += nets.get(n, {}).get(cut, kdb.Region())
    zone = zone.sized(dmin)
    worst = None
    for L in ("li", "m1", "m2", "m3", "m4"):
        ra = nets.get(a, {}).get(L, kdb.Region()).merged() - zone
        rb = nets.get(b, {}).get(L, kdb.Region()).merged() - zone
        if ra.is_empty() or rb.is_empty():
            continue
        for ep in ra.separation_check(rb, dmin).each():
            dist = ep.distance() / 1000
            if worst is None or dist < worst[0]:
                worst = (dist, L, ep.bbox().center())
    if worst is None:
        return {"constraint": c, "ok": True,
                "detail": f"wiring (li/metal) of {a} and {b} at least {c['min']} um apart (outside the pin escape zones)"}
    return {"constraint": c, "ok": False,
            "detail": f"wiring (li/metal) of {a} and {b} comes {worst[0]:.3f} um apart on {worst[1]} near "
                      f"({worst[2].x/1000:.2f}, {worst[2].y/1000:.2f}) (need >= {c['min']}, away from pins)"}


def judge(gds, top, spec, pv=None, level="l2"):
    from icdsl import conncheck
    import l2_judge
    shapes, labels = read(gds, top)
    res = conncheck.analyse(shapes, [], {}, return_nets=True)
    fg, stray = assign_fingers(res["transistors"], spec["devices"])
    w, h, _ = footprint(shapes)

    class Top:                       # what l2_judge needs from a cell
        width, height = int(w * 1000), int(h * 1000)
        route_report = {}

        @staticmethod
        def all_shapes(flat=True):
            return shapes
    out = {"size_um": [round(w, 3), round(h, 3)], "results": []}
    if level == "l2":
        rest = dict(spec, constraints=[c for c in spec.get("constraints", []) if c["type"] != "spacing"])
        r = l2_judge.check(Top, rest, pv, fg=fg, stray=stray)
        out["results"] = r["results"] + [spacing_gds(res["nets"], c) for c in spec.get("constraints", [])
                                           if c["type"] == "spacing"]
    else:
        out["results"] = rails(shapes, labels)          # device count / nets: LVS covers them
    out["shorts"] = res["shorts"][:3]
    out["opens"] = res["opens"][:3]
    out["ok"] = all(r["ok"] for r in out["results"])
    return out
