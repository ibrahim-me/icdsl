```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
c1 = tech.c1
c2 = tech.c2
c3 = tech.c3
has_res = "res_poly" in tech.d["devices"]
has_cap = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

sp = 0.8
rowsep = 3.0
gext = (0.9, 0.9)          # gate extension so a contact fits outside the channel

# ---------- NMOS row (bottom) ----------
y_n = 0.0
x = 0.0
m8  = c.mos("nmos", w=2.0, l=1.0, nf=2, gates="IB",  sd=("VSS", "IB"),  at=(x, y_n), gate_ext=gext); x = m8.diff.right + sp
m5  = c.mos("nmos", w=2.0, l=1.0, nf=4, gates="IB",  sd=("VSS", "tail"), at=(x, y_n), gate_ext=gext); x = m5.diff.right + sp
m1  = c.mos("nmos", w=4.0, l=0.5, nf=2, gates="INN", sd=("tail", "d1"), at=(x, y_n), gate_ext=gext); x = m1.diff.right + sp
m2  = c.mos("nmos", w=4.0, l=0.5, nf=2, gates="INP", sd=("tail", "d2"), at=(x, y_n), gate_ext=gext); x = m2.diff.right + sp
m7  = c.mos("nmos", w=2.0, l=1.0, nf=8, gates="IB",  sd=("VSS", "OUT"), at=(x, y_n), gate_ext=gext); x = m7.diff.right + sp
nmos_devs = [m8, m5, m1, m2, m7]
nmos_right = x

# ---------- PMOS row (top) ----------
y_p = y_n + max(m.diff.h for m in nmos_devs) + rowsep
x = 0.0
m3  = c.mos("pmos", w=4.0, l=1.0, nf=2, gates="d1", sd=("VDD", "d1"), at=(x, y_p), gate_ext=gext); x = m3.diff.right + sp
m4  = c.mos("pmos", w=4.0, l=1.0, nf=2, gates="d1", sd=("VDD", "d2"), at=(x, y_p), gate_ext=gext); x = m4.diff.right + sp
m6  = c.mos("pmos", w=4.0, l=0.5, nf=8, gates="d2", sd=("VDD", "OUT"), at=(x, y_p), gate_ext=gext); x = m6.diff.right + sp
pmos_devs = [m3, m4, m6]
pmos_right = x

# ---------- n-well under PMOS row ----------
nwell_en = tech.enc("nwell", "diff")
nwell_en = nwell_en[0] if isinstance(nwell_en, tuple) else nwell_en
nw = c.rect("nwell",
    x0=min(m.diff.left for m in pmos_devs) - nwell_en,
    x1=max(m.diff.right for m in pmos_devs) + nwell_en,
    y0=y_p - nwell_en,
    y1=y_p + max(m.diff.h for m in pmos_devs) + nwell_en, net="VDD")

# ---------- guard rings ----------
grn = c.guard_ring("ptap", around=nmos_devs, net="VSS", space=0.6)
grp = c.guard_ring("ntap", around=pmos_devs, net="VDD", space=0.6)

# ---------- compensation network ----------
if has_res and has_cap:
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(nmos_right + sp, y_n), nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(nmos_right + sp, y_n + 12), nets=("x", "OUT"))
    cb = c.rect(c1, x0=cc.bottom_pad.left, x1=cc.bottom_pad.right,
                y0=cc.bottom_pad.bottom - 0.6, y1=cc.bottom_pad.top, net="OUT")
    c.via(c0, c1, at=cc.bottom_pad, net="OUT")
    rza, rzb = rz.a, rz.b
else:
    m9 = c.mos("nmos", w=2.0, l=1.0, nf=1, gates="VDD", sd=("d2", "x"), at=(nmos_right + sp, y_n), gate_ext=gext)
    mc = c.mos("nmos", w=20.0, l=1.0, nf=1, gates="OUT", sd=("x", "x"), at=(nmos_right + sp, y_n + 6), gate_ext=gext)
    rza, rzb = m9.sd[0], mc.sd[0]
    cb = mc.sd[0]

# ---------- build c1 landing pads for the router ----------
def term_shapes(dev, net):
    out = []
    out.extend(s for s, n in zip(dev.sd, dev.nets_sd) if n == net)
    out.extend(g for g, n in zip(dev.gates, dev.nets_g) if n == net)
    return out

def gate_pt(g, d):
    """a point on the gate poly outside the diff (gate extension)"""
    if g.right > d.right:
        return ((g.right + d.right) / 2, g.cy)
    if g.left < d.left:
        return ((g.left + d.left) / 2, g.cy)
    return (g.cx, g.cy)

def land(net, devs):
    """one c1 landing pad covering all terminals of `net` in `devs`, with vias"""
    shapes = []
    for d in devs:
        shapes.extend(term_shapes(d, net))
    if not shapes:
        return None
    bboxes = [s.bbox for s in shapes]
    m = 0.55
    x0 = min(b[0] for b in bboxes) - m
    x1 = max(b[2] for b in bboxes) + m
    y0 = min(b[1] for b in bboxes) - m
    y1 = max(b[3] for b in bboxes) + m
    # make the pad at least 1.0 um in each direction so vias fit
    if x1 - x0 < 1.0:
        cx = (x0 + x1) / 2; x0 = cx - 0.5; x1 = cx + 0.5
    if y1 - y0 < 1.0:
        cy = (y0 + y1) / 2; y0 = cy - 0.5; y1 = cy + 0.5
    pad = c.rect(c1, x0=x0, x1=x1, y0=y0, y1=y1, net=net)
    for s in shapes:
        if s.layer == "poly":
            d = next(dev for dev in devs if s in dev.gates)
            pt = gate_pt(s, d.diff)
            c.via("poly", c0, at=pt, net=net)
            c.via(c0, c1, at=pt, net=net)
        else:
            c.via(s.layer, c1, at=(s.cx, s.cy), net=net)
    return pad

alldev = nmos_devs + pmos_devs
pads = {}
for net in ("VSS", "VDD", "IB", "INN", "INP", "tail", "d1", "d2", "x", "OUT"):
    pads[net] = land(net, alldev)
    if net == "x" and not has_res and not has_cap:
        pads[net] = rzb
    if net == "OUT" and not has_res and not has_cap:
        pads[net] = cb

# ---------- router ----------
r = Router(c, v=c2, h=c3, pin_layer=c1)
r.add("VSS", pads["VSS"], grn.straps[0])
r.add("VDD", pads["VDD"], grp.straps[0])
r.add("IB",  pads["IB"])
r.add("INN", pads["INN"])
r.add("INP", pads["INP"])
r.add("tail", pads["tail"])
r.add("d1", pads["d1"])
r.add("d2", pads["d2"], rza)
r.add("x", pads["x"])
r.add("OUT", pads["OUT"], cb)
r.run()

# ---------- ports ----------
c.port("INP", on=pads["INP"], dir="in")
c.port("INN", on=pads["INN"], dir="in")
c.port("IB",  on=pads["IB"],  dir="in")
c.port("OUT", on=cb, dir="out")
c.port("VDD", on=pads["VDD"])
c.port("VSS", on=pads["VSS"])

TOP = c

```