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
        "nmos": dict(model="sky130_fd_pr__nfet_01v8", diff="diff", implant="nsdm", well=None,
                     lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(model="sky130_fd_pr__pfet_01v8", diff="diff", implant="psdm", well="nwell",
                     lmin=0.15, wmin=0.84, bulk="VDD"),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout helpers
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001  # 1 nm database unit

def um(v):
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
    cell.shapes(lay).insert(kdb.DBox(um(x1), um(y1), um(x2), um(y2)))

def text(cell, lay, s, x, y):
    cell.shapes(lay).insert(kdb.DText(s, kdb.DTrans(um(x), um(y))))

def contact(cell, lay, x, y, size=0.17):
    """square contact centred at (x,y)"""
    h = size / 2.0
    box(cell, lay, x - h, y - h, x + h, y + h)

def via(cell, lay, x, y, size=0.15):
    h = size / 2.0
    box(cell, lay, x - h, y - h, x + h, y + h)

def metal_rect(cell, lay, x1, y1, x2, y2):
    if x2 < x1: x1, x2 = x2, x1
    if y2 < y1: y1, y2 = y2, y1
    box(cell, lay, x1, y1, x2, y2)

def metal_path(cell, lay, x1, y1, x2, y2, width):
    """rectangular metal segment between two points (horizontal or vertical)"""
    if x1 == x2:
        h = width / 2.0
        box(cell, lay, x1 - h, min(y1, y2), x1 + h, max(y1, y2))
    elif y1 == y2:
        h = width / 2.0
        box(cell, lay, min(x1, x2), y1 - h, max(x1, x2), y1 + h)
    else:
        # generic rectangle
        box(cell, lay, min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))

# ----------------------------------------------------------------------
# SRAM 6T cell
# ----------------------------------------------------------------------
CELL_W = 5.0   # cell pitch in x (bit-line direction)
CELL_H = 5.0   # cell pitch in y (word-line direction)

# diffusion strip x-centres (6 strips)
STRIP_X = [0.7, 1.4, 2.1, 2.9, 3.6, 4.3]
STRIP_W = 0.4          # diffusion strip width in x
STRIP_Y1 = 0.5
STRIP_Y2 = 4.5

# poly gate y-centres
Y_WL   = 2.5   # word line (access transistors)
Y_QB   = 1.5   # gate of left pull-down & left pull-up
Y_Q    = 3.5   # gate of right pull-up & right pull-down

# transistor widths (gate width = poly width in y)
W_N = 0.42   # NMOS
W_P = 0.84   # PMOS

def add_transistor(cell, dev, x, y, width, length=0.15):
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

    # nwell for pmos (covers the strip and some margin)
    if dev == "pmos":
        box(cell, nwell_lay, x - 0.3, STRIP_Y1 - 0.3, x + 0.3, STRIP_Y2 + 0.3)

    # poly gate (horizontal strip crossing the diffusion)
    hy = width / 2.0
    box(cell, poly_lay, x - length / 2.0, y - hy, x + length / 2.0, y + hy)

def add_diff_contact(cell, x, y):
    """licon + li + mcon on a diffusion contact"""
    contact(cell, layer("licon"), x, y, 0.17)
    box(cell, layer("li"), x - 0.085, y - 0.085, x + 0.085, y + 0.085)
    contact(cell, layer("mcon"), x, y, 0.17)

def add_poly_contact(cell, x, y):
    """licon + li + mcon on a poly contact"""
    contact(cell, layer("licon"), x, y, 0.17)
    box(cell, layer("li"), x - 0.085, y - 0.085, x + 0.085, y + 0.085)
    contact(cell, layer("mcon"), x, y, 0.17)

def add_m1_via(cell, x, y):
    """via from m1 to m2"""
    via(cell, layer("via"), x, y, 0.15)

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

    # ---- poly gates ------------------------------------------------------
    poly_lay = layer("poly")
    # WL gate (common to both access transistors)
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

    # ---- contacts on diffusion -------------------------------------------
    # left access (strip0): source=BL, drain=Q
    add_diff_contact(cell, STRIP_X[0], 1.0)   # BL
    add_diff_contact(cell, STRIP_X[0], 4.0)   # Q
    # left pull-down (strip1): source=Q, drain=VSS
    add_diff_contact(cell, STRIP_X[1], 1.0)   # Q
    add_diff_contact(cell, STRIP_X[1], 4.0)   # VSS
    # left pull-up (strip2): source=VDD, drain=Q
    add_diff_contact(cell, STRIP_X[2], 1.0)   # VDD
    add_diff_contact(cell, STRIP_X[2], 4.0)   # Q
    # right pull-up (strip3): source=VDD, drain=QB
    add_diff_contact(cell, STRIP_X[3], 1.0)   # VDD
    add_diff_contact(cell, STRIP_X[3], 4.0)   # QB
    # right pull-down (strip4): source=VSS, drain=QB
    add_diff_contact(cell, STRIP_X[4], 1.0)   # VSS
    add_diff_contact(cell, STRIP_X[4], 4.0)   # QB
    # right access (strip5): source=BLB, drain=QB
    add_diff_contact(cell, STRIP_X[5], 1.0)   # BLB
    add_diff_contact(cell, STRIP_X[5], 4.0)   # QB

    # ---- contacts on poly gates ------------------------------------------
    add_poly_contact(cell, STRIP_X[0], Y_WL)   # WL (left access)
    add_poly_contact(cell, STRIP_X[5], Y_WL)   # WL (right access)
    add_poly_contact(cell, STRIP_X[1], Y_QB)   # QB (left pull-down)
    add_poly_contact(cell, STRIP_X[2], Y_QB)   # QB (left pull-up)
    add_poly_contact(cell, STRIP_X[3], Y_Q)    # Q  (right pull-up)
    add_poly_contact(cell, STRIP_X[4], Y_Q)    # Q  (right pull-down)

    # ---- m1 routing ------------------------------------------------------
    m1_lay = layer("m1")
    m2_lay = layer("m2")

    # local interconnect (li) is already drawn under contacts.
    # Now draw m1 segments over the mcon contacts and route them.

    def m1_contact(x, y):
        add_m1_via(cell, x, y)   # placeholder: mcon already connects li->m1,
                                 # we just need m1 metal on top of the contact.
        metal_rect(cell, m1_lay, x - 0.1, y - 0.1, x + 0.1, y + 0.1)

    # place m1 over every diff/poly contact
    for x in STRIP_X:
        m1_contact(x, 1.0)
        m1_contact(x, 4.0)
    m1_contact(STRIP_X[0], Y_WL)
    m1_contact(STRIP_X[5], Y_WL)
    m1_contact(STRIP_X[1], Y_QB)
    m1_contact(STRIP_X[2], Y_QB)
    m1_contact(STRIP_X[3], Y_Q)
    m1_contact(STRIP_X[4], Y_Q)

    # VDD rail (m1) : connects left pull-up source (strip2,y=1) and right pull-up source (strip3,y=1)
    metal_path(cell, m1_lay, STRIP_X[2], 1.0, STRIP_X[3], 1.0, 0.2)
    # VSS rail (m1) : connects left pull-down drain (strip1,y=4) and right pull-down source (strip4,y=1)
    metal_path(cell, m1_lay, STRIP_X[1], 4.0, STRIP_X[4], 1.0, 0.2)

    # Q node (m1) : left access drain (strip0,y=4) -> left pull-down source (strip1,y=1)
    #               -> left pull-up drain (strip2,y=4) -> right pull-up gate (strip3,Y_Q)
    #               -> right pull-down gate (strip4,Y_Q)
    metal_path(cell, m1_lay, STRIP_X[0], 4.0, STRIP_X[1], 1.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[1], 1.0, STRIP_X[2], 4.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[2], 4.0, STRIP_X[3], Y_Q, 0.2)
    metal_path(cell, m1_lay, STRIP_X[3], Y_Q, STRIP_X[4], Y_Q, 0.2)

    # QB node (m1) : right access drain (strip5,y=4) -> right pull-down source (strip4,y=4)
    #                -> right pull-up drain (strip3,y=4) -> left pull-down gate (strip1,Y_QB)
    #                -> left pull-up gate (strip2,Y_QB)
    metal_path(cell, m1_lay, STRIP_X[5], 4.0, STRIP_X[4], 4.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[4], 4.0, STRIP_X[3], 4.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[3], 4.0, STRIP_X[1], Y_QB, 0.2)
    metal_path(cell, m1_lay, STRIP_X[1], Y_QB, STRIP_X[2], Y_QB, 0.2)

    # WL line (m1) : connects both access gates and extends to cell borders
    metal_path(cell, m1_lay, 0.0, Y_WL, CELL_W, Y_WL, 0.2)

    # BL line (m1) : left access source (strip0,y=1) extends to top/bottom borders
    metal_path(cell, m1_lay, STRIP_X[0], 1.0, STRIP_X[0], 0.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[0], 1.0, STRIP_X[0], CELL_H, 0.2)

    # BLB line (m1) : right access source (strip5,y=1) extends to top/bottom borders
    metal_path(cell, m1_lay, STRIP_X[5], 1.0, STRIP_X[5], 0.0, 0.2)
    metal_path(cell, m1_lay, STRIP_X[5], 1.0, STRIP_X[5], CELL_H, 0.2)

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
                                          kdb.DTrans(um(x), um(y))))

    # ---- global routing ---------------------------------------------------
    m1_lay = layer("m1")
    m2_lay = layer("m2")
    lab_lay = label_layer("m1")
    pin_lay = pin_layer("m1")

    array_w = 8 * CELL_W
    array_h = 16 * CELL_H

    # VDD and VSS rails (m2) running horizontally across the array
    vdd_y = array_h + 1.0
    vss_y = array_h + 2.0
    metal_path(top, m2_lay, 0.0, vdd_y, array_w, vdd_y, 0.4)
    metal_path(top, m2_lay, 0.0, vss_y, array_w, vss_y, 0.4)

    # connect cell VDD/VSS pins to rails via vias at every cell column
    for col in range(8):
        cx = col * CELL_W + CELL_W / 2.0
        # VDD : cell pin at bottom (y=0 of cell) -> connect to rail above array
        for row in range(16):
            cy = row * CELL_H
            via(top, m2_lay, cx, cy, 0.15)   # via from cell m1 to m2 (simplified)
            metal_path(top, m2_lay, cx, cy, cx, vdd_y, 0.2)
            metal_path(top, m2_lay, cx, cy, cx, vss_y, 0.2)

    # bit lines (m1) already run vertically inside cells; extend them to top/bottom
    # WL lines (m1) run horizontally inside cells; connect them to left edge pins
    for row in range(16):
        wy = row * CELL_H + CELL_H / 2.0
        metal_path(top, m1_lay, 0.0, wy, array_w, wy, 0.2)
        text(top, lab_lay, f"WL{row}", -1.0, wy)
        text(top, pin_lay, f"WL{row}", -1.0, wy)

    for col in range(8):
        bx = col * CELL_W + CELL_W / 2.0
        metal_path(top, m1_lay, bx, 0.0, bx, array_h, 0.2)
        text(top, lab_lay, f"BL{col}", bx, array_h + 0.5)
        text(top, pin_lay, f"BL{col}", bx, array_h + 0.5)
        text(top, lab_lay, f"BLB{col}", bx, -0.5)
        text(top, pin_lay, f"BLB{col}", bx, -0.5)

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
print("wrote sram16x8.gds, bbox:", top_cell.bbox())
