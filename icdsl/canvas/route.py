"""Trunk router: connects pins over the cells on two conductors (vertical columns + horizontal trunks).

    r = Router(top)                 # columns on tech.c2, trunks on tech.c3 (override with v=, h=)
    r.auto()                        # every net named in the conns= of the instances placed in `top`
    r.add("clk", some_rect)         # or add pins by hand
    handles = r.run()               # draws; {net: a drawn shape to hang a port on}

A pin is a horizontal strip (stick-cell ports are); the router picks a free column inside the strip,
drops a via, runs up or down to the net's trunk and vias onto it. Nets whose pins line up use one
column and no trunk; pins of one net that abut end to end on the same y are simply bridged.
Everything already drawn on the two routing layers (in this cell or below) is treated as an obstacle,
so manual wires and routed wires can be mixed. It is a helper, not a fence: `Cell.wire` / `Cell.via`
are always available for nets it cannot do.
"""
from __future__ import annotations

import math
from collections import defaultdict

from .core import Cell, Rect, CanvasError
from . import conn as _conn


def _probe(t, calls):
    c = Cell("__probe__", t)
    try:
        hw, hh = {}, {}
        for args, kw in calls:
            n0 = len(c.shapes)
            c.via(*args, at=(0, 0), **kw)
            for s in c.shapes[n0:]:
                hw[s.layer] = max(hw.get(s.layer, 0), -s.x0, s.x1)
                hh[s.layer] = max(hh.get(s.layer, 0), -s.y0, s.y1)
        return hw, hh
    finally:
        Cell.registry.pop("__probe__", None)


class _Pin(Rect):
    """A pin strip + the row it belongs to."""
    group = None


class Router:
    def __init__(self, cell, v=None, h=None, pin_layer=None):
        self.cell = cell
        t = self.t = cell.tech
        self.v, self.h = t.lname(v or t.c2), t.lname(h or t.c3)
        self.pl = t.lname(pin_layer or t.c1)
        g = t.grid
        hw, hh = _probe(t, [((self.pl, self.v), dict(dir="h", top_dir="v")),
                            ((self.v, self.h), dict(dir="v", top_dir="h"))])
        self.hw, self.hh = hw, hh
        nm = t.nm
        self.sv, self.sh = nm(t.space(self.v)), nm(t.space(self.h))
        up = lambda val, q: int(math.ceil(val / q - 1e-9)) * q
        self.pv_min = up(2 * hw[self.v] + self.sv, 2 * g)          # legal distance between two columns
        self.pv = up(self.pv_min / 4, 2 * g)                       # column grid (fine: narrow pins still get one)
        self.near = int(math.ceil(self.pv_min / self.pv - 1e-9)) - 1
        self.ocols = defaultdict(list)       # obstacles: column index -> [(y0, y1, net)]
        self.ph = up(2 * hh[self.h] + self.sh, 2 * g)
        self.pins = defaultdict(list)
        self.cols = defaultdict(list)        # column index -> [(y0, y1, net)]
        self.trks = defaultdict(list)        # track index -> [(x0, x1, net)]
        self.failed = []

    # ------------------------------------------------------------------ input
    def add(self, net, *rects, group=None):
        """Pins of a net: horizontal strips on the pin layer. group = any key; pins of one group share
        a trunk (default: grouped by height)."""
        for r in rects:
            p = _Pin(r.layer, r.x0, r.y0, r.x1, r.y1, net, r.src)
            p.group = group
            self.pins[net].append(p)
        return self

    def auto(self, refs=None, skip=None, group_rows=True):
        """Collect the pins of every instance port (supplies excepted) under its parent net name."""
        sup = self.t.d.get("supplies", {})
        skip = set(skip or ()) | {sup.get("power", "VDD"), sup.get("ground", "VSS")}
        for r in (refs if refs is not None else self.cell.refs):
            for iy in range(r.ny):
                for ix in range(r.nx):
                    for port in r.cell.port_order:
                        net = r.net_of(port, ix, iy)
                        if port in skip or net in skip:
                            continue
                        q = r.pin(port, ix, iy)
                        p = _Pin(q.layer, q.x0, q.y0, q.x1, q.y1, net, q.src)
                        p.group = (r.y0 + iy * r.dy) if group_rows else None
                        self.pins[net].append(p)
        return self

    def _obstacles(self):
        hwv, hhh = self.hw[self.v], self.hh[self.h]
        for s, net, _ in _conn.flatten(self.cell):
            if s.layer == self.v:
                k0 = int(math.ceil((s.x0 - self.sv - hwv) / self.pv + 1e-9))
                k1 = int(math.floor((s.x1 + self.sv + hwv) / self.pv - 1e-9))
                for k in range(k0, k1 + 1):
                    self.ocols[k].append((s.y0 + self.hh[self.v], s.y1 - self.hh[self.v], net or "?", s.x0, s.x1))
            elif s.layer == self.h:
                k0 = int(math.ceil((s.y0 - self.sh - hhh) / self.ph + 1e-9))
                k1 = int(math.floor((s.y1 + self.sh + hhh) / self.ph - 1e-9))
                for k in range(k0, k1 + 1):
                    self.trks[k].append((s.x0, s.x1, net or "?", s.y0, s.y1))

    # ------------------------------------------------------------------ occupancy
    # A wire may run into a shape of its own net only where one contains the other across the wire
    # (aligned or fully inside): a partial overlap or a near miss would leave a jog / notch below the
    # minimum width or spacing, so there the shape counts as an obstacle like any other net.
    def _col_free(self, k, y0, y1, net):
        e = self.hh[self.v]
        a, b = y0 - e - self.sv, y1 + e + self.sv
        for j in range(k - self.near, k + self.near + 1):
            for q0, q1, n in self.cols.get(j, ()):
                if not (n == net and j == k or q1 + e <= a or b <= q0 - e):
                    return False
        x0 = k * self.pv - self.hw[self.v]
        x1 = x0 + 2 * self.hw[self.v]
        for q0, q1, n, s0, s1 in self.ocols.get(k, ()):
            same = n == net and (s0 <= x0 and x1 <= s1 or x0 <= s0 and s1 <= x1)
            if not (same or q1 + e <= a or b <= q0 - e):
                return False
        return True

    def _trk_free(self, k, x0, x1, net):
        e = self.hw[self.h]
        a, b = x0 - e - self.sh, x1 + e + self.sh
        y0 = k * self.ph - self.hh[self.h]
        y1 = y0 + 2 * self.hh[self.h]
        for q in self.trks.get(k, ()):
            q0, q1, n = q[:3]
            same = n == net and (len(q) == 3 or q[3] <= y0 and y1 <= q[4] or y0 <= q[3] and q[4] <= y1)
            if not (same or q1 + e <= a or b <= q0 - e):
                return False
        return True

    # ------------------------------------------------------------------ planning (nothing drawn)
    def _ranges(self, net, pins):
        hwp, um = self.hw[self.pl], (lambda val: val / 1000.0)
        rng = []
        for p in pins:
            k0 = int(math.ceil((p.x0 + hwp) / self.pv - 1e-9))
            k1 = int(math.floor((p.x1 - hwp) / self.pv + 1e-9))
            if k1 < k0:
                xt = round((p.x0 + p.x1) / 2 / self.pv) * self.pv
                raise CanvasError(
                    f"router: no track fits on the pin of net {net!r} at ({um(p.x0)}, {um(p.y0)}): the pin spans x = "
                    f"{um(p.x0)} .. {um(p.x1)}, tracks are at x = k * {um(self.pv)} (the nearest at {um(xt)}), and the via on a "
                    f"track needs the pin from {um(xt - hwp)} to {um(xt + hwp)}",
                    f"make the pin at least {um(2 * hwp + self.pv)} um long in x (then a track always fits), or centre it on a track")
            rng.append((k0, k1))
        return rng

    def _plan_trunk(self, net, rng, pys, xmed, klo, khi):
        """One trunk + one column per pin: (track, [column per pin]) or None. Columns of the net are
        either the same column or a full pitch apart (their cuts must not overlap or nearly touch)."""
        ymed = sorted(pys)[len(pys) // 2]
        for kt in sorted(range(klo, khi + 1), key=lambda k: abs(k * self.ph - ymed)):
            yt = kt * self.ph
            pick, taken = [], set()
            for (k0, k1), py in zip(rng, pys):
                kk = next((k for k in sorted(range(k0, k1 + 1), key=lambda k: abs(k * self.pv - xmed))
                           if all(k == q or abs(k - q) > self.near for q in taken)
                           and self._col_free(k, min(py, yt), max(py, yt), net)), None)
                if kk is None:
                    break
                pick.append(kk)
                taken.add(kk)
            else:
                if self._trk_free(kt, min(pick) * self.pv, max(pick) * self.pv, net):
                    return kt, pick
        return None

    # ------------------------------------------------------------------ run
    def run(self, order=None):
        t, c, um = self.t, self.cell, (lambda val: val / 1000.0)
        self._obstacles()
        # wires as wide as the via pads: no notches between neighbouring pads of one net
        wv, wh = 2 * self.hw[self.v], 2 * self.hh[self.h]
        handles = {}
        nets = {}
        for net, pins in self.pins.items():
            # bridge pins of one net that sit end to end on the same strip
            pins = sorted(pins, key=lambda p: (p.y0, p.y1, p.x0))
            merged = []
            for p in pins:
                q = merged[-1] if merged else None
                if q is not None and (q.y0, q.y1, q.layer) == (p.y0, p.y1, p.layer) and \
                        p.x0 - q.x1 <= 2 * t.nm(t.space(p.layer)) + 2 * t.grid:
                    if p.x0 > q.x1:
                        c.rect(p.layer, x0=um(q.x1), x1=um(p.x0), y0=um(p.y0), y1=um(p.y1), net=net)
                    merged[-1] = _Pin(p.layer, q.x0, q.y0, max(q.x1, p.x1), q.y1, net, q.src)
                    merged[-1].group = getattr(q, "group", None)
                else:
                    merged.append(_Pin(p.layer, p.x0, p.y0, p.x1, p.y1, net, p.src))
                    merged[-1].group = getattr(p, "group", None)
            nets[net] = merged
        todo = [n for n in (order or [])] + sorted((n for n in nets if n not in (order or [])),
                                                   key=lambda n: (max(p.x1 for p in nets[n]) - min(p.x0 for p in nets[n]), n))
        allp = [p for ps in nets.values() for p in ps]
        if not allp:
            return handles
        ylo, yhi = min(p.y0 for p in allp), max(p.y1 for p in allp)
        klo, khi = int(math.floor(ylo / self.ph)) - 2, int(math.ceil(yhi / self.ph)) + 2
        cl, ch = int(math.floor(min(p.x0 for p in allp) / self.pv)) - 2, int(math.ceil(max(p.x1 for p in allp) / self.pv)) + 2

        def column(net, k, ya, yb):
            self.cols[k].append((min(ya, yb), max(ya, yb), net))
            if ya != yb:
                x = k * self.pv
                return c.rect(self.v, x0=um(x - wv // 2), x1=um(x - wv // 2 + wv), y0=um(min(ya, yb)), y1=um(max(ya, yb)),
                              net=net)

        def trunk(net, kt, ka, kb):
            x0, x1, yt = min(ka, kb) * self.pv, max(ka, kb) * self.pv, kt * self.ph
            self.trks[kt].append((x0, x1, net))
            if x1 > x0:
                return c.rect(self.h, x0=um(x0), x1=um(x1), y0=um(yt - wh // 2), y1=um(yt - wh // 2 + wh), net=net)

        def drop(net, p, py, k, kt):
            x, yt = k * self.pv, kt * self.ph
            c.via(p.layer, self.v, at=(um(x), um(py)), net=net, dir="h", top_dir="v")
            c.via(self.v, self.h, at=(um(x), um(yt)), net=net, dir="v", top_dir="h")
            column(net, k, py, yt)

        # Nets are routed one after the other, short ones first. If some find no room, everything is
        # taken back and routed again with those nets first (a few rounds): the order is the only thing
        # a sequential router can change, and it is usually enough.
        snap = (len(c.shapes), {k: list(v) for k, v in self.cols.items()}, {k: list(v) for k, v in self.trks.items()})
        for attempt in range(6):
            self.failed = []
            self._route(todo, nets, handles, klo, khi, cl, ch, column, trunk, drop)
            if not self.failed or attempt == 5:
                break
            del c.shapes[snap[0]:]
            self.cols = defaultdict(list, {k: list(v) for k, v in snap[1].items()})
            self.trks = defaultdict(list, {k: list(v) for k, v in snap[2].items()})
            handles.clear()
            todo = self.failed + [n for n in todo if n not in self.failed]
        if self.failed:
            raise CanvasError(f"router: no free column/trunk for net(s) {', '.join(self.failed)}",
                              "widen the cells (longer pin strips), add rows, or wire these nets by hand")
        return handles

    def _route(self, todo, nets, handles, klo, khi, cl, ch, column, trunk, drop):
        c, um = self.cell, (lambda val: val / 1000.0)
        for net in todo:
            pins = nets[net]
            if len(pins) == 1:
                handles[net] = pins[0]
                continue
            rng = self._ranges(net, pins)
            pys = [(p.y0 + p.y1) // 2 for p in pins]
            xmed = sorted((p.x0 + p.x1) // 2 for p in pins)[len(pins) // 2]
            # 1. all pins on one column
            a, b = max(r[0] for r in rng), min(r[1] for r in rng)
            done = False
            if a <= b:
                for k in range(a, b + 1):               # leftmost first: leaves the rest of the strip to others
                    if self._col_free(k, min(pys), max(pys), net):
                        for p, py in zip(pins, pys):
                            c.via(p.layer, self.v, at=(um(k * self.pv), um(py)), net=net, dir="h", top_dir="v")
                        handles[net] = column(net, k, min(pys), max(pys))
                        done = True
                        break
            if done:
                continue
            # 2. a trunk per row of pins, the trunks joined by one spine column
            groups = defaultdict(list)
            for i, p in enumerate(pins):
                gk = p.group if getattr(p, "group", None) is not None else pys[i] // (8 * self.ph)
                groups[gk].append(i)
            plans = []
            for gk, idx in sorted(groups.items()):
                pl = self._plan_trunk(net, [rng[i] for i in idx], [pys[i] for i in idx], xmed, klo, khi)
                if pl is None:
                    break
                plans.append((idx, pl))
            else:
                spine = None
                if len(plans) > 1:
                    kts = [pl[0] for _, pl in plans]
                    y0, y1 = min(kts) * self.ph, max(kts) * self.ph
                    for k in sorted(range(cl, ch + 1), key=lambda k: abs(k * self.pv - xmed)):
                        if not self._col_free(k, y0, y1, net):
                            continue
                        if any(k != q and abs(k - q) <= self.near for _, (_, pick) in plans for q in pick):
                            continue                    # two cuts of one net closer than a pitch would merge
                        if all(self._trk_free(kt, min(pick + [k]) * self.pv, max(pick + [k]) * self.pv, net)
                               for _, (kt, pick) in plans):
                            spine = k
                            break
                if len(plans) == 1 or spine is not None:
                    for idx, (kt, pick) in plans:
                        for i, k in zip(idx, pick):
                            drop(net, pins[i], pys[i], k, kt)
                        ks = pick + ([spine] if spine is not None else [])
                        h_ = trunk(net, kt, min(ks), max(ks))
                        if spine is not None:
                            c.via(self.v, self.h, at=(um(spine * self.pv), um(kt * self.ph)), net=net, dir="v", top_dir="h")
                        handles.setdefault(net, h_ or pins[0])
                    if spine is not None:
                        kts = [pl[0] for _, pl in plans]
                        column(net, spine, min(kts) * self.ph, max(kts) * self.ph)
                    done = True
            if not done:
                # 3. one trunk for the whole net
                pl = self._plan_trunk(net, rng, pys, xmed, klo, khi)
                if pl is not None:
                    kt, pick = pl
                    for p, py, k in zip(pins, pys, pick):
                        drop(net, p, py, k, kt)
                    handles[net] = trunk(net, kt, min(pick), max(pick)) or pins[0]
                    done = True
            if not done:
                self.failed.append(net)
