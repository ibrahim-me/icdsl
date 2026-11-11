from icdsl.canvas import *

tech = use()
c0 = tech.c0
c1 = tech.c1
c2 = tech.c2
c3 = tech.c3
topm = tech.stack[-1]
has_res = "res_poly" in tech.d["devices"]
has_cap = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

sp = 0.8          # spacing between device groups (um)
rowsep = 3.0      # vertical separation between NMOS and PMOS rows

# ---------- NMOS row (bottom) ----------
y_n = 0.0
x = 0.0

m8  = c.mos("nmos", w=2.0, l=1.0, nf=2, gates="IB",  sd=("VSS", "IB"),  at=(x, y_n)); x = m8.diff.right + sp
m5  = c.mos("nmos", w=2.0, l=1.0, nf=4, gates="IB",  sd=("VSS", "tail"), at=(x, y_n)); x = m5.diff.right + sp
m1  = c.mos("nmos", w=4.0, l=0.5, nf=2, gates="INN", sd=("tail", "d1"), at=(x, y_n)); x = m1.diff.right + sp
m2  = c.mos("nmos", w=4.0, l=0.5, nf=2, gates="INP", sd=("tail", "d2"), at=(x, y_n)); x = m2.diff.right + sp
m7  = c.mos("nmos", w=2.0, l=1.0, nf=8, gates="IB",  sd=("VSS", "OUT"), at=(x, y_n)); x = m7.diff.right + sp
nmos_devs = [m8, m5, m1, m2, m7]
nmos_right = x

# ---------- PMOS row (top) ----------
y_p = y_n + max(m.diff.h for m in nmos_devs) + rowsep
x = 0.0

m3  = c.mos("pmos", w=4.0, l=1.0, nf=2, gates="d1", sd=("VDD", "d1"), at=(x, y_p)); x = m3.diff.right + sp
m4  = c.mos("pmos", w=4.0, l=1.0, nf=2, gates="d1", sd=("VDD", "d2"), at=(x, y_p)); x = m4.diff.right + sp
m6  = c.mos("pmos", w=4.0, l=0.5, nf=8, gates="d2", sd=("VDD", "OUT"), at=(x, y_p)); x = m6.diff.right + sp
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
    m9 = c.mos("nmos", w=2.0, l=1.0, nf=1, gates="VDD", sd=("d2", "x"), at=(nmos_right + sp, y_n))
    mc = c.mos("nmos", w=20.0, l=1.0, nf=1, gates="OUT", sd=("x", "x"), at=(nmos_right + sp, y_n + 6))
    rza, rzb = m9.sd[0], mc.sd[0]
    cb = mc.sd[0]

# ---------- routing ----------
r = Router(c, v=c2, h=c3, pin_layer=c1)

def P(inst, name):
    return inst.pin(name)

r.add("VSS", P(m8, "sd[0]"), grn.straps[0])
r.add("VDD", P(m3, "sd[0]"), grp.straps[0])
r.add("IB",  P(m8, "gates[0]"), P(m5, "gates[0]"), P(m7, "gates[0]"))
r.add("INN", P(m1, "gates[0]"))
r.add("INP", P(m2, "gates[0]"))
r.add("tail", P(m5, "sd[1]"), P(m1, "sd[0]"), P(m2, "sd[0]"))
r.add("d1", P(m1, "sd[1]"), P(m3, "sd[1]"), P(m3, "gates[0]"), P(m4, "gates[0]"))
r.add("d2", P(m2, "sd[1]"), P(m4, "sd[1]"), P(m6, "gates[0]"), rza)
r.add("x", rzb)
r.add("OUT", P(m6, "sd[1]"), P(m7, "sd[1]"), cb)

try:
    r.run()
except Exception:
    r.add("d2", P(m2, "sd[1]"), P(m4, "sd[1]"), P(m6, "gates[0]"), rza)
    r.add("OUT", P(m6, "sd[1]"), P(m7, "sd[1]"), cb)
    r.run()

# ---------- ports ----------
c.port("INP", on=P(m2, "gates[0]"), dir="in")
c.port("INN", on=P(m1, "gates[0]"), dir="in")
c.port("IB",  on=P(m8, "gates[0]"), dir="in")
c.port("OUT", on=cb, dir="out")
c.port("VDD", on=P(m3, "sd[0]"))
c.port("VSS", on=P(m8, "sd[0]"))

TOP = c
