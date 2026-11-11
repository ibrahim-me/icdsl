I'll analyze the netlist topology and write a clean, systematic manual layout. Let me first check the PDK rule sheet for gf180mcuD to confirm layer/resistor details.

```python
from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1          # c0 = m1 (first conductor), c1 = m2
assert "res_poly" in tech.d["devices"], "gf180mcuD must have res_poly"

# ------------------------------------------------------------------ netlist
# 25 unit poly resistors, each W=1u L=6u (ppolyf_u).  Topology:
#   VSS -XRT1- t -XRT2- n0 -XRS0- n1 -XRS1- n2 ... n6 -XRS6- OUT   (spine)
#   each n_i (and OUT) -XRA_i- x_i -XRB_i- B_i                      (bit taps)
# All resistors identical orientation is "good practice, not judged";
# here the spine runs horizontally and the taps/terminator run vertically,
# which is the natural, compact R-2R embedding.

RW, RL = 1.0, 6.0                  # drawn W, L of every unit resistor
SPINE_Y = 0.0                      # spine runs along y = 0
PITCH_X = 8.0                      # centre-to-centre of spine nodes
TAP_XOFF = 4.0                     # tap column x offset from its spine node
TAP_PITCH_Y = 8.0                  # vertical pitch inside a tap column

c = Cell("r2r8")

def res(name, nets, x, y, orient="h"):
    """Place one unit resistor and return it."""
    return c.resistor("res_poly", w=RW, l=RL, at=(x, y), nets=nets,
                      orient=orient)

# ------------------------------------------------------------------ spine
# spine nodes n0..n6, OUT at x = 0,8,16,...,56 ; VSS at x=-8 (left end)
spine = ["VSS"] + ["n%d" % i for i in range(7)] + ["OUT"]
sx = {name: -8.0 + i * PITCH_X for i, name in enumerate(spine)}
# VSS(-8) -XRT1- t(-8,-8) -XRT2- n0(0) ; then XRS0..XRS6 along the spine
res("RT1", ("VSS", "t"), sx["VSS"], SPINE_Y - TAP_PITCH_Y, orient="v")
res("RT2", ("t", "n0"),  sx["VSS"], SPINE_Y, orient="v")
for i in range(7):
    res("RS%d" % i, ("n%d" % i, "n%d" % (i + 1) if i < 6 else "OUT"),
        sx["n%d" % i], SPINE_Y, orient="h")

# ------------------------------------------------------------------ bit taps
# n_i -XRA_i- x_i -XRB_i- B_i   (vertical column at x = sx[n_i] + TAP_XOFF)
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    tx = sx[node] + TAP_XOFF
    res("RA%d" % i, (node, "x%d" % i), tx, SPINE_Y, orient="v")
    res("RB%d" % i, ("x%d" % i, "B%d" % i), tx, SPINE_Y + TAP_PITCH_Y, orient="v")

# ------------------------------------------------------------------ guard ring
# substrate guard ring around the whole array, tied to VSS
xs = [sx[n] for n in spine] + [sx[n] + TAP_XOFF for n in ("n0", "n6", "OUT")]
ys = [SPINE_Y - TAP_PITCH_Y, SPINE_Y, SPINE_Y + TAP_PITCH_Y,
      SPINE_Y + 2 * TAP_PITCH_Y]
ring = c.guard_ring("ptap", x0=min(xs) - 1.5, x1=max(xs) + 1.5,
                    y0=min(ys) - 1.5, y1=max(ys) + 1.5, net="VSS", space=1.0)

# ------------------------------------------------------------------ ports
c.port("VSS", on=ring.straps[0])
c.port("OUT", on=c.resistor if False else None)  # placeholder, replaced below

# OUT port: on the right end of the last spine resistor (RS6)
rs6 = None
# find RS6 shape: it's the last spine resistor; reconnect via its net
# We'll attach OUT to the m1 pad of RS6's right end by locating the shape named OUT net.
# Simpler: place a small m1 port bar at the OUT node and short it to RS6.
outpad = c.rect(c0, x0=sx["OUT"] - 0.6, x1=sx["OUT"] + 0.6,
                y0=SPINE_Y - 0.6, y1=SPINE_Y + 0.6, net="OUT")
c.port("OUT", on=outpad)

# bit ports B0..B7 : on the top pad of each RB resistor
for i in range(8):
    tx = sx[("n%d" % i) if i < 7 else "OUT"] + TAP_XOFF
    rb = None
    # locate the RB resistor shape by net name B%i
    for s in c.shapes:
        if getattr(s, "net", None) == "B%d" % i:
            rb = s
            break
    c.port("B%d" % i, on=rb, dir="in")

TOP = c
```

Wait, I have issues: I referenced `c.shapes` and `c.resistor` placeholder incorrectly, and I haven't stored resistor shapes. Let me rewrite more carefully, storing the resistor shapes in a dict so I can attach ports. Also the `c.port("OUT", ...)` placeholder line is bogus. Let me rewrite cleanly.

Also I need to verify the resistor PCell returns an object with `.a` and `.b` pads, and that `c.port` can take `on=shape`. Let me store resistors in a dict keyed by name and use their `.a`/`.b` pads for ports.

Let me also reconsider: for the spine, VSS is at x=-8 and n0 at x=0. XRT1 connects VSS to t at (-8, -8) vertical, XRT2 connects t to n0 at (-8, 0) vertical. Wait that puts t at (-8,-8) and XRT2 from t(-8,-8) to n0(0,0)? No — XRT2 connects t to n0, but t is at x=-8 and n0 at x=0. A vertical resistor at x=-8 from y=-8 to y=0 would connect t to... a point at (-8,0), not n0(0,0). I need to fix the terminating leg geometry.

Let me redo the terminating leg: VSS --XRT1-- t --XRT2-- n0. Place VSS at (-8, 0)? Let me place the terminator as a vertical column at x = sx["VSS"] = -8:
- VSS node at (-8, 0)? But spine is at y=0 and n0 at (0,0). 

Hmm, let me restructure. Let me put the terminating leg at the left end going down:
- n0 at (0, 0). 
- XRT2: n0 to t. Vertical resistor at x=0 from y=0 down to y=-8: t at (0, -8).
- XRT1: t to VSS. Vertical resistor at x=0 from y=-8 down to y=-16: VSS at (0, -16).

But then VSS port is at (0,-16), separate from spine. That's fine. But the spine starts at n0(0,0). Let me not have a separate "VSS" spine node; the spine is n0..n6,OUT. VSS is the bottom of the terminator.

Let me redefine:
- Spine nodes: n0..n6, OUT at x = 0, 8, 16, ..., 56 (7 intervals, 8 nodes). n0 at x=0.
- Terminator at n0: XRT2 vertical from n0(0,0) down to t(0,-8), XRT1 vertical from t(0,-8) down to VSS(0,-16).
- Bit taps at each n_i and OUT: vertical column at x = sx[node] + 4.

Wait, but then n0 has: XRS0 (right to n1), XRT2 (down to t), XRA0 (up to x0). 3-way node. Good.

Let me also reconsider port placement. For B ports, the top of RB_i is at y = SPINE_Y + 2*TAP_PITCH_Y = 16. The RB resistor is vertical from y=8 (x_i) to y=16 (B_i). Its `.b` pad is at the top. Good, port B_i on rb.b.

For OUT port: OUT node at (56, 0). RS6 connects n6(48,0) to OUT(56,0) horizontally. OUT also has XRA7 vertical up to x7(60,0) then XRB7 up to B7(60,8). So OUT node is at (56,0). I'll put an OUT port pad there.

For VSS port: VSS at (0,-16), bottom of XRT1. Port on rt1.b (bottom pad) or a pad there.

Let me now also handle the guard ring bounding box. Array extent:
- x: from n0 tap column... let me compute. Spine x from 0 to 56. Tap columns at sx[node]+4: for n0..n6 that's 4,12,20,...,60; for OUT (56) tap at 60. So x range: resistors span. Spine resistors horizontal from x=0 to x=56 (each 6u long, centered on nodes? or from node to node). 

Hmm, I need to be careful about how the resistor PCell positions the resistor relative to `at=`. `at=(x,y)` is the center presumably. For orient="h", resistor extends x±3, y±0.5. So a spine resistor between n_i (x) and n_{i+1} (x+8) placed "at" the midpoint? But I called `res("RS%d",..., sx[n_i], SPINE_Y)` — at n_i's x, not the midpoint. That would overlap n_i and extend to n_i+3, not reach n_{i+1}.

I need to place each spine resistor at the midpoint between its two nodes. Let me fix: RS_i between n_i (x=sx[n_i]) and n_{i+1} (x=sx[n_i]+8). Place at x = sx[n_i] + 4, y=0, orient="h". Then it spans x from sx[n_i]+1 to sx[n_i]+7, centered at midpoint, with pads at left (near n_i+1) and right (near n_{i+1}-1). Then I connect n_i to the left pad and n_{i+1} to the right pad with short metal. Actually the pads are at the ends of the resistor (x±3). Left pad at sx[n_i]+1, right pad at sx[n_i]+7. The nodes n_i (sx[n_i]) and n_{i+1} (sx[n_i]+8) are 1u outside the pads. I need metal to bridge that 1u gap. That's fine — draw m1 rectangles from node to pad.

This is getting fiddly. Let me simplify by placing resistors so their pads land exactly on nodes, and connect nodes with metal bars. Actually, the cleanest: place each resistor with `at` at one end? The PCell `at` is likely center. Let me just place resistors and then connect pads to nodes with explicit m1 metal, using the pad shapes.

Given I can't test, let me make the layout robust by:
1. Placing each resistor.
2. For each net, collect all the resistor pads (and port pads) that should connect, and route them with a Router or explicit wires.

Actually, the cleanest robust method: place all resistors, then use a Router to connect the nets. But the Router needs "pins" — shapes on the pin layer. I can add pins on c1 for each net's pads, then Router connects them. But Router is a trunk router; with many nets it should handle it.

Hmm, but honestly, explicit point-to-point metal might be more predictable for this regular structure. Let me think about what's least error-prone.

Given the regular grid, let me do explicit metal:

Plan: 
- All resistor pads are on c0 (m1). 
- I'll create a metal grid: horizontal m1 rails at the spine y=0 connecting all spine nodes, and vertical m1 segments in each tap column connecting the tap resistors, plus m2 crossovers where needed.

But crossings: spine (horizontal m1 at y=0) crosses tap columns (vertical). At each n_i, the spine node and tap XRA_i connect — that's a junction, not a crossing (they should connect). At other points where a vertical tap column crosses the spine... the tap columns are AT the spine nodes (x = sx[node]+4, offset from spine node x). So the vertical tap column at x=sx[node]+4 does NOT cross the spine at a node; it's offset by 4u. The spine resistor RS_i spans x from sx[n_i]+1 to sx[n_i]+7 (centered at midpoint sx[n_i]+4). Oh! The tap column at x=sx[n_i]+4 is right in the middle of spine resistor RS_i. That's a crossing of vertical tap metal with horizontal spine resistor/metal — unwanted.

I need to avoid crossings. Let me offset tap columns so they don't cross spine resistors. Place tap columns at x = sx[node] (aligned with spine nodes) — but then the tap vertical metal meets the spine at the node (good, junction) but the spine resistor passes through the node too. At node n_i, spine resistors RS_{i-1} and RS_i meet, and tap XRA_i meets. All at the same point — that's the intended junction. But physically the spine resistor RS_i is between n_i and n_{i+1}; its right pad is near n_{i+1}. The tap at n_{i+1} connects at n_{i+1}. So vertical tap metal at x=sx[n_{i+1}] connects to the node n_{i+1} which is also the right end of RS_i. No crossing issue if the tap column is exactly at the node x and the spine resistor ends before it.

But the spine resistor RS_i spans from near n_i to near n_{i+1}; if tap columns are at the node x positions (sx[n_i]), and the resistor pads are inset from nodes, then between the pad and the node there's metal, and the tap column at the node connects there. The vertical tap metal at x=sx[n_i] only exists at the node (y around 0) and goes up. It doesn't cross other spine resistors because those are between nodes. OK so align tap columns with spine node x positions.

But then XRA_i vertical resistor at x=sx[n_i] from y=0 up — and XRT2 (terminator) also at x=sx[n0]=0 going down. At n0, XRA0 goes up, XRT2 goes down, XRS0 goes right. Fine, all at x=0.

Wait, but multiple things at x=0: XRT2 (n0 to t, vertical down), XRA0 (n0 to x0, vertical up). They share node n0 at (0,0) but go opposite directions. Good, no overlap.

Let me also reconsider: the terminator VSS at (0,-16). And spine n0 at (0,0). The XRT1 from t(0,-8) to VSS(0,-16), XRT2 from n0(0,0) to t(0,-8). Good, vertical column at x=0 from y=0 down to -16.

Now crossings: tap columns at x = sx[n_i] = 0,8,16,...,56 for i=0..6, and OUT at 56. These are vertical lines going up from y=0. The spine is horizontal at y=0 from x=0 to x=56. The tap columns meet the spine at the nodes — intended junctions. But do tap columns cross spine resistors elsewhere? Spine resistors are horizontal segments at y=0 between nodes. A tap column at x=sx[n_i] goes up from y=0; it only touches the spine at y=0 (the node). For i not at an endpoint, the tap column at x=sx[n_i] is between spine resistors RS_{i-1} (ending at n_i) and RS_i (starting at n_i). The tap column starts at y=0 going up; the spine resistors are at y=0 (height 1u, y from -0.5 to 0.5). So the tap column's bottom (y=0 to 0.5 region) overlaps the spine resistor area vertically? The tap resistor XRA_i is vertical at x=sx[n_i], from y=0 to y=8, width 1u (x from sx[n_i]-0.5 to sx[n_i]+0.5). The spine resistor RS_{i-1} ends at n_i with its right pad near sx[n_i]-1, and RS_i starts with left pad near sx[n_i]+1. So there's a gap around x=sx[n_i] where no spine resistor is (the pads are inset). The node n_i metal connects them. So I'll draw a node metal rectangle at each n_i connecting the adjacent pads and the tap.

This is doable but intricate. Let me simplify the entire approach: 

**Use explicit node bars.** For each net, I'll place a small m1 "node bar" at the node location, connect all incident resistor pads to it with m1, and route. But routing each connection explicitly is a lot.

Given the complexity and that I can't test, let me reconsider using the **Router**. Here's a clean router-based plan:

1. Place all 25 resistors (positions computed).
2. For each net, create pin shapes on c1 (the pin layer) at each resistor pad that belongs to the net. Actually, the Router's `add(net, pin1, pin2, ...)` takes shapes. I can add each resistor pad as a pin. But a net has multiple pads (e.g., net n0 connects XRT2, XRS0, XRA0 — 3 pads). The Router connects all pins of a net.

But I need the pads to be on the pin layer (c1) for the Router, or it can use c0 shapes? The Router routes on c2 (columns) and c3 (trunks), pins on c1. Resistor pads are on c0. I'd need vias from c0 to c1. This is getting complicated.

Let me step back and choose the **simplest robust approach**: explicit metal1 (m1=c0) connections since everything is on one layer mostly, with m2 for crossings if needed. Given my layout avoids crossings (tap columns at nodes, terminator at n0), I might be able to do it all on m1!

Let me check: 
- Spine: horizontal m1 at y=0 connecting n0..n6,OUT. But the spine resistors themselves are poly (not metal). The nodes n_i need metal connections. If I run a continuous m1 horizontal rail at y=0 from x=0 to x=56 (covering all spine nodes), and connect each resistor pad to this rail with vias/contacts... but resistor pads are on c0=m1 already! So the resistor pads (m1) can directly touch the spine rail (m1) if they overlap or abut.

Actually the resistor pads ARE on m1 (c0). So if I place the spine rail (m1) at y=0 and the resistor pads touch it, they connect directly (same layer, no via needed). 

So plan:
- Spine rail: m1 rectangle from x=0 to x=56, y=-0.6 to y=0.6 (at y=0). This connects all spine nodes n0..n6,OUT into one node?! NO — that's wrong. The spine nodes n0, n1, ..., OUT are DIFFERENT nets separated by resistors. I cannot connect them all with one rail.

Right, the resistors are between the nodes. So the metal must connect: pad of RS_i(left) to node n_i, pad of RS_i(right) to node n_{i+1}, but node n_i and node n_{i+1} are NOT connected to each other by metal (they're connected through the poly resistor). So each node is a separate m1 island.

So I need separate m1 pads for each node, with the resistor poly bridging them (the resistor itself connects the two pads through poly, with contacts). Wait — how does a poly resistor connect? The resistor is a poly strip; at each end there's a contact from poly to m1. The m1 pads at each end are the terminals. So r.a and r.b are m1 pads connected to the poly ends. The resistor electrically connects r.a to r.b through the poly. So I just need r.a of one resistor to connect (by m1) to r.b of the next, etc., at each node.

So at node n_i: r.b of XRT2 (or r.a of RS0) ... let me just say: at each node, the incident resistor pads are shorted together with m1. Each node is its own m1 island (rectangle) touching the incident pads.

So the layout: place resistors, then for each node draw an m1 rectangle that touches all incident pads, merging them. Since pads are m1 and the node rectangle is m1, if they overlap/abut they're one node. 

To make pads touch node rectangles reliably, I should place resistors so their pads are at known locations, then draw node rectangles covering the pads.

Given the resistor PCell pad geometry is uncertain, let me place resistors and then use `c.wire` or `c.rect` to connect pad to node. I can reference pad shapes (r.a, r.b) which have .left/.right/etc.

OK, I think I'm overcomplicating. Let me just write it, storing each resistor, and connecting pads to node bars with explicit m1 rectangles that span from the pad to the node center. I'll make node bars generous so they definitely touch pads.

Actually, the simplest reliable connection: draw the node bar FIRST as an m1 rectangle at the node location, then place resistors such that their pads overlap the node bar. But I place resistors by center...

Let me just place resistors and connect each pad to its node with a short m1 wire using `c.rect` spanning between pad and node point. I'll compute node points and pad points.

Hmm, but I don't know exact pad points. Let me make node bars large enough (e.g., 2u x 2u centered on node) and place resistors so pads are near nodes, then run m1 from pad to node bar. If pad is within the node bar or touches it, connected.

Let me reconsider resistor placement so pads land on nodes:
- For orient="h" resistor placed at center (cx, cy): spans x cx±3, y cy±0.5. Pads at left end (x=cx-3) and right end (x=cx+3), each presumably a small m1 pad around the end. If I place a spine resistor RS_i with center at midpoint between n_i and n_{i+1}, its left pad is near n_i+1 and right pad near n_{i+1}-1. The node n_i is at sx[n_i], pad at sx[n_i]+1 — 1u away. I'll draw m1 from node n_i (sx[n_i],0) to pad (sx[n_i]+1, 0): a 1u m1 segment. Fine.

Actually, simpler: place spine resistor RS_i with its LEFT pad at n_i and RIGHT pad at n_{i+1}. If `at` is center, I can't directly. But I can place at midpoint and accept 1u insets, then bridge with metal.

You know, let me just bridge everything with metal and not worry about exact pad inset: for each connection (pad to node), draw an m1 rectangle from the pad shape to a node point. I'll use the pad's edge closest to the node.

I'll write a helper `connect(pad, point)` that draws m1 from pad to point. And node bars.

Let me also reconsider: maybe I'm overthinking the DRC. m1 min width 0.23, min space 0.23. My wires will be ≥1u wide or at least 0.6u. Fine. Contacts: resistor pads already have contacts (PCell handles). Node-to-pad metal on m1 doesn't need contacts (same layer). 

But wait — do resistor pads r.a/r.b sit on m1 with a contact to poly? Yes, PCell handles the contact stack. Good. And my m1 node bars touching the pads: same layer m1, just abutting — fine, no DRC issue (same net, merged).

Alright. But there's a subtlety: if two different nets' m1 shapes touch, that's a short (LVS fail) and possibly DRC. I must keep different nets' m1 separated by ≥0.23u. My node bars for different nodes are at different locations; need to ensure separation. Spine nodes are 8u apart, node bars ~2u wide — fine. Tap columns offset. Should be OK.

Let me also handle the guard ring: ptap ring around everything tied to VSS. The ring has straps (m1) and a well (nwell? ptap is p-tap, so it's p+ diffusion in p-substrate... actually ptap ties substrate to VSS). The ring.straps[0] is an m1 strap. I'll port VSS on it.

But careful: the guard ring's m1 strap is on net VSS. My VSS net also connects to XRT1. They should be the same net VSS — good, no short issue (same net). But the ring surrounds the array; its m1 strap might cross other nets. The guard_ring helper handles DRC (well enclosure etc.). I'll place it around the array with space=1.0.

Now, the VSS net: XRT1 connects VSS to t. And the guard ring is VSS. And the VSS port. All same net. Good. But does VSS need to connect to anything else? In the netlist, VSS appears on XRT1 only (and it's a top pin). So VSS is just the terminator end + port + guard ring. Fine.

Wait, also every resistor has "VSS" as the 3rd terminal in the subckt call (XRT1 VSS t VSS ppolyf_u ...). The 3rd parameter is the bulk/substrate terminal of the resistor, tied to VSS. For LVS, the resistor model ppolyf_u might have a bulk terminal. In layout, the resistor's substrate/bulk — does the poly resistor PCell connect a bulk? Probably the resistor is just poly with two terminals; the "VSS" third terminal in the netlist might be the resistor's bulk which in layout connects to the substrate/tap. Hmm. For LVS to match, the extracted resistor should have 2 terminals (or 3 with bulk). 

This is a concern: the netlist resistor has 3 pins (e.g., XRT1 VSS t VSS: pins are VSS, t, and bulk=VSS). Actually subckt r2r8 has pins B0..B7 OUT VSS. The resistor instances: XRT1 VSS t VSS ppolyf_u — the first two are the resistor terminals (VSS, t), the third "VSS" might be... Actually for a resistor subcircuit instance `XRT1 VSS t VSS ppolyf_u r_width=1u r_length=6u`, the format is `Xname n1 n2 model params` typically 2 terminals. But here there are 3 names before model: "VSS t VSS". Hmm, that's 3 nodes. Maybe ppolyf_u is a 3-terminal device (with bulk)? Or the netlist writer put bulk as 3rd.

Wait, looking again: `XRT1 VSS t VSS ppolyf_u r_width=1u r_length=6u`. If ppolyf_u is a 2-terminal resistor, then it'd be `XRT1 VSS t ppolyf_u ...`. The extra "VSS" suggests a 3rd terminal (bulk) tied to VSS. Similarly all resistors have 3rd terminal VSS.

So each resistor is 3-terminal: two ends + bulk (VSS). For LVS "same devices, same W/L, same connectivity", the bulk terminal matters. In layout, the poly resistor's bulk connects to the substrate (p-substrate for an nwell-isolated? or the p+ tap). 

Hmm, this complicates. The resistor PCell `c.resistor("res_poly", ...)` — does it create a 2-terminal or 3-terminal device? For LVS, the extracted netlist must match. If the reference has resistors with bulk=VSS, my layout resistors need their bulk tied to VSS too.

The guard ring (ptap) ties the substrate to VSS. If the resistor is built in the substrate (poly over substrate/field), its bulk is the substrate, which is tied to VSS via the guard ring. So as long as the guard ring (VSS) surrounds the resistors, the resistor bulk = substrate = VSS. That should match! The netlist ties every resistor bulk to VSS, and in layout all resistors sit in the p-substrate tied to VSS by the guard ring. 

But wait, is there an nwell? For gf180mcuD poly resistor ppolyf_u — it might be in p-substrate or nwell. If the reference layout (from_spice rows style) puts resistors "inside a substrate ring when they have a bulk terminal", that suggests resistors are in a substrate ring tied to their bulk net (VSS). So I should put the resistors inside a substrate (ptap) ring tied to VSS. My guard ring does exactly that. 

But does the resistor PCell automatically connect its bulk to the surrounding substrate/tap? In extraction, the poly resistor's bulk is the underlying substrate/well. If the resistor is inside a p-tap ring (substrate tied to VSS), extraction sees bulk=VSS. Good. I think the guard ring approach handles it.

However, there's risk: the resistor PCell might draw an nwell or specific implant under it, or the extraction might see the resistor bulk differently. Without being able to test, I'll go with: resistors in substrate, surrounded by ptap guard ring tied to VSS. This matches the "rows style" description (resistors inside a substrate ring when they have a bulk terminal).

Actually, wait. Let me reconsider whether to use `from_spice` after all, since it's proven to pass LVS for these netlists. But I can't verify its output or area. The manual approach gives control. Let me proceed with manual but be careful about the resistor bulk.

Hold on, let me reconsider the resistor terminal count. Let me re-read the netlist: `.subckt r2r8 B0 B1 B2 B3 B4 B5 B6 B7 OUT VSS`. Then `XRT1 VSS t VSS ppolyf_u ...`. In SPICE, a subcircuit instance `X1 n1 n2 n3 model` — the number of nodes must match the subcircuit definition of the model. ppolyf_u is likely a 2-terminal resistor subcircuit/model. But here 3 nodes given. Unless... the netlist format from icl canvas for resistors includes the bulk as a node. 

Actually, maybe icl canvas writes resistor instances as `Xname a b bulk model`. So ppolyf_u is treated as having terminals (a, b, bulk). For LVS, netgen compares the extracted devices. If my layout resistor is extracted as a 2-terminal device but netlist expects 3-terminal, LVS fails on device count/pins.

To be safe, I should make each resistor a 3-terminal device with bulk=VSS. How? The `c.resistor` PCell — does it have a bulk terminal? Looking at the docs: `c.resistor("res_poly", w, l, at, nets=("a","b"))` — only 2 nets. So it's 2-terminal. 

Hmm. But the benchmark says from_spice rows style passes LVS on these netlists including resistors. So the rows style must handle the 3-terminal resistor somehow — perhaps by tying the resistor's substrate/bulk to VSS via the ring, and netgen's extraction of a poly resistor sees 2 terminals but the netlist's 3rd (bulk=VSS) is... 

Actually, maybe netgen LVS for a resistor: the extracted poly resistor is a 2-terminal device, and the netlist `XRT1 VSS t VSS` — netgen might treat the 3rd node as a bulk that must be connected. If extraction doesn't have a bulk terminal on the resistor, LVS would complain "device has different number of terminals".

Unless the canvas resistor extraction DOES produce a bulk terminal connected to the substrate contact. Let me not overthink: the benchmark explicitly says these netlists pass LVS with from_spice. The rows style puts resistors in a substrate ring tied to bulk net. So there must be a mechanism. 

Given uncertainty, the safest for LVS: replicate what from_spice rows does — resistors inside a substrate ring tied to VSS. My guard ring does this. If the resistor PCell's extraction picks up the substrate as bulk via the ring, great. If the resistor needs an explicit bulk contact, the ring provides the substrate tie.

Actually, I realize the resistor bulk in a poly resistor: the poly resistor is isolated from substrate by field oxide; its "bulk" terminal in SPICE might just be a pin that's expected to be connected to the substrate potential. In extraction, netgen might extract the resistor as 2-terminal and ignore bulk, OR the model card defines it. Since the reference passes, and my layout matches the reference's intent (resistors in VSS substrate ring), I'll trust it.

Let me also reconsider: maybe I should just use `from_spice("netlist.spice")` to guarantee LVS, then add a guard ring and ports. But I can't verify area or that it produces a guard ring. The area budget is 2x reference, generous. from_spice rows might produce a large but within-budget layout. But the guard ring "good practice" and identical orientation — from_spice might not give identical orientation. Not judged though.

Decision: I'll write a manual layout. It's deterministic and I can keep area small. Let me also make it robust by connecting everything explicitly on m1 where possible.

Let me now also reconsider: do I even need the resistor pads to connect via m1 node bars, or can I just place resistors abutting so poly ends touch? No — resistor terminals are the m1 pads (contacts). Adjacent resistors' poly doesn't connect; need m1 between pads.

OK let me write the final script carefully. I'll store resistors in dict `R[name] = resobj`. Each resobj has `.a` and `.b` (m1 pads). I'll create node bars and connect.

Let me define node positions and place resistors so that pads are near nodes, then connect pad↔node with m1.

To minimize uncertainty, I'll place each resistor and then connect BOTH its pads to their respective node bars with m1 rectangles. The node bar is centered on the node point. I'll make node bars large (say 2.6u x 2.6u) so they surely overlap/touch the pads (pads are within ~1u of node). But node bars for adjacent nodes (8u apart) of 2.6u — fine, separated by 5.4u. But a node bar might overlap a neighboring resistor's pad? Resistor pads are at the resistor ends near their own nodes. Node bar at n_i covers x sx[n_i]±1.3. The resistor RS_i left pad is at ~sx[n_i]+1 (inside node bar? node bar covers up to sx[n_i]+1.3, pad at sx[n_i]+1 — yes inside). Good, they connect. But also RS_{i-1} right pad at ~sx[n_i]-1 — inside node bar (covers down to sx[n_i]-1.3). Good. So node bar at n_i touches both adjacent spine resistor pads and the tap resistor pad. 

But wait, the tap resistor XRA_i is vertical at x=sx[n_i] (same as node), from y=0 to 8. Its bottom pad at y~0 (near node). Node bar at (sx[n_i], 0) covers it. Good. And XRA_i top pad at y~8 connects to x_i node. x_i node bar at (sx[n_i], 8). And XRB_i from x_i(8) to B_i(16), vertical at x=sx[n_i], bottom pad at y~8 (x_i node bar), top pad at y~16 (B_i node bar / port).

Hold on, I earlier placed tap column at x = sx[node] + TAP_XOFF (offset). Let me instead align tap columns WITH the spine node x (x = sx[n_i]) to avoid crossings, since the terminator is also at x=0 (n0). But then at n0, we have XRT2 (down), XRA0 (up), XRS0 (right) — all at x=0, node n0. Fine. And the spine rail passes through n0. No crossing issue because tap columns are at node x's and only go up from y=0 (spine level), while spine resistors are between nodes at y=0. The tap column at x=sx[n_i] goes up from y=0; the spine resistor RS_{i-1} ends at n_i (pad inset) and RS_i starts at n_i. Between them at x=sx[n_i] there's the node bar. The tap column rises from the node bar. No overlap with spine resistors (which are inset from the node). 

But the terminator at n0: XRT2 goes DOWN from n0 (y=0 to -8), XRT1 further down (-8 to -16). And XRA0 goes UP (0 to 8). Both at x=0. They meet at n0 node bar. Good, no overlap (opposite directions).

So align all tap columns at x = sx[node]. Then x range of array: spine from x=0 to x=56, resistors span x from -3 (RS0 left pad at n0-3? no). Let me recompute positions with resistors centered at midpoints:

Spine nodes n_i at x = 8*i for i=0..6, OUT at x=56. (n0=0, n1=8, ..., n6=48, OUT=56.)
RS_i between n_i (8i) and n_{i+1} (8(i+1)) for i=0..5, and RS6 between n6(48) and OUT(56). Place RS_i center at x=8i+4, y=0, orient h. Spans x 8i+1 to 8i+7. Left pad ~8i+1 (near n_i=8i, 1u away), right pad ~8i+7 (near n_{i+1}=8i+8, 1u away).
Node bar at n_i (x=8i, y=0), size 2.6x2.6: covers x 8i±1.3. Left pad of RS_i at 8i+1 is within [8i-1.3, 8i+1.3]? 8i+1 ≤ 8i+1.3 yes. Right pad of RS_{i-1} at 8(i-1)+7 = 8i-1, within [8i-1.3,...] yes. Good. So node bar touches both spine resistor pads. 

But node bar at n_i (2.6 wide) and node bar at n_{i+1} (2.6 wide, centered 8i+8): covers 8i+6.7 to 8i+9.3. RS_i right pad at 8i+7 — inside n_{i+1} bar? 8i+7 ≥ 8i+6.7 yes. And inside n_i bar? 8i+7 ≤ 8i+1.3? No. Good, so RS_i right pad connects to n_{i+1} bar, left pad to n_i bar. But wait, RS_i right pad at 8i+7: is it also within n_i bar (up to 8i+1.3)? No. Good, no short between n_i and n_{i+1}. But the poly resistor itself connects them electrically (that's intended — it's the resistor). The m1 node bars are separate islands connected only through poly. Good.

Hmm wait, but actually the resistor's two pads ARE connected through the poly resistor. So r.a (left pad) and r.b (right pad) of RS_i are electrically connected (that's the resistor). Left pad touches n_i bar, right pad touches n_{i+1} bar. So n_i and n_{i+1} are connected through RS_i. Correct! And the m1 bars n_i and n_{i+1} are NOT directly connected (separated by gap). Good.

Now terminator: XRT2 between n0(0,0) and t(0,-8): vertical at x=0, center (0,-4), orient v, spans y -7 to -1. Bottom pad ~y=-7 (t), top pad ~y=-1 (near n0=0). Node bar at n0 (0,0) covers y ±1.3, so top pad of XRT2 (y~-1) inside n0 bar. Good. t node at (0,-8): node bar at (0,-8). XRT2 bottom pad (y~-7) inside t bar (covers -9.3 to -6.7)? -7 ≥ -9.3 and ≤ -6.7 yes. XRT1 between t(0,-8) and VSS(0,-16): vertical center (0,-12), spans y -13 to -11. Top pad ~y=-11 inside t bar (covers to -6.7)? -11 < -6.7, NO. Hmm. XRT1 top pad at y~-11, t bar covers y -9.3 to -6.7. -11 is outside. Gap of 2.3u. Need to bridge.

Let me adjust: make the terminator resistors closer or node bars bigger. Let me place t at (0,-8), VSS at (0,-16). XRT2 center (0,-4) spans y -7..-1. XRT1 center (0,-12) spans y -13..-11. Gap between XRT2 bottom (y=-7) and XRT1 top (y=-11) is 4u (from -7 to -11), with t at -8. t node bar at (0,-8) size 2.6 covers y -9.3..-6.7. XRT2 bottom pad y~-7 inside t bar. XRT1 top pad y~-11: t bar covers down to -9.3, -11 is below. Not touching. 

I need XRT1 top pad to touch t bar. If XRT1 center is (0,-12) spans -13..-11, top pad at -11. t bar bottom at -9.3. Gap 1.7u. Let me make node bars bigger, or place resistors so pads are at the node. 

Alternative: place terminator resistors with pads exactly at nodes by using smaller pitch. Let me set terminator vertical pitch = 6 (resistor length) so pads abut: XRT2 from n0(0,0) to t(0,-6): center (0,-3), spans y -6..0. Bottom pad at y=-6 (t), top pad at y=0 (n0). XRT1 from t(0,-6) to VSS(0,-12): center (0,-9), spans -12..-6. Top pad y=-6 (t), bottom pad y=-12 (VSS). Now pads abut at t (y=-6) and at n0 (y=0) and VSS (y=-12). Node bars: n0 bar at (0,0) touches XRT2 top pad (y=0) — but XRT2 spans y -6..0, top pad at y=0 edge. n0 bar covers y -1.3..1.3, touches pad at y=0. Good. t node bar at (0,-6) covers -7.3..-4.7, touches XRT2 bottom (y=-6) and XRT1 top (y=-6). Good. VSS bar at (0,-12) touches XRT1 bottom (y=-12). 

But now the spine RS0 is horizontal at y=0 from x=1 to 7 (center x=4). n0 at (0,0). XRT2 vertical at x=0 from y=-6 to 0. At n0 (0,0), XRT2 top pad and RS0 left pad (x=1) and n0 bar. n0 bar at (0,0) size 2.6 covers x -1.3..1.3, y -1.3..1.3. RS0 left pad at x=1, y=0 — inside n0 bar (x≤1.3). Good. XRT2 top pad at (0,0) — inside. Good. All connect at n0 bar. 

But XRT2 vertical at x=0 spans y -6..0, width 1u (x -0.5..0.5). n0 bar covers x -1.3..1.3. They overlap (same net n0? No—XRT2 connects n0 and t; its top pad is n0, bottom pad is t). The XRT2 resistor itself connects top pad (n0) to bottom pad (t) through poly. The m1: top pad touches n0 bar (net n0), bottom pad touches t bar (net t). The poly connects them (the resistor). Good, no short. But physically the XRT2 poly strip at x=0 from y=-6 to 0, and n0 bar at (0,0) m1 — the contact at top of XRT2 is within n0 bar. Fine.

Now, does XRT2 (vertical at x=0, y -6..0) cross anything? It's at x=0, the leftmost. Spine RS0 is at y=0, x 1..7. XRT2 top is at (0,0), RS0 starts at x=1. They meet at n0 bar (x -1.3..1.3, y -1.3..1.3) which covers both. Good, junction at n0.

Now bit taps: align at x = sx[node] = 8i. XRA_i between n_i(8i, 0) and x_i(8i, 8): vertical center (8i, 4), spans y 1..7. Bottom pad y=1 (n_i), top pad y=7 (x_i). XRB_i between x_i(8i,8) and B_i(8i,16): vertical center (8i,12), spans y 9..15. Bottom pad y=9 (x_i), top pad y=15 (B_i). 
Node bars: n_i bar at (8i,0) covers y -1.3..1.3 — touches XRA_i bottom pad (y=1)? 1 ≤ 1.3 yes. Good. x_i bar at (8i,8) covers y 6.7..9.3 — touches XRA_i top (y=7) and XRB_i bottom (y=9). Good. B_i bar at (8i,16) covers y 14.7..17.3 — touches XRB_i top (y=15). Good. B_i port on B_i bar.

But wait, XRA_i vertical at x=8i spans y 1..7. The spine RS_{i-1} and RS_i are at y=0 (x ranges near 8i). XRA_i starts at y=1, spine at y=0 (height 1u, y -0.5..0.5). No overlap (gap 0.5u). Good. And XRA_i at x=8i (width x 7.5..8.5). Spine resistors RS_{i-1} (x 8i-7..8i-1) and RS_i (x 8i+1..8i+7). XRA_i x-range 7.5..8.5 overlaps RS_i left region? RS_i spans x 8i+1..8i+7. XRA_i x 7.5..8.5. Overlap x 8i+1..8i+5! But different y: RS_i at y -0.5..0.5, XRA_i at y 1..7. No y overlap. So no short. But DRC: poly over poly? They're different layers regions, no overlap in 2D. Fine. But is there a via/contact issue? No.

However, XRA_i (poly resistor vertical at x=8i, y 1..7) and the m1 node bars: n_i bar at (8i,0) m1 covers y -1.3..1.3. XRA_i bottom pad at y=1 (m1 pad) — inside n_i bar. Good. But XRA_i poly spans y 1..7 at x=8i; n_i bar m1 at y -1.3..1.3. The contact at XRA_i bottom (y~1) is within n_i bar (y≤1.3). Good.

Now crossings in m1: The node bars are m1. n_i bar at (8i,0) 2.6x2.6. Adjacent n_i and n_{i+1} bars: n_i covers x 8i±1.3, n_{i+1} covers x 8(i+1)±1.3 = 8i+8±1.3. Gap between 8i+1.3 and 8i+6.7 = 5.4u. RS_i poly between them (x 8i+1..8i+7, y -0.5..0.5). The m1 bars don't touch each other. Good. But RS_i's left pad (m1) at x~8i+1 touches n_i bar; right pad at x~8i+7 touches n_{i+1} bar. Are the pads m1 and do they overlap the bars? Left pad at x 8i+1 (within n_i bar x up to 8i+1.3) — yes overlap, same net n_i, merged. Good. Right pad 8i+7 within n_{i+1} bar (from 8i+6.7) — yes. Good.

Now, the m1 node bars at y=0 (spine) and the vertical tap resistors: no m1 in tap columns except node bars at n_i, x_i, B_i. The x_i bar at (8i,8) m1 2.6x2.6 covers y 6.7..9.3. B_i bar at (8i,16). These are separate m1 islands (different nets x_i and B_i). Separated vertically: x_i bar top y=9.3, B_i bar bottom y=14.7, gap 5.4u. XRB_i poly between (y 9..15). Good.

Now, are there any m1 crossings between different nets? The spine node bars (net n_i) at y=0, x around 8i. Tap node bars x_i (net x_i) at y=8, B_i at y=16. All at x=8i. Different nets at different y, separated. The terminator: n0 bar (net n0) at (0,0), t bar (net t) at (0,-6), VSS bar (net VSS) at (0,-12). Separated by 6u. Good.

But wait: n0 bar is at (0,0) and is net n0. XRA0 bottom pad (net n0) touches it. XRT2 top pad (net n0) touches it. Good, all net n0. t bar net t at (0,-6). VSS bar net VSS at (0,-12). 

Now the guard ring: surrounds everything. Array extent: x from -3 (RS0 left pad at x=1? actually leftmost is n0 bar x -1.3, and XRT2 at x -0.5..0.5, VSS bar x -1.3..1.3). Let me compute overall: x min = -1.3 (n0/VSS bar left), but also B ports etc. at x up to 56+1.3. Actually all x are at 8i (0..56) plus bars ±1.3, so x from -1.3 to 57.3. But resistors: RS0 spans x 1..7, etc. Leftmost m1: n0 bar x -1.3. Rightmost: OUT bar at x=56 covers 54.7..57.3, XRA7/XRB7 at x=56. So x from -1.3 to 57.3. y from -13.3 (VSS bar bottom -12-1.3) to 17.3 (B7 bar top 16+1.3). 

Guard ring with space=1.0: x0=-2.3, x1=58.3, y0=-14.3, y1=18.3. Ring width ~60.6 x 32.6 = ~1975 um². That's over the 1705 budget! Hmm.

Wait, area budget is 1705 um² for the bounding box. My array is ~58.6 x 32.6 ≈ 1910 um² just for the ring. Over budget.

I need a more compact layout. The reference is 77 x 11 = 852 um², budget 1705. My layout is 58 wide x 32 tall = too tall and the ring makes it bigger. Let me reconsider.

The reference layout is 77.04 x 11.06 — very wide and short (11u tall). So they laid it out in a single row, ~77u wide, 11u tall. My vertical taps make it 32u tall — too tall.

I need a compact single-row-ish layout. Let me reconsider: lay everything in roughly one row (height ~11-12u), width ~77u.

How? The ladder topology: spine n0-n1-...-OUT horizontally (7 resistors = 42u if 6u each, plus spacing). Bit taps: each bit needs 2 resistors (12u) but they can be arranged to not add much height if folded.

Reference is 11u tall. Resistor is 6u long x 1u wide. To fit in 11u height, resistors must be mostly horizontal (6u along x, 1u along y) with at most one vertical jog. 

Let me think of a single-row serpentine. Actually, let me reconsider the topology to lay it out in a line.

The netlist is a chain with taps. Let me lay out all resistors horizontally in a single row (y=0), each 6u long, and connect them in the ladder order using vertical jogs at the ends. But the ladder isn't a simple chain — it has branches (taps).

Alternative: Think of it as a 1D chain if we order the nodes cleverly. The graph: VSS-t-n0-n1-n2-...-n6-OUT is the main chain (9 resistors). Each n_i and OUT has a 2-resistor tap to B_i. 

If I lay the main chain horizontally: VSS(-) - t - n0 - n1 - ... - n6 - OUT, that's 9 resistors × 6u = 54u plus node spacing. Then taps branch off. To keep height low, taps could go UP from each node with 2 resistors stacked vertically (12u) — too tall. Or fold the tap: n_i --XRA(horizontal)-- x_i --XRB(vertical)-- B_i? 

Hmm. Let me think about the reference: 77 x 11. 25 resistors × 6u = 150u of resistor length, but they fit in 77u width by using both directions and sharing. Actually 11u height can fit a resistor of 6u length vertically plus some, or horizontally.

Let me reconsider: maybe lay out in 2 rows. Row 1 (y=0): some resistors horizontal. Row 2 (y=8): others. With vertical connectors at ends. Height ~ 1+6+1+spacing ≈ 10-11u. That matches 11u!

So 2 rows of horizontal resistors, height ~11u. Width: 25 resistors / 2 rows ≈ 13 per row × 6u = 78u. Matches 77u width! 

So the reference likely uses 2 rows of horizontal resistors. Let me design a 2-row layout.

I need to map the ladder onto 2 rows of horizontal resistors with vertical jogs connecting them at row ends (like a serpentine) and taps.

This is essentially a graph embedding on 2 horizontal tracks. Let me design it.

Let me define two horizontal rows: row A at y=0, row B at y=8 (or y=-8). Resistors horizontal (6u along x, 1u tall). Vertical m1 jogs at ends connect row A to row B.

But the resistors themselves connect nodes; the vertical jogs are m1 wires connecting a resistor pad on row A to a resistor pad on row B (same net? No — a vertical jog connects two points that should be the SAME net). Wait, a vertical m1 wire connects two resistor pads; if those pads are different nets, that's a short. So vertical jogs only connect pads of the same net. But in a ladder, consecutive resistors in a net... each net is just 2 resistor pads (a node connects 2-3 resistors). 

Hmm, let me reconsider. Each node (net) connects 2 or 3 resistor pads. I place those pads and short them with m1. The m1 can jog vertically between rows.

Let me think of it as: I'll place resistors in a sequence (a path through the graph) and use vertical jogs to switch rows, while branching taps.

This is getting complex. Let me think about the actual graph and find a Hamiltonian-ish path.

Graph edges (resistors):
- Chain: VSS-t, t-n0, n0-n1, n1-n2, n2-n3, n3-n4, n4-n5, n5-n6, n6-OUT (9 edges)
- Taps: n0-x0, x0-B0, n1-x1, x1-B1, ..., n6-x6, x6-B6, OUT-x7, x7-B7 (16 edges)

Total 25. 

If I traverse: Start at VSS, go t, n0, then tap n0-x0-B0 (dead end at B0, a pin), back to n0, then n1, tap n1-x1-B1, back, ... This requires revisiting nodes (branching). In layout, a node is a single m1 island connecting all incident pads — so I don't need to "return"; I just place all pads of a node on one m1 island. The branches are handled by the node island.

So layout = place resistors, connect pads of same node with m1 islands (which can jog between rows). The m1 islands for different nodes must not touch.

Let me design a 2-row placement:

Row A (y=0): place resistors horizontally. Row B (y=8): place resistors horizontally. Vertical m1 jogs connect pads across rows at the same x.

I'll assign each resistor to a row and x-position, such that:
- Resistors sharing a node have their pads connected by m1 (possibly jogging between rows).
- The m1 for a node stays within that node's net.

Let me try to lay out the main chain alternating rows to save width:

Actually, let me just place ALL resistors horizontally in a single sequence but allow the m1 node connections to jog vertically within a limited height. Since all resistors are horizontal (1u tall), I can place them at different y's (multiple rows) and connect pads with m1 jogs. The height is determined by the number of rows × (1u + spacing). With 2 rows, height ~ 1 + 6 (vertical jog) + 1 = 8u plus margins ≈ 10-11u. 

Let me use 2 rows: row0 at y=0, row1 at y=8. Resistor horizontal: 6u x 1u. Vertical jog between rows: m1 at some x, from y=0 to y=8, width ≥0.23. But a vertical jog connects two pads of the SAME net. When do two pads of the same net sit on different rows? A node connects 2-3 pads; I can put some pads on row0 and some on row1, connected by a vertical jog at the node's x.

But each resistor is horizontal and connects two nodes (its two ends). If resistor RS_i is on row0, its left pad (node n_i) and right pad (node n_{i+1}) are both on row0 at y=0. So nodes n_i and n_{i+1} each have a pad on row0. They're connected through the poly resistor (intended). The m1 for node n_i might also need to connect to other resistors (tap) which could be on row1.

OK here's a cleaner way to think: I'll place resistors and then route m1 per net. With a Router! Let me use the Router for the m1 connections. Place all resistors (horizontal, in 2 rows), then for each net, the pins are the resistor pads; Router connects them on m1/m2. But Router routes on c2/c3 with pins on c1... resistor pads are on c0=m1. Hmm, layer mismatch.

Actually, let me reconsider the layers. c0 = m1. Resistor pads on c0. I want to connect pads with m1 (c0) directly where they're on the same row, and use m2 (c1) for vertical jogs crossing, with vias c0->c1.

This is doable but intricate. Given I can't test, let me simplify drastically:

**Simplest robust approach: place all resistors horizontally in ONE row (y=0), and connect node pads with m1 on the same row, using the fact that each node's pads can be placed adjacent.** But a node's pads are at the ends of different resistors which may be far apart.

Hmm. Let me reconsider the topology for a linear layout.

Key insight: I can order the resistors so that the layout is a single meandering line, and the "taps" become branches. But branches need the node to connect 3 pads.

Let me just place resistors in 2 rows and manually route m1 with a Router-like explicit approach, but keep it small.

Actually, let me reconsider using `from_spice`. The benchmark says it passes LVS and area is 0.55-1.36x reference. For r2r8 specifically, from_spice would produce something within budget. And it handles the resistor bulk (3-terminal) correctly since it's proven. The risk is I can't see it, but it's the "recommended" path and the task even says "The same netlist is the file netlist.spice ... from_spice("netlist.spice") reads it." This strongly hints the intended solution is `from_spice("netlist.spice")`!

Let me re-read the task: "The same netlist is the file `netlist.spice` in the directory the script runs in (`from_spice("netlist.spice")` reads it)." — This is a strong hint to use from_spice.

And from the canvas doc: from_spice rows style handles resistors, places them, routes, and the benchmark references pass DRC+LVS+area on all PDKs. So `TOP = from_spice("netlist.spice")` should just work for r2r8.

But wait — from_spice rows style: "Resistors stand beside the rings (inside a substrate ring when they have a bulk terminal)". All our resistors have bulk=VSS. So they'd be inside a substrate ring tied to VSS. That's exactly the guard ring good practice! And from_spice creates ports for top pins. And it routes with a Router. This should give a clean LVS match.

The concern: area. Budget 1705, reference 852, from_spice is 0.55-1.36x reference → up to ~1158 um². Within budget. 

But does from_spice handle a netlist with ONLY resistors (no transistors)? The rows style mentions transistors and rings. With no transistors, there are no transistor strips, but resistors are still placed. Let me re-read: "The hierarchy is flattened. Fingers of one transistor ... merged ... Resistors stand beside the rings ... MIM capacitors in a grid ... One router wires the transistors and resistors". 

With no transistors, "beside the rings" — there are no rings either (rings are around transistor strips). Hmm. So where do resistors go? It's unclear. The rows style might expect at least some transistors to define rows. With a pure-resistor netlist, behavior is uncertain.

Given the hint and the benchmark, let me try from_spice first, but I can't verify. If it fails on pure-resistor, I'd need manual. Since I can't iterate, let me write a script that uses from_spice but ALSO I worry.

Actually, let me reconsider. The task says "A solution must be made per PDK" and gives netlist files. The intended solution is likely `from_spice("netlist.spice")` — 3 lines. The area budget 2x reference accommodates from_spice's baseline. LVS is guaranteed by construction (from_spice generates the reference netlist itself). DRC: from_spice uses Router and PCells which are DRC-clean (per the doc).

But the resistor bulk/3-terminal issue: from_spice rows style handles it (puts resistors in substrate ring tied to bulk). So LVS matches.

I'm now fairly convinced the intended solution is:
```python
from icdsl.canvas import *
tech = use()
TOP = from_spice("netlist.spice")
```

But let me double check from_spice signature and whether it needs the top subcircuit name. The netlist has `.subckt r2r8 ...` and `.end`. from_spice("netlist.spice") — top= defaults to the top subcircuit. Should be r2r8. 

However, I'm worried about the pure-resistor case in rows style. Let me think about whether from_spice would even place 25 resistors properly. The doc says rows style is for "everything else: several transistor sizes, resistors, MIM capacitors". So resistors are supported. "Resistors stand beside the rings" — maybe when there are no transistors, resistors form their own row. 

Actually, you know what, given the strong hint and that this is explicitly a netlist task where the doc recommends from_spice, and the benchmark validates it, I'll go with from_spice. But let me ALSO add a guard ring? from_spice rows already puts resistors in a substrate ring tied to VSS (bulk). So the ring is there. 

But wait, will from_spice create the top ports B0..B7, OUT, VSS? Yes: "Every pin of the top subcircuit becomes a port."

Let me also consider: the netlist resistor has 3 terminals (a, b, bulk=VSS). from_spice creates a resistor strip with drain bar, source bar, gate bar? No, that's for transistors. For resistors: "Resistors stand beside the rings". Each resistor becomes... a resistor PCell with 2 nets? But the netlist has 3 nets per resistor (a, b, bulk). Hmm. The resistor PCell `c.resistor("res_poly", w, l, at, nets=("a","b"))` takes 2 nets. If the netlist resistor has 3 terminals, from_spice must handle the 3rd (bulk). 

The doc says for rows: "sources at the ring's net are strapped into the ring" — that's for transistors. For resistors with bulk, "inside a substrate ring when they have a bulk terminal". So the resistor's bulk terminal connects to the substrate ring (VSS). The resistor itself is 2-terminal (a, b) physically, and bulk is the substrate. For LVS, netgen extracts the poly resistor as a 2-terminal device, but the netlist has it as 3-terminal with bulk=VSS...

This is the crux. If netgen extracts a 2-terminal resistor but netlist says 3-terminal, LVS fails. UNLESS the extraction deck extracts the resistor with a bulk terminal connected to the substrate contact/ring. 

Given the benchmark explicitly says these netlists (including r2r8 with 25 resistors) pass LVS via from_spice on all PDKs, the mechanism works. I'll trust it.

Hmm, but actually wait. Let me reconsider: maybe netgen LVS treats the resistor's bulk pin as a "don't care" or the model is 2-terminal and the 3rd net in the netlist is just... Let me look at the netlist line again: `XRT1 VSS t VSS ppolyf_u r_width=1u r_length=6u`. 

Actually, maybe the format is `Xname n1 n2 model` and there are only 2 nodes, but here we see "VSS t VSS" = 3 nodes. Unless ppolyf_u subcircuit has 3 pins. The canvas doc says device models are from PDK recipes; res_poly model ppolyf_u. 

I think icl canvas writes resistors with a bulk/substrate pin. And extraction handles it. Since the benchmark passes, I'll trust from_spice.

BUT, I'm not 10