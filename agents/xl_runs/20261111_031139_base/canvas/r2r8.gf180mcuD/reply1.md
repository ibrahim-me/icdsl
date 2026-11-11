```python
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
```

I'm overcomplicating the wiring. Let me restart with a clean, disciplined approach: build the ladder, keep resistor refs, route m1 between pads with explicit wires, and use the Router for the bit lines. Let me rewrite the whole script cleanly.

Key facts for gf180mcuD:
- c0 = m1 (contacts land on m1). res_poly pads r.a/r.b are on c0=m1.
- So resistor pads are already m1 rectangles! I can wire directly on m1 between pads, no contacts needed for resistor-to-resistor connections on the same layer.
- Pins B0..B7, OUT, VSS need to be on m1 (c0) with port labels.

So: place all resistors (poly + m1 pads). Then draw m1 wires connecting pads according to netlist. Add vias to m2 only if needed for crossing (avoid crossings by layout). Add ports on m1 pads.

Let me design geometry precisely so m1 connections are short and Manhattan, with no crossings.

Layout plan (all coordinates in um):
- Series rail horizontal at y = rail_y. Resistors horizontal (length along x).
- Nodes at x positions: VSS, t, n0..n6, OUT. Each resistor between consecutive nodes.
- The m1 pads of adjacent resistors touch at the node (if I place them end to end with no gap, the pads might merge). Better: place resistors end to end; each resistor's right pad = next resistor's left pad location. To keep them distinct but connected, draw an m1 wire segment between pads, or just place pads adjacent and they connect via the poly? No—poly resistors are separate devices; the connection is via m1. If two m1 pads touch/overlap they become one node (good). But LVS wants them as separate resistors connected by a wire; touching m1 pads = short = connected, fine.

Actually simplest: place series resistors end-to-end along x with a small gap, connect pads with m1 segments. The m1 rail trunk approach: draw one continuous m1 rectangle along the rail, and contact each resistor pad to it. But pads are already m1; if a pad overlaps the trunk they merge. Let me just make the trunk pass through/over the pads.

Let me reconsider: resistor pads (r.a, r.b) are c0=m1 rectangles at the ends of the poly. For a horizontal resistor centered at (cx, cy) with length along x: poly spans [cx-RL/2, cx+RL/2] in x, [cy-RW/2, cy+RW/2] in y. Pads are at the ends. I need to know pad geometry. The resistor PCell places pads; r.a and r.b are the pad shapes (c0=m1). I can use r.a.center etc.

Cleanest: keep refs, and for each connection draw an m1 wire between the two pads (or via the trunk). Use c.wire on m1 between pad centers. Since pads are m1, wire on m1 connects them (overlap). 

Let me just do: for each net, collect the pads, and route m1 to connect them. Use the Router for the bit lines (each bit line connects two pads: xi and Bi pin). Actually each bit net connects exactly two resistor pads (xi and Bi) — wait Bi is a pin (port), not a resistor pad. The net "Bi" connects resistor pad (xRBi.b) to the pin Bi. So I need a port on that pad.

Let me define: every resistor net connects exactly two resistor pads (two-terminal device). The netlist nets are: VSS, t, n0..n6, OUT, x0..x7, B0..B7. Among these, B0..B7, OUT, VSS are pins. t, n0..n6, x0..x7 are internal.

Each internal net connects exactly two resistor pads (it's a series node between two resistors). Let me verify:
- t: XRT1 (VSS-t) and XRT2 (t-n0) → t connects pads of R1 and R2. ✓ two pads.
- n0: XRT2 (t-n0), XRA0 (n0-x0), XRS0 (n0-n1) → THREE pads! n0 is a 3-way junction.
- Similarly n1..n6 are 3-way, OUT is 2-way (XRS6 n6-OUT, XRA7 OUT-x7).
- x0: XRA0 (n0-x0), XRB0 (B0-x0) → two pads.
- etc.

So n0..n6 are 3-way junctions (series + shunt + series). These are the rail nodes. I'll connect them with the m1 rail trunk.

Plan:
1. Place all 25 resistors, keep refs.
2. Draw m1 rail trunk horizontal at rail_y spanning VSS..OUT. Contact each series resistor's rail pads to trunk. Since pads are m1, just ensure pad overlaps trunk or draw m1 segment.
   - For horizontal series resistor at node pt (its left side), the resistor spans x [pt.x - RL/2, pt.x + RL/2]? No. Let me place resistor so that its two pads are at the two node positions. I.e., resistor between node A (x=a) and node B (x=b) centered at ((a+b)/2, rail_y), length = b-a = RL. So pads at x=a and x=b, y=rail_y. The trunk at rail_y covers [a,b] in x, so pads (at ends) overlap trunk → connected. 
   - So place series resistors centered midway between consecutive node x-positions, with length = PITCH = RL+0.6? But resistor length must be exactly RL=6u. If nodes are spaced PITCH=6.6 apart, the resistor (6u) won't span node to node; there's a 0.6 gap. The m1 trunk fills the gap and connects pads. Good: pads at resistor ends (x = center ± 3), trunk continuous from VSS to OUT, pads overlap trunk → all rail nodes shorted together through trunk + pads. But wait, that shorts ALL rail nodes together! That's wrong—n0, n1, etc. are different nodes.

Right, critical mistake: the rail trunk would short n0 to n1. I must NOT trunk them together. Each series resistor connects two different nodes; the nodes are distinct nets. So I cannot use a single trunk.

So the series rail is a chain of resistors, each node between two resistors is a distinct net. I need m1 to connect: pad(R_i.right) — node ni — pad(R_{i+1}.left). These three meet at node ni. So at each node, the two adjacent resistor pads and possibly a shunt connect.

Layout: place resistors end to end. At the junction between resistor i and i+1, place the two pads adjacent (touching or connected by a short m1 segment). That junction = node ni. Then the shunt branches off from ni.

So: series resistors placed end-to-end along x with NO gap (pads touching), each junction is a node. From each junction (except ends), a shunt goes vertically.

But pads are m1 rectangles of finite size (~contact size + enclosure). If I place resistors end to end, the right pad of R_i and left pad of R_{i+1} are at the same x (the junction). They'd overlap if same y. I can stack them vertically at the junction: right pad of R_i at (junction_x, rail_y), left pad of R_{i+1} at (junction_x, rail_y) — same point. They'd merge into one node (good, that's the intent: they're the same net ni). But they belong to different resistors; merging m1 pads = same net = correct.

However, the poly resistors are separate (poly doesn't connect). The m1 pads merging connects the nets electrically. That's exactly what we want at a node.

But there's subtlety: each resistor pad is a c0 (contact) rectangle on top of poly. If two pads from different resistors overlap in m1, that's fine (same net). But they're on different poly regions; the contact is to each poly separately. Merging the m1 tops connects the two polys through m1. Correct.

So layout: 
- Series resistors end-to-end along x at y=rail_y. Junctions at x = cumulative. Each junction = node (VSS, t, n0, ..., OUT). Adjacent pads touch → same net.
- At each internal junction (t, n0..n6), bring a shunt vertically: from the junction, an m1 wire goes up/down to the first shunt resistor pad.

But the junction pads are at y=rail_y. The shunt first resistor is vertical at x=branch_x, spanning y from rail_y to rail_y+RL (or down). Its lower pad at (branch_x, rail_y) connects to... the junction is at x=junction_x, not branch_x. So I need an m1 wire from junction (junction_x, rail_y) to (branch_x, rail_y) then up. That's an m1 segment along rail_y from junction_x to branch_x, then the vertical resistor.

But the rail already has resistors along rail_y; an m1 segment along rail_y from junction_x to branch_x would cross/overlap the series resistors' poly and pads! Because series resistors occupy rail_y between junctions. Can't run m1 along rail_y past a junction without shorting.

Solution: route the shunt connection on a different layer or offset. Use m2 for the shunt "drop" wires: from junction, via up to m2, run m2 horizontally to branch_x, via down to m1, then up the shunt. Or simpler: place the shunt resistors at the junction x itself (vertical), so no horizontal drop needed.

Alternative cleaner layout: Put the shunt resistors vertically at each junction. I.e., at node ni, the shunt goes vertically: ni - R - xi - R - Bi, with both resistors vertical, stacked, at x = junction_x. Then:
- Lower shunt resistor: between ni (at rail_y) and xi (at rail_y + RL). Vertical resistor centered at (junction_x, rail_y + RL/2), length RL along y. Its lower pad at (junction_x, rail_y) = node ni (touches the series junction pad → same net). Its upper pad at (junction_x, rail_y + RL) = xi.
- Upper shunt resistor: between xi and Bi. Vertical resistor centered at (junction_x, rail_y + RL + RL/2) = (junction_x, rail_y + 1.5*RL). Lower pad at (junction_x, rail_y + RL) = xi (touches lower resistor's upper pad → same net xi). Upper pad at (junction_x, rail_y + 2*RL) = Bi pin.

This is clean! Each shunt is a vertical stack of 2 resistors at the junction x. The node pad (lower pad of lower shunt resistor) touches the series junction pad → connected. xi is the middle pad junction. Bi is the top pad = pin.

But the series resistors are horizontal at rail_y, and the shunt lower pad is at (junction_x, rail_y) — same point as the series junction. The series junction has pads from left and right series resistors at (junction_x, rail_y). Adding the shunt lower pad there = three m1 pads at same point = same net. Good, they merge.

But wait: can I place a vertical resistor whose lower pad is exactly at (junction_x, rail_y) where horizontal series resistor pads also are? The vertical resistor's poly is at x=junction_x, vertical orientation, spanning y [rail_y, rail_y+RL]. Its lower pad at (junction_x, rail_y - RW/2 ... )? Let me get pad geometry. For a vertical resistor (length along y), the poly spans y [cy-RL/2, cy+RL/2], x [cx-RW/2, cx+RW/2]. Pads at the two ends in y. The lower pad is around y = cy - RL/2, centered at x=cx. If cy = rail_y + RL/2, lower pad center y = rail_y. The pad is a c0 rectangle around (cx, rail_y). The series junction pads are also around (junction_x, rail_y) but for horizontal resistors, pads are at the ends in x, centered at y=rail_y, extending in x.

So at (junction_x, rail_y): horizontal resistor's right pad extends in x (around junction_x), vertical resistor's lower pad extends in y (around rail_y). They overlap near (junction_x, rail_y) → merge into one m1 node. Good. Slight overlap is fine (same net). But DRC: overlapping m1 of same net is fine. However, the pads might be designed as specific rectangles; overlap of two m1 pads = merge, OK.

But there's a concern: the vertical resistor's lower pad and the horizontal resistor's right pad both are contacts to poly. Overlapping m1 pads on different polys = the m1 merges but the contacts remain separate (each contact to its own poly). That's fine electrically (m1 node connects both polys). LVS: two resistors share a node. Correct.

Height concern: shunts extend up to rail_y + 2*RL = rail_y + 12, and down similarly if I put some down. Reference height is 11.06. rail_y + 12 - (rail_y - something) > 11. So I can't have shunts extending 12 up AND the rail. Let me alternate shunts up and down, each shunt extends 2*RL = 12 from rail. That's too much (12 > 11 height budget total).

Hmm. 2*RL = 12u per shunt, but height budget ~11. So a full 2R shunt (two 6u resistors) can't fit in 11u height if stacked vertically. Need to fold the 2R shunt: e.g., one resistor vertical (6u) then horizontal (6u) — but that needs width.

Wait, reference is 77 x 11. So height 11, width 77. A 2R shunt = two 6u resistors. If I orient the shunt resistors horizontally (length along x), each is 6u wide x 1u tall. Two in series = 12u wide. That fits in width (77) but the shunt would extend horizontally, not vertically.

Let me reconsider the whole orientation. Make the series rail VERTICAL and shunts horizontal? Series chain VSS-t-n0-...-OUT vertical: 9 resistors × 6u = 54u tall. Height budget 11 — no.

OK so neither pure orientation fits 9 resistors of 6u in 11u. Must fold/snake.

Reference 77 x 11: width 77 fits ~12 resistors of 6u end-to-end (12×6=72). Height 11 fits ~1-2 rows of resistors (6u each) plus wiring.

So: lay resistors in rows, each resistor 6u long (horizontal) x 1u tall, in a row. Multiple rows stacked vertically. Each row ~1u tall + spacing. We can have several rows within 11u.

The ladder is a chain; snake it through rows: row 1 left-to-right, then down to row 2 right-to-left, etc. This is like a serpentine. The nodes (junctions) are between consecutive resistors. Shunts branch off at nodes.

This is getting complex but doable. However, given the complexity and that LVS only checks connectivity (not geometry), maybe the simplest robust approach: place each resistor individually with explicit m1 wiring using the Router or manual wires, accepting a somewhat larger but still within-budget layout.

Budget: 1705 um2, reference 77 x 11. We have 2x area. So we can use up to ~1705 um2. E.g., 77 x 22 = 1694, or 100 x 17 = 1700. So we have room: up to ~17-22 in one dimension if other is ~77-100.

Let me design a compact but simple layout:

Place the 25 resistors in a grid. Each resistor 6x1. Arrange in rows of, say, 6 resistors per row (6×6=36u wide), with rows stacked. 25 resistors → 5 rows of 5 (5×6=30u wide, 5 rows). Height: 5 rows × (1u + spacing). Spacing between rows for wiring ~2-3u. So height ~5×(1+2.5)=17.5u. Width 30u. Area ~525 um2. Well within budget! But wiring the complex connectivity between rows takes space and vias.

Hmm, but the connectivity is a specific ladder; mapping it to a grid requires routing many nets. With m1 and m2 (two metal layers above c0=m1... wait c0=m1 for gf180, so metals are m1(=c0), m2, m3, m4, m5). The router uses c2=columns, c3=trunks. For gf180: c0=m1, c1=m2, c2=m3, c3=m4. Router default: columns on c2 (m3), trunks on c3 (m4), pins on c1 (m2). 

But resistor pads are on c0=m1. To route on m2/m3/m4 I need vias from m1 up. That's fine.

Given the complexity, let me use a cleaner strategy: 

**Strategy: Lay out the ladder as a single serpentine chain for the series rail, with shunts routed to bit pins on the side.**

Actually, let me reconsider the problem scale. 25 resistors, each 6x1. The reference achieves 77x11. Let me try to match a row-based approach close to reference.

Let me reconsider: maybe lay out ALL resistors horizontally in a few rows, and route the ladder connectivity with m1 (same layer as pads) within/between rows, using m2 for crossovers.

Given time, let me just write a script that:
1. Places resistors in a serpentine to form the series chain and shunts, computing node positions.
2. Routes m1 wires between pads to make connections.
3. Adds ports.

But manual routing of 25 resistors with 3-way junctions is error-prone. Let me use the Router for the nets, placing resistor pads as "pins" and letting the router connect. But the router connects pins (shapes) — I can give it pad shapes. The router routes on two layers (columns c2, trunks c3) with pins on c1. But pads are on c0=m1. Router pins should be on c1 (m2) per default. I'd need to bring resistor pads up to m2 first.

This is getting complicated. Let me step back and choose a SIMPLE, correct, DRC-clean layout even if not minimal, within area budget.

**Simple approach: one resistor per "cell", place them in a column/row with explicit m1 wiring on a single layer where possible, use m2 to avoid crossings.**

Given the ladder structure, here's a clean idea:

Lay out the series chain horizontally as the "spine" but FOLD it: since 9 resistors × 6u = 54u > fits in width 77 (54 < 77, OK!). So the series chain VSS-t-n0-n1-n2-n3-n4-n5-n6-OUT can be a single horizontal row of 9 resistors = 54u wide, 1u tall. That fits in 77 width! 

Then the shunts: at each node (t, n0..n6), a 2R shunt to a bit. Each shunt = 2 resistors. If I route each shunt vertically from the node, 2 resistors × 6u = 12u tall — too tall for 11 height. But I can route shunts horizontally to the side and stack the bit pins.

Alternative: route each shunt as: from node, go vertically a bit, then horizontally to a "bit column" where the two shunt resistors and the bit pin are. Hmm.

Let me reconsider height: 11u. A single resistor is 6u long. If vertical, 6u tall fits in 11. Two vertical resistors stacked = 12u > 11. So a 2R shunt can't be two vertical resistors stacked within 11u. But I can fold: one vertical (6u) then turn horizontal. 

New idea: Put the series spine horizontally (54u wide). At each node, the shunt goes DOWN (or up) vertically one resistor (6u) to an intermediate node xi, then the second resistor goes horizontally to the bit pin Bi. The bit pins are placed in a row below/above.

Let me detail:
- Spine at y = 6 (center). Nodes at x = 0, 6.6, 13.2, ... (VSS, t, n0..n6, OUT). 9 resistors, 10 nodes? Wait series chain has 9 resistors and 10 nodes: VSS, t, n0, n1, n2, n3, n4, n5, n6, OUT = 10 nodes. Spacing 6.6 → total width 9×6.6 = 59.4. Plus margins. Fits in 77. ✓
- Shunt at node ni (i=0..6) and at OUT (for B7), and t is part of VSS termination (no bit). Actually shunts: n0..n6 (7 nodes) to B0..B6, and OUT to B7. That's 8 shunts. t and VSS are the termination (no bit). 
- Each shunt: node ni - R - xi - R - Bi. Place first resistor vertical from node (y=6) down to xi (y = 6 - 6 = 0). So vertical resistor centered at (node_x, 3), spanning y [0,6]. Lower pad at (node_x, 6)=node, upper pad at (node_x, 0)=xi. Wait vertical resistor length 6 along y: centered at cy=3, spans y[0,6]. Pads at y=0 and y=6. Pad at y=6 = node (touches spine pad). Pad at y=0 = xi.
- Second resistor: xi - R - Bi, horizontal, from xi (node_x, 0) to Bi. Place it horizontal at y=0, from x=node_x to x=node_x+6, Bi pin at (node_x+6, 0). But adjacent shunts at node_x and node_x+6.6: their horizontal resistors at y=0 would overlap (node_x to node_x+6 and next node_x+6.6 to node_x+12.6 — gap of 0.6, OK no overlap). But the xi pads: shunt i's xi at (node_x, 0), shunt i+1's xi at (node_x+6.6, 0). Different nets, 0.6 apart horizontally at y=0 — but the horizontal resistors occupy y around 0 (1u tall, y[-0.5,0.5]). Adjacent horizontal resistors at y=0 with x-gap 0.6: their m1 pads at ends. The xi pad of shunt i at (node_x, 0) and the left pad of its horizontal resistor — same point (merge). Fine.

But wait, the vertical resistor's lower pad at (node_x, 0) = xi, and the horizontal resistor's left pad at (node_x, 0) = xi → merge, same net. Good. And the horizontal resistor's right pad at (node_x+6, 0) = Bi pin.

Problem: shunts alternate up/down to avoid the vertical resistors overlapping the spine? The spine is at y=6 (resistors horizontal at y=6, spanning y[5.5,6.5]). The vertical shunt resistors go from y=6 down to y=0 (centered at y=3, spanning y[0,6]). They touch the spine at y=6 (the node pad). They don't overlap the spine resistors (which are at y[5.5,6.5] horizontal) except at the node point. The vertical resistor poly at x=node_x spans y[0,6]; the spine horizontal resistor to the left of node spans x[node_x-6.6, node_x] at y[5.5,6.5]. They meet at (node_x, 6) region. The vertical resistor's top pad at y=6 and the spine resistor's right pad at x=node_x both around (node_x, 6) → merge (same net ni). Good. No DRC issue (same net overlap).

But all 8 shunts going DOWN to y=0: their horizontal second resistors at y=0 from node_x to node_x+6. The bit pins Bi at (node_x+6, 0). These bit pins are at y=0, x = 6, 13.2, ..., spaced 6.6. They're 1u tall pads (y[-0.5,0.5]). Adjacent bit pins spaced 6.6 apart — fine. But the horizontal resistors at y=0: shunt i occupies x[node_x, node_x+6], shunt i+1 occupies x[node_x+6.6, node_x+12.6]. Gap 0.6 between them (node_x+6 to node_x+6.6). Fine, no overlap.

But the xi pads at y=0: shunt i's xi at (node_x, 0) — this is also where the vertical resistor bottom pad and horizontal resistor left pad meet. And shunt i+1's vertical resistor bottom pad at (node_x+6.6, 0). These are 6.6 apart, fine.

However, there's a problem: the horizontal resistor at y=0 for shunt i goes from xi (node_x,0) to Bi (node_x+6, 0). But node_x+6 might be close to node_x+6.6 (next shunt's xi). The Bi pad at (node_x+6, 0) and next shunt's xi pad at (node_x+6.6, 0): 0.6 apart, different nets (Bi vs xi+1). m1 pads 0.6 apart — min space for m1 is 0.23, so 0.6 is fine. But the horizontal resistor of shunt i ends at node_x+6 (Bi pad), and the next vertical resistor is at node_x+6.6. Between them at y=0 there's gap 0.6. OK.

But hold on: are the bit pins all at y=0 in a row? B0..B7 at x = node_x+6 for each shunt. node_x for n0..n6, OUT: these are at spine positions. Let me set spine node x positions: VSS=0, t=6.6, n0=13.2, n1=19.8, n2=26.4, n3=33.0, n4=39.6, n5=46.2, n6=52.8, OUT=59.4. Shunts at n0..n6 and OUT: Bi at x = node_x+6: B0 at 19.2, B1 at 25.8, ..., B7 at 65.4. These are spaced 6.6, in a row at y=0. Width from 0 to 65.4 + pad margin ~67. Fits in 77. ✓

Height: spine at y=6 (resistors y[5.5,6.5]), shunts vertical down to y=0 (resistors y[0,6] for vertical ones, y[-0.5,0.5] for horizontal ones at y=0). So total y from -0.5 to 6.5 = 7u. Plus port labels and margins. Fits in 11 easily. 

Wait, but the vertical shunt resistor centered at (node_x, 3) spans y[0,6], x[node_x-0.5, node_x+0.5]. Its top pad at y=6 (node) and bottom pad at y=0 (xi). The spine horizontal resistors are at y[5.5,6.5]. The vertical resistor's top region y[5.5,6] at x=node_x overlaps with spine resistor's y[5.5,6.5] at x near node_x? The spine resistor to the left of node spans x[node_x-6.6, node_x], y[5.5,6.5]. The vertical resistor spans x[node_x-0.5,node_x+0.5], y[0,6]. Overlap region: x[node_x-0.5, node_x], y[5.5,6]. This is poly (vertical resistor) overlapping m1 (spine resistor)? No—spine resistor's poly is at y[5.5,6.5] (the poly resistor body), and its m1 pad is at the end x=node_x. The vertical resistor's poly is at x=node_x. These polys are at different locations (one horizontal y[5.5,6.5], one vertical x=node_x). They cross at (node_x, y[5.5,6])! Poly crossing poly = different resistors crossing. In CMOS, poly over poly isn't a connection (no diffusion), but DRC might not care about poly-poly overlap (it's just two poly rectangles overlapping = actually they'd merge into one poly shape). If two poly rectangles overlap, they become one connected poly shape → electrically the two resistors' polys connect → BAD (would short the resistors through poly).

So I must avoid poly-poly overlap between different resistors. The vertical shunt resistor poly (x=node_x, y[0,6]) crosses the horizontal spine resistor poly (y=6, x[node_x-6.6,node_x]) at the corner (node_x, 6). They overlap in a small region near (node_x, 6). That's a poly-poly overlap → merges the polys → shorts the resistors. Not acceptable.

To avoid: offset the vertical shunt resistor in x so it doesn't overlap the spine resistor poly, OR route the connection via m1 only (the resistor pads are m1; the poly bodies shouldn't overlap).

The resistor PCell: poly body plus pads (c0=m1) at ends. The pad extends beyond the poly. If I place the vertical shunt resistor such that its body is at x=node_x but the spine body ends at x=node_x (pad there), the bodies touch at the corner. To avoid overlap, I can shift the vertical resistor's x slightly so its body is clear of the spine body, and connect via m1 pad overlap.

This is getting fiddly. Let me reconsider: maybe place shunts going UP instead of down, and put the spine at the bottom, shunts above, with the vertical resistor bodies clearly separated horizontally from spine bodies by using the pad as the connector.

Alternative cleaner approach: Don't stack shunts on the spine nodes directly. Instead, route each shunt connection with m1 wires from the spine node pad to a shunt resistor placed in an open area, avoiding poly overlap by placing shunt resistors in empty regions (not on the spine line).

Given the area budget is 2x, I have room. Let me place:
- Spine: 9 horizontal resistors in a row at y=6, x from 0 to 59.4.
- Shunt resistors: place them in rows ABOVE the spine (y > 7), each shunt's two resistors placed vertically or horizontally in open area, connected to the spine node via m1 wires (which can route over the spine using m2 to avoid shorts, or route in gaps).

Hmm, routing m1 over the spine would short to the spine (same layer). Use m2 for crossovers with vias.

This is a real layout task. Given the constraints, let me use the Router to handle the interconnect, placing resistor pads as connection points. But the router needs pins on a layer and routes on c2/c3. Let me bring everything to m2 (c1) for routing.

Actually, simplest robust method given LVS-only connectivity check + DRC:

Place all resistors with plenty of space, then route each net with m1/m2 wires manually using c.wire and c.via, ensuring no poly overlap by placing resistors far apart. But 25 resistors with specific connectivity and area budget...

Let me reconsider the area budget: 1705 um2 is the MAX (2x reference). Reference 77x11=852. We can go up to 1705. So e.g. 100 x 17 = 1700. Plenty of room to place resistors with spacing and route.

Let me do a clean grid placement with routing on m1 and m2:

Place resistors in a grid, 5 columns x 5 rows = 25. Each resistor 6x1. Column pitch 7 (6+1 gap), row pitch 3 (1 body + 2 for wiring). Grid: width 5*7=35, height 5*3=15. Area 525. Then route.

But mapping the ladder to a grid and routing 16 nets (some 3-way) manually is complex.

Given the difficulty, let me use the **Router** properly:
1. Place all 25 resistors in a compact grid (their pads are on m1=c0).
2. For each resistor, create a small m2 "port" above each pad connected by a via (m1->m2). Now each resistor terminal is an m2 pad.
3. Use Router on the cell: pins = these m2 pads grouped by net. Router routes columns (c2=m3) and trunks (c3=m4). But router pins should be on c1=m2 per default (pin_layer=c1). Good, our ports are on m2. Router routes on m3 (columns) and m4 (trunks). 
4. The router connects all pads of the same net. 3-way nets (n0..n6) connect 3 pads — router handles multi-pin nets (trunks per pin row + spine).
5. Add top ports on the pin nets (B0..B7, OUT, VSS) — port on the m2 pad of the pin's resistor.

But the router routes between ALL pads of a net, including creating a connected mesh. For a 2-pin net it routes one connection. For 3-pin net (n0), it connects all three. Good. This avoids manual routing errors.

Concern: router obstacles — it treats existing shapes on routing layers as obstacles. The resistor poly bodies are on "poly" layer, not on m3/m4, so not obstacles for m3/m4 routing. The m2 ports (our pin pads) are on m2=c1, which is the pin layer — router uses them as pins, not obstacles. Good. But m2 wires we draw (the via pads) — small. Fine.

However, the router's "pins" are horizontal strips on the pin layer (c1=m2) that span the cell. It does `r.add(net, bar1, bar2)` or `r.auto()` uses conns of instances. Since I'm not using instances/conns, I'll call `r.add(net, pad1, pad2)` for each net, or `r.auto()` won't know the nets. Let me use `r.add` per net with the pad shapes.

Wait, but the router needs the pins to be shapes on the pin layer. I'll create m2 pads (small rectangles) at each resistor terminal, on the net. Then r.add(net, padA, padB). For 3-pin nets, call r.add with multiple? The signature `r.add("clk", bar1, bar2)` takes two bars. For multi-pin, I can chain: r.add(net, p1, p2); r.add(net, p2, p3) — but reusing p2: "A same-net shape is reused only where the new wire contains it or is contained by it; otherwise it is avoided." So adding net n0 with (p1,p2) then (p2,p3) — the second wire contains p2? It should be OK since same net and contained. Might work. Alternatively route 3-pin net as two connections sharing the middle pad.

Actually, simpler: for each net, collect all terminal pads; route them in a chain using r.add consecutively. Same-net reuse rule should handle shared pads.

But there's a subtlety: the router might not connect a pad to itself. Let me just try.

Also, the router by default uses v=c2 (m3), h=c3 (m4), pin_layer=c1 (m2). Our resistor terminals brought to m2 via via from m1 pad. Good.

But wait: are resistor pads on m1 (c0) for gf180? c0 = m1 for gf180. res_poly pads r.a/r.b — what layer? The PCell puts pads on c0 (the first conductor) = m1. So pads are m1. I via from m1 pad to m2 (c1) to create the router pin. Good.

Let me also handle: the router routes on m3/m4, but the final connections need to get from m4 trunk down to m2 pad — router creates vias between its layers (c2/c3 = m3/m4) and to pin layer (c1=m2)? The router creates columns on c2 and trunks on c3, and connects to pins on c1. It should place vias c1-c2 (m2-m3) and c2-c3 (m3-m4). For gf180, cuts: via1 (m1-m2), via2 (m2-m3), via3 (m3-m4). Router via(c0, c2) etc. It uses the cut stack. Should work generically.

Hold on, default Router: `r = Router(top)` → columns on c2, trunks on c3, pins on c1. For gf180 c0=m1, c1=m2, c2=m3, c3=m4. So pins on m2, columns m3, trunks m4. Vias: m2-m3 (via2), m3-m4 (via3). Good. Our resistor terminals on m2 (via via1 from m1 pad). 

Let me now also make sure I don't route on m1 (c0) except the resistor pads themselves. The router won't use m1. Good, no conflict with resistor pads.

Plan:
1. Place 25 resistors in a grid (to avoid poly overlap, give each its own space). Keep refs.
2. For each resistor, for each terminal (r.a, r.b), create an m2 pad: small m2 rectangle over the m1 pad, plus a via m1->m2. Actually the m1 pad already exists; I just place an m2 rectangle overlapping it with a via. Or simpler: place via (m1->m2) at pad center and an m2 pad rectangle. Let me create m2 pad rectangles at each terminal, net = the resistor's net for that terminal.
   - But I need to know which terminal is which net. res = c.resistor(..., nets=("a","b")) → r.a is net "a", r.b is net "b". So r.a.net? The pad shape has .net. Let me use r.a and r.b shapes with their nets.
3. Collect terminals by net. For each net, list of m2 pad shapes.
4. Router: for each net, connect its pads in a chain via r.add(net, pad[i], pad[i+1]).
5. Add ports for B0..B7, OUT, VSS on the corresponding m2 pad (or on the m1 pad). Port on m2 pad with label. Actually ports become GDS labels; place on the routing layer or m1. Let me place port on the m2 pad (c1) — but top-level pins should be accessible. The netlist pins are B0..B7, OUT, VSS. I'll c.port(net, on=m2pad_of_that_net). For VSS, it's a 2-pin net (VSS-t) — the VSS pin is on the VSS resistor pad. Good.

Wait, VSS net: XRT1 VSS-t. So VSS connects to resistor R1 pad (r.a or r.b = "VSS"). And t connects R1's other pad and R2. So VSS pin = one pad of R1. Good.

OUT net: XRS6 n6-OUT and XRA7 OUT-x7 → OUT is 2-pin (n6 and x7 pads). OUT pin = one of those pads. Actually OUT connects two pads: R(n6-OUT) and R(OUT-x7). So OUT net has 2 pads; the pin can be on either (they're connected by routing). I'll put port on one.

Let me now figure out resistor terminal → net mapping. When I create res(c, (net1, net2), ...), r.a = net1, r.b = net2 (assuming nets=("a","b") maps a→net1, b→net2). Let me verify from the resistor PCell: `nets=("a","b")`, r.a / r.b pads. The first net → r.a, second → r.b. I'll assume r.a.net == nets[0], r.b.net == nets[1]. The pad shapes have .net attribute set. I'll use shape.net.

Let me now also reconsider: do I even need the router? Manual routing might be simpler and more predictable for DRC. But the router handles obstacles and vias automatically. Given the grid placement with spaced resistors, routing on m3/m4 (upper layers) over everything is easy—few obstacles. The router should succeed. Let me use it but with a fallback: if router fails, route manually. I'll just use the router and check.

Actually, there's risk the router has trouble with the specific pad geometry. Let me think about whether to use router or manual. Given I must produce a correct script in one shot, let me use a hybrid: place resistors in a grid, route each net manually with m1 wires locally where pads are close, but that's complex.

Let me just go with the router approach; it's designed for this. Let me write it carefully.

Grid placement: 5 columns x 5 rows. Resistor pitch: x pitch 8 (6 body + 2 gap), y pitch 4 (1 body + 3 gap for m1 pads and routing). Actually pads extend beyond body; contact size 0.22, enclosure. The m1 pad is around the contact. Let me give x pitch 8, y pitch 5. Grid width 5*8=40, height 5*5=25. Area 1000 < 1705. OK but height 25 > reference 11; budget is area 1705, 40x25=1000 fine. But bounding box 40x25 — area 1000 < 1705. ✓. Though it's "fatter" than reference, area is what's budgeted. Good.

Wait, budget is "bounding box area ≤ 1705". 40*25=1000 ✓. Even 77x22=1694 ✓. So I have flexibility.

But can I do closer to reference to be safe? Let me aim for ~70 x 15 = 1050. Use 5 columns (x pitch 7 → 35 wide) and 5 rows (y pitch 3 → 15 tall) = 35x15=525. But y pitch 3 might be too tight for pads + m1 routing. Resistor body 1u tall (if horizontal) + pads. Pads (c0=m1 contact) are ~0.22 but the pad metal might be larger. Let me check: res_poly pads — size? Probably contact-sized with enclosure. For gf180 contact 0.22, m1 min width 0.23. Pad maybe 0.5x0.5. So y pitch 3 (1 body + 2 for pads/routing) is OK if resistors are horizontal (body 6 wide x 1 tall). But in a grid, alternate orientation? Let me keep all resistors horizontal (6 wide x 1 tall) for simplicity, placed in grid with x pitch 7, y pitch 3.5. 5 cols x 5 rows: width 5*7=35, height 5*3.5=17.5. Area 612. Fine.

Hmm, but horizontal resistors: body 6u wide, pads at left and right ends (x direction). Pads extend in x. Adjacent resistors in a row spaced 7 apart (6 body + 1 gap). Pads at ends might extend into the gap. Pad size ~0.5, enclosure from poly end. Poly ends at body edge; pad extends beyond poly by enclosure (~0.07) on each side? The pad is at the end of the poly. For horizontal resistor, pads at left and right, each ~0.5 wide in x, centered at the poly end. So pad extends ~0.25 beyond poly end. Gap between resistors = 1 (pitch 7 - body 6). Two pads facing each other across the gap: each extends 0.25 into gap → total 0.5 < 1 gap. OK no overlap. Good. But those facing pads are different nets (different resistors) — 0.5 gap > min space 0.23. OK.

Actually wait, I place resistors in a grid, not connected. Each resistor isolated. Then router connects pads via m3/m4. The gaps between resistors are empty (no m1), so router can route m3/m4 over them freely. Good. The m1 pads sit on m1; router doesn't use m1. Good.

So grid placement works. Let me set:
- 5 columns, 5 rows.
- x0 = 2, pitch_x = 7.5 → columns at x = 2, 9.5, 17, 24.5, 32. Width ~32+6+2=40.
- y0 = 2, pitch_y = 4 → rows at y = 2, 6, 10, 14, 18. Height ~18+1+2=21.
- All resistors horizontal (length along x). Place the 25 resistors in grid order, assign nets per the ladder.

But the ladder connectivity is specific; mapping 25 resistors to grid positions arbitrarily is fine since router connects them. I just need each resistor's two terminals assigned to the correct nets.

Let me create the 25 resistors with their (net1, net2) per the netlist, placed in grid order. Then router connects same-net pads.

List of resistors (net1, net2):
1. (VSS, t)   XRT1
2. (t, n0)    XRT2
3. (n0, x0)   XRA0
4. (B0, x0)   XRB0   → net (B0, x0); r.a=B0, r.b=x0
5. (n0, n1)   XRS0
6. (n1, x1)   XRA1
7. (B1, x1)   XRB1
8. (n1, n2)   XRS1
9. (n2, x2)   XRA2
10. (B2, x2)  XRB2
11. (n2, n3)  XRS2
12. (n3, x3)  XRA3
13. (B3, x3)  XRB3
14. (n3, n4)  XRS3
15. (n4, x4)  XRA4
16. (B4, x4)  XRB4
17. (n4, n5)  XRS4
18. (n5, x5)  XRA5
19. (B5, x5)  XRB5
20. (n5, n6)  XRS5
21. (n6, x6)  XRA6
22. (B6, x6)  XRB6
23. (n6, OUT) XRS6
24. (OUT, x7) XRA7
25. (B7, x7)  XRB7

Each resistor: r.a=net1, r.b=net2.

Terminals (pad, net):
- VSS: R1.a
- t: R1.b, R2.a
- n0: R2.b, R3.a, R5.a
- x0: R3.b, R4.b
- B0: R4.a
- n1: R5.b, R6.a, R8.a
- x1: R6.b, R7.b
- B1: R7.a
- n2: R8.b, R9.a, R11.a
- x2: R9.b, R10.b
- B2: R10.a
- n3: R11.b, R12.a, R14.a
- x3: R12.b, R13.b
- B3: R13.a
- n4: R14.b, R15.a, R17.a
- x4: R15.b, R16.b
- B4: R16.a
- n5: R17.b, R18.a, R20.a
- x5: R18.b, R19.b
- B5: R19.a
- n6: R20.b, R21.a, R23.a
- x6: R21.b, R22.b
- B6: R22.a
- OUT: R23.b, R24.a
- x7: R24.b, R25.b
- B7: R25.a

Good. Now router connects each net's pads.

For 2-pin nets: one r.add. For 3-pin nets (n0,n1,n2,n3,n4,n5,n6): chain them. E.g., n0: pads [R2.b, R3.a, R5.a]. r.add("n0", p1, p2); r.add("n0", p2, p3). The second reuses p2. Should be OK.

But the router's same-net reuse: "A same-net shape is reused only where the new wire contains it or is contained by it; otherwise it is avoided." When I add n0 (p1,p2) it draws a wire containing p1,p2. Then add n0 (p2,p3): the new wire should contain p2 (already there) and p3. Since p2 is contained in existing wire, reuse it. Likely fine. If it complains, I'll route 3-pin nets differently. Let me just try.

Now, the router `auto()` uses conns from instances — I have none. So I use `r.add` manually then `r.run()`.

After routing, add ports:
- For each bit Bi: port on the m2 pad of R(2i+4).a (the Bi pad). Actually Bi pad = R_{4+2i}.a? Let me see: B0 = R4.a, B1=R7.a, B2=R10.a, B3=R13.a, B4=R16.a, B5=R19.a, B6=R22.a, B7=R25.a. Pattern: R index 4,7,10,13,16,19,22,25 = 3i+4 for i=0..7. Yes R_{3i+4}.a = Bi.
- OUT: port on R23.b or R24.a (OUT pads). Use R24.a (OUT) — but OUT is net connecting R23.b and R24.a. After routing they're connected. Port on R24.a.
- VSS: port on R1.a.

Ports on m2 pads. c.port(net, on=shape). The shape should be on a conductor layer. m2 is c1. Good. But port labels: top-level pins become GDS labels. Place label on m2. Fine.

But wait: will LVS see the port as connecting the net? The port is a label on the m2 pad which is connected (via via) to the resistor pad (m1) and routed. LVS extracts the net; the port label names the pin. Should match.

Also need VSS and OUT and Bi ports. Good.

Now, one concern: the router routes on m3/m4, but the resistor pads are on m1 with vias to m2 pins. The router connects m2 pins via m3/m4. The connection from m1 pad to m2 pin: I place a via (m1->m2 = via1 for gf180) and an m2 pad. The via1 cut between m1 pad and m2 pad. Need enclosure: m1>via1 0,0.06; m2>via1 0.01,0.06. via1 size 0.26. m2 pad must enclose via1 by 0.01 (two opposite) / 0.06. Let me make m2 pad 0.8x0.8 centered on via. via1 0.26. m2 pad 0.8 encloses by (0.8-0.26)/2=0.27 > 0.06. Good. m1 pad (resistor pad) must enclose via1: m1>via1 0,0.06 (two opposite sides: 0 and 0.06). The resistor pad — what size? The PCell makes the pad; hopefully it encloses the contact. The contact (via1) is placed by me at pad center; the resistor pad is an m1 rectangle. If the resistor pad is exactly the contact size (0.22) it won't enclose via1 (0.26). Hmm. The resistor pad (c0) for gf180 = m1. The PCell likely makes the pad a contact-sized or larger m1 rectangle. If it's just the contact (0.22x0.22) and I place a via1 (0.26) on it, the via1 is larger than the pad → via1 not enclosed by m1 pad → DRC (m1>via1 enclosure fail) and via1 extends beyond m1 (no m1 under part of via) → the via1 needs m1 underneath (m1>via1 enclosure). If m1 pad is smaller than via1, fail.

To be safe, I should place my own m1 pad (enlarged) under the via, OR place the via on the resistor's existing contact. Actually the resistor PCell already places a contact (c0) at each pad? Let me think: res_poly creates a poly resistor with contacts on c0 at each end (r.a, r.b are the c0 pads). So r.a IS a c0=m1 contact pad (with the contact cut already?). Or r.a is an m1 pad rectangle. If r.a already includes a contact cut, then I shouldn't add another via on top (would be via on via / wrong stack).

Hmm. The pads r.a/r.b are on c0. For gf180 c0=m1, and the "contact" cut is contact (diff|poly -> m1). The resistor pad likely is an m1 rectangle over a contact cut to poly. So r.a includes m1 pad + contact to poly. To connect r.a to m2, I place via1 (m1->m2) on the m1 pad. via1 needs m1 enclosure: m1 pad must be ≥ via1 + enclosure. If the resistor's m1 pad is only contact-sized (0.22) it's too small for via1 (0.26). 

Solution: draw my own m1 pad rectangle (larger, e.g., 0.7x0.7) overlapping the resistor's m1 pad/contact, then via1 from that m1 pad to m2. The m1 pad overlaps the resistor pad (same net, merge) and is large enough for via1. But the resistor pad already has a contact to poly; my added m1 pad overlaps it — same layer m1, same net, merge fine. The contact to poly remains. Then via1 (m1->m2) on my m1 pad. Good.

But does overlapping m1 with the existing contact cause DRC? The contact cut is within the m1 pad; my m1 pad just extends the m1. Fine.

Alternatively, make the m2 pad large and place via1; ensure m1 underneath is large enough by drawing an m1 pad. Let me draw an m1 pad (0.7x0.7) at each terminal, overlapping the resistor pad, net=terminal net. Then via1 (m1->m2) at center, then m2 pad (0.8x0.8) at center. Actually I can skip separate m2 pad: the router needs a pin shape on m2. I'll create an m2 pad (0.8x0.8) at each terminal with the net, plus via1 from m1 pad to m2 pad. The router uses the m2 pad as pin.

Wait, but if I draw m1 pad and m2 pad and via1, that's a mini via stack. The router will connect m2 pads via m3/m4. Good.

Hold on, simpler: maybe the resistor pad r.a is already large enough. Let me not assume; I'll draw my own m1 pad at each terminal to be safe. But I need the terminal location: r.a.center. I'll place m1 pad at r.a.center, overlapping r.a.

Actually, even simpler and safe: connect everything on m1 locally where possible, but for the router I need pins on m2. Let me just create, for each terminal, an m2 pad with a via1 stack (m1 pad + via1 + m2 pad) at the resistor pad center. The m1 pad overlaps the resistor's m1 pad (same net). Good.

Let me now also double check the router will route without DRC: m3 min width 0.28, space 0.28. Router uses default widths? The router probably uses tech.width for the layer. Should be fine. m3/m4 spacing to obstacles: obstacles include existing m3/m4 (none initially) and the router's own wires. The router manages its own spacing. The pins (m2 pads) are on c1, not obstacles for c2/c3 routing. Vias between c1-c2 (via2: m2-m3) and c2-c3 (via3: m3-m4). The router places these. Should be DRC clean if router is correct.

But there's a catch: the router treats "everything already on the two routing layers, in this cell or below, as obstacle." Initially no m3/m4. As it routes, it adds wires; subsequent nets avoid them. Good.

Also the router might route columns (m3) vertically and trunks (m4) horizontally. With pins scattered in a grid, it should connect them.

Potential issue: 3-pin nets chained with r.add twice — the router might create a wire from p1 to p2, then p2 to p3. Fine.

Let me also consider: do I need to worry that the router connects pads of the same net that are the SAME physical pad? No, each terminal is distinct.

Alright, let me also handle the guard ring (good practice, not judged). I'll add a simple nwell/guard ring tied to VSS around the array? For gf180, there's pwell and nwell. A guard ring tied to VSS: use ntap (nwell tap) or ptap. The netlist doesn't include taps, so LVS won't check them, but extra devices might cause LVS mismatch (extra devices not in netlist). LVS: "same devices" —