"""8-bit R-2R ladder DAC core: 25 identical poly resistors inside a substrate guard ring.
Ladder: VSS -2R- n0 -R- n1 -R- ... -R- n7 = OUT, and 2R from every node n<i> to its bit input B<i>."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
W, L, PITCH = 1.0, 6.0, 3.0
top = Cell("r2r8")
units, col = {}, 0
N = lambda i: "OUT" if i == 7 else f"n{i}"


def unit(name, a, b):
    global col
    units[name] = top.resistor("res_poly", w=W, l=L, at=(col * PITCH, 0), nets=(a, b), orient="v", name=name)
    col += 1
    return units[name]


unit("RT1", "VSS", "t"), unit("RT2", "n0", "t")
for i in range(8):
    unit(f"RA{i}", N(i), f"x{i}"), unit(f"RB{i}", f"B{i}", f"x{i}")
    if i < 7:
        unit(f"RS{i}", N(i), N(i + 1))
ring = top.guard_ring("ptap", around=list(units.values()), space=1.5, net="VSS")

# the two halves of every 2R: neighbours, joined at their top pads on the first conductor
for a, b in [("RT1", "RT2")] + [(f"RA{i}", f"RB{i}") for i in range(8)]:
    top.rect(c0, x0=units[a].b.left, x1=units[b].b.right, y0=units[a].b.bottom, y1=units[a].b.top, net=units[a].b.net)
# ground end of the terminator: straight down into the ring
g = units["RT1"].a
top.rect(c0, x0=g.left, x1=g.right, y0=ring.outer[1], y1=g.bottom, net="VSS")
# ladder nodes: routed over the resistors
r = Router(top, pin_layer=c0)
r.add("n0", units["RT2"].a)
for i in range(8):
    r.add(N(i), units[f"RA{i}"].a)
    if i < 7:
        r.add(N(i), units[f"RS{i}"].a)
        r.add(N(i + 1), units[f"RS{i}"].b)
h = r.run()
for i in range(8):
    top.port(f"B{i}", on=units[f"RB{i}"].a)
top.port("OUT", on=units["RA7"].a)
top.port("VSS", on=ring.straps[0])
TOP = top
