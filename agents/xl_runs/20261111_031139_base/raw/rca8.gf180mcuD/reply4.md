```
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK parameters for gf180mcuD (all values in micrometres)
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("rca8")

# Layer map (gds layer, datatype)
LAYER_MAP = {
    "nwell":   (21, 0),
    "diff":    (22, 0),
    "poly":    (30, 0),
    "nplus":   (32, 0),
    "pplus":   (31, 0),
    "contact": (33, 0),
    "m1":      (34, 0),
    "via1":    (35, 0),
    "m2":      (36, 0),
}
LABEL_MAP = {
    "poly":  (30, 10),
    "m1":    (34, 10),
    "m2":    (36, 10),
    "nwell": (21, 10),
}

L = {}
for name, (g, dt) in LAYER_MAP.items():
    L[name] = ly.layer(g, dt)
for name, (g, dt) in LABEL_MAP.items():
    L[name + "_lab"] = ly.layer(g, dt)

# ---------------------------------------------------------------------------
# Design rules (micrometres)
# ---------------------------------------------------------------------------
G = 0.005
def snap(x):
    return round(x / G) * G

CONTACT_SIZE   = 0.22
CONTACT_DIFF_ENC = 0.07
CONTACT_POLY_ENC = 0.07
CONTACT_M1_OPP   = 0.06   # m1 extends beyond contact on two opposite sides

VIA1_SIZE   = 0.26
VIA1_M1_ENC = 0.06
VIA1_M2_ENC = 0.06

POLY_WIDTH     = 0.18
POLY_ENDCAP    = 0.22
DIFF_EXT_GATE  = 0.23
GATE_CONTACT_SPACE = 0.15

M1_WIDTH = 0.23
M1_SPACE = 0.23
M2_WIDTH = 0.28
M2_SPACE = 0.28

# ---------------------------------------------------------------------------
# Cell dimensions
# ---------------------------------------------------------------------------
FA_W = 10.0
FA_H = 16.0

# ---------------------------------------------------------------------------
# Drawing helpers
# ---------------------------------------------------------------------------
def rect(cell, layer, x1, y1, x2, y2):
    cell.shapes(L[layer]).insert(kdb.DBox(snap(x1), snap(y1), snap(x2), snap(y2)))

def label(cell, layer, text, x, y):
    cell.shapes(L[layer + "_lab"]).insert(
        kdb.DText(text, kdb.DTrans(kdb.DVector(snap(x), snap(y)))))

def contact(cell, x, y, lower="diff"):
    """Contact on diff or poly, with m1 overlay."""
    hs = CONTACT_SIZE / 2
    rect(cell, "contact", x - hs, y - hs, x + hs, y + hs)
    rect(cell, "m1", x - CONTACT_M1_OPP, y - CONTACT_M1_OPP,
         x + CONTACT_M1_OPP, y + CONTACT_M1_OPP)

def via1(cell, x, y):
    """Via1 between m1 and m2."""
    hs = VIA1_SIZE / 2
    rect(cell, "m1", x - VIA1_M1_ENC, y - VIA1_M1_ENC,
         x + VIA1_M1_ENC, y + VIA1_M1_ENC)
    rect(cell, "m2", x - VIA1_M2_ENC, y - VIA1_M2_ENC,
         x + VIA1_M2_ENC, y + VIA1_M2_ENC)
    rect(cell, "via1", x - hs, y - hs, x + hs, y + hs)

def m1_h(cell, x1, x2, y):
    rect(cell, "m1", x1, y - M1_WIDTH / 2, x2, y + M1_WIDTH / 2)

def m1_v(cell, y1, y2, x):
    rect(cell, "m1", x - M1_WIDTH / 2, y1, x + M1_WIDTH / 2, y2)

def m2_h(cell, x1, x2, y):
    rect(cell, "m2", x1, y - M2_WIDTH / 2, x2, y + M2_WIDTH / 2)

def m2_v(cell, y1, y2, x):
    rect(cell, "m2", x - M2_WIDTH / 2, y1, x + M2_WIDTH / 2, y2)

def pin(cell, net, x, y, layer="m1"):
    label(cell, layer, net, x, y)

# ---------------------------------------------------------------------------
# Full adder cell
# ---------------------------------------------------------------------------
fa = ly.create_cell("fa")

# Power rails
m1_h(fa, 0.0, FA_W, 1.0)     # VSS
m1_h(fa, 0.0, FA_W, 15.0)    # VDD
pin(fa, "VSS", 1.0, 1.0)
pin(fa, "VDD", 1.0, 15.0)

# Input pins (left side, M1 vertical)
m1_v(fa, 0.0, FA_H, 1.0)
pin(fa, "A", 1.0, 4.0)
pin(fa, "B", 1.0, 8.0)
pin(fa, "CIN", 1.0, 12.0)

# Output pins (right side, M1 vertical)
m1_v(fa, 0.0, FA_H, FA_W - 1.0)
pin(fa, "SUM", FA_W - 1.0, 6.0)
pin(fa, "COUT", FA_W - 1.0, 10.0)

# ---------------------------------------------------------------------------
# Transistor placement
# ---------------------------------------------------------------------------
# NMOS row 1: y=3.0 to 4.0, 7 transistors
# NMOS row 2: y=5.0 to 6.0, 7 transistors
# PMOS row 1: y=9.0 to 10.5, 7 transistors (nwell y=8.0 to 11.5)
# PMOS row 2: y=11.0 to 12.5, 7 transistors

NMOS_Y1 = 3.5
NMOS_Y2 = 5.5
PMOS_Y1 = 9.75
PMOS_Y2 = 11.75
ROW_H = 0.74   # diffusion height (0.36 NMOS, 0.72 PMOS + margins)

GATE_X = [1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5]  # 7 gates, 1.0 um pitch

# nwell around PMOS rows
rect(fa, "nwell", 0.5, 8.0, FA_W - 0.5, 13.0)

# ---------------------------------------------------------------------------
# Build transistors
# ---------------------------------------------------------------------------
# Each transistor: (row, col_index, gate_signal, source_net, drain_net)
# row: 0=NMOS1, 1=NMOS2, 2=PMOS1, 3=PMOS2
# We'll place them and record contact positions for routing

transistor_contacts = []  # (x, y, net) for source/drain contacts

def add_transistor(row, col, gate_sig, src_net, drn_net):
    gx = GATE_X[col]
    if row in (0, 1):
        # NMOS
        y = NMOS_Y1 if row == 0 else NMOS_Y2
        w = 0.36
        implant = "nplus"
        bulk = "VSS"
    else:
        # PMOS
        y = PMOS_Y1 if row == 2 else PMOS_Y2
        w = 0.72
        implant = "pplus"
        bulk = "VDD"

    half_w = w / 2
    # Diffusion rectangle
    rect(fa, "diff", gx - DIFF_EXT_GATE, y - half_w,
         gx + POLY_WIDTH + DIFF_EXT_GATE, y + half_w)
    rect(fa, implant, gx - DIFF_EXT_GATE, y - half_w,
         gx + POLY_WIDTH + DIFF_EXT_GATE, y + half_w)
    # Gate poly
    rect(fa, "poly", gx, y - half_w - POLY_ENDCAP,
         gx + POLY_WIDTH, y + half_w + POLY_ENDCAP)
    # Source contact (left side of diffusion)
    sx = gx + DIFF_EXT_GATE + CONTACT_SIZE / 2 + 0.02
    contact(fa, sx, y)
    transistor_contacts.append((sx, y, src_net))
    # Drain contact (right side of diffusion)
    dx = gx + POLY_WIDTH - DIFF_EXT_GATE - CONTACT_SIZE / 2 - 0.02
    contact(fa, dx, y)
    transistor_contacts.append((dx, y, drn_net))

# NMOS transistors (from netlist)
nmos_list = [
    # (row, col, gate, source, drain)
    (0, 0, "A",  "VSS", "n1"),
    (0, 1, "B",  "n1",  "VSS"),
    (0, 2, "CIN","CB",  "n1"),
    (0, 3, "B",  "n2",  "CB"),
    (0, 4, "A",  "VSS", "n2"),
    (0, 5, "A",  "n3",  "VSS"),
    (0, 6, "B",  "VSS", "n3"),
    (1, 0, "CIN","n3",  "VSS"),
    (1, 1, "CB", "SB",  "n3"),
    (1, 2, "CIN","n5",  "SB"),
    (1, 3, "B",  "n4",  "n5"),
    (1, 4, "A",  "VSS", "n4"),
    (1, 5, "CB", "COUT","VSS"),
    (1, 6, "SB", "VSS", "SUM"),
]
for t in nmos_list:
    add_transistor(*t)

# PMOS transistors (from netlist)
pmos_list = [
    # (row, col, gate, source, drain)
    (2, 0, "A",  "VDD", "p1"),
    (2, 1, "B",  "p1",  "VDD"),
    (2, 2, "CIN","CB",  "p1"),
    (2, 3, "B",  "p2",  "CB"),
    (2, 4, "A",  "VDD", "p2"),
    (2, 5, "A",  "p3",  "VDD"),
    (2, 6, "B",  "VDD", "p3"),
    (3, 0, "CIN","p3",  "VDD"),
    (3, 1, "CB", "SB",  "p3"),
    (3, 2, "CIN","p5",  "SB"),
    (3, 3, "B",  "p4",  "p5"),
    (3, 4, "A",  "VDD", "p4"),
    (3, 5, "CB", "COUT","VDD"),
    (3, 6, "SB", "VDD", "SUM"),
]
for t in pmos_list:
    add_transistor(*t)

# ---------------------------------------------------------------------------
# Route nets
# ---------------------------------------------------------------------------
# Collect contact points per net
net_points = {}
for x, y, net in transistor_contacts:
    net_points.setdefault(net, []).append((x, y))

# Add power rail contacts
for x in [2.0, 4.0, 6.0, 8.0]:
    net_points.setdefault("VSS", []).append((x, 1.0))
    net_points.setdefault("VDD", []).append((x, 15.0))

# Add input pin contacts
net_points.setdefault("A", []).append((1.0, 4.0))
net_points.setdefault("B", []).append((1.0, 8.0))
net_points.setdefault("CIN", []).append((1.0, 12.0))

# Add output pin contacts
net_points.setdefault("SUM", []).append((FA_W - 1.0, 6.0))
net_points.setdefault("COUT", []).append((FA_W - 1.0, 10.0))

# Route each net: M1 horizontal + M2 vertical
def route_net(pts):
    if len(pts) < 2:
        return
    pts = sorted(set(pts))
    for i in range(len(pts) - 1):
        x1, y1 = pts[i]
        x2, y2 = pts[i + 1]
        m1_h(fa, x1, x2, y1)
        if y1 != y2:
            m2_v(fa, min(y1, y2), max(y1, y2), x2)
            via1(fa, x2, y1)
            via1(fa, x2, y2)

for net, pts in net_points.items():
    route_net(pts)

# ---------------------------------------------------------------------------
# Place 8 full adder instances and chain carries
# ---------------------------------------------------------------------------
XPITCH = 11.0
for i in range(8):
    top.insert(kdb.DCellInstArray(fa.cell_index(),
        kdb.DTrans(kdb.DVector(i * XPITCH, 0.0)))

# Top-level connections
for i in range(8):
    bx = i * XPITCH
    # A and B pins
    m1_v(top, 0.0, FA_H, bx + 1.0)
    pin(top, f"A{i}", bx + 1.0, 4.0)
    pin(top, f"B{i}", bx + 1.0, 8.0)
    # S and COUT pins
    m1_v(top, 0.0, FA_H, bx + FA_W - 1.0)
    pin(top, f"S{i}", bx + FA_W - 1.0, 6.0)
    pin(top, f"COUT{i}", bx + FA_W - 1.0, 10.0)

# CIN pin (only for first stage)
m1_v(top, 0.0, FA_H, 1.0)
pin(top, "CIN", 1.0, 12.0)

# COUT pin (from last stage)
pin(top, "COUT", 7 * XPITCH + FA_W - 1.0, 10.0)

# VDD / VSS rails
m1_h(top, 0.0, 7 * XPITCH + FA_W, 1.0)
m1_h(top, 0.0, 7 * XPITCH + FA_W, 15.0)
pin(top, "VSS", 1.0, 1.0)
pin(top, "VDD", 1.0, 15.0)

# Carry chain: COUT of stage i -> CIN of stage i+1 on M2
for i in range(7):
    x1 = i * XPITCH + FA_W - 1.0
    x2 = (i + 1) * XPITCH + 1.0
    m2_h(top, x1, x2, 12.0)
    via1(top, x1, 10.0)
    via1(top, x2, 12.0)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("rca8.gds")
print("Written rca8.gds")
print("Top cell bbox:", top.bbox())
print("Area:", top.bbox().width() * top.bbox().height(), "um^2")
```