from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)

RW, RL = 1.0, 6.0          # unit resistor: W=1u, L=6u (ppolyf_u)
PITCH = 7.0                # horizontal pitch along series rail
rail_y = 0.0

c = Cell("r2r8")

# node x positions along series rail
X = {"VSS": 0.0, "t": PITCH}
for i in range(7):
    X["n%d" % i] = (i + 2) * PITCH
X["OUT"] = 9 * PITCH

res = []   # (name, resobj)

def add_res(name, a, b, cx, cy, orient):
    r = c.resistor("res_poly", w=RW, l=RL, at=(cx, cy), nets=(a, b), orient=orient)
    res.append((name, r))
    c.device(name, "ppolyf_u", [a, b, "VSS"])
    return r

# ---------------- series rail: VSS -t- n0 -n1- ... -n6- OUT  (9 resistors)
series = [("VSS", "t"), ("t", "n0")] + \
         [("n%d" % i, "n%d" % (i + 1)) for i in range(6)] + \
         [("n6", "OUT")]
for k, (a, b) in enumerate(series):
    add_res("R%d" % k, a, b, (k + 0.5) * PITCH, rail_y, "h")

# ---------------- shunts: n_i -R- x_i -R- B_i  (i=0..6),  OUT -R- x7 -R- B7
for i in range(7):
    sgn = 1 if (i % 2 == 0) else -1
    nx = X["n%d" % i]
    add_res("RS%d" % i, "n%d" % i, "x%d" % i, nx, rail_y + sgn * (RL / 2 + 0.6), "v")
    add_res("RB%d" % i, "x%d" % i, "B%d" % i, nx, rail_y + sgn * (RL + 0.6 + RL / 2), "v")
add_res("RS7", "OUT", "x7", X["OUT"], rail_y + RL / 2 + 0.6, "v")
add_res("RB7", "x7", "B7", X["OUT"], rail_y + RL + 0.6 + RL / 2, "v")

# ---------------- m1 interconnects ----------------
def rpad(r, which):
    return getattr(r, which)

def find_pads(net):
    out = []
    for name, r in res:
        for w in ("a", "b"):
            if r.nets[0 if w == "a" else 1] == net:
                out.append((name, w, getattr(r, w)))
    return out

def strip(net):
    pads = [p for _, _, p in find_pads(net)]
    if len(pads) < 2:
        return
    xs = [p.cx for p in pads]; ys = [p.cy for p in pads]
    if abs(max(xs) - min(xs)) < abs(max(ys) - min(ys)):
        # vertical strip
        cx = (min(xs) + max(xs)) / 2
        c.rect(m1, x0=cx - 0.115, x1=cx + 0.115,
               y0=min(ys) - 0.115, y1=max(ys) + 0.115, net=net)
    else:
        cy = (min(ys) + max(ys)) / 2
        c.rect(m1, x0=min(xs) - 0.115, x1=max(xs) + 0.115,
               y0=cy - 0.115, y1=cy + 0.115, net=net)

for net in ["t", "n0", "n1", "n2", "n3", "n4", "n5", "n6"]:
    strip(net)
for i in range(7):
    strip("x%d" % i)
strip("x7")

# ---------------- ports ----------------
def port_net(net):
    pads = find_pads(net)
    if pads:
        c.port(net, on=pads[0][2])

port_net("VSS")
port_net("OUT")
for i in range(8):
    port_net("B%d" % i)

TOP = c

