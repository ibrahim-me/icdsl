import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data for sky130A (layers in (gds, datatype), rules in um)
# ----------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44),
        "diff": (65, 20), "tap": (65, 44),
        "poly": (66, 20),
        "licon": (66, 44), "li": (67, 20),
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
# Layout helpers
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001  # 1 nm

def L(name):
    """Return layer index from TECH layers dict."""
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
label_m1_l = L("m1") if False else ly.layer(68, 5)   # m1 label
pin_m1_l = ly.layer(68, 16)                          # m1 pin
label_m2_l = ly.layer(69, 5)
pin_m2_l = ly.layer(69, 16)

def box(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, x, y, cut="licon", size=None, metal=None):
    """Place a contact (licon/mcon/via) with the upper metal pad."""
    c = TECH["cuts"][cut]
    s = size if size is not None else c["size"]
    box(cell, ly.layer(*TECH["layers"][cut]), x - s/2, y - s/2, x + s/2, y + s/2)
    if metal == "li":
        box(cell, li_l, x - s/2, y - s/2, x + s/2, y + s/2)
    elif metal == "m1":
        box(cell, m1_l, x - s/2, y - s/2, x + s/2, y + s/2)
    elif metal == "m2":
        box(cell, m2_l, x - s/2, y - s/2, x + s/2, y + s/2)

def via12(cell, x, y):
    """Via between m1 and m2."""
    c = TECH["cuts"]["via"]
    s = c["size"]
    box(cell, via_l, x - s/2, y - s/2, x + s/2, y + s/2)
    box(cell, m1_l, x - s/2, y - s/2, x + s/2, y + s/2)
    box(cell, m2_l, x - s/2, y - s/2, x + s/2, y + s/2)

def mos(cell, x, y, w, l, nfet=True, gate_x=None, gate_y=None):
    """
    Draw a MOS transistor.
    Diffusion runs vertically (y), gate (poly) runs horizontally (x).
    x,y = lower-left of diffusion.
    w = diffusion width (x dimension) = transistor width.
    l = channel length (y dimension) = gate length.
    """
    ext = TECH["rules"]["diff_ext_gate"]
    pe = TECH["rules"]["poly_endcap"]
    # diffusion
    box(cell, diff_l, x, y, x + w, y + l)
    if not nfet:
        # nwell around pfet diffusion
        nw_pad = 0.18
        box(cell, nwell_l, x - nw_pad, y - nw_pad, x + w + nw_pad, y + l + nw_pad)
    # poly gate (crosses diffusion)
    gx = gate_x if gate_x is not None else x
    gy = gate_y if gate_y is not None else y
    box(cell, poly_l, gx - pe, gy - pe, gx + w + pe, gy + l + pe)
    return (x, y, w, l)

def diff_strip(cell, x, y, w, h):
    """Draw a diffusion strip (shared source/drain)."""
    box(cell, diff_l, x, y, x + w, y + h)

def poly_strip(cell, x, y, w, h):
    """Draw a poly strip (gate)."""
    box(cell, poly_l, x, y, x + w, y + h)

def m1_wire(cell, x1, y1, x2, y2, width=0.14):
    """Metal1 wire (horizontal or vertical)."""
    if x1 == x2:
        box(cell, m1_l, x1 - width/2, y1, x2 + width/2, y2)
    else:
        box(cell, m1_l, x1, y1 - width/2, x2, y2 + width/2)

def m2_wire(cell, x1, y1, x2, y2, width=0.14):
    """Metal2 wire (horizontal or vertical)."""
    if x1 == x2:
        box(cell, m2_l, x1 - width/2, y1, x2 + width/2, y2)
    else:
        box(cell, m2_l, x1, y1 - width/2, x2, y2 + width/2)

# ----------------------------------------------------------------------
# Standard cells
# ----------------------------------------------------------------------
top = ly.create_cell("dec4to16")

# Cell parameters
CELL_H = 4.0          # standard cell height
CELL_W = 4.0          # standard cell width
PWR_RAIL_W = 2.0      # power rail width
PWR_RAIL_H = 0.3      # power rail height (metal2)
ROW_PITCH = CELL_H + 0.4  # row pitch including routing channel

# Global coordinates
cur_x = 0.0
cur_y = 0.0

# ----------------------------------------------------------------------
# Power rails (VDD / VSS) - metal2 horizontal stripes spanning the whole width
# ----------------------------------------------------------------------
TOTAL_W = 4 * CELL_W + 4.0   # 4 columns + routing channels
TOTAL_H = 9 * ROW_PITCH + 4.0

# VSS rail at bottom, VDD rail at top
m2_wire(top, 0, 0.5, TOTAL_W, 0.5, width=PWR_RAIL_W)
m2_wire(top, 0, TOTAL_H - 0.5, TOTAL_W, TOTAL_H - 0.5, width=PWR_RAIL_W)

# Labels for power pins
label(top, pin_m1_l, "VSS", 0.5, 0.5)
label(top, pin_m1_l, "VDD", 0.5, TOTAL_H - 0.5)

# ----------------------------------------------------------------------
# Input inverters (row 0) - generate AB0..AB3
# ----------------------------------------------------------------------
inv_cells = []
for i in range(4):
    cx = cur_x + i * (CELL_W + 1.0)
    cy = cur_y + ROW_PITCH
    # Nfet
    mos(top, cx + 0.5, cy + 0.5, 0.42, 0.15, nfet=True)
    # Pfet
    mos(top, cx + 0.5, cy + 2.5, 0.84, 0.15, nfet=False)
    # Contacts: nfet source to VSS, drain to output
    contact(top, cx + 0.71, cy + 0.4, cut="licon", metal="li")   # nfet source
    contact(top, cx + 0.71, cy + 0.8, cut="licon", metal="li")   # nfet drain
    contact(top, cx + 0.92, cy + 2.4, cut="licon", metal="li")   # pfet source
    contact(top, cx + 0.92, cy + 3.4, cut="licon", metal="li")   # pfet drain
    # Gate connection (input A_i) - poly gate already drawn, connect with m1
    # Input A_i comes from left via metal2 vertical bus
    # We'll route later
    inv_cells.append((cx, cy))

# ----------------------------------------------------------------------
# NAND4 gates (rows 1-4, 4 columns)
# ----------------------------------------------------------------------
nand_cells = []
for row in range(4):
    for col in range(4):
        cx = cur_x + col * (CELL_W + 1.0) + 2.0
        cy = cur_y + (row + 1) * ROW_PITCH
        # Nfet stack: 4 series nfets, shared diffusion
        diff_x = cx + 0.5
        diff_y = cy + 0.5
        diff_w = 0.42
        diff_h = 4 * 0.15 + 3 * 0.21 + 2 * 0.25  # 4 gates + spaces + extensions
        diff_strip(top, diff_x, diff_y, diff_w, diff_h)
        # Poly gates for the 4 nfets
        for g in range(4):
            gy = diff_y + 0.25 + g * (0.15 + 0.21)
            poly_strip(top, diff_x - 0.13, gy, diff_w + 0.26, 0.15 + 2 * 0.13)
        # Pfet parallel: 4 pfets, shared source/drain diffusions
        p_diff_y = cy + 2.5
        p_diff_h = 0.84
        p_diff_w = 4 * 0.15 + 3 * 0.21 + 2 * 0.25
        # Source diffusion (VDD side)
        diff_strip(top, cx + 0.5, p_diff_y, p_diff_w, 0.15)
        # Drain diffusion (output side)
        diff_strip(top, cx + 0.5, p_diff_y + 0.45, p_diff_w, 0.15)
        # Poly gates for pfets
        for g in range(4):
            gx = cx + 0.5 + g * (0.15 + 0.21)
            poly_strip(top, gx, p_diff_y - 0.13, 0.15 + 2 * 0.13, 0.84 + 0.26)
        # Contacts
        # Nfet stack contacts: source to VSS, drain to output, internal nodes
        contact(top, cx + 0.71, cy + 0.4, cut="licon", metal="li")   # nfet source (VSS)
        contact(top, cx + 0.71, cy + 0.4 + diff_h - 0.15, cut="licon", metal="li")  # nfet drain (output)
        # Pfet contacts
        contact(top, cx + 0.71, p_diff_y - 0.1, cut="licon", metal="li")   # pfet source (VDD)
        contact(top, cx + 0.71, p_diff_y + 0.45 + 0.15 + 0.1, cut="licon", metal="li")  # pfet drain (output)
        nand_cells.append((cx, cy, row, col))

# ----------------------------------------------------------------------
# Output inverters (rows 5-8, 4 columns)
# ----------------------------------------------------------------------
out_inv_cells = []
for row in range(4):
    for col in range(4):
        cx = cur_x + col * (CELL_W + 1.0) + 2.0
        cy = cur_y + (row + 5) * ROW_PITCH
        mos(top, cx + 0.5, cy + 0.5, 0.42, 0.15, nfet=True)
        mos(top, cx + 0.5, cy + 2.5, 0.84, 0.15, nfet=False)
        contact(top, cx + 0.71, cy + 0.4, cut="licon", metal="li")
        contact(top, cx + 0.71, cy + 0.8, cut="licon", metal="li")
        contact(top, cx + 0.92, cy + 2.4, cut="licon", metal="li")
        contact(top, cx + 0.92, cy + 3.4, cut="licon", metal="li")
        out_inv_cells.append((cx, cy, row, col))

# ----------------------------------------------------------------------
# Global routing: address buses A0..A3 and AB0..AB3 (metal2 vertical)
# ----------------------------------------------------------------------
# Input pins A0..A3 on the left side
for i in range(4):
    x = 0.5
    y = cur_y + ROW_PITCH + 0.5 + i * 0.5
    m2_wire(top, x, y, x, y + 2.0, width=0.14)
    label(top, pin_m2_l, f"A{i}", x, y + 1.0)

# Complement buses AB0..AB3 (from input inverters) - route vertically
for i in range(4):
    x = 2.0 + i * (CELL_W + 1.0) + 1.5
    m2_wire(top, x, cur_y + ROW_PITCH, x, cur_y + 5 * ROW_PITCH, width=0.14)
    label(top, pin_m2_l, f"AB{i}", x, cur_y + ROW_PITCH + 0.5)

# True buses A0..A3 - route vertically to nand gates
for i in range(4):
    x = 0.5 + i * 1.0
    m2_wire(top, x, cur_y + ROW_PITCH, x, cur_y + 5 * ROW_PITCH, width=0.14)

# ----------------------------------------------------------------------
# NAND outputs to output inverters (metal1 vertical)
# ----------------------------------------------------------------------
for (cx, cy, row, col) in nand_cells:
    # Find corresponding output inverter (same row,col)
    oi = out_inv_cells[row * 4 + col]
    ox, oy, orow, ocol = oi
    # Route nand output (drain contact) to inverter input (gate)
    # Simplified: draw metal1 vertical from nand output contact to inverter gate
    m1_wire(top, cx + 0.71, cy + 0.4 + (4 * 0.15 + 3 * 0.21 + 2 * 0.25) - 0.15,
            ox + 0.71, oy + 0.5 + 0.15, width=0.14)

# ----------------------------------------------------------------------
# Output pins Y0..Y15 on the right side
# ----------------------------------------------------------------------
for i in range(16):
    row = i // 4
    col = i % 4
    ox, oy, orow, ocol = out_inv_cells[i]
    x = TOTAL_W - 0.5
    y = oy + 1.5
    m2_wire(top, ox + 0.92, oy + 3.4, x, y, width=0.14)
    label(top, pin_m2_l, f"Y{i}", x, y)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("dec4to16.gds")
print("Wrote dec4to16.gds")
