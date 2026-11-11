from icdsl.canvas import *

tech = use()
c0 = tech.c0

RW, RL = 1.0, 6.0          # unit resistor: drawn W x L (netlist r_width=1u r_length=6u)
CY = 0.0                   # main chain runs horizontally here

c = Cell("r2r8")
res = {}

# Main chain (left to right): VSS -t- n0 -n1- ... -n6 -OUT   (9 unit resistors)
chain_seq = [("RT1","VSS","t"),("RT2","t","n0")] + [(f"RS{k}",f"n{k}",f"n{k+1}") for k in range(6)] + [("RS6","n6","OUT")]
x = 0.0
node_x = {"VSS": 0.0}
for name, a, b in chain_seq:
    res[name] = c.resistor("res_poly", w=RW, l=RL, at=(x, CY), nets=(a, b), orient="h")
    x += RL
    node_x[b] = x                      # VSS=0, t=6, n0=12, ..., n6=48, OUT=54

# Two-resistor series branch at n0..n6 and OUT, going up to bits B0..B7
branch_at = {"n0":"B0","n1":"B1","n2":"B2","n3":"B3","n4":"B4","n5":"B5","n6":"B6","OUT":"B7"}
for node, bit in branch_at.items():
    bx = node_x[node]
    res[f"RA_{node}"] = c.resistor("res_poly", w=RW, l=RL, at=(bx, CY),     nets=(node, f"x_{node}"), orient="v")
    res[f"RB_{node}"] = c.resistor("res_poly", w=RW, l=RL, at=(bx, CY+RL), nets=(f"x_{node}", bit), orient="v")

def pad(name, end):
    r = res[name]
    return r.b if end == "b" else r.a

# Chain interconnections on m1 (c0): b-pad of left resistor to a-pad of right resistor
order = ["RT1","RT2","RS0","RS1","RS2","RS3","RS4","RS5","RS6"]
chain_node_names = ["t","n0","n1","n2","n3","n4","n5","n6","OUT"]
for i, name in enumerate(chain_node_names):
    c.wire(c0, [pad(order[i], "b"), pad(order[i+1], "a")], net=name, width=0.3)

# Branch connections: RA.a to the chain node; RA.b to RB.a at the internal x_ node
for node in branch_at:
    if node == "n0":
        c.wire(c0, [pad("RA_n0", "a"), pad("RT2", "b")], net="n0", width=0.3)
    else:
        k = int(node[1])
        c.wire(c0, [pad(f"RA_{node}", "a"), pad(f"RS{k-1}", "b")], net=node, width=0.3)
    c.wire(c0, [pad(f"RA_{node}", "b"), pad(f"RB_{node}", "a")], net=f"x_{node}", width=0.3)

# Ports
c.port("VSS", on=pad("RT1", "a"), dir="in")
c.port("OUT", on=pad("RS6", "b"), dir="out")
for node, bit in branch_at.items():
    c.port(bit, on=pad(f"RB_{node}", "b"), dir="in")

# Substrate guard ring around the array, tied to VSS (good practice)
bb = c.bbox
m = 1.5
ring = c.guard_ring("ptap", x0=bb.left-m, y0=bb.bottom-m, x1=bb.right+m, y1=bb.top+m, net="VSS")
c.wire(c0, [pad("RT1", "a"), ring.straps[0]], net="VSS", width=0.3)

TOP = c
