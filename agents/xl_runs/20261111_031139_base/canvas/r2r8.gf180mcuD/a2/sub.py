from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)

RW, RL = 1.0, 6.0          # unit resistor: W=1u, L=6u (ppolyf_u)
PITCH = 7.0                # horizontal pitch along the series rail
GAP = 0.7                  # gap between two stacked shunt resistors (bridged by m1)
rail_y = 0.0

c = Cell("r2r8")

# node x positions along the series rail
X = {"VSS": 0.0, "t": PITCH}
for i in range(7):
    X["n%d" % i] = (i + 2) * PITCH
X["OUT"] = 9 * PITCH

refs = []   # (net_a, net_b, resobj)

def add_res(a, b, cx, cy, orient):
    r = c.resistor("res_poly", w=RW, l=RL, at=(cx, cy), nets=(a, b), orient=orient)
    refs.append((a, b, r))
    return r

def pad(r, which):
    return getattr(r, which)

def connect(net, pts):
    """Run m1 through the given points (pads are m1 on gf180 since c0==m1)."""
    if not pts:
        return
    xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
    pad_w = 0.34
    c.rect(m1, x0=min(xs) - pad_w, x1=max(xs) + pad_w,
           y0=min(ys) - pad_w, y1=max(ys) + pad_w, net=net)

# ---------------- series rail: VSS -t- n0 -n1- ... -n6- OUT  (9 resistors)
series = [("VSS", "t"), ("t", "n0")] + \
         [("n%d" % i, "n%d" % (i + 1)) for i in range(6)] + \
         [("n6", "OUT")]
for k, (a, b) in enumerate(series):
    add_res(a, b, (k + 0.5) * PITCH, rail_y, "h")

# ---------------- shunts: n_i -R- x_i -R- B_i  (i=0..6),  OUT -R- x7 -R- B7
for i in range(7):
    sgn = 1 if (i % 2 == 0) else -1
    nx = X["n%d" % i]
    xi = "x%d" % i
    add_res("n%d" % i, xi, nx, rail_y + sgn * (3.0 - GAP / 2), "v")
    add_res(xi, "B%d" % i, nx, rail_y + sgn * (9.0 + GAP / 2), "v")
add_res("OUT", "x7", X["OUT"], rail_y + (3.0 - GAP / 2), "v")
add_res("x7", "B7", X["OUT"], rail_y + (9.0 + GAP / 2), "v")

# ---------------- m1 interconnects ----------------
def node_pts(net):
    pts = []
    for a, b, r in refs:
        for netname, padname in ((a, "a"), (b, "b")):
            if netname == net:
                p = pad(r, padname)
                pts.append((p.cx, p.cy))
    return pts

# internal series nodes: bridge the pads that share a net
for net in ["t", "n0", "n1", "n2", "n3", "n4", "n5", "n6"]:
    connect(net, node_pts(net))

# shunt mid nodes x0..x7
for i in range(7):
    connect("x%d" % i, node_pts("x%d" % i))
connect("x7", node_pts("x7"))

# ---------------- ports ----------------
c.port("VSS", on=pad([r for a, b, r in refs if (a, b) == ("VSS", "t")][0], "a"))
c.port("OUT", on=pad([r for a, b, r in refs if (a, b) == ("n6", "OUT")][0], "b"))
for i in range(8):
    if i < 7:
        r = [r for a, b, r in refs if (a, b) == ("x%d" % i, "B%d" % i)][0]
    else:
        r = [r for a, b, r in refs if (a, b) == ("x7", "B7")][0]
    c.port("B%d" % i, on=pad(r, "b"))
c.port("VSS", on=pad([r for a, b, r in refs if (a, b) == ("VSS", "t")][0], "a"))

TOP = c
