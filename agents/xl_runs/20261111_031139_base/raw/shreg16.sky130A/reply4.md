```
import klayout.db as kdb

# ----------------------------------------------------------------------
# Layout builder for shreg16 (sky130A) - compact standard-cell style
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001                      # 1 nm database unit
top = ly.create_cell("shreg16")

# ----------------------------------------------------------------------
# Layers (sky130A GDS layer/datatype)
# ----------------------------------------------------------------------
DIFF   = ly.layer(65, 20)           # diffusion
POLY   = ly.layer(66, 20)           # poly gate
LICON  = ly.layer(66, 44)           # local interconnect
M1     = ly.layer(68, 20)           # metal1
M1LAB  = ly.layer(68, 5)            # metal1 label (pin)
VIA    = ly.layer(68, 44)           # via1 (m1-m2)
M2     = ly.layer(69, 20)           # metal2
M2LAB  = ly.layer(69, 5)            # metal2 label (pin)
NWELL  = ly.layer(64, 20)           # n-well

# ----------------------------------------------------------------------
# DRC-safe geometry helpers (all coords in um)
# ----------------------------------------------------------------------
def box(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(kdb.DVector(x, y))))

def via12(cell, x, y):
    """via1 0.15x0.15 with m1 enclosure 0.055 -> m1 pad 0.26x0.26"""
    box(cell, VIA, x-0.075, y-0.075, x+0.075, y+0.075)
    box(cell, M1,  x-0.130, y-0.130, x+0.130, y+0.130)

def licon(cell, x, y):
    """licon 0.17x0.17 on diff or poly"""
    box(cell, LICON, x-0.085, y-0.085, x+0.085, y+0.085)

def mos(cell, x, y, w, l, is_pmos=False):
    """
    One MOS transistor.
    x,y : centre of the gate
    w   : transistor width (diffusion height, y direction)
    l   : gate length (poly width, x direction)
    Returns dict with contact centres: s (source), d (drain), g (gate)
    """
    # diffusion (horizontal strip)
    box(cell, DIFF, x - l/2 - 0.20, y - w/2, x + l/2 + 0.20, y + w/2)
    if is_pmos:
        box(cell, NWELL, x - l/2 - 0.38, y - w/2 - 0.18,
                   x + l/2 + 0.38, y + w/2 + 0.18)
    # poly gate (vertical strip, wider than diffusion for gate contact)
    box(cell, POLY, x - l/2, y - w/2 - 0.30, x + l/2, y + w/2 + 0.30)
    # source/drain contacts on diffusion (outside poly region)
    sx = x - l/2 - 0.20 + 0.145
    dx = x + l/2 + 0.20 - 0.145
    cy = y
    licon(cell, sx, cy)
    licon(cell, dx, cy)
    # gate contact on poly extension above diffusion (no diff overlap)
    licon(cell, x, y + w/2 + 0.30 - 0.085)
    return {"s": (sx, cy), "d": (dx, cy), "g": (x, y + w/2 + 0.30 - 0.085)}

def m1_rect(cell, x1, y1, x2, y2):
    box(cell, M1, x1, y1, x2, y2)

def m2_rect(cell, x1, y1, x2, y2):
    box(cell, M2, x1, y1, x2, y2)

# ----------------------------------------------------------------------
# DFF cell: master-slave flip-flop, 22 transistors
# Cell: 10.0 x 10.0 um
# ----------------------------------------------------------------------
def create_dff_cell():
    dff = ly.create_cell("dff")
    CW, CH = 10.0, 10.0

    # Power rails (metal1)
    m1_rect(dff, 0, 0.0, CW, 0.22)          # VSS
    m1_rect(dff, 0, CH-0.22, CW, CH)        # VDD
    label(dff, M1LAB, "VSS", CW/2, 0.11)
    label(dff, M1LAB, "VDD", CW/2, CH-0.11)

    # Transistor rows
    nmos_y = 1.5          # diff centre, height 0.42 -> y=1.29..1.71
    pmos_y = 8.5          # diff centre, height 0.84 -> y=8.08..8.92
    gate_l = 0.15

    # (name, x, w, is_pmos, s_net, d_net, g_net)
    # SPICE order: drain gate source bulk
    transistors = [
        # nmos (w=0.42)
        ("Mn0_0", 1.00, 0.42, False, "CKB", "VSS", "CK"),
        ("Mn0_1", 1.90, 0.42, False, "VSS", "n1",  "D"),
        ("Mn0_2", 2.80, 0.42, False, "n1",  "m",   "CKB"),
        ("Mn0_3", 3.70, 0.42, False, "m",   "n2",  "CK"),
        ("Mn0_4", 4.60, 0.42, False, "n2",  "VSS", "mb"),
        ("Mn0_5", 5.50, 0.42, False, "VSS", "mb",  "m"),
        ("Mn7_0", 6.40, 0.42, False, "VSS", "n3",  "Q"),
        ("Mn7_1", 7.30, 0.42, False, "n3",  "s",   "CKB"),
        ("Mn7_2", 8.20, 0.42, False, "s",   "n4",  "CK"),
        ("Mn7_3", 9.10, 0.42, False, "n4",  "VSS", "mb"),
        ("Mn7_4", 9.10, 0.42, False, "VSS", "Q",   "s"),
        # pmos (w=0.84) in n-well
        ("Mp0_0", 1.00, 0.84, True,  "CKB", "VDD", "CK"),
        ("Mp0_1", 2.20, 0.84, True,  "VDD", "p1",  "D"),
        ("Mp0_2", 3.40, 0.84, True,  "p1",  "m",   "CK"),
        ("Mp0_3", 4.60, 0.84, True,  "m",   "p2",  "CKB"),
        ("Mp0_4", 5.80, 0.84, True,  "p2",  "VDD", "mb"),
        ("Mp0_5", 7.00, 0.84, True,  "VDD", "mb",  "m"),
        ("Mp7_0", 8.20, 0.84, True,  "VDD", "p3",  "Q"),
        ("Mp7_1", 9.40, 0.84, True,  "p3",  "s",   "CK"),
        ("Mp7_2", 9.40, 0.84, True,  "s",   "p4",  "CKB"),
        ("Mp7_3", 9.40, 0.84, True,  "p4",  "VDD", "mb"),
        ("Mp7_4", 9.40, 0.84, True,  "VDD", "Q",   "s"),
    ]

    mos_info = {}
    for name, x, w, is_p, s_net, d_net, g_net in transistors:
        ty = nmos_y if not is_p else pmos_y
        info = mos(dff, x, ty, w, gate_l, is_pmos=is_p)
        mos_info[name] = {"pos": info, "s": s_net, "d": d_net, "g": g_net}

    # One big n-well for all pmos transistors
    box(dff, NWELL, 0.2, 7.6, 9.8, 9.4)

    # N+ tap in n-well (connects n-well to VDD)
    tap_x = 5.0
    box(dff, DIFF, tap_x-0.075, 7.6, tap_x+0.075, 9.4)   # n+ diffusion in nwell
    licon(dff, tap_x, 8.5)
    m1_rect(dff, tap_x-0.07, 8.5-0.13, tap_x+0.07, 8.5+0.13)
    via12(dff, tap_x, 8.5)

    # Net -> metal2 rail y position
    net_y = {
        "VSS": 0.11, "VDD": CH-0.11,
        "CK":  2.6, "D": 3.2, "Q": 3.8,
        "CKB": 4.4, "n1": 5.0, "m": 5.6, "n2": 6.2, "mb": 6.8,
        "s": 7.4, "n3": 8.0, "n4": 8.6,
        "p1": 2.9, "p2": 3.5, "p3": 4.1, "p4": 4.7,
    }
    # Metal2 vertical rails at right edge
    rail_x = CW - 0.5
    for net, yy in net_y.items():
        m2_rect(dff, rail_x-0.07, yy-0.14, rail_x+0.07, yy+0.14)
        label(dff, M2LAB, net, rail_x, yy)

    # Connect every transistor terminal to its net rail via m1 + via
    for name, info in mos_info.items():
        pos = info["pos"]
        for term in ("s", "d", "g"):
            tx, ty = pos[term]
            ny = net_y[info[term]]
            y1, y2 = sorted([ty, ny-0.14])
            m1_rect(dff, tx-0.07, y1, tx+0.07, y2)
            via12(dff, tx, ny-0.14)

    # External pins on metal2 at cell left edge
    label(dff, M2LAB, "D",  0.5, net_y["D"])
    label(dff, M2LAB, "CK", 0.5, net_y["CK"])
    label(dff, M2LAB, "Q",  CW-0.5, net_y["Q"])

    return dff, CW, CH

dff_cell, dff_w, dff_h = create_dff_cell()

# ----------------------------------------------------------------------
# Top cell: 16 dff instances chained (Q_i -> D_{i+1})
# ----------------------------------------------------------------------
PITCH = dff_w + 1.0          # horizontal pitch between cells
START_X = 1.0
Y0 = 1.0
COLS = 16

total_w = START_X + COLS * PITCH

# Global power rails (metal1)
m1_rect(top, 0, Y0+0.0, total_w, 0.22)          # VSS
m1_rect(top, 0, Y0+dff_h-0.22, total_w, Y0+dff_h)  # VDD
label(top, M1LAB, "VSS", total_w/2, Y0+0.11)
label(top, M1LAB, "VDD", total_w/2, Y0+dff_h-0.11)

# Global metal2 rail for CK
CK_Y = Y0 + 2.6
m2_rect(top, 0, CK_Y-0.14, total_w, CK_Y+0.14)
label(top, M2LAB, "CK", 0.5, CK_Y)

# Place flip-flops
for i in range(COLS):
    x = START_X + i * PITCH
    top.insert(kdb.DCellInstArray(dff_cell.cell_index(),
                                  kdb.DTrans(kdb.DVector(x, Y0))))
    # VDD/VSS vias to global rails
    via12(top, x + dff_w/2, Y0+0.11)
    via12(top, x + dff_w/2, Y0+dff_h-0.11)

    # Chain Q_i -> D_{i+1} on metal2
    if i < COLS-1:
        x_cur = x + dff_w - 0.5
        x_nxt = x + PITCH + 0.5
        m2_rect(top, x_cur, CK_Y-0.14, x_nxt, CK_Y+0.14)
        via12(top, x_cur, CK_Y)
        via12(top, x_nxt, CK_Y)

# Top-level pins
label(top, M2LAB, "D",  START_X+0.5, Y0+3.2)
for i, name in enumerate(["Q0","Q1","Q2","Q3","Q4","Q5","Q6","Q7",
                          "Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15"]):
    x = START_X + i * PITCH + dff_w - 0.5
    label(top, M2LAB, name, x, Y0+3.8)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("shreg16.gds")
print("shreg16.gds written, bbox:", top.bbox().to_um().width, "x", top.bbox().to_um().height)
print("area:", top.bbox().to_um().width * top.bbox().to_um().height, "um^2")
```