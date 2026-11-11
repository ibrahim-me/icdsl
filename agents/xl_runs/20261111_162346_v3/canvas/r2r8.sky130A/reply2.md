```
from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
W, L = 1.0, 6.0
PITCH = 7.0
SPINE_Y = 8.0
RUNG_Y  = 2.0
MARGIN  = 1.6

c = Cell("r2r8")

def res(name, x, y, orient, a_net, b_net):
    r = c.resistor("res_poly", w=W, l=L, at=(x, y), nets=(a_net, b_net), orient=orient)
    return r

def node_bar(x, y, net):
    d = max(tech.width(m1), 0.34, 2 * tech.space(m1))
    return c.rect(m1, x0=x - d / 2, x1=x + d / 2, y0=y - d / 2, y1=y + d / 2, net=net)

def link(pad, bar, net):
    c.via(c0, m1, at=(pad.cx, pad.cy), net=net)
    c.via(c0, m1, at=(bar.cx, bar.cy), net=net)

# spine: VSS -t- n0 -n1- ... -n6- OUT   (10 nodes, 9 resistors)
spine = ["VSS", "t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
sbars = []
for k, nm in enumerate(spine):
    x = k * PITCH
    sbars.append(node_bar(x, SPINE_Y, nm))
for k in range(len(spine) - 1):
    r = res("Rsp%d" % k, k * PITCH + 0.5, SPINE_Y - W / 2, "h", spine[k], spine[k + 1])
    link(r.a, sbars[k], spine[k])
    link(r.b, sbars[k + 1], spine[k + 1])

# rungs: ni -RAi- xi -RBi- Bi   (i = 0..6)
for i in range(7):
    nx = (i + 2) * PITCH          # node n_i on the spine
    nb = node_bar(nx, RUNG_Y, "x%d" % i)
    r = res("RA%d" % i, nx - L / 2, RUNG_Y - W / 2, "v", "n%d" % i, "x%d" % i)
    link(r.a, sbars[i + 2], "n%d" % i)
    link(r.b, nb, "x%d" % i)
    bx = nx - 6.0                 # bit pin to the left of xi
    bb = node_bar(bx, RUNG_Y, "B%d" % i)
    r = res("RB%d" % i, bx, RUNG_Y - W / 2, "h", "x%d" % i, "B%d" % i)
    link(r.a, nb, "x%d" % i)
    link(r.b, bb, "B%d" % i)

# MSB: OUT -RA7- x7 -RB7- B7
ox = 9 * PITCH                    # OUT on the spine
nb7 = node_bar(ox, RUNG_Y, "x7")
r = res("RA7", ox - L / 2, RUNG_Y - W / 2, "v", "OUT", "x7")
link(r.a, sbars[9], "OUT")
link(r.b, nb7, "x7")
bb7 = node_bar(ox - 6.0, RUNG_Y, "B7")
r = res("RB7", ox - 6.0, RUNG_Y - W / 2, "h", "x7", "B7")
link(r.a, nb7, "x7")
link(r.b, bb7, "B7")

# ports
c.port("VSS", on=sbars[0], dir="in")
c.port("OUT", on=sbars[9], dir="out")
for i in range(8):
    if i < 7:
        c.port("B%d" % i, on=node_bar((i + 2) * PITCH - 6.0, RUNG_Y, "B%d" % i), dir="in")
    else:
        c.port("B7", on=bb7, dir="in")

# VSS guard ring around the array
x0g = -MARGIN
x1g = 9 * PITCH + MARGIN
y0g = RUNG_Y - MARGIN
y1g = SPINE_Y + MARGIN
gr = c.guard_ring("ntap", x0=x0g, y0=y0g, x1=x1g, y1=y1g, net="VSS")
c.wire(c0, [sbars[0], gr.strap], net="VSS", width=max(tech.width(c0), 0.3))

TOP = c
```