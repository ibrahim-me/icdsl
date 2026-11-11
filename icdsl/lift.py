"""Lift a standard cell from GDS (+ its SPICE netlist) into an editable ICL level-1 `stdcell`.

    python -m icdsl.lift a21oi_1 [--variant bench|hd] [-o out.icl]

variant hd     the cell as drawn: no taps in the cell, PDK widths, nominal L and H. Conductors are
               identical to the GDS (contact columns are re-created by `array`).
variant bench  benchmark conventions: taps in the cell, widths x0.75 as parameters, and every position
               derived from WN.. / WP.. / L / H so one file stays legal over the parameter sweep.

How positions are written
  x  from the gate columns x1 .. xn (x2 = x1 + L + <gap>): a longer L moves every later column, so
     gates widen while spacings, contacts and enclosures keep their size.
  y  from the row edges: nb (bottom of the n row), nb + WN.. (n diffusion tops), pt - WP.. (p bottoms),
     pt (top of the p row), 0 / H (rails). Between two neighbouring edges one horizontal 'stretch line'
     is chosen; a shape edge below it follows the lower row edge, one above it the upper. The line is
     placed where shrinking or growing that band cuts no contact, enclosure, overlap or narrow gap
     (checked at every sweep point).
"""
from __future__ import annotations

import argparse
import math
import os
import sys

import klayout.db as kdb

from . import tech as T

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HD_GDS = os.path.join(ROOT, "pdk", "sky130A", "libs.ref", "sky130_fd_sc_hd", "gds", "sky130_fd_sc_hd.gds")
PREFIX = "sky130_fd_sc_hd__"
LAYERS = {(64, 20): "nwell", (65, 20): "diff", (65, 44): "tap", (66, 20): "poly", (66, 44): "licon",
          (67, 20): "li", (67, 44): "mcon", (68, 20): "m1", (68, 44): "via", (69, 20): "m2", (95, 20): "npc",
          (93, 44): "nsdm", (94, 20): "psdm"}
TEXTS = {(67, 5): "li", (68, 5): "m1", (69, 5): "m2"}
CONDUCTORS = ("poly", "sd", "tap", "li", "m1", "m2")
CUTS = {"licon": ("li", ("poly", "sd", "tap")), "mcon": ("m1", ("li",)), "via": ("m2", ("m1",))}
RAIL_LI, RAIL_M1 = 85, 240
TAP_HALF = (T.R["licon.size"] + 2 * T.R["licon.diff_enc1"]) // 2       # template tap strip: y = +-145
DIFF_TAP = T.rule_space("diff", "tap")                                  # 270
SWEEP = [(0.15, 1.0, 2.72), (0.18, 1.0, 2.72), (0.25, 1.0, 2.72), (0.15, 0.85, 2.72),
         (0.15, 1.35, 3.26), (0.15, 1.9, 4.08)]                    # benchmark conventions (taps in the cell)
SWEEP_LIB = [(0.15, 1.0, 2.72), (0.18, 1.0, 2.72), (0.25, 1.0, 2.72), (0.15, 1.25, 3.26), (0.15, 1.5, 3.8)]


class LiftError(Exception):
    pass


# =============================================================================== reading
_LY = {}


def _layout(gds):
    if gds not in _LY:
        ly = kdb.Layout()
        ly.read(gds)
        _LY[gds] = ly
    return _LY[gds]


class Source:
    """Flattened shapes (merged regions per layer) and text labels of one cell, in nm."""

    def __init__(self, gds, cell):
        ly = _layout(gds)
        c = ly.cell(cell)
        if c is None:
            raise LiftError(f"no cell {cell} in {gds}")
        if abs(ly.dbu - 0.001) > 1e-9:
            raise LiftError("expected a 1 nm database unit")
        self.name = cell
        self.reg = {n: kdb.Region() for n in LAYERS.values()}
        self.labels = []
        bnd = None
        for li in ly.layer_indexes():
            info = ly.get_info(li)
            key = (info.layer, info.datatype)
            if key in LAYERS:
                self.reg[LAYERS[key]] += kdb.Region(c.begin_shapes_rec(li))
            if key in TEXTS:
                it = c.begin_shapes_rec(li)
                while not it.at_end():
                    sh = it.shape()
                    if sh.is_text():
                        t = sh.text.transformed(it.trans())
                        self.labels.append((t.string, TEXTS[key], t.x, t.y))
                    it.next()
            if key in ((236, 0), (235, 4), (81, 4)):
                b = kdb.Region(c.begin_shapes_rec(li)).bbox()
                if not b.empty():
                    bnd = b if bnd is None else bnd + b
        for k in self.reg:
            self.reg[k].merge()
        if bnd is None or bnd.left != 0 or bnd.bottom != 0:
            raise LiftError(f"{cell}: no boundary at the origin")
        self.W, self.H = bnd.right, bnd.top


# =============================================================================== rectangles
def cover(poly):
    """A small set of (overlapping) maximal rectangles whose union is the Manhattan polygon."""
    if poly.is_box():
        return [poly.bbox()]
    R = kdb.Region(poly)
    xs = sorted({p.x for p in poly.each_point_hull()} | {p.x for h in range(poly.holes()) for p in poly.each_point_hole(h)})
    ys = sorted({p.y for p in poly.each_point_hull()} | {p.y for h in range(poly.holes()) for p in poly.each_point_hole(h)})

    def inside(b):
        return (kdb.Region(b) - R).is_empty()
    cand = set()
    for mode, grow_y in ((kdb.Polygon.TD_htrapezoids, True), (kdb.Polygon.TD_vtrapezoids, False)):
        for t in poly.decompose_trapezoids(mode):
            b = t.bbox()
            if grow_y:
                lo = min((y for y in ys if y <= b.bottom and inside(kdb.Box(b.left, y, b.right, b.top))),
                         default=b.bottom)
                hi = max((y for y in ys if y >= b.top and inside(kdb.Box(b.left, lo, b.right, y))), default=b.top)
                b = kdb.Box(b.left, lo, b.right, hi)
            else:
                lo = min((x for x in xs if x <= b.left and inside(kdb.Box(x, b.bottom, b.right, b.top))),
                         default=b.left)
                hi = max((x for x in xs if x >= b.right and inside(kdb.Box(lo, b.bottom, x, b.top))), default=b.right)
                b = kdb.Box(lo, b.bottom, hi, b.top)
            cand.add((b.left, b.bottom, b.right, b.top))
    cand = [kdb.Box(*c) for c in cand]
    left = R.dup()
    out = []
    while not left.is_empty():
        best = max(cand, key=lambda b: ((kdb.Region(b) & left).area(), b.area()))
        if (kdb.Region(best) & left).area() == 0:
            break
        out.append(best)
        left -= kdb.Region(best)
    return sorted(out, key=lambda b: (b.left, b.bottom))


# =============================================================================== nets and devices
class Extract:
    """Connectivity of the source cell: polygons -> nets, transistors (gate = poly & diff)."""

    def __init__(self, src):
        r = src.reg
        self.gates = list((r["poly"] & r["diff"]).merged().each())
        sd = (r["diff"] - r["poly"]).merged()
        self.items = []                      # (layer, polygon)
        for lay in CONDUCTORS:
            reg = sd if lay == "sd" else r[lay]
            for p in reg.each():
                self.items.append((lay, p))
        n = len(self.items)
        par = list(range(n))

        def find(i):
            while par[i] != i:
                par[i] = par[par[i]]
                i = par[i]
            return i

        def union(a, b):
            a, b = find(a), find(b)
            if a != b:
                par[a] = b
        by = {}
        for i, (lay, p) in enumerate(self.items):
            by.setdefault(lay, []).append(i)
        self._regs = [kdb.Region(p) for _, p in self.items]

        def hits(lay, reg):
            bb = reg.bbox()
            return [i for i in by.get(lay, []) if self.items[i][1].bbox().overlaps(bb) and not (self._regs[i] & reg).is_empty()]
        for cut, (top, lows) in CUTS.items():
            for p in r[cut].each():
                cr = kdb.Region(p)
                ups = hits(top, cr)
                downs = [i for lo in lows for i in hits(lo, cr)]
                for i in ups[1:] + downs:
                    if ups:
                        union(ups[0], i)
                if not ups:
                    for i in downs[1:]:
                        union(downs[0], i)
        self.find = find
        self.by = by
        # transistors
        self.devices = []
        nw = r["nwell"]
        for g in self.gates:
            b = g.bbox()
            vertical = b.height() >= b.width()
            gr = kdb.Region(g)
            kind = "pmos" if not (gr & nw).is_empty() else "nmos"
            pol = hits("poly", gr)
            if vertical:
                sides = [kdb.Box(b.left - 2, b.bottom + 1, b.left, b.top - 1), kdb.Box(b.right, b.bottom + 1, b.right + 2, b.top - 1)]
                w, l = b.height(), b.width()
            else:
                sides = [kdb.Box(b.left + 1, b.bottom - 2, b.right - 1, b.bottom), kdb.Box(b.left + 1, b.top, b.right - 1, b.top + 2)]
                w, l = b.width(), b.height()
            sds = []
            for sb in sides:
                h = hits("sd", kdb.Region(sb))
                sds.append(find(h[0]) if h else None)
            self.devices.append({"kind": kind, "g": find(pol[0]) if pol else None, "sd": sds, "w": w, "l": l,
                                 "box": b, "vertical": vertical})
        # labels -> nets
        self.label_net = {}
        for (txt, lay, x, y) in src.labels:
            h = hits(lay, kdb.Region(kdb.Box(x - 1, y - 1, x + 1, y + 1)))
            if h:
                self.label_net.setdefault(txt, find(h[0]))

    def net_at(self, lay, box):
        """Net id of the conductor polygon on `lay` under box (or None)."""
        reg = kdb.Region(box)
        for i in self.by.get(lay, []):
            if self.items[i][1].bbox().overlaps(box) and not (self._regs[i] & reg).is_empty():
                return self.find(i)
        return None


def match(ex, spec):
    """Map extracted nets to the spec's net names (labels fixed, the rest by device matching)."""
    fixed = {}
    for name, nid in ex.label_net.items():
        nm_ = {"VNB": "VGND", "VPB": "VPWR"}.get(name, name)
        if nm_ in fixed.values() and fixed.get(nid) != nm_:
            continue
        fixed[nid] = nm_
    sdev = spec["devices"]
    edev = ex.devices
    if len(sdev) != len(edev):
        return None, f"{len(edev)} transistors in the layout, {len(sdev)} in the netlist"
    m, rev = dict(fixed), {v: k for k, v in fixed.items()}
    used = [False] * len(sdev)
    order = sorted(range(len(edev)), key=lambda i: -sum(x in fixed for x in [edev[i]["g"]] + edev[i]["sd"]))
    steps = [0]

    def bind(pairs):
        added = []
        for e, s in pairs:
            if e is None:
                for a in added:
                    rev.pop(m.pop(a))
                return None
            if e in m:
                if m[e] != s:
                    for a in added:
                        rev.pop(m.pop(a))
                    return None
            elif s in rev:
                for a in added:
                    rev.pop(m.pop(a))
                return None
            else:
                m[e] = s
                rev[s] = e
                added.append(e)
        return added

    def go(k):
        steps[0] += 1
        if steps[0] > 200000:
            return False
        if k == len(order):
            return True
        e = edev[order[k]]
        for j, s in enumerate(sdev):
            if used[j] or s["kind"] != e["kind"] or abs(s["w_hd"] * 1000 - e["w"]) > 5:
                continue
            for a, b in ((s["d"], s["s"]), (s["s"], s["d"])):
                added = bind([(e["g"], s["g"]), (e["sd"][0], a), (e["sd"][1], b)])
                if added is None:
                    continue
                used[j] = True
                e["spec"] = s["name"]
                if go(k + 1):
                    return True
                used[j] = False
                for x in added:
                    rev.pop(m.pop(x))
        return False
    if not go(0):
        return None, "no consistent device matching between layout and netlist"
    return m, ""


# =============================================================================== the mapping
class Mapper:
    """x: gate-column anchors. y: row-edge knots; every shape edge between two knots follows one of
    them (chosen per edge group by a local search over the sweep points)."""

    def __init__(self, src, ex, spec, variant):
        self.variant = variant
        self.H0 = src.H
        if any(not d["vertical"] for d in ex.devices):
            raise LiftError("horizontal gates are not supported")
        gates = sorted({(d["box"].left, d["box"].right) for d in ex.devices})
        if any(c1 - c0 != 150 for c0, c1 in gates):
            raise LiftError("gate length is not 0.15 um")
        # gates that overlap in x (an n gate and its jogged p gate) share one stretch point for L,
        # which must lie inside all of them so that every gate widens by exactly dL
        comps = []
        for g in gates:
            if comps and g[0] < max(c1 for _, c1 in comps[-1]):
                comps[-1].append(g)
            else:
                comps.append([g])
        self.sL = []
        for comp in comps:
            lo, hi = max(c0 for c0, _ in comp), min(c1 for _, c1 in comp)
            if lo >= hi:
                raise LiftError(f"offset gates at x={comp[0][0]/1000}..{comp[-1][1]/1000} share no common x range")
            self.sL.append((lo + hi) / 2)
        # 5 nm more between every gate and its neighbours: the PDK cells use the standard-cell-area
        # rule licon.11a (0.05 um contact-to-gate); outside that area the rule is 0.055 um
        inside = lambda x: any(c0 < x < c1 for c0, c1 in gates)
        self.ins_l = sorted({c0 for c0, _ in gates if not inside(c0)})
        self.ins_r = sorted({c1 for _, c1 in gates if not inside(c1)})
        self.gates = gates
        self.lefts = sorted({c0 for c0, _ in gates})
        self.cols = comps
        wp = {}
        for d in spec["devices"]:
            wp.setdefault((d["kind"], round(d["w_hd"] * 1000)), d["wparam"])
        nd = [d for d in ex.devices if d["kind"] == "nmos"]
        pd = [d for d in ex.devices if d["kind"] == "pmos"]
        if not nd or not pd:
            raise LiftError("needs both n and p transistors")
        self.nb0 = min(d["box"].bottom for d in nd)
        self.pt0 = max(d["box"].top for d in pd)
        if max(d["box"].top for d in nd) >= min(d["box"].bottom for d in pd):
            raise LiftError("n and p rows overlap")
        self.params = dict(spec["params"])
        K = {0: ("0", lambda v: 0), self.H0: ("H", lambda v: v["H"]),
             self.nb0: ("nb", lambda v: v["nb"]), self.pt0: ("pt", lambda v: v["pt"])}
        for d in sorted(nd, key=lambda d: d["box"].bottom) + sorted(pd, key=lambda d: -d["box"].top):
            P = wp.get((d["kind"], d["w"]))
            if P is None:
                raise LiftError(f"no width parameter for a {d['kind']} of w={d['w']/1000}")
            b, t = d["box"].bottom, d["box"].top
            if d["kind"] == "nmos":
                if b not in K:
                    K[b] = (f"nb + {(b - self.nb0)/1000:g}", lambda v, o=b - self.nb0: v["nb"] + o)
                be, bf = K[b]
                if t not in K:
                    K[t] = (f"{be} + {P}", lambda v, f=bf, P=P: f(v) + v[P])
            else:
                if t not in K:
                    K[t] = (f"pt - {(self.pt0 - t)/1000:g}", lambda v, o=self.pt0 - t: v["pt"] - o)
                te, tf = K[t]
                if b not in K:
                    K[b] = (f"{te} - {P}", lambda v, f=tf, P=P: f(v) - v[P])
        self.K = K
        self.pvs = self._points(spec)
        ks = sorted(K)
        for v in self.pvs:
            vals = [K[k][1](v) for k in ks]
            if any(b < a for a, b in zip(vals, vals[1:])):
                raise LiftError("row edges change order over the sweep")
        self.knots = ks
        self.anchor = {}             # edge key -> knot (hd y)

    def _points(self, spec):
        out = []
        for (L, sc, H) in (SWEEP if self.variant == "bench" else SWEEP_LIB):
            v = {"L": round(L * 1000), "H": round(H * 1000)}
            for k, w in self.params.items():
                v[k] = round(max(0.42, round(w * sc * 100) / 100) * 1000)
            if self.variant == "bench":
                v["nb"] = TAP_HALF + DIFF_TAP
                v["pt"] = v["H"] - TAP_HALF - DIFF_TAP
            else:
                v["nb"] = self.nb0
                v["pt"] = v["H"] - (self.H0 - self.pt0)
            out.append(v)
        return out

    # ---- x
    def kL(self, x):
        return sum(1 for t in self.sL if t < x) + 0.5 * sum(1 for t in self.sL if t == x)

    def k5(self, x):
        return sum(1 for e in self.ins_l if e <= x) + sum(1 for e in self.ins_r if e < x)

    def xv(self, x, v):
        return x + round(self.kL(x) * (v["L"] - 150)) + 5 * self.k5(x)

    def anchors(self):
        """Named x anchors: the distinct gate left edges x1..xn (a gate's right edge is xk + L)."""
        out = []
        for i, a in enumerate(self.lefts):
            out.append((f"x{i + 1}", a))
            out.append((f"x{i + 1} + L", a + 150))
        return out

    def _rel(self, x, a):
        n = self.kL(x) - self.kL(a)
        c = (x - a) - n * 150 + 5 * (self.k5(x) - self.k5(a))
        return n, c

    def xe(self, x):
        best = None
        for name, a in self.anchors():
            n, c = self._rel(x, a)
            key = (abs(n), abs(c))
            if best is None or key < best[0]:
                best = (key, name, n, c)
        _, name, n, c = best
        if n:
            name = f"{name} + " + ("L/2" if n == 0.5 else "L" if n == 1 else f"{n:g}*L") if n > 0 else \
                f"{name} - " + ("L/2" if n == -0.5 else "L" if n == -1 else f"{-n:g}*L")
        return _expr(name, round(c))

    def column_defs(self):
        out = []
        for i, a in enumerate(self.lefts):
            if i == 0:
                out.append(f"x1 = {(a + 5 * self.k5(a))/1000:g}")
                continue
            prev = self.lefts[i - 1]
            n, c = self._rel(a, prev)
            term = "" if not n else (" + L/2" if n == 0.5 else " + L" if n == 1 else f" + {n:g}*L")
            out.append(f"x{i + 1} = x{i}{term}" + (f" + {round(c)/1000:g}" if c > 0 else f" - {abs(round(c))/1000:g}" if c < 0 else ""))
        return out

    def width_cols(self, W0):
        """Columns of 0.46 um: the PDK width + the 5 nm reliefs + room for L = 0.25 at every stretch point."""
        return math.ceil((W0 + 5 * self.k5(W0) + len(self.sL) * 100) / T.GRID)

    # ---- y
    def band(self, y):
        """(lower knot, upper knot) of the band strictly containing y, or None if y is a knot / outside."""
        if y in self.K or y <= self.knots[0] or y >= self.knots[-1]:
            return None
        for a, b in zip(self.knots, self.knots[1:]):
            if a < y < b:
                return a, b
        return None

    def knot_of(self, key, y):
        if y in self.K:
            return y
        if y < self.knots[0]:
            return self.knots[0]
        if y > self.knots[-1]:
            return self.knots[-1]
        k = self.anchor.get(key)
        if k is None:
            a, b = self.band(y)
            k = a if y - a <= b - y else b
        return k

    def yv(self, key, y, v):
        k = self.knot_of(key, y)
        return self.K[k][1](v) + (y - k)

    def ye(self, key, y):
        k = self.knot_of(key, y)
        return _expr(self.K[k][0], y - k)

    def edge_value(self, r, side, v):
        """Mapped y of edge `side` (0 = bottom, 1 = top) of rect r at point v (cuts are rigid)."""
        y = r.y0 if side == 0 else r.y1
        if r.fixed:                               # template shapes stay on their rail
            return y if y < self.H0 / 2 else v["H"] - (self.H0 - y)
        if r.kind == "cut":
            cy = (r.y0 + r.y1) // 2
            return self.yv((r.id, "c"), cy, v) + ((r.y0 if side == 0 else r.y1) - cy)
        y = r.y0 if side == 0 else r.y1
        return self.yv((r.id, side), y, v)

    def edge_expr(self, r, side):
        y = r.y0 if side == 0 else r.y1
        return self.ye((r.id, side), y)

    # ---- choosing anchors
    def optimise(self, rects, pairs, restarts=24, seed=1):
        """Exact anchor choice by integer programming (HiGHS via scipy); greedy search if unavailable."""
        try:
            return self.optimise_milp(rects, pairs)
        except Exception as e:                  # noqa: BLE001 - fall back to the local search
            self.milp_error = repr(e)[:200]
            return self.optimise_local(rects, pairs, restarts, seed)

    def optimise_milp(self, rects, pairs, time_limit=60):
        """Binary x_g per free edge group (1 = the band's other knot). For every constraint and sweep
        point a penalty z >= table value of the (at most two) groups involved; f_v marks a failing
        point. Minimise 1000 * sum(f_v) + sum(z)."""
        import numpy as np
        from scipy.optimize import Bounds, LinearConstraint, milp
        from scipy.sparse import coo_matrix
        groups = _edge_groups(rects, self)
        gof = {}
        for gi, g in enumerate(groups):
            for k in g["keys"]:
                gof[k] = gi
        G, V = len(groups), len(self.pvs)

        def setg(gi, b):
            g = groups[gi]
            a, c = g["band"]
            k = g["default"] if not b else (c if g["default"] == a else a)
            for key in g["keys"]:
                self.anchor[key] = k
        for gi in range(G):
            setg(gi, 0)
        rows, cols, vals, lb = [], [], [], []
        nz = 0
        zinfo = []                     # (point index)
        fixed_bad = [0] * V
        for p in pairs:
            gs = []
            for (r, s_) in (p.a, p.b):
                gi = gof.get((r.id, "c" if r.kind == "cut" else s_))
                if gi is not None and gi not in gs:
                    gs.append(gi)
            combos = [()] if not gs else ([(0,), (1,)] if len(gs) == 1 else [(0, 0), (0, 1), (1, 0), (1, 1)])
            tab = {}
            for cb in combos:
                for gi, b in zip(gs, cb):
                    setg(gi, b)
                tab[cb] = [p.bad(self.edge_value(p.b[0], p.b[1], v) - self.edge_value(p.a[0], p.a[1], v))
                           for v in self.pvs]
            for gi in gs:
                setg(gi, 0)
            for vi in range(V):
                if not gs:
                    fixed_bad[vi] += tab[()][vi]
                    continue
                if not any(tab[cb][vi] for cb in combos):
                    continue
                zi = G + V + nz
                nz += 1
                zinfo.append(vi)
                for cb in combos:
                    c = tab[cb][vi]
                    if not c:
                        continue
                    # z + c * sum(mismatch(x_g, b)) >= c   (mismatch(x, 0) = x, mismatch(x, 1) = 1 - x)
                    r_ = len(lb)
                    rows.append(r_); cols.append(zi); vals.append(1.0)
                    const = 0
                    for gi, b in zip(gs, cb):
                        if b == 0:
                            rows.append(r_); cols.append(gi); vals.append(float(c))
                        else:
                            rows.append(r_); cols.append(gi); vals.append(-float(c))
                            const += c
                    lb.append(c - const)
                # f_v >= z / 10
                r_ = len(lb)
                rows += [r_, r_]; cols += [G + vi, zi]; vals += [10.0, -1.0]
                lb.append(0.0)
        n = G + V + nz
        cvec = np.zeros(n)
        cvec[G:G + V] = 1000.0
        cvec[G + V:] = 1.0
        integrality = np.zeros(n)
        integrality[:G + V] = 1
        lo = np.zeros(n)
        hi = np.concatenate([np.ones(G + V), np.full(nz, 10.0)])
        for vi in range(V):
            if fixed_bad[vi]:
                lo[G + vi] = 1.0
        cons = []
        if lb:
            A = coo_matrix((vals, (rows, cols)), shape=(len(lb), n)).tocsr()
            cons = [LinearConstraint(A, np.array(lb), np.full(len(lb), np.inf))]
        res = milp(cvec, constraints=cons, integrality=integrality, bounds=Bounds(lo, hi),
                   options={"time_limit": time_limit, "disp": False})
        if res.x is None:
            raise RuntimeError(f"milp: {res.message}")
        for gi in range(G):
            setg(gi, int(round(res.x[gi])))
        return self.cost(pairs)

    def optimise_local(self, rects, pairs, restarts=24, seed=1):
        """Choose the knot of every free edge group. Objective: fewest sweep points with a predicted
        violation, then fewest violations. Greedy descent (single flips, then flips of two groups that
        share a constraint) from the nearest-knot start and from random restarts."""
        import random
        rnd = random.Random(seed)
        groups = _edge_groups(rects, self)
        if not groups:
            return self.cost(pairs)
        gof = {}
        for gi, g in enumerate(groups):
            for k in g["keys"]:
                gof[k] = gi
        aff = [set() for _ in groups]
        for i, p in enumerate(pairs):
            for (r, s_) in (p.a, p.b):
                gi = gof.get((r.id, "c" if r.kind == "cut" else s_))
                if gi is not None:
                    aff[gi].add(i)
        nbr = [set() for _ in groups]
        for gi in range(len(groups)):
            for i in aff[gi]:
                p = pairs[i]
                for (r, s_) in (p.a, p.b):
                    gj = gof.get((r.id, "c" if r.kind == "cut" else s_))
                    if gj is not None and gj != gi:
                        nbr[gi].add(gj)
        pvs = self.pvs
        side = [0] * len(groups)               # 0 = default knot, 1 = the other one

        def apply():
            for gi, g in enumerate(groups):
                a, b = g["band"]
                k = g["default"] if not side[gi] else (b if g["default"] == a else a)
                for key in g["keys"]:
                    self.anchor[key] = k

        def evalp(i):
            p = pairs[i]
            return [p.bad(self.edge_value(p.b[0], p.b[1], v) - self.edge_value(p.a[0], p.a[1], v)) for v in pvs]

        def score(cnt):
            return 1000 * sum(1 for c in cnt if c) + sum(cnt)

        def descend():
            apply()
            st = {i: evalp(i) for i in range(len(pairs))}
            cnt = [sum(st[i][k] for i in st) for k in range(len(pvs))]
            best = score(cnt)

            def attempt(gs):
                nonlocal best, cnt
                idx = set().union(*(aff[g] for g in gs))
                if not idx or not any(any(st[i]) for i in idx) and best < 1000:
                    pass
                for g in gs:
                    side[g] ^= 1
                for g in gs:
                    a, b = groups[g]["band"]
                    k = groups[g]["default"] if not side[g] else (b if groups[g]["default"] == a else a)
                    for key in groups[g]["keys"]:
                        self.anchor[key] = k
                new = {i: evalp(i) for i in idx}
                c2 = list(cnt)
                for i in idx:
                    for k in range(len(pvs)):
                        c2[k] += new[i][k] - st[i][k]
                sc = score(c2)
                if sc < best:
                    best, cnt = sc, c2
                    st.update(new)
                    return True
                for g in gs:
                    side[g] ^= 1
                apply()
                return False
            for _ in range(10):
                improved = False
                for g in range(len(groups)):
                    if any(any(st[i]) for i in aff[g]):
                        improved |= attempt([g])
                for g in range(len(groups)):
                    if not any(any(st[i]) for i in aff[g]):
                        continue
                    for h in nbr[g]:
                        if h > g or not any(any(st[i]) for i in aff[h]):
                            improved |= attempt([g, h])
                if not improved and best:
                    for g in range(len(groups)):          # chains of three along the constraint graph
                        if not any(any(st[i]) for i in aff[g]):
                            continue
                        done = False
                        for h in nbr[g]:
                            for k in (nbr[g] | nbr[h]) - {g, h}:
                                if attempt([g, h, k]):
                                    improved = done = True
                                    break
                            if done:
                                break
                if not improved or best == 0:
                    break
            return best
        best_sc = descend()
        best_side = list(side)
        for _ in range(restarts if best_sc else 0):
            for g in range(len(groups)):
                side[g] = best_side[g] ^ (1 if rnd.random() < 0.3 else 0)
            sc = descend()
            if sc < best_sc:
                best_sc, best_side = sc, list(side)
            if best_sc == 0:
                break
        side[:] = best_side
        apply()
        return self.cost(pairs)

    def cost(self, pairs):
        c = 0
        for v in self.pvs:
            for p in pairs:
                d = self.edge_value(p.b[0], p.b[1], v) - self.edge_value(p.a[0], p.a[1], v)
                c += p.bad(d)
        return c


def by_g_neighbours(gi, by_g, pairs, gof):
    """Groups that share a constraint with group gi."""
    out = set()
    for i in by_g.get(gi, ()):
        p = pairs[i]
        for (r, s_) in (p.a, p.b):
            g = gof.get((r.id, "c" if r.kind == "cut" else s_))
            if g is not None:
                out.add(g)
    return out


def _edge_groups(rects, M):
    """Edges that must move together: same y, same layer, touching/overlapping pieces (one polygon)
    or a cut and nothing else. Only edges strictly inside a band are free."""
    items = []
    for r in rects:
        if r.fixed:
            continue
        if r.kind == "cut":
            cy = (r.y0 + r.y1) // 2
            b = M.band(cy)
            if b:
                items.append(((r.id, "c"), cy, r, b))
            continue
        for side, y in ((0, r.y0), (1, r.y1)):
            b = M.band(y)
            if b:
                items.append(((r.id, side), y, r, b))
    par = {it[0]: it[0] for it in items}

    def find(k):
        while par[k] != k:
            par[k] = par[par[k]]
            k = par[k]
        return k
    by_y = {}
    for it in items:
        by_y.setdefault((it[1], it[2].layer), []).append(it)
    for lst in by_y.values():
        for i, a in enumerate(lst):
            for b in lst[i + 1:]:
                ra, rb = a[2], b[2]
                if ra.kind == "cut" or rb.kind == "cut":
                    continue
                if min(ra.x1, rb.x1) >= max(ra.x0, rb.x0):
                    par[find(a[0])] = find(b[0])
    groups = {}
    for it in items:
        g = groups.setdefault(find(it[0]), {"keys": [], "band": it[3], "y": it[1]})
        g["keys"].append(it[0])
    for g in groups.values():
        a, b = g["band"]
        g["default"] = a if g["y"] - a <= b - g["y"] else b
    return list(groups.values())


def _expr(anchor, off):
    if not anchor or anchor == "0":
        return f"{off/1000:g}"
    if off == 0:
        return anchor
    return f"{anchor} {'+' if off > 0 else '-'} {abs(off)/1000:g}"


def _paren(e):
    return e if all(ch not in e for ch in " +-") else f"({e})"


# =============================================================================== shapes and constraints
class Rect:
    __slots__ = ("id", "x0", "y0", "x1", "y1", "layer", "kind", "net", "fixed", "name", "diff", "span", "margin")

    def __init__(self, id_, x0, y0, x1, y1, layer, kind="shape", net=None, fixed=False):
        self.id, self.x0, self.y0, self.x1, self.y1 = id_, x0, y0, x1, y1
        self.layer, self.kind, self.net, self.fixed = layer, kind, net, fixed
        self.name, self.diff, self.span, self.margin = None, None, None, None


class Pair:
    """mapped(b) - mapped(a) must satisfy the rule; a / b are (rect, side)."""
    __slots__ = ("kind", "req", "a", "b")

    def __init__(self, kind, req, a, b):
        self.kind, self.req, self.a, self.b = kind, req, a, b

    def bad(self, d):
        if self.kind == "min":
            return 1 if d < self.req else 0
        if self.kind == "gap_same":            # same net: merging is fine, a thin gap is not
            return 1 if 0 < d < self.req else 0
        if self.kind == "gap_diff":            # different nets: never closer than the rule
            return 10 if d <= 0 else (1 if d < self.req else 0)
        if self.kind == "keep":                # an overlap that carries a connection
            return 10 if d <= 0 else 0
        return 0


CONNECT = {"li", "licon", "mcon", "m1", "via", "m2", "poly", "diff"}


def build_pairs(rects):
    out = []
    for i, A in enumerate(rects):
        if A.kind not in ("cut", "array") and not A.fixed:
            out.append(Pair("min", T.rule_width(A.layer), (A, 0), (A, 1)))
        for B in rects[i + 1:]:
            if A.fixed and B.fixed:
                continue
            xo = min(A.x1, B.x1) - max(A.x0, B.x0)
            if xo <= 0:                              # side by side: keep them apart (or joined) vertically
                gx = -xo
                same_net = A.net is not None and A.net == B.net
                if A.layer == B.layer:
                    rs = T.rule_space(A.layer)
                    if gx == 0 and (same_net or A.layer in ("diff", "poly", "npc")) and A.y0 < B.y1 and B.y0 < A.y1:
                        lo = A if A.y0 >= B.y0 else B
                        hi = A if A.y1 <= B.y1 else B
                        out.append(Pair("keep", 0, (lo, 0), (hi, 1)))
                        continue
                else:
                    rs = T.rule_space(A.layer, B.layer) if not _nested(A.layer, B.layer) else 0
                    same_net = False
                if not rs or gx >= rs or same_net or A.kind == "array" or B.kind == "array":
                    continue
                need = math.ceil(math.sqrt(rs * rs - gx * gx) / 5) * 5
                for P, Q in ((A, B), (B, A)):
                    if P.y1 <= Q.y0 and Q.y0 - P.y1 <= 600:
                        out.append(Pair("min", need, (P, 1), (Q, 0)))
                continue
            for P, Q in ((A, B), (B, A)):
                if P.y1 <= Q.y0 and Q.y0 - P.y1 <= 600:          # P below Q
                    gap = Q.y0 - P.y1
                    if P.layer == Q.layer:
                        rs = T.rule_space(P.layer)
                        same = (P.net is not None and P.net == Q.net) or P.layer in ("nsdm", "psdm", "npc", "nwell")
                        if gap == 0:
                            if same or P.layer in ("diff", "poly"):
                                out.append(Pair("keep", 0, (P, 1), (Q, 0)) if False else Pair("min", 0, (Q, 0), (P, 1)))
                        elif P.kind != "array" and Q.kind != "array":
                            out.append(Pair("gap_same" if same else "gap_diff", rs, (P, 1), (Q, 0)))
                    else:
                        rs = T.rule_space(P.layer, Q.layer)
                        if rs and not _nested(P.layer, Q.layer) and P.kind != "array" and Q.kind != "array":
                            out.append(Pair("min", rs, (P, 1), (Q, 0)))
            if A.y0 < B.y1 and B.y0 < A.y1:                       # overlapping in y
                for O, I in ((A, B), (B, A)):
                    if O.x0 <= I.x0 and I.x1 <= O.x1 and I.kind != "array" and O.kind != "array":
                        e0, e1 = T.rule_enc(O.layer, I.layer)
                        if O.layer == "poly" and I.layer == "diff":
                            e0 = e1 = 0
                        if e0 or e1:
                            xenc = min(I.x0 - O.x0, O.x1 - I.x1)
                            req = e0 if xenc >= e1 else e1
                            if O.y1 >= I.y1:
                                out.append(Pair("min", req, (I, 1), (O, 1)))
                            if O.y0 <= I.y0:
                                out.append(Pair("min", req, (O, 0), (I, 0)))
                if A.kind != "array" and B.kind != "array" and (
                        A.layer == B.layer or ({A.layer, B.layer} <= CONNECT and A.net is not None and A.net == B.net)):
                    lo = A if A.y0 >= B.y0 else B           # the higher bottom edge
                    hi = A if A.y1 <= B.y1 else B           # the lower top edge
                    out.append(Pair("keep", 0, (lo, 0), (hi, 1)))
                for Pl, D in ((A, B), (B, A)):              # gate endcap: poly beyond the diffusion
                    if Pl.layer == "poly" and D.layer == "diff" and Pl.x0 > D.x0 and Pl.x1 < D.x1:
                        if Pl.y1 > D.y1:
                            out.append(Pair("min", T.EXT[("poly", "diff")], (D, 1), (Pl, 1)))
                        if Pl.y0 < D.y0:
                            out.append(Pair("min", T.EXT[("poly", "diff")], (Pl, 0), (D, 0)))
    return out


def _nested(a, b):
    return {a, b} in ({"diff", "licon"}, {"li", "licon"}, {"li", "mcon"}, {"m1", "mcon"}, {"m1", "via"},
                      {"m2", "via"}, {"npc", "licon"}, {"poly", "licon"})


# =============================================================================== lifting
def lift(short, variant="bench", spec=None, gds=HD_GDS, cell_name=None):
    """Return (icl_text, info)."""
    if spec is None:
        sys.path.insert(0, os.path.join(ROOT, "bench"))
        import hd_spec
        spec = hd_spec.spec_for(short, scale=hd_spec.SCALE if variant == "bench" else 1.0)
        if spec is None:
            raise LiftError("not expressible at level 1 (special devices or gate length)")
    src = Source(gds, PREFIX + short if gds == HD_GDS and not short.startswith(PREFIX) else short)
    if not src.reg["tap"].is_empty():
        raise LiftError("cell has its own taps (tap/decap cell)")
    ex = Extract(src)
    nets, why = match(ex, spec)
    if nets is None:
        raise LiftError(why)
    M = Mapper(src, ex, spec, variant)
    name = cell_name or spec["name"]
    H0, W0 = src.H, src.W
    notes = []

    def netname(lay, box):
        nid = ex.net_at(lay, box)
        return nets.get(nid) if nid is not None else None

    # ------------------------------------------------------------- rectangles
    rects = []

    def add(*a, **k):
        r = Rect(len(rects), *a, **k)
        rects.append(r)
        return r
    ndiff = src.reg["diff"] - src.reg["nwell"]
    for lay in ("diff", "poly", "li", "m1", "m2", "npc"):
        for p in src.reg[lay].each():
            for b in cover(p):
                if lay == "li" and b.width() >= W0 - 10 and (
                        (b.bottom >= -RAIL_LI and b.top <= RAIL_LI) or (b.bottom >= H0 - RAIL_LI and b.top <= H0 + RAIL_LI)):
                    continue                                  # the template's li rails
                if lay == "m1" and ((b.bottom >= -RAIL_M1 and b.top <= RAIL_M1) or
                                    (b.bottom >= H0 - RAIL_M1 and b.top <= H0 + RAIL_M1)):
                    continue                                  # the template's met1 rails
                kind = "shape"
                if lay == "diff":
                    kind = "ndiff" if not (kdb.Region(b) & ndiff).is_empty() else "pdiff"
                add(b.left, b.bottom, b.right, b.top, lay, kind,
                    netname(lay, b) if lay in ("li", "m1", "m2") else None)
    shapes = list(rects)
    lis = [r for r in shapes if r.layer == "li"]
    sd = (src.reg["diff"] - src.reg["poly"]).merged()
    groups = {}
    for lay in ("licon", "mcon", "via"):
        for p in src.reg[lay].each():
            b = p.bbox()
            if lay == "mcon" and variant == "bench" and (abs(b.center().y) <= RAIL_LI or abs(b.center().y - H0) <= RAIL_LI):
                continue                                      # rail mcons: the tap strips bring their own
            if lay == "licon" and not (kdb.Region(b) & sd).is_empty():
                region = next(i for i, q in enumerate(sd.each()) if not (kdb.Region(q) & kdb.Region(b)).is_empty())
                groups.setdefault((region, b.left), [None, []])[1].append(b)
            else:
                add(b.left, b.bottom, b.right, b.top, lay, "cut", netname("li" if lay != "via" else "m1", b))
    # diffusion contact columns: an array in the diffusion, limited to where its own li is
    arrays = []
    for (_, bs) in groups.values():
        bs.sort(key=lambda b: b.bottom)
        x0, x1, y0, y1 = bs[0].left, bs[0].right, bs[0].bottom, bs[-1].top
        # the diffusion rectangle holding most of the column (a stepped diffusion has several)
        cand = [r for r in shapes if r.layer == "diff" and r.x0 <= x0 and x1 <= r.x1 and r.y0 < y1 and y0 < r.y1]
        if not cand:
            raise LiftError("diffusion contact column not inside a diffusion rectangle")
        dr = max(cand, key=lambda r: (min(r.y1, y1) - max(r.y0, y0), r.y1 - r.y0))
        net = netname("li", bs[0])
        own = [r for r in lis if r.net == net and r.x0 <= x0 and x1 <= r.x1 and r.y0 < y1 and y0 < r.y1]
        lo_r = min(own, key=lambda r: r.y0) if own else None
        hi_r = max(own, key=lambda r: r.y1) if own else None
        a = add(x0, y0, x1, y1, "licon", "array", net)
        a.diff = dr
        de0, de1 = T.rule_enc("diff", "licon")
        dxenc = min(x0 - dr.x0, dr.x1 - x1)
        a.margin = de0 if dxenc >= de1 else de1             # 0.04 when the diffusion continues sideways
        if lo_r is not None:
            xenc = min(min(x0 - r.x0, r.x1 - x1) for r in own)
            yenc = 0 if xenc >= T.rule_enc("li", "licon")[1] else T.rule_enc("li", "licon")[1]
            a.span = (lo_r, hi_r, yenc)
            dm = a.margin
            need = T.CUT_SIZE["licon"]
            # the landing interval (own li within the diffusion) must hold one cut at every point
            rects_for = [((lo_r, 0), yenc), ((dr, 0), dm)]
            tops_for = [((hi_r, 1), yenc), ((dr, 1), dm)]
            for (lk, lm) in rects_for:
                for (hk, hm) in tops_for:
                    arrays.append(Pair("min", need + lm + hm, lk, hk))
        else:
            notes.append(f"contact column at x={x0/1000} has no li of its own net above it")
    if variant == "bench":                     # template shapes the cell meets (fixed to the rails)
        for y, net in ((0, "VGND"), (H0, "VPWR")):
            add(180, y - TAP_HALF, W0 - 180, y + TAP_HALF, "tap", "shape", net, fixed=True)
            add(0, y - RAIL_LI, W0, y + RAIL_LI, "li", "shape", net, fixed=True)
    pairs = build_pairs(rects) + arrays
    if variant == "bench":                     # stay clear of the in-cell tap strips (absent in the PDK cell)
        taps = [r for r in rects if r.fixed and r.layer == "tap"]
        for r in rects:
            if r.fixed or r.layer not in ("poly", "diff", "npc", "licon"):
                continue
            for t in taps:
                if min(r.x1, t.x1) <= max(r.x0, t.x0):
                    continue
                sp = {"poly": T.rule_space("poly", "tap"), "diff": DIFF_TAP, "npc": 0,
                      "licon": T.rule_space("licon", "diff")}[r.layer]
                if t.y0 < 0 and r.y0 < M.nb0:
                    pairs.append(Pair("min", sp, (t, 1), (r, 0)))
                if t.y0 > 0 and r.y1 > M.pt0:
                    pairs.append(Pair("min", sp, (r, 1), (t, 0)))
    conflicts = M.optimise(rects, pairs)
    if conflicts:
        notes.append(f"{conflicts} predicted rule conflict(s) over the sweep")

    # ------------------------------------------------------------- emit
    def xs(r):
        return f"({M.xe(r.x0)}, {M.xe(r.x1)})"

    def ys(r):
        return f"({M.edge_expr(r, 0)}, {M.edge_expr(r, 1)})"

    def cxy(r):
        cx, cy = (r.x0 + r.x1) // 2, (r.y0 + r.y1) // 2
        return f"cx={_paren(M.xe(cx))} cy={_paren(M.ye((r.id, 'c'), cy))}"

    L = []
    if variant == "hd":
        pv = M.pvs[0]
        pl = " ".join(f"{k}={pv[k]/1000:g}" for k in M.params)
    else:
        pl = " ".join(f"{k}={v}" for k, v in M.params.items())
    L.append(f"# {name}: lifted from {PREFIX}{short} by icdsl.lift ({variant} variant)")
    if variant == "bench":
        L.append("# taps in the cell, widths x0.75; x from the gate columns x1.., y from the row edges nb / pt")
    else:
        L.append("# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,")
        L.append("# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)")
    L.append("pdk sky130A")
    L.append(f"param {pl} L=0.15 H={H0/1000:g}")
    L.append("")
    L.append(f"stdcell {name} width={M.width_cols(W0)} height=H{'' if variant == 'bench' else ' taps=no'}")
    for d in spec["devices"]:
        body = "" if variant == "bench" else (" b=VNB" if d["kind"] == "nmos" else " b=VPB")
        L.append(f"  device {d['name']} {d['kind']} w={d['wparam']} l=L d={d['d']} g={d['g']} s={d['s']}{body}")
    L.append("")
    L.append("  # gate columns (left edges): every x below is measured from one of them")
    L += ["  " + s for s in M.column_defs()]
    if variant == "bench":
        L.append("  nb = ptap.top + 0.27                  # bottom of the n row")
        L.append("  pt = ntap.bottom - 0.27               # top of the p row")
    else:
        L.append(f"  nb = {M.nb0/1000:g}                          # bottom of the n row")
        L.append(f"  pt = H - {(H0 - M.pt0)/1000:g}                     # top of the p row")
    cnt = {}

    def nm_(p):
        cnt[p] = cnt.get(p, 0) + 1
        return f"{p}{cnt[p]}"
    L.append("  # diffusion")
    for r in shapes:
        if r.layer == "diff":
            r.name = nm_("nd" if r.kind == "ndiff" else "pd")
            L.append(f"  {r.name} = rect diff xspan={xs(r)} yspan={ys(r)}")
    nds = [r.name for r in shapes if r.layer == "diff" and r.kind == "ndiff"]
    pds = [r.name for r in shapes if r.layer == "diff" and r.kind == "pdiff"]
    L.append(f"  nim = enclose [{', '.join(nds)}] nsdm")
    L.append(f"  pim = enclose [{', '.join(pds)}] psdm")
    L.append("  # poly: gates, pads and jogs")
    for r in shapes:
        if r.layer == "poly":
            r.name = nm_("p")
            L.append(f"  {r.name} = rect poly xspan={xs(r)} yspan={ys(r)}")
    L.append("  # local interconnect")
    for r in shapes:
        if r.layer == "li":
            r.name = nm_("l")
            L.append(f"  {r.name} = rect li xspan={xs(r)} yspan={ys(r)}" + (f" net={r.net}" if r.net else ""))
    L.append("  # contacts: diffusion columns (as many cuts as fit where their li crosses the diffusion), gates")
    for r in rects:
        if r.kind == "array":
            cx = (r.x0 + r.x1) // 2
            net = f" net={r.net}" if r.net else ""
            if r.span:
                lo_r, hi_r, ye = r.span
                lo = M.edge_expr(lo_r, 0) + (f" + {ye/1000:g}" if ye else "")
                hi = M.edge_expr(hi_r, 1) + (f" - {ye/1000:g}" if ye else "")
                r.name = nm_("c")
                mg = "" if r.margin == max(T.rule_enc("diff", "licon")) else f" margin={r.margin/1000:g}"
                L.append(f"  {r.name} = array licon in={r.diff.name} cx={_paren(M.xe(cx))} span=({lo}, {hi}){mg}{net}")
            else:
                r.name = nm_("c")
                L.append(f"  {r.name} = array licon in={r.diff.name} cx={_paren(M.xe(cx))}{net}")
    for r in rects:
        if r.kind == "cut" and r.layer == "licon":
            r.name = nm_("gc")
            L.append(f"  {r.name} = contact licon {cxy(r)}")
    for r in shapes:
        if r.layer == "npc":
            r.name = nm_("np")
            L.append(f"  {r.name} = rect npc xspan={xs(r)} yspan={ys(r)}")
    if any(r.kind == "cut" and r.layer in ("mcon", "via") for r in rects) or any(r.layer in ("m1", "m2") for r in shapes):
        L.append("  # metal")
    for r in rects:
        if r.kind == "cut" and r.layer in ("mcon", "via"):
            r.name = nm_("mc" if r.layer == "mcon" else "v")
            L.append(f"  {r.name} = contact {r.layer} {cxy(r)}")
    for r in shapes:
        if r.layer in ("m1", "m2"):
            r.name = nm_("w")
            L.append(f"  {r.name} = rect {r.layer} xspan={xs(r)} yspan={ys(r)}" + (f" net={r.net}" if r.net else ""))
    if variant == "bench":
        L.append(f"  well y=((max({', '.join(n + '.top' for n in nds)}) + 0.34 + "
                 f"min({', '.join(p + '.bottom' for p in pds)}) - 0.18) / 2)")
    else:
        nwb = src.reg["nwell"].bbox().bottom
        k = M.knot_of(("nwell", 0), nwb) if M.band(nwb) is None else min(M.band(nwb), key=lambda k: abs(k - nwb))
        L.append(f"  well y={_paren(_expr(M.K[k][0], nwb - k))}")
    L.append("  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells")
    L.append("  # pins")
    pins, why = _pins(src, spec, M, rects, variant)
    if pins is None:
        raise LiftError(why)
    L += pins
    L.append("end")
    info = {"ok": True, "notes": notes, "cols": len(M.lefts), "width": M.width_cols(W0), "conflicts": conflicts}
    return "\n".join(L) + "\n", info


def _mapped(r, M, v):
    return (M.xv(r.x0, v), M.edge_value(r, 0, v), M.xv(r.x1, v), M.edge_value(r, 1, v))


def _gap(a, b):
    dx = max(a[0] - b[2], b[0] - a[2], 0)
    dy = max(a[1] - b[3], b[1] - a[3], 0)
    return math.hypot(dx, dy) if dx and dy else max(dx, dy)


def _pins(src, spec, M, rects, variant):
    out = []
    ports = spec["inputs"] + spec["outputs"]
    lis = [r for r in rects if r.layer == "li" and not r.fixed]
    if variant == "hd":
        for p in ports:
            dir_ = "in" if p in spec["inputs"] else "out"
            on = None
            for (t, lay, x, y) in src.labels:
                if t == p and lay == "li":
                    on = next((r for r in lis if r.x0 <= x <= r.x1 and r.y0 <= y <= r.y1 and r.net == p), None)
                    if on:
                        break
            if on is None:
                return None, f"no li shape under the label of port {p}"
            out.append(f"  port {p} {dir_} on={on.name}")
        return out, ""
    m1 = [r for r in rects if r.layer == "m1" and not r.fixed]
    mcons = [r for r in rects if r.layer == "mcon"]
    chosen = []

    def legal(cx, cy, net):
        key = ("pin", net)
        for v in M.pvs:
            X, Y = M.xv(cx, v), M.yv(key, cy, v)
            pad = (X - 145, Y - 145, X + 145, Y + 145)
            if pad[1] < RAIL_M1 + 140 or pad[3] > v["H"] - RAIL_M1 - 140:
                return False
            if not any(r.net == net and q[0] <= X - 85 and X + 85 <= q[2] and q[1] <= Y - 85 and Y + 85 <= q[3]
                       for r in lis for q in [_mapped(r, M, v)]):
                return False
            for (ocx, ocy, onet) in chosen:
                OX, OY = M.xv(ocx, v), M.yv(("pin", onet), ocy, v)
                if _gap((OX - 145, OY - 145, OX + 145, OY + 145), pad) < 140:
                    return False
            for r in m1:
                if r.net != net and _gap(_mapped(r, M, v), pad) < 140:
                    return False
            for r in mcons:
                q = _mapped(r, M, v)
                if _gap(q, (X - 85, Y - 85, X + 85, Y + 85)) < 190:
                    return False
        return True
    order = sorted(ports, key=lambda p: len([l for l in src.labels if l[0] == p]))
    mid = (M.nb0 + M.pt0) / 2
    for p in order:
        cands = [(x, y) for (t, lay, x, y) in src.labels if t == p and lay == "li"]
        for r in lis:
            if r.net == p:
                for x in range(r.x0 + 85, r.x1 - 84, 85):
                    for y in range(r.y0 + 85, r.y1 - 84, 85):
                        cands.append((x // 5 * 5, y // 5 * 5))
        cands.sort(key=lambda c: abs(c[1] - mid))
        got = None
        for (x, y) in cands:
            b = M.band(y)
            opts = [None] if b is None else sorted(b, key=lambda k: abs(k - y))
            for k in opts:
                if k is not None:
                    M.anchor[("pin", p)] = k
                if legal(x, y, p):
                    got = (x, y)
                    break
            if got:
                break
        if got is None:
            return None, f"no legal spot for the met1 pin of {p}"
        chosen.append((got[0], got[1], p))
    for (x, y, p) in sorted(chosen, key=lambda c: ports.index(c[2])):
        dir_ = "in" if p in spec["inputs"] else "out"
        n = p.lower()
        out.append(f"  {n}m = contact mcon cx={_paren(M.xe(x))} cy={_paren(M.ye(('pin', p), y))}")
        out.append(f"  {n}p = enclose {n}m m1 by=0.06 net={p}")
        out.append(f"  port {p} {dir_} on={n}p")
    return out, ""


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cell")
    ap.add_argument("--variant", default="bench", choices=["bench", "hd"])
    ap.add_argument("-o", "--out")
    a = ap.parse_args()
    txt, info = lift(a.cell, a.variant)
    if a.out:
        open(a.out, "w").write(txt)
    else:
        print(txt)
    print(info, file=sys.stderr)


if __name__ == "__main__":
    main()
