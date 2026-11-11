import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data for freepdk45
# ----------------------------------------------------------------------
TECH = dict(
    name="freepdk45",
    grid=0.005,
    gds_dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0),
        "nplus": (4, 0), "pplus": (5, 0),
        "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0),
        "boundary": (235, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    width={"diff": 0.09, "poly": 0.05, "m1": 0.065, "m2": 0.07},
    space={
        ("diff", "diff"): 0.08, ("poly", "poly"): 0.075,
        ("m1", "m1"): 0.065, ("m2", "m2"): 0.07,
    },
    enc={
        ("diff", "contact"): (0.005, 0.005),
        ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035),
        ("pplus", "diff"): (0.035, 0.035),
        ("pwell", "diff"): (0.055, 0.055),
        ("nwell", "diff"): (0.055, 0.055),
    },
    rules=dict(
        gate_contact_space=0.035,
        poly_endcap=0.055,
        diff_ext_gate=0.07,
        well_enc=0.055,
    ),
    devices={
        "nmos": dict(type="mos", model="nmos", diff="diff", implant="nplus",
                     well="pwell", w=0.09, l=0.05),
        "pmos": dict(type="mos", model="pmos", diff="diff", implant="pplus",
                     well="nwell", w=0.18, l=0.05),
    },
)

# ----------------------------------------------------------------------
# Layout helpers
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

diff_l   = layer("diff")
pwell_l  = layer("pwell")
nwell_l  = layer("nwell")
nplus_l  = layer("nplus")
pplus_l  = layer("pplus")
poly_l   = layer("poly")
contact_l= layer("contact")
m1_l     = layer("m1")
_m1lab_gds, _m1lab_dt = TECH["label"]["m1"]
m1lab_l  = ly.layer(_m1lab_gds, _m1lab_dt)
m2_l     = layer("m2")
boundary_l = layer("boundary")

# Design rules (um)
C = 0.065          # contact size
CS = 0.075         # contact spacing
M1W = 0.065        # metal1 width
M1S = 0.065        # metal1 spacing
M1ENC = 0.035      # m1 enclosure of contact
DIFF_EXT = 0.07    # diffusion past gate
POLY_ENDCAP = 0.055 # poly past diff
WELL_ENC = 0.055   # well enclosure of diff
GATE_CS = 0.035    # contact on active to gate

def dbox(x1, y1, x2, y2):
    if x2 < x1: x1, x2 = x2, x1
    if y2 < y1: y1, y2 = y2, y1
    return kdb.DBox(x1, y1, x2, y2)

def add_rect(cell, lay, x1, y1, x2, y2):
    cell.shapes(lay).insert(dbox(x1, y1, x2, y2))

def add_label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(x, y)))

def add_contact(cell, cx, cy):
    """Add contact (0.065x0.065) with m1 enclosure. Returns center."""
    add_rect(cell, contact_l, cx, cy, cx + C, cy + C)
    add_rect(cell, m1_l, cx - M1ENC, cy - M1ENC, cx + C + M1ENC, cy + C + M1ENC)
    return (cx + C / 2.0, cy + C / 2.0)

# ----------------------------------------------------------------------
# Transistor generator - shared diffusion style
# ----------------------------------------------------------------------
def draw_mos(cell, typ, x, y, w, l, gate_overlap=0.055):
    """
    Draw MOS transistor with source/drain contacts.
    x,y = bottom-left of diffusion
    w = diffusion height (gate width direction)
    l = gate length (current flow direction)
    Returns dict with terminal centers.
    """
    dev = TECH["devices"][typ]
    impl = dev["implant"]
    well = dev["well"]

    # Diffusion: extends past gate on both sides
    diff_w = l + 2 * DIFF_EXT
    diff_h = w
    add_rect(cell, diff_l, x, y, x + diff_w, y + diff_h)

    # Implant over diffusion
    impl_l = nplus_l if impl == "nplus" else pplus_l
    add_rect(cell, impl_l, x, y, x + diff_w, y + diff_h)

    # Well around diffusion
    wl = pwell_l if well == "pwell" else nwell_l
    add_rect(cell, wl,
             x - WELL_ENC, y - WELL_ENC,
             x + diff_w + WELL_ENC, y + diff_h + WELL_ENC)

    # Poly gate (crosses diffusion, extends past diff edges)
    poly_x = x + DIFF_EXT - l / 2.0   # center gate in diffusion
    poly_y = y - POLY_ENDCAP
    poly_w = l
    poly_h = w + 2 * POLY_ENDCAP
    add_rect(cell, poly_l, poly_x, poly_y, poly_x + poly_w, poly_y + poly_h)

    # Contacts
    # Source contact: left side of diffusion, away from gate
    s_cx = x + 0.008
    s_cy = y + (diff_h - C) / 2.0
    src = add_contact(cell, s_cx, s_cy)

    # Drain contact: right side of diffusion
    d_cx = x + diff_w - 0.008 - C
    d_cy = y + (diff_h - C) / 2.0
    drn = add_contact(cell, d_cx, d_cy)

    # Gate contact: on poly, centered
    g_cx = poly_x + (poly_w - C) / 2.0
    g_cy = poly_y + (poly_h - C) / 2.0
    gate = add_contact(cell, g_cx, g_cy)

    return {"source": src, "drain": drn, "gate": gate}

def draw_well_tap(cell, typ, x, y, w, h, rail_net, rail_y):
    """
    Draw a well tap: diffusion + implant + contact in the well,
    connected to the power rail.
    """
    dev = TECH["devices"][typ]
    impl = dev["implant"]
    well = dev["well"]

    # Tap diffusion
    add_rect(cell, diff_l, x, y, x + w, y + h)
    impl_l = nplus_l if impl == "nplus" else pplus_l
    add_rect(cell, impl_l, x, y, x + w, y + h)

    # Well around tap
    wl = pwell_l if well == "pwell" else nwell_l
    add_rect(cell, wl,
             x - WELL_ENC, y - WELL_ENC,
             x + w + WELL_ENC, y + h + WELL_ENC)

    # Contact on tap diffusion
    c = C
    tcx = x + (w - c) / 2.0
    tcy = y + (h - c) / 2.0
    tc = add_contact(cell, tcx, tcy)

    # Connect to rail
    add_rect(cell, m1_l, tcx - M1W/2, min(tcy, rail_y), tcx + M1W/2, max(tcy, rail_y))
    return tc

# ----------------------------------------------------------------------
# Full adder cell - compact standard cell style
# ----------------------------------------------------------------------
def build_fa_cell(name):
    cell = ly.create_cell(name)

    # Cell dimensions
    cell_w = 5.6
    cell_h = 4.2

    # Row positions
    vss_y = 0.20
    nmos_y = 0.55
    nmos_h = 0.09
    pmos_y = 2.65
    pmos_h = 0.18
    vdd_y = 3.95

    # Transistor pitch (must accommodate contact spacing)
    # Contact 0.065 + spacing 0.075 = 0.140 min center-to-center
    # But we also need gate contact and routing space
    pitch = 0.34

    # ------------------------------------------------------------------
    # Draw NMOS row (all in one pwell)
    # ------------------------------------------------------------------
    pwell_x = 0.0
    pwell_w = cell_w
    pwell_y = nmos_y - WELL_ENC
    pwell_h = nmos_h + 2 * WELL_ENC
    add_rect(cell, pwell_l, pwell_x, pwell_y, pwell_x + pwell_w, pwell_y + pwell_h)

    nmos_list = [
        ("A",   "VSS", "n1"),
        ("B",   "n1",  "VSS"),
        ("CIN", "CB",  "n1"),
        ("B",   "n2",  "CB"),
        ("A",   "VSS", "n2"),
        ("A",   "n3",  "VSS"),
        ("B",   "VSS", "n3"),
        ("CIN", "n3",  "VSS"),
        ("CB",  "SB",  "n3"),
        ("CIN", "n5",  "SB"),
        ("B",   "n4",  "n5"),
        ("A",   "VSS", "n4"),
        ("CB",  "COUT","VSS"),
        ("SUM", "VSS", "SUM"),
    ]

    nmos_terms = {}   # net -> list of (x, y, kind)
    def nterm(net, x, y, kind):
        nmos_terms.setdefault(net, []).append((x, y, kind))

    x_cursor = 0.17
    for gate, src, drn in nmos_list:
        t = draw_mos(cell, "nmos", x_cursor, nmos_y, nmos_h, 0.05)
        nterm(gate,  t["gate"][0],  t["gate"][1],  "gate")
        nterm(src,   t["source"][0], t["source"][1], "src")
        nterm(drn,   t["drain"][0],  t["drain"][1],  "drn")
        x_cursor += pitch

    # NMOS well tap (p+ in pwell, connect to VSS)
    tap_x = cell_w - 0.30
    draw_well_tap(cell, "nmos", tap_x, nmos_y - 0.02, 0.10, 0.13, "VSS", vss_y)
    nterm("VSS", tap_x + 0.05, nmos_y + 0.045, "bulk")

    # ------------------------------------------------------------------
    # Draw PMOS row (all in one nwell)
    # ------------------------------------------------------------------
    nwell_x = 0.0
    nwell_w = cell_w
    nwell_y = pmos_y - WELL_ENC
    nwell_h = pmos_h + 2 * WELL_ENC
    add_rect(cell, nwell_l, nwell_x, nwell_y, nwell_x + nwell_w, nwell_y + nwell_h)

    pmos_list = [
        ("A",   "VDD", "p1"),
        ("B",   "p1",  "VDD"),
        ("CIN", "CB",  "p1"),
        ("B",   "p2",  "CB"),
        ("A",   "VDD", "p2"),
        ("A",   "p3",  "VDD"),
        ("B",   "VDD", "p3"),
        ("CIN", "p3",  "VDD"),
        ("CB",  "SB",  "p3"),
        ("CIN", "p5",  "SB"),
        ("B",   "p4",  "p5"),
        ("A",   "VDD", "p4"),
        ("CB",  "COUT","VDD"),
        ("SUM", "VDD", "SUM"),
    ]

    pmos_terms = {}
    def pterm(net, x, y, kind):
        pmos_terms.setdefault(net, []).append((x, y, kind))

    x_cursor = 0.17
    for gate, src, drn in pmos_list:
        t = draw_mos(cell, "pmos", x_cursor, pmos_y, pmos_h, 0.05)
        pterm(gate,  t["gate"][0],  t["gate"][1],  "gate")
        pterm(src,   t["source"][0], t["source"][1], "src")
        pterm(drn,   t["drain"][0],  t["drain"][1],  "drn")
        x_cursor += pitch

    # PMOS well tap (n+ in nwell, connect to VDD)
    tap_x = cell_w - 0.30
    draw_well_tap(cell, "pmos", tap_x, pmos_y - 0.02, 0.10, 0.23, "VDD", vdd_y)
    pterm("VDD", tap_x + 0.05, pmos_y + 0.09, "bulk")

    # ------------------------------------------------------------------
    # Power rails
    # ------------------------------------------------------------------
    add_rect(cell, m1_l, 0.0, vss_y - M1W/2, cell_w, vss_y + M1W/2)
    add_rect(cell, m1_l, 0.0, vdd_y - M1W/2, cell_w, vdd_y + M1W/2)
    add_label(cell, m1lab_l, "VSS", cell_w/2, vss_y)
    add_label(cell, m1lab_l, "VDD", cell_w/2, vdd_y)

    # Connect VSS/VSS terms to VSS rail
    def connect_rail(terms, rail_y, rail_net):
        for net, pts in terms.items():
            if net != rail_net:
                continue
            seen = set()
            for (x, y, kind) in pts:
                xr = round(x, 3)
                if xr in seen:
                    continue
                seen.add(xr)
                add_rect(cell, m1_l, x - M1W/2, min(y, rail_y), x + M1W/2, max(y, rail_y))

    connect_rail(nmos_terms, vss_y, "VSS")
    connect_rail(pmos_terms, vdd_y, "VDD")

    # ------------------------------------------------------------------
    # Route signal nets on metal1
    # Use a horizontal track between the rows
    # ------------------------------------------------------------------
    route_y = 1.75   # between nmos and pmos rows
    all_terms = {}
    all_terms.update(nmos_terms)
    all_terms.update(pmos_terms)

    # Nets that need routing (not power)
    signal_nets = ["A", "B", "CIN", "COUT", "SUM", "n1", "n2", "n3", "n4", "n5",
                   "p1", "p2", "p3", "p4", "p5", "CB", "SB"]

    for net in signal_nets:
        if net not in all_terms:
            continue
        pts = all_terms[net]
        xs = [p[0] for p in pts]
        x_min, x_max = min(xs), max(xs)

        # Horizontal trunk
        add_rect(cell, m1_l, x_min - M1W/2, route_y - M1W/2,
                 x_max + M1W/2, route_y + M1W/2)

        # Vertical drops
        seen = set()
        for (x, y, kind) in pts:
            xr = round(x, 3)
            if xr in seen:
                continue
            seen.add(xr)
            y1 = min(y, route_y)
            y2 = max(y, route_y)
            add_rect(cell, m1_l, x - M1W/2, y1, x + M1W/2, y2)

    # ------------------------------------------------------------------
    # Pin labels (on m1 label layer)
    # ------------------------------------------------------------------
    for net, pts in all_terms.items():
        if pts:
            x, y, _ = pts[0]
            add_label(cell, m1lab_l, net, x, y)

    # Boundary
    add_rect(cell, boundary_l, 0, 0, cell_w, cell_h)

    return cell, cell_w, cell_h

# ----------------------------------------------------------------------
# Build full adder
# ------------------------------------------------------------------
fa_cell, fa_w, fa_h = build_fa_cell("fa")

# ----------------------------------------------------------------------
# Top cell rca8
# ------------------------------------------------------------------
top = ly.create_cell("rca8")

# Place 8 full adders in a row
pitch_x = fa_w + 0.15
for i in range(8):
    top.insert(kdb.DCellInstArray(fa_cell.cell_index(),
                                  kdb.DTrans(i * pitch_x, 0.0)))

# Top-level power rails
top_w = 8 * pitch_x
top_h = fa_h
vss_y = 0.20
vdd_y = fa_h - 0.20
add_rect(top, m1_l, 0.0, vss_y - M1W/2, top_w, vss_y + M1W/2)
add_rect(top, m1_l, 0.0, vdd_y - M1W/2, top_w, vdd_y + M1W/2)
add_label(top, m1lab_l, "VSS", top_w/2, vss_y)
add_label(top, m1lab_l, "VDD", top_w/2, vdd_y)

# Top-level input/output pins
pin_y_start = 0.55
pin_pitch = 0.40
for i in range(8):
    add_label(top, m1lab_l, f"A{i}", 0.12, pin_y_start + i * pin_pitch)
    add_label(top, m1lab_l, f"B{i}", 0.12, pin_y_start + i * pin_pitch + 0.15)
    add_label(top, m1lab_l, f"S{i}", top_w - 0.12, pin_y_start + i * pin_pitch)

add_label(top, m1lab_l, "CIN", 0.12, pin_y_start + 8 * pin_pitch)
add_label(top, m1lab_l, "COUT", top_w - 0.12, pin_y_start + 8 * pin_pitch)

# Boundary
add_rect(top, boundary_l, 0, 0, top_w, top_h)

# ----------------------------------------------------------------------
# Write GDS
# ------------------------------------------------------------------
ly.write("rca8.gds")
print("Written rca8.gds, size um:", top_w, "x", top_h, "= area", top_w * top_h, "um2")


