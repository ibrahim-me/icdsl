```
import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data (sky130A)
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
        "ptap": dict(type="tap", diff="tap", implant="psdm", well=None),
        "ntap": dict(type="tap", diff="tap", implant="nsdm", well="nwell"),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout database
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001

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
    if x2 < x1: x1, x2 = x2, x1
    if y2 < y1: y1, y2 = y2, y1
    cell.shapes(lay).insert(kdb.DBox(x1, y1, x2, y2))

def text(cell, lay, s, x, y):
    cell.shapes(lay).insert(kdb.DText(s, kdb.DTrans(x, y)))

def contact(cell, lay, x, y, size):
    h = size / 2.0
    box(cell, lay, x - h, y - h, x + h, y + h)

def metal_path(cell, lay, x1, y1, x2, y2, width):
    if x1 == x2:
        h = width / 2.0
        box(cell, lay, x1 - h, min(y1, y2), x1 + h, max(y1, y2))
    elif y1 == y2:
        h = width / 2.0
        box(cell, lay, min(x1, x2), y1 - h, max(x1, x2), y1 + h)
    else:
        box(cell, lay, min(x1, x2), min(y1, y2), max(x1, x2), max(y1, y2))

# ----------------------------------------------------------------------
# Contact primitives (DRC-correct, all um)
# ----------------------------------------------------------------------
LICON = 0.17
LI_PAD = 0.41      # li extends 0.12 beyond licon on all sides
MCON = 0.17
M1_PAD = 0.41      # m1 extends 0.12 beyond mcon on all sides
VIA = 0.15
M1_VIA_PAD = 0.32  # m1 extends 0.085 beyond via on all sides
M2_VIA_PAD = 0.32  # m2 extends 0.085 beyond via on all sides

def diff_contact(cell, x, y):
    contact(cell, layer("licon"), x, y, LICON)
    box(cell, layer("li"), x - LI_PAD/2, y - LI_PAD/2, x + LI_PAD/2, y + LI_PAD/2)
    contact(cell, layer("mcon"), x, y, MCON)
    box(cell, layer("m1"), x - M1_PAD/2, y - M1_PAD/2, x + M1_PAD/2, y + M1_PAD/2)

def poly_contact(cell, x, y):
    contact(cell, layer("licon"), x, y, LICON)
    box(cell, layer("li"), x - LI_PAD/2, y - LI_PAD/2, x + LI_PAD/2, y + LI_PAD/2)
    contact(cell, layer("mcon"), x, y, MCON)
    box(cell, layer("m1"), x - M1_PAD/2, y - M1_PAD/2, x + M1_PAD/2, y + M1_PAD/2)

def m1_to_m2_via(cell, x, y):
    box(cell, layer("m1"), x - M1_VIA_PAD/2, y - M1_VIA_PAD/2, x + M1_VIA_PAD/2, y + M1_VIA_PAD/2)
    contact(cell, layer("via"), x, y, VIA)
    box(cell, layer("m2"), x - M2_VIA_PAD/2, y - M2_VIA_PAD/2, x + M2_VIA_PAD/2, y + M2_VIA_PAD/2)

# ----------------------------------------------------------------------
# SRAM 6T cell
# ----------------------------------------------------------------------
CELL_W = 5.0
CELL_H = 5.0

STRIP_X = [0.80, 1.55, 2.30, 3.05, 3.80, 4.55]
STRIP_W = 0.25
STRIP_Y1 = 0.50
STRIP_Y2 = 4.50

Y_WL = 2.50
Y_QB = 1.20
Y_Q  = 3.80

W_N = 0.42
W_P = 0.84

PTAP_X = 0.20
NTAP_X = 2.675
TAP_Y1 = 0.50
TAP_Y2 = 4.50

def add_transistor(cell, dev, x, gate_y, width):
    diff_lay = layer(TECH["devices"][dev]["diff"])
    impl_lay = layer(TECH["devices"][dev]["implant"])
    poly_lay = layer("poly")
    nwell_lay = layer("nwell")

    hx = STRIP_W / 2.0
    box(cell, diff_lay, x - hx, STRIP_Y1, x + hx, STRIP_Y2)

    ihx = STRIP_W / 2.0 + 0.06
    box(cell, impl_lay, x - ihx, STRIP_Y1 - 0.06, x + ihx, STRIP_Y2 + 0.06)

    if dev == "pmos":
        box(cell, nwell_lay, x - 0.30, STRIP_Y1 - 0.30, x + 0.30, STRIP_Y2 + 0.30)

    hy = width / 2.0
    box(cell, poly_lay, x - 0.075, gate_y - hy, x + 0.075, gate_y + hy)

def build_sram6t(cell):
    # ---- diffusion strips + implants + nwell -----------------------------
    for i, x in enumerate(STRIP_X):
        dev = "nmos" if i in (0, 1, 4, 5) else "pmos"
        add_transistor(cell, dev, x, 0.0, W_P if dev == "pmos" else W_N)

    # nwell around PMOS strips (2 and 3)
    nwell_lay = layer("nwell")
    box(cell, nwell_lay, 1.85, 0.20, 3.50, 4.80)

    # ---- poly gates ------------------------------------------------------
    poly_lay = layer("poly")
    box(cell, poly_lay, STRIP_X[0] - 0.075, Y_WL - W_N/2, STRIP_X[5] + 0.075, Y_WL + W_N/2)
    box(cell, poly_lay, STRIP_X[1] - 0.075, Y_QB - W_N/2, STRIP_X[1] + 0.075, Y_QB + W_N/2)
    box(cell, poly_lay, STRIP_X[2] - 0.075, Y_QB - W_P/2, STRIP_X[2] + 0.075, Y_QB + W_P/2)
    box(cell, poly_lay, STRIP_X[3] - 0.075, Y_Q  - W_P/2, STRIP_X[3] + 0.075, Y_Q  + W_P/2)
    box(cell, poly_lay, STRIP_X[4] - 0.075, Y_Q  - W_N/2, STRIP_X[4] + 0.075, Y_Q  + W_N/2)

    # ---- diffusion contacts (y=0.85 and y=4.15, clear of poly gates) -----
    diff_contact(cell, STRIP_X[0], 0.85)   # BL
    diff_contact(cell, STRIP_X[0], 4.15)   # Q
    diff_contact(cell, STRIP_X[1], 0.85)   # Q
    diff_contact(cell, STRIP_X[1], 4.15)   # VSS
    diff_contact(cell, STRIP_X[2], 0.85)   # VDD
    diff_contact(cell, STRIP_X[2], 4.15)   # Q
    diff_contact(cell, STRIP_X[3], 0.85)   # VDD
    diff_contact(cell, STRIP_X[3], 4.15)   # QB
    diff_contact(cell, STRIP_X[4], 0.85)   # VSS
    diff_contact(cell, STRIP_X[4], 4.15)   # QB
    diff_contact(cell, STRIP_X[5], 0.85)   # BLB
    diff_contact(cell, STRIP_X[5], 4.15)   # QB

    # ---- poly contacts (x=0.15, clear of diffusion) ----------------------
    PCX = 0.15
    poly_contact(cell, PCX, Y_WL)
    poly_contact(cell, PCX, Y_QB)
    poly_contact(cell, PCX, Y_Q)

    # ---- taps ------------------------------------------------------------
    tap_lay = layer("tap")
    hx = STRIP_W / 2.0

    # ptap: P+ tap in substrate -> VSS
    box(cell, tap_lay, PTAP_X - hx, TAP_Y1, PTAP_X + hx, TAP_Y2)
    box(cell, layer("psdm"), PTAP_X - hx - 0.06, TAP_Y1 - 0.06, PTAP_X + hx + 0.06, TAP_Y2 + 0.06)
    diff_contact(cell, PTAP_X, 0.85)
    diff_contact(cell, PTAP_X, 4.15)

    # ntap: N+ tap in nwell -> VDD
    box(cell, tap_lay, NTAP_X - hx, TAP_Y1, NTAP_X + hx, TAP_Y2)
    box(cell, layer("nsdm"), NTAP_X - hx - 0.06, TAP_Y1 - 0.06, NTAP_X + hx + 0.06, TAP_Y2 + 0.06)
    diff_contact(cell, NTAP_X, 0.85)
    diff_contact(cell, NTAP_X, 4.15)

    # ---- m1 routing ------------------------------------------------------
    m1_lay = layer("m1")

    def m1_pad(x, y):
        box(cell, m1_lay, x - M1_PAD/2, y - M1_PAD/2, x + M1_PAD/2, y + M1_PAD/2)

    for x in STRIP_X:
        m1_pad(x, 0.85)
        m1_pad(x, 4.15)
    m1_pad(PCX, Y_WL)
    m1_pad(PCX, Y_QB)
    m1_pad(PCX, Y_Q)
    m1_pad(PTAP_X, 0.85)
    m1_pad(PTAP_X, 4.15)
    m1_pad(NTAP_X, 0.85)
    m1_pad(NTAP_X, 4.15)

    # VDD rail: strip2(y=0.85) to strip3(y=0.85)
    metal_path(cell, m1_lay, STRIP_X[2], 0.85, STRIP_X[3], 0.85, 0.20)
    # VSS rail: strip1(y=4.15) to strip4(y=0.85)
    metal_path(cell, m1_lay, STRIP_X[1], 4.15, STRIP_X[4], 0.85, 0.20)

    # Q node: strip0(4.15) -> strip1(0.85) -> strip2(4.15) -> strip3(Y_Q) -> strip4(Y_Q)
    metal_path(cell, m1_lay, STRIP_X[0], 4.15, STRIP_X[1], 0.85, 0.20)
    metal_path(cell, m1_lay, STRIP_X[1], 0.85, STRIP_X[2], 4.15, 0.20)
    metal_path(cell, m1_lay, STRIP_X[2], 4.15, STRIP_X[3], Y_Q, 0.20)
    metal_path(cell, m1_lay, STRIP_X[3], Y_Q, STRIP_X[4], Y_Q, 0.20)

    # QB node: strip5(4.15) -> strip4(4.15) -> strip3(4.15) -> strip1(Y_QB) -> strip2(Y_QB)
    metal_path(cell, m1_lay, STRIP_X[5], 4.15, STRIP_X[4], 4.15, 0.20)
    metal_path(cell, m1_lay, STRIP_X[4], 4.15, STRIP_X[3], 4.15, 0.20)
    metal_path(cell, m1_lay, STRIP_X[3], 4.15, STRIP_X[1], Y_QB, 0.20)
    metal_path(cell, m1_lay, STRIP_X[1], Y_QB, STRIP_X[2], Y_QB, 0.20)

    # WL line
    metal_path(cell, m1_lay, 0.0, Y_WL, CELL_W, Y_WL, 0.20)

    # BL and BLB lines
    metal_path(cell, m1_lay, STRIP_X[0], 0.85, STRIP_X[0], 0.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[0], 0.85, STRIP_X[0], CELL_H, 0.20)
    metal_path(cell, m1_lay, STRIP_X[5], 0.85, STRIP_X[5], 0.0, 0.20)
    metal_path(cell, m1_lay, STRIP_X[5], 0.85, STRIP_X[5], CELL_H, 0.20)

    # Tap vertical connections
    metal_path(cell, m1_lay, PTAP_X, 0.85, PTAP_X, 4.15, 0.20)
    metal_path(cell, m1_lay, NTAP_X, 0.85, NTAP_X, 4.15, 0.20)

    # ---- pins ------------------------------------------------------------
    lab_lay = label_layer("m1")
    pin_lay = pin_layer("m1")
    text(cell, lab_lay, "WL",  CELL_W/2, Y_WL)
    text(cell, pin_lay, "WL",  CELL_W/2, Y_WL)
    text(cell, lab_lay, "BL",  STRIP_X[0], CELL_H)
    text(cell, pin_lay, "BL",  STRIP_X[0], CELL_H)
    text(cell, lab_lay, "BLB", STRIP_X[5], CELL_H)
    text(cell, pin_lay, "BLB", STRIP_X[5], CELL_H)
    text(cell, lab_lay, "VDD", NTAP_X, 0.0)
    text(cell, pin_lay, "VDD", NTAP_X, 0.0)
    text(cell, lab_lay, "VSS", PTAP_X, CELL_H)
    text(cell, pin_lay, "VSS", PTAP_X, CELL_H)

# ----------------------------------------------------------------------
# Top cell: sram16x8
# ----------------------------------------------------------------------
def build_top():
    top = ly.create_cell("sram16x8")
    cell6t = ly.create_cell("sram6t")
    build_sram6t(cell6t)

    for row in range(16):
        for col in range(8):
            x = col * CELL_W
            y = row * CELL_H
            top.insert(kdb.DCellInstArray(cell6t.cell_index(), kdb.DTrans(x, y)))

    # ---- global routing --------------------------------------------------
    m1_lay = layer("m1")
    m2_lay = layer("m2")
    lab_lay = label_layer("m1")
    pin_lay = pin_layer("m1")

    array_w = 8 * CELL_W
    array_h = 16 * CELL_H

    vdd_y = array_h + 1.2
    vss_y = array_h + 2.4
    metal_path(top, m2_lay, 0.0, vdd_y, array_w, vdd_y, 0.40)
    metal_path(top, m2_lay, 0.0, vss_y, array_w, vss_y, 0.40)

    for col in range(8):
        cx = col * CELL_W + CELL_W / 2.0
        for row in range(16):
            cy = row * CELL_H + CELL_H / 2.0
            m1_to_m2_via(top, cx, cy)
            metal_path(top, m2_lay, cx, cy, cx, vdd_y, 0.20)
            metal_path(top, m2_lay, cx, cy, cx, vss_y, 0.20)

    for row in range(16):
        wy = row * CELL_H + CELL_H / 2.0
        metal_path(top, m1_lay, 0.0, wy, array_w, wy, 0.20)
        text(top, lab_lay, "WL%d" % row, -0.6, wy)
        text(top, pin_lay, "WL%d" % row, -0.6, wy)

    for col in range(8):
        bx = col * CELL_W + CELL_W / 2.0
        metal_path(top, m1_lay, bx, 0.0, bx, array_h, 0.20)
        text(top, lab_lay, "BL%d" % col, bx, array_h + 0.5)
        text(top, pin_lay, "BL%d" % col, bx, array_h + 0.5)
        text(top, lab_lay, "BLB%d" % col, bx, -0.5)
        text(top, pin_lay, "BLB%d" % col, bx, -0.5)

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
bbox = top_cell.bbox()
print("wrote sram16x8.gds")
print("bbox um: %.3f %.3f %.3f %.3f" % (bbox.left * ly.dbu, bbox.bottom * ly.dbu,
                                        bbox.right * ly.dbu, bbox.top * ly.dbu))
print("area um2: %.2f" % ((bbox.right - bbox.left) * ly.dbu * (bbox.top - bbox.bottom) * ly.dbu))
```