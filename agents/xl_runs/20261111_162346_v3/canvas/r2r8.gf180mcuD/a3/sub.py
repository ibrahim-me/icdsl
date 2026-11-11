# r2r8 - 8-bit R-2R ladder, 25 unit poly resistors (gf180mcuD / sky130A)
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # first conductor: resistor terminals land here
RW, RL = 1.0, 6.0     # unit resistor drawn W x L

c = Cell("r2r8")

# ---- chain nodes (left to right) and x positions ----
nodes = ["VSS", "t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
nx = {nd: i * RL for i, nd in enumerate(nodes)}   # 0, 6, 12, ..., 54

# ---- chain resistors (horizontal) ----
chain_names = ["RT1", "RT2", "RS0", "RS1", "RS2", "RS3", "RS4", "RS5", "RS6"]
chain = {}
for i, name in enumerate(chain_names):
    chain[name] = c.resistor("res_poly", w=RW, l=RL,
                             at=(nx[nodes[i]], 0.0),
                             nets=(nodes[i], nodes[i + 1]), orient="h")

# ---- node dots on c0 tie together all pads sharing a node ----
for nd in nodes:
    c.rect(c0, w=0.8, h=0.8, cx=nx[nd], cy=0.0, net=nd)

# ---- branches: at n0..n6 and OUT, two vertical resistors to the bit pin ----
branch_at = {"n0": "B0", "n1": "B1", "n2": "B2", "n3": "B3",
             "n4": "B4", "n5": "B5", "n6": "B6", "OUT": "B7"}
branch = {}
for nd, bit in branch_at.items():
    x = nx[nd]
    ra = c.resistor("res_poly", w=RW, l=RL, at=(x, 0.0),
                    nets=(nd, f"x_{nd}"), orient="v")
    rb = c.resistor("res_poly", w=RW, l=RL, at=(x, RL),
                    nets=(f"x_{nd}", bit), orient="v")
    branch[nd] = (ra, rb)
    # series point between ra.b (top) and rb.a (bottom)
    c.rect(c0, w=0.8, h=0.8, cx=x, cy=RL, net=f"x_{nd}")

# ---- ports ----
c.port("VSS", on=chain["RT1"].a, dir="in")
c.port("OUT", on=chain["RS6"].b, dir="out")
for nd, bit in branch_at.items():
    c.port(bit, on=branch[nd][1].b, dir="in")   # top pad of upper resistor

TOP = c
print("bbox:", c.bbox, "area um2:", c.bbox.w * c.bbox.h)

