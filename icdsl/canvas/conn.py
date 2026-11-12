"""In-process connectivity check: shorts and opens with the source lines that drew them.

Works on the net names the script attached to shapes (`net=`, ports, labels, and everything the PCells
tag: gates, source/drain straps, taps, via stacks). It is a fast pre-check with readable messages; the
signoff verdict is still netgen LVS. Generic over PDKs: conductors, cuts, and what cuts a conductor
(poly over diffusion, resistor markers) come from the Tech data.
"""
from __future__ import annotations

from collections import defaultdict, deque

import klayout.db as kdb

from .core import Rect, Poly

_B = 2000   # spatial hash bucket, nm


def _kpoly(s):
    if isinstance(s, Poly):
        return kdb.Polygon([kdb.Point(x, y) for x, y in s.pts])
    return kdb.Polygon(kdb.Box(s.x0, s.y0, s.x1, s.y1))


def _touch(a, b, area=False):
    """Do two shapes connect (share area, or an edge unless area=True)?"""
    ox = min(a.x1, b.x1) - max(a.x0, b.x0)
    oy = min(a.y1, b.y1) - max(a.y0, b.y0)
    if ox < 0 or oy < 0 or (ox == 0 and oy == 0):
        return False
    if area and (ox == 0 or oy == 0):
        return False
    if isinstance(a, Rect) and isinstance(b, Rect):
        return True
    pa, pb = _kpoly(a), _kpoly(b)
    if area:
        return not (kdb.Region(pa) & kdb.Region(pb)).is_empty()
    return pa.touches(pb)


class _Index:
    def __init__(self):
        self.b = defaultdict(list)

    def add(self, i, s):
        for gx in range(s.x0 // _B, s.x1 // _B + 1):
            for gy in range(s.y0 // _B, s.y1 // _B + 1):
                self.b[(gx, gy)].append(i)

    def near(self, s):
        seen = set()
        for gx in range(s.x0 // _B, s.x1 // _B + 1):
            for gy in range(s.y0 // _B, s.y1 // _B + 1):
                for i in self.b.get((gx, gy), ()):
                    if i not in seen:
                        seen.add(i)
                        yield i


def flatten(cell):
    """[(shape in top coordinates, resolved net name or None, instance path)] for the whole hierarchy.
    Net names of a child are mapped through `conns` (default: a port connects to the parent's net of
    the same name); nets that are not ports become '<instance path>/<name>'."""
    out = []

    def rec(c, netmap, prefix, maps):
        def res(n):
            if n is None:
                return None
            return netmap.get(n, prefix + n) if netmap is not None else n

        def up(s):
            for r, ix, iy in reversed(maps):
                s = r.map(s, ix, iy)
            return s
        for s in c.shapes:
            out.append((up(s), res(s.net), prefix))
        for name, rects in c.ports.items():
            grp = len(out)
            for r in rects:
                out.append((up(r), res(name), prefix if not c.foreign else ("@%d" % grp)))
        for (text, layer, x, y) in c.labels:
            g = c.tech.grid
            out.append((up(Rect(layer, x - g, y - g, x + g, y + g)), res(text), prefix))
        for r in c.refs:
            for iy in range(r.ny):
                for ix in range(r.nx):
                    tag = r.name + (f"[{ix},{iy}]" if r.nx * r.ny > 1 else "")
                    sub = {p: res(r.net_of(p, ix, iy)) for p in r.cell.port_order}
                    rec(r.cell, sub, prefix + tag + "/", maps + [(r, ix, iy)])

    rec(cell, None, "", [])
    return out


def analyze(cell, max_report=12):
    t = cell.tech
    cfg = t.d.get("conn", {})
    cut_by = {k: list(v) for k, v in cfg.get("cut_by", {}).items()}
    plates = dict(cfg.get("plates", {}))                    # plate layer -> cut that lands on it
    cond = set(t.stack) | set(cfg.get("conductors", [])) | set(plates)
    # conn.cuts: layers that join two conductors like a cut without being a via of the stack (asap7 sdt:
    # active -> lisd); conn.direct: pairs of conductors that are connected wherever they overlap
    all_cuts = {**t.cuts, **cfg.get("cuts", {})}
    direct = [tuple(p) for p in cfg.get("direct", [])]
    for d in all_cuts.values():
        lo = d["lower"]
        cond |= set([lo] if isinstance(lo, str) else lo)
    cutters = {m for v in cut_by.values() for m in v}
    flat = flatten(cell)

    by_layer = defaultdict(list)
    for s, net, path in flat:
        if s.layer in cond or s.layer in all_cuts or s.layer in cutters:
            by_layer[s.layer].append((s, net, path))

    # conductors cut by other layers (diffusion by poly, resistor bodies by their marker)
    for layer, ms in cut_by.items():
        if layer not in by_layer:
            continue
        cidx, cshapes = _Index(), []
        for m in ms:
            for s, _, _ in by_layer.get(m, ()):
                cidx.add(len(cshapes), s)
                cshapes.append(s)
        if not cshapes:
            continue
        new = []
        for s, net, path in by_layer[layer]:
            hit = [cshapes[i] for i in cidx.near(s) if _touch(s, cshapes[i], area=True)]
            if not hit:
                new.append((s, net, path))
                continue
            reg = kdb.Region(_kpoly(s))
            cr = kdb.Region()
            for h in hit:
                cr.insert(_kpoly(h))
            for p in (reg - cr).each():
                if p.is_box():
                    b = p.bbox()
                    new.append((Rect(layer, b.left, b.bottom, b.right, b.top, None, s.src), None, path))
                else:
                    new.append((Poly(layer, [(q.x, q.y) for q in p.each_point_hull()], None, s.src), None, path))
        by_layer[layer] = new

    items, lay_idx = [], {}
    for layer, lst in by_layer.items():
        if layer in cond or layer in all_cuts:
            idx = _Index()
            lay_idx[layer] = idx
            for s, net, path in lst:
                idx.add(len(items), s)
                items.append((s, net, path))
    n = len(items)
    parent = list(range(n))
    adj = defaultdict(list)

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def link(a, b):
        adj[a].append(b)
        adj[b].append(a)
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb

    for layer in cond:
        idx = lay_idx.get(layer)
        if not idx:
            continue
        for bucket in idx.b.values():
            for ii, i in enumerate(bucket):
                si = items[i][0]
                for j in bucket[ii + 1:]:
                    if find(i) == find(j) and len(adj[i]) > 3:
                        continue
                    if _touch(si, items[j][0]):
                        link(i, j)
    # ports of an imported cell are connected inside it
    groups = defaultdict(list)
    for i, (s, net, path) in enumerate(items):
        if path.startswith("@") and net is not None:
            groups[(path, net)].append(i)
    for g in groups.values():
        for a in g[1:]:
            link(g[0], a)
    for a, b in direct:
        ia, ib = lay_idx.get(a), lay_idx.get(b)
        if not ia or not ib:
            continue
        for i in sorted({i for bk in ia.b.values() for i in bk}):
            for j in ib.near(items[i][0]):
                if _touch(items[i][0], items[j][0], area=True):
                    link(i, j)
    plate_of = {c: p for p, c in plates.items()}
    for cut, d in all_cuts.items():
        idx = lay_idx.get(cut)
        if not idx:
            continue
        lows = [d["lower"]] if isinstance(d["lower"], str) else list(d["lower"])
        for bucket_items in [sorted({i for b in idx.b.values() for i in b})]:
            for i in bucket_items:
                s = items[i][0]
                targets = [d["upper"]]
                pl = plate_of.get(cut)
                on_plate = False
                if pl and pl in lay_idx:
                    for j in lay_idx[pl].near(s):
                        if _touch(s, items[j][0], area=True):
                            link(i, j)
                            on_plate = True
                targets += [] if on_plate else lows
                for L in targets:
                    if L in lay_idx:
                        for j in lay_idx[L].near(s):
                            if _touch(s, items[j][0], area=True):
                                link(i, j)

    names = defaultdict(dict)        # root -> {net: first item index}
    for i, (s, net, path) in enumerate(items):
        if net is not None and s.layer not in all_cuts:
            names[find(i)].setdefault(net, i)

    def where(i):
        s, net, path = items[i]
        src = f"{_short(s.src[0])}:{s.src[1]}" if s.src else "?"
        return f"{s.layer} ({s.cx:.3f}, {s.cy:.3f}) {('in ' + path.rstrip('/') + ' ') if path and not path.startswith('@') else ''}[{src}]"

    def path_between(a, b):
        prev = {a: None}
        dq = deque([a])
        while dq:
            u = dq.popleft()
            if u == b:
                break
            for v in adj[u]:
                if v not in prev:
                    prev[v] = u
                    dq.append(v)
        if b not in prev:
            return []
        p, u = [], b
        while u is not None:
            p.append(u)
            u = prev[u]
        return p[::-1]

    shorts, opens = [], []
    for root, nm_ in names.items():
        if len(nm_) > 1:
            ks = sorted(nm_)
            p = path_between(nm_[ks[0]], nm_[ks[1]])
            if len(p) > 9:
                p = p[:4] + [None] + p[-4:]
            shorts.append({"nets": ks, "path": [where(i) if i is not None else "..." for i in p]})
    comp_of = defaultdict(dict)
    for root, nm_ in names.items():
        for k, i in nm_.items():
            comp_of[k][root] = i
    for k, comps in comp_of.items():
        if len(comps) > 1:
            sizes = defaultdict(int)
            for i in range(n):
                r = find(i)
                if r in comps:
                    sizes[r] += 1
            order = sorted(comps, key=lambda r: -sizes[r])
            opens.append({"net": k, "pieces": len(comps),
                          "islands": [where(comps[r]) + f" ({sizes[r]} shapes)" for r in order[:5]]})
    shorts.sort(key=lambda s: s["nets"])
    opens.sort(key=lambda o: (-o["pieces"], o["net"]))
    return {"shapes": n, "named_nets": len(comp_of), "shorts": shorts[:max_report], "opens": opens[:max_report],
            "n_shorts": len(shorts), "n_opens": len(opens)}


def _short(path):
    import os
    try:
        r = os.path.relpath(path)
    except ValueError:
        return path
    return r if not r.startswith("..") else os.path.basename(path)


def render(res):
    o = []
    if not res["n_shorts"] and not res["n_opens"]:
        return [f"connectivity pre-check: ok ({res['named_nets']} named nets, {res['shapes']} conductor shapes)"]
    o.append(f"connectivity pre-check: {res['n_shorts']} short(s), {res['n_opens']} open net(s)")
    for s in res["shorts"]:
        o.append(f"  SHORT {' = '.join(s['nets'])}")
        for step in s["path"]:
            o.append(f"      {step}")
    for p in res["opens"]:
        o.append(f"  OPEN  net {p['net']} is in {p['pieces']} unconnected pieces:")
        for i in p["islands"]:
            o.append(f"      {i}")
    return o
