"""Every PCell once, PDK-generic: via stacks, guard rings, poly resistor, MIM capacitor (where the PDK has
them), polygons."""
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
top = tech.stack[-1]

c = Cell("pcells")
# 1. full via stack c0 -> top metal, and a 2x2 one
v = c.via(c0, top, at=(0, 0), net="N1")
v2 = c.via(c0, c3, at=(4, 0), nx=2, ny=2, net="N1")
c.wire(c0, [v.lower, v2.lower], net="N1", width=max(tech.width(c0), 0.3))
c.port("N1", on=v.upper)

# 2. nmos in a p-tap guard ring, pmos in an n-tap ring
n = c.mos("nmos", w=1.0, nf=2, gates="GN", sd=("VSS", "DN"), at=(0, 6), gate_ext=(0, 0.35))
gr = c.guard_ring("ptap", around=n, net="VSS")
c.wire(c0, [n.sd[0], (gr.left_bar.strap.cx, n.sd[0].cy)], net="VSS")
c.wire(c0, [n.sd[2], (gr.right_bar.strap.cx, n.sd[2].cy)], net="VSS")
p = c.mos("pmos", w=1.0, nf=2, gates="GP", sd=("VDD", "DP"), at=(0, 12), well=False, gate_ext=(0, 0.35))
gp = c.guard_ring("ntap", around=p, net="VDD")
c.wire(c0, [p.sd[0], (gp.left_bar.strap.cx, p.sd[0].cy)], net="VDD")
c.wire(c0, [p.sd[2], (gp.right_bar.strap.cx, p.sd[2].cy)], net="VDD")
# gates joined by a poly bar over each strip
for m, net in ((n, "GN"), (p, "GP")):
    c.rect("poly", x0=m.gates[0].left, x1=m.gates[-1].right, y0=m.gates[0].top - max(tech.width("poly"), 0.2),
           y1=m.gates[0].top, net=net)
c.port("VSS", on=gr.straps[0]); c.port("VDD", on=gp.straps[0])

# 3. poly resistor (PDKs that have one)
if "res_poly" in tech.d["devices"]:
    r = c.resistor("res_poly", w=1.0, l=5.0, at=(12, 0), nets=("RA", "RB"))
    c.port("RA", on=r.a); c.port("RB", on=r.b)

# 4. MIM capacitor (PDKs that have one)
if "cap_mim" in tech.d["devices"]:
    k = c.capacitor("cap_mim", w=6, h=6, at=(12, 8), nets=("CT", "CB"))
    c.port("CT", on=k.top_pad); c.port("CB", on=k.b)

# 5. 45-degree path and an octagon on the top metal
w = max(tech.width(top), 2.0)
c.path(top, [(30, 0), (36, 0), (40, 4), (40, 10)], width=w, net="L1")
TOP = c
