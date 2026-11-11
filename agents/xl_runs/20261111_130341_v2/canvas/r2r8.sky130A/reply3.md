```
from icdsl.canvas import *
from collections import defaultdict

tech = use()
c0 = tech.c0

PW = 1.0   # matches netlist w=1
PL = 6.0   # matches netlist l=6
GAP = 0.5
STEP = PL + GAP

c = Cell("r2r8")

# (resistor name, net_a, net_b)  --  all 25 unit resistors
res = [
    ("R_T1", "VSS", "t"),   ("R_T2", "n0",  "t"),
    ("R_A0", "n0",  "x0"),  ("R_B0", "B0",  "x0"),
    ("R_S0", "n0",  "n1"),
    ("R_A1", "n1",  "x1"),  ("R_B1", "B1",  "x1"),
    ("R_S1", "n1",  "n2"),
    ("R_A2", "n2",  "x2"),  ("R_B2", "B2",  "x2"),
    ("R_S2", "n2",  "n3"),
    ("R_A3", "n3",  "x3"),  ("R_B3", "B3",  "x3"),
    ("R_S3", "n3",  "n4"),
    ("R_A4", "n4",  "x4"),  ("R_B4", "B4",  "x4"),
    ("R_S4", "n4",  "n5"),
    ("R_A5", "n5",  "x5"),  ("R_B5", "B5",  "x5"),
    ("R_S5", "n5",  "n6"),
    ("R_A6", "n6",  "x6"),  ("R_B6", "B6",  "x6"),
    ("R_S6", "n6",  "OUT"),
    ("R_A7", "OUT", "x7"),  ("R_B7", "B7",  "x7"),
]

# node positions along the main chain (left to right): n0..n6, OUT
node_x = {}
x = 0.0
for nm in ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]:
    node_x[nm] = x
    x += STEP

placed = {}   # name -> resistor
nets = defaultdict(list)   # net -> list of (resistor, 'a'/'b')

def add(rname, r, na, nb):
    placed[rname] = r
    nets[na].append((r, "a"))
    nets[nb].append((r, "b"))

# main chain: n0 --R_S0--> n1 --R_S1--> ... --R_S6--> OUT   (horizontal, y=0)
for k in range(7):
    na = "n%d" % k
    nb = "n%d" % (k + 1) if k < 6 else "OUT"
    add("R_S%d" % k,
        c.resistor("res_poly", w=PW, l=PL,
                   at=(node_x[na] + PL / 2, 0), nets=(na, nb), orient="h"),
        na, nb)

# terminating leg at n0 going down: n0 --R_T2--> t --R_T1--> VSS
add("R_T2",
    c.resistor("res_poly", w=PW, l=PL,
               at=(node_x["n0"], -PL / 2), nets=("n0", "t"), orient="v"),
    "n0", "t")
add("R_T1",
    c.resistor("res_poly", w=PW, l=PL,
               at=(node_x["n0"], -PL - GAP - PL / 2), nets=("t", "VSS"), orient="v"),
    "t", "VSS")

# branches up at n0..n6: n_k --R_Ak--> x_k --R_Bk--> B_k
for k in range(7):
    bx = node_x["n%d" % k]
    add("R_A%d" % k,
        c.resistor("res_poly", w=PW, l=PL,
                   at=(bx, PL / 2), nets=("n%d" % k, "x%d" % k), orient="v"),
        "n%d" % k, "x%d" % k)
    add("R_B%d" % k,
        c.resistor("res_poly", w=PW, l=PL,
                   at=(bx, PL + GAP + PL / 2), nets=("x%d" % k, "B%d" % k), orient="v"),
        "x%d" % k, "B%d" % k)

# branch up at OUT: OUT --R_A7--> x7 --R_B7--> B7
ox = node_x["OUT"]
add("R_A7",
    c.resistor("res_poly", w=PW, l=PL,
               at=(ox, PL / 2), nets=("OUT", "x7"), orient="v"),
    "OUT", "x7")
add("R_B7",
    c.resistor("res_poly", w=PW, l=PL,
               at=(ox, PL + GAP + PL / 2), nets=("x7", "B7"), orient="v"),
    "x7", "B7")

# connect every net's terminals with c0 (bounding box of its pads)
for net, lst in nets.items():
    pts = [p for r, which in lst for p in [r.a if which == "a" else r.b]]
    if len(pts) == 1:
        shape = pts[0]
    else:
        x0 = min(p.left for p in pts) - 0.05
        x1 = max(p.right for p in pts) + 0.05
        y0 = min(p.bottom for p in pts) - 0.05
        y1 = max(p.top for p in pts) + 0.05
        shape = c.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# ports
def term_of(lst):
    r, which = lst[0]
    return r.a if which == "a" else r.b

c.port("VSS", on=term_of(nets["VSS"]), dir="in")
c.port("OUT", on=term_of(nets["OUT"]), dir="out")
for k in range(7):
    c.port("B%d" % k, on=placed["R_B%d" % k].b, dir="in")
c.port("B7", on=placed["R_B7"].b, dir="in")

TOP = c

```