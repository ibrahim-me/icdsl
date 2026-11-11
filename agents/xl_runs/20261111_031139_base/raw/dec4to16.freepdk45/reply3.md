```
import klayout.db as kdb

# -----------------------------------------------------------------------------
# PDK data (freepdk45) - layers in (gds, datatype), rules in um
# -----------------------------------------------------------------------------
TECH = dict(
    name="freepdk45",
    grid=0.005,
    gds_dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0),
        "pplus": (5, 0), "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0),
        "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0),
        "m3": (15, 0), "via3": (16, 0), "m4": (17, 0), "via4": (18, 0),
        "m5": (19, 0), "via5": (20, 0), "m6": (21, 0), "via6": (22, 0),
        "m7": (23, 0), "via7": (24, 0), "m8": (25, 0), "via8": (26, 0),
        "m9": (27, 0), "via9": (28, 0), "m10": (29, 0), "boundary": (235, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    width={"diff": 0.09, "poly": 0.05, "nplus": 0.045, "pplus": 0.045,
           "m1": 0.065, "m2": 0.07, "m3": 0.07, "m4": 0.14, "m5": 0.14,
           "m6": 0.14, "m7": 0.40, "m8": 0.40, "m9": 0.80, "m10": 0.80},
    space={
        ("nwell", "nwell"): 0.225, ("pwell", "pwell"): 0.225, ("nwell", "pwell"): 0.20,
        ("diff", "diff"): 0.08, ("poly", "poly"): 0.075, ("poly", "diff"): 0.05,
        ("nplus", "nplus"): 0.045, ("pplus", "pplus"): 0.045, ("nplus", "pplus"): 0.045,
        ("m1", "m1"): 0.065, ("m2", "m2"): 0.07, ("m3", "m3"): 0.07,
        ("m4", "m4"): 0.14, ("m5", "m5"): 0.14, ("m6", "m6"): 0.14,
        ("m7", "m7"): 0.40, ("m8", "m8"): 0.40, ("m9", "m9"): 0.80,
        ("m10", "m10"): 0.80, ("nwell", "diff"): 0.055,
    },
    enc={
        ("diff", "contact"): (0.005, 0.005), ("poly", "contact"): (0.005, 0.005),
        ("m1", "contact"): (0.0, 0.035), ("m1", "via1"): (0.0, 0.035),
        ("m2", "via1"): (0.0, 0.035), ("m2", "via2"): (0.0, 0.035),
        ("m3", "via2"): (0.0, 0.035), ("m3", "via3"): (0.0, 0.035),
        ("nplus", "diff"): (0.035, 0.035), ("pplus", "diff"): (0.035, 0.035),
        ("nwell", "diff"): (0.055, 0.055), ("pwell", "diff"): (0.055, 0.055),
    },
    cuts={
        "contact": dict(size=0.065, space=0.075, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.07, space=0.075, lower="m1", upper="m2"),
    },
    devices={
        "nmos": dict(diff="diff", implant="nplus", well="pwell", w=0.09, l=0.05),
        "pmos": dict(diff="diff", implant="pplus", well="nwell", w=0.18, l=0.05),
    },
)

# -----------------------------------------------------------------------------
# Geometry helpers
# -----------------------------------------------------------------------------
LY = None
TOP = None
LAYERS = {}


def dbu(um):
    return int(round(um / TECH["gds_dbu"]))


def dbox(box):
    return kdb.DBox(dbu(box[0]), dbu(box[1]), dbu(box[2]), dbu(box[3]))


def rect(cell, name, x1, y1, x2, y2):
    cell.shapes(LAYERS[name]).insert(dbox((x1, y1, x2, y2)))


def label(cell, name, text, x, y):
    cell.shapes(LAYERS[name]).insert(
        kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))


def via(cell, name, x, y, size):
    rect(cell, name, x - size / 2, y - size / 2, x + size / 2, y + size / 2)


def m1_wire(cell, x1, y1, x2, y2, width=TECH["width"]["m1"]):
    if x1 == x2:
        rect(cell, "m1", x1 - width / 2, y1, x1 + width / 2, y2)
    else:
        rect(cell, "m1", x1, y1 - width / 2, x2, y1 + width / 2)


def m2_wire(cell, x1, y1, x2, y2, width=TECH["width"]["m2"]):
    if x1 == x2:
        rect(cell, "m2", x1 - width / 2, y1, x1 + width / 2, y2)
    else:
        rect(cell, "m2", x1, y1 - width / 2, x2, y1 + width / 2)


def contact(cell, x, y, size=TECH["cuts"]["contact"]["size"]):
    via(cell, "contact", x, y, size)


def via1(cell, x, y, size=TECH["cuts"]["via1"]["size"]):
    via(cell, "via1", x, y, size)


# -----------------------------------------------------------------------------
# Transistor / cell generators
# -----------------------------------------------------------------------------
def well(cell, kind, x1, y1, x2, y2):
    rect(cell, kind, x1, y1, x2, y2)


def diff_implant(cell, kind, x1, y1, x2, y2):
    enc = TECH["enc"][(kind + "plus", "diff")][0]
    rect(cell, "diff", x1, y1, x2, y2)
    rect(cell, kind + "plus", x1 + enc, y1 + enc, x2 - enc, y2 - enc)


def mos(cell, kind, x, y, w, l, gate_ext=0.055, active_ext=0.07):
    dev = TECH["devices"][kind]
    well_kind = dev["well"]
    impl_kind = dev["implant"]
    x1 = x - w / 2 - gate_ext
    x2 = x + w / 2 + gate_ext
    y1 = y - active_ext - l / 2
    y2 = y + active_ext + l / 2
    well(cell, well_kind, x1 - 0.055, y1 - 0.055, x2 + 0.055, y2 + 0.055)
    diff_implant(cell, impl_kind, x1, y1, x2, y2)
    rect(cell, "poly", x1, y - l / 2, x2, y + l / 2)
    return dict(x=x, y=y, w=w, l=l, x1=x1, x2=x2, y1=y1, y2=y2,
                gate_y1=y - l / 2, gate_y2=y + l / 2)


def cell_pin(cell, net, x, y, width=0.14, height=0.14):
    rect(cell, "m1", x - width / 2, y - height / 2, x + width / 2, y + height / 2)
    label(cell, "m1", net, x, y)


# -----------------------------------------------------------------------------
# Standard cells
# -----------------------------------------------------------------------------
CELL_W = 2.62
CELL_H = 1.62
PITCH_X = CELL_W + 0.18
PITCH_Y = CELL_H + 0.12


def inv_cell(name):
    c = ly.create_cell(name)
    cx = CELL_W / 2
    cy = CELL_H / 2
    pmos_y = cy + 0.30
    nmos_y = cy - 0.30
    mos(c, "pmos", cx, pmos_y, 0.18, 0.05)
    mos(c, "nmos", cx, nmos_y, 0.09, 0.05)
    m1_wire(c, 0.18, cy, CELL_W - 0.18, cy, width=0.14)
    contact(c, cx, pmos_y - 0.105)
    contact(c, cx, nmos_y + 0.105)
    contact(c, cx, cy)
    via1(c, cx, cy)
    cell_pin(c, "A", 0.18, cy)
    cell_pin(c, "Y", cx, cy)
    cell_pin(c, "VDD", cx, pmos_y - 0.105)
    cell_pin(c, "VSS", cx, nmos_y + 0.105)
    return c


def nand4_cell(name):
    c = ly.create_cell(name)
    cx = CELL_W / 2
    cy = CELL_H / 2
    nmos_x = cx - 0.55
    gate_y = [cy - 0.42, cy - 0.14, cy + 0.14, cy + 0.42]
    for i, gy in enumerate(gate_y):
        mos(c, "nmos", nmos_x, gy, 0.09, 0.05)
    pmos_x = [cx - 0.55, cx - 0.18, cx + 0.18, cx + 0.55]
    for px in pmos_x:
        mos(c, "pmos", px, cy, 0.18, 0.05)
    m1_wire(c, 0.18, cy, CELL_W - 0.18, cy, width=0.14)
    contact(c, nmos_x, cy - 0.62)
    contact(c, nmos_x, cy + 0.62)
    contact(c, cx, cy)
    via1(c, cx, cy)
    for px in pmos_x:
        contact(c, px, cy - 0.105)
        contact(c, px, cy + 0.105)
    cell_pin(c, "A", 0.18, gate_y[0])
    cell_pin(c, "B", 0.18, gate_y[1])
    cell_pin(c, "C", 0.18, gate_y[2])
    cell_pin(c, "D", 0.18, gate_y[3])
    cell_pin(c, "Y", cx, cy)
    cell_pin(c, "VDD", cx, cy - 0.105)
    cell_pin(c, "VSS", nmos_x, cy - 0.62)
    return c


# -----------------------------------------------------------------------------
# Global routing helpers
# -----------------------------------------------------------------------------
def place_and_route():
    inv = inv_cell("inv")
    nand4 = nand4_cell("nand4")

    cols = 4
    rows = 9
    origin_x = 0.6
    origin_y = 0.6

    order = []
    for i in range(4):
        order.append(("inv", "IA%d" % i, ["A%d" % i], ["AB%d" % i]))
    nand_insts = [
        ("N0", ["AB0", "AB1", "AB2", "AB3"], "YB0"),
        ("N1", ["A0", "AB1", "AB2", "AB3"], "YB1"),
        ("N2", ["AB0", "A1", "AB2", "AB3"], "YB2"),
        ("N3", ["A0", "A1", "AB2", "AB3"], "YB3"),
        ("N4", ["AB0", "AB1", "A2", "AB3"], "YB4"),
        ("N5", ["A0", "AB1", "A2", "AB3"], "YB5"),
        ("N6", ["AB0", "A1", "A2", "AB3"], "YB6"),
        ("N7", ["A0", "A1", "A2", "AB3"], "YB7"),
        ("N8", ["AB0", "AB1", "AB2", "A3"], "YB8"),
        ("N9", ["A0", "AB1", "AB2", "A3"], "YB9"),
        ("N10", ["AB0", "A1", "AB2", "A3"], "YB10"),
        ("N11", ["A0", "A1", "AB2", "A3"], "YB11"),
        ("N12", ["AB0", "AB1", "A2", "A3"], "YB12"),
        ("N13", ["A0", "AB1", "A2", "A3"], "YB13"),
        ("N14", ["AB0", "A1", "A2", "A3"], "YB14"),
        ("N15", ["A0", "A1", "A2", "A3"], "YB15"),
    ]
    for name, ins, out in nand_insts:
        order.append(("nand4", name, ins, [out]))
    for i in range(16):
        order.append(("inv", "I%d" % i, ["YB%d" % i], ["Y%d" % i]))

    insts = []
    for idx, (kind, name, ins, outs) in enumerate(order):
        col = idx % cols
        row = idx // cols
        x = origin_x + col * PITCH_X + CELL_W / 2
        y = origin_y + row * PITCH_Y + CELL_H / 2
        sub = inv if kind == "inv" else nand4
        TOP.insert(kdb.DCellInstArray(sub.cell_index(),
                                      kdb.DTrans(dbu(x - CELL_W / 2),
                                                 dbu(y - CELL_H / 2))))
        insts.append(dict(name=name, kind=kind, x=x, y=y, ins=ins, outs=outs))

    vdd_y = origin_y + rows * PITCH_Y + 0.30
    vss_y = -0.30
    rail_x_end = origin_x + (cols - 1) * PITCH_X + CELL_W + 0.3
    m2_wire(TOP, origin_x - 0.3, vdd_y, rail_x_end, vdd_y, width=0.2)
    m2_wire(TOP, origin_x - 0.3, vss_y, rail_x_end, vss_y, width=0.2)
    label(TOP, "m2", "VDD", rail_x_end - 0.15, vdd_y)
    label(TOP, "m2", "VSS", rail_x_end - 0.15, vss_y)

    for inst in insts:
        cx, cy = inst["x"], inst["y"]
        m1_wire(TOP, cx, cy, cx, vdd_y, width=0.14)
        via1(TOP, cx, vdd_y)
        m1_wire(TOP, cx, cy, cx, vss_y, width=0.14)
        via1(TOP, cx, vss_y)

    input_bus_x = origin_x - 0.55
    m2_wire(TOP, input_bus_x, origin_y, input_bus_x,
            origin_y + 3 * PITCH_Y + CELL_H, width=0.1)
    label(TOP, "m2", "A0", input_bus_x, origin_y + 0.5 * PITCH_Y)
    label(TOP, "m2", "A1", input_bus_x, origin_y + 1.5 * PITCH_Y)
    label(TOP, "m2", "A2", input_bus_x, origin_y + 2.5 * PITCH_Y)
    label(TOP, "m2", "A3", input_bus_x, origin_y + 3.5 * PITCH_Y)
    for inst in insts[:4]:
        i = int(inst["name"][2:])
        ax = input_bus_x
        ay = inst["y"]
        m2_wire(TOP, ax, ay, inst["x"] - CELL_W / 2 + 0.18, ay, width=0.1)
        via1(TOP, inst["x"] - CELL_W / 2 + 0.18, ay)
        ab_x = inst["x"] + CELL_W / 2 - 0.18
        m1_wire(TOP, inst["x"], inst["y"], ab_x, inst["y"], width=0.1)
        label(TOP, "m1", "AB%d" % i, ab_x, inst["y"])

    for inst in insts[4:20]:
        cx, cy = inst["x"], inst["y"]
        for k, net in enumerate(inst["ins"]):
            if net.startswith("AB"):
                i = int(net[2:])
                src = insts[i]
                sx = src["x"] + CELL_W / 2 - 0.18
                sy = src["y"]
            else:
                i = int(net[1])
                sx = input_bus_x
                sy = origin_y + (i + 0.5) * PITCH_Y
            gy = cy - 0.42 + k * 0.28
            m1_wire(TOP, sx, sy, cx - CELL_W / 2 + 0.18, gy, width=0.1)
            via1(TOP, cx - CELL_W / 2 + 0.18, gy)
            m1_wire(TOP, cx - CELL_W / 2 + 0.18, gy, cx - CELL_W / 2 + 0.18, cy, width=0.1)
        yb_x = cx
        yb_y = cy
        idx = insts.index(inst)
        out_inv = insts[20 + (idx - 4)]
        m1_wire(TOP, yb_x, yb_y, out_inv["x"], out_inv["y"], width=0.1)
        label(TOP, "m1", inst["outs"][0], yb_x, yb_y)

    output_bus_x = origin_x + (cols - 1) * PITCH_X + CELL_W + 0.55
    m2_wire(TOP, output_bus_x, origin_y, output_bus_x,
            origin_y + 15 * PITCH_Y + CELL_H, width=0.1)
    for i in range(16):
        inst = insts[20 + i]
        ix = output_bus_x
        iy = inst["y"]
        m2_wire(TOP, inst["x"] + CELL_W / 2 - 0.18, inst["y"], ix, iy, width=0.1)
        via1(TOP, ix, iy)
        label(TOP, "m2", "Y%d" % i, ix, iy)

    label(TOP, "m1", "VDD", rail_x_end - 0.15, vdd_y)
    label(TOP, "m1", "VSS", rail_x_end - 0.15, vss_y)
    for i in range(4):
        label(TOP, "m1", "A%d" % i, input_bus_x, origin_y + (i + 0.5) * PITCH_Y)
    for i in range(16):
        label(TOP, "m1", "Y%d" % i, output_bus_x, origin_y + i * PITCH_Y + CELL_H / 2)

    bbox = TOP.bbox()
    rect(TOP, "boundary", bbox.left, bbox.bottom, bbox.right, bbox.top)


# -----------------------------------------------------------------------------
# Main build
# -----------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]
TOP = ly.create_cell("dec4to16")
LAYERS = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}

place_and_route()

ly.write("dec4to16.gds")

```