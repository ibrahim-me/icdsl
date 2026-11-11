from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)
RW, RL = 1.0, 6.0          # unit resistor: W=1u, L=6u (ppolyf_u)
PITCH = RL + 0.6           # horizontal pitch between resistor columns

c = Cell("r2r8")

def res(cell, nets, at, orient="h"):
    """One unit poly resistor (ppolyf_u, 1u x 6u) with two c0/m1 pads."""
    r = cell.resistor("res_poly", w=RW, l=RL, at=at, nets=nets, orient=orient)
    return r

# ------------------------------------------------------------------ ladder
# Series rail: VSS - t - n0 - n1 - ... - n6 - OUT  (9 resistors, each R)
# Shunt at each node n0..n6, OUT: node - R - xi - R - Bi  (8 branches x 2 R)
rail_y = 4.2               # vertical centre of the series rail
x = 0.6                    # running x along the rail

def rail_node(name):
    global x
    pt = (x, rail_y)
    x += PITCH
    return pt

vss_pt = rail_node("VSS")      # VSS pin (left end)
t_pt   = rail_node("t")
n_pts  = [rail_node("n%d" % i) for i in range(7)]
out_pt = rail_node("OUT")      # right end

# series resistors along the rail
res(c, ("VSS", "t"),   vss_pt,   orient="h")
res(c, ("t", "n0"),    t_pt,     orient="h")
for i, pt in enumerate(n_pts):
    nxt = n_pts[i + 1] if i < 6 else out_pt
    res(c, ("n%d" % i, nxt[0] if isinstance(nxt, tuple) else "OUT"), pt, orient="h")
# fix the last net name properly:
c.shapes  # placeholder (no-op)

# redo series cleanly (the loop above used a wrong net for the last link)
# rebuild series links explicitly:
series_links = [("VSS", "t", vss_pt)] + [("t", "n0", t_pt)] + \
               [("n%d" % i, "n%d" % (i + 1), n_pts[i]) for i in range(6)] + \
               [("n6", "OUT", n_pts[6])]
for a, b, pt in series_links:
    res(c, (a, b), pt, orient="h")

# shunt branches: n_i - R - x_i - R - B_i   (i=0..6),  OUT - R - x7 - R - B7
branch_x = x               # all shunts drop at the same x (right of OUT)
branch_top_y = rail_y + 2.6
branch_bot_y = rail_y - 2.6

def rung(node_name, node_pt, bit_name, up):
    """2-resistor shunt from node_pt to bit pin: node - R - xi - R - bit."""
    cx = branch_x
    y_mid = branch_top_y if up else branch_bot_y
    y_bit = y_mid + (6.0 + 0.6) if up else y_mid - (6.0 + 0.6)
    res(c, (node_name, "x%d" % node_name[-1] if node_name != "OUT" else "x7"), (cx, y_mid), orient="v")
    bit_pt = (cx, y_bit)
    res(c, ("x%d" % node_name[-1] if node_name != "OUT" else "x7", bit_name), bit_pt, orient="v")
    return bit_pt

bit_pts = []
for i, pt in enumerate(n_pts):
    bit_pts.append(rung("n%d" % i, pt, "B%d" % i, up=(i % 2 == 0)))
bit_pts.append(rung("OUT", out_pt, "B7", up=(7 % 2 == 0)))

# ------------------------------------------------------------------ metal1 wiring
# Series rail on m1: connect all rail node resistor pads together + VSS + OUT pins.
# Each resistor's pads are r.a / r.b; we need the pad touching the rail point.
# Simpler: draw an m1 trunk along the rail and contact each resistor pad to it.

rail = c.rect(m1, x0=vss_pt[0] - 0.5, x1=out_pt[0] + 0.5,
              y0=rail_y - 0.55, y1=rail_y + 0.55, net="RAIL")

# gather resistor instances to contact their pads to the rail trunk
# (resistor() returns the resistor object; we didn't keep them. Rebuild tracking.)
# To keep it simple, contact pads via the resistor object references we keep below.

# Rebuild keeping references:
# (The above res() calls already drew resistors; we now need their pads. Re-do with tracking.)
# Easiest: track resistors in a list as we create them. Let's restructure: keep refs.

# --- restructure: keep all resistor refs ---
# (previous drawings remain; we will add contacts using fresh refs by re-creating is wasteful.
#  Instead, capture refs going forward for shunts, and for the rail we contact via a via array.)

# For the rail, contact each series resistor's rail-side pad to the trunk.
# We don't have refs, so find them: resistors are the res_poly devices. Use c.devices? Not exposed.
# Simplest robust approach: redo the whole ladder capturing refs. Clear cell and rebuild.

c = Cell("r2r8")
rail_y = 4.2
x = 0.6
def rail_node(name):
    global x
    pt = (x, rail_y); x += PITCH; return pt
vss_pt = rail_node("VSS"); t_pt = rail_node("t")
n_pts = [rail_node("n%d" % i) for i in range(7)]
out_pt = rail_node("OUT")

refs = []
def res_ref(nets, at, orient="h"):
    refs.append(res(c, nets, at, orient))
    return refs[-1]

series_links = [("VSS", "t", vss_pt), ("t", "n0", t_pt)] + \
               [("n%d" % i, "n%d" % (i + 1), n_pts[i]) for i in range(6)] + \
               [("n6", "OUT", n_pts[6])]
for a, b, pt in series_links:
    res_ref((a, b), pt, orient="h")

branch_x = x
branch_top_y = rail_y + 2.6
branch_bot_y = rail_y - 2.6
def rung_ref(node_name, bit_name, up):
    cx = branch_x
    y_mid = branch_top_y if up else branch_bot_y
    y_bit = y_mid + (RL + 0.6) if up else y_mid - (RL + 0.6)
    xi = "x%d" % (node_name[-1] if node_name != "OUT" else 7)
    res_ref((node_name, xi), (cx, y_mid), orient="v")
    res_ref((xi, bit_name), (cx, y_bit), orient="v")
    return (cx, y_bit)

bit_pts = [rung_ref("n%d" % i, "B%d" % i, up=(i % 2 == 0)) for i in range(7)]
bit_pts.append(rung_ref("OUT", "B7", up=True))

# m1 rail trunk
rail = c.rect(m1, x0=vss_pt[0] - 0.5, x1=out_pt[0] + 0.5,
              y0=rail_y - 0.55, y1=rail_y + 0.55, net="RAIL")

# contact every resistor pad that sits on a rail node to the trunk.
# A resistor's two pads: r.a and r.b are c0 rectangles at the two ends.
def contact_pads_to_trunk(resobj, trunk, pad_names=("a", "b")):
    for pn in pad_names:
        pad = getattr(resobj, pn)
        # via from pad (c0) up to m1 trunk, placed at pad centre
        c.via(c0, m1, at=pad.cx and pad.cx, net=None)  # placeholder

# The via() signature: c.via(c0, m1, at=(x,y), ...). pad.cx is a float; need tuple.
# Let's do it properly below.

# ------------------------------------------------------------------ (rebuild wiring cleanly)
# We'll place contacts manually using known resistor geometry instead of refs:
# Each horizontal resistor at (x, rail_y), length RL along x: pads at (x-RL/2, rail_y) and (x+RL/2, rail_y).
# Each vertical resistor at (cx, y), length RL along y: pads at (cx, y-RL/2) and (cx, y+RL/2).

def m1_contact_at(pt, net=None):
    c.via(c0, m1, at=pt, net=net)

# Rail trunk contacts: one contact per series resistor at its rail-side pad.
# Horizontal series resistors: left pad connects to previous node, right pad to next node.
# The trunk spans the whole rail; contact each resistor's right pad (toward increasing x) and the
# leftmost resistor's left pad (VSS) so the whole rail is one node.
for pt in [vss_pt, t_pt] + n_pts + [out_pt]:
    # right pad of resistor located at pt
    m1_contact_at((pt[0] + RL / 2 + 0.0, pt[1]), net="RAIL")
# also contact left pad of the VSS resistor (VSS pin side)
m1_contact_at((vss_pt[0] - RL / 2, rail_y), net="RAIL")

# Shunt: node pad (top/bottom of rail resistor) -> vertical resistor top pad -> ... -> bit.
# For each shunt, the rail node connects to the upper pad of the first vertical resistor.
for i, pt in enumerate(n_pts + [out_pt]):
    up = (i % 2 == 0) if i < 7 else True
    y_mid = branch_top_y if up else branch_bot_y
    # contact from rail trunk up to the vertical resistor's lower pad
    m1_contact_at((pt[0], rail_y), net="RAIL")  # node on rail
    # vertical resistor lower pad at (branch_x, y_mid - RL/2) connects to node via m1
    # draw m1 from (pt[0], rail_y) to (branch_x, y_mid - RL/2)? They're far apart.
    pass
