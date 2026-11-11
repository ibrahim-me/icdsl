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
        poly_space=0.21,
        licon_size=0.17,
        li_size=0.34,
        mcon_size=0.17,
        m1_width=0.14,
        m1_pad=0.34,
        via_size=0.15,
        via_space=0.17,
        m2_width=0.14,
        m2_pad=0.34,
    ),
)

# -----------------------------------------------------------------------------
# Geometry helpers
# -----------------------------------------------------------------------------
def dbox(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def dtext(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact_stack(cell, cx, cy, tech, to_m2=False):
    """
    Build a contact stack on poly at (cx, cy):
      poly <- licon <- li <- mcon <- m1 pad [<- via <- m2 pad]
    Returns the m1 pad center and (if to_m2) the m2 pad center.
    """
    L = tech['layers']
    r = tech['rules']
    # licon on poly: 0.17 x 0.17, poly must extend 0.05 beyond (caller ensures)
    hs = r['licon_size'] / 2.0
    dbox(cell, L['licon'], cx - hs, cy - hs, cx + hs, cy + hs)
    # li: 0.34 x 0.34 (encloses licon by 0.085 on all sides, area 0.1156 > 0.0561)
    hs = r['li_size'] / 2.0
    dbox(cell, L['li'], cx - hs, cy - hs, cx + hs, cy + hs)
    # mcon: 0.17 x 0.17 (li encloses mcon by 0.085 on all sides > 0.0)
    hs = r['mcon_size'] / 2.0
    dbox(cell, L['mcon'], cx - hs, cy - hs, cx + hs, cy + hs)
    # m1 pad: 0.34 x 0.34 (encloses mcon by 0.085 > 0.06/0.03)
    hs = r['m1_pad'] / 2.0
    dbox(cell, L['m1'], cx - hs, cy - hs, cx + hs, cy + hs)
    pa = (cx, cy)
    if not to_m2:
        return pa, None
    # via: 0.15 x 0.15 (m1 pad encloses via by 0.095 > 0.085/0.055)
    hs = r['via_size'] / 2.0
    dbox(cell, L['via'], cx - hs, cy - hs, cx + hs, cy + hs)
    # m2 pad: 0.34 x 0.34 (encloses via by 0.095 > 0.085/0.055)
    hs = r['m2_pad'] / 2.0
    dbox(cell, L['m2'], cx - hs, cy - hs, cx + hs, cy + hs)
    pb = (cx, cy)
    return pa, pb

def resistor(cell, x, y, length, width, name, tech):
    """
    Draw one poly resistor with contacts at both ends.
    The poly body extends 0.10 beyond each licon (rule: 0.05 min).
    Returns dict with terminal pad centers for 'a' (left) and 'b' (right).
    """
    L = tech['layers']
    r = tech['rules']
    # poly body
    dbox(cell, L['poly'], x, y, x + length, y + width)
    # polyres marker (inset)
    m = 0.02
    dbox(cell, L['polyres'], x + m, y + m, x + length - m, y + width - m)
    cy = y + width / 2.0
    # contacts inset 0.10 from poly ends (0.05 min enclosure of licon)
    la = contact_stack(cell, x + 0.10, cy, tech)
    lb = contact_stack(cell, x + length - 0.10, cy, tech)
    return {'a': la[0], 'b': lb[0]}

def m1_wire(cell, x1, y1, x2, y2, tech):
    """Manhattan m1 wire between two points (um), width 0.14."""
    L = tech['layers']
    r = tech['rules']
    w = r['m1_width']
    hw = w / 2.0
    # horizontal segment
    dbox(cell, L['m1'], min(x1, x2), y1 - hw, max(x1, x2), y1 + hw)
    # vertical segment
    dbox(cell, L['m1'], x2 - hw, min(y1, y2), x2 + hw, max(y1, y2))

def m2_wire(cell, x1, y1, x2, y2, tech):
    """Manhattan m2 wire between two points (um), width 0.14."""
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
    col_pitch = 9.0
    row_pitch = 9.0
    cols = 5

    # ---- place resistors ---------------------------------------------------
    res_info = {}
    for idx, (name, na, nb) in enumerate(RESISTORS):
        col = idx % cols
        row = idx // cols
        x = col * col_pitch + 2.0
        y = row * row_pitch + 2.0
        info = resistor(top, x, y, res_length, res_width, name, tech)
        res_info[name] = {"a": info["a"], "b": info["b"],
                          "node_a": na, "node_b": nb}

    # ---- collect pads per net ---------------------------------------------
    net_pads = {}
    def add_pad(net, pad):
        net_pads.setdefault(net, []).append(pad)

    for name, info in res_info.items():
        add_pad(info["node_a"], info["a"])
        add_pad(info["node_b"], info["b"])

    # ---- route each net ----------------------------------------------------
    # Use m1 for horizontal segments, m2 for vertical segments (via at corners)
    for net, pads in net_pads.items():
        if len(pads) < 2:
            continue
        x0, y0 = pads[0]
        # route from first pad to a vertical m2 trunk at x0
        # then up/down on m2 to each other pad's y, then m1 to the pad
        trunk_y_min = min(p[1] for p in pads)
        trunk_y_max = max(p[1] for p in pads)
        trunk_x = x0
        # m2 trunk
        m2_wire(top, trunk_x, trunk_y_min, trunk_x, trunk_y_max, tech)
        # via from m1 pad at (x0,y0) to m2 trunk
        pa, pb = contact_stack(top, x0, y0, tech, to_m2=True)
        # connect each other pad
        for (x1, y1) in pads[1:]:
            # m1 from pad to trunk x
            m1_wire(top, x1, y1, trunk_x, y1, tech)
            # via at (trunk_x, y1) to m2 trunk
            contact_stack(top, trunk_x, y1, tech, to_m2=True)

    # ---- pins --------------------------------------------------------------
    pin_x = -6.0
    pin_y_start = 2.0
    pin_pitch = 4.0
    for i, pin_name in enumerate(PIN_ORDER):
        py = pin_y_start + i * pin_pitch
        add_pin(top, pin_name, pin_x, py, L['m1'], L['m1_label'], tech)
        pads = net_pads.get(pin_name, [])
        if pads:
            bx, by = pads[0]
            # route from pin to pad: m1 horizontal to trunk x, then m1 vertical
            # use m2 trunk at pin_x for vertical
            m2_wire(top, pin_x, py, pin_x, by, tech)
            contact_stack(top, pin_x, py, tech, to_m2=True)
            contact_stack(top, pin_x, by, tech, to_m2=True)
            m1_wire(top, pin_x, by, bx, by, tech)

    return ly, top

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
if __name__ == "__main__":
    ly, top = build_r2r8()
    ly.write("r2r8.gds")
    print("Written r2r8.gds, bbox:", top.bbox().to_dmu(ly.dbu))

