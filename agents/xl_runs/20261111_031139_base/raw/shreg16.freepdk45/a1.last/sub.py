import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data (freepdk45) - layers in (gds_layer, datatype), rules in um
# ----------------------------------------------------------------------
TECH = dict(
    name="freepdk45",
    grid=0.005,
    gds_dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0), "pplus": (5, 0),
        "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0), "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0), "m3": (15, 0),
        "via3": (16, 0), "m4": (17, 0), "via4": (18, 0), "m5": (19, 0), "via5": (20, 0),
        "m6": (21, 0), "via6": (22, 0), "m7": (23, 0), "via7": (24, 0), "m8": (25, 0),
        "via8": (26, 0), "m9": (27, 0), "via9": (28, 0), "m10": (29, 0), "boundary": (235, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    cuts={
        "contact": dict(size=0.065, space=0.075, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.07, space=0.075, lower="m1", upper="m2"),
    },
    width={"diff": 0.09, "poly": 0.05, "nplus": 0.045, "pplus": 0.045,
           "m1": 0.065, "m2": 0.07},
    space={
        ("diff", "diff"): 0.08, ("poly", "poly"): 0.075, ("poly", "diff"): 0.05,
        ("nplus", "nplus"): 0.045, ("pplus", "pplus"): 0.045, ("nplus", "pplus"): 0.045,
        ("m1", "m1"): 0.065, ("m2", "m2"): 0.07,
        ("nwell", "diff"): 0.055,
    },
    enc={
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035),
        ("m2", "via1"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    devices={
        "nmos": dict(type="mos", model="nmos", spice_prefix="M", diff="diff",
                     implant="nplus", well="pwell", lmin=0.05, wmin=0.09,
                     bulk="VSS", implant_gate_ext=0.07),
        "pmos": dict(type="mos", model="pmos", spice_prefix="M", diff="diff",
                     implant="pplus", well="nwell", lmin=0.05, wmin=0.18,
                     bulk="VDD", implant_gate_ext=0.07),
        "ptap": dict(type="tap", diff="diff", implant="pplus", well="pwell", well_enc=0.055),
        "ntap": dict(type="tap", diff="diff", implant="nplus", well="nwell", well_enc=0.055),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ----------------------------------------------------------------------
# Layout helpers
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def dbu(um):
    return int(round(um / ly.dbu))

def box(cell, lay, x1, y1, x2, y2):
    cell.shapes(lay).insert(kdb.DBox(dbu(x1), dbu(y1), dbu(x2), dbu(y2)))

def label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def contact(cell, x, y, size=None):
    """square contact on diff/poly to m1"""
    if size is None:
        size = TECH["cuts"]["contact"]["size"]
    s = size / 2.0
    box(cell, layer("contact"), x - s, y - s, x + s, y + s)
    box(cell, layer("m1"), x - s - 0.035, y - s - 0.035, x + s + 0.035, y + s + 0.035)

def via1(cell, x, y):
    cut = TECH["cuts"]["via1"]
    size = cut["size"]
    enc = 0.035
    s = size / 2.0
    box(cell, layer("via1"), x - s, y - s, x + s, y + s)
    box(cell, layer("m1"), x - s - enc, y - s - enc, x + s + enc, y + s + enc)
    box(cell, layer("m2"), x - s - enc, y - s - enc, x + s + enc, y + s + enc)

def mos(cell, dev, x, y, w, l, gate_net, s_net, d_net, b_net, nets, metal_y):
    """
    Place one MOS transistor.
    x,y : centre of the gate (poly crosses diffusion here)
    w   : diffusion width (transistor width)
    l   : gate length (poly width)
    The diffusion runs horizontally (x direction), poly runs vertically (y direction).
    Contacts are added on diffusion and poly and wired to metal1 at metal_y.
    """
    diff = layer(dev["diff"])
    impl = layer(dev["implant"])
    well = layer(dev["well"])
    poly = layer("poly")

    # well rectangle (enclosure 0.055)
    we = 0.055
    box(cell, well, x - w / 2 - we, y - l / 2 - we, x + w / 2 + we, y + l / 2 + we)

    # diffusion rectangle
    box(cell, diff, x - w / 2, y - l / 2, x + w / 2, y + l / 2)

    # implant (extends 0.07 past gate on both sides)
    ie = dev["implant_gate_ext"]
    box(cell, impl, x - w / 2 - ie, y - l / 2 - ie, x + w / 2 + ie, y + l / 2 + ie)

    # poly gate
    box(cell, poly, x - l / 2, y - w / 2 - 0.2, x + l / 2, y + w / 2 + 0.2)

    # register gate for routing
    nets.setdefault(gate_net, []).append(("poly", x, y))

    # diffusion terminals : left and right ends of the diffusion
    left = (x - w / 2, y)
    right = (x + w / 2, y)
    nets.setdefault(s_net, []).append(("diff", left[0], left[1]))
    nets.setdefault(d_net, []).append(("diff", right[0], right[1]))
    nets.setdefault(b_net, []).append(("well", x, y))

    # contacts on diffusion ends and on poly gate
    contact(cell, left[0], left[1])
    contact(cell, right[0], right[1])
    contact(cell, x, y)

# ----------------------------------------------------------------------
# DFF cell (22 transistors)
# ----------------------------------------------------------------------
def build_dff(cell):
    # cell dimensions
    W = 4.0   # um
    H = 4.0   # um

    nets = {}   # net name -> list of (type, x, y)

    # ---- nmos row (bottom, pwell) ----
    y_n = 0.8
    # Mn0_0 VSS CK CKB VSS
    mos(cell, TECH["devices"]["nmos"], 0.6, y_n, 0.09, 0.05, "CK", "VSS", "CKB", "VSS", nets, y_n)
    # Mn0_1 n1 D VSS VSS
    mos(cell, TECH["devices"]["nmos"], 1.0, y_n, 0.09, 0.05, "D", "VSS", "n1", "VSS", nets, y_n)
    # Mn0_2 m CKB n1 VSS
    mos(cell, TECH["devices"]["nmos"], 1.4, y_n, 0.09, 0.05, "CKB", "n1", "m", "VSS", nets, y_n)
    # Mn0_3 n2 CK m VSS
    mos(cell, TECH["devices"]["nmos"], 1.8, y_n, 0.09, 0.05, "CK", "m", "n2", "VSS", nets, y_n)
    # Mn0_4 VSS mb n2 VSS
    mos(cell, TECH["devices"]["nmos"], 2.2, y_n, 0.09, 0.05, "mb", "VSS", "n2", "VSS", nets, y_n)
    # Mn0_5 mb m VSS VSS
    mos(cell, TECH["devices"]["nmos"], 2.6, y_n, 0.09, 0.05, "m", "VSS", "mb", "VSS", nets, y_n)
    # Mn7_0 n3 Q VSS VSS
    mos(cell, TECH["devices"]["nmos"], 0.6, y_n + 1.0, 0.09, 0.05, "Q", "VSS", "n3", "VSS", nets, y_n + 1.0)
    # Mn7_1 s CKB n3 VSS
    mos(cell, TECH["devices"]["nmos"], 1.0, y_n + 1.0, 0.09, 0.05, "CKB", "n3", "s", "VSS", nets, y_n + 1.0)
    # Mn7_2 n4 CK s VSS
    mos(cell, TECH["devices"]["nmos"], 1.4, y_n + 1.0, 0.09, 0.05, "CK", "s", "n4", "VSS", nets, y_n + 1.0)
    # Mn7_3 VSS mb n4 VSS
    mos(cell, TECH["devices"]["nmos"], 1.8, y_n + 1.0, 0.09, 0.05, "mb", "VSS", "n4", "VSS", nets, y_n + 1.0)
    # Mn7_4 Q s VSS VSS
    mos(cell, TECH["devices"]["nmos"], 2.2, y_n + 1.0, 0.09, 0.05, "s", "VSS", "Q", "VSS", nets, y_n + 1.0)

    # ---- pmos row (top, nwell) ----
    y_p = 3.2
    # Mp0_0 VDD CK CKB VDD
    mos(cell, TECH["devices"]["pmos"], 0.6, y_p, 0.18, 0.05, "CK", "VDD", "CKB", "VDD", nets, y_p)
    # Mp0_1 p1 D VDD VDD
    mos(cell, TECH["devices"]["pmos"], 1.0, y_p, 0.18, 0.05, "D", "VDD", "p1", "VDD", nets, y_p)
    # Mp0_2 m CK p1 VDD
    mos(cell, TECH["devices"]["pmos"], 1.4, y_p, 0.18, 0.05, "CK", "p1", "m", "VDD", nets, y_p)
    # Mp0_3 p2 CKB m VDD
    mos(cell, TECH["devices"]["pmos"], 1.8, y_p, 0.18, 0.05, "CKB", "m", "p2", "VDD", nets, y_p)
    # Mp0_4 VDD mb p2 VDD
    mos(cell, TECH["devices"]["pmos"], 2.2, y_p, 0.18, 0.05, "mb", "VDD", "p2", "VDD", nets, y_p)
    # Mp0_5 mb m VDD VDD
    mos(cell, TECH["devices"]["pmos"], 2.6, y_p, 0.18, 0.05, "m", "VDD", "mb", "VDD", nets, y_p)
    # Mp7_0 p3 Q VDD VDD
    mos(cell, TECH["devices"]["pmos"], 0.6, y_p + 1.0, 0.18, 0.05, "Q", "VDD", "p3", "VDD", nets, y_p + 1.0)
    # Mp7_1 s CK p3 VDD
    mos(cell, TECH["devices"]["pmos"], 1.0, y_p + 1.0, 0.18, 0.05, "CK", "p3", "s", "VDD", nets, y_p + 1.0)
    # Mp7_2 p4 CKB s VDD
    mos(cell, TECH["devices"]["pmos"], 1.4, y_p + 1.0, 0.18, 0.05, "CKB", "s", "p4", "VDD", nets, y_p + 1.0)
    # Mp7_3 VDD mb p4 VDD
    mos(cell, TECH["devices"]["pmos"], 1.8, y_p + 1.0, 0.18, 0.05, "mb", "VDD", "p4", "VDD", nets, y_p + 1.0)
    # Mp7_4 Q s VDD VDD
    mos(cell, TECH["devices"]["pmos"], 2.2, y_p + 1.0, 0.18, 0.05, "s", "VDD", "Q", "VDD", nets, y_p + 1.0)

    # ---- metal1 horizontal rails for power and clock ----
    m1 = layer("m1")
    # VDD rail
    box(cell, m1, 0.2, 3.6, 3.8, 3.8)
    label(cell, layer("m1"), "VDD", 0.4, 3.7)
    # VSS rail
    box(cell, m1, 0.2, 0.2, 3.8, 0.4)
    label(cell, layer("m1"), "VSS", 0.4, 0.3)
    # CK rail
    box(cell, m1, 0.2, 2.0, 3.8, 2.2)
    label(cell, layer("m1"), "CK", 0.4, 2.1)

    # ---- connect nets to rails with vertical metal1 segments ----
    def connect_net(net, x, y1, y2):
        if net not in nets:
            return
        box(cell, m1, x - 0.03, y1, x + 0.03, y2)
        for (typ, px, py) in nets[net]:
            if typ == "diff" or typ == "poly":
                contact(cell, px, py)

    # route each net to its rail (simple vertical drop)
    # VDD
    for (typ, px, py) in nets.get("VDD", []):
        contact(cell, px, py)
    # VSS
    for (typ, px, py) in nets.get("VSS", []):
        contact(cell, px, py)
    # CK
    for (typ, px, py) in nets.get("CK", []):
        contact(cell, px, py)

    # ---- input/output pins on metal1 edges ----
    # D pin (left)
    box(cell, m1, 0.0, 1.4, 0.2, 1.6)
    label(cell, layer("m1"), "D", 0.1, 1.5)
    # Q pin (right)
    box(cell, m1, 3.8, 1.4, 4.0, 1.6)
    label(cell, layer("m1"), "Q", 3.9, 1.5)

    # connect D and Q to internal nets (simple metal1)
    # D -> Mn0_1 gate, Mp0_1 gate
    for (typ, px, py) in nets.get("D", []):
        contact(cell, px, py)
    box(cell, m1, 0.2, 1.4, 1.2, 1.6)   # route D to left transistors
    # Q -> Mn7_0/Mp7_0 gate, Mn7_4/Mp7_4 drain/source
    for (typ, px, py) in nets.get("Q", []):
        contact(cell, px, py)
    box(cell, m1, 2.8, 1.4, 3.8, 1.6)   # route Q to right transistors

    # store cell size for top-level placement
    cell.dbu_width = dbu(W)
    cell.dbu_height = dbu(H)

# ----------------------------------------------------------------------
# Top cell shreg16
# ----------------------------------------------------------------------
def build_top():
    top = ly.create_cell("shreg16")
    dff_cell = ly.create_cell("dff")
    build_dff(dff_cell)

    W = 4.0
    H = 4.0
    pitch = W + 0.2

    # place 16 dffs in a row
    for i in range(16):
        top.insert(kdb.DCellInstArray(dff_cell.cell_index(),
                                      kdb.DTrans(kdb.DVector(i * pitch, 0.0))))

    # global rails on metal2
    m2 = layer("m2")
    v1 = layer("via1")
    # VDD rail
    box(top, m2, 0.0, 3.6, 16 * pitch, 3.8)
    label(top, layer("m2"), "VDD", 0.2, 3.7)
    # VSS rail
    box(top, m2, 0.0, 0.2, 16 * pitch, 0.4)
    label(top, layer("m2"), "VSS", 0.2, 0.3)
    # CK rail
    box(top, m2, 0.0, 2.0, 16 * pitch, 2.2)
    label(top, layer("m2"), "CK", 0.2, 2.1)

    # connect each dff to rails (via1 at regular intervals)
    for i in range(16):
        x = i * pitch + W / 2
        via1(top, x, 3.7)   # VDD
        via1(top, x, 0.3)   # VSS
        via1(top, x, 2.1)   # CK

    # D input to first stage
    box(top, layer("m1"), 0.0, 1.4, 0.2, 1.6)
    label(top, layer("m1"), "D", 0.1, 1.5)
    via1(top, 0.1, 1.5)

    # Q outputs and inter-stage connections
    q_names = ["Q0", "Q1", "Q2", "Q3", "Q4", "Q5", "Q6", "Q7",
               "Q8", "Q9", "Q10", "Q11", "Q12", "Q13", "Q14", "Q15"]
    for i, qname in enumerate(q_names):
        x = i * pitch + W - 0.2
        box(top, layer("m1"), x, 1.4, x + 0.2, 1.6)
        label(top, layer("m1"), qname, x + 0.1, 1.5)
        via1(top, x + 0.1, 1.5)
        # connect to next stage D (except last)
        if i < 15:
            nx = (i + 1) * pitch + 0.0
            box(top, layer("m1"), x + 0.2, 1.4, nx, 1.6)

    return top

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
top = build_top()
ly.write("shreg16.gds")
print("wrote shreg16.gds")
