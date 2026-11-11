import klayout.db as kdb

# ---------------------------------------------------------------- PDK (gf180mcuD)
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "pwell": (204, 0), "dnwell": (12, 0),
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0), "sab": (49, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0), "via2": (38, 0), "m3": (42, 0),
        "via3": (40, 0), "m4": (46, 0), "via4": (41, 0), "m5": (81, 0),
        "capm": (75, 0), "cap_mk": (117, 5), "res_mk": (110, 5), "sab": (49, 0),
        "m1res": (110, 11), "boundary": (0, 0),
    },
    label={"m1": (34, 10)},
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
    },
    width={"diff": 0.22, "poly": 0.18, "nplus": 0.40, "pplus": 0.40, "m1": 0.23, "m2": 0.28},
    space={
        ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("nplus", "nplus"): 0.40, ("pplus", "pplus"): 0.40,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        gate_space=0.24,
    ),
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------- geometry helpers
def dbu_up(um, dbu):
    return int(round(um / dbu))

def dbox(ly, cell, x1, y1, x2, y2, layer):
    cell.shapes(ly.layer(*layer)).insert(kdb.DBox(x1, y1, x2, y2))

def dtext(ly, cell, text, x, y, layer):
    cell.shapes(ly.layer(*layer)).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(ly, cell, cx, cy, layer_stack, cs=0.22):
    """contact on lower layer (diff/poly) with m1 on top, centered at (cx,cy)."""
    c = TECH["cuts"]["contact"]
    hs = c["size"] / 2.0
    me = TECH["enc"]["m1", "contact"]
    m1x = c["size"] + 2 * me[1]
    m1y = c["size"] + 2 * me[0]
    dbox(ly, cell, cx - hs, cy - hs, cx + hs, cy + hs, layer_stack[0])
    dbox(ly, cell, cx - m1x / 2, cy - m1y / 2, cx + m1x / 2, cy + m1y / 2, layer_stack[1])

# ---------------------------------------------------------------- build
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("r2r8")

L = 6.0          # resistor length (um)
W = 1.0          # resistor width (um)
PITCH = 7.0      # centre-to-centre pitch of unit cells (um)
HALF_P = PITCH / 2.0
EXT = 0.30       # pplus extension beyond poly ends (um)
CONTACT_OFF = 0.25   # contact offset from poly end (um)
CONTACT_YOFF = 0.20  # contact offset from poly centre line (um)
M1W = 2.6        # m1 segment width (um)
M1H = 0.23       # m1 segment height (um)
ROW_H = 10.0     # row height (um)
COL_W = 7.0      # column width (um)

# resistor: poly body, res_mk marker, sab block, pplus heads, two m1 contacts
def res_unit(cell, cx, cy):
    dbox(ly, cell, cx - L / 2, cy - W / 2, cx + L / 2, cy + W / 2, TECH["layers"]["poly"])
    dbox(ly, cell, cx - L / 2, cy - W / 2, cx + L / 2, cy + W / 2, TECH["layers"]["res_mk"])
    dbox(ly, cell, cx - L / 2 - 0.28, cy - W / 2 - 0.28,
         cx + L / 2 + 0.28, cy + W / 2 + 0.28, TECH["layers"]["sab"])
    dbox(ly, cell, cx - L / 2 - EXT, cy - W / 2 - EXT,
         cx - L / 2 + EXT, cy + W / 2 + EXT, TECH["layers"]["pplus"])
    dbox(ly, cell, cx + L / 2 - EXT, cy - W / 2 - EXT,
         cx + L / 2 + EXT, cy + W / 2 + EXT, TECH["layers"]["pplus"])
    contact(ly, cell, cx - L / 2 + CONTACT_OFF, cy - CONTACT_YOFF,
            (TECH["layers"]["poly"], TECH["layers"]["m1"]))
    contact(ly, cell, cx + L / 2 - CONTACT_OFF, cy + CONTACT_YOFF,
            (TECH["layers"]["poly"], TECH["layers"]["m1"]))

# m1 segment between two contact centres (with via1 pads at both ends)
def m1_seg(cell, x1, y1, x2, y2):
    dx = x2 - x1
    dy = y2 - y1
    length = ((dx * dx) + (dy * dy)) ** 0.5
    if length < 1e-9:
        return
    ux = dx / length
    uy = dy / length
    nx = -uy
    ny = ux
    hw = M1W / 2.0
    hh = M1H / 2.0
    half = length / 2.0
    mx = (x1 + x2) / 2.0
    my = (y1 + y2) / 2.0
    pts = [
        (mx - ux * half - nx * hw, my - uy * half - ny * hw),
        (mx + ux * half - nx * hw, my + uy * half - ny * hw),
        (mx + ux * half + nx * hw, my + uy * half + ny * hw),
        (mx - ux * half + nx * hw, my - uy * half + ny * hw),
    ]
    cell.shapes(ly.layer(*TECH["layers"]["m1"])).insert(
        kdb.DPolygon([kdb.DPoint(p[0], p[1]) for p in pts]))
    dbox(ly, cell, x1 - hh, y1 - hh, x1 + hh, y1 + hh, TECH["layers"]["m1"])
    dbox(ly, cell, x2 - hh, y2 - hh, x2 + hh, y2 + hh, TECH["layers"]["m1"])

# ---------------------------------------------------------------- place 25 unit resistors
# (name, end1_node, end2_node, cell_x, cell_y)
units = [
    ("RT1", "VSS", "t",   0.0, 0.0),
    ("RT2", "n0",  "t",   PITCH, 0.0),
    ("RA0", "n0",  "x0",  PITCH, ROW_H),
    ("RB0", "B0",  "x0",  0.0,   ROW_H),
    ("RS0", "n0",  "n1",  2 * PITCH, ROW_H),
    ("RA1", "n1",  "x1",  3 * PITCH, ROW_H),
    ("RB1", "B1",  "x1",  2 * PITCH, ROW_H),
    ("RS1", "n1",  "n2",  4 * PITCH, ROW_H),
    ("RA2", "n2",  "x2",  5 * PITCH, ROW_H),
    ("RB2", "B2",  "x2",  4 * PITCH, ROW_H),
    ("RS2", "n2",  "n3",  6 * PITCH, ROW_H),
    ("RA3", "n3",  "x3",  7 * PITCH, ROW_H),
    ("RB3", "B3",  "x3",  6 * PITCH, ROW_H),
    ("RS3", "n3",  "n4",  8 * PITCH, ROW_H),
    ("RA4", "n4",  "x4",  9 * PITCH, ROW_H),
    ("RB4", "B4",  "x4",  8 * PITCH, ROW_H),
    ("RS4", "n4",  "n5",  10 * PITCH, ROW_H),
    ("RA5", "n5",  "x5",  11 * PITCH, ROW_H),
    ("RB5", "B5",  "x5",  10 * PITCH, ROW_H),
    ("RS5", "n5",  "n6",  12 * PITCH, ROW_H),
    ("RA6", "n6",  "x6",  13 * PITCH, ROW_H),
    ("RB6", "B6",  "x6",  12 * PITCH, ROW_H),
    ("RS6", "n6",  "OUT", 14 * PITCH, ROW_H),
    ("RA7", "OUT", "x7",  15 * PITCH, ROW_H),
    ("RB7", "B7",  "x7",  14 * PITCH, ROW_H),
]

unit_info = {}
for name, n1, n2, cx, cy in units:
    res_unit(top, cx, cy)
    unit_info[name] = (cx, cy, n1, n2)

# ---------------------------------------------------------------- interconnect
def node_point(node):
    if node == "VSS":
        return (0.0, -ROW_H)
    for name, cx, cy, a, b in [(k,) + v for k, v in unit_info.items() for k in [k]]:
        pass
    for name, (cx, cy, a, b) in unit_info.items():
        if node == a:
            return (cx - L / 2 + CONTACT_OFF, cy - CONTACT_YOFF)
        if node == b:
            return (cx + L / 2 - CONTACT_OFF, cy + CONTACT_YOFF)
    raise ValueError("unknown node " + node)

# VSS rail: m1 from x=0 to x=14*PITCH at y=-ROW_H, plus contact to RT1 poly contact
rail_x0 = 0.0
rail_x1 = 14 * PITCH
rail_y = -ROW_H
dbox(ly, top, rail_x0 - M1W / 2, rail_y - M1H / 2, rail_x1 + M1W / 2, rail_y + M1H / 2,
     TECH["layers"]["m1"])
# contact from RT1 left contact (VSS end) down to rail
rt1_cx, rt1_cy, _, _ = unit_info["RT1"]
vss_contact_pt = (rt1_cx - L / 2 + CONTACT_OFF, rt1_cy - CONTACT_YOFF)
dbox(ly, top, vss_contact_pt[0] - M1H / 2, vss_contact_pt[1] - M1H / 2,
     vss_contact_pt[0] + M1H / 2, vss_contact_pt[1] + M1H / 2, TECH["layers"]["m1"])
m1_seg(top, vss_contact_pt[0], vss_contact_pt[1], vss_contact_pt[0], rail_y)

# connect every resistor end that is VSS to the rail
for name, (cx, cy, a, b) in unit_info.items():
    for node in (a, b):
        if node == "VSS":
            px, py = node_point(node)
            m1_seg(top, px, py, px, rail_y)

# bit inputs B0..B7 : vertical m1 at x = cell cx, from contact up to y = ROW_H + M1W
for i in range(8):
    name = "RB%d" % i
    cx, cy, a, b = unit_info[name]
    px, py = node_point("B%d" % i)
    top_y = ROW_H + M1W
    dbox(ly, top, cx - M1H / 2, py, cx + M1H / 2, top_y, TECH["layers"]["m1"])
    dtext(ly, top, "B%d" % i, cx, top_y + 0.3, TECH["label"]["m1"])

# OUT : vertical m1 at x = 14*PITCH (RS6 right contact), up from contact
out_cx, out_cy, _, _ = unit_info["RS6"]
out_px, out_py = node_point("OUT")
dbox(ly, top, out_cx - M1H / 2, out_py, out_cx + M1H / 2, ROW_H + M1W, TECH["layers"]["m1"])
dtext(ly, top, "OUT", out_cx, ROW_H + M1W + 0.3, TECH["label"]["m1"])

# VSS pin : label on the rail
dtext(ly, top, "VSS", rail_x0 - 1.0, rail_y, TECH["label"]["m1"])

# series resistors RS0..RS6 : horizontal m1 between left and right contacts
for i in range(7):
    name = "RS%d" % i
    cx, cy, a, b = unit_info[name]
    p1 = node_point(a)
    p2 = node_point(b)
    m1_seg(top, p1[0], p1[1], p2[0], p2[1])

# ---------------------------------------------------------------- write
ly.write("r2r8.gds")
print("written r2r8.gds")