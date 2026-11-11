```
from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

c = Cell("r2r8")

R, L, GAP = 1.0, 6.0, 0.4
X0, Y0 = 1.0, 1.0
PITCH = 1.3
SIDE = 6.0

def term(r, side):
    return r.a if side == "a" else r.b

# ---------------- main chain (horizontal, c0) ----------------
chain = [("RT1","VSS","t"),("RT2","t","n0")] + \
        [("RS%d"%i,"n%d"%i,"n%d"%(i+1)) for i in range(7)]
res = {}
x = X0
node_x = {"VSS": X0}
for name, a, b in chain:
    res[name] = c.resistor("res_poly", w=R, l=L, at=(x, Y0), nets=(a, b), orient="h")
    node_x[b] = x + L
    x += L + GAP
out_x = x - GAP

# ---------------- bit cells (c0, stacked above chain) ----------------
for i in range(8):
    jx = node_x["n%d"%i] if i < 7 else out_x
    by = Y0 + 2.0 + PITCH * i
    jnet = "n%d"%i if i < 7 else "OUT"
    res["RA%d"%i] = c.resistor("res_poly", w=R, l=L, at=(jx - SIDE, by),
                               nets=(jnet, "x%d"%i), orient="h")
    res["RB%d"%i] = c.resistor("res_poly", w=R, l=L, at=(jx, by),
                               nets=("x%d"%i, "B%d"%i), orient="h")
    # chain node n_i -> up to RA_i left end (c0 vertical + horizontal)
    c.rect(c0, x0=jx - 0.09, x1=jx + 0.09, y0=Y0 + L / 2, y1=by - L / 2, net=jnet)
    c.rect(c0, x0=jx - SIDE, x1=jx - 0.09, y0=by - L / 2, y1=by + L / 2, net=jnet)

# ---------------- bring every terminal up to m1 ----------------
term = {}
for name, r in res.items():
    for side in ("a", "b"):
        p = term(r, side)
        v = c.via(c0, m1, at=(p.cx, p.cy), net=p.net)
        term[(name, side)] = v.upper

# ---------------- m1 ports for VSS and OUT ----------------
c.wire(m1, [term[("RT1", "a")], (X0 - 2.0, Y0)], width=0.2, net="VSS")
c.wire(m1, [term[("RS6", "b")], (out_x + 2.0, Y0)], width=0.2, net="OUT")

# ---------------- B pins on m2 ----------------
for i in range(8):
    tb = term[("RB%d"%i, "b")]
    v = c.via(m1, m2, at=(tb.cx, tb.cy), net="B%d"%i)
    c.rect(m2, w=1.6, h=0.4, cx=v.upper.cx, cy=tb.cy + 1.2, net="B%d"%i)

# ---------------- ports ----------------
c.port("VSS", on=c.rect(m1, w=1.6, h=0.4, cx=X0 - 2.0, cy=Y0, net="VSS"), dir="in")
c.port("OUT", on=c.rect(m1, w=1.6, h=0.4, cx=out_x + 2.0, cy=Y0, net="OUT"), dir="out")
for i in range(8):
    jx = node_x["n%d"%i] if i < 7 else out_x
    by = Y0 + 2.0 + PITCH * i
    c.port("B%d"%i, on=c.rect(m2, w=1.6, h=0.4, cx=jx, cy=by + 1.2, net="B%d"%i), dir="in")

TOP = c


```