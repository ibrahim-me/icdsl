import klayout.db as kdb

# ---------------------------------------------------------------- technology
TECH = dict(
    name="freepdk45",
    grid=0.005,
    dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0),
        "pplus": (5, 0), "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0),
        "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0),
        "m3": (15, 0), "via3": (16, 0), "m4": (17, 0), "via4": (18, 0),
        "m5": (19, 0), "via5": (20, 0), "m6": (21, 0), "via6": (22, 0),
        "m7": (23, 0), "via7": (24, 0), "m8": (25, 0), "via8": (26, 0),
        "m9": (27, 0), "via9": (28, 0), "m10": (29, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    width={"nwell": 0.20, "pwell": 0.20, "diff": 0.09, "poly": 0.05,
           "nplus": 0.045, "pplus": 0.045, "m1": 0.065, "m2": 0.07,
           "m3": 0.07, "m4": 0.14, "m5": 0.14, "m6": 0.14, "m7": 0.40,
           "m8": 0.40, "m9": 0.80, "m10": 0.80},
    space={("diff", "diff"): 0.08, ("poly", "poly"): 0.075,
           ("poly", "diff"): 0.05, ("m1", "m1"): 0.065, ("m2", "m2"): 0.07},
    enc={
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035),
        ("m2", "via1"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    rules=dict(gate_contact_space=0.035, poly_endcap=0.055,
               diff_ext_gate=0.07, tap_diff_space=0.105),
    devices=dict(
        nmos=dict(w=0.09, l=0.05, implant="nplus", well="pwell"),
        pmos=dict(w=0.18, l=0.05, implant="pplus", well="nwell"),
    ),
)

CW, CH = 2.0, 2.0          # cell pitch (x: bitline dir, y: wordline dir)
COLS, ROWS = 8, 16

ly = kdb.Layout()
ly.dbu = TECH["dbu"]
top = ly.create_cell("sram16x8")
cell = ly.create_cell("sram6t")

L = {name: ly.layer(*tp) for name, tp in TECH["layers"].items()}
LAB = {m: ly.layer(*tp) for m, tp in TECH["label"].items()}

def dbu(um): return um / TECH["dbu"]
def box(x1, y1, x2, y2):
    return kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2))

def rect(cell, layer, x, y, w, h):
    cell.shapes(layer).insert(box(x, y, x + w, y + h))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text,
        kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, x, y, size=0.065):
    h = size / 2
    rect(cell, L["contact"], x - h, y - h, size, size)
    rect(cell, L["m1"], x - h - 0.035, y - h - 0.035, size + 0.07, size + 0.07)

def via(cell, x, y, size=0.07):
    h = size / 2
    rect(cell, L["via1"], x - h, y - h, size, size)
    rect(cell, L["m1"], x - h - 0.035, y - h - 0.035, size + 0.07, size + 0.07)
    rect(cell, L["m2"], x - h - 0.035, y - h - 0.035, size + 0.07, size + 0.07)

# ---------------------------------------------------------------- cell
GW = 0.05          # poly gate width
ACT_H = 0.20       # diffusion height

# x positions of vertical poly gates (bitline direction)
g_accessL = 0.45   # WL gate  (Mn0_0)
g_pdL     = 0.75   # QB gate  (Mn0_1 / Mp1_0)
g_pdR     = 1.25   # Q gate   (Mn0_2 / Mp1_1)
g_accessR = 1.55   # WL gate  (Mn0_3)

# y positions (wordline direction)
Y_ACT_NMOS = 0.35          # nmos active strip centre
Y_ACT_PMOS = 1.65          # pmos active strip centre
Y_WL       = 1.00          # wordline m1 rail
Y_VDD      = 1.90          # vdd m1 rail
Y_VSS      = 0.10          # vss m1 rail
X_BL       = 0.35          # bitline m2 rail (left)
X_BLB      = 1.65          # bitlinebar m2 rail (right)

# wells (abut at y=1.0, allowed by PDK)
rect(cell, L["pwell"], 0.10, 0.00, CW - 0.20, 1.00)
rect(cell, L["nwell"], 0.10, 1.00, CW - 0.20, 1.00)

# poly gates (vertical strips, extend past active for endcap)
for gx in (g_accessL, g_pdL, g_pdR, g_accessR):
    rect(cell, L["poly"], gx - GW / 2, 0.10, GW, CH - 0.20)

# ---------- NMOS side (bottom) ----------
# left active: BL | WL | Q | QB | VSS
rect(cell, L["diff"], 0.20, Y_ACT_NMOS - ACT_H / 2, 0.80, ACT_H)
rect(cell, L["nplus"], 0.20, Y_ACT_NMOS - ACT_H / 2, 0.80, ACT_H)
# right active: VSS | Q | QB | WL | BLB
rect(cell, L["diff"], 1.00, Y_ACT_NMOS - ACT_H / 2, 0.80, ACT_H)
rect(cell, L["nplus"], 1.00, Y_ACT_NMOS - ACT_H / 2, 0.80, ACT_H)

# contacts left active
contact(cell, 0.35, Y_ACT_NMOS)          # BL -> Mn0_0 source
contact(cell, 0.65, Y_ACT_NMOS)          # Q node
contact(cell, 0.95, Y_ACT_NMOS)          # VSS -> Mn0_1 drain
# contacts right active
contact(cell, 1.05, Y_ACT_NMOS)          # VSS -> Mn0_2 drain
contact(cell, 1.25, Y_ACT_NMOS)          # QB node
contact(cell, 1.65, Y_ACT_NMOS)          # BLB -> Mn0_3 source

# ---------- PMOS side (top) ----------
# active: Q | QB | VDD | Q | QB
rect(cell, L["diff"], 0.20, Y_ACT_PMOS - ACT_H / 2, 0.80, ACT_H)
rect(cell, L["pplus"], 0.20, Y_ACT_PMOS - ACT_H / 2, 0.80, ACT_H)
rect(cell, L["diff"], 1.00, Y_ACT_PMOS - ACT_H / 2, 0.80, ACT_H)
rect(cell, L["pplus"], 1.00, Y_ACT_PMOS - ACT_H / 2, 0.80, ACT_H)

# contacts left active (Q | QB | VDD)
contact(cell, 0.35, Y_ACT_PMOS)          # Q -> Mp1_0 source
contact(cell, 0.65, Y_ACT_PMOS)          # QB -> Mp1_0 drain / Mp1_1 gate side
contact(cell, 0.95, Y_ACT_PMOS)          # VDD
# contacts right active (VDD | Q | QB)
contact(cell, 1.05, Y_ACT_PMOS)          # VDD
contact(cell, 1.25, Y_ACT_PMOS)          # Q
contact(cell, 1.65, Y_ACT_PMOS)          # QB -> Mp1_1 drain

# ---------- m1 horizontal rails ----------
rect(cell, L["m1"], 0.0, Y_WL - 0.0325, CW, 0.065)           # WL
rect(cell, L["m1"], 0.0, Y_VDD - 0.0325, CW, 0.065)          # VDD
rect(cell, L["m1"], 0.0, Y_VSS - 0.0325, CW, 0.065)          # VSS

# WL contacts to poly gates
contact(cell, g_accessL, Y_WL)
contact(cell, g_accessR, Y_WL)

# VDD contacts to pmos active
contact(cell, 0.95, Y_VDD)
contact(cell, 1.05, Y_VDD)

# VSS contacts to nmos active
contact(cell, 0.95, Y_VSS)
contact(cell, 1.05, Y_VSS)

# ---------- Q node metal (m1) ----------
# nmos Q (0.65,Y_ACT_NMOS) <-> pmos Q (1.25,Y_ACT_PMOS) <-> Q gate g_pdR(1.25)
# Use vertical m1 at x=0.95 (between actives, clear of WL rail at y=1.0)
YMID = (Y_ACT_NMOS + Y_ACT_PMOS) / 2   # 1.0
# Q node: connect nmos Q contact to pmos Q contact via vertical m1 at x=0.95
# But x=0.95 is where VSS/VDD contacts are... use x=1.15 instead
rect(cell, L["m1"], 0.65 - 0.0325, Y_ACT_NMOS - 0.0325, 0.065, 0.065)   # pad on nmos Q contact
rect(cell, L["m1"], 1.25 - 0.0325, Y_ACT_PMOS - 0.0325, 0.065, 0.065)   # pad on pmos Q contact
# vertical m1 connector at x=1.15 from y=0.35 to y=1.65
rect(cell, L["m1"], 1.15 - 0.0325, Y_ACT_NMOS, 0.065, Y_ACT_PMOS - Y_ACT_NMOS)
# connect to Q gate poly at g_pdR=1.25 via horizontal m1 at y=Y_ACT_NMOS
rect(cell, L["m1"], 1.15, Y_ACT_NMOS - 0.0325, 0.10, 0.065)   # from x=1.15 to 1.25 at nmos level

# ---------- QB node metal (m1) ----------
# nmos QB (1.25,Y_ACT_NMOS) <-> pmos QB (0.65,Y_ACT_PMOS) <-> QB gate g_pdL(0.75)
rect(cell, L["m1"], 1.25 - 0.0325, Y_ACT_NMOS - 0.0325, 0.065, 0.065)   # pad on nmos QB contact
rect(cell, L["m1"], 0.65 - 0.0325, Y_ACT_PMOS - 0.0325, 0.065, 0.065)   # pad on pmos QB contact
# vertical m1 connector at x=0.85 from y=0.35 to y=1.65
rect(cell, L["m1"], 0.85 - 0.0325, Y_ACT_NMOS, 0.065, Y_ACT_PMOS - Y_ACT_NMOS)
# connect to QB gate poly at g_pdL=0.75 via horizontal m1 at y=Y_ACT_PMOS
rect(cell, L["m1"], 0.75, Y_ACT_PMOS - 0.0325, 0.10, 0.065)   # from x=0.75 to 0.85 at pmos level

# ---------- m2 vertical bitlines + vias ----------
rect(cell, L["m2"], X_BL - 0.035, 0.0, 0.07, CH)
rect(cell, L["m2"], X_BLB - 0.035, 0.0, 0.07, CH)
via(cell, X_BL, Y_ACT_NMOS)      # BL to m1 contact pad
via(cell, X_BLB, Y_ACT_NMOS)     # BLB to m1 contact pad

# ---------- pins ----------
label(cell, LAB["m1"], "WL", CW / 2, Y_WL)
label(cell, LAB["m1"], "VDD", CW / 2, Y_VDD)
label(cell, LAB["m1"], "VSS", CW / 2, Y_VSS)
label(cell, LAB["m2"], "BL", X_BL, CH / 2)
label(cell, LAB["m2"], "BLB", X_BLB, CH / 2)

# ---------------------------------------------------------------- top array
for r in range(ROWS):
    for c in range(COLS):
        top.insert(kdb.DCellInstArray(cell.cell_index(),
            kdb.DTrans(c * CW, r * CH)))

# global rails on top
for r in range(ROWS):
    y = r * CH
    rect(top, L["m1"], 0.0, y + Y_WL - 0.0325, COLS * CW, 0.065)
    rect(top, L["m1"], 0.0, y + Y_VDD - 0.0325, COLS * CW, 0.065)
    rect(top, L["m1"], 0.0, y + Y_VSS - 0.0325, COLS * CW, 0.065)
    label(top, LAB["m1"], "WL%d" % r, COLS * CW / 2, y + Y_WL)
    label(top, LAB["m1"], "VDD", COLS * CW / 2, y + Y_VDD)
    label(top, LAB["m1"], "VSS", COLS * CW / 2, y + Y_VSS)

for c in range(COLS):
    x = c * CW
    rect(top, L["m2"], x + X_BL - 0.035, 0.0, 0.07, ROWS * CH)
    rect(top, L["m2"], x + X_BLB - 0.035, 0.0, 0.07, ROWS * CH)
    label(top, LAB["m2"], "BL%d" % c, x + X_BL, ROWS * CH / 2)
    label(top, LAB["m2"], "BLB%d" % c, x + X_BLB, ROWS * CH / 2)

ly.write("sram16x8.gds")
print("written sram16x8.gds, bbox um:",
      top.bbox().left * TECH["dbu"], top.bbox().bottom * TECH["dbu"],
      top.bbox().right * TECH["dbu"], top.bbox().top * TECH["dbu"])


