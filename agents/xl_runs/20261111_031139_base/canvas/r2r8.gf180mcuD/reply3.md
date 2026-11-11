```
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

devices = []   # (name, model, [nets])
pad_shapes = []  # (net, shape) for m1 pads to connect

def add_res(name, a, b, cx, cy, orient):
    """Draw one unit resistor manually: poly body + m1 pads at ends."""
    if orient == "h":
        poly = c.rect("poly", x0=cx - RL / 2, x1=cx + RL / 2,
                      y0=cy - RW / 2, y1=cy + RW / 2)
        # m1 pads at left/right ends of poly
        pad_w, pad_h = 0.34, 0.23   # m1 pad over contact (enclosure 0.06/0.005)
        p1 = c.rect(m1, x0=cx - RL / 2 - 0.02, x1=cx - RL / 2 + 0.22,
                    y0=cy - pad_h / 2, y1=cy + pad_h / 2, net=a)
        p2 = c.rect(m1, x0=cx + RL / 2 - 0.22, x1=cx + RL / 2 + 0.02,
                    y0=cy - pad_h / 2, y1=cy + pad_h / 2, net=b)
        # contact cuts on poly ends
        c.rect("contact", x0=cx - RL / 2 + 0.0, x1=cx - RL / 2 + 0.22,
               y0=cy - 0.11, y1=cy + 0.11)
        c.rect("contact", x0=cx + RL / 2 - 0.22, x1=cx + RL / 2 + 0.0,
               y0=cy - 0.11, y1=cy + 0.11)
        pad_shapes.append((a, p1)); pad_shapes.append((b, p2))
    else:
        poly = c.rect("poly", x0=cx - RW / 2, x1=cx + RW / 2,
                      y0=cy - RL / 2, y1=cy + RL / 2)
        pad_w, pad_h = 0.23, 0.34
        p1 = c.rect(m1, x0=cx - pad_w / 2, x1=cx + pad_w / 2,
                    y0=cy - RL / 2 - 0.02, y1=cy - RL / 2 + 0.22, net=a)
        p2 = c.rect(m1, x0=cx - pad_w / 2, x1=cx + pad_w / 2,
                    y0=cy + RL / 2 - 0.22, y1=cy + RL / 2 + 0.02, net=b)
        c.rect("contact", x0=cx - 0.11, x1=cx + 0.11,
               y0=cy - RL / 2 + 0.0, y1=cy - RL / 2 + 0.22)
        c.rect("contact", x0=cx - 0.11, x1=cx + 0.11,
               y0=cy + RL / 2 - 0.22, y1=cy + RL / 2 + 0.0)
        pad_shapes.append((a, p1)); pad_shapes.append((b, p2))
    devices.append((name, "ppolyf_u", [a, b, "VSS"]))
    return poly

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
    add_res("RS%d" % i, "n%d" % i, "x%d" % i, nx, rail_y + sgn * (RL / 2 + 0.45), "v")
    add_res("RB%d" % i, "x%d" % i, "B%d" % i, nx, rail_y + sgn * (RL + 0.45 + RL / 2), "v")
add_res("RS7", "OUT", "x7", X["OUT"], rail_y + RL / 2 + 0.45, "v")
add_res("RB7", "x7", "B7", X["OUT"], rail_y + RL + 0.45 + RL / 2, "v")

# ---------------- m1 interconnects ----------------
def pads_of(net):
    return [s for netname, s in pad_shapes if netname == net]

def wire_net(net):
    pts = [(s.cx, s.cy) for s in pads_of(net)]
    if not pts:
        return
    xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
    pw = 0.23   # m1 min width
    c.rect(m1, x0=min(xs) - pw / 2, x1=max(xs) + pw / 2,
           y0=min(ys) - pw / 2, y1=max(ys) + pw / 2, net=net)

# internal series nodes
for net in ["t", "n0", "n1", "n2", "n3", "n4", "n5", "n6"]:
    wire_net(net)
# shunt mid nodes
for i in range(7):
    wire_net("x%d" % i)
wire_net("x7")

# ---------------- ports ----------------
def port_net(net, idx=0):
    s = pads_of(net)[idx]
    c.port(net, on=s)

port_net("VSS", 0)   # left pad of first series resistor
port_net("OUT")
for i in range(8):
    if i < 7:
        port_net("B%d" % i, 1)   # b pad of bit resistor
    else:
        port_net("B7", 1)

TOP = c
```