"""ASAP7 (7 nm FinFET): inverter + tap column built with the device helpers (mos / tap / via), in the
7.5-track architecture of the PDK's standard cells: rails on m1 over lig, gates cut under the rails,
sources on lisd down to the rail, drains through v0 to an m1 trunk on the next gate track."""
from icdsl.canvas import *

tech = use("asap7")
c = Cell("inv")
H = tech.rule("cell_height")
FP, GP = tech.rule("fin_pitch"), tech.rule("gate_pitch")
YN, YP, WF = FP, 6 * FP, 3 * FP                   # n active, p active (lower edges), 3 fins each
MID = H / 2

# gates of n and p meet at the middle of the cell and run to 5 nm past the rails' centre lines
n = c.mos("nmos", w=WF, at=(0.046, YN), gates="A", sd=("VSS", "Y"), gate_ext=(YN, MID - YN - WF - 0.005))
p = c.mos("pmos", w=WF, at=(0.046, YP), gates="A", sd=("VDD", "Y"), gate_ext=(YP - MID - 0.005, YN))
pt = c.tap("ptap", at=(n.x_next, YN), h=WF, net="VSS", gate_ext=(YN, MID - YN - WF - 0.005))
nt = c.tap("ntap", at=(p.x_next, YP), h=WF, net="VDD", gate_ext=(YP - MID - 0.005, YN))
W = pt.x_next - 0.046                             # the footprints abut: 3 + 2 gate pitches

# rails: m1 over lig; a gate cut under each rail separates the gates from it
vss = c.rect("m1", x0=0, x1=W, cy=0, h=0.018, net="VSS")
vdd = c.rect("m1", x0=0, x1=W, cy=H, h=0.018, net="VDD")
for rail, net in ((vss, "VSS"), (vdd, "VDD")):
    c.rect("lig", x0=0, x1=W, cy=rail.cy, h=0.016, net=net)
    c.rect("gcut", x0=0, x1=W, cy=rail.cy, h=0.044)
c.rect("nwell", x0=0, x1=W, y0=MID, y1=H, net="VDD")

# sources and taps: the lisd column runs on to the rail's lig, one v0 per column joins lig and m1
for s, rail in ((n.sd[0], vss), (pt.strap, vss), (p.sd[0], vdd), (nt.strap, vdd)):
    c.rect("lisd", x0=s.left, x1=s.right, y0=min(s.bottom, rail.cy), y1=max(s.top, rail.cy), net=rail.net)
    c.via("lig", "m1", at=(s.cx, rail.cy), net=rail.net, dir="h", bottom_pad=False)

# input: lig + v0 on the gate between the two actives; output: v0 on both drains, m1 stubs to a trunk
a = c.via("gate", "m1", at=(n.gx[0], MID), net="A")
xt = n.gx[0] + GP                                 # the m1 track over the right dummy gate
y = c.rect("m1", cx=xt, w=0.018, y0=n.sd[1].bottom, y1=p.sd[1].top, net="Y")
for d, yv in ((n.sd[1], n.sd[1].bottom + 0.009), (p.sd[1], p.sd[1].top - 0.009)):
    v = c.via("lisd", "m1", at=(d.cx, yv), net="Y", dir="h", bottom_pad=False)
    c.rect("m1", x0=v.upper.left, x1=y.right, y0=v.upper.bottom, y1=v.upper.top, net="Y")

c.set_boundary(0, 0, W, H)
c.port("A", on=a.upper, dir="in")
c.port("Y", on=y, dir="out")
c.port("VDD", on=vdd, dir="power")
c.port("VSS", on=vss, dir="ground")
TOP = c
