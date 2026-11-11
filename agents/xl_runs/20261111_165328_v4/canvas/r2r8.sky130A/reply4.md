```
from icdsl.canvas import *
tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width(m1), 0.2)
CW = max(tech.width(c0), 0.2)

c = Cell("r2r8")
RW, RL = 1.0, 6.0
PITCH = 8.0
X0 = 3.0
CHAIN_Y = 22.0
XI_Y = CHAIN_Y - RL - 1.5
BI_Y = XI_Y - RL - 1.5

names = ["t"] + ["n%d"%i for i in range(7)] + ["OUT"]
X = {nm: X0 + i*PITCH for i, nm in enumerate(names)}

# place all resistors
refs = {}
# RT1: VSS - t (vertical at X[t])
refs["RT1"] = c.resistor("res_poly", w=RW, l=RL, at=(X["t"], (CHAIN_Y+XI_Y)/2), orient="v", nets=("VSS","t"))
# RT2: t - n0 (horizontal)
refs["RT2"] = c.resistor("res_poly", w=RW, l=RL, at=((X["t"]+X["n0"])/2, CHAIN_Y), orient="h", nets=("t","n0"))
# RS0..RS6: n0-n1, ..., n6-OUT (horizontal)
for i in range(7):
    a = "n%d"%i
    b = "n%d"%(i+1) if i<6 else "OUT"
    refs["RS%d"%i] = c.resistor("res_poly", w=RW, l=RL, at=((X[a]+X[b])/2, CHAIN_Y), orient="h", nets=(a,b))
# RAi, RBi vertical branches
for i in range(8):
    nm = "n%d"%i if i<7 else "OUT"
    refs["RA%d"%i] = c.resistor("res_poly", w=RW, l=RL, at=(X[nm], (CHAIN_Y+XI_Y)/2), orient="v", nets=(nm,"xi%d"%i))
    refs["RB%d"%i] = c.resistor("res_poly", w=RW, l=RL, at=(X[nm], (XI_Y+BI_Y)/2), orient="v", nets=("xi%d"%i,"B%d"%i))

# c0 node pads
pads = {}
def pad(net, x, y, s=0.3):
    pads[(net,x,y)] = c.rect(c0, x0=x-s, x1=x+s, y0=y-s, y1=y+s, net=net)
    return pads[(net,x,y)]

# chain node pads
for nm in names:
    pad(nm, X[nm], CHAIN_Y)
# VSS pad
pad("VSS", X["t"], XI_Y)
# xi and Bi pads
for i in range(8):
    nm = "n%d"%i if i<7 else "OUT"
    pad("xi%d"%i, X[nm], XI_Y)
    pad("B%d"%i, X[nm], BI_Y)

def term(r, which):
    t = getattr(r, which)
    return (t.cx, t.cy)

# connect each resistor terminal to its net pad
for name, r in refs.items():
    # find nets
    pass

# Build connections explicitly
conns = [
    ("RT1","a","VSS",X["t"],XI_Y), ("RT1","b","t",X["t"],CHAIN_Y),
    ("RT2","a","t",X["t"],CHAIN_Y), ("RT2","b","n0",X["n0"],CHAIN_Y),
]
for i in range(7):
    a = "n%d"%i
    b = "n%d"%(i+1) if i<6 else "OUT"
    conns.append(("RS%d"%i,"a",a,X[a],CHAIN_Y))
    conns.append(("RS%d"%i,"b",b,X[b],CHAIN_Y))
for i in range(8):
    nm = "n%d"%i if i<7 else "OUT"
    conns.append(("RA%d"%i,"a",nm,X[nm],CHAIN_Y))
    conns.append(("RA%d"%i,"b","xi%d"%i,X[nm],XI_Y))
    conns.append(("RB%d"%i,"a","xi%d"%i,X[nm],XI_Y))
    conns.append(("RB%d"%i,"b","B%d"%i,X[nm],BI_Y))

for resname, which, net, x, y in conns:
    r = refs[resname]
    tx, ty = term(r, which)
    c.wire(c0, [(x,y), (tx,ty)], width=CW, net=net, first="h")

# ports: via c0->m1 at each pin pad, port on m1
for net in ["B%d"%i for i in range(8)] + ["OUT", "VSS"]:
    # find pad for this net
    cand = [p for (n,x,y),p in pads.items() if n == net]
    p = cand[0]
    v = c.via(c0, m1, at=(p.cx, p.cy), net=net, dir="v", top_dir="h")
    mp = c.rect(m1, x0=v.upper.left, x1=v.upper.right, y0=v.upper.bottom, y1=v.upper.top, net=net)
    c.port(net, on=mp)

TOP = c
```