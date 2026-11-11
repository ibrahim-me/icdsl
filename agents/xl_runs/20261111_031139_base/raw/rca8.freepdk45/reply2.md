```
import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data for freepdk45 (from the task description)
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
via1_l   = layer("via1")
m2_l     = layer("m2")
boundary_l = layer("boundary")

# design rules (um)
DIFF_EXT_GATE = TECH["rules"]["diff_ext_gate"]
POLY_ENDCAP   = TECH["rules"]["poly_endcap"]
WELL_ENC      = TECH["rules"]["well_enc"]
CONTACT_SIZE  = 0.065
CONTACT_SPACE = 0.075
M1_WIDTH      = TECH["width"]["m1"]
M1_SPACE      = TECH["space"][("m1", "m1")]
M1_CONTACT_ENC= 0.035

def dbox(x1, y1, x2, y2):
    return kdb.DBox(x1, y1, x2, y2)

def add_rect(cell, lay, x1, y1, x2, y2):
    cell.shapes(lay).insert(dbox(x1, y1, x2, y2))

def add_label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(x, y)))

# ----------------------------------------------------------------------
# Transistor generator
# ----------------------------------------------------------------------
def draw_mos(cell, typ, x, y, w, l):
    """
    Draw a single MOS transistor.
    Returns dict with terminal centre coordinates (um) for source, drain, gate.
    """
    dev = TECH["devices"][typ]
    impl = dev["implant"]
    well = dev["well"]

    # diffusion rectangle (active)
    diff_w = l + 2 * DIFF_EXT_GATE   # x dimension
    diff_h = w                       # y dimension
    add_rect(cell, diff_l, x, y, x + diff_w, y + diff_h)

    # implant over diffusion
    impl_l = nplus_l if impl == "nplus" else pplus_l
    add_rect(cell, impl_l, x, y, x + diff_w, y + diff_h)

    # well around diffusion
    wl = pwell_l if well == "pwell" else nwell_l
    add_rect(cell, wl,
             x - WELL_ENC, y - WELL_ENC,
             x + diff_w + WELL_ENC, y + diff_h + WELL_ENC)

    # poly gate
    poly_x = x + DIFF_EXT_GATE
    poly_y = y - POLY_ENDCAP
    poly_w = l
    poly_h = w + 2 * POLY_ENDCAP
    add_rect(cell, poly_l, poly_x, poly_y, poly_x + poly_w, poly_y + poly_h)

    # contacts (source, drain, gate)
    c = CONTACT_SIZE
    enc = M1_CONTACT_ENC

    def contact_block(cx, cy):
        add_rect(cell, contact_l, cx, cy, cx + c, cy + c)
        add_rect(cell, m1_l, cx - enc, cy - enc, cx + c + enc, cy + c + enc)
        return (cx + c / 2.0, cy + c / 2.0)

    # source contact (left end of diffusion)
    s_cx = x + WELL_ENC
    s_cy = y + (diff_h - c) / 2.0
    src = contact_block(s_cx, s_cy)

    # drain contact (right end of diffusion)
    d_cx = x + diff_w - WELL_ENC - c
    d_cy = y + (diff_h - c) / 2.0
    drn = contact_block(d_cx, d_cy)

    # gate contact (centre of poly)
    g_cx = poly_x + (poly_w - c) / 2.0
    g_cy = poly_y + (poly_h - c) / 2.0
    gate = contact_block(g_cx, g_cy)

    return {"source": src, "drain": drn, "gate": gate}

# ----------------------------------------------------------------------
# Full adder cell (28 transistors, mirror style)
# ----------------------------------------------------------------------
def build_fa_cell(name):
    cell = ly.create_cell(name)

    # placement parameters
    row_h_nmos = 0.09
    row_h_pmos = 0.18
    row_y_nmos = 0.6
    row_y_pmos = 2.6
    col_pitch  = 0.30   # centre-to-centre of transistor columns

    # transistor list: (type, gate, source, drain, bulk)
    nmos_list = [
        ("nmos", "A",   "VSS", "n1",   "VSS"),
        ("nmos", "B",   "n1",  "VSS",  "VSS"),
        ("nmos", "CIN", "CB",  "n1",   "VSS"),
        ("nmos", "B",   "n2",  "CB",   "VSS"),
        ("nmos", "A",   "VSS", "n2",   "VSS"),
        ("nmos", "A",   "n3",  "VSS",  "VSS"),
        ("nmos", "B",   "VSS", "n3",   "VSS"),
        ("nmos", "CIN", "n3",  "VSS",  "VSS"),
        ("nmos", "CB",  "SB",  "n3",   "VSS"),
        ("nmos", "CIN", "n5",  "SB",   "VSS"),
        ("nmos", "B",   "n4",  "n5",   "VSS"),
        ("nmos", "A",   "VSS", "n4",   "VSS"),
        ("nmos", "CB",  "COUT","VSS",  "VSS"),
        ("nmos", "SUM", "VSS", "SUM",  "VSS"),
    ]
    pmos_list = [
        ("pmos", "A",   "VDD", "p1",   "VDD"),
        ("pmos", "B",   "p1",  "VDD",  "VDD"),
        ("pmos", "CIN", "CB",  "p1",   "VDD"),
        ("pmos", "B",   "p2",  "CB",   "VDD"),
        ("pmos", "A",   "VDD", "p2",   "VDD"),
        ("pmos", "A",   "p3",  "VDD",  "VDD"),
        ("pmos", "B",   "VDD", "p3",   "VDD"),
        ("pmos", "CIN", "p3",  "VDD",  "VDD"),
        ("pmos", "CB",  "SB",  "p3",   "VDD"),
        ("pmos", "CIN", "p5",  "SB",   "VDD"),
        ("pmos", "B",   "p4",  "p5",   "VDD"),
        ("pmos", "A",   "VDD", "p4",   "VDD"),
        ("pmos", "CB",  "COUT","VDD",  "VDD"),
        ("pmos", "SUM", "VDD", "SUM",  "VDD"),
    ]

    # place transistors and collect terminals per net
    terminals = {}   # net name -> list of (x, y, kind)
    def add_term(net, xy, kind):
        terminals.setdefault(net, []).append((xy, kind))

    x_cursor = 0.2
    for typ, gate, src, drn, bulk in nmos_list:
        t = draw_mos(cell, typ, x_cursor, row_y_nmos,
                     TECH["devices"]["nmos"]["w"],
                     TECH["devices"]["nmos"]["l"])
        add_term(gate, t["gate"], "gate")
        add_term(src,  t["source"], "src")
        add_term(drn,  t["drain"],  "drn")
        x_cursor += col_pitch

    x_cursor = 0.2
    for typ, gate, src, drn, bulk in pmos_list:
        t = draw_mos(cell, typ, x_cursor, row_y_pmos,
                     TECH["devices"]["pmos"]["w"],
                     TECH["devices"]["pmos"]["l"])
        add_term(gate, t["gate"], "gate")
        add_term(src,  t["source"], "src")
        add_term(drn,  t["drain"],  "drn")
        x_cursor += col_pitch

    cell_width = x_cursor + 0.2
    cell_height = row_y_pmos + row_h_pmos + 0.6

    # ------------------------------------------------------------------
    # Power rails (metal1)
    # ------------------------------------------------------------------
    vss_y = 0.1
    vdd_y = cell_height - 0.1
    add_rect(cell, m1_l, 0.0, vss_y - M1_WIDTH/2, cell_width, vss_y + M1_WIDTH/2)
    add_rect(cell, m1_l, 0.0, vdd_y - M1_WIDTH/2, cell_width, vdd_y + M1_WIDTH/2)
    add_label(cell, m1lab_l, "VSS", cell_width/2, vss_y)
    add_label(cell, m1lab_l, "VDD", cell_width/2, vdd_y)

    # connect all VSS/VSS terminals to VSS rail, VDD to VDD rail
    def connect_net_to_rail(net, rail_y):
        if net not in terminals:
            return
        for (xy, kind) in terminals[net]:
            x = xy[0]
            y1 = min(xy[1], rail_y)
            y2 = max(xy[1], rail_y)
            add_rect(cell, m1_l, x - M1_WIDTH/2, y1, x + M1_WIDTH/2, y2)

    connect_net_to_rail("VSS", vss_y)
    connect_net_to_rail("VDD", vdd_y)

    # ------------------------------------------------------------------
    # Route remaining nets on metal1 (bounding box around terminals)
    # ------------------------------------------------------------------
    route_nets = ["A", "B", "CIN", "COUT", "SUM", "n1", "n2", "n3", "n4", "n5",
                  "p1", "p2", "p3", "p4", "p5", "CB", "SB"]
    for net in route_nets:
        if net not in terminals:
            continue
        pts = [xy for (xy, kind) in terminals[net]]
        if not pts:
            continue
        xs = [p[0] for p in pts]
        ys = [p[1] for p in pts]
        x_min, x_max = min(xs), max(xs)
        y_min, y_max = min(ys), max(ys)
        add_rect(cell, m1_l, x_min - M1_WIDTH/2, y_min - M1_WIDTH/2,
                 x_max + M1_WIDTH/2, y_max + M1_WIDTH/2)

    # ------------------------------------------------------------------
    # Pin labels on m1 label layer
    # ------------------------------------------------------------------
    for net, plist in terminals.items():
        if plist:
            px, py = plist[0][0]
            add_label(cell, m1lab_l, net, px, py)

    # boundary
    add_rect(cell, boundary_l, 0, 0, cell_width, cell_height)

    return cell, cell_width, cell_height

# ----------------------------------------------------------------------
# Build full adder cell
# ------------------------------------------------------------------
fa_cell, fa_w, fa_h = build_fa_cell("fa")

# ----------------------------------------------------------------------
# Top cell rca8
# ------------------------------------------------------------------
top = ly.create_cell("rca8")

# place 8 full adders in a row
pitch_x = fa_w + 0.2
for i in range(8):
    top.insert(kdb.DCellInstArray(fa_cell.cell_index(),
                                  kdb.DTrans(i * pitch_x, 0.0)))

# top-level pins (metal1 labels)
rail_y = fa_h - 0.1
add_rect(top, m1_l, 0.0, rail_y - M1_WIDTH/2, 8 * pitch_x, rail_y + M1_WIDTH/2)
add_label(top, m1lab_l, "VDD", 4 * pitch_x, rail_y)
add_rect(top, m1_l, 0.0, 0.1 - M1_WIDTH/2, 8 * pitch_x, 0.1 + M1_WIDTH/2)
add_label(top, m1lab_l, "VSS", 4 * pitch_x, 0.1)

for i in range(8):
    add_label(top, m1lab_l, f"A{i}", 0.1, 0.5 + i * 0.4)
    add_label(top, m1lab_l, f"B{i}", 0.1, 0.7 + i * 0.4)
    add_label(top, m1lab_l, f"S{i}", 8 * pitch_x - 0.1, 0.5 + i * 0.4)

add_label(top, m1lab_l, "CIN", 0.1, 4.0)
add_label(top, m1lab_l, "COUT", 8 * pitch_x - 0.1, 4.0)

# boundary for top cell
add_rect(top, boundary_l, 0, 0, 8 * pitch_x, fa_h)

# ----------------------------------------------------------------------
# Write GDS
# ------------------------------------------------------------------
ly.write("rca8.gds")
print("Written rca8.gds, top cell:", top.name, "size um:", 8 * pitch_x, "x", fa_h)
```