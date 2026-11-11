from icdsl.canvas import *
tech = use()
c0 = tech.c0
c1 = tech.metal(1)
c2 = tech.metal(2)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

sp = 0.8

# ---------- NMOS row ----------
y_n = 0.0
x = 0.0
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
row_n_right = x
row_n_bottom = min(m.diff.bottom for m in (m8, m5, m1, m2, m7))
row_n_top = max(m.diff.top for m in (m8, m5, m1, m2, m7))

# ---------- PMOS row ----------
y_p = row_n_top + 2.0
x = 0.0
m3 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d1"), at=(x, y_p))
x = m3.diff.right + sp
m4 = c.mos("pmos", w=4, l=1, nf=2, gates="d1", sd=("VDD", "d2"), at=(x, y_p))
x = m4.diff.right + sp
m6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="d2", sd=("VDD", "OUT"), at=(x, y_p))
x = m6.diff.right + sp
row_p_right = x
row_p_bottom = min(m.diff.bottom for m in (m3, m4, m6))
row_p_top = max(m.diff.top for m in (m3, m4, m6))

# ---------- Power rails ----------
vss = c.rect(c0, x0=m8.diff.left - 0.4, x1=row_n_right + 0.4,
             y0=row_n_bottom - 1.0, y1=row_n_bottom - 0.5, net="VSS")
vdd = c.rect(c0, x0=m3.diff.left - 0.4, x1=row_p_right + 0.4,
             y0=row_p_top + 0.5, y1=row_p_top + 1.0, net="VDD")
c.rect(c1, x0=vss.left - 0.2, x1=vss.right + 0.2, y0=vss.bottom, y1=vss.top, net="VSS")
c.rect(c1, x0=vdd.left - 0.2, x1=vdd.right + 0.2, y0=vdd.bottom, y1=vdd.top, net="VDD")
c.via(c0, c1, at=(vss.cx, vss.cy), net="VSS")
c.via(c0, c1, at=(vdd.cx, vdd.cy), net="VDD")

# ---------- Connect source/drain to power rails ----------
def connect_sd_to_rail(m, sd_pair, nf, target_net, rail):
    for i in range(nf + 1):
        snet = sd_pair[0] if i % 2 == 0 else sd_pair[1]
        if snet == target_net:
            c.wire(c0, [m.sd[i], (m.sd[i].cx, rail.cy), rail], net=target_net)

connect_sd_to_rail(m8, ("VSS", "IB"), 2, "VSS", vss)
connect_sd_to_rail(m5, ("VSS", "tail"), 4, "VSS", vss)
connect_sd_to_rail(m7, ("VSS", "OUT"), 8, "VSS", vss)
connect_sd_to_rail(m3, ("VDD", "d1"), 2, "VDD", vdd)
connect_sd_to_rail(m4, ("VDD", "d2"), 2, "VDD", vdd)
connect_sd_to_rail(m6, ("VDD", "OUT"), 8, "VDD", vdd)

# ---------- Gate strapping with metal1 + licon ----------
def strap_gates(m, net):
    if len(m.gates) <= 1:
        return
    x0 = m.gates[0].left - 0.05
    x1 = m.gates[-1].right + 0.05
    y0 = m.gates[0].bottom - 0.05
    y1 = m.gates[0].top + 0.05
    strap = c.rect(c1, x0=x0, x1=x1, y0=y0, y1=y1, net=net)
    for g in m.gates:
        c.via("poly", c1, at=(g.cx, g.cy), net=net, dir="h")
    return strap

strap_gates(m8, "IB")
strap_gates(m5, "IB")
strap_gates(m7, "IB")
strap_gates(m3, "d1")
strap_gates(m4, "d1")
strap_gates(m6, "d2")

# ---------- Signal routing ----------
c.wire(c0, [m5.sd[1], (m1.sd[0].cx, m5.sd[1].cy), m1.sd[0]], net="tail")
c.wire(c0, [m1.sd[2], (m2.sd[0].cx, m1.sd[2].cy), m2.sd[0]], net="tail")

c.wire(c0, [m8.sd[1], (m5.gates[0].cx, m8.sd[1].cy), m5.gates[0]], net="IB")
c.wire(c0, [m5.gates[-1], (m7.gates[0].cx, m5.gates[-1].cy), m7.gates[0]], net="IB")
c.wire(c0, [m7.gates[-1], (m8.gates[0].cx, m7.gates[-1].cy), m8.gates[0]], net="IB")

c.wire(c2, [m1.sd[1], (m1.sd[1].cx, y_p + 0.5), (m3.sd[1].cx, y_p + 0.5), m3.sd[1]], net="d1")
c.wire(c2, [m3.gates[-1], (m3.gates[-1].cx, y_p + 0.5), (m4.gates[0].cx, y_p + 0.5), m4.gates[0]], net="d1")

c.wire(c2, [m2.sd[1], (m2.sd[1].cx, y_p + 0.5), (m4.sd[1].cx, y_p + 0.5), m4.sd[1]], net="d2")
c.wire(c2, [m4.gates[-1], (m4.gates[-1].cx, y_p + 0.5), (m6.gates[0].cx, y_p + 0.5), m6.gates[0]], net="d2")

c.port("INN", on=m1.gates[0], dir="in")
c.port("INP", on=m2.gates[0], dir="in")

# ---------- Compensation ----------
if have_res and have_mim:
    rz = c.resistor("res_poly", w=1.0, l=8.0, at=(m6.diff.right + 1.0, y_p + 1.0), nets=("d2", "x"))
    cc = c.capacitor("cap_mim", w=20, h=20, at=(rz.b.right + 1.0, y_p + 1.0), nets=("x", "OUT"))
    c.wire(c2, [m6.sd[1], (rz.a.left, m6.sd[1].cy), rz.a], net="d2")
    c.wire(c2, [rz.b, (cc.b.left, rz.b.cy), cc.b], net="x")
    c.wire(c2, [cc.top_pad, (cc.top_pad.cx, m6.sd[1].cy), m6.sd[1]], net="OUT")
    c.wire(c2, [m7.sd[1], (m7.sd[1].cx, cc.top_pad.cy), (cc.top_pad.cx, cc.top_pad.cy), cc.top_pad], net="OUT")
else:
    m9 = c.mos("nmos", w=1, l=1, nf=1, gates="VDD", sd=("d2", "x"), at=(m6.diff.right + 1.0, y_p + 1.0))
    mc = c.mos("nmos", w=1, l=1, nf=1, gates="OUT", sd=("x", "x"), at=(m9.diff.right + 0.6, y_p + 1.0))
    c.wire(c2, [m6.sd[1], (m9.sd[0].left, m6.sd[1].cy), m9.sd[0]], net="d2")
    c.wire(c2, [m9.sd[1], (mc.sd[0].left, m9.sd[1].cy), mc.sd[0]], net="x")
    c.wire(c2, [mc.gates[0], (mc.gates[0].cx, m6.sd[1].cy), m6.sd[1]], net="OUT")
    c.wire(c2, [m7.sd[1], (m7.sd[1].cx, mc.gates[0].cy), (mc.gates[0].cx, mc.gates[0].cy), mc.gates[0]], net="OUT")

c.wire(c2, [m6.sd[1], (m6.sd[1].cx, m7.sd[1].cy), m7.sd[1]], net="OUT")
c.port("OUT", on=m7.sd[1], dir="out")

c.port("IB", on=m8.gates[0], dir="in")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

# ---------- Guard rings ----------
gr_n = c.guard_ring("ptap", around=[m1, m2, m5, m7, m8], net="VSS", space=0.6)
gr_p = c.guard_ring("ntap", around=[m3, m4, m6], net="VDD", space=0.6)

TOP = c
