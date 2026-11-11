```python
from icdsl.canvas import *
tech = use()
c0 = tech.c0
c1 = tech.metal(1)
c2 = tech.metal(2)
top = tech.stack[-1]
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

# ------------------------------------------------------------------ placement
y_n = 0.0
x = 0.0
sp = 0.8

m8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS", "IB"), at=(x, y_n))
x = m8.diff.right + sp
m5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "tail"), at=(x, y_n))
x = m5.diff.right + sp
m1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("tail", "d1"), at=(x, y_n))
x = m1.diff.right + sp
m2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("tail", "d2"), at=(x, y_n))
x = m2.diff.right + sp
m7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS", "OUT"), at=(x, y_n))
x = m7.diff.right + sp

y_p = max(m.diff.h for m in (m8, m5, m1, m2, m7)) + 2.0
x = 0.0
m3 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d1"), at=(x, y_p))
x = m3.diff.right + sp
m4 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d2"), at=(x, y_p))
x = m4.diff.right + sp
m6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="d2", sd=("VDD", "OUT"), at=(x, y_p))
x = m6.diff.right + sp

# ------------------------------------------------------------------ power rails
vss = c.rect(c0, x0=m8.diff.left - 0.4, x1=m7.diff.right + 0.4,
             y0=m8.diff.bottom - 0.9, y1=m8.diff.bottom - 0.5, net="VSS")
vdd = c.rect(c0, x0=m3.diff.left - 0.4, x1=m6.diff.right + 0.4,
             y0=m6.diff.top + 0.5, y1=m6.diff.top + 0.9, net="VDD")

for m in (m1, m2, m5, m7, m8):
    c.rect(c0, x0=m.sd[0].left, x1=m.sd[-1].right, y0=vss.top, y1=m.sd[0].top, net="VSS")
for m in (m3, m4, m6):
    c.rect(c0, x0=m.sd[0].left, x1=m.sd[-1].right, y0=m.sd[0].bottom, y1=vdd.bottom, net="VDD")

c.rect(c1, x0=vss.left - 0.2, x1=vss.right + 0.2, y0=vss.bottom, y1=vss.top, net="VSS")
c.rect(c1, x0=vdd.left - 0.2, x1=vdd.right + 0.2, y0=vdd.bottom, y1=vdd.top, net="VDD")
c.via(c0, c1, at=(vss.cx, (vss.bottom + vss.top) / 2), net="VSS")
c.via(c0, c1, at=(vdd.cx, (vdd.bottom + vdd.top) / 2), net="VDD")

# ------------------------------------------------------------------ signal routing
# tail: M5 drain -> M1/M2 sources
c.wire(c0, [m5.sd[-1], (m1.sd[0].cx, m5.sd[-1].cy), m1.sd[0]], net="tail")
c.wire(c0, [m1.sd[-1], (m2.sd[0].cx, m1.sd[-1].cy), m2.sd[0]], net="tail")

# IB: M8 drain/gate -> M5/M7 gates
c.wire(c0, [m8.sd[-1], (m5.gates[0].cx, m8.sd[-1].cy), m5.gates[0]], net="IB")
c.wire(c0, [m5.gates[-1], (m7.gates[0].cx, m5.gates[-1].cy), m7.gates[0]], net="IB")
c.wire(c0, [m7.gates[-1], (m8.gates[0].cx, m7.gates[-1].cy), m8.gates[0]], net="IB")

# d1: M1 drain -> M3 drain/gate -> M4 gate
c.wire(c2, [m1.sd[-1], (m1.sd[-1].cx, y_p + 0.5), (m3.sd[-1].cx, y_p + 0.5), m3.sd[-1]], net="d1")
c.wire(c2, [m3.gates[-1], (m3.gates[-1].cx, y_p + 0.5), (m4.gates[0].cx, y_p + 0.5), m4.gates[0]], net="d1")

# d2: M2 drain -> M4 drain -> M6 gate
c.wire(c2, [m2.sd[-1], (m2.sd[-1].cx, y_p + 0.5), (m4.sd[-1].cx, y_p + 0.5), m4.sd[-1]], net="d2")
c.wire(c2, [m4.gates[-1], (m4.gates[-1].cx, y_p + 0.5), (m6.gates[0].cx, y_p + 0.5), m6.gates[0]], net="d2")

# INN, INP
c.port("INN", on=m1.gates[0], dir="in")
c.port("INP", on=m2.gates[0], dir="in")

# ------------------------------------------------------------------ compensation
if have_res and have_mim:
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(m6.diff.right + 1.0, y_p + 1.0), nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(rz.b.right + 1.0, y_p + 1.0), nets=("x", "OUT"))
    c.wire(c2, [m6.sd[-1], (rz.a.left, m6.sd[-1].cy), rz.a], net="d2")
    c.wire(c2, [rz.b, (cc.b.left, rz.b.cy), cc.b], net="x")
    c.wire(c2, [cc.top_pad, (cc.top_pad.cx, m6.sd[-1].cy), m6.sd[-1]], net="OUT")
    c.wire(c2, [m7.sd[-1], (m7.sd[-1].cx, cc.top_pad.cy), (cc.top_pad.cx, cc.top_pad.cy), cc.top_pad], net="OUT")
else:
    m9 = c.mos("nmos", w=1, l=1, nf=1, gates="VDD", sd=("d2", "x"), at=(m6.diff.right + 1.0, y_p + 1.0))
    mc = c.mos("nmos", w=1, l=1, nf=1, gates="OUT", sd=("x", "x"), at=(m9.diff.right + 0.6, y_p + 1.0))
    c.wire(c2, [m6.sd[-1], (m9.sd[0].left, m6.sd[-1].cy), m9.sd[0]], net="d2")
    c.wire(c2, [m9.sd[-1], (mc.sd[0].left, m9.sd[-1].cy), mc.sd[0]], net="x")
    c.wire(c2, [mc.gates[0], (mc.gates[0].cx, m6.sd[-1].cy), m6.sd[-1]], net="OUT")
    c.wire(c2, [m7.sd[-1], (m7.sd[-1].cx, mc.gates[0].cy), (mc.gates[0].cx, mc.gates[0].cy), mc.gates[0]], net="OUT")

# ------------------------------------------------------------------ OUT port
c.wire(c2, [m6.sd[-1], (m6.sd[-1].cx, m7.sd[-1].cy), m7.sd[-1]], net="OUT")
c.port("OUT", on=m7.sd[-1], dir="out")

# ------------------------------------------------------------------ IB port
c.port("IB", on=m8.gates[0], dir="in")

# ------------------------------------------------------------------ VDD/VSS ports
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

# ------------------------------------------------------------------ guard rings
gr_n = c.guard_ring("ptap", around=[m1, m2, m5, m7, m8], net="VSS", space=0.6)
gr_p = c.guard_ring("ntap", around=[m3, m4, m6], net="VDD", space=0.6)
if gr_n.well:
    c.rect(gr_n.well.layer, x0=gr_n.well.left, x1=gr_n.well.right, y0=gr_n.well.bottom, y1=gr_n.well.top, net="VSS")
if gr_p.well:
    c.rect(gr_p.well.layer, x0=gr_p.well.left, x1=gr_p.well.right, y0=gr_p.well.bottom, y1=gr_p.well.top, net="VDD")

TOP = c
```