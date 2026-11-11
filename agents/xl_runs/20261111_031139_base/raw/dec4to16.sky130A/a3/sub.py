import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK parameters (sky130A)
# ----------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "diff": (65, 20), "tap": (65, 44),
        "poly": (66, 20), "licon": (66, 44), "li": (67, 20),
        "mcon": (67, 44), "m1": (68, 20), "via": (68, 44),
        "m2": (69, 20),
    },
    label={"m1": (68, 5), "m2": (69, 5), "poly": (66, 5)},
    pin={"m1": (68, 16), "m2": (69, 16), "poly": (66, 16)},
    cuts={
        "licon": dict(size=0.17, space=0.17),
        "mcon": dict(size=0.17, space=0.19),
        "via": dict(size=0.15, space=0.17),
    },
    width={"diff": 0.15, "poly": 0.15, "li": 0.17, "m1": 0.14, "m2": 0.14},
    space={
        ("diff", "diff"): 0.27, ("poly", "poly"): 0.21,
        ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06),
        ("poly", "licon"): (0.05, 0.08),
        ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085),
        ("m2", "via"): (0.055, 0.085),
    },
    rules=dict(
        gate_contact_space=0.055,
        poly_endcap=0.13,
        diff_ext_gate=0.25,
        polycontact_diff_space=0.19,
        gate_space=0.21,
    ),
    devices={
        "nmos": dict(model="sky130_fd_pr__nfet_01v8", w=0.42, l=0.15),
        "pmos": dict(model="sky130_fd_pr__pfet_01v8", w=0.84, l=0.15),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout setup
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("dec4to16")

DIFF = ly.layer(65, 20)
POLY = ly.layer(66, 20)
LICON = ly.layer(66, 44)
LI = ly.layer(67, 20)
MCON = ly.layer(67, 44)
M1 = ly.layer(68, 20)
VIA = ly.layer(68, 44)
M2 = ly.layer(69, 20)
NWELL = ly.layer(64, 20)
TAP = ly.layer(65, 44)

PIN_M1 = ly.layer(68, 16)
PIN_M2 = ly.layer(69, 16)
PIN_POLY = ly.layer(66, 16)
LAB_M1 = ly.layer(68, 5)
LAB_M2 = ly.layer(69, 5)
LAB_POLY = ly.layer(66, 5)

def B(layer, x1, y1, x2, y2):
    top.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def LAB(layer, text, x, y):
    top.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def LICON(x, y):
    s = 0.17
    B(LICON, x - s/2, y - s/2, x + s/2, y + s/2)
    B(LI, x - s/2 - 0.08, y - s/2 - 0.08, x + s/2 + 0.08, y + s/2 + 0.08)

def VIA(x, y):
    s = 0.15
    B(VIA, x - s/2, y - s/2, x + s/2, y + s/2)
    B(M1, x - s/2 - 0.055, y - s/2 - 0.055, x + s/2 + 0.055, y + s/2 + 0.055)
    B(M2, x - s/2 - 0.055, y - s/2 - 0.055, x + s/2 + 0.055, y + s/2 + 0.055)

def M1H(x1, x2, y, w=0.14):
    B(M1, x1, y - w/2, x2, y + w/2)

def M1V(x, y1, y2, w=0.14):
    B(M1, x - w/2, y1, x + w/2, y2)

def M2H(x1, x2, y, w=0.14):
    B(M2, x1, y - w/2, x2, y + w/2)

def M2V(x, y1, y2, w=0.14):
    B(M2, x - w/2, y1, x + w/2, y2)

# ----------------------------------------------------------------------
# Placement grid
# ----------------------------------------------------------------------
ORX = 1.0
ORY = 1.0
PX = 4.5
PY = 4.0
COLS = 4

# Row positions
# Row 0: input inverters (AB0..AB3)
# Row 1-4: NAND4 gates (N0..N15)
# Row 5-8: output inverters (Y0..Y15)

def place_inv(cx, cy, name_a, name_y):
    """Standard inverter: NFET bottom, PFET top, shared output Y."""
    # NFET
    nfx, nfy = cx + 0.4, cy + 0.4
    nfw, nfl = 0.42, 0.15
    B(DIFF, nfx, nfy, nfx + nfw, nfy + nfl + 0.5)
    B(POLY, nfx - 0.13, nfy + 0.25, nfx + nfw + 0.13, nfy + 0.25 + nfl)

    # PFET
    fpx, fpy = cx + 1.8, cy + 0.4
    fpw, fpl = 0.84, 0.15
    B(DIFF, fpx, fpy, fpx + fpw, fpy + fpl + 0.5)
    B(NWELL, fpx - 0.18, fpy - 0.18, fpx + fpw + 0.18, fpy + fpl + 0.5 + 0.18)
    B(POLY, fpx - 0.13, fpy + 0.25, fpx + fpw + 0.13, fpy + 0.25 + fpl)

    # Gate connection poly strip
    B(POLY, cx + 0.95, cy + 0.275, cx + 1.67, cy + 0.425)

    # Input A on poly (left side)
    B(POLY, cx + 0.0, cy + 0.275, cx + 0.27, cy + 0.425)
    LAB(PIN_POLY, name_a, cx + 0.135, cy + 0.35)

    # Contacts
    LICON(cx + 0.61, cy + 0.55)      # NFET source -> VSS
    LICON(cx + 0.61, cy + 0.90)      # NFET drain -> Y
    LICON(cx + 2.22, cy + 0.90)      # PFET source -> VDD
    LICON(cx + 2.22, cy + 0.55)      # PFET drain -> Y

    # Metal1: connect drains (Y)
    M1V(cx + 0.61, cy + 0.55, cy + 0.90)
    M1H(cx + 0.61, cx + 2.22, cy + 0.90)
    M1V(cx + 2.22, cy + 0.55, cy + 0.90)

    # Output Y on metal1 right side
    M1V(cx + 3.05, cy + 0.55, cy + 0.90)
    M1H(cx + 2.22, cx + 3.05, cy + 0.90)
    LAB(PIN_M1, name_y, cx + 3.05, cy + 0.725)

    # Power: NFET source to VSS (bottom), PFET source to VDD (top)
    M1V(cx + 0.61, cy + 0.45, cy + 0.55)
    VIA(cx + 0.61, cy + 0.45)
    M1V(cx + 2.22, cy + 0.90, cy + 3.55)
    VIA(cx + 2.22, cy + 3.55)

def place_nand4(cx, cy, name_a, name_b, name_c, name_d, name_y):
    """NAND4: 4 NFETs in series, 4 PFETs in parallel."""
    # NFET series diffusion
    ndx, ndy = cx + 0.4, cy + 0.4
    ndw, ndl = 0.42, 0.15
    nd_sp = 0.21
    nd_ext = 0.25
    nd_h = 4 * ndl + 3 * nd_sp + 2 * nd_ext
    B(DIFF, ndx, ndy, ndx + ndw, ndy + nd_h)

    # NFET poly gates
    for g in range(4):
        gy = ndy + nd_ext + g * (ndl + nd_sp)
        B(POLY, ndx - 0.13, gy, ndx + ndw + 0.13, gy + ndl)

    # PFET parallel diffusions
    fdy = cy + 2.6
    fdh = 0.65
    fdw = 0.84
    fd_sp = 0.21
    fd_ext = 0.25
    fdx_list = []
    fx = cx + 0.4
    for g in range(4):
        B(DIFF, fx, fdy, fx + fdw, fdy + fdh)
        B(NWELL, fx - 0.18, fdy - 0.18, fx + fdw + 0.18, fdy + fdh + 0.18)
        gx = fx + (fdw - ndl) / 2
        B(POLY, gx - 0.13, fdy + fd_ext, gx + 0.13 + ndl, fdy + fd_ext + ndl)
        fdx_list.append(fx)
        fx += fdw + fd_sp

    # Connect all PFET gates together (input D)
    B(POLY, fdx_list[0] + 0.42 - 0.075, fdy + fd_ext,
          fdx_list[3] + 0.42 + 0.075, fdy + fd_ext + ndl)

    # Inputs A,B,C on poly (left side, NFET gates)
    for g in range(3):
        gy = ndy + nd_ext + g * (ndl + nd_sp) + ndl / 2
        B(POLY, cx + 0.0, gy - 0.075, cx + 0.27, gy + 0.075)
        LAB(PIN_POLY, [name_a, name_b, name_c][g], cx + 0.135, gy)

    # Input D on poly (right side, PFET gates)
    dgy = fdy + fd_ext + ndl / 2
    B(POLY, cx + 4.23, dgy - 0.075, cx + 4.5, dgy + 0.075)
    LAB(PIN_POLY, name_d, cx + 4.365, dgy)

    # Contacts: NFET stack
    LICON(cx + 0.61, ndy + 0.15)                    # source -> VSS
    LICON(cx + 0.61, ndy + nd_h - 0.15)             # drain -> Y
    for g in range(1, 4):
        iy = ndy + nd_ext + (g - 1) * (ndl + nd_sp) + ndl + 0.1
        LICON(cx + 0.61, iy)                        # internal nodes

    # Contacts: PFET parallel
    for fx in fdx_list:
        LICON(fx + 0.42, fdy + fdh - 0.15)          # source -> VDD
        LICON(fx + 0.42, fdy + 0.15)                # drain -> Y

    # Metal1: connect PFET drains together
    M1H(fdx_list[0] + 0.42, fdx_list[3] + 0.42, fdy + 0.15)
    # Connect NFET drain to PFET drains (output Y)
    M1V(cx + 0.61, ndy + nd_h - 0.15, fdy + 0.15)

    # Output Y on metal1 right side
    M1V(cx + 4.05, ndy + nd_h - 0.15, fdy + fdh - 0.15)
    M1H(cx + 0.61, cx + 4.05, fdy + fdh - 0.15)
    LAB(PIN_M1, name_y, cx + 4.05, (ndy + nd_h - 0.15 + fdy + fdh - 0.15) / 2)

    # Power: NFET source to VSS, PFET sources to VDD
    M1V(cx + 0.61, ndy + 0.05, ndy + 0.15)
    VIA(cx + 0.61, ndy + 0.05)
    M1V(fdx_list[0] + 0.42, fdy + fdh - 0.15, cy + 3.55)
    VIA(fdx_list[0] + 0.42, cy + 3.55)

# ----------------------------------------------------------------------
# Place all cells
# ----------------------------------------------------------------------
# Row 0: input inverters
for i in range(4):
    cx = ORX + i * PX
    cy = ORY
    place_inv(cx, cy, f"A{i}", f"AB{i}")

# Rows 1-4: NAND4 gates
nand_map = [
    ("AB0", "AB1", "AB2", "AB3", "YB0"),
    ("A0",  "AB1", "AB2", "AB3", "YB1"),
    ("AB0", "A1",  "AB2", "AB3", "YB2"),
    ("A0",  "A1",  "AB2", "AB3", "YB3"),
    ("AB0", "AB1", "A2",  "AB3", "YB4"),
    ("A0",  "AB1", "A2",  "AB3", "YB5"),
    ("AB0", "A1",  "A2",  "AB3", "YB6"),
    ("A0",  "A1",  "A2",  "AB3", "YB7"),
    ("AB0", "AB1", "AB2", "A3",  "YB8"),
    ("A0",  "AB1", "AB2", "A3",  "YB9"),
    ("AB0", "A1",  "AB2", "A3",  "YB10"),
    ("A0",  "A1",  "AB2", "A3",  "YB11"),
    ("AB0", "AB1", "A2",  "A3",  "YB12"),
    ("A0",  "AB1", "A2",  "A3",  "YB13"),
    ("AB0", "A1",  "A2",  "A3",  "YB14"),
    ("A0",  "A1",  "A2",  "A3",  "YB15"),
]
for idx, (a, b, c, d, y) in enumerate(nand_map):
    r = idx // COLS
    c = idx % COLS
    cx = ORX + c * PX
    cy = ORY + (r + 1) * PY
    place_nand4(cx, cy, a, b, c, d, y)

# Rows 5-8: output inverters
for idx in range(16):
    r = idx // COLS
    c = idx % COLS
    cx = ORX + c * PX
    cy = ORY + (r + 5) * PY
    place_inv(cx, cy, f"YB{idx}", f"Y{idx}")

# ----------------------------------------------------------------------
# Global routing: address buses A0..A3 and AB0..AB3 (metal2 vertical)
# ----------------------------------------------------------------------
# Input pins A0..A3 on left side
for i in range(4):
    x = ORX - 0.8
    y1 = ORY + 0.5
    y2 = ORY + 9 * PY - 0.5
    M2V(x, y1, y2)
    LAB(PIN_M2, f"A{i}", x, y1 + 0.5)

# Complement buses AB0..AB3 from input inverters
for i in range(4):
    x = ORX + i * PX + 1.5
    y1 = ORY + 0.5
    y2 = ORY + 9 * PY - 0.5
    M2V(x, y1, y2)
    LAB(PIN_M2, f"AB{i}", x, y1 + 0.5)

# Route inputs to each NAND gate
for idx, (a, b, c, d, y) in enumerate(nand_map):
    r = idx // COLS
    c = idx % COLS
    ncx = ORX + c * PX
    ncy = ORY + (r + 1) * PY
    # Gate y positions within NAND cell
    ndy = ncy + 0.4
    nd_ext = 0.25
    ndl = 0.15
    nd_sp = 0.21
    gate_ys = [ndy + nd_ext + g * (ndl + nd_sp) + ndl / 2 for g in range(4)]
    fdy = ncy + 2.6
    fd_ext = 0.25
    dgy = fdy + fd_ext + ndl / 2

    inputs = [a, b, c, d]
    gate_y_list = gate_ys + [dgy]
    for g in range(4):
        sig = inputs[g]
        gy = gate_y_list[g]
        if sig.startswith("A"):
            i = int(sig[1])
            bx = ORX - 0.8
        else:
            i = int(sig[2])
            bx = ORX + i * PX + 1.5
        # Horizontal metal1 from bus to NAND gate
        M1H(bx, ncx + 0.4 - 0.13, gy)
        LICON(ncx + 0.4 - 0.13, gy)

# Route NAND outputs to output inverters
for idx in range(16):
    r = idx // COLS
    c = idx % COLS
    ncx = ORX + c * PX
    ncy = ORY + (r + 1) * PY
    ocx = ORX + c * PX
    ocy = ORY + (r + 5) * PY
    # NAND output Y is at right side of NAND cell
    # Output inverter input A is on poly at left side
    ndy = ncy + 0.4
    nd_ext = 0.25
    ndl = 0.15
    nd_sp = 0.21
    nd_h = 4 * ndl + 3 * nd_sp + 2 * nd_ext
    out_y = ndy + nd_h - 0.15
    inv_gy = ocy + 0.4 + 0.25 + ndl / 2
    # Route with metal1
    M1V(ncx + 4.05, out_y, ocy + 0.275)
    M1H(ncx + 4.05, ocx + 0.135, ocy + 0.275)

# Output pins Y0..Y15 on right side
for idx in range(16):
    r = idx // COLS
    c = idx % COLS
    ocx = ORX + c * PX
    ocy = ORY + (r + 5) * PY
    x = ORX + 4 * PX + 0.8
    y = ocy + 0.725
    M2H(ocx + 3.05, x, y)
    LAB(PIN_M2, f"Y{idx}", x, y)

# ----------------------------------------------------------------------
# Power rails (metal2 horizontal)
# ----------------------------------------------------------------------
TOTAL_W = ORX + 4 * PX + 1.6
TOTAL_H = ORY + 9 * PY + 1.0
M2H(0, TOTAL_W, 0.5, w=2.0)       # VSS
M2H(0, TOTAL_W, TOTAL_H - 0.5, w=2.0)  # VDD
LAB(PIN_M2, "VSS", 1.0, 0.5)
LAB(PIN_M2, "VDD", 1.0, TOTAL_H - 0.5)

# ----------------------------------------------------------------------
# N-well taps
# ----------------------------------------------------------------------
for r in range(4):
    for c in range(4):
        cx = ORX + c * PX
        cy = ORY + (r + 1) * PY
        B(TAP, cx + 2.6, cy + 2.6, cx + 3.02, cy + 3.25)
        B(NWELL, cx + 2.42, cy + 2.42, cx + 3.20, cy + 3.43)
        LICON(cx + 2.81, cy + 2.925)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("dec4to16.gds")
print(f"Wrote dec4to16.gds, size: {TOTAL_W} x {TOTAL_H} = {TOTAL_W*TOTAL_H:.1f} um^2")
print("Devices: 84 nfet + 84 pfet = 168 total")
