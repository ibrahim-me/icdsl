import klayout.db as kdb

# -----------------------------------------------------------------------------
# PDK data (sky130A) - layers and design rules in um
# -----------------------------------------------------------------------------
TECH = dict(
    dbu=0.001,
    layers=dict(
        poly=(66, 20),
        polyres=(66, 13),
        licon=(66, 44),
        li=(67, 20),
        mcon=(67, 44),
        m1=(68, 20),
        via=(68, 44),
        m2=(69, 20),
        m1_label=(68, 5),
        m2_label=(69, 5),
    ),
    rules=dict(
        poly_width=0.15,
        licon_size=0.17,
        li_size=0.34,
        mcon_size=0.17,
        m1_width=0.14,
        m1_pad=0.34,
        via_size=0.15,
        m2_width=0.14,
        m2_pad=0.34,
        # poly must extend 0.05 beyond licon on all sides; licon half=0.085
        # so licon center must be >= 0.135 from poly edge
        licon_poly_margin=0.135,
    ),
)

# -----------------------------------------------------------------------------
# Geometry helpers
# -----------------------------------------------------------------------------
def dbox(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def dtext(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def poly_contact(cell, cx, cy, tech, to_m2=False):
    """
    Poly contact stack: licon on poly -> li -> mcon -> m1 pad [-> via -> m2 pad].
    licon center is placed with 0.135 margin from poly edge (0.05 enclosure + 0.085 half).
    li is 0.34x0.34 (area 0.1156 > 0.0561, encloses licon by 0.085 > 0.08).
    m1 pad is 0.34x0.34 (encloses mcon by 0.085 > 0.06).
    Returns (m1_pad_center, m2_pad_center_or_None).
    """
    L = tech['layers']
    r = tech['rules']
    hs_licon = r['licon_size'] / 2.0
    hs_li = r['li_size'] / 2.0
    hs_mcon = r['mcon_size'] / 2.0
    hs_m1 = r['m1_pad'] / 2.0

    dbox(cell, L['licon'], cx - hs_licon, cy - hs_licon, cx + hs_licon, cy + hs_licon)
    dbox(cell, L['li'], cx - hs_li, cy - hs_li, cx + hs_li, cy + hs_li)
    dbox(cell, L['mcon'], cx - hs_mcon, cy - hs_mcon, cx + hs_mcon, cy + hs_mcon)
    dbox(cell, L['m1'], cx - hs_m1, cy - hs_m1, cx + hs_m1, cy + hs_m1)

    if not to_m2:
        return (cx, cy), None

    hs_via = r['via_size'] / 2.0
    hs_m2 = r['m2_pad'] / 2.0
    dbox(cell, L['via'], cx - hs_via, cy - hs_via, cx + hs_via, cy + hs_via)
    dbox(cell, L['m2'], cx - hs_m2, cy - hs_m2, cx + hs_m2, cy + hs_m2)
    return (cx, cy), (cx, cy)

def m1_wire(cell, x1, y1, x2, y2, tech):
    """Manhattan m1 wire, width 0.14."""
    L = tech['layers']
    r = tech['rules']
    w = r['m1_width']
    hw = w / 2.0
    dbox(cell, L['m1'], min(x1, x2), y1 - hw, max(x1, x2), y1 + hw)
    dbox(cell, L['m1'], x2 - hw, min(y1, y2), x2 + hw, max(y1, y2))

def m2_wire(cell, x1, y1, x2, y2, tech):
    """Manhattan m2 wire, width 0.14."""
    L = tech['layers']
    r = tech['rules']
    w = r['m2_width']
    hw = w / 2.0
    dbox(cell, L['m2'], min(x1, x2), y1 - hw, max(x1, x2), y1 + hw)
    dbox(cell, L['m2'], x2 - hw, min(y1, y2), x2 + hw, max(y1, y2))

def add_pin(cell, name, x, y, layer, label_layer, tech):
    """Pin = m1/m2 pad + text label on label layer."""
    r = tech['rules']
    hs = r['m1_pad'] / 2.0
    dbox(cell, layer, x - hs, y - hs, x + hs, y + hs)
    dtext(cell, label_layer, name, x, y)

# -----------------------------------------------------------------------------
# Netlist
# -----------------------------------------------------------------------------
# (name, node_a, node_b)
RESISTORS = [
    ("R1",  "VSS", "t"),
    ("R2",  "t",   "n0"),
    ("R3",  "n0",  "x0"),
    ("R4",  "x0",  "B0"),
    ("R5",  "n0",  "n1"),
    ("R6",  "n1",  "x1"),
    ("R7",  "x1",  "B1"),
    ("R8",  "n1",  "n2"),
    ("R9",  "n2",  "x2"),
    ("R10", "x2",  "B2"),
    ("R11", "n2",  "n3"),
    ("R12", "n3",  "x3"),
    ("R13", "x3",  "B3"),
    ("R14", "n3",  "n4"),
    ("R15", "n4",  "x4"),
    ("R16", "x4",  "B4"),
    ("R17", "n4",  "n5"),
    ("R18", "n5",  "x5"),
    ("R19", "x5",  "B5"),
    ("R20", "n5",  "n6"),
    ("R21", "n6",  "x6"),
    ("R22", "x6",  "B6"),
    ("R23", "n6",  "OUT"),
    ("R24", "OUT", "x7"),
    ("R25", "x7",  "B7"),
]

PIN_ORDER = ["B0", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "OUT", "VSS"]

# -----------------------------------------------------------------------------
# Top-level builder
# -----------------------------------------------------------------------------
def build_r2r8():
    tech = TECH
    ly = kdb.Layout()
    ly.dbu = tech['dbu']
    top = ly.create_cell("r2r8")
    L = tech['layers']
    r = tech['rules']

    res_length = 6.0
    res_width = 1.0
    margin = r['licon_poly_margin']   # 0.135: licon center from poly edge

    # ---- placement ---------------------------------------------------------
    # Main chain runs horizontally at y=0: VSS-R1-t-R2-n0-R5-n1-...-R23-OUT
    # Bit resistors hang vertically below each node.
    chain_y = 3.0
    chain_resistors = [  # (name, node_a, node_b) in chain order
        ("R1", "VSS", "t"),
        ("R2", "t", "n0"),
        ("R5", "n0", "n1"),
        ("R8", "n1", "n2"),
        ("R11", "n2", "n3"),
        ("R14", "n3", "n4"),
        ("R17", "n4", "n5"),
        ("R20", "n5", "n6"),
        ("R23", "n6", "OUT"),
    ]
    bit_resistors = [  # (name, node_a, node_b) for bit legs
        ("R3", "n0", "x0"), ("R4", "x0", "B0"),
        ("R6", "n1", "x1"), ("R7", "x1", "B1"),
        ("R9", "n2", "x2"), ("R10", "x2", "B2"),
        ("R12", "n3", "x3"), ("R13", "x3", "B3"),
        ("R15", "n4", "x4"), ("R16", "x4", "B4"),
        ("R18", "n5", "x5"), ("R19", "x5", "B5"),
        ("R21", "n6", "x6"), ("R22", "x6", "B6"),
        ("R24", "OUT", "x7"), ("R25", "x7", "B7"),
    ]

    node_x = {}   # node name -> x coordinate on main chain
    res_info = {} # resistor name -> {a: (x,y), b: (x,y), node_a, node_b}

    x = 2.0
    # VSS pin at start
    node_x["VSS"] = x
    for (name, na, nb) in chain_resistors:
        # horizontal resistor from x to x+length at chain_y
        dbox(top, L['poly'], x, chain_y, x + res_length, chain_y + res_width)
        dbox(top, L['polyres'], x + 0.02, chain_y + 0.02,
             x + res_length - 0.02, chain_y + res_width - 0.02)
        cy = chain_y + res_width / 2.0
        # left contact
        pa, _ = poly_contact(top, x + margin, cy, tech)
        # right contact
        pb, _ = poly_contact(top, x + res_length - margin, cy, tech)
        res_info[name] = {"a": pa, "b": pb, "node_a": na, "node_b": nb}
        node_x[nb] = x + res_length
        x += res_length + 2.0   # 2.0 um gap between chain resistors

    # ---- bit resistors (vertical, below main chain) ------------------------
    bit_start_y = chain_y - 2.0 - res_length   # top of vertical resistors
    for (name, na, nb) in bit_resistors:
        bx = node_x[na]
        # vertical resistor from bit_start_y down to bit_start_y - length
        by1 = bit_start_y
        by2 = bit_start_y - res_length
        dbox(top, L['poly'], bx, by2, bx + res_width, by1)
        dbox(top, L['polyres'], bx + 0.02, by2 + 0.02,
             bx + res_width - 0.02, by1 - 0.02)
        cx = bx + res_width / 2.0
        # top contact (at node na side)
        pa, _ = poly_contact(top, cx, by1 - margin, tech)
        # bottom contact (at node nb side)
        pb, _ = poly_contact(top, cx, by2 + margin, tech)
        res_info[name] = {"a": pa, "b": pb, "node_a": na, "node_b": nb}
        # store x-node position for bit output
        if nb.startswith("B") or nb == "OUT":
            node_x[nb] = (cx, by2)   # bottom of bit resistor

    # ---- collect pads per net ----------------------------------------------
    net_pads = {}
    def add_pad(net, pad):
        net_pads.setdefault(net, []).append(pad)

    for name, info in res_info.items():
        add_pad(info["node_a"], info["a"])
        add_pad(info["node_b"], info["b"])

    # ---- route each net on m1 ----------------------------------------------
    for net, pads in net_pads.items():
        if len(pads) < 2:
            continue
        x0, y0 = pads[0]
        for (x1, y1) in pads[1:]:
            m1_wire(top, x0, y0, x1, y1, tech)

    # ---- pins --------------------------------------------------------------
    # VSS and OUT are on the main chain; bit inputs hang below.
    pin_y_start = chain_y + 3.0
    pin_pitch = 4.0
    pin_x_left = -6.0

    for i, pin_name in enumerate(PIN_ORDER):
        if pin_name == "VSS":
            px, py = node_x["VSS"], chain_y
            add_pin(top, pin_name, px, py, L['m1'], L['m1_label'], tech)
            # VSS is already a net pad; just add label at the pad
            pads = net_pads.get("VSS", [])
            if pads:
                # label at pad location
                dtext(top, L['m1_label'], pin_name, pads[0][0], pads[0][1])
        elif pin_name == "OUT":
            px, py = node_x["OUT"]
            add_pin(top, pin_name, px, py, L['m1'], L['m1_label'], tech)
        else:
            # bit input: pin at left, route to bottom of bit resistor
            px = pin_x_left
            py = pin_y_start + i * pin_pitch
            add_pin(top, pin_name, px, py, L['m1'], L['m1_label'], tech)
            bx, by = node_x[pin_name]
            # route: m1 from pin to (bx, py), then m1 down to (bx, by)
            m1_wire(top, px, py, bx, py, tech)
            m1_wire(top, bx, py, bx, by, tech)

    return ly, top

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
if __name__ == "__main__":
    ly, top = build_r2r8()
    ly.write("r2r8.gds")
    print("Written r2r8.gds, bbox:", top.bbox().to_dmu(ly.dbu))

