I'll build the shreg16 with a custom `dff` standard cell (22 transistors matching the netlist exactly) and a top that chains 16 instances. Let me first check the PDK and look at the reference inverter example conventions.

```bash
bin/icl inspect inspect.py --pdk gf180mcuD 2>/dev/null; bin/icl check examples/canvas/inv.py --pdk gf180mcuD 2>&1 | tail -20
```
<result>
<parameter name="output>
```
bin/icl inspect inspect.py --pdk gf180mcuD 2>/dev/null; bin/icl check inv.py --pdk gf180mcuD 2>&1 | tail -20
```
</parameter>
</bash>
Let me run the inspect and a sanity check properly.
```bash
bin/icl inspect examples/canvas/inv.py --pdk gf180mcuD 2>&1 | head -60
```
<result>
<parameter name="output>
PDK gf180mcuD   grid 5 nm   (short layer names; rule sheet shown in the prompt)
...
```
</parameter>
</bash>
The rule sheet is already in the prompt. Now let me write the layout script. I'll build it carefully.

Key design:
- `dff` cell: 22 mos transistors, internal m1 routing, ports VSS VDD D CK Q.
- `shreg16` top: 16 dffs in a row, m2 CK bus + VDD/VSS rails, m1/m2 for D chain and Q fanout, ports.

Let me write the script now.

```bash
cat > /tmp/shreg16.py << 'EOF'
"""shreg16 - 16-bit shift register, 16 x dff (master-slave, 22 transistors each).
Same script targets sky130A / gf180mcuD / freepdk45."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)
L = 0.28                      # drawn gate length (all transistors)
WN = 0.36                     # nmos width
WP = 0.72                     # pmos width

# ------------------------------------------------------------------ dff cell
def build_dff(c):
    """One dff: VSS VDD Q CK D.  Transistor-level, matches gf180mcuD.spice."""
    # placement grid (um): vertical poly gates, horizontal diffusion
    gx = 0.62                 # gate (poly) pitch
    dx = 0.30                 # diffusion extension past gate each side
    row_p = 2.60              # pmos row centre (in nwell)
    row_n = 0.0               # nmos row centre
    hp = 0.55                 # half poly height beyond diff
    con = 0.22                # contact size
    m1w = 0.30                # m1 wire width

    def mosrow(kind, row, items):
        """items: list of (gate_net, src_net, drain_net, w) placed left to right."""
        xs = []
        for k, (gn, sn, dn, w) in enumerate(items):
            x = k * gx
            tr = c.mos(kind, w=w, l=L, nf=1, gates=gn, sd=(sn, dn),
                       at=(x, row), contacts=[0, 1])
            xs.append(tr)
        return xs

    # ---- transistor placement (netlist order, grouped by row for compactness)
    # pmos row (in nwell): Mp0_0..Mp0_5 then Mp7_0..Mp7_4
    p_items = [
        ("CK",  "VDD", "CKB", WP),   # Mp0_0  drain=VDD gate=CK source=CKB
        ("D",   "VDD", "p1", WP),    # Mp0_1
        ("CK",  "p1",  "m",  WP),    # Mp0_2
        ("CKB", "m",   "p2", WP),    # Mp0_3
        ("mb",  "VDD", "p2", WP),    # Mp0_4
        ("m",   "VDD", "mb", WP),    # Mp0_5
        ("Q",   "VDD", "p3", WP),    # Mp7_0
        ("CK",  "p3",  "s",  WP),    # Mp7_1
        ("CKB", "s",   "p4", WP),    # Mp7_2
        ("mb",  "VDD", "p4", WP),    # Mp7_3
        ("s",   "VDD", "Q",  WP),    # Mp7_4
    ]
    # nmos row: Mn0_0..Mn0_5 then Mn7_0..Mn7_4
    n_items = [
        ("CK",  "CKB", "VSS", WN),   # Mn0_0  drain=VSS gate=CK source=CKB
        ("D",   "VSS", "n1", WN),    # Mn0_1
        ("CKB", "n1",  "m",  WN),    # Mn0_2
        ("CK",  "m",   "n2", WN),    # Mn0_3
        ("mb",  "n2",  "VSS", WN),   # Mn0_4
        ("m",   "VSS", "mb", WN),    # Mn0_5
        ("Q",   "VSS", "n3", WN),    # Mn7_0
        ("CKB", "n3",  "s",  WN),    # Mn7_1
        ("CK",  "s",   "n4", WN),    # Mn7_2
        ("mb",  "n4",  "VSS", WN),   # Mn7_3
        ("s",   "VSS", "Q",  WN),    # Mn7_4
    ]
    Pt = mosrow("pmos", row_p, p_items)
    Nt = mosrow("nmos", row_n, n_items)

    # nwell around pmos row
    pw = len(p_items) * gx
    nwell = c.rect("nwell", x0=-0.6, x1=pw + 0.6,
                   y0=row_p - 1.6, y1=row_p + 1.6, net="VDD")
    # nwell contact (ntap) inside nwell, tied to VDD
    nt = c.tap("ntap", x0=pw * 0.5 - 0.6, y0=row_p + 0.5,
               x1=pw * 0.5 + 0.6, y1=row_p + 1.4, net="VDD")

    # ------------------------------------------------------------------ m1 routing
    def M1(net, x0, y0, x1, y1):
        return c.rect(m1, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

    def con_at(x, y, net):
        return c.via(c0, m1, at=(x, y), net=net)

    # Gate poly nets run vertically; bring each gate to m1 with a contact on poly.
    # We contact poly->m1 at the top of each gate (in the gap between rows) and route horizontally.
    # Collect gate poly rectangles per net.
    gate_poly = {}
    for tr in Pt + Nt:
        g = tr.gates[0]
        gate_poly.setdefault(g.net, []).append(g)

    # Route each gate net: vertical m1 at the gate x, contact to poly, then horizontal trunk.
    # Simpler: run a horizontal m1 trunk for each gate net above the pmos row, drop contacts to each gate.
    gate_nets = ["CK", "CKB", "D", "m", "mb", "s", "Q"]
    trunk_y = row_p + 1.95          # horizontal trunks above pmos row
    trunk_pitch = 0.42
    trunk_x = {}
    for i, gn in enumerate(gate_nets):
        trunk_x[gn] = trunk_y + i * trunk_pitch   # reuse y as x? no - use separate x positions
    # Actually route gate trunks vertically at dedicated x, then horizontal to each gate.
    # Simplest robust: one vertical m1 "gate bus" segment per gate net spanning all gate x's,
    # with a contact to each gate poly. Place bus at x = gate_x + gx/2 offset per net is messy.
    # Instead: for each gate net, run m1 horizontally at trunk_y across all gates, with a
    # vertical m1 drop + contact at each gate of that net.
    for gn in gate_nets:
        polys = gate_poly[gn]
        if not polys:
            continue
        x0 = min(p.left for p in polys) - 0.15
        x1 = max(p.right for p in polys) + 0.15
        M1(gn, x0, trunk_y - m1w/2, x1, trunk_y + m1w/2)
        for p in polys:
            # vertical drop from trunk to gate poly, contact poly
            drop = c.rect(m1, x0=p.cx - m1w/2, x1=p.cx + m1w/2,
                          y0=trunk_y + m1w/2, y1=p.top + 0.05, net=gn)
            con_at(p.cx, (trunk_y + m1w/2 + p.top) / 2, gn)

    # Diffusion (source/drain) routing: each transistor's sd straps are c0 on the diff.
    # Connect sd straps to m1 rails. We route each unique net with horizontal m1 at the row,
    # contacting each sd strap of that net on that row.
    def route_sd(row, items, trs, net_y_offset):
        # group strap contacts by net
        from collections import defaultdict
        bynet = defaultdict(list)
        for tr, (gn, sn, dn, w) in zip(trs, items):
            bynet[sn].append(tr.sd[0])
            bynet[dn].append(tr.sd[1])
        for net, straps in bynet.items():
            if net in ("VSS", "VDD"):
                continue  # rails handled separately
            ys = [s.cy for s in straps]
            y0 = min(ys) - m1w/2; y1 = max(ys) + m1w/2
            x0 = min(s.left for s in straps) - 0.15
            x1 = max(s.right for s in straps) + 0.15
            # horizontal m1 at row level spanning straps
            M1(net, x0, row - m1w/2, x1, row + m1w/2)
            for s in straps:
                con_at(s.cx, row, net)

    route_sd(row_p, p_items, Pt, 0)
    route_sd(row_n, n_items, Nt, 0)

    # VDD / VSS rails: horizontal m1 at top/bottom, contact all sd straps of that net on both rows.
    for net, row, items, trs in (("VDD", row_p, p_items, Pt), ("VSS", row_n, n_items, Nt)):
        straps = []
        for tr, (gn, sn, dn, w) in zip(trs, items):
            if sn == net:
                straps.append(tr.sd[0])
            if dn == net:
                straps.append(tr.sd[1])
        x0 = min(s.left for s in straps) - 0.2
        x1 = max(s.right for s in straps) + 0.2
        rail_y = row + (1.15 if net == "VDD" else -1.15)
        M1(net, x0, rail_y - m1w/2, x1, rail_y + m1w/2)
        for s in straps:
            # vertical drop from rail to strap
            c.rect(m1, x0=s.cx - m1w/2, x1=s.cx + m1w/2,
                   y0=min(rail_y, s.top), y1=max(rail_y, s.bottom), net=net)
            con_at(s.cx, (rail_y + s.cy) / 2, net)

    # ------------------------------------------------------------------ ports
    # D: gate net trunk
    c.port("D", on=c.rect(m1, trunk_x and 0, 0, 1, 1) if False else None)
    return

# The above is getting complicated; let me rewrite more carefully below.
print("placeholder")
EOF
echo "draft written"
```
<result>
<parameter name="output>
draft written
</parameter>
</bash>
That draft is getting messy. Let me think more carefully and write a clean, correct version. The routing approach needs to be systematic. Let me redesign.

Cleaner approach for dff routing:

I'll place transistors in two rows. For each transistor, the mos PCell gives me:
- `tr.gates[0]`: poly gate rectangle
- `tr.sd[0]`: source c0 strap, `tr.sd[1]`: drain c0 strap

I'll route with m1:
1. **Gate nets (CK, CKB, D, m, mb, s, Q)**: Each gate net connects multiple transistor gates. I'll run a horizontal m1 trunk for each gate net at a y above the pmos row, and drop vertical m1 segments with contacts to each gate poly of that net. The poly-to-m1 contact: contact on poly (c0 between poly and m1). `c.via("poly", m1, ...)` — wait, the cut between poly and m1 is "contact" (diff|poly -> m1). For poly->m1, the cut is contact too. Let me use `c.via("poly", m1, at=...)`. Actually the via helper takes (lower_layer, upper_layer). For poly->m1 it's contact cut. Let me check: `c.via(c0, tech.c2, ...)` for m1->m2. For poly->m1, lower="poly", upper=m1, cut=contact. The via_size gives pad sizes. I'll place the contact pad on the poly and extend m1 over it.

Actually, simpler: route m1 over the poly gate with a contact. The m1 wire crosses the poly; put a contact (c0) on the poly under the m1. `c.via("poly", m1, at=(x,y))` creates contact stack with pads on poly and m1.

2. **Diffusion nets**: source/drain straps are c0 on diff. Run m1 over them with c0->m1 contacts (`c.via(c0, m1, ...)`).

Let me reconsider the via helper: `c.via(c0, tech.c2, at=(x,y), nx, ny, net, dir)`. For c0->m1: `c.via(c0, m1, at=(x,y), net=...)`. The cut layer is c0 (contact), pads on c0 and m1. Good. For poly->m1: `c.via("poly", m1, at=(x,y), net=...)`. Cut = contact. Good.

Let me also reconsider: do I even need separate trunks per gate net, or can I route more directly? Given 7 gate nets and 11 gates per row, trunks are fine.

Let me also handle: the mos PCell already places c0 straps on sd. Those straps are on the diff. I run m1 over them with c0->m1 vias. Good.

But there's a subtlety: the mos PCell's sd straps — are they sized/positioned such that m1 can contact them? The strap is a c0 pad on the diff. m1 over it with a via works.

Let me also reconsider gate contact: poly min width 0.18, we use L=0.28. poly_endcap=0.22 (poly extends beyond contact?). gate_contact_space=0.15 (space between gate and contact... actually that's for contact to gate). Let me just place contacts on poly away from gate edges appropriately. The via on poly needs enclosure poly>contact 0.07. So contact pad on poly must be fully inside poly with 0.07 margin. Poly gate is 0.28 wide (x direction) and tall (y direction, = w + extensions). I'll contact the poly at its top end (above the row) where the poly extends up (gate_ext). Let me make the poly tall enough.

Actually the mos PCell handles gate extension. The gate poly `tr.gates[0]` extends beyond the diff. I'll contact near the top of the poly.

This is getting complicated. Let me simplify the whole dff layout: instead of routing gate nets with trunks, I'll route each gate net as follows — but the nets m, mb, s are internal and only connect 2-3 transistors. CK connects many (inverter + pass gates). 

Let me just do it systematically with trunks. Let me rewrite cleanly.

Actually, let me reconsider the entire approach to reduce risk. Given LVS must match exactly and DRC must be clean, and area budget is generous (2x), let me make a **very regular, easy-to-verify** layout:

**dff cell structure:**
- Place all 22 transistors in a single column? No, too tall.
- Two rows: pmos top, nmos bottom. Each row has 11 transistors side by side.
- Gate pitch 0.62 um → row width = 11*0.62 = 6.82 um. Cell width ~8 um.
- Row height: pmos row and nmos row separated. Each transistor w (vertical) = 0.36 or 0.72. With gate extending beyond. Row pitch ~2.6 um. Two rows + rails → cell height ~9 um.
- Cell ~8 x 9 = 72 um². 16 in a row = 128 x 9 = 1152 um². Well within budget.

Routing: m1 for everything inside dff. VDD/VSS as horizontal m1 rails spanning the cell width at top and bottom. Internal nets as vertical m1 segments at each transistor x, connecting gate/drain/source as needed, plus horizontal segments.

Hmm, but each transistor needs 3 connections (gate, source, drain) and they're at the same x. That's 3 vertical wires per transistor = too many.

Let me think about which nets connect where and share x:

At each transistor position x_k, we have one pmos and one nmos (aligned vertically). Their gates may be different nets. 

Let me list per position k (0..10), the pmos (gate,src,drain) and nmos (gate,src,drain):

k=0:  pMp0_0 (G=CK, S=CKB, D=VDD)   nMn0_0 (G=CK, S=CKB, D=VSS)
      Both gates = CK. Sources: pmos S=CKB, nmos S=CKB → both source to CKB! Drains: pmos D=VDD, nmos D=VSS.
      So at k=0: gate CK (shared), both sources connect to CKB, pmos drain to VDD, nmos drain to VSS.
      This is the CKB inverter: output CKB = common source node, inputs gate=CK, pulled to VDD (pmos) and VSS (nmos). 

k=1:  pMp0_1 (G=D, S=VDD, D=p1)    nMn0_1 (G=D, S=VSS, D=n1)
      Gates both = D. pmos source VDD drain p1; nmos source VSS drain n1. p1 and n1 are separate nodes.

k=2:  pMp0_2 (G=CK, S=p1, D=m)     nMn0_2 (G=CKB, S=n1, D=m)
      Both drains = m (common). pmos gate CK source p1; nmos gate CKB source n1.

k=3:  pMp0_3 (G=CKB, S=m, D=p2)    nMn0_3 (G=CK, S=m, D=n2)
      Both sources = m (common). pmos gate CKB drain p2; nmos gate CK drain n2.

k=4:  pMp0_4 (G=mb, S=VDD, D=p2)   nMn0_4 (G=mb, S=n2, D=VSS)
      Gates both = mb. pmos source VDD drain p2; nmos source n2 drain VSS.

k=5:  pMp0_5 (G=m, S=VDD, D=mb)    nMn0_5 (G=m, S=VSS, D=mb)
      Gates both = m. Both drains = mb (common). pmos source VDD, nmos source VSS.
      This is mb = ~m inverter: output mb = common drain, input gate=m.

k=6:  pMp7_0 (G=Q, S=VDD, D=p3)    nMn7_0 (G=Q, S=VSS, D=n3)
      Gates both = Q. pmos source VDD drain p3; nmos source VSS drain n3.

k=7:  pMp7_1 (G=CK, S=p3, D=s)     nMn7_1 (G=CKB, S=n3, D=s)
      Both drains = s (common).

k=8:  pMp7_2 (G=CKB, S=s, D=p4)    nMn7_2 (G=CK, S=s, D=n4)
      Both sources = s (common).

k=9:  pMp7_3 (G=mb, S=VDD, D=p4)   nMn7_3 (G=mb, S=n4, D=VSS)
      Gates both = mb.

k=10: pMp7_4 (G=s, S=VDD, D=Q)     nMn7_4 (G=s, S=VSS, D=Q)
      Gates both = s. Both drains = Q (common). Q output.

Great, this is very regular! At each position k, the pmos and nmos share the same gate net, and often share source or drain. This is a classic complementary pair layout.

So at each x position k, I can place pmos and nmos with aligned gates (single poly strip crossing both diffusions = one transistor each but shared gate line). The gate poly runs vertically through both rows at x_k.

Connections per position:
- Gate net G_k: vertical poly at x_k, connects both transistors' gates.
- A "source/drain bus" vertical m1 at x_k connecting the shared terminals.

Let me define for each position the vertical m1 connections needed:

k=0 (CK inverter): gate=CK. Common source node CKB connects both sources. pmos drain→VDD, nmos drain→VSS.
   So: vertical poly CK at x_0. Vertical m1 for CKB connecting both sources (between the two rows). pmos drain to VDD rail, nmos drain to VSS rail.

k=1 (D input stage): gate=D. pmos: source VDD, drain p1. nmos: source VSS, drain n1.
   p1 and n1 separate. pmos drain p1 → connects to k=2 pmos source. nmos drain n1 → connects to k=2 nmos source.

k=2: gate pmos=CK, gate nmos=CKB. Different gates! So can't share a single poly. Hmm.
   pMp0_2 gate=CK, nMn0_2 gate=CKB. So at position 2, pmos and nmos have different gates.
   Common drain m. pmos source p1 (from k=1), nmos source n1 (from k=1).

This breaks the simple shared-gate idea at k=2, k=3 (pmos gate CKB, nmos gate CK — different), k=7 (CK/CKB), k=8 (CKB/CK).

So positions 2,3,7,8 have split gates. That's fine — two separate poly strips at those x positions, slightly offset, or two adjacent gate columns.

Let me restructure: use a gate pitch where each transistor gets its own gate column, but align pmos/nmos where gates match.

Actually, simpler: give every transistor its own vertical gate column (pitch gx), 22 columns total, arranged pmos row and nmos row with the same x for corresponding transistors but gates may differ. Then route source/drain with horizontal m1 in each row and vertical connectors.

Hmm, this is getting complicated but let me just commit to a clear scheme:

**Scheme: per-transistor vertical gate, horizontal diffusion rows, m1 routing.**

- 11 columns (x_0..x_10), pitch gx=0.7 um.
- At each column, pmos (top row) and nmos (bottom row). Each has its own gate poly. Where pmos and nmos gates are the same net (k=0,1,4,5,6,9,10), I can use one poly strip crossing both diffusions (shared gate). Where different (k=2,3,7,8), two separate poly strips — but they'd be at the same x, overlapping. I need to offset them: pmos gate at x_k, nmos gate at x_k + 0.35 (half pitch). That complicates column alignment.

Alternative: don't share. Give each transistor its own gate column. 22 gate columns. But pmos and nmos rows are at different y, so gates at same x but different y are separate poly rectangles (not connected) — that's fine, they're different nets possibly. I can route each gate individually with m1.

Let me just do: 22 transistors, each with independent gate poly at its own (x, row). Place them in a grid: 11 columns x 2 rows. Gate of each transistor is a vertical poly strip at column x_k, spanning just its row (plus extension). Then route each gate net with m1: connect all gate polys of the same net with m1 wires.

But routing 22 individual gates with m1 requires many vias and wires. Doable but let me minimize.

Actually, the cleanest: since pmos and nmos at the same column often share gate net, place them so their gates align (same x) when same net, and route that net as one vertical poly + m1 trunk. For the 4 split columns, use two adjacent sub-columns.

Let me define columns with possible split:
- col 0: gate CK (shared) — x_0
- col 1: gate D (shared) — x_1
- col 2: pmos gate CK, nmos gate CKB — split: pmos at x_2, nmos at x_2 + sg (sg = 0.34)
- col 3: pmos gate CKB, nmos gate CK — split
- col 4: gate mb (shared)
- col 5: gate m (shared)
- col 6: gate Q (shared)
- col 7: pmos CK, nmos CKB — split
- col 8: pmos CKB, nmos CK — split
- col 9: gate mb (shared)
- col 10: gate s (shared)

This is workable but the x positions get irregular for source/drain sharing (p1 connects k=1 pmos drain to k=2 pmos source; if k=2 pmos is at x_2 and k=1 at x_1, p1 is a horizontal m1 between them at the pmos row — fine).

OK you know what, I'm overcomplicating. Let me just place each transistor independently with explicit x, y and route nets with m1 point-to-point using the router-like manual approach. I'll write a helper to connect a net to a list of (shape) terminals with m1.

Given the area budget is huge, I can use a "vertical m1 per terminal" approach: for each transistor, run m1 vertically from its gate, source, drain straps to horizontal trunks.

Let me just go with a clean implementation and iterate on DRC. Let me write it now, carefully, and test.

Let me define the dff with these concrete coordinates:

```
gx = 0.66          # column pitch
row_p = 2.9        # pmos diffusion centre y
row_n = 0.0        # nmos diffusion centre y
tw_p = 0.72        # pmos diffusion width (vertical)
tw_n = 0.36        # nmos diffusion width (vertical)
L = 0.28           # gate length (poly width, x direction)
gate_ext_y = 0.45  # poly extension beyond diff (y direction) for contacting
dx_ext = 0.25      # diffusion extension beyond gate (x direction) each side
```

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

```python
from icdsl.canvas import *
from icdsl.canvas.route import Router
from collections import defaultdict

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# Design rules (um) for gf180mcuD; derive from tech where possible
CONTACT = 0.22
CONTACT_SPACE = 0.25
M1W = 0.30
M1_SPACE = 0.23
POLY = 0.28          # gate length L
POLY_SPACE = 0.24
GATE_CONTACT_SPACE = 0.16
POLY_ENDCAP = 0.22
DIFF_EXT = 0.50      # diffusion extension past gate
GATE_EXT_Y = 0.60    # poly extension past diff (y) for gate contact
GX = 0.70            # column pitch
ROW_P = 3.0
ROW_N = 0.0
TW_P = 0.72
TW_N = 0.36
```

Hmm, let me derive some from tech: tech.width("poly"), tech.space("poly"), tech.width("m1"), etc. Let me use those.

Let me write the full script now and test.

For the mos placement, I need to know: does c.mos center the gate at the given `at`? Let me assume `at=(x,y)` places the transistor centered there (gate center at x, diff center at y). I'll verify by querying bboxes and adjusting routing to actual shapes (robust).

Let me write a robust router inside dff: for each net, I have terminal shapes (gate polys and diff regions for source/drain). I'll create m1 contact pads over each terminal and connect with m1.

Actually, let me simplify routing by connecting each net with a "trunk per row + vertical links":

I'll precompute for each transistor the x of its gate (gx_center) and the source/drain contact points.

Let me just place transistors and then for each net, collect (shape, type) terminals and call a generic `net_connect(net, terminals)` that builds a tree:
- Sort terminals by x.
- Run a horizontal m1 trunk at y = trunk_y (net-specific) from min x to max x.
- For each terminal, run vertical m1 from trunk to the terminal, with via.

But terminals at row_p and row_n have different y. A horizontal trunk at one y can't reach both. So: two trunks (one at row_p area, one at row_n area) + vertical link at one x.

Let me implement net_connect(net, p_terminals, n_terminals) where p_terminals are on row_p, n_terminals on row_n:
- trunk_p at y = row_p + trunk_offset_p (a unique y per net above the pmos diff)
- trunk_n at y = row_n - trunk_offset_n
- vertical link at x = median x connecting trunk_p and trunk_n (spanning rows)
- vertical drops from each trunk to each terminal.

But trunks for different nets at different y — need to stack them without overlap. There are ~14 nets. Stacking 14 trunks above pmos row: row_p=3.0, pmos diff top = 3.0+0.36=3.36. Trunks from 3.5 upward. Each trunk m1w=0.3 + space 0.23 = 0.53 pitch. 14 trunks = 7.4 um. That's a lot but OK (cell height grows). Alternatively route some nets below nmos row.

This is getting too tall. Let me reduce: route gate nets above pmos row, diffusion nets... hmm.

Alternative: Use m2 for some internal routing? m2 is available. But let me keep dff single-metal (m1) for simplicity and accept a taller cell. Area budget is generous.

Actually, let me reconsider the cell height. If I stack 14 trunks above pmos row at 0.53 pitch = 7.4 um, plus pmos row (3.36 top) → trunks up to ~10.8, plus nmos row below (0 to -0.63) and VSS rail below. Cell height ~12 um. Width = 11*0.70 + margins = 8 um. Cell = 8 x 12 = 96 um². 16 in a row = 128 x 12 = 1536 um². Within 3299. Fine.

But stacking trunks and crossing vertical drops — vertical drops from trunks to terminals at row_p cross other trunks? No, drops are vertical at terminal x, going from trunk down to row_p. They cross intermediate trunks! That's a problem (different nets crossing on same layer m1).

To avoid crossings, I should use m2 for crossings, or route drops before trunks... This is the classic problem.

Better approach: route each net entirely with vertical segments at the terminal x's and a single horizontal trunk, but order trunks so drops don't cross other trunks. Drops cross trunks that are between the trunk and the terminal. If trunk is the closest to the terminal row, drops don't cross other trunks. So: place each net's trunk immediately adjacent to the row it serves, and drops go straight from trunk to terminal (short, no crossing). For nets serving both rows, need a trunk near each row + vertical link; the vertical link crosses trunks between rows — but between row_n and row_p there's a gap (0.63 to 2.09 = 1.46 um) with no trunks if I keep trunks adjacent to rows. So vertical link in the gap is clean.

So plan:
- Above pmos row (y > 3.36): trunks for nets that have pmos terminals, stacked immediately above row. Drops go down from trunk to pmos terminals (short, within pmos row area, no crossing since trunk is right above).
- Below nmos row (y < -0.63): trunks for nets with nmos terminals, stacked below. Drops go up to nmos terminals.
- For nets with terminals on both rows: trunk_p above pmos, trunk_n below nmos, connected by vertical m1 at some x through the gap (clean). But the vertical link from trunk_p down to trunk_n passes through pmos row area (where pmos terminals/drops are) and nmos area. It would cross pmos trunk drops. Hmm.

To avoid, for nets spanning both rows, route the vertical link at an x where there's no pmos/nmos terminal drop in the way — but every x has transistors. 

Alternative: route spanning nets on m2! Use m2 for the vertical link between rows, with vias to m1 trunks. m2 over m1 with via1. That's clean: m2 vertical segment in the gap, via1 down to m1 trunk_p and trunk_n. m2 doesn't cross m1 drops (different layer). 

But m2 width/space: m2 min width 0.28, space 0.28. Fine.

OK this is workable but complex. Let me simplify by NOT splitting rows: route ALL nets with trunks above the pmos row only, and for nmos terminals, run vertical m1 from the trunk down through the pmos row? No, crosses.

Hmm. Let me reconsider: maybe place ALL transistors in ONE row (single diffusion row), mixing pmos and nmos, with nwell only under pmos. Then all terminals on one row, single set of trunks above, no cross-row routing. But pmos need nwell and nmos don't; mixing in one row with nwell under some is fine (nwell is a separate layer, can be under pmos only). Diffusion row: all transistors side by side, pitch gx. pmos and nmos interleaved. nwell rectangle under pmos transistors only.

Single row: 22 transistors, width = 22*gx = 15.4 um. Height = one row + trunks. All terminals on one row (y=row). Trunks above row, drops down. No cross-row. Much simpler!

But nwell: pmos transistors need nwell around them. nwell min width 0.86, space 0.6. I'll put one nwell spanning all pmos transistors (they're not contiguous if interleaved with nmos — nwell would cover nmos too, which is wrong; nmos in nwell would be broken). So pmos must be grouped in nwell, nmos outside. If interleaved, nwell can't cover just pmos. So group pmos together and nmos together → two rows again, OR put all pmos in a contiguous block with nwell and all nmos in another block.

Two blocks side by side horizontally: pmos block (with nwell) and nmos block. Each block is a row of transistors. Then it's like two rows but side by side. Terminals: pmos block terminals at y=row_p, nmos block at y=row_n (same y actually if same row height). Let me put both blocks on the SAME row y (row=0), pmos block on left (x in nwell), nmos block on right. Then all terminals on one row y=0! Trunks above, drops down. Single row of trunks. 

But pmos and nmos at same y, different x blocks. nwell covers pmos block. Good. Diffusion: pmos diff width 0.72, nmos 0.36 — different widths but same row y, different heights. That's fine (diff rectangles different heights, same center y). Actually diffusion height = transistor width (vertical). pmos 0.72 tall, nmos 0.36 tall, both centered at y=0. They're at different x so no overlap. Fine.

So: single diffusion row y=0. pmos block: 11 transistors at x = 0, gx, 2*gx, ... (within nwell). nmos block: 11 transistors at x = pmos_block_end + gap, ... . All gates vertical poly at each transistor x, crossing the diff at y=0.

Wait, but then gate polys for pmos and nmos are all vertical strips at various x, all crossing y=0. Adjacent polys gap = gx - POLY = 0.70-0.28 = 0.42 > 0.24. Good.

All terminals (gate polys, source/drain diffs) on/near y=0. Route with m1 trunks above (y>0) and drops down. Single set of trunks, no cross-row. 

But source/drain of a transistor: diff is horizontal (x direction) at y=0, width = transistor width (vertical, y direction)? No wait. Let me re-set orientation.

Let me define: gate length L = poly width in x direction. Channel width W = diffusion width in y direction. Transistor: diff rectangle = (x: gate_left-ext to gate_right+ext) × (y: -W/2 to W/2). Gate poly = (x: gate_left to gate_right) × (y: -W/2-ext to W/2+ext). So poly is a vertical strip (tall in y), diff is a horizontal strip (wide in x)? No: diff x-range is narrow (around gate, width L+2ext), y-range is W (transistor width). So diff is a vertical rectangle (tall in y, narrow in x)! And poly is also vertical (tall in y, width L in x). They overlap in x (gate over diff) forming the transistor.

Hmm, that means diffusion is vertical (narrow x, tall y), and source/drain are the top and bottom ends of the diff (in y). Source contact at top of diff, drain at bottom.

Let me redo: 
- diff: x0 = gx_center - (L+2*DIFF_EXT)/2, x1 = gx_center + (L+2*DIFF_EXT)/2 (narrow in x), y0 = -W/2, y1 = W/2 (tall in y = transistor width).
- gate poly: x