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
    """via1 (0.15x0.15) with m1 enclosure 0.085 all around -> m1 0.32x0.32"""
    box(cell, VIA, x-0.075, y-0.075, x+0.075, y+0.075)
    box(cell, M1,  x-0.160, y-0.160, x+0.160, y+0.160)

def licon(cell, x, y):
    """licon 0.17x0.17 on diff/poly"""
    box(cell, LICON, x-0.085, y-0.085, x+0.085, y+0.085)

def mos(cell, x, y, w, l, is_pmos=False):
    """
    One MOS transistor.
    x,y : centre of the gate (poly crosses diff here)
    w   : transistor width (diff height, y direction)
    l   : gate length (poly width, x direction)
    Returns dict with contact centres: s (source), d (drain), g (gate)
    """
    # diffusion (horizontal, height = w)
    dh = w
    box(cell, DIFF, x - l/2 - 0.20, y - dh/2, x + l/2 + 0.20, y + dh/2)
    if is_pmos:
        box(cell, NWELL, x - l/2 - 0.38, y - dh/2 - 0.18,
                   x + l/2 + 0.38, y + dh/2 + 0.18)
    # poly gate (vertical, width = l)
    box(cell, POLY, x - l/2, y - dh/2 - 0.13, x + l/2, y + dh/2 + 0.13)
    # source/drain contacts on diff (left/right of gate)
    sx = x - l/2 - 0.20 + 0.145   # 0.145 from diff edge -> licon centre
    dx = x + l/2 + 0.20 - 0.145
    cy = y
    licon(cell, sx, cy)
    licon(cell, dx, cy)
    # gate contact on poly (above gate)
    licon(cell, x, y + dh/2 + 0.13 + 0.145)
    return {"s": (sx, cy), "d": (dx, cy), "g": (x, y + dh/2 + 0.13 + 0.145)}

def m1_rect(cell, x1, y1, x2, y2):
    box(cell, M1, x1, y1, x2, y2)

def m2_rect(cell, x1, y1, x2, y2):
    box(cell, M2, x1, y1, x2, y2)

# ----------------------------------------------------------------------
# DFF cell: master-slave flip-flop, 22 transistors
# Compact standard cell: 12.0 um wide x 9.0 um tall
# ----------------------------------------------------------------------
def create_dff_cell():
    dff = ly.create_cell("dff")
    CW, CH = 12.0, 9.0

    # Power rails (metal1)
    m1_rect(dff, 0, 0.0, CW, 0.22)          # VSS
    m1_rect(dff, 0, CH-0.22, CW, CH)        # VDD
    label(dff, M1LAB, "VSS", CW/2, 0.11)
    label(dff, M1LAB, "VDD", CW/2, CH-0.11)

    # Transistor rows
    nmos_y = 1.5          # diff centre y, height 0.42 -> y=1.29..1.71
    pmos_y = 7.5          # diff centre y, height 0.84 -> y=7.08..7.92
    gate_l = 0.15

    # (name, x, w, is_pmos, s_net, d_net, g_net)
    # SPICE order: M drain gate source bulk
    transistors = [
        # nmos (w=0.42)
        ("Mn0_0", 1.10, 0.42, False, "CKB", "VSS", "CK"),
        ("Mn0_1", 1.90, 0.42, False, "VSS", "n1",  "D"),
        ("Mn0_2", 2.70, 0.42, False, "n1",  "m",   "CKB"),
        ("Mn0_3", 3.50, 0.42, False, "m",   "n2",  "CK"),
        ("Mn0_4", 4.30, 0.42, False, "n2",  "VSS", "mb"),
        ("Mn0_5", 5.10, 0.42, False, "VSS", "mb",  "m"),
        ("Mn7_0", 5.90, 0.42, False, "VSS", "n3",  "Q"),
        ("Mn7_1", 6.70, 0.42, False, "n3",  "s",   "CKB"),
        ("Mn7_2", 7.50, 0.42, False, "s",   "n4",  "CK"),
        ("Mn7_3", 8.30, 0.42, False, "n4",  "VSS", "mb"),
        ("Mn7_4", 9.10, 0.42, False, "VSS", "Q",   "s"),
        # pmos (w=0.84) in n-well
        ("Mp0_0", 1.10, 0.84, True,  "CKB", "VDD", "CK"),
        ("Mp0_1", 2.30, 0.84, True,  "VDD", "p1",  "D"),
        ("Mp0_2", 3.50, 0.84, True,  "p1",  "m",   "CK"),
        ("Mp0_3", 4.70, 0.84, True,  "m",   "p2",  "CKB"),
        ("Mp0_4", 5.90, 0.84, True,  "p2",  "VDD", "mb"),
        ("Mp0_5", 7.10, 0.84, True,  "VDD", "mb",  "m"),
        ("Mp7_0", 8.30, 0.84, True,  "VDD", "p3",  "Q"),
        ("Mp7_1", 9.50, 0.84, True,  "p3",  "s",   "CK"),
        ("Mp7_2", 10.70,0.84, True,  "s",   "p4",  "CKB"),
        ("Mp7_3", 11.90,0.84, True,  "p4",  "VDD", "mb"),  # will clamp
        ("Mp7_4", 11.90,0.84, True,  "VDD", "Q",   "s"),   # will clamp
    ]

    # Clamp pmos x to cell width (rightmost pmos at x=10.3)
    transistors = [(n, min(x, 10.3), w, p, s, d, g) for n,x,w,p,s,d,g in transistors]

    mos_info = {}
    for name, x, w, is_p, s_net, d_net, g_net in transistors:
        ty = nmos_y if not is_p else pmos_y
        info = mos(dff, x, ty, w, gate_l, is_pmos=is_p)
        mos_info[name] = {"pos": info, "s": s_net, "d": d_net, "g": g_net}

    # Net -> metal2 rail y position (vertical rails at cell right edge)
    net_y = {
        "VSS": 0.11, "VDD": CH-0.11,
        "CK":  2.6, "D": 3.2, "Q": 3.8,
        "CKB": 4.4, "n1": 5.0, "m": 5.6, "n2": 6.2, "mb": 6.8,
        "s": 7.4, "n3": 8.0, "n4": 8.6,
        "p1": 2.9, "p2": 3.5, "p3": 4.1, "p4": 4.7,
    }
    # Draw metal2 vertical rails at right edge of cell
    rail_x = CW - 0.5
    for net, yy in net_y.items():
        m2_rect(dff, rail_x-0.07, yy-0.14, rail_x+0.07, yy+0.14)
        label(dff, M2LAB, net, rail_x, yy)

    # Connect every transistor terminal to its net rail via m1 + via
    for name, info in mos_info.items():
        pos = info["pos"]
        for term in ("s", "d", "g"):
            tx, ty = pos[term]
            ny = net_y[info[term if term!="g" else "g"]]
            # vertical m1 from contact to rail level
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
PITCH = dff_w + 1.6          # horizontal pitch between cells
START_X = 2.0
Y0 = 2.0
COLS = 16

# Global power rails (metal1) across top
total_w = START_X + COLS * PITCH
m1_rect(top, 0, Y0+0.0, total_w, 0.22)          # VSS
m1_rect(top, 0, Y0+dff_h-0.22, total_w, Y0+dff_h)  # VDD
label(top, M1LAB, "VSS", total_w/2, Y0+0.11)
label(top, M1LAB, "VDD", total_w/2, Y0+dff_h-0.11)

# Global metal2 rails for CK and chain
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

