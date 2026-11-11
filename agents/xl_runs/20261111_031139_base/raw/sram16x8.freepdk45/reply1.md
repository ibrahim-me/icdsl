I'll build a 16×8 6T SRAM array for freepdk45. Let me first verify the PDK layer numbers and design rules, then write the layout script.

Key design decisions:
- **Cell orientation**: word lines (WL) run horizontally (x) as poly strips; bit lines (BL/BLB) run vertically (y) in metal2, contacting cell diffusion through metal1 landing pads.
- **Cell**: shared-diffusion 6T — left diffusion strip hosts access + pulldown NMOS sharing node Q; right strip hosts access + pulldown sharing QB; PMOS pull-ups in nwell above; Q/QB/VDD/VSS straps in metal1.
- **Pitch**: cell ≈ 1.66 × 2.46 um → array ≈ 13.3 × 39.4 um (well within the 592 um² budget).

Let me write the script:
```python
import klayout.db as kdb

# ---------------------------------------------------------------- technology
TECH = dict(
    name="freepdk45",
    grid=0.005,
    dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0),
        "pplus": (5, 0), "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0),
        "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0),
        "m3": (15, 0), "via3": (16, 0), "m4": (17, 0), "via4": (18, 0),
        "m5": (19, 0), "via5": (20, 0), "m6": (21, 0), "via6": (22, 0),
        "m7": (23, 0), "via7": (24, 0), "m8": (25, 0), "via8": (26, 0),
        "m9": (27, 0), "via9": (28, 0), "m10": (29, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    width={"nwell": 0.20, "pwell": 0.20, "diff": 0.09, "poly": 0.05,
           "nplus": 0.045, "pplus": 0.045, "m1": 0.065, "m2": 0.07,
           "m3": 0.07, "m4": 0.14, "m5": 0.14, "m6": 0.14, "m7": 0.40,
           "m8": 0.40, "m9": 0.80, "m10": 0.80},
    space={("diff", "diff"): 0.08, ("poly", "poly"): 0.075,
           ("poly", "diff"): 0.05, ("m1", "m1"): 0.065, ("m2", "m2"): 0.07},
    enc={
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035),
        ("m2", "via1"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    rules=dict(gate_contact_space=0.035, poly_endcap=0.055,
               diff_ext_gate=0.07, tap_diff_space=0.105),
    devices=dict(
        nmos=dict(w=0.09, l=0.05, implant="nplus", well="pwell"),
        pmos=dict(w=0.18, l=0.05, implant="pplus", well="nwell"),
    ),
)

CW, CH = 1.66, 2.46          # cell pitch (x: bitline dir, y: wordline dir)
COLS, ROWS = 8, 16

ly = kdb.Layout()
ly.dbu = TECH["dbu"]
top = ly.create_cell("sram16x8")

L = {name: ly.layer(*tp) for name, tp in TECH["layers"].items()}
LAB = {m: ly.layer(*tp) for m, tp in TECH["label"].items()}

def dbu(um): return um / TECH["dbu"]
def box(x1, y1, x2, y2):
    return kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2))

def rect(cell, layer, x, y, w, h):
    cell.shapes(layer).insert(box(x, y, x + w, y + h))

def contact(cell, x, y, layers=("diff", "poly", "m1"), size=0.065):
    """contact pad: cut + metal on all listed layers, centered at (x,y)"""
    h = size / 2
    for lname in layers:
        rect(cell, L[lname], x - h, y - h, size, size)
    if "m1" in layers:
        rect(cell, L["m1"], x - h - 0.035, y - h - 0.035, size + 0.07, size + 0.07)

def via(cell, x, y, lower, upper, size=None):
    info = TECH["cuts"].get(lower + "1" if False else "")  # placeholder
```

Hmm, I realize I haven't defined `cuts` in my TECH dict. Let me include the via sizes from the PDK. For this layout I only need contact and via1. Let me include them.

Let me also define the transistor helper:

```python
def mos(cell, kind, x, y, w, l, gate_name):
    """diffusion strip w (x) x h (y) at (x,y), poly gate strip l (y) x gw (x) centered at gate_y"""
```

Actually let me write the whole thing carefully now.

```python
import klayout.db as kdb

# ---------------- PDK: freepdk45 ----------------
GRID = 0.005
DBU = 0.0005

LAYERS = {
    "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0),
    "pplus": (5, 0), "poly": (9, 0), "contact": (10, 0),
    "m1": (11, 0), "via1": (12, 0), "m2": (13, 0),
}
LABEL = {m: (11 + 2 * i, 1) for i, m in enumerate(
    ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])}

CUTS = {
    "contact": dict(size=0.065, space=0.075),
    "via1": dict(size=0.07, space=0.075),
}

# cell pitch
CW, CH = 1.66, 2.46
COLS, ROWS = 8, 16

# cell-internal geometry (um)
# x: bitline direction; y: wordline direction
BL_X = 0.20          # BL  metal1 pad center x
BLB_X = 1.46         # BLB metal1 pad center x
Q_X = 0.62           # Q   strap center x
QB_X = 1.04          # QB  strap center x
VDD_X = 1.24         # VDD strap center x
VSS_X = 0.44         # VSS strap center x
STRAP_W = 0.135      # metal1 strap width (contact 0.065 + 2*0.035 enc)
PAD = 0.065          # contact pad

# diffusion strips (x ranges)
DL_X0, DL_X1 = 0.10, 0.19      # left NMOS strip (Q side), width 0.09
DR_X0, DR_X1 = 1.47, 1.56      # right NMOS strip (QB side)
PL_X0, PL_X1 = 0.53, 0.71      # left PMOS strip (Q side), width 0.18
PR_X0, PR_X1 = 0.95, 1.13      # right PMOS strip (QB side)

# y regions
NMOS_Y0, NMOS_Y1 = 0.20, 0.60      # NMOS active row
PMOS_Y0, PMOS_Y1 = 1.86, 2.26      # PMOS active row
WL_Y = 0.40                        # word line poly (access gate) y
GATE_Y = 2.06                      # PMOS/NMOS gate y (cross-coupled)
Q_Y = 0.90                         # Q node contact y (between NMOS gate and PMOS gate)
QB_Y = 1.56
VSS_Y = 0.72                       # VSS strap contact y on NMOS strip
VDD_Y = 1.74                       # VDD strap contact y on PMOS strip
BL_Y = 1.03                        # BL pad contact y on left NMOS strip
BLB_Y = 1.43                       # BLB pad contact y on right NMOS strip
```

Wait, I need to double check the strap/diffusion overlaps:
- Q strap x 0.62±0.0675 → [0.5525, 0.6875]. Overlaps DL [0.10,0.19]? NO! 0.5525 > 0.19. ✗✗

I made an error. Q strap must overlap DL diffusion to contact it. Let me redo the x assignment.

Constraints:
- Q strap overlaps DL (left NMOS) and PL (left PMOS).
- QB strap overlaps DR (right NMOS) and PR (right PMOS).
- BL pad overlaps DL; BLB pad overlaps DR.
- All straps/pads are metal1 vertical strips; mutual space ≥ 0.065 where y-ranges overlap.

DL = [0.10, 0.19], DR = [1.47, 1.56], PL = [0.53, 0.71], PR = [0.95, 1.13].

Q strap must overlap both DL [0.10,0.19] and PL [0.53,0.71] — impossible with a single straight strip (gap 0.34).

So the left-side Q node can't be one vertical strap contacting both DL and PL unless DL and PL overlap in x. Let me make PL overlap DL in x: PL = [0.10, 0.28] (width 0.18, same left edge as DL). Then Q strap at x [0.1325, 0.2675] overlaps both ✓.

Similarly PR overlaps DR: PR = [1.38, 1.56]? DR = [1.47, 1.56]. PR width 0.18: PR = [1.38, 1.56]. QB strap = [1.3925, 1.5275] overlaps DR [1.47,1.56] ✓ and PR ✓.

Now x layout:
- DL [0.10, 0.19], PL [0.10, 0.28] (same x start, different y rows — fine, separated by y)
- Q strap [0.1325, 0.2675] (overlaps DL ✓, PL ✓)
- BL pad must overlap DL [0.10,0.19]: BL pad [0.1325, 0.1975]? But that overlaps Q strap x-range [0.1325,0.2675]! Both metal1. BL pad y-range around BL_Y, Q strap y-range around Q_Y — if y-ranges don't overlap, OK. BL pad: y [BL_Y-0.0325, BL_Y+0.0325]. Q strap: y [Q_Y-0.0675, Q_Y+0.0675]. Choose BL_Y and Q_Y far enough: |BL_Y - Q_Y| ≥ 0.065 + half-heights... pad half 0.0325, strap half 0.0675 → need |Δy| ≥ 0.0325+0.0675+0.065 = 0.165 if x-overlaps. 

Hmm, this is getting fiddly. Alternative: put BL pad at x NOT overlapping Q strap. BL pad must overlap DL [0.10,0.19]. Q strap is [0.1325, 0.2675]. Any BL pad overlapping DL overlaps Q strap in x (since Q strap covers most of DL). So separate in y: |BL_Y - Q_Y| ≥ 0.165.

Similarly BLB pad overlaps DR [1.47,1.56], QB strap [1.3925,1.5275] covers most of DR → separate in y: |BLB_Y - QB_Y| ≥ 0.165.

VDD strap overlaps PL [0.10,0.28]: VDD strap x within PL, say [0.1325, 0.2675] — same as Q strap?! Then VDD and Q straps both overlap PL and DL in x — separate in y: |VDD_Y - Q_Y| ≥ 0.165 (both full straps) or make VDD strap only in PMOS row region.

OK you know what, this x-sharing forces y-separation of everything. Total y needed: NMOS row [0.20,0.60], contacts at various y, PMOS row [1.86,2.26]. Let me just assign y positions with ≥0.165 separation where x-overlaps:

- WL_Y = 0.40 (poly horizontal, crosses NMOS strip — access gate)
- VSS_Y = 0.72 (VSS strap contact on NMOS strip; strap x overlaps DL/PL? VSS strap connects NMOS drains... wait)

Hold up, let me recheck transistor connections:
- Mn0_0 (access): D=Q, G=WL, S=BL. Diffusion strip DL: gate WL crosses it. Contacts: BL (source) and Q (drain).
- Mn0_1 (pulldown): D=VSS, G=QB, S=Q. Gate QB crosses DL. Contacts: Q (source) and VSS (drain).

So DL has gates WL and QB crossing it, contacts BL, Q, VSS.
- Q contact: between the two gates (shared drain/source node).
- BL contact: on one side of WL gate.
- VSS contact: on other side of QB gate.

y positions along DL: BL contact at y_BL, WL gate at y_WL, Q contact at y_Q, QB gate at y_QB, VSS contact at y_VSS. Order along y: e.g., BL(0.30), WL(0.40), Q(0.90)... wait Q contact must be between WL and QB gates. Let me order: BL_Y=0.30, WL_Y=0.40, Q_Y=0.65, QB_Y=0.90, VSS_Y=1.15? But NMOS row is [0.20, 0.60] — contacts must be on the diffusion (within row y-range) and diffusion_ext_gate 0.07: diffusion extends 0.07 past outer gates.

Hmm, NMOS row height 0.40 with 2 gates (WL, QB) and 3 contacts (BL, Q, VSS) — tight. Gate width (poly) 0.05 in y, contacts 0.065 in y, gate_contact_space 0.035 between contact and gate, diff_ext_gate 0.07 diffusion past end gates.

Along y within diffusion: 
- diffusion from y0 to y1
- end gate (WL) at y0 + 0.07 + 0.025 = y0+0.095 (gate centered, diffusion extends 0.07 past gate edge: gate edge at y0+0.07, gate center y0+0.095)
- contact BL: gate edge + 0.035 + 0.0325 = y0+0.07+0.035+0.0325 = y0+0.1375 center
- gate QB: ... this needs more space. Let me compute total: 0.07 (ext) + 0.05 (WL) + 0.035 (space) + 0.065 (BL contact) + 0.035 + 0.065 (Q contact) + 0.035 + 0.05 (QB) + 0.035 + 0.065 (VSS contact) + 0.07 (ext) = 0.575. Too tall for 0.40 row.

Reduce: share contacts? The classic trick: Q contact shared between Mn0_0 drain and Mn0_1 source — one contact between the two gates. BL contact outside WL, VSS contact outside QB. Sequence along y: BL_contact, WL_gate, Q_contact, QB_gate, VSS_contact.

Minimal height: 0.07 (ext below WL) + 0.05 (WL) + 0.035 (WL to Q contact) + 0.065 (Q contact) + 0.035 (Q contact to QB) + 0.05 (QB) + 0.035 (QB to VSS contact) + 0.065 (VSS contact) + 0.07 (ext above VSS) = 0.475. Still > 0.40.

Hmm. But wait — do BL and VSS contacts need to be on the same strip as the gates? BL is source of access, VSS is drain of pulldown. They could be at the ends. 0.475 needed. Let me make NMOS row taller: CH=2.46, NMOS row [0.15, 0.65] (0.50 tall). OK 0.475 fits in 0.50. Tight but OK. Actually let me recompute more carefully with contact centered and gate_contact_space = contact edge to gate edge ≥ 0.035:

y0 = 0.15 (diff bottom)
- WL gate: bottom y0+0.07=0.22, top 0.27 (center 0.245)
- BL contact: bottom 0.27+0.035=0.305, top 0.37 (center 0.3375)
- Q contact: bottom 0.37+0.035=0.405, top 0.47 (center 0.4375)
- QB gate: bottom 0.47+0.035=0.505, top 0.555 (center 0.53)
- VSS contact: bottom 0.555+0.035=0.59, top 0.655 — exceeds 0.65!

Too tight. Swap: put VSS contact below WL and BL above? Order: VSS_contact, WL_gate, Q_contact, QB_gate, BL_contact — same total.

Alternative: reduce by putting Q contact not between gates but... Q must be between WL and QB electrically? No! Q is drain of Mn0_0 and source of Mn0_1. The contact can be anywhere on the diffusion segment that's electrically Q. The diffusion segment between WL gate and QB gate is Q (drain of access = source of pulldown). Segments: below WL = BL (source of access), between WL and QB = Q, above QB = VSS (drain of pulldown). So yes Q between the two gates.

Total 0.475 minimum. Let me set NMOS row [0.12, 0.62] (0.50). 0.475 fits with 0.025 to spare. Hmm, tight but OK. Actually let me reconsider: maybe drop the separate VSS contact — connect VSS via the strap that crosses... no, VSS must contact the diffusion.

Alternatively use wider row: CH=2.46 gives room. NMOS row [0.10, 0.62] = 0.52. Fine.

Similarly PMOS row: Mp1_0 (gate QB, S=VDD, D=Q) and Mp1_1 (gate Q, S=VDD, D=QB) on strips PL and PR. Each strip has one gate. Contacts: VDD and Q on PL. Sequence: VDD_contact, QB_gate, Q_contact (or Q, gate, VDD). Height: 0.07 + 0.065 + 0.035 + 0.05 + 0.035 + 0.065 + 0.07 = 0.39. PMOS row [1.72, 2.24] = 0.52. Fine.

But wait — cross-coupled gates: QB gate of PMOS Mp1_0 must connect to QB node (DR/PR diffusions + QB strap). Q gate of PMOS Mp1_1 connects to Q node. The gates are poly strips running horizontally (x) across the cell at GATE_Y. Q gate poly crosses PL and PR? Mp1_1 gate = Q, crosses PR (right PMOS strip). Mp1_0 gate = QB crosses PL (left PMOS strip). So poly strips: one at QB_Y_pmos crossing PL, one at Q_Y_pmos crossing PR. They're separate poly strips (different x ranges), both horizontal. They must connect to QB/Q straps respectively — via contact on poly + m1 strap.

Also NMOS gates: WL (horizontal poly across both DL and DR at WL_Y), QB gate of Mn0_1 crosses DL at QB_Y_nmos, Q gate of Mn0_2 crosses DR at Q_Y_nmos.

So poly strips in cell:
1. WL: [cell_x0, cell_x1] at WL_Y — crosses DL and DR. Continues to adjacent cells (row wire).
2. QB_n (gate of Mn0_1): crosses DL only, at QB_Y_n. Connects to QB strap via poly contact.
3. Q_n (gate of Mn0_2): crosses DR only, at Q_Y_n. Connects to Q strap via poly contact.
4. QB_p (gate of Mp1_0): crosses PL only, at QB_Y_p. Connects to QB strap.
5. Q_p (gate of Mp1_1): crosses PR only, at Q_Y_p. Connects to Q strap.

Cross-coupled connections:
- Q node: DL diff (Mn0_0 drain, Mn0_1 source), PL diff (Mp1_0 drain), Q_n gate (Mn0_2 gate), Q_p gate (Mp1_1 gate). All connected via Q strap (m1 vertical) with contacts to DL, PL, and poly contacts to Q_n, Q_p gates.
- QB node: DR, PR, QB_n gate, QB_p gate via QB strap.

Poly contacts: contact on poly (layers contact + poly + m1 pad). The m1 pad connects to the strap.

This is a lot of contacts but doable. Let me now also handle y-separation constraints between metal1 straps/pads that overlap in x.

Straps (all vertical metal1, full-ish height):
- Q strap x [0.1325, 0.2675]: contacts DL (at Q_Y_n), PL (at Q_Y_p), poly Q_n, poly Q_p.
- QB strap x [1.3925, 1.5275]: contacts DR, PR, poly QB_n, QB_p.
- VDD strap: connects PL and PR sources (VDD). x must overlap PL [0.10,0.28] and PR [1.38,1.56] — can't be one straight strap. So VDD = two segments? Or VDD strap per strip connected by metal2 horizontal? 

Simpler: VDD and VSS as metal2 horizontal straps per row? VDD common to all cells — metal2 horizontal line per row at VDD_Y, contacting PMOS strips via via1+m1 pads. But m1 pads at different x (PL and PR) — metal2 horizontal line crosses both, with via1 at each. That works: VDD metal2 horizontal strap per row, y = VDD_Y, with via1+m1 contacts to PL and PR diffusions... wait contact is on diffusion (contact layer) + m1, then via1 from m1 to m2.

Hmm, but actually simpler: keep everything in metal1 within the cell, and bring VDD/VSS up at cell edges via metal2. Let me do:

- VSS: metal1 vertical strap overlapping DL (x within [0.10,0.19]) at VSS_Y, and overlapping DR at VSS_Y — two segments connected by metal1 horizontal? Metal1 horizontal at VSS_Y from DL to DR would cross Q/QB straps... 

You know, let me simplify: VDD and VSS straps run vertically too, one per side:
- VSS strap x [0.1325, 0.2675]?? overlaps Q strap. No.

New plan: separate x columns for each node:
- Column A (x ~0.145): DL diff [0.10,0.19], BL pad, Q strap, VSS strap — all at different y, x-overlapping → need y-separation ≥ 0.165 between any two metal1 shapes here. Contacts on DL at: BL_Y, Q_Y_n, VSS_Y. Plus Q strap and VSS strap vertical segments.

Ugh, the y-separation requirement between x-overlapping metal1 shapes is the killer. |y1-y2| ≥ 0.165 for pad(0.065) vs strap(0.135): 0.0325+0.0675+0.065 = 0.165.

Available y range: CH=2.46. Let me budget:
- NMOS row: [0.10, 0.62] (contacts BL, Q, VSS within)
- gap
- PMOS row: [1.84, 2.36] (contacts VDD, Q, VDD within)

Within NMOS row [0.10, 0.62] (0.52 tall), contacts at BL_Y, Q_Y_n, VSS_Y with gates between. From earlier computation: BL(0.3375), WL(0.245)... let me redo with y0=0.10:
- WL gate: [0.17, 0.22] (center 0.195), ext below 0.07 ✓ (0.10 to 0.17)
- BL contact: [0.255, 0.32] (center 0.2875)
- Q contact: [0.355, 0.42] (center 0.3875)
- QB gate: [0.455, 0.505] (center 0.48)
- VSS contact: [0.54, 0.605] (center 0.5725), ext above 0.07 → 0.675 > 0.62 ✗

Row too short. Extend NMOS row to [0.10, 0.70] (0.60). Then VSS contact [0.54, 0.605], ext to 0.675 ✓ within 0.70. 

But then Q strap contact at Q_Y_n = 0.3875, VSS strap contact at VSS_Y = 0.5725 — both on DL, x-overlapping straps → |0.5725-0.3875| = 0.185 ≥ 0.165 ✓ (barely). BL pad at BL_Y = 0.2875 vs Q strap 0.3875: |Δ| = 0.1 < 0.165 ✗! BL pad and Q strap both overlap DL in x.

Fix: BL pad x must not overlap Q strap x, OR separate by y. BL pad overlaps DL [0.10,0.19]. Q strap [0.1325,0.2675] overlaps DL [0.1325,0.19]. If BL pad = [0.10, 0.165] (width 0.065) and Q strap = [0.1325, 0.2675], x-overlap [0.1325,0.165] ≠ ∅ → need y-sep 0.165. |0.3875-0.2875| = 0.1 ✗.

Make BL pad x = [0.10, 0.165], Q strap x = [0.17, 0.305]? Q strap must overlap DL [0.10,0.19] for contact → Q strap x must intersect [0.10,0.19]. And overlap PL [0.10,0.28]. Q strap [0.17, 0.305] overlaps DL [0.17,0.19] ✓ (contact at x 0.17-0.1975 within DL ✓) and PL ✓. BL pad [0.10, 0.165] vs Q strap [0.17, 0.305]: space 0.005 < 0.065 ✗ (both m1, y-overlapping possibly).

OK the x-space between BL pad and Q strap where both exist must be ≥ 0.065 OR y-separated. Let me just y-separate everything in column A and give each its own x sub-range within DL:

DL [0.10, 0.19] width 0.09. Contact pads are 0.065 wide, centered in DL: x [0.1175, 0.1825]. All contacts on DL have essentially the same x-range! So all metal1 contacts on DL (BL, Q, VSS) overlap in x → must be y-separated by ≥ 0.065 (pad-pad: 0.0325+0.0325+0.065 = 0.13). Pad vs strap (strap wider): 0.165.

So in column A: BL pad (y 0.2875), Q strap contact/pad (y 0.3875), VSS pad (y 0.5725): separations 0.1, 0.185. BL-Q: 0.1 < 0.13 ✗.

Increase row height and spread: y0=0.10:
- WL gate [0.17, 0.22]
- BL contact [0.26, 0.325] (center 0.2925)
- Q contact [0.395, 0.46] (center 0.4275)
- QB gate [0.495, 0.545]
- VSS contact [0.615, 0.68] (center 0.6475), ext above to 0.75

NMOS row [0.10, 0.75]. Separations: BL-Q: 0.4275-0.2925 = 0.135 ≥ 0.13 ✓. Q-VSS: 0.6475-0.4275 = 0.22 ✓.

But Q strap is vertical (not just pad) — it runs from Q_Y_n up to PMOS row. Where it overlaps DL y-range [0.10,0.75] at x overlapping DL... Q strap x [0.17,0.305] overlaps DL [0.10,0.19] in x-range [0.17,0.19]. Q strap vertical segment passing through DL region y [0.10,0.75] would overlap BL pad (y [0.26,0.325]) in both x and y → short! 

So Q strap can't pass through the DL region at x overlapping DL except at the Q contact. Solution: Q strap only exists where needed: segment from Q contact up to PMOS row, starting at y above QB gate (0.545). Q strap: y [0.545+0.035, ...] = [0.58, ...] x [0.17, 0.305]. It contacts DL at Q contact [0.395,0.46]? The strap y starts 0.58 > 0.46 — no contact!

Restructure: Q strap vertical at x [0.17, 0.305], running y [0.395, PMOS_top]. It overlaps DL in x [0.17,0.19] and y [0.395, 0.46] (Q contact region — good, that's the contact), but also y [0.46, 0.545] overlaps QB gate region — QB gate is poly, different layer, OK. y [0.545, 0.68] overlaps VSS contact [0.615,0.68] at x [0.17,0.19] ∩ VSS contact x [0.1175,0.1825] = [0.17,0.1825] ≠ ∅ → Q strap (m1) overlaps VSS contact pad (m1) → short ✗.

So Q strap x must avoid VSS pad x [0.1175, 0.1825] where y-overlaps. Q strap x [0.17, 0.305] overlaps [0.17, 0.1825]. ✗.

Make Q strap x = [0.185, 0.32]? Overlaps DL [0.185, 0.19] (tiny, 0.005 — contact needs 0.065 pad within diff with 0.005 enc: contact [0.185,0.25] vs DL [0.10,0.19]: contact not within diff ✗ enc fails).

Hmm. Contact on DL must be within DL with 0.005 enc: contact x ⊂ [0.1005, 0.1895]. Q strap must contact DL at Q contact: strap overlaps contact. VSS pad at [0.1175, 0.1825]. Q strap and VSS pad both m1: if y-overlap, need x-space 0.065. Q strap x-range must be ≥ 0.065 from VSS pad x-range OR y-separated.

Q strap y-range: from Q contact (0.395-0.46) upward. VSS pad y [0.615, 0.68]. If Q strap y starts at 0.46+0.035=0.495 (space from Q contact? Q strap touching Q contact pad is the connection — they should overlap/touch). Q strap y [0.395, ...]. Overlaps VSS pad y [0.615,0.68] → need x-space: Q strap x must be ≥ 0.065 from VSS pad x [0.1175,0.1825] → Q strap x ≥ 0.2475 or ≤ 0.0525. Q strap must overlap DL [0.10,0.19] for the Q contact → Q strap x ⊂ around [0.1175,0.1895]. Conflict: Q strap x ≥ 0.2475 doesn't overlap DL.

Fundamental: Q strap and VSS pad both contact DL, both m1, both need x within DL's range → they overlap in x → must be y-separated: |Q_strap_y_at_DL - VSS_pad_y| ≥ 0.13 (pad-pad) but Q strap is wide (0.135) → pad-strap 0.165.

Q strap passes through DL y-range only at Q contact (it's a vertical strap; where it crosses DL diffusion it contacts it — actually that's FINE and desired: Q strap contacting DL along the overlap creates the connection; the contact cut is still needed for extraction? For LVS, diffusion-metal contact needs contact cut. The strap overlapping diffusion without contact = no electrical connection in extraction (m1 over diff without contact = crossing). So strap must have contact cut on diff.

OK let me step back and simplify the cell design radically:

**Simpler cell: horizontal straps for VDD/VSS, vertical for Q/QB, with contacts only where needed, and route straps in x-ranges that don't conflict.**

Actually, the cleanest classic approach: 
- Q and QB nodes: metal1 vertical straps.
- VDD and VSS: metal1 horizontal straps at top/bottom of cell, connecting all strips, with contacts at each strip.
- BL/BLB: metal2 vertical, contacting via metal1 pads at cell top/bottom? No—

Let me try yet another approach: **put contacts at the ends of diffusion strips, outside the gate region**, and run node straps horizontally:

NMOS strip DL [0.10,0.19] x, y [0.10, 0.75]:
- WL gate at y 0.195 (access): below it (y 0.10-0.17) is BL source region; above WL (0.22-0.75) is... Q drain region shared with pulldown.
- QB gate at y 0.52 (pulldown): below QB (0.22-0.49) is Q region; above QB (0.555-0.75) is VSS drain region.

Contacts:
- BL contact at y 0.135 (in BL region, below WL): pad [0.1175,0.1825]x[0.1025,0.1675]
- Q contact at y 0.355 (in Q region): pad [0.1175,0.1825]x[0.3225,0.3875]
- VSS contact at y 0.665 (in VSS region): pad [0.1175,0.1825]x[0.6325,0.6975]

All three pads same x-range [0.1175,0.1825], y-separated: BL-Q: 0.3225-0.1675 = 0.155 ≥ 0.13 ✓; Q-VSS: 0.6325-0.3875 = 0.245 ✓.

Now straps:
- Q strap: vertical metal1 at x [0.1175, 0.1825]? It would overlap BL and VSS pads in x → y-separation needed. Q strap runs from Q contact (y 0.3225-0.3875) upward to PMOS row. Overlaps VSS pad y [0.6325,0.6975] in x [0.1175,0.1825] → short unless y-separated: strap starts at 0.3875+0.065=0.4525? Still overlaps VSS pad at 0.6325. ✗.

Q strap must avoid VSS pad. So Q strap x ≠ [0.1175,0.1825] at VSS pad y. But Q strap needs to contact DL at Q contact (x [0.1175,0.1825], y [0.3225,0.3875]). A vertical strap at x [0.1175,0.1825] from y 0.3875 upward crosses VSS pad y-range. ✗.

**Solution: jog the strap.** Q strap: vertical segment at x [0.1175,0.1825] from Q contact up to y 0.4525 (above Q contact + 0.065 space), then horizontal jog at y [0.4525, 0.5175] to x-range clear of VSS pad, then vertical up. But horizontal jog in m1 at y 0.4525-0.5175 crosses QB gate (poly at 0.505-0.555)? Poly vs m1 crossing OK without contact. Crosses QB strap? QB strap is on the right side (x ~1.4). OK.

This is getting really complicated. Let me simplify by **not sharing diffusion between access and pulldown**. Give each transistor its own diffusion strip, and route nodes with metal1 in a grid with proper spacing. More area but simpler DRC. Area budget is 2× reference (592 um²), reference cell = 295.8/128 = 2.31 um². Our cell CW×CH = 1.66×2.46 = 4.08 um² → array 13.3×39.4 = 524 um² < 592 ✓. We have area slack (budget 592, we're at 524). Can afford bigger cell.

**Simpler per-transistor-strip design:**

6 diffusion strips:
- NMOS row (pwell): 4 strips, each 0.09 wide (x), spaced 0.08.
  - A: Mn0_0 access (gate WL): contacts BL, Q
  - B: Mn0_1 pulldown (gate QB): contacts Q, VSS
  - C: Mn0_2 pulldown (gate Q): contacts VSS, QB
  - D: Mn0_3 access (gate WL): contacts QB, BLB
- PMOS row (nwell): 2 strips, each 0.18 wide, spaced 0.08.
  - E: Mp1_0 (gate QB): contacts VDD, Q
  - F: Mp1_1 (gate Q): contacts VDD, QB

Each strip has 1-2 gates and 2 contacts. Contacts at ends of strip (outside gates).

x layout (CW = 1.66):
- margin 0.08
- A [0.08, 0.17]
- space 0.08
- B [0.25, 0.34]
- space 0.08
- C [0.42, 0.51]
- space 0.08
- D [0.59, 0.68]
- space
- E [0.80, 0.98] (pmos 0.18)
- space 0.08
- F [1.06, 1.24]
- margin to 1.66: 0.42 right margin — lots of space. Hmm, cell is wider than needed. Let me compress: total used = 0.08 + 4*0.09 + 3*0.08 + 0.08 + 2*0.18 + 0.08 + 0.08 = 0.08+0.36+0.24+0.08+0.36+0.08+0.08 = 1.28. CW = 1.4? But straps need room. Let me use CW = 1.66 and distribute.

Wait, but Q node connects A(drain), B(source), E(drain), and gates of C and F. These are at different x (A=0.08-0.17, B=0.25-0.34, E=0.80-0.98) plus poly gates at C and F x-ranges. Q strap must reach all: horizontal metal1 strap at Q_Y connecting contacts on A, B, E and poly contacts at C, F gates. Horizontal strap crosses strips B, C, D, F in x — at Q_Y, if it overlaps their diffusion in y... diffusion strips are at NMOS/PMOS row y-ranges; Q_Y is between rows → no overlap with diffusions. Crosses poly gates? Q strap (m1) crossing poly gate strips (horizontal poly at gate y) — Q strap is horizontal at Q_Y, poly gates are horizontal too at different y → parallel, no cross. But Q strap must contact poly gates of C (Q gate of Mn0_2) and F (Q gate of Mp1_1) — those poly strips run horizontally at Q_Y_n and Q_Y_p. Q strap horizontal at Q_Y can't contact them (parallel, different y). Need vertical jogs from Q strap up/down to the poly gates with contacts.

OK here's my refined plan — **two metal layers within cell**:
- metal1: horizontal node straps (Q, QB, VDD, VSS) running full cell width at specific y, plus vertical segments/jogs to contacts.
- metal2: BL/BLB vertical bit lines (full array), WL could be metal2 too but poly is fine.

Actually, let me use:
- WL: poly horizontal per row (simple, continuous across row).
- BL/BLB: metal2 vertical per column.
- Q, QB, VDD, VSS: metal1 horizontal straps per cell (running x), with vertical jogs to transistor contacts and poly gate contacts.
- Contacts from BL metal2 to access diffusion: via1 stack (m2-via1-m1-contact-diff) — needs m1 pad at each cell under BL line. m1 pad at BL x-range, y at access source region.

Hmm, BL metal2 vertical line at x_BL, with via1 + m1 pad contacting diffusion at each cell. m1 pad must overlap diffusion and be ≤ cell width. BL x-range fixed per column; diffusion strip A at x [0.08,0.17] — so x_BL must overlap A. m1 pad for BL at x_BL ± 0.035 enc, y at BL contact y.

But Q strap (m1 horizontal) at Q_Y runs full width — crosses x_BL at y Q_Y. BL m1 pad at y BL_Y. If |Q_Y - BL_Y| small and x-overlaps → m1-m1 violation. Keep them y-separated or x-separated. BL pad x [x_BL-0.0675, x_BL+0.0675] (m1 pad over contact: contact 0.065 + 0.035*2 = 0.135). Q strap full width → overlaps BL pad x → need |Q_Y - BL_Y| ≥ 0.165 (strap 0.135? Q strap width: m1 min 0.065; make Q strap 0.065 wide → pad-strap sep 0.0325+0.0325+0.065 = 0.13).

OK I think I'm overcomplicating. Let me just carefully assign y coordinates with all separations, using horizontal straps for Q, QB, VDD, VSS and vertical bit lines in metal2 with local m1 pads.

**Final cell architecture:**

y layers (bottom to top):
- pwell/nwell: full cell + enc
- NMOS row: y [0.55, 1.30] (height 0.75)
- PMOS row: y [1.90, 2.65]? CH=2.46 — too tall. Let me recompute CH.

NMOS strip with 1 gate + 2 contacts (access A: gate WL, contacts BL and Q):
Along y: ext 0.07, gate 0.05, ext between gate and contacts... Sequence: contact_BL, gate_WL, contact_Q (or contact, gate, contact).
Minimal: 0.07 + 0.065 + 0.035 + 0.05 + 0.035 + 0.065 + 0.07 = 0.39.
Pulldown B (gate QB, contacts Q, VSS): same 0.39.
But A and B are separate strips now — each 0.39 tall. NMOS row height 0.39 + margins. Let me set NMOS row [0.30, 0.74] (0.44).

Within strip A (access): BL contact below WL, Q contact above WL:
- y0 = 0.30
- BL contact: [0.37, 0.435] center 0.4025 (ext below 0.07: 0.30→0.37 ✓)
- WL gate: [0.47, 0.52] center 0.495
- Q contact: [0.555, 0.62] center 0.5875
- ext above: 0.62→0.69 ≤ 0.74 ✓

Strip B (pulldown, gate QB): Q contact below QB gate, VSS above:
- Q contact: [0.37, 0.435]
- QB gate: [0.47, 0.52]
- VSS contact: [0.555, 0.62]

Hmm but Q node: A's Q contact (y 0.5875) and B's Q contact (y 0.4025) — Q strap horizontal at Q_Y must contact both: Q strap at y 0.5875 contacts A; to contact B at 0.4025 need vertical jog. Or Q strap at y 0.4025 contacts B, jog up to A. Either way one jog.

Alternatively align: put both Q contacts at same y! Strip A: Q contact below WL, BL above? Access: source BL, drain Q — either side of gate. Let me set:
- Strip A: BL contact [0.555, 0.62], WL gate [0.47, 0.52], Q contact [0.37, 0.435]
- Strip B: Q contact [0.37, 0.435], QB gate [0.47, 0.52], VSS contact [0.555, 0.62]

Now Q contacts both at y [0.37, 0.435] → Q strap horizontal at y_Q = 0.4025 contacts both A and B ✓ no jog needed for those. 
- BL contact A at [0.555, 0.62] (y 0.5875)
- VSS contact B at [0.555, 0.62] (y 0.5875) — VSS strap horizontal at y_VSS = 0.5875 contacts B; needs to reach D's... no, VSS is B's drain and C's drain (Mn0_2: D=VSS). C's VSS contact also at y 0.5875 → VSS strap contacts B and C ✓.
- WL gate at y 0.495 crosses A and D (both access gates) ✓ WL poly horizontal.
- QB gate B at y 0.495; Q gate C at y 0.495 — QB gate and Q gate both at y 0.495 but different x-ranges (B x [0.25,0.34], C x [0.42,0.51]) → two separate poly strips, or one continuous poly strip from B to C at y 0.495? If continuous, it crosses strip D? No, poly over diffusion without contact = transistor! A poly strip crossing diffusion creates a gate. So poly must only cross intended diffusions. QB gate poly: x-range covering B only [0.25,0.34] + endcap 0.055 → [0.195, 0.385]. Q gate poly: covering C only [0.42,0.51] → [0.365, 0.565]. These two poly strips: space between 0.385 and 0.365 → overlap! Poly-poly space 0.075 needed. [0.195,0.385] and [0.365,0.565] overlap [0.365,0.385] ✗.

Make gates narrower: poly endcap 0.055 each side, diffusion width 0.09 → gate x-range = diff [±0.055]: B gate [0.195, 0.385] width 0.19. C gate [0.365, 0.565]. Overlap because B and C strips are only 0.08 apart (0.34 to 0.42) — gates need 0.055 endcap each → total 0.11 > 0.08 gap. ✗.

So adjacent strips can't each have a gate with endcaps in the gap. Solutions: increase x spacing between B and C to ≥ 0.055+0.075+0.055 = 0.185 (gate endcap + poly-poly space + gate endcap)? No wait: gate B right edge = C_x0 - 0.055, gate C left edge = B_x1 + 0.055, space between gates ≥ 0.075 → gap between diffusions ≥ 0.055 + 0.075 + 0.055 = 0.185. Diff-diff space is only 0.08, so we must increase spacing between gated strips to 0.185. That widens the cell.

Alternative: gates don't need endcap past diffusion if... poly_endcap 0.055 is required (POLY.3). So yes.

Hmm, but actually the endcap is poly past active: poly extends 0.055 beyond diffusion edge. Two adjacent diffusions with gates: poly1 ends at diff1_x1 + 0.055, poly2 starts at diff2_x0 - 0.055, need poly-poly space 0.075 → diff2_x0 - diff1_x1 ≥ 0.185.

So between any two diffusion strips that both have gates at the same y (or any y, since poly strips are horizontal and span x), spacing ≥ 0.185 if both gated. Strips with gates at different y could be closer? Poly-poly space is between poly shapes regardless of y? No — poly-poly space applies to poly shapes on the same layer; if they're at different y, they're separated in y, no space needed in x. But horizontal poly strips at different y: fine.

So: B gate (QB) at y 0.495, C gate (Q) at y 0.495 — same y → need x separation 0.185 between B and C. Move C to x [0.525, 0.615] (gap 0.185 from B). Then D (access, gate WL at y 0.495) also gated at same y → D needs 0.185 from C → D [0.80, 0.89]. And A (gate WL at 0.495) needs 0.185 from B → A [0.065, 0.155]? gap A-B: 0.25-0.155 = 0.095 < 0.185 ✗. A [0.065, 0.155], B must start ≥ 0.34. 

This is eating x space. 4 NMOS strips gated at same y: total x = 4*0.09 + 3*0.185 = 0.36 + 0.555 = 0.915 + margins. Plus PMOS strips: E gate QB at y Q_Y_p, F gate Q at y Q_Y_p — same y → E-F spacing 0.185. PMOS total = 2*0.18 + 0.185 = 0.545.

x layout: NMOS [0.065, 0.98] roughly, PMOS [0.80, 1.345] — they can overlap in x (different y rows). CW = max(NMOS right + margin, PMOS right + margin) = 1.345 + 0.1 = 1.445. Say CW = 1.5.

Hmm wait, but actually do A and D (access gates, both WL) need to be separate poly strips? WL is one continuous poly strip crossing both A and D — it's one poly shape spanning x from A to D. Then poly-poly space between WL and B's QB gate: WL spans [A_x0-0.055, D_x1+0.055] continuously — it would overlap B and C regions in x but at y 0.495 it crosses B and C diffusions → creates unwanted gates! ✗.

So WL poly must only cross A and D diffusions, not B and C. Poly shape = union of rectangles crossing A and D only: two separate rectangles [A_x0-0.055, A_x1+0.055] and [D_x0-0.055, D_x1+0.055] at y WL_Y. They're separate poly shapes (not connected!) — but WL must be one net. Connect them via metal2 (WL metal2 strap over the top with via1 contacts to poly)? Or make WL = metal2 horizontal per row, contacting poly gates via contacts.

Simplest: WL = metal2 horizontal strap per row (running x full array width), with via1 + m1 pad + contact to poly gate segments at A and D. Hmm, contact on poly: contact layer over poly + m1 pad, then via1 to m2.

Actually — simpler: WL poly strip per row is continuous horizontally but we mask it to cross only A and D... The two WL segments (over A and over D) need to be connected. Run WL in metal2 above, connecting the two poly segments via via1/m1/poly contacts at each segment.

Alternatively: accept WL poly crossing B and C? That would make B and C have WL gates — wrong transistors. No.

OK, let me use **metal2 for WL** (horizontal per row) and **poly only for the cross-coupled gates** (QB gate on B, Q gate on C at NMOS row; QB gate on E, Q gate on F at PMOS row). Poly gate segments:
- QB_n: over B only [B_x0-0.055, B_x1+0.055] at y QB_Y_n
- Q_n: over C only at y Q_Y_n
- QB_p: over E only at y QB_Y_p
- Q_p: over F only at y Q_Y_p

These four poly segments are at different x and possibly different y — no poly-poly space issues if x-separated or y-separated. B [0.25,0.34], C [0.42,0.51]: gap 0.08. QB_n gate [0.195, 0.385], Q_n gate [0.365, 0.565] — if same y, overlap ✗. Put QB_n and Q_n at different y: QB_Y_n = 0.495, Q_Y_n = 0.65? Then poly-poly space not needed (different y). But each poly segment must be ≥ ... min poly length? No min length, just width 0.05. OK.

But wait, Q_n gate (poly over C) connects to Q node; QB_n gate (poly over B) connects to QB node. They connect via metal1 straps with poly contacts.

Let me also reconsider: maybe put all four cross-coupled poly gates at the same y but space the NMOS strips 0.185 apart. x cost: 4*0.09 + 3*0.185 = 0.915. PMOS: 2*0.18 + 0.185 = 0.545. CW = 0.915 + 2*0.1 (margins) = 1.115 for NMOS side; PMOS can share x-range. CW = 1.115? Plus strap routing room. Hmm, but then WL poly segments over A and D: A [0.1, 0.19], D [0.725, 0.815] (with 0.185 gaps: A[0.1,0.19], B[0.375,0.465], C[0.65,0.74], D[0.925,1.015]). Let me recompute: A_x0=0.1, A_x1=0.19; B_x0 = 0.19+0.185=0.375, B_x1=0.465; C_x0=0.65, C_x1=0.74; D_x0=0.925, D_x1=1.015. NMOS span [0.1, 1.015]. CW = 1.015 + 0.15 margin = 1.165. WL poly segments: over A [0.045, 0.245] and over D [0.87, 1.07] at WL_Y. Connect via metal2 WL strap.

This works but cell is 1.165 wide × CH tall. Array 8 cols × 1.165 = 9.32 um wide. Reference width 12.4 — we're smaller. 

But honestly, the jog/strap routing complexity is high. Let me reconsider the **shared-diffusion** approach but with gates at the SAME y for access transistors and using the 0.185 spacing only where needed...

Actually, you know what? Let me reconsider the whole thing. The cleanest, most DRC-safe approach given my constraints:

**Use metal2 for ALL horizontal row wires (WL, VDD, VSS) and metal1 for vertical column straps?** No, BL is vertical...

Let me just go with this concrete plan and carefully assign coordinates:

**Cell (CW × CH) = (1.55 × 2.6)**:

x positions:
- A (Mn0_0 access): [0.12, 0.21]
- B (Mn0_1 pulldown): [0.395, 0.485]  (gap A-B = 0.185 ✓)
- C (Mn0_2 pulldown): [0.67, 0.76]   (gap B-C = 0.185 ✓)
- D (Mn0_3 access): [0.945, 1.035]  (gap C-D = 0.185 ✓)
- E (Mp1_0 pmos): [0.12, 0.30]      (overlaps A/B in x, different y row ✓)
- F (Mp1_1 pmos): [0.67, 0.85]      (overlaps C/D ✓)
- CW = 1.55, margins: left 0.12, right 1.55-1.035 = 0.515 (E/F within)

Hmm E [0.12,0.30] width 0.18 ✓, F [0.67,0.85] width 0.18 ✓, gap E-F = 0.37 ≥ 0.185 ✓ (they have gates QB_p and Q_p at same y → need 0.185 ✓).

y positions:
- NMOS row: [0.45, 1.05] (height 0.60)
  - Strip A: BL contact [0.52, 0.585] (y 0.5525), WL gate [0.62, 0.67] (y 0.645), Q contact [0.705, 0.77] (y 0.7375)
    Check: ext below 0.45→0.52 = 0.07 ✓; BL-WL: 0.62-0.585 = 0.035 ✓; WL-Q: 0.705-0.67 = 0.035 ✓; ext above 0.77→1.05 = 0.28 ✓
  - Strip B: Q contact [0.52, 0.585], QB gate [0.62, 0.67], VSS contact [0.705, 0.77]
  - Strip C: VSS contact [0.52, 0.585], Q gate [0.62, 0.67], QB contact [0.705, 0.77]
    Wait Mn0_2: D=QB, G=Q, S=VSS. So VSS source below gate, QB drain above. VSS contact [0.52,0.585], Q gate [0.62,0.67], QB contact [0.705,0.77] ✓
  - Strip D: QB contact [0.52, 0.585], WL gate [0.62, 0.67], BLB contact [0.705, 0.77]
    Mn0_3: D=BLB, G=WL, S=QB. QB source below, BLB drain above ✓
- WL_Y = 0.645 (poly segments over A and D)
- QB_Y_n = 0.645 (poly over B), Q_Y_n = 0.645 (poly over C) — same y! B and C gap 0.185 ✓ gates: QB_n [0.34, 0.54], Q_n [0.615, 0.815], space 0.615-0.54 = 0.0