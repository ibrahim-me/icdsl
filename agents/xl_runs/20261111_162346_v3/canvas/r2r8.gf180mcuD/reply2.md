```
# r2r8 - 8-bit R-2R ladder, 25 unit poly resistors (gf180mcuD / sky130A)
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # m1 (gf180) / li (sky130): resistor terminals land here
RW, RL = 1.0, 6.0     # unit resistor drawn W x L

c = Cell("r2r8")

# ---- chain nodes (left to right) and their x positions ----
nodes = ["VSS", "t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
nx = {nd: i * RL for i, nd in enumerate(nodes)}   # VSS=0, t=6, n0=12, ..., OUT=54

# ---- chain resistors (horizontal), one per edge between consecutive nodes ----
chain = {}
for i in range(len(nodes) - 1):
    name = f"R{nd}" if False else None
# build explicit names matching the netlist
chain_names = ["RT1", "RT2", "RS0", "RS1", "RS2", "RS3", "RS4", "RS5", "RS6"]
for i, name in enumerate(chain_names):
    chain[name] = c.resistor("res_poly", w=RW, l=RL,
                             at=(nx[nodes[i]], 0.0),
                             nets=(nodes[i], nodes[i + 1]), orient="h")

# node dots tie together all resistor pads (and branch pads) that share a node
for nd in nodes:
    c.rect(c0, w=0.7, h=0.7, center=(nx[nd], 0.0), net=nd)

# ---- branches: at n0..n6 and OUT, two vertical resistors to the bit pin ----
branch_at = {"n0": "B0", "n1": "B1", "n2": "B2", "n3": "B3",
             "n4": "B4", "n5": "B5", "n6": "B6", "OUT": "B7"}
for nd, bit in branch_at.items():
    x = nx[nd]
    ra = c.resistor("res_poly", w=RW, l=RL, at=(x, 0.0), nets=(nd, f"x_{nd}"), orient="v")
    rb = c.resistor("res_poly", w=RW, l=RL, at=(x, RL), nets=(f"x_{nd}", bit), orient="v")
    c.rect(c0, w=0.7, h=0.7, center=(x, RL), net=f"x_{nd}")   # series point x_nd

# ---- ports ----
c.port("VSS", on=chain["RT1"].a, dir="in")
c.port("OUT", on=chain["RS6"].b, dir="out")
for nd, bit in branch_at.items():
    c.port(bit, on=c.resistor("res_poly", w=RW, l=RL, at=(0, 0)).b if False else None, dir="in")
# bit ports sit on the top pad of the upper branch resistor (re-fetch it)
for nd, bit in branch_at.items():
    x = nx[nd]
    rb = c.resistor("res_poly", w=RW, l=RL, at=(x, RL), nets=(f"x_{nd}", bit), orient="v")
    c.port(bit, on=rb.b, dir="in")

# ---- substrate guard ring tied to VSS around the array (good practice) ----
bb = c.bbox
pad = 1.2
ring = c.guard_ring("ptap", x0=bb.left - pad, y0=bb.bottom - pad,
                    x1=bb.right + pad, y1=bb.top + pad, net="VSS")
c.wire(c0, [chain["RT1"].a, ring.straps[0]], net="VSS", width=0.3)

TOP = c
print("bbox:", c.bbox, "area um2:", c.bbox.w * c.bbox.h)

```