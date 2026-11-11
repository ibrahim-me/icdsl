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

# chain node pads
xn = [X0 + i*PITCH for i in range(NN)]
names = ["t"] + ["n%d"%i for i in range(7)] + ["OUT"]
npad = {}
for i, nm in enumerate(names):
    npad[nm] = node(xn[i], YCH, nm)

# termination RT1: t -> VSS, vertical
vss = node(xn[0], YCH - RL - 1.0, "VSS")
rt1 = res("RT1", xn[0], (YCH + vss.top)/2, "v", ("VSS", "t"))
link(npad["t"], rt1.a, "t")
link(vss, rt1.b, "VSS")

# chain resistors RT2 (t-n0) and RS0..RS5 (n0..n5->n1..n6), RS6 (n6-OUT)
# RT2 between t and n0
rt2 = res("RT2", (xn[0]+xn[1])/2, YCH, "h", ("t", "n0"))
link(npad["t"], rt2.a, "t")
link(npad["n0"], rt2.b, "n0")
prev = npad["n0"]
for i in range(7):
    nm = "n%d" % i
    nxt = "n%d" % (i+1) if i < 6 else "OUT"
    r = res("RS%d" % i, (xn[i+1]+xn[i+2])/2, YCH, "h", (nm, nxt))
    link(prev, r.a, nm)
    link(npad[nxt], r.b, nxt)
    prev = npad[nxt]

# 2R branches at n0..n6 and OUT: RAi (node->xi), RBi (xi->Bi), vertical
for i in range(8):
    nm = "n%d" % i if i < 7 else "OUT"
    xi = node(xn[i+1], YCH - RL - 1.0, "xi%d" % i)
    bi = node(xn[i+1], YCH - 2*RL - 2.0, "B%d" % i)
    ra = res("RA%d" % i, xn[i+1], (YCH + xi.top)/2, "v", (nm, "xi%d" % i))
    rb = res("RB%d" % i, xn[i+1], (xi.top + bi.top)/2, "v", ("xi%d" % i, "B%d" % i))
    link(npad[nm], ra.a, nm)
    link(xi, ra.b, "xi%d" % i)
    link(xi, rb.a, "xi%d" % i)
    link(bi, rb.b, "B%d" % i)

# ports: via up to m1 + port on m1 pad
for nm in names + ["VSS"] + ["B%d"%i for i in range(8)]:
    pad = npad[nm] if nm in npad else None
    if pad is None:
        # find the Bi or VSS pad
        for obj in c.shapes:
            pass
    break

# simpler: collect all pads by net
pads_by_net = {}
def reg(net, pad):
    pads_by_net.setdefault(net, []).append(pad)
for nm, p in npad.items():
    reg(nm, p)
reg("VSS", vss)
for i in range(8):
    reg("xi%d"%i, node(xn[i+1], YCH - RL - 1.0, "xi%d"%i))  # xi already made; re-fetch below

# rebuild xi/bi registry cleanly
pads_by_net = {}
def reg2(net, pad):
    pads_by_net.setdefault(net, []).append(pad)
for nm, p in npad.items():
    reg2(nm, p)
reg2("VSS", vss)
xi_pad = {}; bi_pad = {}
for i in range(8):
    xi_pad[i] = node(xn[i+1], YCH - RL - 1.0, "xi%d"%i)
    bi_pad[i] = node(xn[i+1], YCH - 2*RL - 2.0, "B%d"%i)
    reg2("xi%d"%i, xi_pad[i])
    reg2("B%d"%i, bi_pad[i])

# Note: the earlier branch loop already created xi/bi nodes; reg2 re-creates duplicates.
# To avoid duplicates, redo cleanly below. We'll restart cell cleanly.
