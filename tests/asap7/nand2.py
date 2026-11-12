"""ASAP7 (7 nm FinFET): NAND2 + tap column from the device helpers. Two n-transistors in series on one
active (the column between them has no contact), two p-transistors in parallel; same 7.5-track
architecture as inv.py."""
from icdsl.canvas import *

tech = use("asap7")
c = Cell("nand2")
H = tech.rule("cell_height")
FP, GP = tech.rule("fin_pitch"), tech.rule("gate_pitch")
YN, YP, WF = FP, 6 * FP, 3 * FP
MID = H / 2
LO, HI = (YN, MID - YN - WF - 0.005), (YP - MID - 0.005, YN)     # gate extensions: rail .. middle .. rail

n = c.mos("nmos", w=WF, nf=2, at=(0.046, YN), gates=["A", "B"], sd=["VSS", "x", "Y"],
          contacts=[True, False, True], gate_ext=LO)
p = c.mos("pmos", w=WF, nf=2, at=(0.046, YP), gates=["A", "B"], sd=["VDD", "Y", "VDD"], gate_ext=HI)
pt = c.tap("ptap", at=(n.x_next, YN), h=WF, net="VSS", gate_ext=LO)
nt = c.tap("ntap", at=(p.x_next, YP), h=WF, net="VDD", gate_ext=HI)
W = pt.x_next - 0.046

vss = c.rect("m1", x0=0, x1=W, cy=0, h=0.018, net="VSS")
vdd = c.rect("m1", x0=0, x1=W, cy=H, h=0.018, net="VDD")
for rail in (vss, vdd):
    c.rect("lig", x0=0, x1=W, cy=rail.cy, h=0.016, net=rail.net)
    c.rect("gcut", x0=0, x1=W, cy=rail.cy, h=0.044)
c.rect("nwell", x0=0, x1=W, y0=MID, y1=H, net="VDD")

for s, rail in ((n.sd[0], vss), (pt.strap, vss), (p.sd[0], vdd), (p.sd[2], vdd), (nt.strap, vdd)):
    c.rect("lisd", x0=s.left, x1=s.right, y0=min(s.bottom, rail.cy), y1=max(s.top, rail.cy), net=rail.net)
    c.via("lig", "m1", at=(s.cx, rail.cy), net=rail.net, dir="h", bottom_pad=False)

a = c.via("gate", "m1", at=(n.gx[0], MID), net="A")
b = c.via("gate", "m1", at=(n.gx[1], MID), net="B")
xt = n.gx[1] + GP                                  # m1 track over the right dummy gate
y = c.rect("m1", cx=xt, w=0.018, y0=n.sd[2].bottom, y1=p.sd[1].top, net="Y")
for d, yv in ((n.sd[2], n.sd[2].bottom + 0.009), (p.sd[1], p.sd[1].top - 0.009)):
    v = c.via("lisd", "m1", at=(d.cx, yv), net="Y", dir="h", bottom_pad=False)
    c.rect("m1", x0=v.upper.left, x1=y.right, y0=v.upper.bottom, y1=v.upper.top, net="Y")

c.set_boundary(0, 0, W, H)
c.port("A", on=a.upper, dir="in")
c.port("B", on=b.upper, dir="in")
c.port("Y", on=y, dir="out")
c.port("VDD", on=vdd, dir="power")
c.port("VSS", on=vss, dir="ground")
TOP = c
