# Final layout script for r2r8 on gf180mcuD (also valid on sky130A)
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # m1 (gf180) / li (sky130)
c1 = tech.c1          # m2
c2 = tech.c2          # m3
poly = "poly"

RW, RL = 1.0, 6.0     # unit resistor drawn W x L
CHAIN_Y = 0.0         # main chain runs horizontally here
BRANCH_X_PITCH = 6.0  # node spacing along chain (resistor length)

# Main chain nodes (left to right): VSS, t, n0..n6, OUT  -> 9 resistors
chain_nodes = ["VSS","t","n0","n1","n2","n3","n4","n5","n6","OUT"]
# Branches: at n0..n6 and OUT, two-resistor series branch to bit B0..B7
branch_at = {"n0":"B0","n1":"B1","n2":"B2","n3":"B3","n4":"B4","n5":"B5","n6":"B6","OUT":"B7"}

c = Cell("r2r8")

# ---- place all resistors ----
res = {}   # name -> resistor object
x = 0.0
# chain resistors: RT1(VSS-t), RT2(t-n0), RS0(n0-n1)...RS6(n6-OUT)
chain_edges = [("RT1","VSS","t"),("RT2","t","n0")] + [(f"RS{k}",f"n{k}",f"n{k+1}") for k in range(6)] + [("RS6","n6","OUT")]
for name, a, b in chain_edges:
    res[name] = c.resistor("res_poly", w=RW, l=RL, at=(x, CHAIN_Y), nets=(a,b), orient="h")
    x += RL
chain_end_x = x  # x position of OUT node

# branch resistors: at each chain node, vertical two-resistor branch up to bit pin
branch_x = {}
for k, node in enumerate(["n0","n1","n2","n3","n4","n5","n6"]):
    branch_x[node] = (k+1) * RL   # n0 at x=6? wait: VSS=0,t=6,n0=12
# recompute: VSS x=0, t x=6, n0 x=12, n1 x=18, ... n6 x=48, OUT x=54
branch_x = {"n0":12.0,"n1":18.0,"n2":24.0,"n3":30.0,"n4":36.0,"n5":42.0,"n6":48.0,"OUT":54.0}
for node, bit in branch_at.items():
    bx = branch_x[node]
    res[f"RA_{node}"] = c.resistor("res_poly", w=RW, l=RL, at=(bx, CHAIN_Y), nets=(node, f"x_{node}"), orient="v")
    res[f"RB_{node}"] = c.resistor("res_poly", w=RW, l=RL, at=(bx, CHAIN_Y+RL), nets=(f"x_{node}", bit), orient="v")

# ---- connect chain nodes with m1 (c0) wires between resistor pads ----
def node_pad(resname, end):
    r = res[resname]
    return r.b if end=="b" else r.a

# chain: connect b-pad of left resistor to a-pad of right resistor at each internal node
# RT1.b (t) -- RT2.a (t); RT2.b (n0) -- RS0.a (n0); ... RS5.b(n6) -- RS6.a(n6)
chain_seq = ["RT1","RT2","RS0","RS1","RS2","RS3","RS4","RS5","RS6"]
for i in range(len(chain_seq)-1):
    c.wire(c0, [node_pad(chain_seq[i],"b"), node_pad(chain_seq[i+1],"a")], net=chain_nodes[i+1], width=0.3)

# VSS pin: port on RT1.a pad (left end). OUT pin: port on RS6.b pad (right end).
# branch node connection: RA_.a (at chain node y=0) connects to chain node; RB_.b (top) is the bit pin port.
# RA_.a sits at chain node; connect it to the chain node pad with short wire
for node in branch_at:
    c.wire(c0, [node_pad(f"RA_{node}","a"), node_pad(f"RA_{node}","a")], net=node)  # no-op placeholder

# Actually connect RA_.a to the chain node: find which chain resistor ends at this node
# node n_k: RS_{k-1}.b and RS_k.a meet; RA connects to same point. Tie RA_.a to RS_k.a (or RT2.b for n0)
c.wire(c0, [node_pad("RA_n0","a"), node_pad("RT2","b")], net="n0")
for k in range(1,7):
    c.wire(c0, [node_pad(f"RA_n{k}","a"), node_pad(f"RS{k-1}","b")], net=f"n{k}")
c.wire(c0, [node_pad("RA_OUT","a"), node_pad("RS6","b")], net="OUT")

# connect RA_.b to RB_.a at x_node (series point x_) with short m1 wire
for node in branch_at:
    c.wire(c0, [node_pad(f"RA_{node}","b"), node_pad(f"RB_{node}","a")], net=f"x_{node}")

# ---- ports ----
c.port("VSS", on=node_pad("RT1","a"), dir="in")
c.port("OUT", on=node_pad("RS6","b"), dir="out")
for node, bit in branch_at.items():
    c.port(bit, on=node_pad(f"RB_{node}","b"), dir="in")
c.port("VSS", on=node_pad("RT1","a"))  # ensure VSS port (duplicate name ok? use one)

# VSS also ties to substrate/guard ring: tie all resistor bulk? resistor bulk is internal to PCell (VSS net).
# Add a VSS rail and guard ring around array tied to VSS.
bb = c.bbox
pad = 1.5
ring = c.guard_ring("ptap", x0=bb.left-pad, y0=bb.bottom-pad, x1=bb.right+pad, y1=bb.top+pad, net="VSS")
# strap VSS rail to the RT1.a pad
c.wire(c0, [node_pad("RT1","a"), ring.straps[0]], net="VSS", width=0.3)

TOP = c
print("bbox:", c.bbox, "area:", c.bbox.w*c.bbox.h)
