"""Stick cells: a CMOS leaf cell from two transistor strips, on any PDK that has nmos/pmos/ptap/ntap
recipes. A convenience on top of the canvas, not a fence - everything it draws is ordinary canvas
geometry, and a cell it cannot express can be drawn by hand and still be placed next to stick cells.

    inv  = stick("inv",   n="VSS A Y",       p="VDD A Y",       ports="A Y")
    nand = stick("nand2", n="VSS A x B Y",   p="VDD A Y B VDD", ports="A B Y")

A strip reads left to right: source/drain net, gate net, source/drain net, gate net, ... Both strips
have the same number of columns. '-' in a gate position = no transistor there (the diffusion is broken),
'-' in a source/drain position = no diffusion in that column. If the n and p gates of a column have
different nets the poly is split (clocked inverters, pass gates).

Layout: ground rail + substrate taps at y = 0, n strip, a channel of horizontal tracks on the second
conductor (c1), p strip, power rail + well taps at y = H. Rails are centred on the cell edge, so rows
are stacked by mirroring every other row (see `rows`). Every net that needs wiring gets a track; ports
are tracks that span the cell, so a parent can drop a via on a port at any x.
"""
from __future__ import annotations

import math

from .core import Cell, Rect, CanvasError
from .pcells import _cut_lo
from . import tech as T

_NONE = ("-", "|")


def _probe(t, calls):
    """Half extents (nm) per layer of some via stacks drawn at the origin."""
    c = Cell("__probe__", t)
    try:
        for args, kw in calls:
            c.via(*args, at=(0, 0), **kw)
        hw, hh = {}, {}
        for s in c.shapes:
            hw[s.layer] = max(hw.get(s.layer, 0), -s.x0, s.x1)
            hh[s.layer] = max(hh.get(s.layer, 0), -s.y0, s.y1)
        return hw, hh
    finally:
        Cell.registry.pop("__probe__", None)


def _ceil(v, g):
    return int(math.ceil(v / g - 1e-9)) * g


def geometry(t, l=None, kinds=("nmos", "pmos")):
    """The grid a stick cell uses on this PDK (all nm): column pitch P, track pitch, keep-apart K."""
    g = t.grid
    poly, cut, c0, c1, c2 = t.roles["poly"], t.roles["contact"], t.c0, t.c1, t.c2
    nrec, prec = t.device(kinds[0]), t.device(kinds[1])
    L = t.nm(l if l is not None else max(nrec["lmin"], prec["lmin"]))
    if L % (2 * g):
        raise CanvasError(f"stick: gate length {L / 1000} must be a multiple of {2 * g / 1000} um")
    hw, hh = _probe(t, [((c0, c1), dict(dir="v", top_dir="h")), ((poly, c1), dict(dir="v", top_dir="h")),
                        ((c1, c2), dict(dir="h", top_dir="v"))])
    cs = t.nm(t.cuts[cut]["size"])
    sa = t.nm(t.enc(c0, cut)[0])
    sw = max(t.nm(t.width(c0)), cs + 2 * sa)
    wcol = max(2 * hw[c0], sw)
    chalf = max(_cut_lo(cs, g), cs - _cut_lo(cs, g))
    P = max(2 * (wcol + t.nm(t.space(c0))), L + 2 * t.nm(t.rule("gate_contact_space")) + 2 * chalf,
            L + t.nm(t.rule("gate_space")), 2 * hw[poly] + t.nm(t.space(poly)))
    for (xl, e) in t.d.get("contact_extra", {}).get(poly, []):
        P = max(P, 2 * hw[xl] + t.nm(t.space(xl)))
    P = _ceil(P, 4 * g)
    pitch = _ceil(2 * hh[c1] + t.nm(t.space(c1)), g)
    need = 0
    for layer, h in hh.items():
        if layer in (c1, c2) or layer in t.cuts and layer != cut:
            continue
        need = max(need, 2 * h + t.nm(t.space(layer)))
    K = max(1, int(math.ceil(need / pitch - 1e-9)))
    return dict(L=L, P=P, pitch=pitch, K=K, hw=hw, hh=hh, sw=sw)


def stick(name, n, p, ports, wn=None, wp=None, l=None, ntracks=None, power=None, ground=None,
          tracks=None, kinds=("nmos", "pmos"), tech=None):
    """Build a stick cell (see the module text). wn / wp: transistor widths (um); l: gate length;
    ntracks: minimum number of tracks (cells of one row need the same height: same wn, wp, ntracks);
    tracks={net: index} fixes track positions. Returns the Cell; cell.stick has the grid:
    P (column pitch), H, W, track_y {net: y}, pitch (track pitch), ntracks - all in um."""
    t = tech or T.current()
    g = t.grid
    sup = t.d.get("supplies", {})
    power, ground = power or sup.get("power", "VDD"), ground or sup.get("ground", "VSS")
    ports = ports.split() if isinstance(ports, str) else list(ports)
    nt = n.split() if isinstance(n, str) else list(n)
    pt = p.split() if isinstance(p, str) else list(p)
    if len(nt) != len(pt) or len(nt) % 2 == 0 or len(nt) < 3:
        raise CanvasError(f"stick {name}: both strips need the same odd number of entries "
                          f"(net gate net gate ... net); got {len(nt)} and {len(pt)}",
                          "pad the shorter strip with '-' entries")
    ng = len(nt) // 2
    strips = {}
    for side, tok in (("n", nt), ("p", pt)):
        sd = [None if x in _NONE else x for x in tok[0::2]]
        gt = [None if x in _NONE else x for x in tok[1::2]]
        for j, gnet in enumerate(gt):
            if gnet and (sd[j] is None or sd[j + 1] is None):
                raise CanvasError(f"stick {name}: {side} gate {gnet!r} (column {j}) needs a source/drain net on both sides")
        for j, s in enumerate(sd):
            if s and not ((j > 0 and gt[j - 1]) or (j < ng and gt[j])):
                raise CanvasError(f"stick {name}: {side} source/drain {s!r} (column {j}) has no transistor next to it")
        strips[side] = (sd, gt)
    G = geometry(t, l, kinds)
    L, P, pitch, K, hw, hh = G["L"], G["P"], G["pitch"], G["K"], G["hw"], G["hh"]
    nrec, prec, ptr, ntr = t.device(kinds[0]), t.device(kinds[1]), t.device("ptap"), t.device("ntap")
    poly, cut, c0, c1 = t.roles["poly"], t.roles["contact"], t.c0, t.c1
    nm = t.nm
    cs = nm(t.cuts[cut]["size"])
    cl = _cut_lo(cs, g)                         # centre to the low edge of a contact (on grid)
    chalf = max(cl, cs - cl)
    Wn = nm(wn if wn is not None else max(nrec["wmin"], (cs + 2 * nm(max(t.enc(nrec["diff"], cut)))) / 1000.0))
    Wp = nm(wp if wp is not None else 2 * Wn / 1000.0)
    c = Cell(name, t)
    xs = [P // 2 + j * P for j in range(ng + 1)]
    xg = [P + j * P for j in range(ng)]

    # ---------------------------------------------------------------- vertical dimensions
    sp0 = nm(t.space(c0))
    endcap = nm(t.rule("poly_endcap"))
    pc_diff = nm(t.rule("polycontact_diff_space"))
    pc_imp = nm(t.rule("polycontact_implant_space"))

    def e_imp(rec):
        return max(nm(t.enc(rec["implant"], rec["diff"])[0]), nm(rec.get("implant_gate_ext", 0)))

    def ovh(rec):
        return max(0, nm(max(t.enc(c0, cut))) - nm(t.enc(rec["diff"], cut)[0])) + 2 * g

    ht = _ceil(max(cs + 2 * nm(max(max(t.enc(ptr["diff"], cut)), max(t.enc(ntr["diff"], cut)))),
                   nm(t.width(ptr["diff"])), nm(t.width(ntr["diff"])), nm(t.width(c0))), 2 * g)
    # A rail is shared with the mirrored row next to it, so its contacts must be the same in both. A
    # contact whose size is an odd number of grids cannot be centred on the rail line; the whole rail
    # (odd height) is then centred on the contact, half a grid off the line, and `rows` shifts the
    # mirrored rows by one grid (mirror_dy). rlo / rhi: rail line to the rail's low / high edge.
    if cs != 2 * cl:
        ht += g
    rlo = cl + (ht - cs) // 2
    rhi = ht - rlo

    def rail_gap(rec, trec):
        return _ceil(max(nm(t.rule("tap_diff_space")), nm(t.enc(trec["implant"], trec["diff"])[0]) + e_imp(rec),
                         endcap + nm(t.space(poly, trec["diff"])), sp0 + ovh(rec)), g)

    def chan_gap(rec):
        return _ceil(max(pc_diff + chalf, nm(t.space(poly, rec["diff"])) + hh[poly], sp0 + ovh(rec) + hh[c0],
                         e_imp(rec) + pc_imp + chalf), g)

    yn0 = rhi + rail_gap(nrec, ptr)
    yn1 = yn0 + Wn
    yt0 = yn1 + chan_gap(nrec)

    # ---------------------------------------------------------------- terminals, nets, tracks
    (nsd, ngt), (psd, pgt) = strips["n"], strips["p"]
    term = {}                                   # net -> [(kind, column, x)]

    def add(net, kind, j, x):
        term.setdefault(net, []).append((kind, j, x))

    for j in range(ng + 1):
        if nsd[j] and nsd[j] != ground:
            add(nsd[j], "sdn", j, xs[j])
        if psd[j] and psd[j] != power:
            add(psd[j], "sdp", j, xs[j])
    for j in range(ng):
        a, b = ngt[j], pgt[j]
        if a and a == b:
            add(a, "g", j, xg[j])
        else:
            if a:
                add(a, "gn", j, xg[j])
            if b:
                add(b, "gp", j, xg[j])
    for bad in (power, ground):
        if bad in term:
            raise CanvasError(f"stick {name}: {bad} is used on a gate or on the opposite strip",
                              "tie it through a named net and connect that net in the parent")
    for q in ports:
        if q not in term and q not in (power, ground):
            raise CanvasError(f"stick {name}: port {q!r} is not a net of the strips")
    tracked = [k for k, v in term.items() if len(v) > 1 or k in ports]
    for k, v in term.items():
        if k not in tracked and v[0][0] != "sdn" and v[0][0] != "sdp":
            raise CanvasError(f"stick {name}: gate net {k!r} connects to nothing else", "make it a port")
    # vertical order: in a column where the n side and the p side carry different nets, the p net's
    # track must be K tracks above the n net's. If that order is cyclic (clocked latches: CK over CKB in
    # one column, CKB over CK in the next) the n-side terminal gets a second track for its net, joined
    # to the first by a jumper column at the right end of the cell.
    cons = []                                   # (n net, p net, n terminal kind, column)
    for j in range(ng + 1):
        a, b = nsd[j], psd[j]
        if a in tracked and b in tracked and a != b:
            cons.append((a, b, "sdn", j))
    for j in range(ng):
        a, b = ngt[j], pgt[j]
        if a and b and a != b:
            cons.append((a, b, "gn", j))
    edges, up, alias = [], {}, {}

    def reaches(src, dst):
        todo, seen = [src], set()
        while todo:
            q = todo.pop()
            if q == dst:
                return True
            if q not in seen:
                seen.add(q)
                todo += up.get(q, [])
        return False

    for a, b, kind, j in cons:
        node = a
        if reaches(b, a):
            node = next((x for x in alias.get(a, []) if not reaches(b, x)), None)
            if node is None:
                node = f"{a}#{len(alias.get(a, [])) + 2}"
                alias.setdefault(a, []).append(node)
                term[node] = []
            e = next(x for x in term[a] if x[0] == kind and x[1] == j)
            term[a].remove(e)
            term[node].append(e)
        edges.append((node, b))
        up.setdefault(node, []).append(b)
    jumpers = [(x, a) for a, v in alias.items() for x in v]
    for i, (x, a) in enumerate(jumpers):
        xj = (ng + 1) * P + P // 2 + i * P
        term[x].append(("jmp", ng + 1 + i, xj))
        term[a].append(("jmp", ng + 1 + i, xj))
        if a not in tracked:
            tracked.append(a)
        tracked.append(x)
    W = (ng + 1 + len(jumpers)) * P
    xs_all = xs + [(ng + 1) * P + P // 2 + i * P for i in range(len(jumpers))]
    lvl = {k: 0 for k in tracked}
    for it in range(len(tracked) + 2):
        ch = False
        for a, b in edges:
            if lvl[b] < lvl[a] + K:
                lvl[b] = lvl[a] + K
                ch = True
        if not ch:
            break
    else:
        raise CanvasError(f"stick {name}: the n-below-p ordering of nets is cyclic "
                          f"({', '.join(f'{a} below {b}' for a, b in edges)})",
                          "move one of the transistors to another column or break the diffusion with '-'")
    padw = hw[c1] + nm(t.space(c1))
    span = {k: ((0, W) if k in ports else (min(x for _, _, x in term[k]) - padw, max(x for _, _, x in term[k]) + padw))
            for k in tracked}
    trk, used = {}, {}
    if tracks:
        for k, v in tracks.items():
            if k in span:
                trk[k] = v
                used.setdefault(v, []).append(span[k])
    for k in sorted(tracked, key=lambda k: (lvl[k], span[k][0], k)):
        if k in trk:
            continue
        i = max([0] + [trk[a] + K for a, b in edges if b == k and a in trk])
        while any(not (span[k][1] <= a or b <= span[k][0]) for a, b in used.get(i, [])):
            i += 1
        trk[k] = i
        used.setdefault(i, []).append(span[k])
    for a, b in edges:
        if trk[b] < trk[a] + K:
            raise CanvasError(f"stick {name}: tracks= puts {b} less than {K} tracks above {a}")
    need = max(trk.values()) + 1 if trk else 1
    if ntracks is not None and ntracks < need:
        raise CanvasError(f"stick {name}: needs {need} tracks, ntracks={ntracks}",
                          f"pass ntracks={need} (or more) to every stick cell of the row, or leave ntracks out")
    NT = max(need, ntracks or 0)
    yt = [yt0 + i * pitch for i in range(NT)]
    yp0 = yt[-1] + chan_gap(prec)
    nwell = prec.get("well")
    if nwell:
        yp0 = max(yp0, yn1 + _ceil(nm(t.enc(nwell, prec["diff"])[0]) + nm(t.space(nwell, nrec["diff"])), g))
    yp1 = yp0 + Wp
    H = yp1 + rail_gap(prec, ntr) + rlo
    um = lambda v: v / 1000.0

    # ---------------------------------------------------------------- rails and taps
    for (y, rec, net) in ((0, ptr, ground), (H, ntr, power)):
        c.rect(rec["diff"], x0=0, x1=um(W), y0=um(y - rlo), y1=um(y + rhi))
        for x in xs_all:
            c.rect(cut, x0=um(x - cl), x1=um(x - cl + cs), y0=um(y - cl), y1=um(y - cl + cs), net=net)
        rail = c.rect(c0, x0=0, x1=um(W), y0=um(y - rlo), y1=um(y + rhi), net=net)
        e = nm(t.enc(rec["implant"], rec["diff"])[0])
        c.rect(rec["implant"], x0=um(-e), x1=um(W + e), y0=um(y - rlo - e), y1=um(y + rhi + e))
        c.port(net, on=rail)
    # ---------------------------------------------------------------- transistor strips
    mos = {"n": {}, "p": {}}                    # side -> column -> (Mos handle, first column)
    inset = W
    for side, rec, kind, y, w, bulk in (("n", nrec, kinds[0], yn0, Wn, ground), ("p", prec, kinds[1], yp0, Wp, power)):
        sd, gt = strips[side]
        j = 0
        while j < ng:
            if not gt[j]:
                j += 1
                continue
            k = j
            while k < ng and gt[k]:
                k += 1
            m = c.mos(kind, w=um(w), l=um(L), nf=k - j, at=(um(xs[j]), um(y)), origin="col", pitch=um(P),
                      gates=gt[j:k], sd=sd[j:k + 1], bulk=bulk, implant=False, well=False,
                      name=f"M{side}{j}")
            if abs(nm(m.sx[0]) - xs[j]) > 1 or abs(nm(m.pitch) - P) > 1:
                raise CanvasError(f"stick {name}: internal grid mismatch (pitch {m.pitch} vs {um(P)})")
            for q in range(j, k + 1):
                mos[side][("sd", q)] = m.sd[q - j]
            for q in range(j, k):
                mos[side][("g", q)] = m.gates[q - j]
            inset = min(inset, m.diff.x0, W - m.diff.x1)
            j = k
        e = nm(t.enc(rec["implant"], rec["diff"])[0])
        ex = max(0, e - inset)
        c.rect(rec["implant"], x0=um(-ex), x1=um(W + ex), y0=um(y - e_imp(rec)), y1=um(y + w + e_imp(rec)))
    if nwell:
        e = nm(t.enc(nwell, prec["diff"])[0])
        et = nm(ntr["well_enc"]) if "well_enc" in ntr else nm(t.enc(nwell, ntr["diff"])[0])
        ex = max(et, e - inset)
        c.rect(nwell, x0=um(-ex), x1=um(W + ex), y0=um(yp0 - e), y1=um(H + rhi + et), net=power)
    pwell = nrec.get("well")
    if pwell:           # PDKs that draw the p-well too: it abuts the n-well, so the two never overlap or leave a slot
        e = nm(t.enc(pwell, nrec["diff"])[0])
        et = nm(ptr["well_enc"]) if "well_enc" in ptr else nm(t.enc(pwell, ptr["diff"])[0])
        if nwell:
            en = nm(t.enc(nwell, prec["diff"])[0])
            etn = nm(ntr["well_enc"]) if "well_enc" in ntr else nm(t.enc(nwell, ntr["diff"])[0])
            ex = max(et, e - inset, etn, en - inset)
            ytop = yp0 - en
        else:
            ex, ytop = max(et, e - inset), yn1 + e
        c.rect(pwell, x0=um(-ex), x1=um(W + ex), y0=um(-rlo - et), y1=um(ytop), net=ground)
    # ---------------------------------------------------------------- supplies
    for j in range(ng + 1):
        s = mos["n"].get(("sd", j))
        if s is not None and nsd[j] == ground:
            c.rect(c0, x0=s.left, x1=s.right, y0=0, y1=s.bottom, net=ground)
        s = mos["p"].get(("sd", j))
        if s is not None and psd[j] == power:
            c.rect(c0, x0=s.left, x1=s.right, y0=s.top, y1=um(H), net=power)
    # ---------------------------------------------------------------- nets on tracks
    track_y = {}
    wj = max(nm(t.width(c0)), 2 * hw[c0])
    for node in tracked:
        net = node.split("#")[0]
        y = yt[trk[node]]
        if node == net:
            track_y[net] = um(y)
        cols = sorted({x for _, _, x in term[node]})
        c1_needed = (node == net and net in ports) or len(cols) > 1
        for kind, j, x in term[node]:
            if kind == "sdn":
                s = mos["n"][("sd", j)]
                c.rect(c0, x0=s.left, x1=s.right, y0=s.top, y1=um(y), net=net)
            elif kind == "sdp":
                s = mos["p"][("sd", j)]
                c.rect(c0, x0=s.left, x1=s.right, y0=um(y), y1=s.bottom, net=net)
            elif kind == "jmp":
                if node != net:
                    ym = yt[trk[net]]
                    c.rect(c0, x0=um(x - wj // 2), x1=um(x - wj // 2 + wj), y0=um(min(y, ym)), y1=um(max(y, ym)),
                           net=net)
            else:
                gn_, gp_ = mos["n"].get(("g", j)), mos["p"].get(("g", j))
                lo = gn_.top if kind in ("g", "gn") else um(y)
                hi = gp_.bottom if kind in ("g", "gp") else um(y)
                ref = gn_ if kind in ("g", "gn") else gp_
                c.rect(poly, x0=ref.left, x1=ref.right, y0=lo, y1=hi, net=net)
            if kind in ("g", "gn", "gp"):
                c.via(poly, c1, at=(um(x), um(y)), net=net, dir="v", top_dir="h")
            elif c1_needed:
                c.via(c0, c1, at=(um(x), um(y)), net=net, dir="v", top_dir="h")
        wt = 2 * hh[c1]          # as high as the via pads: a pad dropped anywhere on a track leaves no notch
        if node == net and net in ports:
            s1 = _ceil(nm(t.space(c1)) / 2, g)
            r = c.rect(c1, x0=um(s1), x1=um(W - s1), y0=um(y - wt // 2), y1=um(y - wt // 2 + wt), net=net)
            c.port(net, on=r)
        elif len(cols) > 1:
            c.rect(c1, x0=um(cols[0]), x1=um(cols[-1]), y0=um(y - wt // 2), y1=um(y - wt // 2 + wt), net=net)
    c.set_boundary(0, 0, um(W), um(H))
    c.stick = dict(P=um(P), W=um(W), H=um(H), pitch=um(pitch), ntracks=NT, track_y=track_y,
                   power=power, ground=ground, jumpers=[x for x, _ in jumpers],
                   rail=(um(rlo), um(rhi)), mirror_dy=um(rhi - rlo))
    return c


def rows(parent, rows_, power=None, ground=None, x0=0.0, y0=0.0, bars=True):
    """Place rows of stick cells (same height) bottom to top, every other row mirrored so that
    neighbouring rows share a rail. rows_ = [[(cell, name, conns), ...], ...]; conns as in Cell.place.
    With bars=True the ground rails are joined by a vertical bar on the left and the power rails by one
    on the right (first conductor), and both are made ports. Returns {name: Ref}."""
    t = parent.tech
    sup = t.d.get("supplies", {})
    power, ground = power or sup.get("power", "VDD"), ground or sup.get("ground", "VSS")
    c0 = t.c0
    insts, ends = {}, []
    H = None
    for r, row in enumerate(rows_):
        x = x0
        for (cell, name, conns) in row:
            h = cell.stick["H"]
            if H is None:
                H = h
            elif abs(h - H) > 1e-6:
                raise CanvasError(f"rows: {cell.name} is {h} um high, the row height is {H}",
                                  "give all cells the same wn, wp and ntracks")
            if r % 2 == 0:
                ref = parent.place(cell, at=(x, y0 + r * H), name=name, conns=conns)
            else:
                ref = parent.place(cell, at=(x, y0 + (r + 1) * H + cell.stick["mirror_dy"]), orient="MX", name=name,
                                   conns=conns)
            insts[name] = ref
            x += cell.stick["W"]
        ends.append(x)
    if bars and rows_:
        rlo, rhi = next(iter(insts.values())).cell.stick["rail"]      # rail line to the rail's edges
        wb = max(2 * t.width(c0), 0.3)
        gap = max(2 * t.space(c0), 0.3)
        right = max(ends)
        nrow = len(rows_)
        yg = [y0 + k * H for k in range(0, nrow + 1, 2)]
        yp = [y0 + k * H for k in range(1, nrow + 1, 2)]
        for ys, net, side in ((yg, ground, "l"), (yp, power, "r")):
            if not ys:
                continue
            bx0 = (x0 - gap - wb) if side == "l" else (right + gap)
            bar = parent.rect(c0, x0=bx0, x1=bx0 + wb, y0=min(ys) - rlo, y1=max(ys) + rhi, net=net)
            for y in ys:
                if side == "l":
                    parent.rect(c0, x0=bx0, x1=x0, y0=y - rlo, y1=y + rhi, net=net)
                else:
                    k = int(round((y - y0) / H))
                    xe = min(ends[i] for i in (k - 1, k) if 0 <= i < nrow)
                    parent.rect(c0, x0=xe, x1=bx0 + wb, y0=y - rlo, y1=y + rhi, net=net)
            parent.port(net, on=bar)
    return insts
