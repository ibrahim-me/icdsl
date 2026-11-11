import klayout.db as kdb

# ------------------------------------------------------------------------------
# PDK data (sky130A) - layers and basic rules in micrometres
# ------------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "lvtn": (125, 44), "hvtp": (78, 44), "hvi": (75, 20), "hvntm": (125, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20), "via2": (69, 44), "m3": (70, 20),
        "via3": (70, 44), "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
        "capm": (89, 44), "cap2m": (97, 44), "rpm": (86, 20), "urpm": (79, 20),
        "polyres": (66, 13), "diffres": (65, 13), "lires": (67, 13),
        "m1res": (68, 13), "m2res": (69, 13), "m3res": (70, 13), "m4res": (71, 13), "m5res": (72, 13),
        "boundary": (235, 4), "areaid_sc": (81, 4), "inductor": (82, 24),
    },
    label={"poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5), "m3": (70, 5), "m4": (71, 5),
           "m5": (72, 5), "nwell": (64, 5), "pwell": (64, 59)},
    pin={"poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16), "m3": (70, 16), "m4": (71, 16),
         "m5": (72, 16), "nwell": (64, 16), "pwell": (122, 16)},
    cuts={
        "licon": dict(size=0.17, space=0.17, lower=["diff", "tap", "poly"], upper="li"),
        "mcon": dict(size=0.17, space=0.19, lower="li", upper="m1"),
        "via": dict(size=0.15, space=0.17, lower="m1", upper="m2"),
    },
    width={"diff": 0.15, "tap": 0.15, "poly": 0.15, "li": 0.17, "m1": 0.14, "m2": 0.14},
    space={
        ("diff", "diff"): 0.27, ("tap", "tap"): 0.27, ("diff", "tap"): 0.27,
        ("poly", "poly"): 0.21, ("poly", "diff"): 0.075, ("poly", "tap"): 0.055,
        ("li", "li"): 0.17, ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06), ("tap", "licon"): (0.0, 0.12), ("poly", "licon"): (0.05, 0.08),
        ("li", "licon"): (0.0, 0.08), ("li", "mcon"): (0.0, 0.0), ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085), ("m2", "via"): (0.055, 0.085),
        ("nwell", "diff"): (0.18, 0.18), ("nwell", "tap"): (0.18, 0.18), ("npc", "licon"): (0.10, 0.10),
    },
    rules=dict(
        gate_contact_space=0.055,
        poly_endcap=0.13,
        diff_ext_gate=0.25,
        polycontact_diff_space=0.19,
        polycontact_implant_space=0.11,
        gate_space=0.21,
        tap_diff_space=0.27,
        latchup_dist=15.0,
        wide_metal=3.0,
    ),
    devices={
        "nmos": dict(type="mos", model="sky130_fd_pr__nfet_01v8", diff="diff", implant="nsdm", well=None,
                     lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(type="mos", model="sky130_fd_pr__pfet_01v8", diff="diff", implant="psdm", well="nwell",
                     lmin=0.15, wmin=0.84, bulk="VDD"),
    },
)

# ------------------------------------------------------------------------------
# Layout helpers
# ------------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001  # 1 nm database unit

def L(name):
    """Return layer index for a short layer name."""
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

# layer indices
diff_l = L("diff")
poly_l = L("poly")
licon_l = L("licon")
li_l = L("li")
mcon_l = L("mcon")
m1_l = L("m1")
via_l = L("via")
m2_l = L("m2")

# label / pin layers
m1_lab_l = ly.layer(*TECH["label"]["m1"])
m1_pin_l = ly.layer(*TECH["pin"]["m1"])

def box(cell, layer, x1, y1, x2, y2):
    """Draw a rectangle (um)."""
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def text(cell, layer, txt, x, y):
    """Place a text label (um)."""
    cell.shapes(layer).insert(kdb.DText(txt, kdb.DTrans(x, y)))

def contact_stack(cell, x, y, cut_size=0.17, enc=0.03):
    """
    Place a full contact stack from diff/poly up to m1.
    Draws licon, li, mcon and a small m1 pad.
    """
    hs = cut_size / 2.0
    # cut (licon)
    box(cell, licon_l, x - hs, y - hs, x + hs, y + hs)
    # li (encasement 0 per rules)
    box(cell, li_l, x - hs, y - hs, x + hs, y + hs)
    # mcon
    box(cell, mcon_l, x - hs, y - hs, x + hs, y + hs)
    # m1 pad (small encasement)
    box(cell, m1_l, x - hs - enc, y - hs - enc, x + hs + enc, y + hs + enc)

def add_mos(cell, x, y, w, l, gate_net, source_net, drain_net, bulk_net, is_pmos, contacts):
    """
    Place a MOS transistor.
    x,y : bottom-left of diffusion (um)
    w   : diffusion width along x (um)  -> transistor width
    l   : diffusion length along y (um) -> transistor length
    Contacts are added to the contacts dict keyed by net name.
    """
    pe = TECH["rules"]["poly_endcap"]          # 0.13 um
    de = TECH["rules"]["diff_ext_gate"]        # 0.25 um
    c_size = TECH["cuts"]["licon"]["size"]     # 0.17 um

    # diffusion
    box(cell, diff_l, x, y, x + w, y + l)
    # poly gate (extends beyond diffusion by poly_endcap on left/right)
    box(cell, poly_l, x - pe, y, x + w + pe, y + l)

    # source contact (bottom end of diffusion)
    sx = x + w / 2.0
    sy = y
    contact_stack(cell, sx, sy, c_size)
    contacts.setdefault(source_net, []).append((sx, sy, "m1"))

    # drain contact (top end of diffusion)
    dx = x + w / 2.0
    dy = y + l
    contact_stack(cell, dx, dy, c_size)
    contacts.setdefault(drain_net, []).append((dx, dy, "m1"))

    # gate contact (middle of poly)
    gx = x + w / 2.0
    gy = y + l / 2.0
    contact_stack(cell, gx, gy, c_size)
    contacts.setdefault(gate_net, []).append((gx, gy, "m1"))

    # bulk contact (side of diffusion, tied to bulk net)
    bx = x - de / 2.0
    by = y + l / 2.0
    contact_stack(cell, bx, by, c_size)
    contacts.setdefault(bulk_net, []).append((bx, by, "m1"))

def route_net(cell, net_name, points, track_y, m1_width=0.14, via_size=0.15):
    """
    Simple Manhattan router for one net.
    points : list of (x, y, layer) contact centres.
    track_y : y-coordinate of the horizontal m1 trunk for this net.
    Draws vertical m1 segments from each contact to the trunk and a horizontal trunk.
    """
    if not points:
        return
    xs = [p[0] for p in points]
    xmin, xmax = min(xs), max(xs)
    # horizontal trunk
    box(cell, m1_l, xmin - m1_width/2, track_y - m1_width/2, xmax + m1_width/2, track_y + m1_width/2)
    # vertical segments to each contact
    for (px, py, _) in points:
        box(cell, m1_l, px - m1_width/2, min(py, track_y) - m1_width/2,
            px + m1_width/2, max(py, track_y) + m1_width/2)

def place_pin(cell, net_name, x, y, layer=m1_pin_l, lab_layer=m1_lab_l, size=0.14):
    """Place a pin (metal rectangle + label)."""
    hs = size / 2.0
    box(cell, layer, x - hs, y - hs, x + hs, y + hs)
    text(cell, lab_layer, net_name, x, y)

# ------------------------------------------------------------------------------
# Full adder cell
# ------------------------------------------------------------------------------
fa = ly.create_cell("fa")

# placement parameters
cell_w = 22.0   # full adder width (um)
cell_h = 14.0   # full adder height (um)

# rows
nmos_y = 1.0
pmos_y = 8.0
row_h  = 4.0

# transistor pitch
pitch = 2.6

# contacts collector: net -> list of (x,y,layer)
contacts = {}

# ------------------------------------------------------------------
# NMOS transistors (w=0.42, l=0.15)
# ------------------------------------------------------------------
nmos_list = [
    # (name, x, gate, source, drain, bulk)
    ("Mn0_0",  0.0, "A",   "VSS", "n1",   "VSS"),
    ("Mn0_1",  pitch, "B",  "n1",  "VSS",  "VSS"),
    ("Mn0_2",  2*pitch, "CB","CIN","n1",   "VSS"),
    ("Mn0_3",  3*pitch, "B", "n2", "CB",   "VSS"),
    ("Mn0_4",  4*pitch, "A", "VSS","n2",   "VSS"),
    ("Mn0_5",  5*pitch, "A", "n3", "VSS",  "VSS"),
    ("Mn0_6",  6*pitch, "B", "VSS","n3",   "VSS"),
    ("Mn0_7",  7*pitch, "CIN","n3","VSS",  "VSS"),
    ("Mn0_8",  8*pitch, "SB","CB","n3",    "VSS"),
    ("Mn0_9",  9*pitch, "CIN","n5","SB",   "VSS"),
    ("Mn0_10",10*pitch, "B", "n4","n5",    "VSS"),
    ("Mn0_11",11*pitch, "A", "VSS","n4",   "VSS"),
    ("Mn0_12",12*pitch, "CB","COUT","VSS", "VSS"),
    ("Mn14",  13*pitch, "SB","VSS","SUM",  "VSS"),
]

for name, x, g, s, d, b in nmos_list:
    add_mos(fa, x, nmos_y, 0.42, 0.15, g, s, d, b, False, contacts)

# ------------------------------------------------------------------
# PMOS transistors (w=0.84, l=0.15)
# ------------------------------------------------------------------
pmos_list = [
    ("Mp0_0",  0.0, "A",   "VDD", "p1",   "VDD"),
    ("Mp0_1",  pitch, "B",  "p1",  "VDD",  "VDD"),
    ("Mp0_2",  2*pitch, "CB","CIN","p1",   "VDD"),
    ("Mp0_3",  3*pitch, "B", "p2", "CB",   "VDD"),
    ("Mp0_4",  4*pitch, "A", "VDD","p2",   "VDD"),
    ("Mp0_5",  5*pitch, "A", "p3", "VDD",  "VDD"),
    ("Mp0_6",  6*pitch, "B", "VDD","p3",   "VDD"),
    ("Mp0_7",  7*pitch, "CIN","p3","VDD",  "VDD"),
    ("Mp0_8",  8*pitch, "SB","CB","p3",    "VDD"),
    ("Mp0_9",  9*pitch, "CIN","p5","SB",   "VDD"),
    ("Mp0_10",10*pitch, "B", "p4","p5",    "VDD"),
    ("Mp0_11",11*pitch, "A", "VDD","p4",   "VDD"),
    ("Mp0_12",12*pitch, "CB","COUT","VDD", "VDD"),
    ("Mp14",  13*pitch, "SB","VDD","SUM",  "VDD"),
]

for name, x, g, s, d, b in pmos_list:
    add_mos(fa, x, pmos_y, 0.84, 0.15, g, s, d, b, True, contacts)

# ------------------------------------------------------------------
# nwell around PMOS row
# ------------------------------------------------------------------
nwell_x = -0.5
nwell_w = 14*pitch + 1.0
nwell_y = pmos_y - 0.5
nwell_h = row_h + 1.0
box(fa, L("nwell"), nwell_x, nwell_y, nwell_x + nwell_w, nwell_y + nwell_h)
# nwell tap contact (tie to VDD)
contact_stack(fa, nwell_x + 0.5, nwell_y + 0.5, TECH["cuts"]["licon"]["size"])
contacts.setdefault("VDD", []).append((nwell_x + 0.5, nwell_y + 0.5, "m1"))

# ------------------------------------------------------------------
# Route all nets with m1
# ------------------------------------------------------------------
# Assign each net a horizontal track. We have ~20 nets, cell height 14 um.
# Use tracks spaced by 1.0 um starting at y=0.5.
net_list = sorted(contacts.keys())
track_pitch = 1.0
track_start = 0.5
for i, net in enumerate(net_list):
    track_y = track_start + i * track_pitch
    if track_y > cell_h - 0.5:
        track_y = cell_h - 0.5
    route_net(fa, net, contacts[net], track_y)

# ------------------------------------------------------------------
# Place pins on the left side of the cell (inputs) and right side (outputs)
# ------------------------------------------------------------------
pin_y = 0.5
pin_spacing = 1.0
# inputs: A, B, CIN
for idx, pin in enumerate(["A", "B", "CIN"]):
    place_pin(fa, pin, -0.5, pin_y + idx * pin_spacing)
# outputs: SUM, COUT
for idx, pin in enumerate(["SUM", "COUT"]):
    place_pin(fa, pin, cell_w + 0.5, pin_y + idx * pin_spacing)
# supplies
place_pin(fa, "VDD", cell_w/2.0, cell_h + 0.5)
place_pin(fa, "VSS", cell_w/2.0, -0.5)

# ------------------------------------------------------------------------------
# Top cell: rca8
# ------------------------------------------------------------------------------
top = ly.create_cell("rca8")

# place 8 full adders in a row
fa_w = cell_w + 2.0   # add some spacing
fa_h = cell_h + 2.0
for i in range(8):
    x = i * fa_w
    top.insert(kdb.DCellInstArray(fa.cell_index(), kdb.DTrans(x, 0.0)))

# ------------------------------------------------------------------
# Top-level routing: power rails and carry chain
# ------------------------------------------------------------------
# VDD and VSS rails run vertically on m2 at left and right edges
rail_x_left = -1.0
rail_x_right = 8 * fa_w + 1.0
rail_y_bottom = -1.0
rail_y_top = fa_h + 1.0
box(top, m2_l, rail_x_left - 0.3, rail_y_bottom, rail_x_left + 0.3, rail_y_top)
box(top, m2_l, rail_x_right - 0.3, rail_y_bottom, rail_x_right + 0.3, rail_y_top)

# connect each FA's VDD/VSS to the rails with m1 vertical segments
for i in range(8):
    x = i * fa_w + fa_w / 2.0
    # VDD
    box(top, m1_l, x - 0.07, fa_h + 0.5, x + 0.07, rail_y_top)
    # VSS
    box(top, m1_l, x - 0.07, rail_y_bottom, x + 0.07, -0.5)

# carry chain: route COUT of stage i to CIN of stage i+1 on m2
for i in range(7):
    x1 = i * fa_w + fa_w + 0.5
    x2 = (i + 1) * fa_w - 0.5
    y = fa_h / 2.0
    box(top, m2_l, x1, y - 0.07, x2, y + 0.07)
    # vias to m1 at ends
    box(top, via_l, x1 - 0.075, y - 0.075, x1 + 0.075, y + 0.075)
    box(top, via_l, x2 - 0.075, y - 0.075, x2 + 0.075, y + 0.075)

# ------------------------------------------------------------------
# Top-level pins
# ------------------------------------------------------------------------------
pin_y_top = rail_y_top + 0.5
pin_spacing = 1.0
# supplies
place_pin(top, "VDD", rail_x_left, pin_y_top, layer=m2_l, lab_layer=m1_lab_l, size=0.2)
place_pin(top, "VSS", rail_x_right, pin_y_top, layer=m2_l, lab_layer=m1_lab_l, size=0.2)

# inputs A0..A7, B0..B7, CIN
for i in range(8):
    place_pin(top, f"A{i}", i * fa_w + fa_w/2.0, rail_y_bottom - 1.0, layer=m1_l, lab_layer=m1_lab_l)
    place_pin(top, f"B{i}", i * fa_w + fa_w/2.0, rail_y_bottom - 2.0, layer=m1_l, lab_layer=m1_lab_l)
place_pin(top, "CIN", rail_x_left - 2.0, fa_h/2.0, layer=m2_l, lab_layer=m1_lab_l, size=0.2)

# outputs COUT, S0..S7
place_pin(top, "COUT", rail_x_right + 2.0, fa_h/2.0, layer=m2_l, lab_layer=m1_lab_l, size=0.2)
for i in range(8):
    place_pin(top, f"S{i}", i * fa_w + fa_w/2.0, rail_y_top + 1.0, layer=m1_l, lab_layer=m1_lab_l)

# ------------------------------------------------------------------------------
# Write GDS
# ------------------------------------------------------------------------------
ly.write("rca8.gds")
print("rca8.gds written")
