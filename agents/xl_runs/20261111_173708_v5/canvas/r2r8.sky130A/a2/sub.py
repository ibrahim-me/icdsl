from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
assert "res_poly" in tech.d["devices"], "res_poly not available on this PDK"

# ---------- electrical parameters (must match the netlist) ----------
RW, RL = 1.0, 6.0          # unit resistor drawn W and L
GAP = 2.0                  # gap between series resistors / metal connectors
CHAIN_Y = 2.0              # y of the horizontal main chain
TAPX = 4.0                 # x-offset of a tap column from its chain node
TAP_PITCH = 16.0           # vertical pitch of tap columns (two 6um resistors + gaps)
BIT_TOP = 40.0             # y of the top-edge bit-line ports
MARGIN = 3.0               # margin around the array

c = Cell("r2r8")

# ---------- main chain: VSS -t- n0 -n1- ... -n6- OUT  (9 unit resistors) ----------
chain = [("VSS", "t"), ("t", "n0")] + [(f"n{i}", f"n{i+1}") for i in range(6)] + [("n6", "OUT")]
x = MARGIN
res = {}
for a, b in chain:
    res[(a, b)] = c.resistor("res_poly", w=RW, l=RL, at=(x, CHAIN_Y), nets=(a, b), orient="h")
    x += RL + GAP
chain_right = x - GAP          # right end of the last resistor (OUT node)
array_right = chain_right + MARGIN

def chain_node_x(name):
    if name == "VSS":
        return MARGIN
    if name == "OUT":
        return chain_right
    for (a, b), r in res.items():
        if b == name:
            return r.right + GAP / 2
    for (a, b), r in res.items():
        if a == name:
            return r.left - GAP / 2
    raise ValueError(name)

# ---------- taps: at n0..n6 and OUT, two unit resistors in series to B0..B7 ----------
bit_of = {"n0": "B0", "n1": "B1", "n2": "B2", "n3": "B3",
          "n4": "B4", "n5": "B5", "n6": "B6", "OUT": "B7"}
nodes = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
tap_objs = []                # shapes the guard ring must enclose
for i, node in enumerate(nodes):
    bit = bit_of[node]
    nx = chain_node_x(node)
    tx = nx + TAPX
    ty = CHAIN_Y + RW / 2 + GAP + i * TAP_PITCH   # bottom of lower tap resistor

    lo = c.resistor("res_poly", w=RW, l=RL, at=(tx, ty), nets=(node, node + "_x"), orient="v")
    up = c.resistor("res_poly", w=RW, l=RL, at=(tx, lo.top + GAP + RL / 2),
                    nets=(node + "_x", bit), orient="v")
    tap_objs += [lo, up]

    # metal1: chain node -> lower resistor bottom (L-shape)
    c.rect(c1, x0=min(nx, tx), x1=max(nx, tx),
           y0=CHAIN_Y - RW / 2, y1=CHAIN_Y + RW / 2, net=node)
    c.rect(c1, x0=tx - RW / 2, x1=tx + RW / 2,
           y0=CHAIN_Y + RW / 2, y1=lo.bottom, net=node)
    # metal1: lower resistor top -> upper resistor bottom
    c.rect(c1, x0=tx - RW / 2, x1=tx + RW / 2,
           y0=lo.top, y1=up.bottom, net=node + "_x")

    # via c0 -> c2 at the top of the upper resistor, then metal2 bit line up to the top edge
    c.via(c0, c2, at=(tx, up.top + GAP), net=bit, dir="v")
    c.rect(c2, x0=tx - 0.6, x1=tx + 0.6,
           y0=up.top + GAP, y1=BIT_TOP, net=bit)
    tap_objs.append(c.rect(c2, x0=tx - 0.6, x1=tx + 0.6,
                           y0=up.top + GAP, y1=BIT_TOP, net=bit))

# ---------- ports ----------
c.port("VSS", on=res[("VSS", "t")].a, dir="in")
c.port("OUT", on=res[("n6", "OUT")].b, dir="out")
for i, node in enumerate(nodes):
    bit = bit_of[node]
    nx = chain_node_x(node)
    tx = nx + TAPX
    pad = c.rect(c2, x0=tx - 0.6, x1=tx + 0.6,
                 y0=BIT_TOP - 1.0, y1=BIT_TOP + 1.0, net=bit)
    c.port(bit, on=pad, dir="in")

# ---------- substrate guard ring tied to VSS around the array ----------
gr = c.guard_ring("ptap", around=tap_objs + list(res.values()), net="VSS", space=MARGIN)
c.port("VSS", on=gr.straps[0])

TOP = c

