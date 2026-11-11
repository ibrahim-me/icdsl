```
from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1 on gf180mcuD
m2 = tech.metal(1)                # m2
via1 = "via1"

c = Cell("r2r8")

RES_L = 6.0
RES_W = 1.0
PX = 10.0                         # column pitch (keeps pplus spacing DRC clean)
PY = 9.0                          # row pitch
SPINE_Y = 10.0
RUNG_Y = 1.0

resistors = [
    ("VSS", "t"), ("n0", "t"), ("n0", "x0"), ("B0", "x0"), ("n0", "n1"),
    ("n1", "x1"), ("B1", "x1"), ("n1", "n2"), ("n2", "x2"), ("B2", "x2"),
    ("n2", "n3"), ("n3", "x3"), ("B3", "x3"), ("n3", "n4"),
    ("n4", "x4"), ("B4", "x4"), ("n4", "n5"), ("n5", "x5"), ("B5", "x5"),
    ("n5", "n6"), ("n6", "x6"), ("B6", "x6"), ("n6", "OUT"), ("OUT", "x7"),
    ("B7", "x7"),
]

# spine resistors (horizontal) at SPINE_Y, left ends at 2 + k*PX
spine = ["RT1", "RT2", "RS0", "RS1", "RS2", "RS3", "RS4", "RS5", "RS6"]
spine_net = [("VSS","t"), ("n0","t"), ("n0","n1"), ("n1","n2"), ("n2","n3"),
             ("n3","n4"), ("n4","n5"), ("n5","n6"), ("n6","OUT")]
spine_res = {}
for k, nets in enumerate(spine_net):
    x = 2.0 + k * PX
    r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, SPINE_Y), nets=nets, orient="h")
    spine_res[nets] = r

# rung resistors (vertical) at RUNG_Y, centered under their spine node
rung = [("n0","x0","B0"), ("n1","x1","B1"), ("n2","x2","B2"), ("n3","x3","B3"),
        ("n4","x4","B4"), ("n5","x5","B5"), ("n6","x6","B6"), ("OUT","x7","B7")]
rung_res = {}
for i, (node, xnet, bnet) in enumerate(rung):
    x = 2.0 + i * PX + RES_L / 2.0          # under spine node between RS(i-1) and RS(i)
    # node n_i is between spine resistor i-1 and i; for i=0 node n0 is between RT2 and RS0 -> x = 2+2*PX+3
    # simpler: place rung under the LEFT end of the spine resistor that starts at node
    pass

# Recompute rung x positions: node n_i sits at the junction after spine resistor index i+1
# spine order: RT1(VSS-t), RT2(t-n0), RS0(n0-n1), RS1(n1-n2), ... RS6(n6-OUT)
# junction x (right end of spine resistor k) = 2 + k*PX + RES_L
# node n0 = right end of RT2 (k=1) ; node n_i = right end of spine resistor k=i+1 ; OUT = right end of RS6 (k=8)
def node_x(name):
    if name == "VSS": return 2.0
    if name == "t":   return 2.0 + 1*PX + RES_L
    if name == "OUT": return 2.0 + 8*PX + RES_L
    # n_i : right end of spine resistor index i+1
    i = int(name[1:])
    return 2.0 + (i+1)*PX + RES_L

for i, (node, xnet, bnet) in enumerate(rung):
    x = node_x(node)
    # RA: node -> xnet ; RB: bnet -> xnet ; both share xnet
    ra = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, RUNG_Y), nets=(node, xnet), orient="v")
    rb = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, RUNG_Y + RES_L + PY), nets=(bnet, xnet), orient="v")
    rung_res[(node, xnet, bnet)] = (ra, rb)

# ---- connect spine nodes (metal1 horizontal segments in gaps) ----
def pad(r, end):
    return r.a if end == "a" else r.b

# spine: connect b of resistor k to a of resistor k+1 (the shared node)
for k in range(len(spine_net) - 1):
    r1 = spine_res[spine_net[k]]
    r2 = spine_res[spine_net[k + 1]]
    net = spine_net[k][1]          # shared node name
    c.wire(c0, [pad(r1, "b"), pad(r2, "a")], net=net, width=0.6, first="h")

# VSS pin at left end of RT1
c.port("VSS", on=pad(spine_res[("VSS","t")], "a"), dir="in")
# OUT pin at right end of RS6
c.port("OUT", on=pad(spine_res[("n6","OUT")], "b"), dir="out")

# ---- connect rungs to spine nodes and B pins ----
for i, (node, xnet, bnet) in enumerate(rung):
    x = node_x(node)
    ra, rb = rung_res[(node, xnet, bnet)]
    # connect ra.a (node) to spine node: vertical metal1 from ra.a up to spine_y
    c.wire(c0, [pad(ra, "a"), (x, SPINE_Y - RES_W/2 - 0.3)], net=node, width=0.6, first="v")
    # spine node metal: short segment at spine_y touching the vertical wire
    c.rect(c0, x0=x - 0.3, y0=SPINE_Y - 0.3, x1=x + 0.3, y1=SPINE_Y + 0.3, net=node)
    # xnet: connect ra.b and rb.b (both = xnet) with vertical metal1 between the two rung resistors
    c.wire(c0, [pad(ra, "b"), pad(rb, "b")], net=xnet, width=0.6, first="v")
    # B pin on rb.a
    c.port(bnet, on=pad(rb, "a"), dir="in")

TOP = c

```