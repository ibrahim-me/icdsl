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

CW, CH = 1.66, 2.46          # cell pitch (x: bitline dir, y: wordline dir)
COLS, ROWS = 8, 16

ly = kdb.Layout()
ly.dbu = TECH["dbu"]
top = ly.create_cell("sram16x8")

L = {name: ly.layer(*tp) for name, tp in TECH["layers"].items()}
LAB = {m: ly.layer(*tp) for m, tp in TECH["label"].items()}

def dbu(um): return um / TECH["dbu"]
def box(x1, y1, x2, y2):
    return kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2))

def rect(cell, layer, x, y, w, h):
    cell.shapes(layer).insert(box(x, y, x + w, y + h))

def contact(cell, x, y, layers=("diff", "poly", "m1"), size=0.065):
    """contact pad: cut + metal on all listed layers, centered at (x,y)"""
    h = size / 2
    for lname in layers:
        rect(cell, L[lname], x - h, y - h, size, size)
    if "m1" in layers:
        rect(cell, L["m1"], x - h - 0.035, y - h - 0.035, size + 0.07, size + 0.07)

def via(cell, x, y, lower, upper, size=None):
    info = TECH["cuts"].get(lower + "1" if False else "")  # placeholder
