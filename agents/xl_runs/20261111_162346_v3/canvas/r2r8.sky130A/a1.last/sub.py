from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
W, L = 1.0, 6.0          # unit resistor drawn W x L (sky130 res_poly w=1 l=6)
PITCH = 7.0              # centre-to-centre of spine nodes
SPINE_Y = 8.0            # top rail: VSS, t, n0..n6, OUT
RUNG_Y  = 2.0            # lower rail: x0..x7
BIT_Y   = -4.0           # bit pins exit left here
MARGIN  = 1.6

c = Cell("r2r8")

def res(name, x0, y0, x1, y1, a_net, b_net):
    r = c.resistor("res_poly", w=W, l=L, x0=x0, x1=x1, y0=y0, y1=y1,
                   nets=(a_net, b_net))
    c.wire(m1, [r.a, r.b], net=None, width=max(tech.width(m1), 0.3))
    return r

def node_bar(x, y, net):
    s = tech.space(m1)
    d = max(tech.width(m1), 0.34, 2 * s)
    return c.rect(m1, x0=x - d / 2, x1=x + d / 2, y0=y - d / 2, y1=y + d / 2, net=net)

# spine: VSS -RT1- t -RT2- n0 -RS0- n1 ... -RS6- OUT
spine = ["VSS", "t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
for i in range(len(spine) - 1):
    res("Rsp%d" % i, i * PITCH, SPINE_Y, (i + 1) * PITCH, SPINE_Y,
        spine[i], spine[i + 1])
for i, nm in enumerate(spine):
    node_bar(i * PITCH, SPINE_Y, nm)

# rungs: ni -RAi- xi -RBi- Bi  (i = 0..6)
for i in range(7):
    ni = i * PITCH
    res("RA%d" % i, ni, SPINE_Y, ni, RUNG_Y, "n%d" % i, "x%d" % i)
    res("RB%d" % i, ni, RUNG_Y, ni - PITCH, RUNG_Y, "x%d" % i, "B%d" % i)
    node_bar(ni, RUNG_Y, "x%d" % i)
    node_bar(ni - PITCH, RUNG_Y, "B%d" % i)

# MSB: OUT -RA7- x7 -RB7- B7
res("RA7", 7 * PITCH, SPINE_Y, 7 * PITCH, RUNG_Y, "OUT", "x7")
res("RB7", 7 * PITCH, RUNG_Y, 6 * PITCH, RUNG_Y, "x7", "B7")
node_bar(7 * PITCH, RUNG_Y, "x7")
node_bar(6 * PITCH, RUNG_Y, "B7")

# ports on the left edge
c.port("VSS", on=node_bar(0, SPINE_Y, "VSS"), dir="in")
c.port("OUT", on=node_bar(9 * PITCH, SPINE_Y, "OUT"), dir="out")
for i in range(8):
    c.port("B%d" % i, on=node_bar(i * PITCH - PITCH, BIT_Y, "B%d" % i), dir="in")
    c.wire(m1, [node_bar(i * PITCH - PITCH, RUNG_Y, "B%d" % i),
                (i * PITCH - PITCH, BIT_Y)], net="B%d" % i,
           width=max(tech.width(m1), 0.3))

# substrate guard ring tied to VSS around the array
x0g = -PITCH - MARGIN
x1g = 9 * PITCH + MARGIN
y0g = BIT_Y - MARGIN
y1g = SPINE_Y + MARGIN
gr = c.guard_ring("ntap", x0=x0g, y0=y0g, x1=x1g, y1=y1g, net="VSS")
c.wire(c0, [node_bar(0, SPINE_Y, "VSS"), gr.strap], net="VSS",
       width=max(tech.width(c0), 0.3))

TOP = c
