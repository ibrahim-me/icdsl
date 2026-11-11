```python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
assert "res_poly" in tech.d["devices"], "res_poly not available on this PDK"

# ---------- electrical parameters (must match the netlist) ----------
RW, RL = 1.0, 6.0          # unit resistor drawn W and L
GAP = 2.0                  # metal1 node connector between series resistors
TAPX = 4.0                 # x-offset of a tap from its chain node
CHAIN_Y = 6.0              # y-center of the horizontal main chain
TAP_Y0 = CHAIN_Y + RW/2 + GAP   # bottom of the first (lower) tap resistor
BITPITCH = 4.0             # vertical pitch of the metal2 bit lines
MARGIN = 3.0               # margin around the array (also for the guard ring)

c = Cell("r2r8")

# ---------- main chain: VSS -t- n0 -n1- ... -n6- OUT  (9 unit resistors) ----------
chain = [("VSS", "t"), ("t", "n0")] + [(f"n{i}", f"n{i+1}") for i in range(6)] + [("n6", "OUT")]
x = MARGIN
res = {}                   # name -> resistor shape
for a, b in chain:
    r = c.resistor("res_poly", w=RW, l=RL, at=(x, CHAIN_Y), nets=(a, b), orient="h")
    res[(a, b)] = r
    x += RL + GAP
chain_right = x - GAP      # right end of the last resistor (OUT node)

# metal1 node connectors along the chain (same-net metal1 may merge; explicit is safe)
def chain_node_x(name):
    # return x-center of the node `name` on the chain
    if name == "VSS":
        return MARGIN
    if name == "OUT":
        return chain_right
    # find the resistor to the right of the node
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
tap = {}                   # node -> (lower, upper) resistor
for node, bit in bit_of.items():
    nx = chain_node_x(node)
    lo = c.resistor("res_poly", w=RW, l=RL, at=(nx + TAPX, TAP_Y0),
                    nets=(node, node + "_x"), orient="v")
    up = c.resistor("res_poly", w=RW, l=RL,
                    at=(nx + TAPX, lo.top + GAP), nets=(node + "_x", bit), orient="v")
    tap[node] = (lo, up)

# ---------- metal1 connectors: chain nodes to lower tap resistors ----------
for node in bit_of:
    nx = chain_node_x(node)
    lo = tap[node][0]
    c.rect(c1, x0=min(nx, lo.cx - RW / 2), x1=max(nx, lo.cx + RW / 2),
           y0=lo.bottom, y1=CHAIN_Y + RW / 2, net=node)

# ---------- metal2 bit lines B0..B7 (run over the array, one via per tap) ----------
for i, node in enumerate(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]):
    bit = bit_of[node]
    up = tap[node][1]
    by = CHAIN_Y + TAP_Y0 - CHAIN_Y + 2 * RL + GAP + 2 * GAP + i * BITPITCH
    by = up.top + GAP + 2 * GAP + i * BITPITCH
    c.via(c1, c2, at=(up.cx, up.top + GAP), net=bit, dir="v")
    c.rect(c2, x0=up.cx - 0.6, x1=max(chain_right + MARGIN, up.cx + 1.0) + 0.6,
           y0=by - RW / 2, y1=by + RW / 2, net=bit)

# ---------- ports ----------
c.port("VSS", on=res[("VSS", "t")].a, dir="in")
c.port("OUT", on=res[("n6", "OUT")].b, dir="out")
for i in range(8):
    bit = f"B{i}"
    node = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"][i]
    up = tap[node][1]
    by = up.top + GAP + 2 * GAP + i * BITPITCH
    c.port(bit, on=c.rect(c2, x0=chain_right + MARGIN - 1.0, x1=chain_right + MARGIN + 1.0,
                          y0=by - RW / 2, y1=by + RW / 2, net=bit), dir="in")

# ---------- substrate guard ring tied to VSS around the array ----------
bb = c.bbox
gr = c.guard_ring("ptap", around=[bb], net="VSS", space=MARGIN)
c.port("VSS", on=gr.straps[0])

TOP = c
``````python
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
assert "res_poly" in tech.d["devices"], "res_poly not available on this PDK"

# ---------- electrical parameters (must match the netlist) ----------
RW, RL = 1.0, 6.0          # unit resistor drawn W and L
GAP = 2.0                  # metal1 node connector between series resistors
CHAIN_Y = 6.0              # y-center of the horizontal main chain
TAPX = 4.0                 # x-offset of a tap from its chain node
BITPITCH = 4.0             # vertical pitch of the metal2 bit lines
MARGIN = 3.0               # margin around the array (also for the guard ring)

c = Cell("r2r8")

# ---------- main chain: VSS -t- n0 -n1- ... -n6- OUT  (9 unit resistors) ----------
chain = [("VSS", "t"), ("t", "n0")] + [(f"n{i}", f"n{i+1}") for i in range(6)] + [("n6", "OUT")]
x = MARGIN
res = {}
for a, b in chain:
    res[(a, b)] = c.resistor("res_poly", w=RW, l=RL, at=(x, CHAIN_Y), nets=(a, b), orient="h")
    x += RL + GAP
chain_right = x - GAP      # right end of the last resistor (OUT node)

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
tap = {}
for node, bit in bit_of.items():
    nx = chain_node_x(node)
    lo = c.resistor("res_poly", w=RW, l=RL, at=(nx + TAPX, TAP_Y0 := CHAIN_Y + RW / 2 + GAP),
                    nets=(node, node + "_x"), orient="v")
    up = c.resistor("res_poly", w=RW, l=RL, at=(nx + TAPX, lo.top + GAP),
                    nets=(node + "_x", bit), orient="v")
    tap[node] = (lo, up)

# metal1 connectors: chain node -> lower tap resistor
for node in bit_of:
    nx = chain_node_x(node)
    lo = tap[node][0]
    cy = CHAIN_Y + RW / 2
    c.rect(c1, x0=min(nx, lo.cx - RW / 2), x1=max(nx, lo.cx + RW / 2),
           y0=cy, y1=lo.bottom, net=node)

# ---------- metal2 bit lines B0..B7 (run over the array, one via per tap) ----------
for i, node in enumerate(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]):
    bit = bit_of[node]
    up = tap[node][1]
    by = up.top + GAP + 2 * GAP + i * BITPITCH
    c.via(c1, c2, at=(up.cx, up.top + GAP), net=bit, dir="v")
    c.rect(c2, x0=up.cx - 0.6, x1=chain_right + MARGIN + 1.0,
           y0=by - RW / 2, y1=by + RW / 2, net=bit)

# ---------- ports ----------
c.port("VSS", on=res[("VSS", "t")].a, dir="in")
c.port("OUT", on=res[("n6", "OUT")].b, dir="out")
for i in range(8):
    bit = f"B{i}"
    node = ["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"][i]
    up = tap[node][1]
    by = up.top + GAP + 2 * GAP + i * BITPITCH
    pad = c.rect(c2, x0=chain_right + MARGIN - 1.0, x1=chain_right + MARGIN + 1.0,
                 y0=by - RW / 2, y1=by + RW / 2, net=bit)
    c.port(bit, on=pad, dir="in")

# ---------- substrate guard ring tied to VSS around the array ----------
gr = c.guard_ring("ptap", around=[c.bbox], net="VSS", space=MARGIN)
c.port("VSS", on=gr.straps[0])

TOP = c
```