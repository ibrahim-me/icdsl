```python
import klayout.db as kdb

# ----------------------------------------------------------------------
# Layout builder for shreg16 (sky130A)
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001                      # 1 nm database unit
top = ly.create_cell("shreg16")

# ----------------------------------------------------------------------
# Layers (sky130A GDS layer/datatype from the PDK data file)
# ----------------------------------------------------------------------
DIFF   = ly.layer(65, 20)           # diffusion
POLY   = ly.layer(66, 20)           # poly gate
LICON  = ly.layer(66, 44)           # local interconnect (diff/poly contact)
M1     = ly.layer(68, 20)           # metal1
M1LAB  = ly.layer(68, 5)            # metal1 label
VIA    = ly.layer(68, 44)           # via1 (m1-m2)
M2     = ly.layer(69, 20)           # metal2
M2LAB  = ly.layer(69, 5)            # metal2 label
NWELL  = ly.layer(64, 20)           # n-well for pmos

# ----------------------------------------------------------------------
# Geometry helpers (all coordinates in micrometres)
# ----------------------------------------------------------------------
def box(cell, layer, x1, y1, x2, y2):
    cell.shapes(layer).insert(kdb.DBox(x1, y1, x2, y2))

def label(cell, layer, text, x, y):
    cell.shapes(layer).insert(kdb.DText(text, kdb.DTrans(kdb.DVector(x, y))))

def contact(cell, layer, x, y, size=0.17):
    """square contact / via"""
    box(cell, layer, x - size/2, y - size/2, x + size/2, y + size/2)

def mos(cell, x, y, w, l, is_pmos=False):
    """
    Draw a single MOS transistor.
    x,y : lower-left corner of the diffusion rectangle
    w   : diffusion width (x direction)  -> transistor width
    l   : gate length (y direction)      -> transistor length
    Returns dict with contact centre points (left, right, gate) for routing.
    """
    active_h = 1.0                    # diffusion height (y)
    poly_ov  = 0.10                   # poly extension beyond diffusion
    # diffusion
    box(cell, DIFF, x, y, x + w, y + active_h)
    if is_pmos:
        # n-well around pmos (simple rectangle covering the transistor area)
        box(cell, NWELL, x - 0.2, y - 0.2, x + w + 0.2, y + active_h + 0.2)
    # poly gate (vertical, crossing the diffusion)
    box(cell, POLY,
        x - poly_ov, y + active_h/2 - l/2,
        x + w + poly_ov, y + active_h/2 + l/2)
    # diffusion contacts (source / drain)
    cy = y + active_h/2
    contact(cell, LICON, x + 0.12, cy)          # left contact
    contact(cell, LICON, x + w - 0.12, cy)      # right contact
    # poly contact (gate) – placed on the poly extension above the gate
    contact(cell, LICON, x + w/2, y + active_h/2 + l/2 + 0.12)
    return {
        "left":  (x + 0.12, cy),
        "right": (x + w - 0.12, cy),
        "gate":  (x + w/2, y + active_h/2 + l/2 + 0.12),
    }

def m1_wire(cell, x1, y1, x2, y2):
    box(cell, M1, x1, y1, x2, y2)

def m2_wire(cell, x1, y1, x2, y2):
    box(cell, M2, x1, y1, x2, y2)

def via12(cell, x, y, size=0.15):
    contact(cell, VIA, x, y, size)

# ----------------------------------------------------------------------
# DFF cell (master-slave flip-flop, 22 transistors)
# ----------------------------------------------------------------------
def create_dff_cell():
    dff = ly.create_cell("dff")
    cell_w = 30.0
    cell_h = 16.0

    # power rails (metal1)
    m1_wire(dff, 0, 14.5, cell_w, 15.5)   # VDD
    m1_wire(dff, 0, 0.5,  cell_w, 1.5)    # VSS
    label(dff, M1LAB, "VDD", cell_w/2, 15.0)
    label(dff, M1LAB, "VSS", cell_w/2, 1.0)

    # ------------------------------------------------------------------
    # Transistor placement
    # ------------------------------------------------------------------
    # NMOS row (y = 2.0), PMOS row (y = 9.0)
    nmos_y = 2.0
    pmos_y = 9.0
    x_cursor = 1.0
    pitch = 2.6

    # (name, x, w, is_pmos, source_net, drain_net, gate_net)
    transistors = [
        # nmos
        ("Mn0_0", x_cursor, 0.42, False, "VSS", "CKB", "CK"); x_cursor += pitch
        ("Mn0_1", x_cursor, 0.42, False, "n1",  "VSS", "D");  x_cursor += pitch
        ("Mn0_2", x_cursor, 0.42, False, "m",   "n1",  "CKB");x_cursor += pitch
        ("Mn0_3", x_cursor, 0.42, False, "n2",  "m",   "CK"); x_cursor += pitch
        ("Mn0_4", x_cursor, 0.42, False, "VSS", "n2",  "mb"); x_cursor += pitch
        ("Mn0_5", x_cursor, 0.42, False, "mb",  "VSS", "m");  x_cursor += pitch
        ("Mn7_0", x_cursor, 0.42, False, "n3",  "VSS", "Q");  x_cursor += pitch
        ("Mn7_1", x_cursor, 0.42, False, "s",   "n3",  "CKB");x_cursor += pitch
        ("Mn7_2", x_cursor, 0.42, False, "n4",  "s",   "CK"); x_cursor += pitch
        ("Mn7_3", x_cursor, 0.42, False, "VSS", "n4",  "mb"); x_cursor += pitch
        ("Mn7_4", x_cursor, 0.42, False, "Q",   "VSS", "s");  x_cursor += pitch
        # pmos
        ("Mp0_0", x_cursor, 0.84, True,  "VDD", "CKB", "CK"); x_cursor += pitch
        ("Mp0_1", x_cursor, 0.84, True,  "p1",  "VDD", "D");  x_cursor += pitch
        ("Mp0_2", x_cursor, 0.84, True,  "m",   "p1",  "CK"); x_cursor += pitch
        ("Mp0_3", x_cursor, 0.84, True,  "p2",  "m",   "CKB");x_cursor += pitch
        ("Mp0_4", x_cursor, 0.84, True,  "VDD", "p2",  "mb"); x_cursor += pitch
        ("Mp0_5", x_cursor, 0.84, True,  "mb",  "VDD", "m");  x_cursor += pitch
        ("Mp7_0", x_cursor, 0.84, True,  "p3",  "VDD", "Q");  x_cursor += pitch
        ("Mp7_1", x_cursor, 0.84, True,  "s",   "p3",  "CK"); x_cursor += pitch
        ("Mp7_2", x_cursor, 0.84, True,  "p4",  "s",   "CKB");x_cursor += pitch
        ("Mp7_3", x_cursor, 0.84, True,  "VDD", "p4",  "mb"); x_cursor += pitch
        ("Mp7_4", x_cursor, 0.84, True,  "Q",   "VDD", "s");  x_cursor += pitch
    ]

    # place transistors and remember contact positions
    mos_info = {}
    for name, x, w, is_p, s_net, d_net, g_net in transistors:
        info = mos(dff, x, nmos_y if not is_p else pmos_y, w, 0.15, is_pmos=is_p)
        mos_info[name] = {"pos": info, "s": s_net, "d": d_net, "g": g_net}

    # ------------------------------------------------------------------
    # Simple metal1 routing: connect every diffusion contact to a vertical
    # m1 segment that goes to a metal2 rail dedicated to its net.
    # ------------------------------------------------------------------
    # metal2 rails (one per net) – placed at different y levels
    net_y = {
        "VSS": 1.0, "VDD": 15.0, "CK": 4.0, "D": 5.0, "Q": 6.0,
        "CKB": 7.0, "n1": 8.0, "m": 9.0, "n2": 10.0, "mb": 11.0,
        "s": 12.0, "n3": 13.0, "n4": 14.0,
        "p1": 4.5, "p2": 5.5, "p3": 6.5, "p4": 7.5,
    }
    # draw metal2 rails across the cell
    for net, yy in net_y.items():
        m2_wire(dff, 0, yy - 0.2, cell_w, yy + 0.2)
        label(dff, M2LAB, net, cell_w - 1.0, yy)

    # connect each transistor terminal to its net rail via m1 + via
    for name, info in mos_info.items():
        pos = info["pos"]
        # source contact -> source net rail
        sx, sy = pos["left"]
        m1_wire(dff, sx, sy - 0.1, sx, net_y[info["s"]] - 0.25)
        via12(dff, sx, net_y[info["s"]] - 0.25)
        # drain contact -> drain net rail
        dx, dy = pos["right"]
        m1_wire(dff, dx, dy - 0.1, dx, net_y[info["d"]] - 0.25)
        via12(dff, dx, net_y[info["d"]] - 0.25)
        # gate contact -> gate net rail
        gx, gy = pos["gate"]
        m1_wire(dff, gx, gy - 0.1, gx, net_y[info["g"]] - 0.25)
        via12(dff, gx, net_y[info["g"]] - 0.25)

    # external pins (metal2 labels at cell border)
    label(dff, M2LAB, "D",  0.5, net_y["D"])
    label(dff, M2LAB, "CK", 0.5, net_y["CK"])
    label(dff, M2LAB, "Q",  cell_w - 0.5, net_y["Q"])
    label(dff, M2LAB, "VDD", cell_w/2, 15.0)
    label(dff, M2LAB, "VSS", cell_w/2, 1.0)

    return dff, cell_w, cell_h

dff_cell, dff_w, dff_h = create_dff_cell()

# ----------------------------------------------------------------------
# Top cell: 16 dff instances chained (Q_i -> D_{i+1})
# ----------------------------------------------------------------------
pitch_x = dff_w + 2.0
start_x = 2.0
y0 = 2.0

# global rails in top cell
m1_wire(top, 0, 14.5, start_x + 16 * pitch_x, 15.5)   # VDD
m1_wire(top, 0, 0.5,  start_x + 16 * pitch_x, 1.5)    # VSS
label(top, M1LAB, "VDD", (start_x + 16 * pitch_x)/2, 15.0)
label(top, M1LAB, "VSS", (start_x + 16 * pitch_x)/2, 1.0)

# place flip-flops and route chain
for i in range(16):
    inst = kdb.DCellInstArray(dff_cell.cell_index(),
                              kdb.DTrans(kdb.DVector(start_x + i * pitch_x, y0)))
    top.insert(inst)

    # connect VDD/VSS of instance to global rails (via1)
    via12(top, start_x + i * pitch_x + dff_w/2, 15.0)
    via12(top, start_x + i * pitch_x + dff_w/2, 1.0)

    # chain Q_i -> D_{i+1} using metal2
    if i < 15:
        x_cur = start_x + i * pitch_x + dff_w - 0.5
        x_nxt = start_x + (i + 1) * pitch_x + 0.5
        m2_wire(top, x_cur, 6.0, x_nxt, 6.0)   # Q net rail at y=6.0
        via12(top, x_cur, 6.0)
        via12(top, x_nxt, 6.0)

# top-level pins
label(top, M2LAB, "D",  start_x + 0.5, 5.0)
label(top, M2LAB, "CK", start_x + 0.5, 4.0)
for i, name in enumerate(["Q0","Q1","Q2","Q3","Q4","Q5","Q6","Q7",
                          "Q8","Q9","Q10","Q11","Q12","Q13","Q14","Q15"]):
    x = start_x + i * pitch_x + dff_w - 0.5
    label(top, M2LAB, name, x, 6.0)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("shreg16.gds")
print("shreg16.gds written")
```