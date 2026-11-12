"""ASAP7 (7 nm FinFET): gated ring oscillator - NAND2(EN, OUT) -> inverter -> inverter -> OUT - in one row
with a tap column. Stage-to-stage wires on m1 along the middle of the row; the feedback from the last
stage to the NAND runs on m2 (v1 on both ends, one of them stacked on the gate contact)."""
from icdsl.canvas import *

tech = use("asap7")
c = Cell("ringosc")
H = tech.rule("cell_height")
FP, GP = tech.rule("fin_pitch"), tech.rule("gate_pitch")
YN, YP, WF = FP, 6 * FP, 3 * FP
MID = H / 2
LO, HI = (YN, MID - YN - WF - 0.005), (YP - MID - 0.005, YN)     # gate extensions: rail .. middle .. rail
to_vss, to_vdd = [], []                                          # lisd columns that go to a rail


def stage(x, ins, out, mid=None):
    """One gate at active x: len(ins) n-transistors in series, as many p-transistors in parallel.
    -> (m1 pads of the inputs, m1 output trunk, x of the next active)"""
    k = len(ins)
    nsd = ["VSS"] + [f"{out}_s{i}" for i in range(1, k)] + [out]
    psd = [("VDD", out)[i % 2] for i in range(k + 1)]
    n = c.mos("nmos", w=WF, nf=k, at=(x, YN), gates=ins, sd=nsd, gate_ext=LO,
              contacts=[True] + [False] * (k - 1) + [True])
    p = c.mos("pmos", w=WF, nf=k, at=(x, YP), gates=ins, sd=psd, gate_ext=HI)
    to_vss.append(n.sd[0])
    to_vdd.extend(s for s, net in zip(p.sd, psd) if net == "VDD")
    pads = [c.via("gate", "m1", at=(gx, MID), net=net).upper for gx, net in zip(n.gx, ins)]
    trunk = c.rect("m1", cx=n.gx[-1] + GP, w=0.018, y0=n.diff.bottom, y1=p.diff.top, net=out)
    drains = [(n.sd[-1], n.diff.bottom + 0.009)] + [(s, p.diff.top - 0.009) for s, net in zip(p.sd, psd) if net == out]
    for d, yv in drains:
        v = c.via("lisd", "m1", at=(d.cx, yv), net=out, dir="h", bottom_pad=False)
        c.rect("m1", x0=v.upper.left, x1=trunk.right, y0=v.upper.bottom, y1=v.upper.top, net=out)
    return pads, trunk, n.x_next


(en, fb), y1, x = stage(0.046, ["EN", "OUT"], "n1")
(i2,), y2, x = stage(x, ["n1"], "n2")
(i3,), y3, x = stage(x, ["n2"], "OUT")
pt = c.tap("ptap", at=(x, YN), h=WF, net="VSS", gate_ext=LO)
nt = c.tap("ntap", at=(x, YP), h=WF, net="VDD", gate_ext=HI)
to_vss.append(pt.strap)
to_vdd.append(nt.strap)
W = pt.x_next - 0.046

vss = c.rect("m1", x0=0, x1=W, cy=0, h=0.018, net="VSS")
vdd = c.rect("m1", x0=0, x1=W, cy=H, h=0.018, net="VDD")
for rail, cols in ((vss, to_vss), (vdd, to_vdd)):
    c.rect("lig", x0=0, x1=W, cy=rail.cy, h=0.016, net=rail.net)
    c.rect("gcut", x0=0, x1=W, cy=rail.cy, h=0.044)
    for s in cols:
        c.rect("lisd", x0=s.left, x1=s.right, y0=min(s.bottom, rail.cy), y1=max(s.top, rail.cy), net=rail.net)
        c.via("lig", "m1", at=(s.cx, rail.cy), net=rail.net, dir="h", bottom_pad=False)
c.rect("nwell", x0=0, x1=W, y0=MID, y1=H, net="VDD")

# stage to stage on m1 (the trunk of one stage to the gate pad of the next), feedback on m2
for trunk, pad in ((y1, i2), (y2, i3)):
    c.rect("m1", x0=trunk.left, x1=pad.right, cy=MID, h=0.018, net=trunk.net)
va = c.via("m1", "m2", at=(y3.cx, MID), net="OUT", dir="h", bottom_pad=False)
vb = c.via("m1", "m2", at=fb, net="OUT", dir="h", bottom_pad=False)
c.rect("m2", x0=vb.upper.left, x1=va.upper.right, cy=MID, h=0.018, net="OUT")

c.set_boundary(0, 0, W, H)
c.port("EN", on=en, dir="in")
c.port("OUT", on=y3, dir="out")
c.port("VDD", on=vdd, dir="power")
c.port("VSS", on=vss, dir="ground")
TOP = c
