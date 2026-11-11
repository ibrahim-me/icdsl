
For each transistor at column k (x = k*gx), row r:
- diff: x0 = x - dx_ext, x1 = x + L + dx_ext, y0 = r - tw/2, y1 = r + tw/2
- gate poly: x0 = x, x1 = x + L, y0 = r - tw/2 - gate_ext_y, y1 = r + tw/2 + gate_ext_y
  (poly crosses diff; extends above/below diff for gate contact)
- source strap (c0) on diff at left side of gate: around (x - dx_ext/2, r)
- drain strap (c0) on diff at right side of gate: around (x + L + dx_ext/2, r)

But the mos PCell creates the diff, gate, and straps automatically. Let me use c.mos and read tr.diff, tr.gates[0], tr.sd[0], tr.sd[1]. The mos places gate centered? Let me just use c.mos at (x, r) with the gate at x. The mos PCell: gate poly centered at x? Let me assume the mos places gate poly with center at the given x, and diff centered at x, sd straps on either side.

Actually I don't know exact mos PCell geometry. Let me use c.mos and then query the shapes' bboxes to route. That's robust: I place mos at (x, r), then read tr.gates[0].bbox, tr.sd[0].bbox, tr.sd[1].bbox, and route m1 to those.

So the plan:
1. Place all 22 mos at computed (x, y) positions.
2. For routing, query bboxes.

Let me set positions:
- pmos row y = row_p, nmos row y = row_n.
- x_k = k * gx for k in 0..10. For split-gate columns (2,3,7,8), offset nmos by +gx/2? That breaks alignment. 

Alternative for split gates: keep both at x_k but make two poly strips side by side within the column. The mos PCell places one gate per transistor. If I place pmos at x_k and nmos at x_k + 0.30, their gates are separate strips. Then source/drain sharing (m at k=2: both drains to m) — pmos drain (right strap) and nmos drain (right strap) are at different x, connect with m1. Fine.

But then p1 sharing: k=1 pmos drain (right strap at x_1+...) to k=2 pmos source (left strap at x_2 - ...). Horizontal m1 at row_p. Fine.

OK let me just place pmos and nmos at the same x_k for all k, and for split-gate columns accept that pmos gate and nmos gate are two separate poly strips at the same x (overlapping in x but different y rows — they don't touch since rows are separated). Wait, if both at same x_k and same L, the poly strips are at same x range but different y (row_p vs row_n). They're separate rectangles, not connected. Good — that's exactly what we want for different gate nets. And for shared gate nets, I'd want them connected — but they're at different y so the poly strips don't connect. I'd need m1 to connect the two gates. That's fine: route gate net with m1 connecting both polys.

So actually, simplest: **every transistor independent, same x_k for pmos/nmos pair, route ALL nets with m1.** No shared poly. Each gate net connected via m1 trunk contacting each gate poly. This is uniform and simple.

The only concern: poly strips of pmos and nmos at same x but different y — no DRC issue (separate). Gate poly min width 0.28 = L. Good. Poly space 0.24: adjacent columns pitch gx=0.66, poly width 0.28, space between polys = 0.66-0.28 = 0.38 > 0.24. Good. But within a column, pmos poly and nmos poly are at different y, fine.

Wait, but adjacent columns: poly at x_k (width 0.28) and poly at x_{k+1} (width 0.28), gap = gx - 0.28 = 0.38 > 0.24 space. Good. But the poly extends in y beyond diff (gate_ext_y). Adjacent column polys at different y rows might overlap in y extension? pmos poly y range around row_p, nmos around row_n. If row_p and row_n are far enough, no overlap. row_p=2.9, row_n=0.0, poly half-height = tw/2 + gate_ext_y. For pmos tw=0.72: half=0.36+0.45=0.81, y range 2.09..3.71. For nmos tw=0.36: half=0.18+0.45=0.63, y range -0.63..0.63. Gap between 0.63 and 2.09 = 1.46 um. Fine, no overlap. But poly space rule is between any two poly shapes regardless of y? Space rule applies to shapes that could overlap in projection — actually DRC space is Euclidean distance between shapes. If two poly shapes are 1.46 um apart, fine.

Hold on, but gate polys in adjacent columns at the SAME row: pmos row has 11 polys at x_0..x_10, gap 0.38 > 0.24. Good.

Now routing. Let me define m1 trunks:

**VDD rail**: horizontal m1 at y = row_p + 1.5 (above pmos row), spanning full cell width. Contact all pmos sources/drains that are VDD.
**VSS rail**: horizontal m1 at y = row_n - 1.5 (below nmos row), spanning full width. Contact all nmos sources/drains that are VSS.

Actually VDD and VSS are used in both rows. Let me run VDD rail at top (y = row_p + 1.6) and VSS rail at bottom (y = row_n - 1.6), and also connect cross-row where needed.

Let me just route net by net. For each net, collect all terminal shapes (gate polys, sd straps) and connect them with m1. I'll write a `connect_net(net, terminals)` that builds a Steiner-ish tree: sort terminals, run a horizontal trunk at a suitable y and vertical drops, or just chain them.

Given the regular structure, let me route each net specifically. Let me enumerate nets and terminals:

Terminals per transistor (gate G, source strap S, drain strap D):

k=0: pMp0_0: G=CK, S=CKB, D=VDD.   nMn0_0: G=CK, S=CKB, D=VSS.
k=1: pMp0_1: G=D,  S=VDD, D=p1.    nMn0_1: G=D,  S=VSS, D=n1.
k=2: pMp0_2: G=CK, S=p1, D=m.      nMn0_2: G=CKB,S=n1, D=m.
k=3: pMp0_3: G=CKB,S=m,  D=p2.     nMn0_3: G=CK, S=m,  D=n2.
k=4: pMp0_4: G=mb, S=VDD, D=p2.    nMn0_4: G=mb, S=n2, D=VSS.
k=5: pMp0_5: G=m,  S=VDD, D=mb.    nMn0_5: G=m,  S=VSS, D=mb.
k=6: pMp7_0: G=Q,  S=VDD, D=p3.    nMn7_0: G=Q,  S=VSS, D=n3.
k=7: pMp7_1: G=CK, S=p3, D=s.      nMn7_1: G=CKB,S=n3, D=s.
k=8: pMp7_2: G=CKB,S=s,  D=p4.     nMn7_2: G=CK, S=s,  D=n4.
k=9: pMp7_3: G=mb, S=VDD, D=p4.    nMn7_3: G=mb, S=n4, D=VSS.
k=10:pMp7_4: G=s,  S=VDD, D=Q.     nMn7_4: G=s,  S=VSS, D=Q.

Nets and their terminals:
- CK: gates k=0(p,n), k=2(p), k=3(n), k=5(p,n), k=7(p), k=8(n).  [6 gates]
- CKB: gates k=2(n), k=3(p), k=7(n), k=8(p).  [4 gates]
- D: gates k=1(p,n).  [2 gates] + D is input port
- VDD: pmos sources k=1,4,5,6,9,10 (S=VDD); pmos drains k=0 (D=VDD). nmos? none. Also VDD rail.
- VSS: nmos sources k=1,5,7,9,10 (S=VSS); nmos drains k=0 (D=VSS), k=4 (D=VSS), k=9 (D=VSS). Also VSS rail.
- CKB (net): also k=0 sources (both S=CKB). So CKB net = gates k=2(n),3(p),7(n),8(p) + sources k=0(p,n).
- p1: k=1 pmos drain, k=2 pmos source, k=2 nmos source, k=1 nmos drain? No: k=1 nmos drain = n1. Let me redo.
  p1: k=1 pMp0_1 D=p1; k=2 pMp0_2 S=p1.  (2 terminals)
- n1: k=1 nMn0_1 D=n1; k=2 nMn0_2 S=n1.  (2 terminals)
- m: k=2 pMp0_2 D=m; k=2 nMn0_2 D=m; k=3 pMp0_3 S=m; k=3 nMn0_3 S=m; k=5 pMp0_5 G=m; k=5 nMp0_5 G=m.  (6 terminals)
- p2: k=3 pMp0_3 D=p2; k=3 nMn0_3 D=n2? no n2 separate. p2: k=3 pMp0_3 D=p2; k=4 pMp0_4 D=p2.  (2 terminals)
- n2: k=3 nMn0_3 D=n2; k=4 nMn0_4 S=n2.  (2 terminals)
- mb: k=4 pMp0_4 G=mb; k=4 nMn0_4 G=mb; k=5 pMp0_5 D=mb; k=5 nMn0_5 D=mb; k=9 pMp7_3 G=mb; k=9 nMn7_3 G=mb.  (6 terminals)
- n3: k=6 nMn7_0 D=n3; k=7 nMn7_1 S=n3.  (2)
- p3: k=6 pMp7_0 D=p3; k=7 pMp7_1 S=p3.  (2)
- s: k=7 pMp7_1 D=s; k=7 nMn7_1 D=s; k=8 pMp7_2 S=s; k=8 nMn7_2 S=s; k=10 pMp7_4 G=s; k=10 nMn7_4 G=s.  (6)
- p4: k=8 pMp7_2 D=p4; k=8 nMn7_2 D=n4? no. p4: k=8 pMp7_2 D=p4; k=9 pMp7_3 D=p4.  (2)
- n4: k=8 nMn7_2 D=n4; k=9 nMn7_3 S=n4.  (2)
- Q: k=6 pMp7_0 G=Q; k=6 nMn7_0 G=Q; k=10 pMp7_4 D=Q; k=10 nMn7_4 D=Q.  (4) + Q output port.

OK. This is a lot of routing but systematic. I'll write a `connect` helper that, given a net name and a list of terminal shapes, connects them with m1 using a trunk + drops strategy:

For each net:
- Pick a trunk orientation. For gate nets (vertical polys at various x), run a horizontal m1 trunk at a dedicated y (above pmos row, stacked) and vertical drops to each gate poly. For diffusion nets, run horizontal trunks at the row y and vertical drops to straps.

Actually, let me simplify by using a generic "route net" that:
1. Computes bounding box of all terminals.
2. Picks a trunk line (horizontal at mid-y or vertical at mid-x).
3. Connects each terminal to the trunk with a vertical/horizontal m1 segment + via.

But terminals are at different rows (row_p vs row_n). A single horizontal trunk can't reach both rows without vertical segments. Let me do: for each net, run a vertical m1 "spine" at the median x spanning from row_n to row_p, and horizontal m1 branches to each terminal, with vias. That's a reasonable tree.

Hmm, but spines for many nets at different x could cross. Since each net's terminals are at specific x's, and nets are different, spines at different x won't cross if x's differ. But two nets might have terminals at similar x. Let me assign each net a unique spine x.

This is getting heavy. Let me just route each net manually with the known structure, since I enumerated it. It's deterministic.

Actually, let me step back and use a much simpler and robust routing: **route everything with the two-layer Router at the TOP level only, and inside dff use m1 with a grid of vertical/horizontal wires.** But internal dff routing still needed.

Let me reconsider: maybe I'm overengineering the dff. Let me use a simpler correct approach for dff internal routing:

For each net, I'll connect terminals by:
- A horizontal m1 wire at the row's y (row_p for pmos terminals, row_n for nmos terminals) spanning the terminals on that row.
- Vertical m1 wires connecting row_p and row_n trunks at specific x's for nets that span both rows.

Let me define, for each row, horizontal m1 trunks for the nets present on that row, stacked in y (slightly above/below the row so they don't overlap the diff/contacts). Then vertical connectors.

Ugh. OK let me just write code with a generic net router inside dff: for each net, gather terminal points (centers of gate polys and sd straps), then connect them with a Manhattan tree using m1, on a per-net dedicated "track" y to avoid crossings. I'll place horizontal trunks at distinct y levels for nets that share a row.

Given time, let me write a pragmatic `route_net` that connects terminals via a horizontal trunk at a chosen y per net (chosen from a list of available tracks) with vertical drops. For terminals on both rows, use two trunks (one per row) joined by a vertical segment.

Let me just code it and run DRC to iterate. I'll keep wires wide enough (m1w=0.3) and spaced.

Let me now also think about the top level routing, then write everything.

**Top level shreg16:**
- 16 dff instances in a row, pitch = dff width + gap.
- Each dff: ports D, CK, Q, VSS, VDD.
- Route CK: m2 horizontal bus across all dffs, drop to each CK pin via via1 (m1->m2) and m1.
- Route VDD/VSS: m2 rails (or m1) across.
- D chain: D input → FF0.D; FF_i.Q → FF_{i+1}.D. Route with m1/m2.
- Q outputs: each FF.Q is already a pin on dff; bring to top port. Route Q to top edge with m2 vertical drops? The Q pins are at the dff location. I'll bring each Q up on m2 to a horizontal trunk at top, then to port. Or just port each Q where it is (port on the m1 shape inside the placed instance). Ports can be on placed instance shapes via `top.port("Q0", on=shape_in_instance_coords)`. Actually `port` needs a shape in the top cell. For placed instances, I can get the port shape via `inst.pin("Q")` which returns the rectangle in parent coords. Then `top.port("Q0", on=that_rect)`.

Let me use the Router for top? The router routes between pins. But I have a simple structure: CK bus (one net to 16 pins), D chain (point to point), Q fanout (16 pins to ports). I could hand-route with m2.

Let me hand-route top:
- Place dffs in a row at y=0, x = i * pitch.
- Each dff has Q port on its right side? The dff Q is routed internally to some m1 shape. Let me make dff expose Q on the right edge (m1 vertical segment at right edge), D on the left edge, CK on top, VDD/VSS rails.

Hmm, let me design dff with ports on edges for easy chaining:
- D input: left edge (m1 vertical segment at x=left).
- Q output: right edge (m1 vertical segment at x=right).
- CK: top edge.
- VDD/VSS: top/bottom rails.

Then in top, chain Q(right of FF_i) to D(left of FF_{i+1}) with short m1. CK bus on m2 above. Q outputs dropped to ports.

Let me design dff so that:
- D net connects to an m1 shape at the left edge (x = cell_left), call it D_port.
- Q net connects to an m1 shape at the right edge (x = cell_right), Q_port.
- CK connects to an m1 shape at top edge.
- VDD, VSS rails span full width at top/bottom, with port shapes.

Then dff width = 11*gx + margins. Let me set cell width W_dff, height H_dff.

Let me now just write the code. I'll make dff place transistors and route, exposing:
- `dff.D_shape`: m1 rect at left edge for D.
- `dff.Q_shape`: m1 rect at right edge for Q.
- `dff.CK_shape`: m1 rect at top edge for CK.
- `dff.VDD_shape`, `dff.VSS_shape`: rail shapes.

Then top places instances and routes.

Let me write it. I'll be careful with the mos PCell and querying shapes.

One concern: `c.mos(...)` returns an object with `.diff`, `.gates`, `.sd`, etc. The `.sd[i]` are c0 straps. I need m1 to contact them. I'll place m1 over the strap with a c0->m1 via.

Let me check the via helper signature: `c.via(c0, m1, at=(x,y), net=...)`. This creates a via from c0 to m1. The cut is c0. Pads on c0 and m1. Good. For poly->m1: `c.via("poly", m1, at=(x,y), net=...)`.

But wait — does `c.via` require the cut layer to be in the conductor stack as a cut between those two? c0 is the cut for diff/poly -> m1. For poly->m1, cut is contact (c0). The via(c0, m1) should work: lower=c0? No. Let me think: via(lower_layer, upper_layer) — the cut is between them. For c0->m1: the cut layer is c0 itself (contact), lower pad on... hmm. Actually c0 IS the contact cut layer (diff|poly -> m1). So a "via" from m1 to diff/poly uses cut c0, with pad on m1 and pad on the lower layer (diff or poly).

The via helper: `c.via(c0, tech.c2, at=...)` for m1->m2 where cut=via1. So via(cut_layer, upper_layer) — cut_layer is the cut, upper_layer is the top metal, and it also pads the lower metal. For m1->m2: via(via1, m2) pads m1 and m2, cut via1.

For c0->m1 (contact to diff/poly): via(c0, m1) — cut c0, pads m1 and (diff or poly). But which lower layer? The via at (x,y) — if there's diff there, pad on diff; if poly, pad on poly. The via helper probably pads both the cut's lower layers. Let me just use `c.via(c0, m1, at=(x,y), net=net)` and it should create contact pad on m1 and on the underlying diff/poly.

Actually, I realize the mos PCell already puts c0 straps (contact pads) on the sd regions. Those are c0 rectangles (the cut) with maybe m1? No, `m.sd[i]` is "c0 strap per source/drain column" — a c0 rectangle on the diff. To connect to m1, I place m1 over it and a via(c0, m1). But the c0 strap is already the contact cut; I need m1 pad over it. The via(c0, m1) creates m1 pad + c0 cut. But there's already a c0 rectangle (the strap). Overlapping c0 rectangles — might be okay (merged) or might create duplicate. Let me instead just place m1 over the sd strap region and add a via(c0, m1) — but the strap is c0, via needs c0 cut which is the strap itself. Hmm.

Let me reconsider: maybe simpler to NOT rely on mos sd straps. Instead, place my own contacts: put m1 over the diff (source/drain regions) with c0->m1 vias. The diff region `tr.diff` is the active area. I can place m1 over the left part (source) and right part (drain) of the diff with contacts.

But the gate is in the middle of the diff; source is left of gate, drain is right. So:
- source contact: m1 over diff region left of gate, with c0->m1 via.
- drain contact: m1 over diff region right of gate.

Let me do that: for each transistor, source m1 contact at (gate_left - margin, row), drain m1 contact at (gate_right + margin, row). And gate contact: m1 over poly extension with c0->m1 via.

This avoids depending on mos sd strap geometry. I'll still use c.mos to create the devices (for LVS) and get diff/gate bboxes, then add my own m1 contacts.

Actually, even simpler for LVS: the mos PCell creates the transistor. The source/drain are the diff regions on either side of the gate. For connectivity, I just need m1 to touch those diff regions (via contact). And gate = poly touched by m1 (via contact). Good.

Let me write a helper `contact_diff(m1_rect_over_diff, net)` and `contact_poly(m1_rect_over_poly, net)`.

Let me now write the full script. I'll iterate on DRC.

Let me define concrete geometry and write it.

For gf180mcuD:
- contact size 0.22, space 0.25. m1 over contact needs enclosure m1>contact 0.005,0.06 (all sides / two opposite). So m1 pad around contact: contact 0.22, m1 pad at least 0.22+2*0.06 = 0.34 in one direction, 0.22+2*0.005 in other. Let me make m1 contact pads 0.4 x 0.4 to be safe. Actually enclosure "m1>contact 0.005,0.06" means all sides 0.005 and two opposite sides 0.06? The format "enc(outer, inner) (all sides, two opposite sides)". So m1 must extend 0.06 on two opposite sides and 0.005 on the other two? Or 0.06 all sides and 0.005 on two opposite? Ambiguous. Let me make m1 pad 0.5 x 0.5 around a 0.22 contact → extension 0.14 each side > 0.06. Safe.

- gate_contact_space=0.15: space between gate (poly) edge and contact. So a contact on diff must be 0.15 away from poly gate edge. My source/drain contacts are at gate_left - margin and gate_right + margin. The diff extends dx_ext beyond gate. Contact placed within diff but 0.15 from gate edge. Let me place source contact center at gate_left - 0.15 - 0.11 = gate_left - 0.26 (contact half-width 0.11, so contact edge at gate_left - 0.15). Good. And diff extends dx_ext=0.25 beyond gate, so contact at gate_left-0.26 is within diff (diff starts at gate_left - 0.25)? Contact center at gate_left-0.26, contact half-width 0.11 → contact left edge at gate_left-0.37, which is OUTSIDE diff (diff starts gate_left-0.25). Problem.

Let me set dx_ext larger, say 0.45, so diff extends 0.45 beyond gate. Then contact center at gate_left - 0.26, contact spans gate_left-0.37 to gate_left-0.15, all within diff (gate_left-0.45 to gate_left). And contact edge (gate_left-0.15) is exactly 0.15 from gate edge (gate_left). Good, meets gate_contact_space=0.15 (need >= 0.15). Let me use 0.16 to be safe: contact center at gate_left - 0.16 - 0.11 = gate_left - 0.27.

Hmm wait, gate_contact_space might be space between contact and gate poly. Let me keep 0.16 margin.

Also poly_endcap=0.22: poly must extend beyond contact by 0.22? That's for contact on poly. For gate contact (m1 over poly), poly_endcap means poly extends 0.22 beyond the contact. My gate poly extends gate_ext_y=0.45 beyond diff in y, and contact on poly is within the poly. Let me place gate contact on the poly extension above the diff, centered on the poly width. Poly width L=0.28 (x direction). Contact 0.22 wide centered on poly → contact spans x_c-0.11 to x_c+0.11 within poly (x to x+0.28). Need poly_endcap 0.22: poly extends 0.22 beyond contact on... the contact is on top of poly; poly_endcap is poly extending beyond the contact in the direction of the gate? Actually poly_endcap = poly extension beyond the contact (the contact is on the poly, poly must extend past the contact). For a contact on the gate poly (not at the end), this might not apply. Let me place gate contacts on the poly extension beyond the diff (the part of poly sticking out above/below the active area), where poly_endcap matters: poly must extend 0.22 beyond the contact. My gate_ext_y=0.45 gives poly extending 0.45 beyond diff edge; contact placed within that extension, with poly extending 0.22 beyond contact. Fine.

This is a lot of detail. Let me just write it with generous margins and run DRC, then fix.

Let me write the script now. I'll make it parameterized by PDK where needed but target gf180. Actually the task says solution must be made per PDK, but I'll target gf180mcuD primarily and make it portable-ish. Let me just write for gf180mcuD with tech-derived values where possible.

Let me write:

