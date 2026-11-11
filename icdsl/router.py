"""Constraint-aware geometric maze router (library: route).

Search runs on a grid of nodes (default pitch 0.46 um) over the routing layers,
but legality is decided on real geometry: every candidate wire segment, landing
pad and cut is checked against the actual shapes already in the layout with the
spacing that applies to that pair of nets (rule minimum, a per-net `space=`, or a
pairwise keep-away from `avoid=`). Wide wires, keep-aways and mixed widths are
therefore DRC-correct by construction.

Supported per-net constraints (NetSpec):
  layers, width (per layer), space, avoid {net: dist}, prefer {layer: cost factor},
  maxres (ohm), shield (net used for parallel shield wires), symmetric partner.
"""
from __future__ import annotations

import heapq
import itertools
import time
from collections import defaultdict
from dataclasses import dataclass, field

from . import tech as T
from .geom import Rect, Shape, rect_c

G = T.GRID
COND = T.STACK                      # li, m1..m4
CUT_LAYERS = ("licon", "mcon", "via", "via2", "via3")


class RouteError(Exception):
    def __init__(self, msg, net=None, detail=None):
        super().__init__(msg)
        self.net, self.detail = net, detail or {}


# ------------------------------------------------------------------ data
@dataclass
class Access:
    c: int
    r: int
    layer: str          # routing layer the path starts/ends on
    stack: tuple = ()   # cuts to place at the node going up from the pin layer
    pin_layer: str = ""
    patch: Rect = None  # extra metal on the pin layer bridging an off-grid pin to the node
    stub: tuple = ()    # off-grid access: (px, py, [(layer, Rect), ...]) contact on the pin + stub to node


@dataclass
class PinGroup:
    net: str
    name: str
    access: list
    shapes: list = field(default_factory=list)


@dataclass
class NetSpec:
    net: str
    layers: list = field(default_factory=lambda: ["m1", "m2"])
    width: dict = field(default_factory=dict)       # layer -> nm
    space: int = 0                                   # min spacing to any other net (nm)
    avoid: dict = field(default_factory=dict)        # net -> nm
    prefer: dict = field(default_factory=dict)       # layer -> cost multiplier
    maxres: float | None = None
    shield: str | None = None
    via_weight: float = 1.0
    width_fixed: bool = False      # width given explicitly: maxres may not widen it
    line: int = 0

    def w(self, layer):
        return max(self.width.get(layer, 0), T.rule_width(layer))


@dataclass
class NetRoute:
    net: str
    segs: list = field(default_factory=list)     # (layer, (x0,y0), (x1,y1), width)  nm
    cuts: list = field(default_factory=list)     # (cut, x, y)
    shapes: list = field(default_factory=list)
    nodes: set = field(default_factory=set)      # (c, r, layer)
    pins_used: list = field(default_factory=list)  # (x, y) of pin landings

    def length(self, layer=None):
        return sum(abs(b[0] - a[0]) + abs(b[1] - a[1]) for (l, a, b, w) in self.segs if layer in (None, l))


class SpatialIndex:
    def __init__(self, bucket=2000):
        self.b = bucket
        self.cells = defaultdict(list)

    def _keys(self, r):
        b = self.b
        for bx in range(r.x0 // b, r.x1 // b + 1):
            for by in range(r.y0 // b, r.y1 // b + 1):
                yield (bx, by)

    def add(self, s):
        for k in self._keys(s.rect):
            self.cells[k].append(s)

    def remove(self, shape):
        for k in self._keys(shape.rect):
            lst = self.cells.get(k)
            if lst:
                self.cells[k] = [x for x in lst if x is not shape]

    def remove_net(self, net):
        for k in list(self.cells):
            self.cells[k] = [s for s in self.cells[k] if s.net != net]

    def query(self, r):
        seen = set()
        for k in self._keys(r):
            for s in self.cells.get(k, ()):
                if id(s) not in seen:
                    seen.add(id(s))
                    yield s


def cheb_gap(a, b):
    dx = max(b.x0 - a.x1, a.x0 - b.x1, 0)
    dy = max(b.y0 - a.y1, a.y0 - b.y1, 0)
    return max(dx, dy)


def fill_rect(a, b):
    """Rectangle closing the gap between two rects whose projections overlap on one axis."""
    ox0, ox1 = max(a.x0, b.x0), min(a.x1, b.x1)
    oy0, oy1 = max(a.y0, b.y0), min(a.y1, b.y1)
    if ox0 < ox1:                                   # stacked vertically
        y0, y1 = min(a.y1, b.y1), max(a.y0, b.y0)
        return Rect(ox0, y0, ox1, y1) if y0 < y1 else None
    if oy0 < oy1:                                   # side by side
        x0, x1 = min(a.x1, b.x1), max(a.x0, b.x0)
        return Rect(x0, oy0, x1, oy1) if x0 < x1 else None
    return None


def _touch(a, b):
    return a.x0 <= b.x1 and b.x0 <= a.x1 and a.y0 <= b.y1 and b.y0 <= a.y1


# ------------------------------------------------------------------ router
class Router:
    def __init__(self, region: Rect, grid=G, layers=("m1", "m2")):
        self.G = grid
        self.region = region
        self.c0, self.c1 = -(-region.x0 // grid), region.x1 // grid
        self.r0, self.r1 = -(-region.y0 // grid), region.y1 // grid
        self.layers = [l for l in T.ROUTE_LAYERS if l in layers]
        bucket = max(500, 4 * grid)
        self.idx = {l: SpatialIndex(bucket) for l in list(COND) + list(CUT_LAYERS)}
        self.pair = {}
        self._maxpair = 0
        self.routes = {}
        self.penalty = defaultdict(set)      # (c, r) -> nets whose m1 access nodes are here
        self.neck = set()                    # grid nodes near the routed net's pins: wide wires neck down
        self.reserved = {}                   # net -> reserved landing shapes (pin access first)
        self.reserve_live = set()
        self.notes = []

    # ---------------------------------------------------------- shapes
    def add_shape(self, s: Shape):
        if s.layer in self.idx:
            self.idx[s.layer].add(s)

    def set_avoid(self, a, b, d):
        k = frozenset((a, b))
        self.pair[k] = max(self.pair.get(k, 0), d)
        self._maxpair = max(self._maxpair, d)

    def _req(self, layer, net, other, spec):
        s = T.rule_space(layer)
        if other is not None and other != net:
            s = max(s, self.pair.get(frozenset((net, other)), 0))
            if spec:
                s = max(s, spec.space, spec.avoid.get(other, 0))
        return s

    def clear(self, net, layer, rect, spec=None, ignore=(), pin=False):
        """True if a conductor rect of `net` on `layer` is legal against everything placed.

        Pairwise keep-aways (avoid/keepout/space) apply to wires and vias, not to pin landings:
        `pin=True` (or an existing shape tagged 'pinpad') only needs the design-rule spacing."""
        base = T.rule_space(layer)
        extra = 0 if pin else max(spec.space if spec else 0,
                                  max(spec.avoid.values(), default=0) if spec else 0, self._maxpair)
        maxs = max(base, extra)
        fills = []
        for s in self.idx[layer].query(rect.bloat(maxs)):
            g = cheb_gap(rect, s.rect)
            if g >= maxs:
                continue                    # quick reject
            if ignore and id(s) in ignore:
                continue
            if s.net == net and net is not None:
                if "reserve" in s.kinds:
                    continue                # our own reserved landing
                if 0 < g < base:
                    f = fill_rect(rect, s.rect)
                    if f is None:
                        return False        # diagonal near-miss: not fillable
                    fills.append(f)
                continue
            if g < base:
                return False
            if extra > base and not pin and "pinpad" not in s.kinds:
                req = self._req(layer, net, s.net, spec)
                if g < req and not self._near_pin(rect, layer, (net, s.net), req):
                    return False
        for f in fills:                     # notch fills must themselves be legal
            for s in self.idx[layer].query(f.bloat(base)):
                if s.net != net and cheb_gap(f, s.rect) < base:
                    return False
        return True

    def notch_fills(self, net, layer, shapes):
        """Metal that closes same-net gaps narrower than the spacing rule."""
        out = []
        sp = T.rule_space(layer)
        for a in shapes:
            for s in self.idx[layer].query(a.rect.bloat(sp)):
                if s.net == net and s is not a and "reserve" not in s.kinds:
                    g = cheb_gap(a.rect, s.rect)
                    if 0 < g < sp:
                        f = fill_rect(a.rect, s.rect)
                        if f is not None:
                            out.append(Shape(layer, f, net, f"route:{net}"))
        return out

    def _near_pin(self, rect, layer, nets, d):
        for L in {layer, "m1"}:
            for s in self.idx[L].query(rect.bloat(d)):
                if "pinpad" in s.kinds and s.net in nets and cheb_gap(rect, s.rect) < d:
                    return True
        return False

    def clear_cut(self, net, cut, rect):
        sp = T.rule_space(cut)
        for s in self.idx[cut].query(rect.bloat(sp)):
            if s.net == net and s.rect == rect:
                continue
            if cheb_gap(rect, s.rect) < sp:
                return False
        return True

    def blocker(self, net, layer, rect, spec=None, pin=False):
        """Describe what blocks a rect (for error messages)."""
        maxs = 3000
        best = None
        for s in self.idx[layer].query(rect.bloat(maxs)):
            if s.net == net:
                continue
            g = cheb_gap(rect, s.rect)
            req = T.rule_space(layer) if (pin or "pinpad" in s.kinds) else self._req(layer, net, s.net, spec)
            if g < req and (best is None or g < best[0]):
                best = (g, req, s)
        return best

    # ---------------------------------------------------------- pin access reservation
    def landing(self, net, acc, spec):
        """Metal a route would put down to land on a pin through this access point."""
        x, y = self.xy(acc.c, acc.r)
        if acc.stub:
            return list(acc.stub[2])
        out = []
        lay = acc.pin_layer
        for cut in acc.stack:
            up = T.STACK[T.STACK.index(lay) + 1]
            out.append((up, self.pad(up, cut, x, y, spec.w(up) if up in T.ROUTE_LAYERS else 0)))
            lay = up
        return out

    def reserve_access(self, pins, nets, spec_for):
        """Pin access first: before any wire goes down, keep one legal landing per pin group,
        so an early net cannot take the only spot where a later net can contact its pin."""
        self.release_all()
        self.reserved = {}
        work = []
        for n in nets:
            sp = spec_for(n)
            for g in pins.get(n, []):
                if g.access and any(a.stack or a.stub for a in g.access):
                    work.append((n, g, sp))

        def legal(n, g, sp):
            return [a for a in g.access if a.layer in sp.layers and (a.stack or a.stub)
                    and self.stack_ok(n, a, sp)]
        work.sort(key=lambda t: len(legal(*t)))
        for n, g, sp in work:
            cand = legal(n, g, sp)
            if not cand:
                continue
            bx = [s.rect for s in g.shapes] or [rect_c(*self.xy(a.c, a.r), 1, 1) for a in cand]
            cx = (min(r.x0 for r in bx) + max(r.x1 for r in bx)) / 2
            cy = (min(r.y0 for r in bx) + max(r.y1 for r in bx)) / 2

            def score(a):
                x, y = self.xy(a.c, a.r)
                return (a.stub is not None, abs(x - cx) + abs(y - cy))
            a = min(cand, key=score)
            for (l, r) in self.landing(n, a, sp):
                sh = Shape(l, r, n, f"reserve:{n}", ("pinpad", "reserve"))
                self.reserved.setdefault(n, []).append(sh)
                self.add_shape(sh)           # later picks must respect this one
            self.reserve_live.add(n)

    def hold(self, net):
        if net in self.reserved and net not in self.reserve_live:
            for sh in self.reserved[net]:
                self.add_shape(sh)
            self.reserve_live.add(net)

    def release(self, net):
        if net in self.reserve_live:
            for sh in self.reserved.get(net, ()):
                self.idx[sh.layer].remove(sh)
            self.reserve_live.discard(net)

    def release_all(self):
        for n in list(self.reserve_live):
            self.release(n)

    # ---------------------------------------------------------- geometry helpers
    def xy(self, c, r):
        return c * self.G, r * self.G

    def seg_rect(self, a, b, w):
        (x0, y0), (x1, y1) = a, b
        return Rect(min(x0, x1) - w // 2, min(y0, y1) - w // 2, max(x0, x1) + w - w // 2, max(y0, y1) + w - w // 2)

    def pad(self, layer, cut, x, y, w=0):
        s = max(T.pad_size(layer, cut), w)
        s += s % 10   # keep centre on 5 nm grid
        return rect_c(x, y, s, s)

    def cut_rect(self, cut, x, y):
        return rect_c(x, y, T.CUT_SIZE[cut], T.CUT_SIZE[cut])

    def via_ok(self, net, c, r, lo, hi, spec):
        cut = T.cut_between(lo, hi)
        x, y = self.xy(c, r)
        wl = self._w(spec, lo, (c, r)) if lo in T.ROUTE_LAYERS else 0
        return (self.clear_cut(net, cut, self.cut_rect(cut, x, y)) and
                self.clear(net, lo, self.pad(lo, cut, x, y, wl), spec) and
                self.clear(net, hi, self.pad(hi, cut, x, y, self._w(spec, hi, (c, r))), spec))

    def stack_ok(self, net, acc, spec):
        x, y = self.xy(acc.c, acc.r)
        if acc.stub:
            px, py, shapes = acc.stub
            if acc.stack and not self.clear_cut(net, acc.stack[0], self.cut_rect(acc.stack[0], px, py)):
                return False
            for (l, r) in shapes:
                if not self.clear(net, l, r, spec, pin=True):
                    return False
            return True
        lay = acc.pin_layer
        for cut in acc.stack:
            up = T.STACK[T.STACK.index(lay) + 1]
            if not self.clear_cut(net, cut, self.cut_rect(cut, x, y)):
                return False
            if lay != "li" and not self.clear(net, lay, self.pad(lay, cut, x, y), spec, pin=True):
                return False
            if not self.clear(net, up, self.pad(up, cut, x, y, self._w(spec, up, (acc.c, acc.r))
                                                if up in T.ROUTE_LAYERS else 0), spec, pin=True):
                return False
            lay = up
        if acc.patch is not None and not self.clear(net, acc.pin_layer, acc.patch, spec, pin=True):
            return False
        if not acc.stack:
            w = self._w(spec, acc.layer, (acc.c, acc.r))
            return self.clear(net, acc.layer, rect_c(x, y, w, w), spec, pin=True)
        return True

    # ---------------------------------------------------------- pin access
    def access_for(self, net, shape, layers):
        """Grid nodes from which a path on `layers` can connect to `shape`."""
        pl = shape.layer
        r = shape.rect
        out = []
        allowed = [l for l in T.ROUTE_LAYERS if l in layers]
        if not allowed:
            return out
        if pl in allowed:
            land, stack = pl, ()
        else:
            i0 = T.STACK.index(pl)
            land = next((l for l in allowed if T.STACK.index(l) > i0), None)
            if land is None:
                return out
            stack = tuple(T.cut_between(T.STACK[i], T.STACK[i + 1]) for i in range(i0, T.STACK.index(land)))
        for c in range(max(self.c0, -(-r.x0 // self.G)), min(self.c1, r.x1 // self.G) + 1):
            for rr in range(max(self.r0, -(-r.y0 // self.G)), min(self.r1, r.y1 // self.G) + 1):
                x, y = self.xy(c, rr)
                if stack:
                    cr = self.cut_rect(stack[0], x, y)
                    if pl == "li":
                        if not r.contains(cr):
                            continue
                    elif not r.contains_pt(x, y):
                        continue
                else:
                    # a wire leaving this node must stay inside the pin: no slivers / tiny steps
                    hw = T.rule_width(pl) // 2
                    if not (r.x0 + hw <= x <= r.x1 - hw and r.y0 + hw <= y <= r.y1 - hw):
                        continue
                out.append(Access(c, rr, land, stack, pl))
        if out:
            return out
        # off-grid pin, option 1: contact on the pin itself + short stub on the landing layer to a node
        if len(stack) <= 1:
            cs = T.CUT_SIZE[stack[0]] // 2 if stack else T.rule_width(land) // 2
            if r.w >= 2 * cs and r.h >= 2 * cs:
                ww = T.rule_width(land)
                pad = T.pad_size(land, stack[0]) if stack else ww
                for c in range(max(self.c0, -(-(r.x0 - self.G) // self.G)), min(self.c1, (r.x1 + self.G) // self.G) + 1):
                    for rr in range(max(self.r0, -(-(r.y0 - self.G) // self.G)), min(self.r1, (r.y1 + self.G) // self.G) + 1):
                        x, y = self.xy(c, rr)
                        px = min(max(x, r.x0 + cs), r.x1 - cs)
                        py = min(max(y, r.y0 + cs), r.y1 - cs)
                        px -= px % 5
                        py -= py % 5
                        shapes = [(land, rect_c(px, py, pad + pad % 10, pad + pad % 10))]
                        if px != x:
                            shapes.append((land, self.seg_rect((px, py), (x, py), ww)))
                        if py != y:
                            shapes.append((land, self.seg_rect((x, py), (x, y), ww)))
                        out.append(Access(c, rr, land, stack, pl, None, (px, py, shapes)))
                if out:
                    return out
        # off-grid pin, option 2: land on a nearby node and bridge to the pin with a patch on its own layer
        h = max(T.rule_width(pl), 140) // 2
        h += h % 5
        g2 = self.G
        for c in range(max(self.c0, -(-(r.x0 - g2) // self.G)), min(self.c1, (r.x1 + g2) // self.G) + 1):
            for rr in range(max(self.r0, -(-(r.y0 - g2) // self.G)), min(self.r1, (r.y1 + g2) // self.G) + 1):
                x, y = self.xy(c, rr)
                if stack:
                    e = 0 if pl == "li" else T.rule_enc(pl, stack[0])[1]
                    cr = self.cut_rect(stack[0], x, y).bloat(e)
                else:
                    cr = rect_c(x, y, 2 * h, 2 * h)
                px = min(max(x, r.x0 + h), r.x1 - h) if r.w >= 2 * h else r.cx
                py = min(max(y, r.y0 + h), r.y1 - h) if r.h >= 2 * h else r.cy
                patch = cr.union(Rect(px - h, py - h, px + h, py + h))
                if patch.w > 3 * self.G or patch.h > 3 * self.G:
                    continue
                out.append(Access(c, rr, land, stack, pl, patch))
        return out

    # ---------------------------------------------------------- search
    def _cost(self, layer, horiz, spec):
        pref = T.PREFERRED.get(layer, "h")
        base = 1.0 if (pref == "h") == horiz else 1.6
        if layer == "m1":
            base = 1.0 if horiz else 1.15
        return base * spec.prefer.get(layer, 1.0)

    def _w(self, spec, layer, *nodes):
        """Wire width on a layer; minimum width near the net's own pins (neck-down of wide wires)."""
        if self.neck and any((n[0], n[1]) in self.neck for n in nodes):
            return T.rule_width(layer)
        return spec.w(layer)

    def _search(self, net, spec, sources, targets, extra=None, max_expand=None):
        if max_expand is None:
            max_expand = getattr(self, "max_expand", 400000)
        if getattr(self, "deadline", None) and time.monotonic() > self.deadline:
            raise RouteError(f"net '{net}': routing time budget exhausted", net)
        layers = [l for l in self.layers if l in spec.layers]
        li = {l: i for i, l in enumerate(layers)}
        tl = list(targets)
        via_cost = 3.0 * spec.via_weight

        def h(n):
            return min(abs(n[0] - t[0]) + abs(n[1] - t[1]) + via_cost * abs(li.get(n[2], 0) - li.get(t[2], 0))
                       for t in tl)

        cache = {}
        wide = spec.w("m1") > T.rule_width("m1") + 60

        def step_ok(a, b, L):
            k = (a, b, L)
            if k not in cache:
                w = self._w(spec, L, a, b)
                rect = self.seg_rect(self.xy(*a), self.xy(*b), w)
                ok = self.clear(net, L, rect, spec)
                if ok and extra:
                    ok = extra("seg", L, rect)
                cache[k] = ok
            return cache[k]

        def via_ok(c, r, lo, hi):
            k = ("v", c, r, lo, hi)
            if k not in cache:
                ok = self.via_ok(net, c, r, lo, hi, spec)
                if ok and extra:
                    x, y = self.xy(c, r)
                    cut = T.cut_between(lo, hi)
                    ok = extra("via", lo, self.pad(lo, cut, x, y)) and extra("via", hi, self.pad(hi, cut, x, y))
                cache[k] = ok
            return cache[k]

        cnt = itertools.count()
        openq, g, parent = [], {}, {}
        for s, g0 in sources.items():
            if s[2] not in li:
                continue
            g[s] = g0
            parent[s] = None
            heapq.heappush(openq, (g0 + h(s), next(cnt), s))
        n_exp = 0
        while openq:
            f, _, n = heapq.heappop(openq)
            if f - h(n) > g.get(n, 1e18) + 1e-9:
                continue
            if n in targets:
                path = [n]
                while parent[path[-1]] is not None:
                    path.append(parent[path[-1]])
                return path[::-1]
            n_exp += 1
            if n_exp > max_expand:
                break
            c, r, L = n
            par = parent[n]
            for dc, dr in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                m = (c + dc, r + dr, L)
                if not (self.c0 <= m[0] <= self.c1 and self.r0 <= m[1] <= self.r1):
                    continue
                if not step_ok((c, r), (m[0], m[1]), L):
                    continue
                w = self._cost(L, dc != 0, spec)
                if par is not None and par[2] == L and (par[0] - c, par[1] - r) not in ((-dc, -dr),):
                    w += 0.3      # bend penalty
                if L == "m1":
                    if (self.penalty.get((m[0], m[1])) or set()) - {net}:
                        w += 8.0                 # don't sit on other nets' pin contacts
                    elif wide:
                        for q in ((m[0] + 1, m[1]), (m[0] - 1, m[1]), (m[0], m[1] + 1), (m[0], m[1] - 1)):
                            if (self.penalty.get(q) or set()) - {net}:
                                w += 3.0         # a wide wire next to a contact point blocks it
                                break
                ng = g[n] + w
                if ng < g.get(m, 1e18):
                    g[m] = ng
                    parent[m] = n
                    heapq.heappush(openq, (ng + h(m), next(cnt), m))
            i = layers.index(L)
            for j in (i - 1, i + 1):
                if 0 <= j < len(layers) and abs(T.STACK.index(layers[j]) - T.STACK.index(L)) == 1:
                    lo, hi = sorted((L, layers[j]), key=T.STACK.index)
                    if not via_ok(c, r, lo, hi):
                        continue
                    m = (c, r, layers[j])
                    ng = g[n] + via_cost
                    if ng < g.get(m, 1e18):
                        g[m] = ng
                        parent[m] = n
                        heapq.heappush(openq, (ng + h(m), next(cnt), m))
        return None

    # ---------------------------------------------------------- commit
    def _commit(self, nr, spec, path, start_acc, end_acc, extra_shapes=None):
        net = nr.net
        new = []

        def add(layer, rect, pinpad=False):
            s = Shape(layer, rect, net, f"route:{net}", ("pinpad",) if pinpad else ())
            new.append(s)

        for acc in (start_acc, end_acc):
            if acc is None:
                continue
            x, y = self.xy(acc.c, acc.r)
            lay = acc.pin_layer
            if acc.stub:
                px, py, shapes = acc.stub
                if acc.stack:
                    add(acc.stack[0], self.cut_rect(acc.stack[0], px, py), True)
                    nr.cuts.append((acc.stack[0], px, py))
                for (l, r) in shapes:
                    add(l, r, True)
                nr.pins_used.append((x, y, acc.layer))
                continue
            if acc.patch is not None:
                add(acc.pin_layer, acc.patch, True)
            for cut in acc.stack:
                up = T.STACK[T.STACK.index(lay) + 1]
                add(cut, self.cut_rect(cut, x, y), True)
                if lay != "li":
                    add(lay, self.pad(lay, cut, x, y), True)
                add(up, self.pad(up, cut, x, y, self._w(spec, up, (acc.c, acc.r)) if up in T.ROUTE_LAYERS else 0),
                    True)
                nr.cuts.append((cut, x, y))
                lay = up
            nr.pins_used.append((x, y, acc.layer))
            if not acc.stack:
                w = self._w(spec, acc.layer, (acc.c, acc.r))
                add(acc.layer, rect_c(x, y, w + (w % 10), w + (w % 10)))
        # segments: merge collinear runs
        i = 0
        while i < len(path) - 1:
            a = path[i]
            if path[i + 1][2] != a[2]:
                lo, hi = sorted((a[2], path[i + 1][2]), key=T.STACK.index)
                cut = T.cut_between(lo, hi)
                x, y = self.xy(a[0], a[1])
                add(cut, self.cut_rect(cut, x, y))
                add(lo, self.pad(lo, cut, x, y, self._w(spec, lo, a)))
                add(hi, self.pad(hi, cut, x, y, self._w(spec, hi, a)))
                nr.cuts.append((cut, x, y))
                i += 1
                continue
            j = i + 1
            d = (path[j][0] - a[0], path[j][1] - a[1])
            w = self._w(spec, a[2], a, path[j])
            while j + 1 < len(path) and path[j + 1][2] == a[2] and \
                    (path[j + 1][0] - path[j][0], path[j + 1][1] - path[j][1]) == d and \
                    self._w(spec, a[2], path[j], path[j + 1]) == w:
                j += 1
            b = path[j]
            pa, pb = self.xy(a[0], a[1]), self.xy(b[0], b[1])
            add(a[2], self.seg_rect(pa, pb, w))
            nr.segs.append((a[2], pa, pb, w))
            i = j
        for p in path:
            nr.nodes.add(p)
        for s in new:
            self.add_shape(s)
        frontier = list(new)
        seen = {(x.layer, x.rect) for x in new}
        for _ in range(3):                  # close notches created by wide / jogging wires
            fills = []
            for L in T.ROUTE_LAYERS:
                for f in self.notch_fills(net, L, [x for x in frontier if x.layer == L]):
                    k = (f.layer, f.rect)
                    if k in seen or any(s.net == net and s.rect.contains(f.rect)
                                        for s in self.idx[L].query(f.rect)):
                        continue
                    seen.add(k)
                    fills.append(f)
            if not fills:
                break
            for f in fills:
                self.add_shape(f)
            new += fills
            frontier = fills
        nr.shapes += new
        return new

    # ---------------------------------------------------------- nets
    def route(self, net, groups, spec):
        nr = self.routes.get(net) or NetRoute(net)
        self.routes[net] = nr
        groups = [g for g in groups if g.access or g.shapes]
        if len(groups) < 2:
            return nr
        self.neck = set()
        maxw = max((spec.w(l) - T.rule_width(l) for l in spec.layers if l in T.ROUTE_LAYERS), default=0)
        if maxw > 0:
            k = -(-(max(spec.w(l) for l in spec.layers if l in T.ROUTE_LAYERS) // 2 + 300) // self.G)
            for g in groups:
                for a in g.access:
                    for dc in range(-k, k + 1):
                        for dr in range(-k, k + 1):
                            self.neck.add((a.c + dc, a.r + dr))
        try:
            return self._route_groups(net, nr, groups, spec)
        finally:
            self.neck = set()

    def _route_groups(self, net, nr, groups, spec):
        acc = []
        for g in groups:
            cand = g.access
            if g.shapes:
                cand = []
                for sh in g.shapes:
                    cand += self.access_for(net, sh, spec.layers)
            pts = [a for a in cand if a.layer in spec.layers and self.stack_ok(net, a, spec)]
            if not pts:
                why = ""
                if cand:
                    a = cand[0]
                    x, y = self.xy(a.c, a.r)
                    b = self.blocker(net, a.layer, self.pad(a.layer, a.stack[-1], x, y) if a.stack else
                                     rect_c(x, y, 300, 300), spec, pin=True)
                    if b:
                        why = f" (blocked by {b[2].owner or b[2].net} on {a.layer}: {b[0]/1000:.3f} < {b[1]/1000:.3f} um)"
                raise RouteError(f"net '{net}': pin {g.name} has no legal access point{why}", net, {"pin": g.name})
            acc.append(pts)
        order = sorted(range(len(groups)), key=lambda i: len(acc[i]))
        start = order[0]
        tree = {}
        src_acc = {}
        for a in acc[start]:
            k = (a.c, a.r, a.layer)
            tree[k] = 1.0 if a.stack else 0.0
            src_acc[k] = a
        connected = {start}
        first = True
        while len(connected) < len(groups):
            targets = {}
            for i in range(len(groups)):
                if i not in connected:
                    for a in acc[i]:
                        targets.setdefault((a.c, a.r, a.layer), (i, a))
            path = self._search(net, spec, tree, targets)
            if path is None:
                missing = [groups[i].name for i in range(len(groups)) if i not in connected]
                raise RouteError(f"net '{net}': no legal path to {', '.join(missing)}", net, {"unreached": missing})
            sa = src_acc.get(path[0]) if first or path[0] in src_acc else None
            gi, ea = targets[path[-1]]
            self._commit(nr, spec, path, sa, ea)
            if first:
                # the start group is now anchored; forget its unused access points
                tree = {k: 0.0 for k in tree if k == path[0]}
                src_acc = {}
                first = False
            for p in path:
                tree[p] = 0.0
            connected.add(gi)
        return nr

    def route_symmetric(self, netA, groupsA, netB, groupsB, axis2, spec_a, spec_b):
        """Route netA, and netB as its mirror image about x = axis2/2 (axis2 = 2*axis in nm)."""
        if axis2 % self.G:
            raise RouteError(f"symmetry axis x={axis2/2000:.3f} um must be on the routing grid or half-grid")

        def mc(c):
            return (axis2 // self.G) - c

        accB = {}
        for gi, g in enumerate(groupsB):
            for a in g.access:
                accB[(a.c, a.r, a.layer)] = (gi, a)
        corr = []
        for g in groupsA:
            hits = [accB.get((mc(a.c), a.r, a.layer)) for a in g.access]
            hits = [h for h in hits if h]
            if not hits:
                raise RouteError(f"pins of '{netB}' are not mirror images of '{netA}' pin {g.name} about "
                                 f"x={axis2/2000:.3f} um", netA)
            corr.append(hits[0][0])
        ax = axis2 // 2
        s_ab = max(T.rule_space("m1"), self.pair.get(frozenset((netA, netB)), 0))

        def extra(kind, layer, rect):
            m = Rect(axis2 - rect.x1, rect.y0, axis2 - rect.x0, rect.y1)
            if not self.clear(netB, layer, m, spec_b):
                return False
            # A and its mirror must keep spacing across the axis
            gap = 2 * max(rect.x0 - ax, ax - rect.x1, 0)
            return gap >= s_ab

        # restrict A's groups to access points whose mirror is a B access point
        ga = []
        for g in groupsA:
            ga.append(PinGroup(g.net, g.name, [a for a in g.access if (mc(a.c), a.r, a.layer) in accB], g.shapes))
        saved = self._search
        self._search = lambda net, spec, s, t, extra_=None, **k: saved(net, spec, s, t, extra)
        try:
            nra = self.route(netA, ga, spec_a)
        finally:
            self._search = saved
        nrb = self.routes.get(netB) or NetRoute(netB)
        self.routes[netB] = nrb
        new = []
        for s in nra.shapes:
            r = s.rect
            new.append(Shape(s.layer, Rect(axis2 - r.x1, r.y0, axis2 - r.x0, r.y1), netB, f"route:{netB}"))
        for (l, a, b, w) in nra.segs:
            nrb.segs.append((l, (axis2 - a[0], a[1]), (axis2 - b[0], b[1]), w))
        nrb.cuts += [(c, axis2 - x, y) for (c, x, y) in nra.cuts]
        nrb.pins_used += [(axis2 - x, y, l) for (x, y, l) in nra.pins_used]
        for s in new:
            self.add_shape(s)
        nrb.shapes += new
        return nra, nrb

    def ripup(self, net):
        for l in self.idx:
            keep = defaultdict(list)
            for k, v in self.idx[l].cells.items():
                keep[k] = [s for s in v if not ((s.net == net and s.owner.startswith("route:"))
                                                or s.owner == f"shield:{net}")]
            self.idx[l].cells = keep
        self.routes.pop(net, None)

    def add_wire(self, net, layer, pts, width, spec, owner):
        """Manual wire through grid-snapped points; returns (shapes, problem-or-None)."""
        nr = self.routes.get(net) or NetRoute(net)
        self.routes[net] = nr
        new = []
        for a, b in zip(pts, pts[1:]):
            if a[0] != b[0] and a[1] != b[1]:
                return [], f"segment {a}->{b} is not horizontal or vertical"
            r = self.seg_rect(a, b, width)
            if not self.clear(net, layer, r, spec):
                bl = self.blocker(net, layer, r, spec)
                what = f"{bl[2].owner or bl[2].net} ({bl[2].net})" if bl else "?"
                gap = f"{bl[0]/1000:.3f} um, needs {bl[1]/1000:.3f}" if bl else ""
                return [], f"segment ({a[0]/1000:.3f},{a[1]/1000:.3f})-({b[0]/1000:.3f},{b[1]/1000:.3f}) on {layer} " \
                           f"conflicts with {what}: {gap}"
            s = Shape(layer, r, net, owner)
            new.append(s)
            nr.segs.append((layer, a, b, width))
        for s in new:
            self.add_shape(s)
        nr.shapes += new
        return new, None

    # ---------------------------------------------------------- shields
    def shield(self, net, sh_net, spec):
        """Parallel shield wires (net sh_net) on both sides of every long segment of `net`."""
        nr = self.routes.get(net)
        pieces = []
        if not nr:
            return pieces
        for (L, a, b, w) in list(nr.segs):
            if abs(b[0] - a[0]) + abs(b[1] - a[1]) < 2 * self.G:
                continue
            ws = T.rule_width(L)
            off = w // 2 + max(T.rule_space(L), self.pair.get(frozenset((net, sh_net)), 0)) + ws // 2
            off = -(-off // self.G) * self.G
            horiz = a[1] == b[1]
            for sgn in (1, -1):
                if horiz:
                    p, q = (a[0], a[1] + sgn * off), (b[0], b[1] + sgn * off)
                else:
                    p, q = (a[0] + sgn * off, a[1]), (b[0] + sgn * off, b[1])
                r = self.seg_rect(p, q, ws)
                if self.region.contains(r) and self.clear(sh_net, L, r, None):
                    s = Shape(L, r, sh_net, f"shield:{net}")
                    self.add_shape(s)
                    pieces.append(s)
        return pieces

    # ---------------------------------------------------------- finishing
    def fix_min_area(self):
        """Grow isolated pads that are below the layer's minimum area."""
        import klayout.db as kdb
        fixes = 0
        for net, nr in self.routes.items():
            for L in T.ROUTE_LAYERS:
                mine = [s for s in nr.shapes if s.layer == L]
                if not mine:
                    continue
                reg = kdb.Region()
                for s in self._net_shapes(net, L):
                    reg.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
                reg.merge()
                for poly in reg.each():
                    if poly.area() >= T.AREA[L]:
                        continue
                    bb = poly.bbox()
                    w, h = bb.width(), bb.height()
                    horiz = T.PREFERRED.get(L, "h") == "h"
                    for hz in (horiz, not horiz):
                        if hz:
                            need = -(-T.AREA[L] // h)
                            need += (need - w) % 10
                            grow = (need - w) // 2
                            r = Rect(bb.left - grow, bb.bottom, bb.right + grow, bb.top)
                        else:
                            need = -(-T.AREA[L] // w)
                            need += (need - h) % 10
                            grow = (need - h) // 2
                            r = Rect(bb.left, bb.bottom - grow, bb.right, bb.top + grow)
                        if self.clear(net, L, r, None):
                            s = Shape(L, r, net, f"route:{net}")
                            self.add_shape(s)
                            nr.shapes.append(s)
                            fixes += 1
                            break
                    else:
                        self.notes.append(f"net {net}: {L} island at ({bb.center().x/1000:.2f},"
                                          f"{bb.center().y/1000:.2f}) below min area and cannot grow")
        return fixes

    def fix_slivers(self):
        """Widen same-net metal narrower than the width rule (e.g. a wire meeting a pad off-centre leaves a
        thin step). Each narrow spot is grown to the minimum width where that stays legal."""
        import klayout.db as kdb
        fixes = 0
        for net, nr in self.routes.items():
            for L in T.ROUTE_LAYERS:
                if not any(s.layer == L for s in nr.shapes):
                    continue
                minw = T.rule_width(L)
                for _ in range(3):
                    reg = kdb.Region()
                    for s in self._net_shapes(net, L):
                        reg.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
                    reg.merge()
                    bad = list(reg.width_check(minw).each())
                    if not bad:
                        break
                    added = 0
                    for ep in bad:
                        b = ep.bbox()
                        bx0, by0, bx1, by1 = b.left, b.bottom, b.right, b.top
                        e1, e2 = ep.first, ep.second            # restrict to where the two edges face each other
                        ox0 = max(min(e1.x1, e1.x2), min(e2.x1, e2.x2))
                        ox1 = min(max(e1.x1, e1.x2), max(e2.x1, e2.x2))
                        oy0 = max(min(e1.y1, e1.y2), min(e2.y1, e2.y2))
                        oy1 = min(max(e1.y1, e1.y2), max(e2.y1, e2.y2))
                        if ox1 > ox0 and e1.y1 == e1.y2:          # horizontal edges: thin in y
                            bx0, bx1 = ox0, ox1
                        if oy1 > oy0 and e1.x1 == e1.x2:          # vertical edges: thin in x
                            by0, by1 = oy0, oy1
                        cands = []
                        dx = max(0, minw - (bx1 - bx0))
                        dy = max(0, minw - (by1 - by0))
                        for fx in ((0.5,) if not dx else (0.0, 0.5, 1.0)):     # grow left / centred / right
                            for fy in ((0.5,) if not dy else (0.0, 0.5, 1.0)):  # grow down / centred / up
                                x0 = bx0 - int(dx * (1 - fx))
                                x1 = bx1 + int(dx * fx)
                                y0 = by0 - int(dy * (1 - fy))
                                y1 = by1 + int(dy * fy)
                                cands.append(Rect(x0 - x0 % 5, y0 - y0 % 5, x1 + (-x1) % 5, y1 + (-y1) % 5))
                        for r in cands:
                            if self.clear(net, L, r, None):
                                sh = Shape(L, r, net, f"route:{net}")
                                self.add_shape(sh)
                                nr.shapes.append(sh)
                                new = [sh]
                                for _ in range(3):              # close same-net notches it created
                                    fl = [f for f in self.notch_fills(net, L, new) if self.clear(net, L, f.rect, None)]
                                    if not fl:
                                        break
                                    for f in fl:
                                        self.add_shape(f)
                                        nr.shapes.append(f)
                                    new = fl
                                added += 1
                                break
                    fixes += added
                    if not added:
                        break
        return fixes

    def _net_shapes(self, net, layer):
        seen = set()
        out = []
        for cell in self.idx[layer].cells.values():
            for s in cell:
                if s.net == net and id(s) not in seen and "reserve" not in s.kinds:
                    seen.add(id(s))
                    out.append(s)
        return out

    # ---------------------------------------------------------- analysis
    def resistance(self, net):
        """Worst pin-to-pin resistance (ohm) through the routed tree (wires + cuts)."""
        nr = self.routes.get(net)
        if not nr or len(nr.pins_used) < 2:
            return 0.0
        adj = defaultdict(list)

        def node(x, y, L):
            return (x, y, L)
        pts = defaultdict(set)
        for (L, a, b, w) in nr.segs:
            pts[(L, a[1] == b[1], a[1] if a[1] == b[1] else a[0])].update([a, b])
        # split segments at every point lying on them
        allp = defaultdict(set)
        for (L, a, b, w) in nr.segs:
            allp[L].update([a, b])
        for (cut, x, y) in nr.cuts:
            for L in T.ROUTE_LAYERS:
                allp[L].add((x, y))
        for (x, y, L) in nr.pins_used:
            allp[L].add((x, y))
        for (L, a, b, w) in nr.segs:
            on = sorted([p for p in allp[L] if (a[0] == b[0] == p[0] and min(a[1], b[1]) <= p[1] <= max(a[1], b[1])) or
                         (a[1] == b[1] == p[1] and min(a[0], b[0]) <= p[0] <= max(a[0], b[0]))])
            for p, q in zip(on, on[1:]):
                rr = T.RSHEET[L] * (abs(q[0] - p[0]) + abs(q[1] - p[1])) / w
                adj[node(*p, L)].append((node(*q, L), rr))
                adj[node(*q, L)].append((node(*p, L), rr))
        for (cut, x, y) in nr.cuts:
            for (lo, hi), c in T.CUTS.items():
                if c == cut:
                    adj[node(x, y, lo)].append((node(x, y, hi), T.RCUT[cut]))
                    adj[node(x, y, hi)].append((node(x, y, lo), T.RCUT[cut]))
        pins = [node(x, y, L) for (x, y, L) in nr.pins_used]
        worst = 0.0
        for p in pins:
            dist = {p: 0.0}
            q = [(0.0, p)]
            while q:
                d, u = heapq.heappop(q)
                if d > dist.get(u, 1e18):
                    continue
                for v, w in adj[u]:
                    if d + w < dist.get(v, 1e18):
                        dist[v] = d + w
                        heapq.heappush(q, (d + w, v))
            for o in pins:
                if o in dist:
                    worst = max(worst, dist[o])
        return worst

    def coupling(self, a, b, reach=2000):
        """Sidewall coupling estimate (fF) between two routed nets (same-layer parallel runs)."""
        ra, rb = self.routes.get(a), self.routes.get(b)
        if not ra or not rb:
            return 0.0
        tot = 0.0
        for (L, p, q, w) in ra.segs:
            for (L2, p2, q2, w2) in rb.segs:
                if L != L2:
                    continue
                if p[1] == q[1] and p2[1] == q2[1]:      # both horizontal
                    ov = min(max(p[0], q[0]), max(p2[0], q2[0])) - max(min(p[0], q[0]), min(p2[0], q2[0]))
                    gap = abs(p[1] - p2[1]) - (w + w2) / 2
                elif p[0] == q[0] and p2[0] == q2[0]:
                    ov = min(max(p[1], q[1]), max(p2[1], q2[1])) - max(min(p[1], q[1]), min(p2[1], q2[1]))
                    gap = abs(p[0] - p2[0]) - (w + w2) / 2
                else:
                    continue
                if ov > 0 and 0 < gap <= reach:
                    tot += T.EPS_OX * T.THICK[L] * (ov / 1000) / (gap / 1000)
        return tot
