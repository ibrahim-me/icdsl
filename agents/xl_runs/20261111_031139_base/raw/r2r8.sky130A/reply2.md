```python
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
        licon_space=0.17,
        li_width=0.17,
        mcon_size=0.17,
        mcon_space=0.19,
        m1_width=0.14,
        m1_space=0.14,
        via_size=0.15,
        via_space=0.17,
        enc_poly_licon=0.05,
        enc_li_licon=0.0,
        enc_li_mcon=0.0,
        enc_m1_mcon=0.03,
        enc_m1_via=0.055,
        enc_m2_via=0.055,
    ),
)

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
def dbox(cell, layer, x1, y1, x2, y2):
    """Insert a filled rectangle (um)."""
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def dtext(cell, layer, text, x, y):
    """Insert a text label (um)."""
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(x, y)))

def contact(cell, layer, cx, cy, size):
    """Square contact centered at (cx, cy)."""
    s = size / 2.0
    dbox(cell, layer, cx - s, cy - s, cx + s, cy + s)

def resistor(cell, x, y, length, width, name, tech):
    """
    Draw one poly resistor with contacts at both ends.
    Returns dict with terminal pad centers (m1 metal) for 'a' (left) and 'b' (right).
    """
    r = tech['rules']
    L = tech['layers']
    # poly body
    dbox(cell, L['poly'], x, y, x + length, y + width)
    # polyres marker (slightly inset)
    m = 0.02
    dbox(cell, L['polyres'], x + m, y + m, x + length - m, y + width - m)
    cy = y + width / 2.0
    # left contact stack: poly <- licon <- li <- mcon <- m1 pad
    lx = x
    contact(cell, L['licon'], lx, cy, r['licon_size'])
    dbox(cell, L['li'], lx - r['li_width'] / 2, cy - r['li_width'] / 2,
         lx + r['li_width'] / 2, cy + r['li_width'] / 2)
    contact(cell, L['mcon'], lx, cy, r['mcon_size'])
    dbox(cell, L['m1'], lx - 0.12, cy - 0.12, lx + 0.12, cy + 0.12)
    pa = (lx, cy)
    # right contact stack
    rx = x + length
    contact(cell, L['licon'], rx, cy, r['licon_size'])
    dbox(cell, L['li'], rx - r['li_width'] / 2, cy - r['li_width'] / 2,
         rx + r['li_width'] / 2, cy + r['li_width'] / 2)
    contact(cell, L['mcon'], rx, cy, r['mcon_size'])
    dbox(cell, L['m1'], rx - 0.12, cy - 0.12, rx + 0.12, cy + 0.12)
    pb = (rx, cy)
    return {'a': pa, 'b': pb}

def m1_wire(cell, x1, y1, x2, y2, tech):
    """Manhattan m1 wire between two points (um)."""
    L = tech['layers']
    r = tech['rules']
    w = r['m1_width']
    hw = w / 2.0
    # horizontal segment
    dbox(cell, L['m1'], min(x1, x2), y1 - hw, max(x1, x2), y1 + hw)
    # vertical segment
    dbox(cell, L['m1'], x2 - hw, min(y1, y2), x2 + hw, max(y1, y2))
    # via stack at the end point (m1 -> via -> m2) to avoid m1-m1 overlap issues
    contact(cell, L['via'], x2, y2, r['via_size'])
    dbox(cell, L['m2'], x2 - 0.12, y2 - 0.12, x2 + 0.12, y2 + 0.12)

def add_pin(cell, name, x, y, tech):
    """Pin = small m1 pad + text label on m1 label layer."""
    L = tech['layers']
    dbox(cell, L['m1'], x - 0.12, y - 0.12, x + 0.12, y + 0.12)
    dtext(cell, L['m1_label'], name, x, y)

# -----------------------------------------------------------------------------
# Netlist definition
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

    # placement grid
    col_pitch = 8.0
    row_pitch = 4.0
    res_length = 6.0
    res_width = 1.0

    # place resistors
    res_info = {}
    for idx, (name, na, nb) in enumerate(RESISTORS):
        col = idx % 5
        row = idx // 5
        x = col * col_pitch
        y = row * row_pitch
        info = resistor(top, x, y, res_length, res_width, name, tech)
        res_info[name] = {"a": info["a"], "b": info["b"],
                          "node_a": na, "node_b": nb}

    # collect pads per net
    net_pads = {}
    def add_pad(net, pad):
        net_pads.setdefault(net, []).append(pad)

    for name, info in res_info.items():
        add_pad(info["node_a"], info["a"])
        add_pad(info["node_b"], info["b"])

    # route each net on m1 (star from first pad)
    for net, pads in net_pads.items():
        if len(pads) < 2:
            continue
        x0, y0 = pads[0]
        for (x1, y1) in pads[1:]:
            m1_wire(top, x0, y0, x1, y1, tech)

    # pins on the left side
    pin_y_start = 2.0
    pin_pitch = 3.0
    pin_x = -4.0
    for i, pin_name in enumerate(PIN_ORDER):
        py = pin_y_start + i * pin_pitch
        add_pin(top, pin_name, pin_x, py, tech)
        pads = net_pads.get(pin_name, [])
        if pads:
            bx, by = pads[0]
            m1_wire(top, pin_x, py, bx, by, tech)

    return ly, top

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
if __name__ == "__main__":
    ly, top = build_r2r8()
    ly.write("r2r8.gds")
    print("Written r2r8.gds, bbox:", top.bbox().to_dmu(ly.dbu))
```