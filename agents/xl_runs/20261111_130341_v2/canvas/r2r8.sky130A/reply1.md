```python
from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width("poly"), 0.15)          # poly resistor width (1 um in netlist)
PL = 6.0                                     # poly resistor length (6 um in netlist)
GAP = 0.4                                    # gap between resistor bodies
BV = 0.9                                     # vertical pitch between metal rails

c = Cell("r2r8")

# ------------------------------------------------------------------ resistors
# (name, net_a, net_b)  --  a is the left / bottom terminal
res = [
    ("R_B7x7", "B7", "x7"), ("R_x7OUT", "x7", "OUT"),
    ("R_OUTn6", "OUT", "n6"), ("R_n6n5", "n6", "n5"),
    ("R_n5n4", "n5", "n4"), ("R_n4n3", "n4", "n3"),
    ("R_n3n2", "n3", "n2"), ("R_n2n1", "n2", "n1"),
    ("R_n1n0", "n1", "n0"), ("R_n0t",  "n0", "t"),
    ("R_tVSS", "t", "VSS"),
]
# branches: node --R-- xk --R-- Bk   (k = 0..6)
for k in range(7):
    res.append((f"R_n{k}x{k}", f"n{k}", f"x{k}"))
    res.append((f"R_x{k}B{k}", f"x{k}", f"B{k}"))

# place main chain horizontally, left to right; r.a = left terminal
x = 0.0
main = []
for name, na, nb in res[:11]:
    r = c.resistor("res_poly", w=PW, l=PL, at=(x + PL / 2, 0),
                   nets=(na, nb), orient="h")
    main.append((r, na, nb))
    x += PL + GAP

# vertical branches at nodes n0..n6 (x positions of the shared nodes)
# node n_k sits between R_n{k+1}n{k} (right side) and R_n{k}n{k-1} (left side)
# in our left-to-right order: ... n6 n5 n4 n3 n2 n1 n0 t VSS
# x position of node n_k = x of right end of resistor R_n{k}n{k-1}
node_x = {}
cx = 0.0
for i, (r, na, nb) in enumerate(main):
    # right end of this resistor is a node
    cx += PL
    if i < 10:  # not the last (VSS end)
        # identify node name = nb of this resistor = na of next
        node_x[nb] = cx
    cx += GAP

# place branches upward from each node n_k
for k in range(7):
    x0 = node_x[f"n{k}"]
    # first resistor: n_k -> x_k  (vertical, bottom at node)
    r1 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV),
                    nets=(f"n{k}", f"x{k}"), orient="v")
    # second resistor: x_k -> B_k  (vertical, on top of first)
    r2 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV + PL + GAP),
                    nets=(f"x{k}", f"B{k}"), orient="v")

# ------------------------------------------------------------------ metal rails
# rail y-levels: main chain nodes at y=0; branch top (B_k) at y = BV+2*PL+GAP
# We connect every resistor terminal to its net rail on m1.
# Simplest robust scheme: one horizontal m1 rail per distinct net that has
# multiple terminals, plus short drops to each terminal pad.

# Collect terminals per net
from collections import defaultdict
terms = defaultdict(list)   # net -> list of (resistor, 'a'/'b')
for r, na, nb in main:
    terms[na].append((r, "a"))
    terms[nb].append((r, "b"))
for k in range(7):
    # branch resistors already added to `res`; find their objects by re-walking is awkward,
    # so instead re-collect below from all resistor objects we keep.
    pass

# Rebuild terminal list including branch resistors (keep references)
allres = []  # (r, na, nb)
x = 0.0
for name, na, nb in res[:11]:
    r = c.resistor("res_poly", w=PW, l=PL, at=(x + PL / 2, 0),
                   nets=(na, nb), orient="h")
    allres.append((r, na, nb))
    x += PL + GAP
# note: the first loop already created the main resistors; the second loop above
# recreated them. To avoid duplicates we restart cleanly below.

c = Cell("r2r8")   # rebuild cleanly
tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = max(tech.width("poly"), 0.15)
PL = 6.0
GAP = 0.4
BV = 0.9

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

allres = []
x = 0.0
for name, na, nb in res[:11]:
    r = c.resistor("res_poly", w=PW, l=PL, at=(x + PL / 2, 0),
                   nets=(na, nb), orient="h")
    allres.append((r, na, nb))
    x += PL + GAP

node_x = {}
cx = 0.0
for i, (r, na, nb) in enumerate(allres[:11]):
    cx += PL
    if i < 10:
        node_x[nb] = cx
    cx += GAP

for k in range(7):
    x0 = node_x[f"n{k}"]
    r1 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV),
                    nets=(f"n{k}", f"x{k}"), orient="v")
    r2 = c.resistor("res_poly", w=PW, l=PL, at=(x0, PL / 2 + BV + PL + GAP),
                    nets=(f"x{k}", f"B{k}"), orient="v")
    allres.append((r1, f"n{k}", f"x{k}"))
    allres.append((r2, f"x{k}", f"B{k}"))

terms = defaultdict(list)
for r, na, nb in allres:
    terms[na].append((r, "a"))
    terms[nb].append((r, "b"))

# connect each net's terminals with m1: a horizontal rail at the net's y, drops to pads
for net, lst in terms.items():
    pts = []
    for r, which in lst:
        pad = r.a if which == "a" else r.b
        pts.append(pad)
    # rail y = average pad y (all pads of a net share roughly one of the rail levels)
    ys = sorted({p.cy for p in pts})
    rail_y = sum(ys) / len(ys)
    xs = sorted({p.cx for p in pts})
    rail = c.rect(m1, x0=xs[0] - 0.2, x1=xs[-1] + 0.2,
                  y0=rail_y - PW / 2, y1=rail_y + PW / 2, net=net)
    for p in pts:
        c.rect(m1, x0=min(p.left, rail.left), x1=max(p.right, rail.right),
               y0=min(p.bottom, rail.bottom), y1=max(p.top, rail.top), net=net)

# ------------------------------------------------------------------ ports
# pin locations: B7 at left end of main chain, VSS at right end, OUT at its node,
# B0..B6 at top of branches.
c.port("B7", on=allres[0][0].a, dir="in")   # B7 terminal of R_B7x7 (left end)
c.port("VSS", on=allres[10][0].b, dir="in") # VSS terminal of R_tVSS (right end)
# OUT: terminal of R_x7OUT (b) / R_OUTn6 (a) at node OUT
c.port("OUT", on=allres[1][0].b, dir="out")
for k in range(7):
    # B_k is the top terminal of branch resistor R_x{k}B{k}
    rB = [r for r, na, nb in allres if na == f"x{k}" and nb == f"B{k}"][0]
    c.port(f"B{k}", on=rB.b, dir="in")

TOP = c
``````python
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
```