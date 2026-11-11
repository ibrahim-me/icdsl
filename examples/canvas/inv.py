"""Inverter drawn on the canvas: the same script builds on every PDK that has a description."""
from icdsl.canvas import *

tech = use()                      # PDK from --pdk / $ICL_PDK
c0, m1 = tech.c0, tech.metal(1)

c = Cell("inv")
n = c.mos("nmos", w=0.65, gates="A", sd=("VSS", "Y"), at=(0, 0))
p = c.mos("pmos", w=1.0, gates="A", sd=("VDD", "Y"), at=(0, n.diff.top + 1.2))

# one poly gate through both devices, contact in the gap
g = c.rect("poly", x0=n.gates[0].left, x1=n.gates[0].right, y0=n.gates[0].top, y1=p.gates[0].bottom, net="A")
a = c.via("poly", c0, at=(g.cx - 0.3, (n.diff.top + p.diff.bottom) / 2), net="A", dir="v")
c.rect("poly", x0=a.lower.left, x1=g.right, y0=a.lower.bottom, y1=a.lower.top, net="A")

# output: join the two drains on the first conductor
y = c.rect(c0, x0=n.sd[1].left, x1=n.sd[1].right, y0=n.sd[1].bottom, y1=p.sd[1].top, net="Y")

# rails with taps, straps from the sources
vss = c.tap("ptap", x0=n.diff.left - 0.3, y0=n.diff.bottom - 1.0, x1=n.diff.right + 0.3, y1=n.diff.bottom - 0.6,
            net="VSS")
vdd = c.tap("ntap", x0=p.diff.left - 0.3, y0=p.diff.top + 0.6, x1=p.diff.right + 0.3, y1=p.diff.top + 1.0,
            net="VDD")
c.rect(c0, x0=n.sd[0].left, x1=n.sd[0].right, y0=vss.strap.bottom, y1=n.sd[0].top, net="VSS")
c.rect(c0, x0=p.sd[0].left, x1=p.sd[0].right, y0=p.sd[0].bottom, y1=vdd.strap.top, net="VDD")
if p.well:                        # one well for the device and its tap
    c.rect(p.well.layer, x0=min(p.well.left, vdd.well.left), x1=max(p.well.right, vdd.well.right),
           y0=p.well.bottom, y1=vdd.well.top, net="VDD")

c.port("A", on=a.upper, dir="in")
c.port("Y", on=y, dir="out")
c.port("VDD", on=vdd.strap)
c.port("VSS", on=vss.strap)
