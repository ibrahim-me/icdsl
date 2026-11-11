```
from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1 on gf180mcuD

c = Cell("r2r8")

RES_L = 6.0
RES_W = 1.0
PITCH_X = 8.0
PITCH_Y = 6.0
COLS = 10

resistors = [
    ("VSS", "t"), ("n0", "t"), ("n0", "x0"), ("B0", "x0"), ("n0", "n1"),
    ("n1", "x1"), ("B1", "x1"), ("n1", "n2"), ("n2", "x2"), ("B2", "x2"),
    ("n2", "n3"), ("n3", "x3"), ("B3", "x3"), ("n3", "n4"),
    ("n4", "x4"), ("B4", "x4"), ("n4", "n5"), ("n5", "x5"), ("B5", "x5"),
    ("n5", "n6"), ("n6", "x6"), ("B6", "x6"), ("n6", "OUT"), ("OUT", "x7"),
    ("B7", "x7"),
]

# place resistors in serpentine rows, add ports on every pad
for i, (n1, n2) in enumerate(resistors):
    row = i // COLS
    col = i % COLS
    if row % 2 == 0:
        x = 1.0 + col * PITCH_X
    else:
        x = 1.0 + (COLS - 1 - col) * PITCH_X
    y = 4.0 + row * PITCH_Y
    r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, y), nets=(n1, n2), orient="h")
    c.port(n1, on=r.a)
    c.port(n2, on=r.b)

# route every multi-pad net on m1 (c0); single-pad nets are already pins
from collections import defaultdict
net_pads = defaultdict(list)
for i, (n1, n2) in enumerate(resistors):
    row = i // COLS
    col = i % COLS
    if row % 2 == 0:
        x = 1.0 + col * PITCH_X
    else:
        x = 1.0 + (COLS - 1 - col) * PITCH_X
    y = 4.0 + row * PITCH_Y
    # re-create to get pad refs (ports already added above)
    r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, y), nets=(n1, n2), orient="h")
    net_pads[n1].append(r.a)
    net_pads[n2].append(r.b)

# NOTE: the loop above re-drew resistors; rebuild cleanly below
c = Cell("r2r8")
net_pads = defaultdict(list)
for i, (n1, n2) in enumerate(resistors):
    row = i // COLS
    col = i % COLS
    if row % 2 == 0:
        x = 1.0 + col * PITCH_X
    else:
        x = 1.0 + (COLS - 1 - col) * PITCH_X
    y = 4.0 + row * PITCH_Y
    r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, y), nets=(n1, n2), orient="h")
    net_pads[n1].append(r.a)
    net_pads[n2].append(r.b)

# connect pads of each net with m1 wires
for net, pads in net_pads.items():
    if len(pads) < 2:
        continue
    for j in range(len(pads) - 1):
        c.wire(c0, [pads[j], pads[j + 1]], net=net, width=0.6, first="h")

# top-level ports
c.port("VSS", on=net_pads["VSS"][0], dir="in")
for i in range(8):
    c.port("B%d" % i, on=net_pads["B%d" % i][0], dir="in")
c.port("OUT", on=net_pads["OUT"][0], dir="out")

TOP = c
```