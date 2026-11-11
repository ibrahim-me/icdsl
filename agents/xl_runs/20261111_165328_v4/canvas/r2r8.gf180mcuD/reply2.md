```
from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1, first conductor
assert "res_poly" in tech.d["devices"], "gf180mcuD needs res_poly"

# ------------------------------------------------------------------ netlist
# 25 unit poly resistors, ppolyf_u, drawn W=1u L=6u.
# Spine (horizontal, y=0):  VSS -RT1- t -RT2- n0 -RS0- n1 -RS1- n2 ... n6 -RS6- OUT
# Bit taps (vertical at each spine node): n_i -RA_i- x_i -RB_i- B_i   (i=0..6), OUT -RA7- x7 -RB7- B7
# All resistor terminals that share a net are joined by a small m1 node bar so extraction sees one node.

RW, RL = 1.0, 6.0
PITCH = 8.0
SPINE_Y = 0.0

c = Cell("r2r8")

pads = {}                         # net -> list of terminal pad shapes

def add_res(name, nets, x, y, orient="h"):
    r = c.resistor("res_poly", w=RW, l=RL, at=(x, y), nets=nets, orient=orient)
    for pad, net in ((r.a, nets[0]), (r.b, nets[1])):
        pads.setdefault(net, []).append(pad)
    return r

# ---- spine nodes
spine = ["VSS", "t"] + ["n%d" % i for i in range(7)] + ["OUT"]
sx = {"VSS": -16.0, "t": -8.0}
for i in range(7):
    sx["n%d" % i] = 0.0 + i * PITCH
sx["OUT"] = 6.0 * PITCH           # 48

# VSS -RT1- t -RT2- n0  (horizontal)
add_res("RT1", ("VSS", "t"), (sx["VSS"] + sx["t"]) / 2, SPINE_Y, "h")
add_res("RT2", ("t", "n0"), (sx["t"] + sx["n0"]) / 2, SPINE_Y, "h")
# RS0..RS6 along the spine
for i in range(7):
    a = "n%d" % i
    b = "n%d" % (i + 1) if i < 6 else "OUT"
    add_res("RS%d" % i, (a, b), (sx[a] + sx[b]) / 2, SPINE_Y, "h")

# ---- bit taps: n_i -RA_i- x_i -RB_i- B_i   (vertical columns)
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    tx = sx[node]
    add_res("RA%d" % i, (node, "x%d" % i), tx, SPINE_Y + RL / 2 + 1.0, "v")
    add_res("RB%d" % i, ("x%d" % i, "B%d" % i), tx, SPINE_Y + RL + 2.0 + RL / 2 + 1.0, "v")

# ---- node bars: join every net that has more than one terminal pad
for net, plist in pads.items():
    if len(plist) < 2:
        continue
    x0 = min(p.left for p in plist) - 0.4
    x1 = max(p.right for p in plist) + 0.4
    y0 = min(p.bottom for p in plist) - 0.4
    y1 = max(p.top for p in plist) + 0.4
    c.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# ---- substrate guard ring around the array, tied to VSS
allx = [sx[n] for n in spine] + [sx[("n%d" % i) if i < 7 else "OUT"] for i in range(8)]
ally = [SPINE_Y, SPINE_Y + RL / 2 + 1.0, SPINE_Y + RL + 2.0 + RL / 2 + 1.0]
ring = c.guard_ring("ptap",
                    around=(min(allx) - 2.0, min(ally) - 2.0,
                            max(allx) + 2.0, max(ally) + 2.0),
                    space=1.0, net="VSS", well=False)
# make sure the VSS net (RT1 pad) is electrically the same as the ring strap
c.rect(c0, x0=min(p.left for p in pads["VSS"]) - 0.4,
       x1=max(p.right for p in pads["VSS"]) + 0.4,
       y0=min(p.bottom for p in pads["VSS"]) - 0.4,
       y1=max(p.top for p in pads["VSS"]) + 0.4,
       xspan=None, net="VSS") if False else None
# connect VSS pad to ring strap with an m1 bar
vpad = pads["VSS"][0]
rstrap = ring.straps[0]
c.rect(c0, x0=min(vpad.left, rstrap.left) - 0.2, x1=max(vpad.right, rstrap.right) + 0.2,
       y0=min(vpad.bottom, rstrap.bottom) - 0.2, y1=max(vpad.top, rstrap.top) + 0.2, net="VSS")

# ---- ports
c.port("VSS", on=ring.straps[0])
c.port("OUT", on=pads["OUT"][-1])          # RS6.b side (right end of spine)
for i in range(8):
    c.port("B%d" % i, on=pads["B%d" % i][0], dir="in")

TOP = c

```