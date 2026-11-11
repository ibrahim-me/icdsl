```
from icdsl.canvas import *

tech = use()
c0 = tech.c0

PW = 1.0
PL = 6.0
GAP = 0.5
STEP = PL + GAP
PAD = 0.5

c = Cell("r2r8")
resistors = {}

def place_res(name, x, y, orient, na, nb):
    r = c.resistor("res_poly", w=PW, l=PL, at=(x, y), nets=(na, nb), orient=orient)
    resistors[name] = r
    return r

# Node positions along the main chain
node_x = {}
x = 0.0
for nm in ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]:
    node_x[nm] = x
    x += STEP

# Main chain: n0 -R_S0- n1 -R_S1- ... -R_S6- OUT  (horizontal, y=0)
for k in range(7):
    na = "n%d" % k
    nb = "n%d" % (k + 1) if k < 6 else "OUT"
    place_res("R_S%d" % k, node_x[na] + PL / 2, 0, "h", na, nb)

# Terminating leg at n0 going down: n0 -R_T2- t -R_T1- VSS
place_res("R_T2", node_x["n0"], -PL / 2, "v", "n0", "t")
place_res("R_T1", node_x["n0"], -PL - GAP - PL / 2, "v", "t", "VSS")

# Branches up at n0..n6: n_k -R_Ak- x_k -R_Bk- B_k
for k in range(7):
    bx = node_x["n%d" % k]
    place_res("R_A%d" % k, bx, PL / 2, "v", "n%d" % k, "x%d" % k)
    place_res("R_B%d" % k, bx, PL + GAP + PL / 2, "v", "x%d" % k, "B%d" % k)

# Branch up at OUT: OUT -R_A7- x7 -R_B7- B7
place_res("R_A7", node_x["OUT"], PL / 2, "v", "OUT", "x7")
place_res("R_B7", node_x["OUT"], PL + GAP + PL / 2, "v", "x7", "B7")

# Connect all terminals of each node with a small c0 pad
def node_pad(x, y, net):
    c.rect(c0, x0=x - PAD / 2, x1=x + PAD / 2, y0=y - PAD / 2, y1=y + PAD / 2, net=net)

# Main chain nodes
for k in range(7):
    node_pad(node_x["n%d" % k], 0, "n%d" % k)
node_pad(node_x["OUT"], 0, "OUT")

# x nodes (top of vertical branches)
for k in range(7):
    node_pad(node_x["n%d" % k], PL, "x%d" % k)
node_pad(node_x["OUT"], PL, "x7")

# t node (between R_T1 and R_T2)
node_pad(node_x["n0"], -PL, "t")

# Ports on resistor terminal pads (each is on c0, on the correct net)
for k in range(7):
    c.port("B%d" % k, on=resistors["R_B%d" % k].b, dir="in")
c.port("B7", on=resistors["R_B7"].b, dir="in")
c.port("OUT", on=resistors["R_S6"].b, dir="out")
c.port("VSS", on=resistors["R_T1"].b, dir="in")

TOP = c


```