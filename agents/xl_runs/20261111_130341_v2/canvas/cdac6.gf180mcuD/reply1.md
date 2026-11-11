I'll start by inspecting the PDK rule sheet and the capacitor PCell behavior, then build the CDAC6 layout.

```python
from icdsl.canvas import *
import math

tech = use()
print(tech.d.get("name"))
tech.describe()
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4
print("stack:", tech.stack)
print("devices:", list(tech.d["devices"].keys()))
print("cap_mim wmin:", tech.d["devices"]["cap_mim"])

# Probe the cap_mim PCell on a scratch cell to learn pad layers/sizes
pc = Cell("probe")
k = pc.capacitor("cap_mim", w=5.0, h=5.0, at=(0, 0), nets=("T", "B"))
print("cap:", k)
print("top_pad:", k.top_pad.layer, k.top_pad.bbox)
print("bottom_pad:", k.bottom_pad.layer, k.bottom_pad.bbox)
print("dielectric:", getattr(k, "dielectric", None), getattr(k, "capm", None))
for s in pc.shapes:
    print("  shape:", s.layer, s.bbox, s.net)
```

```text
name gf180mcuD
PDK gf180mcuD   grid 5 nm   (short layer names; every official layer also works)
layers: nwell=21/0  pwell=204/0  dnwell=12/0  diff=22/0  poly=30/0  nplus=32/0  pplus=31/0  sab=49/0  contact=33/0  m1=34/0  via1=35/0  m2=36/0  via2=38/0  m3=42/0  via3=40/0  m4=46/0  via4=41/0  m5=81/0  capm=75/0  cap_mk=117/5  ...
conductor stack: m1 < m2 < m3 < m4 < m5    metal(1) = m1, c0 = m1
...
min width (um): ... m4 0.28  m5 0.44 ...
min space (um): ... m4 0.28  m5 0.46 ... capm 0.6
...
cap_mim    mim  model cap_mim_2f0_m4m5_noshield  wmin=5.0
cap: <Capacitor object>
top_pad: m5 (81, 0) (-2.5, -2.5, 2.5, 2.5)
bottom_pad: m4 (46, 0) (-2.5, -2.5, 2.5, 2.5)
dielectric: capm (75, 0) (-2.5, -2.5, 2.5, 2.5)
  shape: capm (75, 0) (-2.5, -2.5, 2.5, 2.5)
  shape: m4 (46, 0) (-2.5, -2.5, 2.5, 2.5)
  shape: m5 (81, 0) (-2.5, -2.5, 2.5, 2.5)
```

The cap_mim PCell gives bottom_pad on m4 and top_pad on m5, both 5x5, plus capm dielectric. Now I'll write the full layout script:

- 8x8 array of 5x5 unit caps, pitch 5.6 (capm min space 0.6).
- Columns dedicated to bits: B5×4 cols, B4×2, B3×1, last col = B2(4)/B1(2)/B0(1)/VSS(1).
- All top plates (m5) merge into one solid TOP plane (m5 min width 0.44 — plane is huge, fine).
- Bottom plates (m4) connect via via3 to m3 column trunks; per-bit horizontal m3 collection trunks above the array; last-column units exit on m4 to the right.
- TOP pin on the plane; bit pins at right edge; VSS pin with its unit.

Let me write it.

```python
"""cdac6 - 6-bit binary-weighted capacitor array (gf180mcuD)."""
from icdsl.canvas import *

tech = use()
assert tech.d.get("name") == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0          # unit cap (cap_mim wmin=5)
PITCH = 5.6          # W + capm min space 0.6
COLS, ROWS = 8, 8

# bit assignment: 32 B5, 16 B4, 8 B3, then B2(4) B1(2) B0(1) VSS(1) in last col
col_net = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + [None]   # col 7 filled per-row below
row_net_col7 = ["B2"] * 4 + ["B1"] * 2 + ["B0"] + ["VSS"]

c = Cell("cdac6")

# --- place 64 unit capacitors ---
caps = []
for col in range(COLS):
    for row in range(ROWS):
        if col == COLS - 1:
            net = row_net_col7[row]
        else:
            net = col_net[col]
        x = col * PITCH
        y = row * PITCH
        k = c.capacitor("cap_mim", w=W, h=H, at=(x + W / 2, y + W / 2),
                        nets=("TOP", net))
        caps.append(k)

# --- TOP plane: solid m5 over the whole array (all top plates are TOP) ---
x0 = 0.0
y0 = 0.0
x1 = COLS * PITCH
y1 = ROWS * PITCH
top_plane = c.rect(c4, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

# --- bottom plate routing: m4 column trunks + via3 to m3, per-bit collection trunks ---
MW = tech.width(c3)          # m3 width 0.28
MS = tech.space(c3)          # m3 space 0.28
PAD = 0.15                   # trunk extension above array
trunk_y = y1 + PAD           # column trunks run up here to meet collection trunks

col_trunk_x = {}
for col in range(COLS - 1):          # cols 0..6 have a single bit
    net = col_net[col]
    tx = (col + 0.5) * PITCH
    col_trunk_x[col] = tx
    c.rect(c3, x0=tx - MW / 2, y0=y0, x1=tx + MW / 2, y1=trunk_y, net=net)

# collection trunks stacked above the array, one per bit
cy = y1 + PAD
for net in ("B5", "B4", "B3"):
    cols = [col for col in range(COLS - 1) if col_net[col] == net]
    xa = cols[0] * PITCH
    xb = (cols[-1] + 1) * PITCH
    c.rect(c3, x0=xa, y0=cy, x1=xb, y1=cy + MW, net=net)
    cy += MW + MS

# vias + short m3 jogs from each bottom pad to its column trunk
for col in range(COLS - 1):
    net = col_net[col]
    tx = col_trunk_x[col]
    for row in range(ROWS):
        k = caps[col * ROWS + row]
        pad = k.bottom_pad
        px = pad.cx
        c.via(c3, c4, at=(px, pad.cy), net=net)          # via3 m4<->m3? wait args
```

Wait — `c.via(c3, c4, ...)` cuts stack from c3 to c4 = via4 (m4->m5). I need via3 = m3->m4. The via helper: `c.via(lower_layer, upper_layer, ...)`. So `c.via(c3, c4)` is via4. For m3->m4 I need `c.via(c2, c3)` = via3. Let me fix: `c.via(c2, c3, at=(px, pad.cy), net=net)` — lower c2 (m3), upper c3 (m4). That's via3. Good.

Then m3 jog from via up to column trunk: via at pad center (px, row center y). Trunk at tx. Jog: m3 horizontal from (px, row_y) to (tx, row_y)? But that crosses other pads/capm in the row... The jog at row center y from px to tx passes through the row — over capm of units in between (different nets possibly!). Bad.

Better: via at the column trunk x directly? The pad is 5x5 centered at (col+0.5)*PITCH = tx. So pad center IS at tx! The column trunk runs at tx through the pad center. So place via3 at (tx, pad.cy) — it's on the pad (m4) and on the trunk (m3). The via is 0.26x0.26, pad is 5x5, trunk 0.28 — enclosure fine. No jog needed! The via connects pad to trunk directly at the trunk's x.

So: for each unit in cols 0-6, via3 at (tx, pad.cy). The m4 trunk merges with the pad anyway (same layer, same net) — actually trunk passes through pad, same net, merged. The via3 connects m4 pad/trunk to m3 trunk. Wait, trunk is m3 at tx running vertically; pad is m4 at (tx, row center). via3 at (tx, row center) connects them. But the m3 trunk and m4 pad overlap at the via location — the via cuts through. Good. Actually do I even need the via if m3 trunk and m4 pad overlap? Different layers overlapping without a via = no electrical contact. Need via. Yes, place via3 at each (tx, row center).

But hold on: m3 trunk at tx runs y 0 to trunk_y. It passes through every pad location in the column. At each, a via3 connects to the m4 pad. All same net. 

For col 7 (mixed): no trunk. Each unit: via3 at pad center connecting m4 pad to m3, then m3 horizontal jog at row y from pad x to exit x... but jog crosses capm of other units in the row? Col 7 units are at different rows; the jog is within col 7 x-range at that row — passes over that unit's own capm (same net) — fine, and over nothing else (other units in row are in cols 0-6, different x). Wait, jog from px=42 (col7 center) to exit x=44.8+ — within col 7 (39.2-44.8) at row y: only this unit's capm there. Good. Beyond x=44.8 no capm. Then pin pad at right.

But m3 jog at row y from x=42 to 47: does it cross column trunks of cols 0-6? Those are at x ≤ 36.4. No. Does it cross collection trunks at y 45.4+? Jog at row y < 44.8. No. Good. But the jog is m3, and col-7 pads are m4 — via3 connects. Then m3 jog to pin. Pin pads on m3 at right edge? Or route jog to x=47 and put pin pad there on m3.

Hmm, but actually simpler for col 7: route on m4 directly (horizontal m4 segment from pad to right-edge pin pad), no via needed. m4 segment at row y from x=42 to x=47.5, pin pad m4 at x 47-48.5. m4 segments at different rows don't cross. They don't cross m3 trunks (different layer, no via = no contact; DRC fine). They don't cross collection trunks (y<44.8). They pass over col-7 capm only at own row. 

But wait: m4 segment from x=42 to 47.5 at row y — passes over col-7's own capm (x 39.2-44.8, same unit) — same net, fine. Beyond array x>44.8 no capm. Good. And m4 is used for column trunks (cols 0-6) at x ≤ 36.4 — no overlap with col-7 segments (x≥42). Collection trunks are m3, not m4. Good.

Actually wait, I planned collection trunks on m3 and column trunks on m3. Let me redo layers: column trunks on m3 (c2), collection trunks on m3 (c2) — same layer, stacked in y, fine. Vias via3 (c2->c3 = m3->m4) at pad centers. Col-7 exit on m4 (c3) directly from pads.

Hmm, but if column trunk is m3 and pad is m4, and I place via3 at (tx, row center): via3 lower=m3 upper=m4. The via pad on m3 and m4. m3 trunk passes through. Good.

Let me also double check: does the m3 column trunk pass over capm regions? Col trunk at x=tx (col center), running y 0-46. Within array (y 0-44.8), at x=tx it passes through each unit's capm (5x5 centered at tx). capm is dielectric — m3 metal over capm without m5 plate above... wait TOP plane is m5 over everything! So m3 trunk under m5 plane with capm between? capm is only at unit positions (5x5). At unit positions, we have m4 bottom plate + capm + m5 TOP plane = a MIM capacitor between bottom plate (net B5 etc.) and TOP! That's an EXTRA capacitor not in the netlist → LVS mismatch!

Oh no. This is a real problem. The TOP m5 plane over the whole array, with m4 bottom plates and capm at each unit, forms the intended unit caps (bottom plate = unit's m4 pad, top = TOP plane). But the m3 trunk running under capm regions: m3 is below m4. Stack: m1<m2<m3<m4<m5. capm is between m4 and m5 plates (MIM m4m5). The m3 trunk is below m4. At a unit position: m5 plane (TOP), capm, m4 bottom plate (net B5), and below m4 is m3 trunk (net B5) — m3 and m4 are different layers with via3 connecting them (same net). No extra device: MIM needs m4 and m5 with capm. m3 isn't a plate of the MIM (capm is specifically between m4 and m5). So m3 trunk under the capm doesn't form a capacitor. The only MIM is m4-m5 with capm. Good — 64 unit caps only.

But wait, does the m5 TOP plane over m3 trunk (where there's no capm) form anything? No dielectric layer between m3 and m5 except interlayer dielectric (not capm), so no MIM device. capm only where drawn. Good.

Also, the m3 trunk and m4 pad: via3 connects them. The m4 pad is the bottom plate. Fine.

Another concern: m5 TOP plane is a solid rectangle 44.8x44.8. m5 min width 0.44 — fine. It covers everything. Pins: TOP port on the plane.

Now, does the m5 plane short to anything? It's the only m5 shape. Bottom plates are m4. Vias via3 are m3-m4. No m5 vias. Good.

Now LVS: netlist has 64 cap_mim devices each between TOP and a bottom net. Our layout: 64 MIMs (m4 pad + capm + m5 plane). Each m4 pad connects via via3 + m3 trunk to its bit net. The m5 plane is TOP. Extraction should see 64 caps between TOP and respective nets. 

But: m4 pads in the same column merge with the m3 trunk? No — m4 pad and m3 trunk are different layers connected by via3. The m4 pads in a column: are they connected to each other on m4? The m3 trunk is m3, not m4. The m4 pads are separate 5x5 rectangles at each row — they don't touch each other (0.6 gap). They connect via the m3 trunk + vias. Electrically all same net. Extraction: m4 pads connected through via3 to m3 trunk → same node. Good.

Wait, actually I said column trunk on m3. But earlier I considered m4 trunk. Let me finalize: column trunk on m3 (c2), via3 (c2->c3) to m4 pad. Collection trunks on m3 above array. Col-7 exits on m4.

Hold on, there's a subtlety: via3 at (tx, row center) — the m3 trunk passes through there, and the m4 pad is there. via3 connects m3 and m4. But the m4 pad also sits on top of the m3 trunk over a 0.26 area — fine.

DRC check: via3 size 0.26, space 0.26. Multiple via3s in a column at 5.6 pitch — fine. m3 enclosure of via3: 0.01 each side — trunk 0.28 wide, via 0.26 centered → 0.01 each side. Exactly at rule. OK (m3>via3 0.01,0.06 — two opposite sides 0.01, and 0.06 the other way? The rule "m3>via3 0.01,0.06" means all sides 0.01 or two opposite 0.06? enc(outer, inner) is (all sides, two opposite sides). So via needs m3 enclosure 0.01 on all sides, or 0.06 on two opposite sides. Trunk 0.28 - via 0.26 = 0.02 total → 0.01 each side on the width direction. On the length direction, trunk is long → plenty. So 0.01 all sides satisfied. Good.

m4 enclosure of via3: m4>via3 0.01,0.06. Pad 5x5, via 0.26 → plenty.

Now the m3 trunk passes through m4 pads — at the via location they contact. Elsewhere m3 trunk is under m4 pad? The trunk is m3 at x=tx (0.28 wide), pad is m4 5x5 centered at tx. So m4 pad covers the m3 trunk over the pad's full width (5x5 over 0.28 trunk). Different layers overlapping without via = no contact, DRC allows (metal over metal with interlayer dielectric). But wait — is there a rule against m3 under m4 without via? No, that's normal stacking. But the via3 at the center connects them. The rest of the overlap is just stacked metal. Fine.

Hmm, but actually there's a concern: the m3 trunk runs vertically and is covered by m4 pads at each row (5x5). Between pads (0.6 gap), the m3 trunk is exposed (just m3). Fine.

Now, the m3 trunk extends from y=0 to y=trunk_y=44.95. Above the array (y 44.8-44.95) it's just m3, no capm. Fine. It meets the collection trunk at y=45.4? trunk_y=44.95, collection trunk at y=45.4-45.68. Gap of 0.45! They don't connect. I need the column trunk to reach the collection trunk. Let me set trunk_y = y1 + PAD + MW (so trunk reaches up to touch the collection trunk). Collection trunk bottom at cy=45.4. Column trunk top should be ≥ 45.4 to touch. Set trunk_y = 45.68 (top of B5 collection trunk) — but B4 collection trunk is at 46.0, B3 at 46.6. Column trunks only need to reach their bit's collection trunk. B5 cols reach y=45.68, B4 cols reach 46.28, B3 col reaches 46.88. Different trunk_y per bit. Simpler: extend all column trunks to y=47.0 (above all collection trunks). Then each column trunk crosses all collection trunks (m3, same layer) — B5 column trunk crosses B4 collection trunk (y46.0-46.28) at x=col center (≤19.6). B4 collection trunk spans x 22.4-33.6 — doesn't reach x≤19.6. No cross. B5 trunk crosses B5 collection (connect), and B4/B3 collections are at x>22.4, not reached by B5 trunks (x≤19.6). B4 trunks (x 25.2, 30.8) cross B4 collection (connect) and B3 collection (x 33.6-39.2, not reached). B3 trunk (x 36.4) crosses B3 collection (connect). B5 trunk at x=19.6 top y=47: B3 collection at y46.6-46.88 x33.6-39.2 — no. Good. But B5 trunk extending to y=47 passes y=46.0-46.28 where B4 collection is — but B4 collection x range 22.4-33.6, B5 trunk x≤19.6 — no overlap. Good.

So set all column trunks y 0 to 47.0. Collection trunks at y 45.4 (B5), 46.0 (B4), 46.6 (B3), each height 0.28. They cross column trunks of same bit → connect. 

Then extend from collection trunks to pins on the right. Pins: let me place all bit pins on the right side at x = 44.8 + 2.0 = 46.8 onwards, stacked. Or extend collection trunks to the right edge and put pins there.

B5 collection trunk spans x 0-22.4. Extend it to x=48 (right side) at y=45.4-45.68? But it would cross B4 column trunks (x 25.2, 30.8) at y 45.4-45.68 — B4 column trunks run y 0-47, so at y 45.4 they exist at x 25.2, 30.8 → B5 trunk (m3) crossing B4 trunk (m3) = SHORT! Bad.

So collection trunks can't just extend across other bits' column trunks. Options: route collection trunks only over their own columns, then bring pins out vertically at the column's right edge on m3? Vertical m3 segment at x=22.4 (right edge of B5 cols) from y=45.68 up... no, pins need to exit the array area.

Alternative: put pins on the TOP side, above the collection trunks. Stack: collection trunks at y 45.4/46.0/46.6 (m3). Above them, vertical m3 segments at each collection trunk's right end going up to pin pads? But vertical segment at x=22.4 (B5 trunk right end) from y=45.68 up to pin at y=48 — does it cross B4/B3 collection trunks? B4 collection at y46.0-46.28 x22.4-33.6 — the vertical segment at x=22.4 touches the B4 collection trunk's left edge at x=22.4 → contact (same layer m3) → B5 shorts B4! Bad.

Hmm. The x-ranges: B5 cols 0-22.4, B4 cols 22.4-33.6, B3 col 33.6-39.2. They abut at x=22.4 and 33.6. Collection trunks span their bit's x-range including endpoints. So B5 trunk ends at x=22.4 where B4 trunk begins — they touch at the corner point (22.4, 45.4-45.68) vs (22.4, 46.0-46.28) — different y, no touch (gap 0.32). OK they don't touch. Good.

To bring pins out without crossing: run each collection trunk to the right edge of its own column group, then vertical up in the gap between groups? The gaps between groups are at x=22.4 (boundary) — no gap, groups abut.

New idea: route collection trunks horizontally but at the TOP (above array), extending each to the RIGHT beyond its group, but in the region above the array there are no column trunks above y=44.8 except the column trunks themselves which run to y=47. So a horizontal trunk at y=45.4 extending right from x=22.4 would cross B4 column trunks at x=25.2, 30.8 (they run to y=47). Short.

So instead, extend column trunks only up to their collection trunk, and route collection trunks to pins going UP then over? This is a classic routing problem. 

Simplest robust solution: put ALL pins on the right side, and route each bit's collection on a dedicated horizontal m3 trunk at a unique y, where the trunk runs from the array's right edge (x=44.8) leftward only over its own columns... but columns of different bits are interleaved in x? No — they're contiguous groups. B5: x 0-22.4. To connect B5 column trunks (at x 2.8, 8.4, 14, 19.6) to a pin at right (x>44.8), a horizontal trunk at y=45.4 from x=0 to x=48 crosses B4/B3 column trunks at x 25.2-36.4 → shorts.

Solution: route the horizontal trunk on a DIFFERENT layer than the column trunks. Column trunks on m3, collection trunks on m4? But m4 has bottom pads and col-7 exits. Collection trunk on m4 at y=45.4 (above array, no capm) running x 0-48: crosses column trunks (m3) — different layer, no via = no contact, DRC fine! Then connect collection trunk (m4) to column trunks (m3) via via3 at each column trunk location. But the collection trunk on m4 crosses m3 column trunks of OTHER bits — different layers, no contact (no via). Only where we place via3 (same bit) do they connect. 

But wait: m4 collection trunk at y=45.4-45.68 running x 0-48 — it's above the array (y>44.8), no capm. It crosses m3 column trunks (vertical, x=2.8..36.4, y 0-47) — m4 over m3, no via → no contact, OK. At B5 column trunk x positions, place via3 connecting m4 collection trunk to m3 column trunk → B5 connected. But the m4 collection trunk is net B5; it crosses B4 column trunks (net B4) — m4 over m3 without via = no electrical contact. DRC: different layers crossing is fine. 

But hold on — m4 collection trunk for B5 at y 45.4, and B4 collection trunk at y 46.0, B3 at 46.6 — all m4, stacked, different nets, no overlap (different y). Good. Each runs full width x 0-48 (or to pin). Then vias at same-bit column positions connect to column trunks.

But the m4 collection trunk crossing m3 column trunks: is there a DRC rule about m4 over m3? No, that's standard stacking. But the via3 needs m3 enclosure 0.01 — the m3 trunk is 0.28 wide, via 0.26 → OK. And m4 enclosure of via3 0.01 — collection trunk 0.28 wide → OK.

Hmm wait, but actually there's still an issue: the m4 collection trunk runs over the m3 column trunks. At the via locations they connect. But the m4 trunk is continuous metal (net B5) passing over B4's m3 trunk — no contact. Fine.

But actually, simpler: do we even need column trunks to go all the way up? Column trunk m3 from y=0 to y=44.8 (top of array), with via3 at each pad. Collection trunk m4 at y=45.4+ crossing above, with via3 at each column trunk's top (x=tx, y=45.4) connecting m3 trunk end to m4 collection trunk. The via3 at (tx, 45.5): m3 trunk ends at y=44.8 — via at y=45.5 wouldn't touch the m3 trunk! Need m3 trunk to reach the via. Extend m3 trunk from y=0 to y=47 (past all collection trunks). Then via3 at (tx, collection_cy + MW/2) connects m3 trunk to m4 collection trunk. m3 trunk at x=tx runs y 0-47, crossing all collection trunks (m4) — only connects at via locations. Good.

Wait, but m3 trunk crossing m4 collection trunk of a different bit: m3 under m4, no via, no contact. But DRC might flag... no, crossing different metal layers is normal. OK.

Actually, hold on. Let me reconsider: is it cleaner to just use m4 for column trunks too (merge with pads, no via needed for pad connection), and route collection on m3? Let me re-evaluate:

Option: column trunk on m4 (merges with bottom pads directly, no via needed at pads). Collection trunk on m3 above array. Connect via via3 at (tx, collection_y). m4 column trunk runs y 0-47 at x=tx. It passes through m4 pads (same net, merged) — fine. It crosses m3 collection trunks of other bits — m4 over m3, no via, no contact. At same-bit collection trunk, via3 connects. 

This is symmetric. Either way works. The m4 column trunk merging with pads means no via needed at each pad — fewer vias, cleaner. But m4 trunk under m5 TOP plane with capm... m4 is the bottom plate layer; the trunk IS part of the bottom plate (same net). Fine, no extra device.

I'll go with: column trunk on m4 (c3), collection trunk on m3 (c2), via3 (c2->c3) connecting at collection points. Wait via3 is m3->m4 = c2->c3. `c.via(c2, c3, at=...)`. Good.

Hmm, but actually, do I even need collection trunks on a different layer? Let me just do everything on m4 with careful x-separation, and handle col 7 separately. The problem was horizontal collection trunks crossing vertical column trunks of other bits on the same layer. With contiguous bit groups, B5 trunk (x 0-22.4) doesn't reach B4 trunks (x≥22.4). They abut at x=22.4 but different y (B5 trunk y45.4, B4 column trunks at x≥22.4 — B5 trunk ends at 22.4, B4 trunk at x=25.2 min — no overlap). Actually B4 column trunk at x=25.2 (col 4 center), B5 trunk ends at x=22.4 — gap 2.8. No cross. So same-layer works IF collection trunks only span their own group's x-range!

Then how do the collection trunks reach pins? Extend each collection trunk to the right edge of its group, then route pin connection vertically at the group's right edge... but groups abut, no gap for vertical segments without crossing neighbors' collection trunks.

Alternative: pins on the right side, each bit's pin connects via a vertical m4 segment at the group's right edge going from collection trunk y down/up to the pin y. But vertical segment at x=22.4 (B5 right edge) from y=45.68 down to... it would cross B4 collection trunk? B4 collection at y46.0-46.28 x22.4-33.6 — vertical segment at x=22.4 touches B4 collection at its left edge x=22.4 → short (same layer m4, touching at boundary). Bad.

OK the cleanest: collection trunks on m3 (different layer from column trunks on m4), full width, vias only at same-bit columns. Pins extend from collection trunks to the right edge (x=48) — collection trunk on m3 runs x 0-48 at y=45.4 (B5). It crosses m4 column trunks (vertical) — m3 over m4, no via, no contact. At B5 column positions, via3 connects. Then B5 collection trunk extends to x=48 where the B5 pin pad is. B4 collection trunk at y=46.0 runs x 0-48, pin at x=48. Etc. They're stacked in y (45.4, 46.0, 46.6), no overlap. Pins at right edge x 47-48.5, stacked by bit. 

But wait: collection trunk on m3 at y=45.4 running x 0-48 — it's above the array (y>44.8), no capm. Good. It crosses m4 column trunks (x=2.8..36.4, y 0-47) — m3 over m4, no contact. Good. At B5 column x positions, via3 (m3-m4) connects collection trunk (m3, net B5) to column trunk (m4, net B5). 

But the m4 column trunk runs y 0-47 — it crosses the B4 collection trunk (m3 at y46.0) at x=25.2 (B4 column) — m4 over m3, no via, no contact. And at x=25.2, y46.0, is there a via? Only if we place one — we place vias only at same-bit positions: B4 via at (25.2, 46.14) connecting B4 collection to B4 column. Good. B5 collection at y45.4 crosses B4 column trunk at x=25.2 — m3 over m4, no via → no contact. Good.

This works. Let me also reconsider: m4 column trunk at x=tx running y 0-47 passes through m4 pads (same net, merged) — but also, does it pass over capm? capm is at unit positions; m4 trunk is the bottom plate itself at those positions (merged with pad). The m4 trunk is 0.28 wide; pad is 5x5. They merge. The capm is over the m4 pad. MIM = m4 pad + capm + m5 plane. The m4 trunk is part of the bottom plate. Fine.

But here's a subtle LVS concern: the m4 column trunk connects all 8 pads in the column (same net) — intended. The m5 TOP plane is common. So each unit cap is between its column's bit net and TOP. Extraction: 64 caps. 

Now col 7 (mixed bits B2, B1, B0, VSS): no column trunk. Each unit's bottom pad (m4) needs to reach its bit net. Route on m4: horizontal segment from pad (x=42) to the right edge pin. But m4 segments at different rows — no cross. They cross m3 collection trunks (y 45.4+)? Segments at row y < 44.8, collections at y ≥ 45.4 — no. They cross m4 column trunks? Column trunks at x ≤ 36.4; segments at x ≥ 42 — no. They pass over col-7's own capm (same unit, same net) — fine. Beyond array x>44.8 no capm. Pin pads on m4 at right edge x 47-48.5, stacked at each row's y. 

But wait: m4 segment from x=42 to 48 at row y — passes over col-7 capm (x 39.2-44.8) at that row — same unit, same net, it's the bottom plate extension. Fine. Then x 44.8-48 no capm, to pin pad.

Hmm, but actually the m4 segment at row y from x=42 to 48: at x 42-44.8 it's over this unit's capm region — but the bottom pad is already 5x5 covering x 39.2-44.8 at this row. The segment from 42 to 44.8 merges with the pad. From 44.8 to 48 extends out. Fine.

Actually, simpler: just extend each col-7 unit's bottom pad with an m4 rectangle to the right-edge pin. Or use wire(). Let me use c.rect(m4, ...) for the segment and pin pad combined: from pad.right (44.8) to x=48.5 at the row's y, height 0.28 (m4 min width), centered on row y. Then port on it.

Wait, pad.right = 44.8 (col 7 spans 39.2-44.8, pad centered at 42, so pad x 39.5-44.5). Segment from 44.5 to 48.5. Fine.

Now pins: B5, B4, B3 pins at right edge on collection trunks (m3) at x≈48. B2, B1, B0, VSS pins at right edge on m4 segments at their row y. TOP pin on m5 plane. All pins at right side except TOP. Let me place pin pads:
- Collection trunks (m3) at y 45.4 (B5), 46.0 (B4), 46.6 (B3), each running x 0-48.5. Pin port at right end.
- Col-7 segments (m4) at row y: rows 0-3 B2 (y 2.8, 8.4, 14, 19.6), rows 4-5 B1 (25.2, 30.8), row 6 B0 (36.4), row 7 VSS (42). Segments x 44.5-48.5, height 0.28, at each row y. Pin ports on them.

But m4 segments at row y and m3 collection trunks at y 45.4+ — different layers, no issue. m4 segments at row y (≤42) and m4 column trunks (x≤36.4) — no overlap (segments x≥44.5). Good.

Wait, VSS segment at row 7 (y=42) and B3 collection trunk at y=46.6 — different y, fine. But VSS segment at y=42-42.28 (height 0.28 centered 42) — and is there anything else at y~42? B3 column trunk at x=36.4 (m4) runs full height — VSS segment at x 44.5-48.5, no overlap. Good.

Now, the m3 collection trunks run x 0-48.5 at y 45.4/46.0/46.6. They cross m4 column trunks at x=2.8..36.4 — m3 over m4 no contact. But they also cross... the m4 column trunks run y 0-47, so at y 45.4 they're present. m3 collection over them — fine. Vias at same-bit column x positions connect. 

Wait, I need vias between m3 collection trunk and m4 column trunk at each column of the bit. For B5: columns 0-3, x = 2.8, 8.4, 14, 19.6. via3 at (x, 45.54) (center of B5 collection trunk y 45.4-45.68). via3 = c.via(c2, c3) (m3->m4). m3 enclosure: collection trunk 0.28 wide, via 0.26 → 0.01 each side. OK. m4 enclosure: column trunk 0.28 wide → OK.

But hold on: via3 at (2.8, 45.54) — the m4 column trunk at x=2.8 runs y 0-47, so it's there. m3 collection trunk at y 45.4-45.68 runs x 0-48.5, so it's there. via connects them. Good.

Now, do the m4 column trunks need to extend above the array to y=47? They need to reach the collection trunks at y 45.4-46.88. So column trunks run y 0 to 47.0. Above array (44.8-47) no capm — fine. But m4 column trunk at x=2.8 running y 44.8-47 — it's under the m3 collection trunks (y 45.4/46.0/46.6) — m4 under m3, no via except at B5 via (2.8, 45.54). At y 46.0 (B4 collection), m4 trunk at x=2.8 is under m3 B4 trunk — no via → no contact. Good. But wait, B4 collection trunk runs x 0-48.5 at y 46.0 — it crosses m4 column trunk at x=2.8 (B5 net) — m3 over m4, no via → no contact. Good. And at x=2.8, y46.0, no via placed (only B5 via at y45.54). Good.

Hmm, but actually there's a problem: m4 column trunk at x=2.8 (net B5) runs y 0-47. The B4 collection trunk (m3, net B4) at y 46.0-46.28 crosses it. No via → OK. But the B5 collection trunk (m3, net B5) at y 45.4-45.68 also crosses it, with a via at (2.8, 45.54) → connect (same net, intended). Good.

Everything checks. Now also: the m4 column trunks and the m5 TOP plane — m4 under m5, no contact (different layers). capm between m4 pad and m5 at unit positions = the capacitor. The m4 trunk under m5 plane where there's no capm — just stacked metal, no device. Good.

Wait, one more: m5 TOP plane over m4 column trunks (y 44.8-47, above array) — no capm there, fine. Over the array, m5 over m4 pads with capm = caps. Good.

Now, is there any issue with m5 plane being one big rectangle and extraction seeing the TOP node as one node — yes intended. And each m4 pad is a separate bottom plate but connected via m4 trunk + vias to the bit net. Extraction sees cap between TOP (m5) and bottom plate (m4) → net TOP and bit net. 64 caps. 

But wait — will netgen extract each m4 pad + capm + m5 overlap as a separate capacitor? The m5 plane is continuous; the m4 pads are separate (0.6 gap). capm is 64 separate 5x5 rectangles. Each capm overlaps m5 plane and one m4 pad → 64 MIM caps. The m4 pads connect via trunks to bit nets. Should extract correctly.

However, there's a concern: the m4 column trunk merges with the m4 pads (same layer, touching). So all 8 pads in a column + trunk = one m4 shape (merged). capm rectangles sit on top. Extraction: the merged m4 shape is one conductor (bit net), with 8 capm rectangles over it → 8 caps between bit net and TOP. Good, that's correct (each unit is a cap).

Now LVS device count: 64 cap_mim. The netlist has XC0..XC63 = 64 caps. Good. W/L = 5u/5u. Our caps are 5x5. Good.

Pin names: TOP, B0, B1, B2, B3, VSS, B4, B5. We create ports with these names. Direction: the netlist pins are just pins; direction in subckt is unspecified. Use dir="inout" or "in". Fine.

Area: array 44.8 x 44.8. Plus routing above to y=47+0.28=47.28. Plus right extension to x=48.5. Plus pin pads. Bounding box roughly 48.5 x 47.3 = ~2294 um². Well within 10578 budget. 

Wait, that seems too small — reference is 73.6 x 71.86. Our 5x5 caps with 0.6 pitch: 8*5.6=44.8. Reference must use bigger spacing or different arrangement. Anyway, we're within budget. Good. Actually let me double check capm min space 0.6 → pitch 5.6. Yes. 44.8 array. Fine.

Hmm, but wait: is the cap_mim PCell's capm exactly w x h = 5x5? And pads 5x5? From probe: yes, all 5x5 centered at at=. Good. capm min space 0.6 between capm rectangles → pitch ≥ 5.6. We use 5.6. Good.

But also need to check: m5 TOP plane min width 0.44 — it's huge. m5 space 0.46 — only one m5 shape. Fine. m4 min width 0.28 — trunks 0.28, segments 0.28. m4 space 0.28 — column trunks at 5.6 pitch (fine), segments at different rows. m4 col trunk vs col-7 segment: col trunk x≤36.4, segment x≥44.5 — fine. m4 col trunk vs pad: merged (same net). m4 segments at different rows: row pitch 5.6, segment height 0.28 — fine.

m3 collection trunks: width 0.28, stacked at 0.56 pitch (45.4, 46.0, 46.6) — space 0.28 exactly. OK. m3 space 0.28. Good. m3 collection vs m3... only 3 collection trunks. Good.

via3: size 0.26, space 0.26. In a column, vias at 5.6 pitch — fine. At collection points, one via per column. Good.

m5 plane: no via4 needed. TOP port directly on plane.

Now, are there DRC issues with m4 column trunk passing under m5 plane? No rule. With capm min space 0.6 — capm rectangles at 5.6 pitch. Good. capm min width 5 — exactly 5. Good.

One concern: the m4 column trunk (0.28 wide) runs through the middle of each capm/pad region (x=tx = col center = pad center). The capm is 5x5 centered at tx. m4 trunk 0.28 wide centered at tx — inside the pad. Fine. But does the m4 trunk need to be covered by anything? No.

Another concern: nwell/latchup — no wells in this cap-only layout. gf180 latchup_dist=15 — that's for taps near diffs; no diffs here. Fine. No nwell needed.

Boundary layer — not needed.

Now, the "interleaved" note is "good practice, not judged" — we don't need interleaving. Column grouping is fine for LVS.

Let me also double check the via call signature: `c.via(c0, tech.c2, at=(x, y), nx=2, ny=1, net="A", dir="h")` — via stack from lower to upper. For via3 (m3->m4): `c.via(c2, c3, at=(x,y), net=net)`. c2=m3, c3=m4. Good. It returns v.lower/v.upper pads. We don't need them.

Wait, actually — does `c.via` require the cut to be between adjacent conductors? c2=m3, c3=m4 are adjacent in stack. via3 is m3->m4. Good.

Now let me also handle: the m4 column trunk and m4 pad — since both m4 and same net and touching, they merge into one shape. The via3 at (tx, row center) is within the merged shape. Fine. But I place vias at (tx, row center) for pad connection AND at (tx, collection_y) for trunk-collection connection. Two vias per unit position? No: pad vias not needed (trunk merges with pad on m4 directly). Only collection vias at (tx, collection_cy) — one per column. Wait, but then how does the pad connect to the trunk? The m4 trunk merges with the m4 pad (same layer, touching/overlapping) → directly connected, no via needed. The trunk runs vertically through all pad locations. So each pad touches the trunk → connected. 

So only vias needed: at collection points (tx, collection_y) connecting m4 column trunk to m3 collection trunk. One via per column (cols 0-6). 7 vias total. 

Hold on, but the m4 trunk and m4 pad: trunk is 0.28 wide vertical, pad is 5x5. They overlap (trunk passes through pad center). Same layer, same net → merged. Connected. 

But wait, is there a DRC issue: m4 trunk width 0.28 = min width. OK. The merged shape (trunk + 8 pads) — min area 0.1444 — fine.

Now col 7: pads don't have a trunk. Each pad isolated on m4. Connect each via m4 segment to right-edge pin. The segment merges with pad (pad.right=44.5, segment from 44.5). Same layer same net → connected. Good, no via needed.

Actually wait, pad for col 7: centered at x=42, so x 39.5-44.5. Segment x 44.5-48.5. They touch at 44.5 → merged. Good.

Let me now also reconsider: do I need the m4 column trunks at all, or could route pads via vias to m3? The m4 trunk approach is simplest. Going with it.

Now, the collection trunks on m3 run x 0-48.5. But they cross m4 column trunks — m3 over m4. Is there any DRC rule about m3 over m4 without via? No. But wait — actually, do we want the collection trunk (m3) to cross the column trunk (m4) of a different bit with NO via? That's a crossing with no contact — fine electrically and DRC-wise. But some DRC decks might have rules about... no, standard.

Hmm, but actually there's a real concern: the m3 collection trunk at y=45.4 runs x 0-48.5. The m4 column trunks run y 0-47 at x=2.8, 8.4, ..., 36.4. At the crossing (e.g., x=2.8, y=45.54) we place a via (B5). At other crossings (x=25.2, y=45.54 — B4 column trunk under B5 collection) no via → no contact. Good. But the m3 collection trunk is continuous B5 metal passing over B4's m4 trunk — fine.

Wait, but actually I realize the collection trunks should maybe not run the full width; running full width x 0-48.5 means B5 collection trunk passes over col 7 area (x 39.2-44.8) above the array — no capm there (y>44.8), fine. And over m4 column trunks of B4/B3 — fine.

OK, let me also reconsider whether to extend collection trunks all the way to x=48.5 or just to group edge + pin. Running full width is simplest and pins at right edge x=48. Port on the trunk at its right end.

But the collection trunk at x=48.5 end — port "B5" on it. The trunk ends at x=48.5, y 45.4-45.68. Port there. Good. Similarly B4 at y46.0, B3 at y46.6. Col-7 segments end at x=48.5 at their row y — ports B2, B1, B0, VSS.

Wait, multiple ports at x≈48.5 but different y — fine, they're separate pins.

Bounding box: x 0-48.5, y 0-47.28 (top of B3 collection trunk 46.6+0.28=46.88; actually B3 trunk top = 46.88; col-7 VSS segment at y=42.28 top). So y max = 46.88. x max = 48.5. Area ≈ 48.5 * 46.88 ≈ 2274 um². Well within budget. 

Hmm wait, but should I add some margin/pads for the pins to be proper ports? The port is on the shape; the shape extends to x=48.5. Fine. Maybe add a bit of right margin. Let me set pin x-end = 49.0. Bounding box ~49 x 47 = 2303. Fine.

Actually, let me reconsider pin placement: maybe nicer to have pins on the right with the port at the far right. Let me make collection trunks and segments end at x = 49.0. And add port labels.

Also TOP port: on m5 plane. Place port at center or edge. dir inout.

Let me also double-check: netlist pin order TOP B0 B1 B2 B3 VSS B4 B5. Our ports: TOP, B0..B5, VSS. Names match. LVS compares by name. Good.

Now, one more important check: the cap_mim PCell for gf180 — does it create the device with model cap_mim_2f0_m4m5_noshield and parameters w=5u l=5u? The netlist says c_width=5u c_length=5u. LVS compares devices: cap_mim with w=5, l=5. The PCell should record w and l from w=5.0, h=5.0. Good.

But wait — will netgen see the m5 plane as one plate and each m4 pad as the other, giving cap between TOP and bit net? The MIM extraction: capm region with m4 below and m5 above. Yes.

Potential issue: the m4 column trunk merges with pads, so the bottom plate conductor includes the trunk. The capm is only over the pad area (5x5), not over the trunk between pads. So 8 caps per column, each 5x5. Good.

Another potential issue: m5 plane is one rectangle; netgen extracts one capacitor per capm rectangle overlapping m5 and m4. 64 capm → 64 caps. Good.

Let me also make sure we don't accidentally create extra caps: m5 plane over m4 column trunks above array (y 44.8-47) — no capm there → no cap. m5 over m4 col-7 segments (x 44.5-49, y<44.8) — no capm → no cap. Good. capm only at 64 unit positions.

Now let me write the script carefully.

Also need `TOP = c` at end maybe, and the cell name "cdac6". The top cell variable should be named such that `check` finds it — the script's TOP variable or last cell. I'll set `TOP = c`.

Let me also verify tech names: c0=m1, c1=m2, c2=m3, c3=m4, c4=m5 for gf180. via3 = c2->c3. Good.

Let me write it:

```python
"""cdac6 - 6-bit binary-weighted capacitor array for gf180mcuD."""
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0
PITCH = 5.6
COLS, ROWS = 8, 8

col_net = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + [None]
row_net_col7 = ["B2"] * 4 + ["B1"] * 2 + ["B0"] + ["VSS"]

c = Cell("cdac6")

caps = []
for col in range(COLS):
    for row in range(ROWS):
        net = row_net_col7[row] if col == COLS - 1 else col_net[col]
        k = c.capacitor("cap_mim", w=W, h=H,
                        at=(col * PITCH + W / 2, row * PITCH + H / 2),
                        nets=("TOP", net))
        caps.append(k)

x1 = COLS * PITCH
y1 = ROWS * PITCH

# TOP plane (m5)
top_plane = c.rect(c4, x0=0, y0=0, x1=x1, y1=y1, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

MW = tech.width(c3)   # m4 width 0.28
M3W = tech.width(c2)  # m3 width 0.28

# m4 column trunks (cols 0-6), one per bit, run full height + above array
TRUNK_TOP = y1 + 3.0
col_trunk_x = {}
for col in range(COLS - 1):
    tx = (col + 0.5) * PITCH
    col_trunk_x[col] = tx
    c.rect(c3, x0=tx - MW / 2, y0=0, x1=tx + MW / 2, y1=TRUNK_TOP, net=col_net[col])

# m3 collection trunks above the array, one per bit, full width to the right pins
CY = y1 + 0.6
PIN_X = x1 + 4.0
for net in ("B5", "B4", "B3"):
    c.rect(c2, x0=0, y0=CY, x1=PIN_X, y1=CY + M3W, net=net)
    CY += M3W + tech.space(c2)

# vias via3 (m3->m4) joining each column trunk to its bit's collection trunk
for col in range(COLS - 1):
    net = col_net[col]
    tx = col_trunk_x[col]
    # find collection trunk y for this net
    ...
```

Hmm, I need to know each bit's collection trunk center y. Let me record them. B5 at CY0 = y1+0.6 = 45.4, center 45.54. B4 at 46.0, center 46.14. B3 at 46.6, center 46.74. Let me store in dict.

```python
coll_y = {}
CY = y1 + 0.6
for net in ("B5", "B4", "B3"):
    c.rect(c2, x0=0, y0=CY, x1=PIN_X, y1=CY + M3W, net=net)
    coll_y[net] = CY + M3W / 2
    CY += M3W + tech.space(c2)

for col in range(COLS - 1):
    net = col_net[col]
    c.via(c2, c3, at=(col_trunk_x[col], coll_y[net]), net=net)
```

Wait — via at (tx, coll_y[net]): the m4 column trunk is at x=tx running y 0-TRUNK_TOP. coll_y ~45.5-46.7 < TRUNK_TOP=47.8. Good, trunk is there. m3 collection trunk at that y running x 0-PIN_X — there. via connects. Good.

But hold on: the via3 at (tx, coll_y) — m3 collection trunk and m4 column trunk cross there. The via connects them (same net). But the m3 collection trunk also crosses OTHER m4 column trunks (different bits) at their x positions — no via there → no contact. Good. But wait, does the m3 collection trunk cross the m4 column trunk of the SAME bit at other y? No, collection trunk is horizontal at one y; column trunk is vertical at one x; they cross once at (tx, coll_y) — where the via is. Good.

Now col 7 exits:

```python
SEG_H = MW  # 0.28
for row in range(ROWS):
    net = row_net_col7[row]
    k = caps[COLS * ROWS - ROWS + row]  # last column, this row
    pad = k.bottom_pad
    c.rect(c3, x0=pad.right, y0=pad.cy - SEG_H / 2, x1=PIN_X, y1=pad.cy + SEG_H / 2, net=net)
```

pad.right = 44.5 (col 7 pad x 39.5-44.5). Segment x 44.5-49.0 at row y. Good.

Ports:

```python
c.port("B5", on=<B5 collection trunk>, dir="inout")
...
```

For ports, I need a shape to hang the port on. The collection trunks are rects — keep references. Let me store them.

```python
coll_shapes = {}
CY = y1 + 0.6
for net in ("B5", "B4", "B3"):
    s = c.rect(c2, x0=0, y0=CY, x1=PIN_X, y1=CY + M3W, net=net)
    coll_shapes[net] = s
    coll_y[net] = CY + M3W / 2
    CY += M3W + tech.space(c2)
```

Ports at right end: `c.port("B5", on=coll_shapes["B5"], dir="inout")` — port on the shape. The port label will be placed on the shape. Fine. Or make a small pin pad at the right end. The port on the trunk shape is fine (port becomes a label on that net).

Actually, for LVS pin recognition, netgen needs the pin name as a label on the net. `c.port` creates a label. Good.

For col-7 segments, keep references and port them:

```python
seg_shapes = {}
for row in range(ROWS):
    ...
    s = c.rect(...)
    seg_shapes[row] = s
c.port("B2", on=seg_shapes[0])  # etc.
```

But B2 has 4 units (rows 0-3) all connected by... wait, are they connected? Each row's segment is separate (different y). They're all net B2 but not connected to each other! LVS: B2 net should be one node with 4 caps. If the 4 segments aren't connected, they're 4 separate nodes all named B2 → LVS error (shorted? or multiple pins on same net not connected).

I need to connect the B2 segments together. Add a vertical m4 trunk at x=PIN_X (right edge) connecting all col-7 segments? The segments end at x=49.0. A vertical m4 trunk at x=48.5-49.0 running all rows would connect them. But it would cross... m3 collection trunks at y 45.4+? Vertical trunk at x~48.75 running y 0-44.8 — collection trunks at y 45.4+ (above), no cross. m4 column trunks at x≤36.4 — no cross. capm? x 48.5-49 is beyond array (x1=44.8), no capm. Good. So vertical m4 bus at right edge connecting all col-7 segments → all B2 segments connected, B1, B0, VSS each single. 

But wait: vertical bus at x 48.5-49.0 (width 0.5) running y 0-44.8, net = ? It connects B2, B1, B0, VSS segments — all different nets! Can't have one bus. 

Alternative: connect same-net segments. B2 rows 0-3: segments at y 2.8, 8.4, 14, 19.6. Connect them with a vertical m4 segment at x=48.5-49.0 from y=2.8 to 19.6? But it passes y=8.4, 14 where B1 segments are at different x (they end at 49.0 too!). B1 segments at rows 4-5 (y 25.2, 30.8) end at x=49.0. A vertical bus for B2 at x 48.5-49.0 from y 2.8-19.6 doesn't reach B1 segments (y 25.2+). Good, no cross. But the B2 bus at x 48.5-49.0 — do B1/B0/VSS segments cross it? They end at x=49.0 (their right edge = 49.0). The bus occupies x 48.5-49.0. B1 segment at y=25.2 x 44.5-49.0 touches the bus at x 48.5-49.0, y 25.2 — but bus only spans y 2.8-19.6. No touch. Good. But they're adjacent in x (both end at 49.0) — at y 25.2, bus not present. Fine.

Hmm, this is getting fiddly. Simpler: connect col-7 segments of the same bit with short vertical m4 jogs at x=49.0 (the common end x). Actually, since all segments end at x=49.0, I can make them all end at x=49.0 and add vertical connectors per bit between consecutive same-net segments. But bits alternate in col 7: B2,B2,B2,B2,B1,B1,B0,VSS. So B2 rows 0-3 are consecutive — one vertical bus from row0 to row3 at x=48.5-49.0 connects all 4. B1 rows 4-5 — short bus. B0 row 6 single. VSS row 7 single.

But the vertical bus for B2 at x 48.5-49.0 spanning y 2.8-19.6: it's at the same x where B1/B0/VSS segments end (x=49.0). They touch only if y overlaps — B1 at y 25.2+, no overlap. Good. But the bus right edge at 49.0 and segments right edge