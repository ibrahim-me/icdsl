from icdsl.canvas import *
from collections import defaultdict

tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width("poly"), 0.15)   # poly resistor width  = netlist w  (1 um)
PL = 6.0                             # poly resistor length = netlist l  (6 um)
GAP = 0.4                            # gap between resistor bodies
BV = 0.9                             # vertical offset of branch rails

c = Cell("r2r8")

# resistor list: (name, net_a, net_b); a = left/bottom terminal
res = [
    ("R_B7x7", "B7", "x7"), ("R_x7OUT", "x7", "OUT"),
    ("R_OUTn6", "OUT", "n6"), ("R_n6n5", "n6", "n5"),
    ("R_n5n4", "n5", "n4"), ("R_n4n3", "n4", "n3"),
    ("R_n3n2", "n3", "n2"), ("R_n2n1", "n2", "n1"),
    ("R_n1n0", "n1", "n0"), ("R_n0t",  "n0", "t"),
    ("R_tVSS", "t", "VSS"),
]
for k in range(7):
    res.append((f"R_n{k}x{k}", f"n{k}", f"x{k}"))
    res.append((f"R_x{k}B{k}", f"x{k}", f"B{k}"))

# ---- main chain: horizontal, left to right, r.a = left terminal
allres = []
x = 0.0
for name, na, nb in res[:11]:
    r = c.resistor("res_poly", w=PW, l=PL, at=(x + PL / 2, 0),
                   nets=(na, nb), orient="h")
    allres.append((r, na, nb))
    x += PL + GAP

# x position of each shared node n_k (right end of resistor R_n{k}n{k-1})
node_x = {}
cx = 0.0
for i, (r, na, nb) in enumerate(allres[:11]):
    cx += PL
    if i < 10:
        node_x[nb] = cx
    cx += GAP

# ---- branches: node n_k --R-- x_k --R-- B_k, two vertical resistors
for k in range(7):
    x0 = node_x[f"n{k}"]
    r1 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV),
                    nets=(f"n{k}", f"x{k}"), orient="v")
    r2 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV + PL + GAP),
                    nets=(f"x{k}", f"B{k}"), orient="v")
    allres.append((r1, f"n{k}", f"x{k}"))
    allres.append((r2, f"x{k}", f"B{k}"))

# ---- connect every net's terminals on m1: one rail per net + drops to pads
terms = defaultdict(list)
for r, na, nb in allres:
    terms[na].append((r, "a"))
    terms[nb].append((r, "b"))

for net, lst in terms.items():
    pads = [(r.a if w == "a" else r.b) for r, w in lst]
    rail_y = sum(p.cy for p in pads) / len(pads)
    xs = [p.cx for p in pads]
    rail = c.rect(m1, x0=min(xs) - 0.2, x1=max(xs) + 0.2,
                  y0=rail_y - PW / 2, y1=rail_y + PW / 2, net=net)
    for p in pads:
        c.rect(m1, x0=min(p.left, rail.left), x1=max(p.right, rail.right),
               y0=min(p.bottom, rail.bottom), y1=max(p.top, rail.top), net=net)

# ---- ports
c.port("B7", on=allres[0][0].a, dir="in")      # left end of main chain
c.port("VSS", on=allres[10][0].b, dir="in")    # right end of main chain
c.port("OUT", on=allres[1][0].b, dir="out")    # OUT node of main chain
for k in range(7):
    rB = [r for r, na, nb in allres if na == f"x{k}" and nb == f"B{k}"][0]
    c.port(f"B{k}", on=rB.b, dir="in")

TOP = c
