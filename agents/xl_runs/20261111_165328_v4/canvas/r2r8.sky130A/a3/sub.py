from icdsl.canvas import *
tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width(m1), 0.2)
CW = max(tech.width(c0), 0.2)

c = Cell("r2r8")
RW, RL = 1.0, 6.0
PITCH = 9.0
X0 = 4.0
YCH = 20.0

names = ["t"] + ["n%d"%i for i in range(7)] + ["OUT"]
X = {nm: X0 + i*PITCH for i, nm in enumerate(names)}

# resistor placements: (name, x, y, orient, (net_a, net_b))
pl = []
pl.append(("RT1", X["t"], YCH - RL/2, "v", ("VSS","t")))
pl.append(("RT2", (X["t"]+X["n0"])/2, YCH, "h", ("t","n0")))
for i in range(7):
    a = "n%d"%i
    b = "n%d"%(i+1) if i<6 else "OUT"
    pl.append(("RS%d"%i, (X[a]+X[b])/2, YCH, "h", (a,b)))
for i in range(8):
    nm = "n%d"%i if i<7 else "OUT"
    x = X[nm]
    yxi = YCH - RL - 1.5
    ybi = yxi - RL - 1.5
    pl.append(("RA%d"%i, x, (YCH+yxi)/2, "v", (nm,"xi%d"%i)))
    pl.append(("RB%d"%i, x, (yxi+ybi)/2, "v", ("xi%d"%i,"B%d"%i)))

refs = {}
for name, x, y, orient, nets in pl:
    refs[name] = c.resistor("res_poly", w=RW, l=RL, at=(x, y), orient=orient, nets=nets)

# one c0 node pad per (net, location); connect each resistor terminal to its net pad
pads = {}   # (net, x, y) -> shape
def getpad(net, x, y, s=0.5):
    k = (net, x, y)
    if k not in pads:
        pads[k] = c.rect(c0, x0=x-s, x1=x+s, y0=y-s, y1=y+s, net=net)
    return pads[k]

def tpt(r, which):
    t = getattr(r, which)
    return (t.cx, t.cy)

for name, x, y, orient, nets in pl:
    r = refs[name]
    # determine terminal coordinates
    if orient == "h":
        pa = (x - RL/2, y); pb = (x + RL/2, y)
    else:
        pa = (x, y - RL/2); pb = (x, y + RL/2)
    getpad(nets[0], *pa)
    getpad(nets[1], *pb)
    c.wire(c0, [pa, tpt(r,"a")], width=CW, net=nets[0], first="h")
    c.wire(c0, [pb, tpt(r,"b")], width=CW, net=nets[1], first="h")

# ports: bring each pin net up to m1 via a c0 pad + via
for net in ["B%d"%i for i in range(8)] + ["OUT", "VSS"]:
    pts = [p.bbox for p in pads.values() if p.net == net]
    # pick a representative pad (first)
    pad = [p for p in pads.values() if p.net == net][0]
    v = c.via(c0, m1, at=(pad.cx, pad.cy), net=net, dir="v", top_dir="h")
    mp = c.rect(m1, x0=v.upper.left, x1=v.upper.right, y0=v.upper.bottom, y1=v.upper.top, net=net)
    c.port(net, on=mp)

TOP = c
