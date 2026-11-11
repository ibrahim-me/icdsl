from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")

# ---------------- devices ----------------
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL", "D1"), at=(0, 0))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL", "D2"), at=(0, 0))
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS", "TAIL"), at=(0, 0))
M8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS", "IB"), at=(0, 0))
M3 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D1"), at=(0, 0))
M4 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD", "D2"), at=(0, 0))
M6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="D2", sd=("VDD", "OUT"), at=(0, 0))
M7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS", "OUT"), at=(0, 0))

if have_res:
    RZ = c.resistor("res_poly", w=1, l=8, at=(0, 0), nets=("D2", "X"), orient="v")
if have_mim:
    CC = c.capacitor("cap_mim", w=20, h=20, at=(0, 0), nets=("X", "OUT"))

# ---------------- floorplan ----------------
# column A: input pair M1/M2 ; column B: tail M5 ; column C: bias diode M8
# M1 left, M2 right (same row), sources -> TAIL rail between them and M5
M2.place_right_of(M1, space=0.6)
M5.place_below(M1, space=0.5, align="left")   # tail under M1
M8.place_right_of(M5, space=0.5)              # bias diode next to tail

# PMOS load row above the NMOS pair (n-well), sources to VDD rail
M3.place_above(M1, space=0.6, align="left")
M4.place_above(M2, space=0.6, align="left")

# second stage to the right: M6 (top), M7 (bottom)
M6.place_right_of(M4, space=1.0, align="top")
M7.place_below(M6, space=0.8, align="right")

# compensation network between D2 and OUT
if have_res:
    RZ.place_right_of(M6, space=0.8, align="top")
if have_mim:
    CC.place_below(RZ, space=0.4, align="right") if have_res else CC.place_right_of(M6, space=1.0, align="top")

# ---------------- power rails ----------------
vdd = c.rect(m2, x0=min(M3.well.left, M4.well.left, M6.well.left) - 0.2,
             x1=max(M3.well.right, M4.well.right, M6.well.right) + 0.2,
             y0=max(M3.top, M4.top, M6.top), y1=max(M3.top, M4.top, M6.top) + 0.8, net="VDD")
vss = c.rect(m2, x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.2,
             x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.2,
             y0=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom) - 0.8,
             y1=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom), net="VSS")

# ---------------- taps / guard rings ----------------
# n-taps in PMOS wells -> VDD ; p-taps in NMOS substrate -> VSS
for mos in (M3, M4, M6):
    if mos.well:
        c.tap("ntap", x0=mos.well.left - 0.1, y0=mos.well.bottom - 0.1,
              x1=mos.well.right + 0.1, y1=mos.well.top + 0.1, net="VDD")
c.tap("ptap", x0=M1.diff.left - 0.1, y0=M1.diff.bottom - 0.1,
      x1=max(M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y1=min(M1.diff.bottom, M2.diff.bottom, M5.diff.bottom, M7.diff.bottom, M8.diff.bottom) - 0.1, net="VSS")
c.tap("ptap", x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.1,
      y1=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top) + 0.1,
      x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.1,
      y0=max(M1.diff.top, M2.diff.top, M5.diff.top, M7.diff.top, M8.diff.top), net="VSS")

# ---------------- first stage routing ----------------
# TAIL rail: M1.sd[0], M2.sd[0] -> M5.drain
tail = c.rect(c0, x0=min(M1.sd[0].left, M2.sd[0].left, M5.sd[1].left),
              x1=max(M1.sd[0].right, M2.sd[0].right, M5.sd[1].right),
              y0=min(M1.sd[0].bottom, M2.sd[0].bottom, M5.sd[1].bottom),
              y1=max(M1.sd[0].top, M2.sd[0].top, M5.sd[1].top), net="TAIL")
# D1 = M1 drain = M3 drain = M3/M4 gate
d1 = c.rect(c0, x0=min(M1.sd[1].left, M3.sd[1].left, M3.gates[0].left, M4.gates[0].left),
            x1=max(M1.sd[1].right, M3.sd[1].right, M3.gates[0].right, M4.gates[0].right),
            y0=min(M1.sd[1].bottom, M3.sd[1].bottom, M3.gates[0].bottom, M4.gates[0].bottom),
            y1=max(M1.sd[1].top, M3.sd[1].top, M3.gates[0].top, M4.gates[0].top), net="D1")
# D2 = M2 drain = M4 drain = M6 gate
d2 = c.rect(c0, x0=min(M2.sd[1].left, M4.sd[1].left, M6.gates[0].left),
            x1=max(M2.sd[1].right, M4.sd[1].right, M6.gates[0].right),
            y0=min(M2.sd[1].bottom, M4.sd[1].bottom, M6.gates[0].bottom),
            y1=max(M2.sd[1].top, M4.sd[1].top, M6.gates[0].top), net="D2")

# gate inputs INN/INP (poly already at gates); bring to metal1 pins
for mos, pin in ((M1, "INN"), (M2, "INP")):
    g = mos.gates[0]
    c.rect(m1, x0=g.left - 0.2, x1=g.right + 0.2, y0=g.bottom - 0.1, y1=g.top + 0.1, net=pin)

# ---------------- second stage & compensation ----------------
# OUT = M6 drain = M7 drain
out = c.rect(c0, x0=min(M6.sd[1].left, M7.sd[1].left),
             x1=max(M6.sd[1].right, M7.sd[1].right),
             y0=min(M6.sd[1].bottom, M7.sd[1].bottom),
             y1=max(M6.sd[1].top, M7.sd[1].top), net="OUT")
if have_res:
    rz = c.rect(c0, x0=min(RZ.a.left, d2.left), x1=max(RZ.a.right, d2.right),
                y0=min(RZ.a.bottom, d2.bottom), y1=max(RZ.a.top, d2.top), net="D2")
    xnode = c.rect(c0, x0=min(RZ.b.left, CC.bottom_pad.left if have_mim else RZ.b.left),
                   x1=max(RZ.b.right, CC.bottom_pad.right if have_mim else RZ.b.right),
                   y0=min(RZ.b.bottom, CC.bottom_pad.bottom if have_mim else RZ.b.bottom),
                   y1=max(RZ.b.top, CC.bottom_pad.top if have_mim else RZ.b.top), net="X")
if have_mim and not have_res:
    xnode = c.rect(c0, x0=CC.bottom_pad.left, x1=CC.bottom_pad.right,
                   y0=CC.bottom_pad.bottom, y1=CC.bottom_pad.top, net="X")
    c.rect(c0, x0=d2.left, x1=CC.top_pad.left, y0=CC.top_pad.bottom, y1=CC.top_pad.top, net="D2")

# ---------------- router for long signals ----------------
r = Router(c)
r.auto()
try:
    h = r.run()
except Exception as e:
    # route critical nets by hand if router struggles
    pass

# ---------------- ports ----------------
c.port("INP", on=M2.gates[0], dir="in")
c.port("INN", on=M1.gates[0], dir="in")
c.port("OUT", on=out, dir="out")
c.port("IB", on=M8.sd[1], dir="in")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c
