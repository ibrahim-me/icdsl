from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width(m1), 0.2)

c = Cell("r2r8")

RW, RL = 1.0, 6.0
X0, PITCH, YCH = 2.5, 7.2, 9.0
NN = 9  # 0=t, 1..7=n0..n6, 8=OUT

def node(x, y, net):
    return c.rect(c0, x0=x-0.22, x1=x+0.22, y0=y-0.22, y1=y+0.22, net=net)

def link(p, q, net):
    c.via(c0, m1, at=(p.cx, p.cy), net=net, dir="v", top_dir="h")
    c.via(c0, m1, at=(q.cx, q.cy), net=net, dir="v", top_dir="h")
    c.wire(m1, [p, q], width=PW, net=net, first="h")

def res(name, x, y, orient, nets):
    return c.resistor("res_poly", w=RW, l=RL, at=(x, y), orient=orient, nets=nets)

xn = [X0 + i*PITCH for i in range(NN)]
names = ["t"] + ["n%d"%i for i in range(7)] + ["OUT"]
npad = {nm: node(xn[i], YCH, nm) for i, nm in enumerate(names)}

# termination RT1: t -> VSS (vertical)
vss = node(xn[0], YCH - RL - 1.0, "VSS")
rt1 = res("RT1", xn[0], (YCH + vss.top)/2, "v", ("VSS", "t"))
link(npad["t"], rt1.a, "t")
link(vss, rt1.b, "VSS")

# chain: RT2 (t-n0), RS0..RS6
rt2 = res("RT2", (xn[0]+xn[1])/2, YCH, "h", ("t", "n0"))
link(npad["t"], rt2.a, "t")
link(npad["n0"], rt2.b, "n0")
for i in range(7):
    nm = "n%d" % i
    nxt = "n%d" % (i+1) if i < 6 else "OUT"
    r = res("RS%d" % i, (xn[i+1]+xn[i+2])/2, YCH, "h", (nm, nxt))
    link(npad[nm], r.a, nm)
    link(npad[nxt], r.b, nxt)

# 2R branches at n0..n6 and OUT
xi_pad = {}; bi_pad = {}
for i in range(8):
    nm = "n%d" % i if i < 7 else "OUT"
    xi_pad[i] = node(xn[i+1], YCH - RL - 1.0, "xi%d" % i)
    bi_pad[i] = node(xn[i+1], YCH - 2*RL - 2.0, "B%d" % i)
    ra = res("RA%d" % i, xn[i+1], (YCH + xi_pad[i].top)/2, "v", (nm, "xi%d" % i))
    rb = res("RB%d" % i, xn[i+1], (xi_pad[i].top + bi_pad[i].top)/2, "v", ("xi%d" % i, "B%d" % i))
    link(npad[nm], ra.a, nm)
    link(xi_pad[i], ra.b, "xi%d" % i)
    link(xi_pad[i], rb.a, "xi%d" % i)
    link(bi_pad[i], rb.b, "B%d" % i)

# ports: via up to m1, port on m1 pad
def port_pin(net, pad):
    c.via(c0, m1, at=(pad.cx, pad.cy), net=net, dir="v", top_dir="h")
    mp = c.rect(m1, x0=pad.cx-PW, x1=pad.cx+PW, y0=pad.cy-PW, y1=pad.cy+PW, net=net)
    c.port(net, on=mp)

for nm in names:
    port_pin(nm, npad[nm])
port_pin("VSS", vss)
for i in range(8):
    port_pin("B%d"%i, bi_pad[i])

TOP = c
