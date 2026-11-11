```
from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
W, L = 1.0, 6.0
PITCH = 7.0
SPINE_Y = 8.0
RUNG_Y  = 2.0

c = Cell("r2r8")

def node_bar(x, y, net):
    d = max(tech.width(m1), 0.34, 2 * tech.space(m1))
    return c.rect(m1, x0=x - d / 2, x1=x + d / 2, y0=y - d / 2, y1=y + d / 2, net=net)

def tap(pad, bar, net):
    v1 = c.via(c0, m1, at=(pad.cx, pad.cy), net=net)
    v2 = c.via(c0, m1, at=(bar.cx, bar.cy), net=net)
    c.wire(m1, [v1.upper, v2.upper], net=net, width=max(tech.width(m1), 0.3))

# ---------- spine: VSS -t- n0 -n1- ... -n6- OUT ----------
spine = ["VSS", "t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
sbars = [node_bar(k * PITCH, SPINE_Y, nm) for k, nm in enumerate(spine)]
for k in range(len(spine) - 1):
    r = c.resistor("res_poly", w=W, l=L,
                   at=(k * PITCH + PITCH / 2, SPINE_Y),
                   nets=(spine[k], spine[k + 1]), orient="h")
    tap(r.a, sbars[k], spine[k])
    tap(r.b, sbars[k + 1], spine[k + 1])

# ---------- rungs: ni -RAi- xi -RBi- Bi   (i = 0..6) ----------
for i in range(7):
    nx = (i + 2) * PITCH                 # spine node n_i
    nb = node_bar(nx, RUNG_Y, "x%d" % i)
    r = c.resistor("res_poly", w=W, l=L,
                   at=(nx + 0.5, (SPINE_Y + RUNG_Y) / 2),
                   nets=("n%d" % i, "x%d" % i), orient="v")
    tap(r.a, sbars[i + 2], "n%d" % i)
    tap(r.b, nb, "x%d" % i)
    bx = nx - L                          # bit pin to the left of xi
    bb = node_bar(bx, RUNG_Y, "B%d" % i)
    r = c.resistor("res_poly", w=W, l=L,
                   at=(bx + L / 2, RUNG_Y + 0.5),
                   nets=("x%d" % i, "B%d" % i), orient="h")
    tap(r.a, nb, "x%d" % i)
    tap(r.b, bb, "B%d" % i)
    c.port("B%d" % i, on=bb, dir="in")

# ---------- MSB: OUT -RA7- x7 -RB7- B7 ----------
ox = 9 * PITCH
nb7 = node_bar(ox, RUNG_Y, "x7")
r = c.resistor("res_poly", w=W, l=L,
               at=(ox + 0.5, (SPINE_Y + RUNG_Y) / 2),
               nets=("OUT", "x7"), orient="v")
tap(r.a, sbars[9], "OUT")
tap(r.b, nb7, "x7")
bb7 = node_bar(ox - L, RUNG_Y, "B7")
r = c.resistor("res_poly", w=W, l=L,
               at=(ox - L / 2, RUNG_Y + 0.5),
               nets=("x7", "B7"), orient="h")
tap(r.a, nb7, "x7")
tap(r.b, bb7, "B7")
c.port("B7", on=bb7, dir="in")

# ---------- ports ----------
c.port("VSS", on=sbars[0], dir="in")
c.port("OUT", on=sbars[9], dir="out")

# ---------- substrate guard ring tied to VSS ----------
gr = c.guard_ring("ptap", around=(-1.0, 0.5, 64.5, 9.5), space=1.0, width=2.0, net="VSS")
tap(sbars[0], gr.straps[0], "VSS")

TOP = c


```