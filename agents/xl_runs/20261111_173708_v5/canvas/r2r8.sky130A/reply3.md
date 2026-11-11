```
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
assert "res_poly" in tech.d["devices"], "res_poly not available on this PDK"

# ---------- drawn resistor size (must match the netlist) ----------
RW, RL = 1.0, 6.0
CGAP = 2.0          # gap between series resistors on the main chain (bridged by c0)
TGAP = 2.0          # gap between the two resistors of a 2R tap
CHAIN_Y = 1.0       # y-center of the horizontal main chain
TAP_Y0 = 2.5        # y-bottom of the lower tap resistor
PORT_Y = 18.5       # y of the top-edge bit-line ports
MARGIN = 2.0

c = Cell("r2r8")

# ---------- main chain: VSS -t- n0 -n1- ... -n6- OUT  (9 unit resistors) ----------
chain = [("VSS", "t"), ("t", "n0")] + [(f"n{i}", f"n{i+1}") for i in range(6)] + [("n6", "OUT")]
x = MARGIN
chain_res = []
for a, b in chain:
    r = c.resistor("res_poly", w=RW, l=RL, at=(x, CHAIN_Y), nets=(a, b), orient="h")
    chain_res.append(r)
    x += RL + CGAP
chain_right = x - CGAP          # right end of the last resistor (OUT node)

def node_x(name):
    """x-center of a chain node (VSS/OUT at the chain ends, others in the gaps)."""
    if name == "VSS":
        return chain_res[0].left
    if name == "OUT":
        return chain_res[-1].right
    for k in range(len(chain_res) - 1):
        if chain_res[k].nets[1] == name and chain_res[k + 1].nets[0] == name:
            return (chain_res[k].right + chain_res[k + 1].left) / 2
    raise ValueError(name)

# c0 node rails along the chain (bridge the gaps between series resistors)
for k in range(len(chain_res) - 1):
    r0, r1 = chain_res[k], chain_res[k + 1]
    c.rect(c0, x0=r0.right, x1=r1.left,
           y0=CHAIN_Y - RW / 2, y1=CHAIN_Y + RW / 2, net=r0.nets[1])

# ---------- taps: at n0..n6 and OUT, two unit resistors in series to B0..B7 ----------
nodes = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
tap_objs = []
for i, node in enumerate(nodes):
    bit = f"B{i}"
    nx = node_x(node)
    ty = TAP_Y0

    lo = c.resistor("res_poly", w=RW, l=RL, at=(nx, ty), nets=(node, node + "_x"), orient="v")
    up = c.resistor("res_poly", w=RW, l=RL, at=(nx, lo.top + TGAP + RL / 2),
                    nets=(node + "_x", bit), orient="v")
    tap_objs += [lo, up]

    # c0: chain node -> lower tap resistor
    c.rect(c0, x0=nx - RW / 2, x1=nx + RW / 2,
           y0=CHAIN_Y + RW / 2, y1=lo.bottom, net=node)
    # c0: lower resistor -> upper resistor
    c.rect(c0, x0=nx - RW / 2, x1=nx + RW / 2,
           y0=lo.top, y1=up.bottom, net=node + "_x")

    # via stack c0 -> c2 at the top of the upper resistor, metal2 bit line up to the port
    c.via(c0, c2, at=(nx, up.top + TGAP), net=bit, dir="v")
    tap_objs.append(c.rect(c2, x0=nx - 0.6, x1=nx + 0.6,
                           y0=up.top + TGAP, y1=PORT_Y, net=bit))

# ---------- ports ----------
c.port("VSS", on=chain_res[0].a, dir="in")
c.port("OUT", on=chain_res[-1].b, dir="out")
for i, node in enumerate(nodes):
    bit = f"B{i}"
    nx = node_x(node)
    pad = c.rect(c2, x0=nx - 0.6, x1=nx + 0.6,
                 y0=PORT_Y - 1.0, y1=PORT_Y + 1.0, net=bit)
    c.port(bit, on=pad, dir="in")

# ---------- substrate guard ring tied to VSS around the array ----------
gr = c.guard_ring("ptap", around=tap_objs + chain_res, net="VSS", space=MARGIN)
c.port("VSS", on=gr.straps[0])

TOP = c


```