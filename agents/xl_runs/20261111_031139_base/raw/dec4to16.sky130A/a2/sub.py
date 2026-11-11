import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK parameters (sky130A)
# ----------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "diff": (65, 20), "tap": (65, 44),
        "poly": (66, 20), "licon": (66, 44), "li": (67, 20),
        "mcon": (67, 44), "m1": (68, 20), "via": (68, 44),
        "m2": (69, 20),
    },
    label={"m1": (68, 5), "m2": (69, 5), "poly": (66, 5)},
    pin={"m1": (68, 16), "m2": (69, 16), "poly": (66, 16)},
    cuts={
        "licon": dict(size=0.17, space=0.17),
        "mcon": dict(size=0.17, space=0.19),
        "via": dict(size=0.15, space=0.17),
    },
    width={"diff": 0.15, "poly": 0.15, "li": 0.17, "m1": 0.14, "m2": 0.14},
    space={
        ("diff", "diff"): 0.27, ("poly", "poly"): 0.21,
        ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06),
        ("poly", "licon"): (0.05, 0.08),
        ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085),
        ("m2", "via"): (0.055, 0.085),
    },
    rules=dict(
        gate_contact_space=0.055,
        poly_endcap=0.13,
        diff_ext_gate=0.25,
        polycontact_diff_space=0.19,
        gate_space=0.21,
    ),
    devices={
        "nmos": dict(model="sky130_fd_pr__nfet_01v8", w=0.42, l=0.15),
        "pmos": dict(model="sky130_fd_pr__pfet_01v8", w=0.84, l=0.15),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout setup
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

def L(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

diff_l = L("diff")
poly_l = L("poly")
licon_l = L("licon")
li_l = L("li")
mcon_l = L("mcon")
m1_l = L("m1")
via_l = L("via")
m2_l = L("m2")
nwell_l = L("nwell")
tap_l = L("tap")
label_m1_l = ly.layer(68, 5)
pin_m1_l = ly.layer(68, 16)
label_m2_l = ly.layer(69, 5)
pin_m2_l = ly.layer(69, 16)
label_poly_l = ly.layer(66, 5)
pin_poly_l = ly.layer(66, 16)

# ----------------------------------------------------------------------
# Drawing helpers
# ----------------------------------------------------------------------
def box(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def licon(cell, x, y):
    """Local interconnect contact with li enclosure."""
    s = 0.17
    box(cell, licon_l, x - s/2, y - s/2, x + s/2, y + s/2)
    # li pad: 0.08 enclosure on all sides (satisfies 2-adjacent-edges rule)
    box(cell, li_l, x - s/2 - 0.08, y - s/2 - 0.08, x + s/2 + 0.08, y + s/2 + 0.08)

def via12(cell, x, y):
    """Via between m1 and m2."""
    s = 0.15
    box(cell, via_l, x - s/2, y - s/2, x + s/2, y + s/2)
    box(cell, m1_l, x - s/2 - 0.055, y - s/2 - 0.055, x + s/2 + 0.055, y + s/2 + 0.055)
    box(cell, m2_l, x - s/2 - 0.055, y - s/2 - 0.055, x + s/2 + 0.055, y + s/2 + 0.055)

def m1_h(cell, x1, x2, y, w=0.14):
    """Horizontal metal1 wire."""
    box(cell, m1_l, x1, y - w/2, x2, y + w/2)

def m1_v(cell, x, y1, y2, w=0.14):
    """Vertical metal1 wire."""
    box(cell, m1_l, x - w/2, y1, x + w/2, y2)

def m2_h(cell, x1, x2, y, w=0.14):
    """Horizontal metal2 wire."""
    box(cell, m2_l, x1, y - w/2, x2, y + w/2)

def m2_v(cell, x, y1, y2, w=0.14):
    """Vertical metal2 wire."""
    box(cell, m2_l, x - w/2, y1, x + w/2, y2)

def nwell_rect(cell, x1, y1, x2, y2):
    box(cell, nwell_l, x1, y1, x2, y2)

def tap_diff(cell, x, y, w=0.42, h=0.65):
    """Tap diffusion with licon contact."""
    box(cell, tap_l, x, y, x + w, y + h)
    licon(cell, x + w/2, y + h/2)

# ----------------------------------------------------------------------
# MOS transistor
# ----------------------------------------------------------------------
def mos(cell, x, y, w, l, nfet=True):
    """
    Draw a MOS transistor.
    x,y = lower-left corner of diffusion
    w = diffusion width in x (transistor width)
    l = channel length in y (gate length)
    Diffusion extends 0.25 past gate on both sides in y.
    Poly extends 0.13 past diffusion on both sides in x.
    """
    pe = TECH["rules"]["poly_endcap"]
    ext = TECH["rules"]["diff_ext_gate"]
    
    # Diffusion
    diff_h = l + 2 * ext
    box(cell, diff_l, x, y, x + w, y + diff_h)
    
    if not nfet:
        # nwell around p-diffusion
        nw_pad = 0.18
        box(cell, nwell_l, x - nw_pad, y - nw_pad, x + w + nw_pad, y + diff_h + nw_pad)
    
    # Poly gate (centered in diffusion vertically)
    gate_y = y + ext
    box(cell, poly_l, x - pe, gate_y, x + w + pe, gate_y + l)
    
    return dict(x=x, y=y, w=w, l=l, diff_h=diff_h, gate_y=gate_y)

# ----------------------------------------------------------------------
# Cell parameters
# ----------------------------------------------------------------------
CELL_W = 3.5
CELL_H = 3.5
COLS = 4
ROWS_PER_BLOCK = 4
PITCH_X = CELL_W + 0.5
PITCH_Y = CELL_H + 0.5

# Global origin
ORX = 2.0
ORY = 2.0

# Total dimensions
TOTAL_W = ORX * 2 + COLS * PITCH_X + 2.0
TOTAL_H = ORY * 2 + (1 + ROWS_PER_BLOCK + ROWS_PER_BLOCK) * PITCH_Y + 2.0

# ----------------------------------------------------------------------
# Power rails (metal2 horizontal)
# ----------------------------------------------------------------------
m2_h(top, 0, TOTAL_W, 0.5, w=2.0)       # VSS
m2_h(top, 0, TOTAL_W, TOTAL_H - 0.5, w=2.0)  # VDD
label(top, pin_m2_l, "VSS", 1.0, 0.5)
label(top, pin_m2_l, "VDD", 1.0, TOTAL_H - 0.5)

# ----------------------------------------------------------------------
# Build inverter cell (as a reusable cell)
# ----------------------------------------------------------------------
inv_cell = ly.create_cell("inv")
inv_w = CELL_W
inv_h = CELL_H

# nfet: bottom-left
nfet = mos(inv_cell, 0.6, 0.4, 0.42, 0.15, nfet=True)
# pfet: top-right, in nwell
pfet = mos(inv_cell, 2.0, 2.4, 0.84, 0.15, nfet=False)

# Connect gates: poly strip from nfet gate to pfet gate
# nfet gate: x=[0.47, 1.15], y=[0.65, 0.80]
# pfet gate: x=[1.87, 2.97], y=[3.05, 3.20]
# Run poly horizontally at y=0.80 from nfet gate right edge to pfet gate
# Actually, let's use metal1 to connect gates via contacts
# Better: run a poly strip connecting both gates
box(inv_cell, poly_l, 1.15, 0.72, 1.87, 0.88)  # poly connector

# Contacts
# nfet source (bottom) -> VSS
licon(inv_cell, 0.8, 0.4 + 0.1)
# nfet drain (top) -> output
licon(inv_cell, 0.8, 0.4 + 0.65 - 0.1)
# pfet source (top) -> VDD
licon(inv_cell, 2.42, 2.4 + 0.65 - 0.1)
# pfet drain (bottom) -> output
licon(inv_cell, 2.42, 2.4 + 0.1)

# Connect nfet drain and pfet drain (output) with metal1
m1_v(inv_cell, 0.8, 0.4 + 0.65 - 0.1, 2.4 + 0.1)
m1_h(inv_cell, 0.8, 2.42, 2.4 + 0.1)

# Connect gates to input A (poly pin on left)
# Input A comes in on poly from left
box(inv_cell, poly_l, 0.0, 0.72, 0.47, 0.88)
label(inv_cell, pin_poly_l, "A", 0.2, 0.8)

# Output Y on metal1 right side
m1_v(inv_cell, 3.0, 0.4 + 0.65 - 0.1, 2.4 + 0.1)
label(inv_cell, pin_m1_l, "Y", 3.0, 2.4 + 0.1)

# Power connections
# nfet source to VSS (metal2 at bottom)
m1_v(inv_cell, 0.8, 0.4 + 0.1, 0.5)
via12(inv_cell, 0.8, 0.5)
# pfet source to VDD (metal2 at top)
m1_v(inv_cell, 2.42, 2.4 + 0.65 - 0.1, inv_h - 0.5)
via12(inv_cell, 2.42, inv_h - 0.5)

# ----------------------------------------------------------------------
# Build nand4 cell
# ----------------------------------------------------------------------
nand_cell = ly.create_cell("nand4")
nand_w = CELL_W * 2  # wider for 4 parallel pfets
nand_h = CELL_H

# 4 nfets in series: single diff strip, 4 gates
nfet_diff_x = 0.6
nfet_diff_y = 0.4
nfet_diff_w = 0.42
nfet_gates = 4
nfet_gate_l = 0.15
nfet_gate_sp = 0.21
nfet_ext = 0.25
nfet_diff_h = nfet_gates * nfet_gate_l + (nfet_gates - 1) * nfet_gate_sp + 2 * nfet_ext

box(nand_cell, diff_l, nfet_diff_x, nfet_diff_y, nfet_diff_x + nfet_diff_w, nfet_diff_y + nfet_diff_h)

# Poly gates for series nfets
for g in range(nfet_gates):
    gy = nfet_diff_y + nfet_ext + g * (nfet_gate_l + nfet_gate_sp)
    box(nand_cell, poly_l, nfet_diff_x - 0.13, gy, nfet_diff_x + nfet_diff_w + 0.13, gy + nfet_gate_l)

# 4 pfets in parallel: 4 diff strips side by side
pfet_diff_y = 2.4
pfet_diff_h = 0.65
pfet_gate_l = 0.15
pfet_gate_sp = 0.21
pfet_ext = 0.25
pfet_diff_w_total = 4 * 0.84 + 3 * 0.21 + 2 * 0.25

pfet_positions = []
px = 0.6
for g in range(4):
    box(nand_cell, diff_l, px, pfet_diff_y, px + 0.84, pfet_diff_y + pfet_diff_h)
    # nwell around each p-diffusion
    box(nand_cell, nwell_l, px - 0.18, pfet_diff_y - 0.18, px + 0.84 + 0.18, pfet_diff_y + pfet_diff_h + 0.18)
    # poly gate
    gx = px + (0.84 - 0.15) / 2
    box(nand_cell, poly_l, gx - 0.13, pfet_diff_y + pfet_ext, gx + 0.13 + 0.15, pfet_diff_y + pfet_ext + pfet_gate_l)
    pfet_positions.append(px)
    px += 0.84 + 0.21

# Connect all pfet gates together (input D)
# Run poly horizontally connecting all gates
box(nand_cell, poly_l, pfet_positions[0] + 0.42 - 0.075, pfet_diff_y + pfet_ext,
    pfet_positions[3] + 0.42 + 0.075, pfet_diff_y + pfet_ext + 0.15)

# Contacts for nfet stack
# Source of bottom nfet -> VSS
licon(nand_cell, nfet_diff_x + nfet_diff_w/2, nfet_diff_y + 0.1)
# Drain of top nfet -> output
licon(nand_cell, nfet_diff_x + nfet_diff_w/2, nfet_diff_y + nfet_diff_h - 0.1)
# Internal nodes between nfets (contacts on shared diffusion)
for g in range(1, nfet_gates):
    gy = nfet_diff_y + nfet_ext + (g - 1) * (nfet_gate_l + nfet_gate_sp) + nfet_gate_l + 0.1
    licon(nand_cell, nfet_diff_x + nfet_diff_w/2, gy)

# Contacts for pfet parallel
# All sources -> VDD (top of each diff)
for px in pfet_positions:
    licon(nand_cell, px + 0.42, pfet_diff_y + pfet_diff_h - 0.1)
# All drains -> output (bottom of each diff)
for px in pfet_positions:
    licon(nand_cell, px + 0.42, pfet_diff_y + 0.1)

# Connect pfet drains together with metal1
m1_v(nand_cell, pfet_positions[0] + 0.42, pfet_diff_y + 0.1, pfet_diff_y + pfet_diff_h - 0.1)
# Actually, connect all drains with horizontal metal1
m1_h(nand_cell, pfet_positions[0] + 0.42, pfet_positions[3] + 0.42, pfet_diff_y + 0.1)

# Connect nfet drain (top) to pfet drains (output)
m1_v(nand_cell, nfet_diff_x + nfet_diff_w/2, nfet_diff_y + nfet_diff_h - 0.1, pfet_diff_y + 0.1)

# Inputs A, B, C, D on poly (left side)
# A: gate of first nfet (bottom)
# B: gate of second nfet
# C: gate of third nfet
# D: gate of fourth nfet (top) AND all pfet gates
for g in range(4):
    gy = nfet_diff_y + nfet_ext + g * (nfet_gate_l + nfet_gate_sp) + nfet_gate_l / 2
    label(nand_cell, pin_poly_l, f"ABCD"[g], nfet_diff_x - 0.2, gy)

# Output Y on metal1 right
m1_v(nand_cell, nand_w - 0.5, nfet_diff_y + nfet_diff_h - 0.1, pfet_diff_y + pfet_diff_h - 0.1)
label(nand_cell, pin_m1_l, "Y", nand_w - 0.5, (nfet_diff_y + nfet_diff_h - 0.1 + pfet_diff_y + pfet_diff_h - 0.1) / 2)

# Power connections
# nfet source to VSS
m1_v(nand_cell, nfet_diff_x + nfet_diff_w/2, nfet_diff_y + 0.1, 0.5)
via12(nand_cell, nfet_diff_x + nfet_diff_w/2, 0.5)
# pfet sources to VDD
m1_v(nand_cell, pfet_positions[0] + 0.42, pfet_diff_y + pfet_diff_h - 0.1, nand_h - 0.5)
via12(nand_cell, pfet_positions[0] + 0.42, nand_h - 0.5)

# ----------------------------------------------------------------------
# Place cells in top
# ----------------------------------------------------------------------
# Row 0: input inverters (AB0..AB3)
for i in range(4):
    cx = ORX + i * PITCH_X
    cy = ORY
    top.insert(kdb.DCellInstArray(inv_cell.cell_index(), kdb.DTrans(cx, cy)))

# Rows 1-4: nand4 gates
nand_instances = []
for r in range(ROWS_PER_BLOCK):
    for c in range(COLS):
        cx = ORX + c * PITCH_X
        cy = ORY + (r + 1) * PITCH_Y
        top.insert(kdb.DCellInstArray(nand_cell.cell_index(), kdb.DTrans(cx, cy)))
        nand_instances.append((cx, cy, r, c))

# Rows 5-8: output inverters
out_inv_instances = []
for r in range(ROWS_PER_BLOCK):
    for c in range(COLS):
        cx = ORX + c * PITCH_X
        cy = ORY + (r + 1 + ROWS_PER_BLOCK) * PITCH_Y
        top.insert(kdb.DCellInstArray(inv_cell.cell_index(), kdb.DTrans(cx, cy)))
        out_inv_instances.append((cx, cy, r, c))

# ----------------------------------------------------------------------
# Global routing
# ----------------------------------------------------------------------
# Address inputs A0..A3 on left side (metal2 vertical buses)
for i in range(4):
    x = ORX - 1.0
    y1 = ORY + 0.5
    y2 = ORY + (1 + 2 * ROWS_PER_BLOCK) * PITCH_Y - 0.5
    m2_v(top, x, y1, y2)
    label(top, pin_m2_l, f"A{i}", x, y1 + 0.5)

# Complement signals AB0..AB3 from input inverters (metal2 vertical)
for i in range(4):
    x = ORX + i * PITCH_X + 1.5
    y1 = ORY + 0.5
    y2 = ORY + (1 + 2 * ROWS_PER_BLOCK) * PITCH_Y - 0.5
    m2_v(top, x, y1, y2)
    label(top, pin_m2_l, f"AB{i}", x, y1 + 0.5)

# Route NAND inputs: A0..A3 and AB0..AB3 to each NAND gate
# Each NAND at (row r, col c) needs specific inputs
# From netlist:
# N0: AB0 AB1 AB2 AB3
# N1: A0 AB1 AB2 AB3
# N2: AB0 A1 AB2 AB3
# N3: A0 A1 AB2 AB3
# N4: AB0 AB1 A2 AB3
# N5: A0 AB1 A2 AB3
# N6: AB0 A1 A2 AB3
# N7: A0 A1 A2 AB3
# N8: AB0 AB1 AB2 A3
# N9: A0 AB1 AB2 A3
# N10: AB0 A1 AB2 A3
# N11: A0 A1 AB2 A3
# N12: AB0 AB1 A2 A3
# N13: A0 AB1 A2 A3
# N14: AB0 A1 A2 A3
# N15: A0 A1 A2 A3

# Input mapping: for each NAND, which of the 8 lines (A0,A1,A2,A3,AB0,AB1,AB2,AB3)
# connects to which gate (A,B,C,D)
nand_input_map = [
    # (gate_A, gate_B, gate_C, gate_D) - each is ('A', i) or ('AB', i)
    [('AB',0), ('AB',1), ('AB',2), ('AB',3)],  # N0
    [('A',0),  ('AB',1), ('AB',2), ('AB',3)],  # N1
    [('AB',0), ('A',1),  ('AB',2), ('AB',3)],  # N2
    [('A',0),  ('A',1),  ('AB',2), ('AB',3)],  # N3
    [('AB',0), ('AB',1), ('A',2),  ('AB',3)],  # N4
    [('A',0),  ('AB',1), ('A',2),  ('AB',3)],  # N5
    [('AB',0), ('A',1),  ('A',2),  ('AB',3)],  # N6
    [('A',0),  ('A',1),  ('A',2),  ('AB',3)],  # N7
    [('AB',0), ('AB',1), ('AB',2), ('A',3)],   # N8
    [('A',0),  ('AB',1), ('AB',2), ('A',3)],   # N9
    [('AB',0), ('A',1),  ('AB',2), ('A',3)],   # N10
    [('A',0),  ('A',1),  ('AB',2), ('A',3)],   # N11
    [('AB',0), ('AB',1), ('A',2),  ('A',3)],   # N12
    [('A',0),  ('AB',1), ('A',2),  ('A',3)],   # N13
    [('AB',0), ('A',1),  ('A',2),  ('A',3)],   # N14
    [('A',0),  ('A',1),  ('A',2),  ('A',3)],   # N15
]

# X positions of input buses
bus_x = {}
for i in range(4):
    bus_x[('A', i)] = ORX - 1.0
    bus_x[('AB', i)] = ORX + i * PITCH_X + 1.5

# Route inputs to each NAND gate
for (cx, cy, r, c) in nand_instances:
    nand_idx = r * COLS + c
    input_map = nand_input_map[nand_idx]
    # Gate positions within nand cell: A at bottom, D at top
    # Gate y positions (relative to cell): 
    #   gate_g = cy + 0.4 + 0.25 + g * (0.15 + 0.21) + 0.075
    for g in range(4):
        sig_type, sig_idx = input_map[g]
        bx = bus_x[(sig_type, sig_idx)]
        gy = cy + 0.4 + 0.25 + g * (0.15 + 0.21) + 0.075
        # Horizontal metal1 from bus to NAND gate
        m1_h(top, bx, cx + 0.6 - 0.13, gy)
        # Via to connect to poly gate? Actually poly gate is at this y
        # We need to connect metal1 to poly gate via licon+li
        licon(top, cx + 0.6 - 0.13, gy)

# Route NAND outputs to output inverters
for (cx, cy, r, c) in nand_instances:
    nand_idx = r * COLS + c
    # Find corresponding output inverter
    ocx, ocy, orow, ocol = out_inv_instances[nand_idx]
    # NAND output is at right side of nand cell
    # Output inverter input (A) is on poly at left side
    # Route with metal1 vertical then horizontal
    ny = cy + 0.4 + 0.25 + 3 * (0.15 + 0.21) + 0.075  # top nfet gate area ~ output
    # Actually NAND output contact is at top of nfet stack
    out_y = cy + 0.4 + nfet_diff_h - 0.1
    # Route from NAND output to inverter input
    m1_v(top, cx + nand_cell.bbox().width() - 0.5, out_y, ocy + 0.72)
    m1_h(top, cx + nand_cell.bbox().width() - 0.5, ocx + 0.2, ocy + 0.72)

# Output pins Y0..Y15 on right side
for i in range(16):
    r = i // COLS
    c = i % COLS
    ocx, ocy, orow, ocol = out_inv_instances[i]
    # Output Y from inverter is on metal1 right side of inv cell
    # Route to right edge
    x = TOTAL_W - 1.0
    y = ocy + 2.4 + 0.1
    m2_h(top, ocx + 3.0, x, y)
    label(top, pin_m2_l, f"Y{i}", x, y)

# ----------------------------------------------------------------------
# N-well taps (for latch-up protection)
# ----------------------------------------------------------------------
# Place nwell taps in nwell regions
for r in range(ROWS_PER_BLOCK):
    for c in range(COLS):
        cx = ORX + c * PITCH_X
        cy = ORY + (r + 1) * PITCH_Y
        # Tap in nand cell nwell area
        tap_diff(top, cx + 2.0 + 0.5, cy + 2.4 + 0.1)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("dec4to16.gds")
print(f"Wrote dec4to16.gds, size: {TOTAL_W} x {TOTAL_H} = {TOTAL_W*TOTAL_H:.1f} um^2")
print(f"Devices: 84 nfet + 84 pfet = 168 total")
