from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1 on gf180mcuD

c = Cell("r2r8")

RES_L = 6.0
RES_W = 1.0
PX = 10.0                         # column pitch
SPINE_Y = 22.0                    # main chain row
RACK_Y = 8.0                      # rung resistors row (vertical)
BIT_Y = 2.0                       # bit port row

resistors = [
    ("RT1", "VSS", "t"), ("RT2", "n0", "t"),
    ("RS0", "n0", "n1"), ("RS1", "n1", "n2"), ("RS2", "n2", "n3"),
    ("RS3", "n3", "n4"), ("RS4", "n4", "n5"), ("RS5", "n5", "n6"),
    ("RS6", "n6", "OUT"),
]
rungs = [   # (name, node_net, bit_net)  node--RA--x--RB--bit
    ("RA0","n0","B0"), ("RB0","B0","x0"),
    ("RA1","n1","B1"), ("RB1","B1","x1"),
    ("RA2","n2","B2"), ("RB2","B2","x2"),
    ("RA3","n3","B3"), ("RB3","B3","x3"),
    ("RA4","n4","B4"), ("RB4","B4","x4"),
    ("RA5","n5","B5"), ("RB5","B5","x5"),
    ("RA6","n6","B6"), ("RB6","B6","x6"),
    ("RA7","OUT","B7"), ("RB7","B7","x7"),
]

# ---- spine: 9 horizontal resistors, left edges at x = 2 + k*PX ----
spine = {}
for k, (name, n1, n2) in enumerate(resistors):
    x = 2.0 + k * PX
    r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, SPINE_Y),
                   nets=(n1, n2), orient="h")
    spine[name] = r

# node x positions (gap centers between consecutive spine resistors)
# node between resistor k and k+1 : center of gap [2+k*PX+6, 2+(k+1)*PX]
def gap_center(k):
    return 2.0 + k * PX + RES_L + (PX - RES_L) / 2.0

# t = gap(0), n0 = gap(1), ..., n6 = gap(7)
node_x = {"t": gap_center(0)}
for i in range(7):
    node_x["n%d" % i] = gap_center(i + 1)

# connect spine node pads (same net) with short metal1 in the gap
def pad(r, end):
    return r.a if end == "a" else r.b

# t: RT1.b (right, x=8) to RT2.a (left, x=12)
c.wire(c0, [pad(spine["RT1"], "b"), pad(spine["RT2"], "a")], net="t",
       width=0.6, first="h")
# n0..n6: RS(i-1).b to RSi.a
for i in range(7):
    rprev = spine["RS%d" % (i - 1)] if i > 0 else spine["RT2"]
    rcur = spine["RS%d" % i]
    c.wire(c0, [pad(rprev, "b"), pad(rcur, "a")], net="n%d" % i,
           width=0.6, first="h")

c.port("VSS", on=pad(spine["RT1"], "a"), dir="in")
c.port("OUT", on=pad(spine["RS6"], "b"), dir="out")

# ---- rungs: at each node x, two vertical resistors sharing x_i ----
# RA: node (top, at spine) -> x_i (middle).  RB: x_i (middle) -> bit (bottom).
# Place RA with top at SPINE_Y-2 (clear of spine), length RES_L up; x_i at its bottom.
# Place RB with top at x_i, length RES_L down; bit at its bottom.
RUNG_TOP = SPINE_Y - 4.0          # top of RA (clear of spine row)
for i, (name, n1, n2) in enumerate(rungs):
    if name.startswith("RA"):
        node = n1
        x = node_x[node]
        r = c.resistor("res_poly", w=RES_W, l=RES_L, at=(x, RUNG_TOP),
                       nets=(n1, n2), orient="v")
        spine["rung_" + name] = r
    else:  # RB: shares x_i with the matching RA
        bit = n1
        # find matching RA x
        ra_name = "RA" + name[2:]
        ra = spine["rung_" + ra_name]
        x = ra.a.cx if hasattr(ra.a, "cx") else None
        # determine x from RA position: RA at (node_x, RUNG_TOP), vertical, so cx = node_x
        node = None
        for nm, nx in node_x.items():
            if abs(nx - (2.0 + 0)) < 1e-6:
                pass
        # simpler: recompute x from bit index
        idx = int(name[2:])
        x = node_x["n%d" % idx] if idx < 7 else node_x["t"] if False else None
        # B7 uses OUT node
        if idx == 7:
            x = 2.0 + 8 * PX + RES_L   # OUT = right end of RS6
        else:
            x = node_x["n%d" % idx]
        r = c.resistor("res_poly", w=RES_W, l=RES_L,
                       at=(x, RUNG_TOP - RES_L - 2.0), nets=(n1, n2), orient="v")
        spine["rung_" + name] = r

# connect rung terminals
for i, (name, n1, n2) in enumerate(rungs):
    if name.startswith("RA"):
        r = spine["rung_" + name]
        # r.a = top (node), r.b = bottom (x_i). connect top to spine node
        c.wire(c0, [pad(r, "a"), (node_x[n1], SPINE_Y - 2.0)], net=n1,
               width=0.6, first="v")
        # small node pad at spine level
        c.rect(c0, x0=node_x[n1] - 0.3, y0=SPINE_Y - 2.3,
               x1=node_x[n1] + 0.3, y1=SPINE_Y - 1.7, net=n1)
    else:
        r = spine["rung_" + name]
        # RB: r.a = top (x_i), r.b = bottom (bit). connect bit to port
        c.port(n1, on=pad(r, "b"), dir="in")

TOP = c


