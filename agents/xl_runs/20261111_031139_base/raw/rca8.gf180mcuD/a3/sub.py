import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data for gf180mcuD (all values in micrometres)
# ---------------------------------------------------------------------------
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "pwell": (204, 0), "dnwell": (12, 0),
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0),
        "via2": (38, 0), "m3": (42, 0), "via3": (40, 0), "m4": (46, 0),
        "via4": (41, 0), "m5": (81, 0),
    },
    label={"poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10),
           "m4": (46, 10), "m5": (81, 10), "nwell": (21, 10), "pwell": (204, 10)},
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"diff": 0.22, "poly": 0.18, "m1": 0.23, "m2": 0.28, "m3": 0.28,
           "m4": 0.28, "m5": 0.44},
    space={
        ("diff", "diff"): 0.28, ("poly", "poly"): 0.24,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28,
        ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07),
        ("m1", "contact"): (0.005, 0.06), ("m1", "via1"): (0.0, 0.06),
        ("m2", "via1"): (0.01, 0.06),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
    ),
    devices={
        "nmos": dict(model="nfet_03v3", w=0.36, l=0.28, bulk="VSS"),
        "pmos": dict(model="pfet_03v3", w=0.72, l=0.28, bulk="VDD"),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------------------
# Derived layout constants
# ---------------------------------------------------------------------------
G = TECH["grid"]                      # 0.005 um grid
def snap(x):
    return round(x / G) * G

CONTACT = TECH["cuts"]["contact"]
CE_M1_OPP = snap(TECH["enc"]["m1", "contact"][1])   # 0.06
POLY_L = snap(TECH["devices"]["nmos"]["l"])         # 0.28
POLY_ENDCAP = snap(TECH["rules"]["poly_endcap"])    # 0.22
DIFF_EXT_GATE = snap(TECH["rules"]["diff_ext_gate"])# 0.23

M1W = snap(TECH["width"]["m1"])       # 0.23
M2W = snap(TECH["width"]["m2"])       # 0.28

# via cut size lookup by metal pair
VIA_CUT = {
    ("m1", "m2"): TECH["cuts"]["via1"],
    ("m2", "m3"): TECH["cuts"]["via2"],
    ("m3", "m4"): TECH["cuts"]["via3"],
    ("m4", "m5"): TECH["cuts"]["via4"],
}
VIA_LAYER = {
    ("m1", "m2"): "via1",
    ("m2", "m3"): "via2",
    ("m3", "m4"): "via3",
    ("m4", "m5"): "via4",
}

# ---------------------------------------------------------------------------
# Layout helpers
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("rca8")

# layer handles
L = {}
for name, (g, dt) in TECH["layers"].items():
    L[name] = ly.layer(g, dt)
for name, (g, dt) in TECH["label"].items():
    L[name + "_label"] = ly.layer(g, dt)

def box(x1, y1, x2, y2):
    return kdb.DBox(snap(x1), snap(y1), snap(x2), snap(y2))

def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(box(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text,
        kdb.DTrans(kdb.DVector(snap(x), snap(y)))))

def contact(cell, x, y, lower="diff"):
    """Place a contact (0.22x0.22) centred at (x,y) on the given lower layer."""
    c = CONTACT
    half = c["size"] / 2.0
    rect(cell, L["contact"], x - half, y - half, x + half, y + half)
    rect(cell, L["m1"], x - CE_M1_OPP, y - CE_M1_OPP,
         x + CE_M1_OPP, y + CE_M1_OPP)

def via(cell, x, y, lower, upper):
    """Place a via between lower and upper metal layers centred at (x,y)."""
    key = (lower, upper)
    v = VIA_CUT[key]
    vl = VIA_LAYER[key]
    half = v["size"] / 2.0
    rect(cell, L[lower], x - half, y - half, x + half, y + half)
    rect(cell, L[upper], x - half, y - half, x + half, y + half)
    rect(cell, L[vl], x - half, y - half, x + half, y + half)

def m1_h(cell, x1, x2, y):
    rect(cell, L["m1"], x1, y - M1W / 2, x2, y + M1W / 2)

def m1_v(cell, y1, y2, x):
    rect(cell, L["m1"], x - M1W / 2, y1, x + M1W / 2, y2)

def m2_h(cell, x1, x2, y):
    rect(cell, L["m2"], x1, y - M2W / 2, x2, y + M2W / 2)

def m2_v(cell, y1, y2, x):
    rect(cell, L["m2"], x - M2W / 2, y1, x + M2W / 2, y2)

def poly_strip(cell, x1, x2, y1, y2):
    rect(cell, L["poly"], x1, y1, x2, y2)

def diff_rect(cell, x1, y1, x2, y2, nplus=False, pplus=False):
    rect(cell, L["diff"], x1, y1, x2, y2)
    if nplus:
        rect(cell, L["nplus"], x1, y1, x2, y2)
    if pplus:
        rect(cell, L["pplus"], x1, y1, x2, y2)

def pin(cell, net, x, y, layer="m1"):
    lbl = layer + "_label"
    label(cell, L[lbl], net, x, y)

# ---------------------------------------------------------------------------
# Full adder cell
# ---------------------------------------------------------------------------
fa = ly.create_cell("fa")

# Cell dimensions
FA_W = 46.0   # width
FA_H = 46.0   # height

# Row y-centres
NMOS_Y = 11.5
PMOS_Y = 34.5
ROW_H = 10.0

# Gate x-centres (pitch 0.76 um)
GATE_X = {}
x = 4.0
for sig in ["A", "B", "CIN", "CB", "SB"]:
    GATE_X[sig] = x
    x += 0.76

# Supply rails
m1_h(fa, 0.0, FA_W, 2.0)     # VSS rail
m1_h(fa, 0.0, FA_W, 44.0)    # VDD rail
pin(fa, "VSS", 2.0, 2.0)
pin(fa, "VDD", 2.0, 44.0)

# Input pins on M1 (left side)
m1_v(fa, 0.0, FA_H, 1.0)
pin(fa, "A", 1.0, 6.0)
pin(fa, "B", 1.0, 14.0)
pin(fa, "CIN", 1.0, 22.0)

# Output pins on M1 (right side)
m1_v(fa, 0.0, FA_H, FA_W - 1.0)
pin(fa, "SUM", FA_W - 1.0, 30.0)
pin(fa, "COUT", FA_W - 1.0, 38.0)

# ---------------------------------------------------------------------------
# Build NMOS network (bottom row)
# ---------------------------------------------------------------------------
nmos_list = [
    # (name, gate, source, drain)
    ("n0", "A", "VSS", "n1"),
    ("n1", "B", "n1", "VSS"),
    ("n2", "CIN", "CB", "n1"),
    ("n3", "B", "n2", "CB"),
    ("n4", "A", "VSS", "n2"),
    ("n5", "A", "n3", "VSS"),
    ("n6", "B", "VSS", "n3"),
    ("n7", "CIN", "n3", "VSS"),
    ("n8", "CB", "SB", "n3"),
    ("n9", "CIN", "n5", "SB"),
    ("n10", "B", "n4", "n5"),
    ("n11", "A", "VSS", "n4"),
    ("n12", "CB", "COUT", "VSS"),
    ("n14", "SB", "VSS", "SUM"),
]

n_x = 4.0
for name, gate, src, drn in nmos_list:
    gx = GATE_X[gate]
    w = TECH["devices"]["nmos"]["w"]
    half_w = w / 2.0
    # diffusion rectangle
    diff_rect(fa, n_x - half_w, NMOS_Y - ROW_H / 2,
              n_x + half_w, NMOS_Y + ROW_H / 2, nplus=True)
    # gate poly (vertical strip crossing diffusion)
    poly_strip(fa, gx - POLY_L / 2, gx + POLY_L / 2,
               NMOS_Y - ROW_H / 2 - POLY_ENDCAP,
               NMOS_Y + ROW_H / 2 + POLY_ENDCAP)
    # source contact
    sx = n_x - half_w + DIFF_EXT_GATE
    contact(fa, sx, NMOS_Y)
    m1_v(fa, NMOS_Y - ROW_H / 2, NMOS_Y + ROW_H / 2, sx)
    # drain contact
    dx = n_x + half_w - DIFF_EXT_GATE
    contact(fa, dx, NMOS_Y)
    m1_v(fa, NMOS_Y - ROW_H / 2, NMOS_Y + ROW_H / 2, dx)
    n_x += 1.6

# ---------------------------------------------------------------------------
# Build PMOS network (top row)
# ---------------------------------------------------------------------------
pmos_list = [
    # (name, gate, source, drain)
    ("p0", "A", "VDD", "p1"),
    ("p1", "B", "p1", "VDD"),
    ("p2", "CIN", "CB", "p1"),
    ("p3", "B", "p2", "CB"),
    ("p4", "A", "VDD", "p2"),
    ("p5", "A", "p3", "VDD"),
    ("p6", "B", "VDD", "p3"),
    ("p7", "CIN", "p3", "VDD"),
    ("p8", "CB", "SB", "p3"),
    ("p9", "CIN", "p5", "SB"),
    ("p10", "B", "p4", "p5"),
    ("p11", "A", "VDD", "p4"),
    ("p12", "CB", "COUT", "VDD"),
    ("p14", "SB", "VDD", "SUM"),
]

p_x = 4.0
for name, gate, src, drn in pmos_list:
    gx = GATE_X[gate]
    w = TECH["devices"]["pmos"]["w"]
    half_w = w / 2.0
    diff_rect(fa, p_x - half_w, PMOS_Y - ROW_H / 2,
              p_x + half_w, PMOS_Y + ROW_H / 2, pplus=True)
    poly_strip(fa, gx - POLY_L / 2, gx + POLY_L / 2,
               PMOS_Y - ROW_H / 2 - POLY_ENDCAP,
               PMOS_Y + ROW_H / 2 + POLY_ENDCAP)
    sx = p_x - half_w + DIFF_EXT_GATE
    contact(fa, sx, PMOS_Y)
    m1_v(fa, PMOS_Y - ROW_H / 2, PMOS_Y + ROW_H / 2, sx)
    dx = p_x + half_w - DIFF_EXT_GATE
    contact(fa, dx, PMOS_Y)
    m1_v(fa, PMOS_Y - ROW_H / 2, PMOS_Y + ROW_H / 2, dx)
    p_x += 1.6

# ---------------------------------------------------------------------------
# Route internal nets on M1 (horizontal segments at transistor rows)
# and M2 (vertical connections between rows and to pins)
# ---------------------------------------------------------------------------
# Net -> list of (x, y) contact points that must be connected
net_points = {
    "VSS": [], "VDD": [], "A": [], "B": [], "CIN": [],
    "n1": [], "n2": [], "n3": [], "n4": [], "n5": [],
    "p1": [], "p2": [], "p3": [], "p4": [], "p5": [],
    "CB": [], "SB": [], "SUM": [], "COUT": [],
}

# Collect contact points from transistors
n_x = 4.0
for name, gate, src, drn in nmos_list:
    gx = GATE_X[gate]
    w = TECH["devices"]["nmos"]["w"]
    half_w = w / 2.0
    sx = n_x - half_w + DIFF_EXT_GATE
    dx = n_x + half_w - DIFF_EXT_GATE
    net_points[src].append((sx, NMOS_Y))
    net_points[drn].append((dx, NMOS_Y))
    n_x += 1.6

p_x = 4.0
for name, gate, src, drn in pmos_list:
    gx = GATE_X[gate]
    w = TECH["devices"]["pmos"]["w"]
    half_w = w / 2.0
    sx = p_x - half_w + DIFF_EXT_GATE
    dx = p_x + half_w - DIFF_EXT_GATE
    net_points[src].append((sx, PMOS_Y))
    net_points[drn].append((dx, PMOS_Y))
    p_x += 1.6

# Add supply rail contacts
for x in range(4, int(FA_W), 4):
    net_points["VSS"].append((x, 2.0))
    net_points["VDD"].append((x, 44.0))

# Add input pin contacts
for sig, y in [("A", 6.0), ("B", 14.0), ("CIN", 22.0)]:
    net_points[sig].append((1.0, y))

# Add output pin contacts
net_points["SUM"].append((FA_W - 1.0, 30.0))
net_points["COUT"].append((FA_W - 1.0, 38.0))

# Route each net: connect all points with M1 horizontal + M2 vertical
def route_net(net, pts):
    if len(pts) < 2:
        return
    pts = sorted(set(pts))
    for i in range(len(pts) - 1):
        x1, y1 = pts[i]
        x2, y2 = pts[i + 1]
        m1_h(fa, x1, x2, y1)
        if y1 != y2:
            m2_v(fa, min(y1, y2), max(y1, y2), x2)
            via(fa, x2, y1, "m1", "m2")
            via(fa, x2, y2, "m1", "m2")

for net, pts in net_points.items():
    route_net(net, pts)

# ---------------------------------------------------------------------------
# Place full adder instances and chain carries
# ---------------------------------------------------------------------------
XPITCH = 50.0
YPITCH = 0.0

for i in range(8):
    top.insert(kdb.DCellInstArray(fa.cell_index(),
        kdb.DTrans(kdb.DVector(i * XPITCH, YPITCH))))

# Route carry chain and connect I/O pins on top level
for i in range(8):
    bx = i * XPITCH
    # A and B pins
    pin(top, f"A{i}", bx + 1.0, 6.0, "m1")
    pin(top, f"B{i}", bx + 1.0, 14.0, "m1")
    m1_v(top, 0.0, FA_H, bx + 1.0)
    # S pin
    pin(top, f"S{i}", bx + FA_W - 1.0, 30.0, "m1")
    m1_v(top, 0.0, FA_H, bx + FA_W - 1.0)

# CIN pin
pin(top, "CIN", 1.0, 22.0, "m1")
m1_v(top, 0.0, FA_H, 1.0)

# COUT pin
pin(top, "COUT", 7 * XPITCH + FA_W - 1.0, 38.0, "m1")
m1_v(top, 0.0, FA_H, 7 * XPITCH + FA_W - 1.0)

# VDD / VSS rails across top
m1_h(top, 0.0, 7 * XPITCH + FA_W, 2.0)
m1_h(top, 0.0, 7 * XPITCH + FA_W, 44.0)
pin(top, "VSS", 2.0, 2.0)
pin(top, "VDD", 2.0, 44.0)

# Carry chain: route COUT of stage i to CIN of stage i+1 on M2
for i in range(7):
    x1 = i * XPITCH + FA_W - 1.0
    x2 = (i + 1) * XPITCH + 1.0
    m2_h(top, x1, x2, 26.0)
    via(top, x1, 38.0, "m1", "m2")
    via(top, x2, 22.0, "m1", "m2")

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("rca8.gds")
print("Written rca8.gds")
print("Top cell bbox:", top.bbox())

