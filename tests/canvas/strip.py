"""mos_strip by hand: a 1:2 current mirror. Two multi-finger strips in one substrate ring, the ring gets a
router pin, the trunk router wires gate, drains and sources. The same script on every PDK."""
from icdsl.canvas import *

tech = use()
c = Cell("mirror")
r = Router(c)
m1, g1 = mos_strip(c, r, "nmos", "M1", w=2, l=1, nf=2, g="IB", s="VSS", d="IB", at=(0, 0), group="row")
m2, g2 = mos_strip(c, r, "nmos", "M2", w=2, l=1, nf=4, g="IB", s="VSS", d="OUT", at=(g1.right + 2.0, 0), group="row")
ring = c.guard_ring("ptap", around=[g1, g2], net="VSS", space=1.0)
st = ring.bottom_bar.strap
v = c.via(tech.c0, tech.c1, at=(st.cx, st.cy), net="VSS", dir="h", top_dir="h")
r.add("VSS", c.rect(tech.c1, x0=st.cx - 0.6, x1=st.cx + 0.6, y0=v.upper.bottom, y1=v.upper.top, net="VSS"), group="ring")
for net, shape in r.run().items():
    c.port(net, on=shape)
assert set(c.ports) == {"IB", "OUT", "VSS"}, sorted(c.ports)
assert len(m1.gates) == 2 and len(m2.gates) == 4
TOP = c
