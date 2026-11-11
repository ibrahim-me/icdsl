```python
import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data (sky130A) - layers and design rules in micrometres
# ----------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell":   (64, 20),
        "diff":    (65, 20),
        "tap":     (65, 44),
        "poly":    (66, 20),
        "nsdm":    (93, 44),
        "psdm":    (94, 20),
        "licon":   (66, 44),
        "li":      (67, 20),
        "mcon":    (67, 44),
        "m1":      (68, 20),
        "via":     (68, 44),
        "m2":      (69, 20),
    },
    label={
        "poly": (66, 5),
        "li":   (67, 5),
        "m1":   (68, 5),
        "m2":   (69, 5),
    },
    pin={
        "poly": (66, 16),
        "li":   (67, 16),
        "m1":   (68, 16),
        "m2":   (69, 16),
    },
    devices={
        "nmos": dict(model="sky130_fd_pr__nfet_01v8", diff="diff", implant="nsdm", well=None,
                     lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(model="sky130_fd_pr__pfet_01v8", diff="diff", implant="psdm", well="nwell",
                     lmin=0.15, wmin=0.84, bulk="VDD"),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout database and helpers
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001                      # 1 nm database unit

def dbu(v):
    """um -> database units"""
    return v / ly.dbu

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def label_layer(name):
    gds, dt = TECH["label"][name]
    return ly.layer(gds, dt)

def pin_layer(name):
    gds, dt = TECH["pin"][name]
    return ly.layer(gds, dt)

def box(cell, lay, x1, y1, x2, y2):
    """axis-aligned rectangle, coordinates in um"""
    if x2 < x1:
        x1, x2 = x2, x1
    if y2 < y1:
        y1, y2 = y2, y1
    cell.shapes(lay).insert(kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2)))

def text(cell, lay, s, x, y):
    cell.shapes(lay).insert(kdb.DText(s, kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, lay, x, y, size):
    """square contact centred at (x,y), um"""
    h = size / 2.0
    box(cell, lay, x - h, y - h, x + h, y + h)

def metal_rect(cell, lay, x1, y1, x2, y2):
    box(cell, lay, x1, y1, x2, y2)

def metal_path(cell, lay, x1, y1, x2, y2, width):
    """horizontal or vertical metal segment"""
    if x1 == x2:
        h = width / 2.0
        box(cell, lay, x1 - h, min(y1, y2), x1 + h, max(y1, y2))
    elif y1 == y2:
        h = width / 2.0
        box(cell, lay, min(x1, x2), y1 - h, max(x1, x2), y1 + h)
    else:
        box(cell, lay, min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))

# ----------------------------------------------------------------------
# Contact primitives (all sizes in um, DRC-correct)
# ----------------------------------------------------------------------
LICON = 0.17
LI_ENC_LICON_X = 0.165   # li extends 0.08 beyond licon on left/right
LI_ENC_LICON_Y = 0.0     # li extends 0.0 beyond licon on top/bottom
MCON = 0.17
M1_ENC_MCON_X = 0.065    # m1 extends 0.03 beyond mcon on left/right
M1_ENC_MCON_Y = 0.03     # m1 extends 0.03 beyond mcon on top/bottom
VIA = 0.15
M2_ENC_VIA_X = 0.085     # m2 extends 0.085 beyond via on left/right
M2_ENC_VIA_Y = 0.055     # m2 extends 0.055 beyond via on top/bottom

def diff_contact(cell, x, y):
    """licon + li + mcon + m1 on a diffusion contact (licon on diff only, not poly)"""
    contact(cell, layer("licon"), x, y, LICON)
    box(cell, layer("li"),
        x - LI_ENC_LICON_X, y - LI_ENC_LICON_Y,
        x + LI_ENC_LICON_X, y + LI_ENC_LICON_Y)
    contact(cell, layer("mcon"), x, y, MCON)
    box(cell, layer("m1"),
        x - M1_ENC_MCON_X, y - M1_ENC_MCON_Y,
        x + M1_ENC_MCON_X, y + M1_ENC_MCON_Y)

def poly_contact(cell, x, y):
    """licon + li + mcon + m1 on a poly contact (licon on poly only, not diff)"""
    contact(cell, layer("licon"), x, y, LICON)
    box(cell, layer("li"),
        x - LI_ENC_LICON_X, y - LI_ENC_LICON_Y,
        x + LI_ENC_LICON_X, y + LI_ENC_LICON_Y)
    contact(cell, layer("mcon"), x, y, MCON)
    box(cell, layer("m1"),
        x - M1_ENC_MCON_X, y - M1_ENC_MCON_Y,
        x + M1_ENC_MCON_X, y + M1_ENC_MCON_Y)

def m1_to_m2_via(cell, x, y):
    """via from m1 to m2, surrounded by m1 and m2"""
    box(cell, layer("m1"),
        x - M1_ENC_MCON_X, y - M1_ENC_MCON_Y,
        x + M1_ENC_MCON_X, y + M1_ENC_MCON_Y)
    contact(cell, layer("via"), x, y, VIA)
    box(cell, layer("m2"),
        x - M2_ENC_VIA_X, y - M2_ENC_VIA_Y,
        x + M2_ENC_VIA_X, y + M2_ENC_VIA_Y)

# ----------------------------------------------------------------------
# SRAM 6T cell
# ----------------------------------------------------------------------
CELL_W = 3.6   # cell pitch in x (bit-line direction)
CELL_H = 4.6   # cell pitch in y (word-line direction)

# diffusion strip x-centres (6 strips)
STRIP_X = [0.45, 0.95, 1.45, 2.15, 2.65, 3.15]
STRIP_W = 0.30
STRIP_Y1 = 0.55
STRIP_Y2 = 4.05

# poly gate y-centres
Y_WL   = 2.30   # word line (access transistors)
Y_QB   = 1.15   # gate of left pull-down & left pull-up
Y_Q    = 3.45   # gate of right pull-up & right pull-down

# transistor widths (gate width = poly width in y)
W_N = 0.42   # NMOS
W_P = 0.84   # PMOS

def add_transistor(cell, dev, x, gate_y, width):
    """draw a MOS transistor: diff, implant, well (if pmos), poly gate"""
    diff_lay = layer(TECH["devices"][dev]["diff"])
    impl_lay = layer(TECH["devices"][dev]["implant"])
    poly_lay = layer("poly")
    nwell_lay = layer("nwell")

    # diffusion rectangle (vertical strip)
    hx = STRIP_W / 2.0
    box(cell, diff_lay, x - hx, STRIP_Y1, x + hx, STRIP_Y2)

    # implant (slightly larger than diff)
    ihx = STRIP_W / 2.0 + 0.05
    box(cell, impl_lay, x - ihx, STRIP_Y1 - 0.05, x + ihx, STRIP_Y2 + 0.05)

    # nwell for pmos
    if dev == "pmos":
        box(cell, nwell_lay, x - 0.30, STRIP_Y1 - 0.30, x + 0.30, STRIP_Y2 + 0.30)

    # poly gate (horizontal strip crossing the diffusion)
    hy = width / 2.0
    box(cell, poly_lay, x - 0.075, gate_y - hy, x + 0.075, gate_y + hy)

def build_sram6t(cell):
    # ---- diffusion strips ------------------------------------------------
    # strip 0 : left access NMOS   (Mn0_0)   gate = WL
    # strip 1 : left pull-down NMOS (Mn0_1)  gate = QB
    # strip 2 : left pull-up   PMOS (Mp1_0)  gate = QB
    # strip 3 : right pull-up  PMOS (Mp1_1)  gate = Q
    # strip 4 : right pull-down NMOS (Mn0_2) gate = Q
    # strip 5 : right access NMOS   (Mn0_3)  gate = WL

    for i, x in enumerate(STRIP_X):
        dev = "nmos" if i in (0, 1, 4, 5) else "pmos"
        add_transistor(cell, dev, x, 0.0, W_P if dev == "pmos" else W_N)

    # ---- poly gates (continuous horizontal lines) ------------------------
    poly_lay = layer("poly")
    # WL gate across both access transistors
    box(cell, poly_lay, STRIP_X[0] - 0.075, Y_WL - W_N / 2.0,
        STRIP_X[5] + 0.075, Y_WL + W_N / 2.0)
    # QB gates (left pull-down + left pull-up)
    box(cell, poly_lay, STRIP_X[1] - 0.075, Y_QB - W_N / 2.0,
        STRIP_X[1] + 0.075, Y_QB + W_N / 2.0)
    box(cell, poly_lay, STRIP_X[2] - 0.075, Y_QB - W_P / 2.0,
        STRIP_X[2] + 0.075, Y_QB + W_P / 2.0)
    # Q gates (right pull-up + right pull-down)
    box(cell, poly_lay, STRIP_X[3] - 0.075, Y_Q - W_P / 2.0,
        STRIP_X[3] + 0.075, Y_Q + W_P / 2.0)
    box(cell, poly_lay, STRIP_X[4] - 0.075, Y_Q - W_N / 2.0,
        STRIP_X[4] + 0.075, Y_Q + W_N / 2.0)

    # ---- contacts on diffusion (NOT on poly) -----------------------------
    # y=1.0 contacts are between Y_QB(1.15) and STRIP_Y1(0.55) - clear of poly
    # y=4.0 contacts are between Y_Q(3.45) and STRIP_Y2(4.05) - clear of poly
    # left access (strip0): source=BL(y=1), drain=Q(y=4)
    diff_contact(cell, STRIP_X[0], 1.0)
    diff_contact(cell, STRIP_X[0], 4.0)
    # left pull-down (strip1): source=Q(y=1), drain=VSS(y=4)
    diff_contact(cell, STRIP_X[1], 1.0)
    diff_contact(cell, STRIP_X[1], 4.0)
    # left pull-up (strip2): source=VDD(y=1), drain=Q(y=4)
    diff_contact(cell, STRIP_X[2], 1.0)
    diff_contact(cell, STRIP_X[2], 4.0)
    # right pull-up (strip3): source=VDD(y=1), drain=QB(y=4)
    diff_contact(cell, STRIP_X[3], 1.0)
    diff_contact(cell, STRIP_X[3], 4.0)
    # right pull-down (strip4): source=VSS(y=1), drain=QB(y=4)
    diff_contact(cell, STRIP_X[4], 1.0)
    diff_contact(cell, STRIP_X[4], 4.0)
    # right access (strip5): source=BLB(y=1), drain=QB(y=4)
    diff_contact(cell, STRIP_X[5], 1.0)
    diff_contact(cell, STRIP_X[5], 4.0)

    # ---- contacts on poly gates (NOT on diff) ----------------------------
    # Place poly contacts at x=0.2 (left of strip0 at 0.45), clear of diffusion
    PCX = 0.20
    poly_contact(cell, PCX, Y_WL)   # WL
    poly_contact(cell, PCX, Y_QB)   # QB
    poly_contact(cell, PCX, Y_Q)    # Q

    # ---- m1 routing ------------------------------------------------------
    m1_lay = layer("m1")

    def m1_pad(x, y):
        metal_rect(cell, m1_lay, x - M1_ENC_MCON_X, y - M1_ENC_MCON_Y,
                   x + M1_ENC_MCON_X, y + M1_ENC_MCON_Y)

    # ensure m1 over every contact
    for x in STRIP_X:
        m1_pad(x, 1.0)
        m1_pad(x, 4.0)
    m1_pad(PCX, Y_WL)
    m1_pad(PCX, Y_QB)
    m1_pad(PCX, Y_Q)

    # VDD rail (m1): connects left pull-up source (strip2,y=1) and right pull-up source (strip3,y=1)
    metal_path(cell, m1_lay, STRIP_X[2], 1.0, STRIP_X[3], 1.0, 0.20)
    # VSS rail (m1): connects left pull-down drain (strip1,y=4) and right pull-down source (strip4,y=1)
    metal_path(cell, m1_lay, STRIP_X[1], 4.0, STRIP_X[4], 1.0, 0.20)

    # Q node (m1): left access drain(strip0,y=4) -> left pull-down source(strip1,y=1)
    #              -> left pull-up drain(strip2,y=4) -> right pull-up gate(strip3,Y_Q)
    #              -> right pull-down gate(strip4,Y_Q)
    metal_path(cell, m1_lay, STRIP_X[0], 4.0, STRIP_X[1], 1.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[1], 1.0, STRIP_X[2], 4.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[2], 4.0, STRIP_X[3], Y_Q, 0.20)
    metal_path(cell, m1_lay, STRIP_X[3], Y_Q, STRIP_X[4], Y_Q, 0.20)

    # QB node (m1): right access drain(strip5,y=4) -> right pull-down source(strip4,y=4)
    #                -> right pull-up drain(strip3,y=4) -> left pull-down gate(strip1,Y_QB)
    #                -> left pull-up gate(strip2,Y_QB)
    metal_path(cell, m1_lay, STRIP_X[5], 4.0, STRIP_X[4], 4.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[4], 4.0, STRIP_X[3], 4.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[3], 4.0, STRIP_X[1], Y_QB, 0.20)
    metal_path(cell, m1_lay, STRIP_X[1], Y_QB, STRIP_X[2], Y_QB, 0.20)

    # WL line (m1): connects both access gates and extends to cell borders
    metal_path(cell, m1_lay, 0.0, Y_WL, CELL_W, Y_WL, 0.20)

    # BL line (m1): left access source (strip0,y=1) extends to top/bottom borders
    metal_path(cell, m1_lay, STRIP_X[0], 1.0, STRIP_X[0], 0.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[0], 1.0, STRIP_X[0], CELL_H, 0.20)

    # BLB line (m1): right access source (strip5,y=1) extends to top/bottom borders
    metal_path(cell, m1_lay, STRIP_X[5], 1.0, STRIP_X[5], 0.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[5], 1.0, STRIP_X[5], CELL_H, 0.20)

    # ---- pins (labels on m1) ---------------------------------------------
    lab_lay = label_layer("m1")
    pin_lay = pin_layer("m1")
    text(cell, lab_lay, "WL",  CELL_W / 2.0, Y_WL)
    text(cell, pin_lay, "WL",  CELL_W / 2.0, Y_WL)
    text(cell, lab_lay, "BL",  STRIP_X[0], CELL_H)
    text(cell, pin_lay, "BL",  STRIP_X[0], CELL_H)
    text(cell, lab_lay, "BLB", STRIP_X[5], CELL_H)
    text(cell, pin_lay, "BLB", STRIP_X[5], CELL_H)
    text(cell, lab_lay, "VDD", STRIP_X[2], 0.0)
    text(cell, pin_lay, "VDD", STRIP_X[2], 0.0)
    text(cell, lab_lay, "VSS", STRIP_X[1], CELL_H)
    text(cell, pin_lay, "VSS", STRIP_X[1], CELL_H)

# ----------------------------------------------------------------------
# Top cell: sram16x8
# ----------------------------------------------------------------------
def build_top():
    top = ly.create_cell("sram16x8")
    cell6t = ly.create_cell("sram6t")
    build_sram6t(cell6t)

    # place 16 rows (WL) x 8 columns (BL)
    for row in range(16):
        for col in range(8):
            x = col * CELL_W
            y = row * CELL_H
            top.insert(kdb.DCellInstArray(cell6t.cell_index(),
                                          kdb.DTrans(dbu(x), dbu(y))))

    # ---- global routing ---------------------------------------------------
    m1_lay = layer("m1")
    m2_lay = layer("m2")
    lab_lay = label_layer("m1")
    pin_lay = pin_layer("m1")

    array_w = 8 * CELL_W
    array_h = 16 * CELL_H

    # VDD and VSS rails (m2) running horizontally above the array
    vdd_y = array_h + 1.2
    vss_y = array_h + 2.4
    metal_path(top, m2_lay, 0.0, vdd_y, array_w, vdd_y, 0.40)
    metal_path(top, m2_lay, 0.0, vss_y, array_w, vss_y, 0.40)

    # connect cell VDD/VSS to rails via m1->m2 vias at column centres
    for col in range(8):
        cx = col * CELL_W + CELL_W / 2.0
        for row in range(16):
            cy = row * CELL_H
            # via from cell m1 (VDD/VSS pins at cell bottom/top) to m2 rail
            m1_to_m2_via(top, cx, cy)
            metal_path(top, m2_lay, cx, cy, cx, vdd_y, 0.20)
            metal_path(top, m2_lay, cx, cy, cx, vss_y, 0.20)

    # WL lines (m1) run horizontally across the array, connect to left edge pins
    for row in range(16):
        wy = row * CELL_H + CELL_H / 2.0
        metal_path(top, m1_lay, 0.0, wy, array_w, wy, 0.20)
        text(top, lab_lay, "WL%d" % row, -0.6, wy)
        text(top, pin_lay, "WL%d" % row, -0.6, wy)

    # BL lines (m1) run vertically, already inside cells; extend to top/bottom
    for col in range(8):
        bx = col * CELL_W + CELL_W / 2.0
        metal_path(top, m1_lay, bx, 0.0, bx, array_h, 0.20)
        text(top, lab_lay, "BL%d" % col, bx, array_h + 0.5)
        text(top, pin_lay, "BL%d" % col, bx, array_h + 0.5)
        text(top, lab_lay, "BLB%d" % col, bx, -0.5)
        text(top, pin_lay, "BLB%d" % col, bx, -0.5)

    # supply pins
    text(top, lab_lay, "VDD", array_w / 2.0, vdd_y + 0.5)
    text(top, pin_lay, "VDD", array_w / 2.0, vdd_y + 0.5)
    text(top, lab_lay, "VSS", array_w / 2.0, vss_y + 0.5)
    text(top, pin_lay, "VSS", array_w / 2.0, vss_y + 0.5)

    return top

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
top_cell = build_top()
ly.write("sram16x8.gds")
print("wrote sram16x8.gds, bbox dbu:", top_cell.bbox(),
      " um:", top_cell.bbox().left * ly.dbu, top_cell.bbox().bottom * ly.dbu,
      top_cell.bbox().right * ly.dbu, top_cell.bbox().top * ly.dbu)
```