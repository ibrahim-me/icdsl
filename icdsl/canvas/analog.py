"""Device rows: a flat device netlist with any sizes (an analog block) as rows of multi-finger MOS strips
inside tap rings, resistors and capacitors next to them, wired by the trunk router.

    from icdsl.canvas import *
    top = from_spice("ota.spice")              # chooses this style when the cell is not CMOS logic
    m, shapes = mos_strip(c, r, "nmos", "M1", w=4, l=0.5, nf=2, g="INN", s="tail", d="d1", at=(0, 0))

It is a baseline, not a matched layout: fingers of one device are merged into one strip, devices stand in
netlist order, there is no interdigitation and no common centroid. Everything it draws is ordinary canvas
geometry (`mos`, `via`, `guard_ring`, `resistor`, `capacitor`, `Router`), so a script can use `mos_strip`
for some devices and draw the rest by hand.
"""
from __future__ import annotations

from .core import Cell, Group, CanvasError
from . import tech as T


class _NoRouter:
    def add(self, *a, **k):
        return self


def _sizes(c):
    t = c.tech
    c0, c1, c2 = t.c0, t.c1, t.c2
    s01 = c.via_size(c0, c1, dir="v", top_dir="h")
    sg = c.via_size("poly", c1, dir="h", top_dir="h")
    bar = max(s01[c1][1], sg[c1][1], c.via_size(c1, c2, dir="h", top_dir="v")[c1][1])
    gap = max(t.rule("polycontact_diff_space"), t.space(c0), t.space(c1)) + 0.1
    return s01, sg, bar, gap


def _pin(c, r, net, cx, cy, bar, group, half=0.6):
    """A router pin: a c1 bar of the pin height centred on (cx, cy)."""
    b = c.rect(c.tech.c1, x0=cx - half, x1=cx + half, y0=cy - bar / 2, y1=cy + bar / 2, net=net)
    r.add(net, b, group=group)
    return b


def mos_strip(c, r, kind, name, w, l=None, nf=1, g="G", s="S", d="D", at=(0, 0), group=None, supply=None):
    """A multi-finger MOS with router pins: the drain bar (c1) along one edge of the diffusion, the source
    bar along the other, the gate bar on poly outside the diffusion (above an n device, below a p device).
    r = the Router that will wire the cell (pins are added to it). supply = a net whose source columns get
    no bar (connect their c0 straps yourself, e.g. into a tap ring). s == d (a MOS capacitor): one bar.
    Returns (the Mos, Group of everything drawn)."""
    t = c.tech
    t.planar_only("mos_strip")
    c0, c1 = t.c0, t.c1
    s01, sg, BAR, GAP = _sizes(c)
    rec = t.device(kind)
    p = rec.get("well") == t.roles.get("nwell")
    n0 = len(c.shapes)
    m = c.mos(kind, w=w, l=l, nf=nf, gates=g, sd=(s, d), at=at, name=name, well=not p)
    st = m.sd[0]
    hb = max(BAR, s01[c0][1])
    ys, yd = st.bottom + hb / 2, st.top - hb / 2
    if p:
        ys, yd = yd, ys                                 # p devices: sources on the top (supply) side
    if s == d:
        jobs = [(s, (st.bottom + st.top) / 2, m.sd)]
    else:
        if abs(yd - ys) < BAR + t.space(c1) - 1e-9:
            raise CanvasError(f"mos_strip {name}: w={w} is too small for a source bar and a drain bar on the "
                              f"diffusion (needs {2 * hb + t.space(c1):.2f} um)",
                              "use stick() / stick_auto() for small logic transistors, or a larger w")
        jobs = [(s, ys, m.sd[0::2]), (d, yd, m.sd[1::2])]
    for net, y, cols in jobs:
        if net == supply and s != d:
            continue
        vs = [c.via(c0, c1, at=(k.cx, y), net=net, dir="v", top_dir="h") for k in cols]
        x0, x1 = vs[0].upper.left, vs[-1].upper.right
        if x1 - x0 < 1.0:                               # room for the router's via
            x0, x1 = (x0 + x1) / 2 - 0.5, (x0 + x1) / 2 + 0.5
        r.add(net, c.rect(c1, x0=x0, x1=x1, y0=y - BAR / 2, y1=y + BAR / 2, net=net), group=group)
    hp = max(sg["poly"][1], BAR, sg[c0][1])
    yg = (m.diff.bottom - GAP - hp / 2) if p else (m.diff.top + GAP + hp / 2)
    xa, xb = m.gates[0].left, m.gates[-1].right
    xc = (xa + xb) / 2
    xa, xb = min(xa, xc - sg["poly"][0] / 2), max(xb, xc + sg["poly"][0] / 2)
    pad = c.via("poly", c1, at=(xc, yg), net=g, dir="h", top_dir="h").lower
    c.rect("poly", x0=xa, x1=xb, y0=pad.bottom, y1=pad.top, net=g)
    for gt in m.gates:
        c.rect("poly", x0=gt.left, x1=gt.right, y0=min(gt.bottom, yg), y1=max(gt.top, yg), net=g)
    r.add(g, c.rect(c1, x0=min(xa, xc - 0.5), x1=max(xb, xc + 0.5), y0=yg - BAR / 2, y1=yg + BAR / 2, net=g),
          group=group)
    return m, Group(c.shapes[n0:])


# ---------------------------------------------------------------------------------------------- netlist
def _models(t):
    return {rec["model"].lower(): (kind, rec) for kind, rec in t.devices.items() if rec.get("model")}


def _prim(e, models, name=None, nodes=None):
    """A netlist element as a primitive device dict(type, kind, name, nodes, w, l), or None."""
    from .synth import _um
    if not e["ref"] or e["ref"].lower() not in models:
        return None
    kind, rec = models[e["ref"].lower()]
    pr = e["params"]
    w = pr.get("w", pr.get("r_width", pr.get("c_width")))
    ln = pr.get("l", pr.get("r_length", pr.get("c_length")))
    if w is None or ln is None:
        raise CanvasError(f"from_spice: {e['name']} has no w= / l= (or r_width / c_width ...) parameters")
    return dict(type=rec["type"], kind=kind, name=name or e["name"], nodes=list(nodes or e["nodes"]),
                w=round(_um(w, 1.0), 6), l=round(_um(ln, 1.0), 6))


def classify(sub, t):
    """The elements of one subcircuit as primitive devices, or None when one of them is something else
    (an instance of a subcircuit, a device without a recipe in this PDK)."""
    models = _models(t)
    out = [_prim(e, models) for e in sub["elems"]]
    return None if None in out or not out else out


def flatten(subs, top, t):
    """All primitive devices under subcircuit `top` (hierarchy expanded, inner nets and names prefixed
    with the instance name)."""
    models = _models(t)
    out = []

    def walk(name, prefix, netmap, depth=0):
        if depth > 50:
            raise CanvasError(f"from_spice: subcircuit {name} contains itself")
        for e in subs[name]["elems"]:
            nodes = [netmap.get(n, prefix + n) for n in e["nodes"]]
            iname = prefix + e["name"].lstrip("xX")
            if e["ref"] in subs:
                walk(e["ref"], iname + "_", dict(zip(subs[e["ref"]]["pins"], nodes)), depth + 1)
                continue
            d = _prim(e, models, iname, nodes)
            if d is None:
                raise CanvasError(f"from_spice: {e['name']} in {name} is a {e['ref'] or e['kind']!r}: neither a "
                                  f"subcircuit of the netlist nor the model of a device recipe of {t.name}",
                                  "models with a recipe: " + ", ".join(sorted(models)) + ". Draw other devices "
                                  "with rect/polygon and declare them with cell.device(...)")
            out.append(d)
    walk(top, "", {p_: p_ for p_ in subs[top]["pins"]})
    return out


def _merge_fingers(devs):
    """Fingers of one transistor (same kind, size, gate, source/drain pair and bulk) -> one strip."""
    order, groups = [], {}
    for dv in devs:
        d, g, s, b = dv["nodes"][:4]
        key = (dv["kind"], dv["w"], dv["l"], g, frozenset((s, d)), b)
        if key not in groups:
            name = dv["name"]
            name = name[1:] if name[:2].lower() == "xm" else name        # XM5_0 -> M5_0
            name = name.replace(".", "_").replace("/", "_")
            base = name.rsplit("_", 1)[0] if name.rsplit("_", 1)[-1].isdigit() and "_" in name else name
            groups[key] = dict(kind=dv["kind"], name=base, w=dv["w"], l=dv["l"], nf=0, g=g, s=s, d=d, b=b)
            order.append(key)
        groups[key]["nf"] += 1
    return [groups[k] for k in order]


def _cap_array(c, r, caps, shared, x, BAR):
    """MIM capacitors in a grid (netlist order, row by row). Both plates of every capacitor come down to
    a tab on the bottom-plate metal below it; a second router wires the tabs on the two metals under
    the bottom plates. A net that also goes to other devices (`shared`) gets a bridge left of the grid:
    a via stack down to c1 and a pin for the main router r. -> {net: shape to hang a port on}"""
    from .route import Router
    t = c.tech
    c1 = t.c1
    rec = t.device(caps[0]["kind"])
    bot, topm = rec["bottom"], rec["top"]
    if any(t.device(dv["kind"])["bottom"] != bot for dv in caps):
        raise CanvasError("from_spice: capacitors on different metal pairs in one cell",
                          "draw them by hand: capacitor() + your own wires")
    i = t.stack.index(bot)
    if i < 2:
        raise CanvasError(f"from_spice: no two metals under the capacitor bottom plate ({bot})")
    rc = Router(c, v=t.stack[i - 1], h=t.stack[i - 2], pin_layer=bot)
    be = rec["bottom_enc"]
    GAP, TH = 3.0, 1.0
    S = rec.get("bottom_space", 1.2) + 0.05       # bottom plate to other metal on its layer
    GAPY = 2 * S + TH
    nets = list(dict.fromkeys(n for dv in caps for n in dv["nodes"][:2]))
    bridges = [n for n in nets if n in shared]
    if bridges:
        x += 11.0
    for k, net in enumerate(bridges):
        yy = 0.5 + 2.5 * k
        c.rect(bot, x0=x - 6.0, x1=x - 2.0, y0=yy - TH / 2, y1=yy + TH / 2, net=net)
        rc.add(net, c.rect(bot, x0=x - 4.4, x1=x - 2.0, y0=yy - TH / 2, y1=yy + TH / 2, net=net), group="capbridge")
        v = c.via(c1, bot, at=(x - 5.4, yy), net=net, dir="h", top_dir="h")
        c.rect(c1, x0=v.lower.cx - 4.5, x1=v.lower.cx, y0=yy - BAR / 2, y1=yy + BAR / 2, net=net)
        r.add(net, c.rect(c1, x0=v.lower.cx - 4.5, x1=v.lower.cx - 2.0, y0=yy - BAR / 2, y1=yy + BAR / 2, net=net),
              group="rc")
    ncol = max(1, int(round(len(caps) ** 0.5 + 0.499)))
    yy = GAPY
    for ri in range(0, len(caps), ncol):
        row = caps[ri:ri + ncol]
        xx = x
        for dv in row:
            a, b = dv["nodes"][:2]
            u = c.capacitor(dv["kind"], w=dv["w"], h=dv["l"], at=(xx + be, yy + be), nets=(a, b),
                            name=dv["name"].lstrip("xX"))
            bp, tp = u.bottom_plate, u.top_pad
            tw = min(1.6, (bp.right - bp.left - 0.6) / 2)
            # bottom plate: a tab that touches it
            rc.add(b, c.rect(bot, x0=bp.left, x1=bp.left + tw, y0=bp.bottom - TH, y1=bp.bottom, net=b), group=f"cap{ri}")
            # top plate: top metal from the pad to a via on a separate tab below the bottom plate
            sw = min(1.2, tp.right - tp.left)
            sx1 = tp.right
            tab = c.rect(bot, x0=sx1 - sw / 2 - tw / 2, x1=sx1 - sw / 2 + tw / 2, y0=bp.bottom - S - TH,
                         y1=bp.bottom - S, net=a)
            c.via(bot, topm, at=(sx1 - sw / 2, tab.cy), net=a)
            c.rect(topm, x0=sx1 - sw, x1=sx1, y0=tab.bottom, y1=tp.bottom + min(0.5, tp.top - tp.bottom), net=a)
            rc.add(a, tab, group=f"cap{ri}")
            xx = bp.right + GAP
        yy += max(dv["l"] for dv in row) + 2 * be + GAPY
    out = {}
    for net, ps in list(rc.pins.items()):
        if len(ps) == 1:
            pp = ps[0]
            out[net] = c.rect(bot, x0=pp.x0 / 1000, y0=pp.y0 / 1000, x1=pp.x1 / 1000, y1=pp.y1 / 1000, net=net)
            del rc.pins[net]
    out.update(rc.run())
    return out



def device_rows(name, devices, pins, aspect=1.0, tech=None):
    """Layout of a flat device list (from `classify`): MOS strips in rows inside tap rings (n devices below,
    p devices above), resistors and capacitors to the right, nets wired by the Router, a port per pin."""
    from .route import Router
    t = tech or T.current()
    t.planar_only("device_rows")
    c0, c1 = t.c0, t.c1
    nwell = t.roles.get("nwell")
    c = Cell(name, tech=t)
    r = Router(c)
    _, _, BAR, _ = _sizes(c)
    mos = _merge_fingers([d for d in devices if d["type"] == "mos"])
    for s_ in mos:
        s_["p"] = t.device(s_["kind"]).get("well") == nwell
    names = set()
    for s_ in mos:                                      # unique strip names
        base, k = s_["name"], 1
        while s_["name"] in names:
            k += 1
            s_["name"] = f"{base}_{k}"
        names.add(s_["name"])
    sides = {False: [s_ for s_ in mos if not s_["p"]], True: [s_ for s_ in mos if s_["p"]]}
    for p, lst in sides.items():
        bulks = sorted({s_["b"] for s_ in lst})
        if len(bulks) > 1:
            raise CanvasError(f"from_spice {name}: {'p' if p else 'n'} devices have different bulk nets {bulks}",
                              "device rows put all devices of one polarity in rings of one net; draw this "
                              "cell by hand (mos_strip + guard_ring per bulk net)")

    # measure every strip once in a scratch cell
    probe = Cell("__probe__", tech=t)
    Cell.registry.pop("__probe__", None)
    for s_ in mos:
        _, grp = mos_strip(probe, _NoRouter(), s_["kind"], s_["name"], s_["w"], s_["l"], s_["nf"], s_["g"],
                           s_["s"], s_["d"], at=(0, 0))
        s_["box"] = (grp.left, grp.bottom, grp.right, grp.top)
    GAPX, GAPY, RING = 1.2, 1.0, 1.0
    area = sum((s_["box"][2] - s_["box"][0] + GAPX) * (s_["box"][3] - s_["box"][1] + GAPY) for s_ in mos)
    target = max([(area * aspect) ** 0.5] + [s_["box"][2] - s_["box"][0] for s_ in mos]) if mos else 0.0

    def pack(lst):
        rows_, cur, x = [], [], 0.0
        for s_ in lst:
            wd = s_["box"][2] - s_["box"][0]
            if cur and x + wd > target + 1e-6:
                rows_.append(cur)
                cur, x = [], 0.0
            cur.append(s_)
            x += wd + GAPX
        if cur:
            rows_.append(cur)
        return rows_

    y = 0.0
    rings, right = [], 0.0
    for p in (False, True):
        lst = sides[p]
        if not lst:
            continue
        bulk = lst[0]["b"]
        # strips whose source is the bulk net go next to a ring bar (first row of an n ring, last row of a
        # p ring), where their source straps run straight into the ring
        tied = [s_ for s_ in lst if s_["s"] == bulk and s_["s"] != s_["d"]]
        free = [s_ for s_ in lst if s_ not in tied]
        rows_ = pack(tied) + pack(free) if not p else pack(free) + pack(tied)
        for gi in range(0, len(rows_), 2):                      # at most two rows per ring
            pair = rows_[gi:gi + 2]
            drawn = []
            yy = y
            for ri, row in enumerate(pair):
                edge = (ri == 0) if not p else (ri == len(pair) - 1)
                base = yy - min(s_["box"][1] for s_ in row)
                x = 0.0
                for s_ in row:
                    sup = bulk if edge and s_ in tied else None
                    m, grp = mos_strip(c, r, s_["kind"], s_["name"], s_["w"], s_["l"], s_["nf"], s_["g"], s_["s"],
                                       s_["d"], at=(x - s_["box"][0], base), group=f"{'p' if p else 'n'}{gi + ri}",
                                       supply=sup)
                    drawn.append((m, grp, sup))
                    x = grp.right + GAPX
                yy = max(g_.top for _, g_, _ in drawn) + GAPY
            ring = c.guard_ring("ntap" if p else "ptap", around=[g_ for _, g_, _ in drawn], net=bulk, space=RING)
            for m, grp, sup in drawn:
                if sup is None:
                    continue
                for st in m.sd[0::2]:
                    if p:
                        c.rect(c0, x0=st.left, x1=st.right, y0=st.top, y1=ring.inner[3] + 0.1, net=bulk)
                    else:
                        c.rect(c0, x0=st.left, x1=st.right, y0=ring.inner[1] - 0.1, y1=st.bottom, net=bulk)
            rings.append((ring, bulk, "ntap" if p else "ptap"))
            right = max(right, ring.outer[2])
            y = ring.outer[3] + 3.0

    # passives, right of the rings. Resistors with a bulk terminal stand in a substrate ring of that net.
    x = right + 3.0 if rings else 0.0
    res = [dv for dv in devices if dv["type"] == "res"]
    for bulk in dict.fromkeys(dv["nodes"][2] if len(dv["nodes"]) > 2 else None for dv in res):
        mine = [dv for dv in res if (dv["nodes"][2] if len(dv["nodes"]) > 2 else None) == bulk]
        ringed = bulk is not None and not any(b_ == bulk and k_ == "ptap" for _, b_, k_ in rings)
        if ringed:
            x += 3.0
        drawn = []
        for dv in mine:
            a, b = dv["nodes"][:2]
            rz = c.resistor(dv["kind"], w=dv["w"], l=dv["l"], at=(x, 3.0), nets=(a, b), name=dv["name"].lstrip("xX"),
                            orient="v", **({"bulk": bulk} if bulk is not None else {}))
            drawn.append(rz)
            for pad, net in ((rz.a, a), (rz.b, b)):
                v = c.via(c0, c1, at=pad, net=net, dir="h", top_dir="h")
                _pin(c, r, net, v.upper.cx, v.upper.cy, BAR, "rc")
            x = max(rz.right, rz.a.right, rz.b.right) + 1.5
        if ringed:
            ring = c.guard_ring("ptap", around=drawn, net=bulk, space=1.5)
            rings.append((ring, bulk, "ptap"))
            x = ring.outer[2] + 3.0
    caps = [dv for dv in devices if dv["type"] == "mim"]
    cap_h = {}
    if caps:
        shared = {n for dv in devices if dv["type"] != "mim" for n in dv["nodes"]}
        cap_h = _cap_array(c, r, caps, shared, x, BAR)

    # a pin on every ring whose net is used elsewhere (gates at a supply, sources that are not at a ring bar, ...)
    ring_of = {}
    for ring, bulk, _ in rings:
        ring_of.setdefault(bulk, ring)
    for i, (ring, bulk, _) in enumerate(rings):
        if bulk in r.pins or sum(1 for q in rings if q[1] == bulk) > 1:
            st = ring.bottom_bar.strap
            v = c.via(c0, c1, at=(st.cx, st.cy), net=bulk, dir="h", top_dir="h")
            _pin(c, r, bulk, v.upper.cx, v.upper.cy, BAR, f"ring{i}")
    single = {net: ps[0] for net, ps in r.pins.items() if len(ps) == 1}
    for net in single:
        del r.pins[net]
    h = r.run()
    for net in pins:
        if net in h:
            c.port(net, on=h[net])
        elif net in ring_of:
            c.port(net, on=ring_of[net].straps[0])
        elif net in single:
            pp = single[net]
            c.port(net, on=c.rect(c1, x0=pp.x0 / 1000, y0=pp.y0 / 1000, x1=pp.x1 / 1000, y1=pp.y1 / 1000, net=net))
        elif net in cap_h:
            c.port(net, on=cap_h[net])
        else:
            raise CanvasError(f"from_spice {name}: pin {net} is not connected to any device")
    c.strips = [s_["name"] for s_ in mos]
    return c
