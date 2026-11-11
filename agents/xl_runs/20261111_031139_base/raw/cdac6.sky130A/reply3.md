```
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data (sky130A) – layers and rules
# ---------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "lvtn": (125, 44), "hvtp": (78, 44), "hvi": (75, 20), "hvntm": (125, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20), "via2": (69, 44), "m3": (70, 20),
        "via3": (70, 44), "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
        "capm": (89, 44), "cap2m": (97, 44), "rpm": (86, 20), "urpm": (79, 20),
        "polyres": (66, 13), "diffres": (65, 13), "lires": (67, 13),
        "m1res": (68, 13), "m2res": (69, 13), "m3res": (70, 13), "m4res": (71, 13), "m5res": (72, 13),
        "boundary": (235, 4), "areaid_sc": (81, 4), "inductor": (82, 24),
    },
    label={
        "poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5), "m3": (70, 5),
        "m4": (71, 5), "m5": (72, 5), "nwell": (64, 5), "pwell": (64, 59),
    },
    pin={
        "poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16), "m3": (70, 16),
        "m4": (71, 16), "m5": (72, 16), "nwell": (64, 16), "pwell": (122, 16),
    },
)

ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("cdac6")

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def label_layer(name):
    return ly.layer(*TECH["label"][name])

def pin_layer(name):
    return ly.layer(*TECH["pin"][name])

def box(Cell, lay, x1, y1, x2, y2):
    Cell.shapes(lay).insert(kdb.DBox(x1, y1, x2, y2))

def rect(Cell, lay, x, y, w, h):
    box(Cell, lay, x, y, x + w, y + h)

def text(Cell, lay, s, x, y):
    Cell.shapes(lay).insert(kdb.DText(s, kdb.DTrans(x, y)))

# ---------------------------------------------------------------------------
# Unit MIM capacitor parameters (sky130_fd_pr__cap_mim_m3_1, w=5 l=5)
# ---------------------------------------------------------------------------
CAPM_W = 5.0
CAPM_H = 5.0
M3_W = CAPM_W + 2 * 0.14   # m3 surrounds capm by 0.14 on all sides -> 5.28
M3_H = CAPM_H + 2 * 0.14
M4_W = CAPM_W + 2 * 0.14   # m4 covers capm by 0.14 on all sides -> 5.28
M4_H = CAPM_H + 2 * 0.14

# Placement: 8 columns x 8 rows, pitch 8.5 um
# Gap between capm edges = 8.5 - 5.0 = 3.5 um
# m3 trace in gap center is 1.75 - 0.15 = 1.60 um from capm edge > 1.34 um (capm.11) OK
PITCH = 8.5
COLS = 8
ROWS = 8
ORIGIN_X = 0.0
ORIGIN_Y = 0.0

# Bit assignment: 64 units
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
assignments = []
for bit, cnt in bit_counts.items():
    for i in range(cnt):
        assignments.append((bit, i))
assert len(assignments) == 64

# ---------------------------------------------------------------------------
# Place unit capacitors
# Each unit: m3 bottom plate, capm dielectric, m4 top plate
# No via3 between m3 and m4 (that would short the capacitor)
# ---------------------------------------------------------------------------
unit_info = []
for idx, (net, _) in enumerate(assignments):
    col = idx % COLS
    row = idx // COLS
    cx = ORIGIN_X + col * PITCH + PITCH / 2
    cy = ORIGIN_Y + row * PITCH + PITCH / 2

    # m3 bottom plate (isolated island per unit)
    rect(top, layer("m3"), cx - M3_W / 2, cy - M3_H / 2, M3_W, M3_H)
    # capm dielectric
    rect(top, layer("capm"), cx - CAPM_W / 2, cy - CAPM_H / 2, CAPM_W, CAPM_H)
    # m4 top plate (will be merged into TOP plane)
    rect(top, layer("m4"), cx - M4_W / 2, cy - M4_H / 2, M4_W, M4_H)

    unit_info.append((cx, cy, net))

# ---------------------------------------------------------------------------
# m4 TOP plane: single rectangle covering all units, all m4 plates merge into it
# ---------------------------------------------------------------------------
ARRAY_W = COLS * PITCH
ARRAY_H = ROWS * PITCH
MARGIN = 1.0
TOP_X1 = ORIGIN_X - MARGIN
TOP_Y1 = ORIGIN_Y - MARGIN
TOP_X2 = ORIGIN_X + ARRAY_W + MARGIN
TOP_Y2 = ORIGIN_Y + ARRAY_H + MARGIN
rect(top, layer("m4"), TOP_X1, TOP_Y1, TOP_X2 - TOP_X1, TOP_Y2 - TOP_Y1)

# ---------------------------------------------------------------------------
# m3 bit buses: vertical buses to the right of the array
# ---------------------------------------------------------------------------
M3_BUS_W = 0.30
BUS_X = {}
bus_start_x = ORIGIN_X + ARRAY_W + 2.0
bus_pitch = 3.0
for i, bit in enumerate(bit_counts.keys()):
    BUS_X[bit] = bus_start_x + i * bus_pitch

for bit, bx in BUS_X.items():
    rect(top, layer("m3"), bx - M3_BUS_W / 2, ORIGIN_Y - MARGIN,
         bx + M3_BUS_W / 2, ORIGIN_Y + ARRAY_H + MARGIN)

# Connect each unit's m3 plate to its bit bus with horizontal m3 segment
for cx, cy, net in unit_info:
    bx = BUS_X[net]
    x1 = cx + M3_W / 2
    x2 = bx - M3_BUS_W / 2
    if x2 > x1 + 0.02:
        rect(top, layer("m3"), x1, cy - M3_BUS_W / 2, x2, cy + M3_BUS_W / 2)

# ---------------------------------------------------------------------------
# Pins: labels on label layers (and pin layers for netgen)
# ---------------------------------------------------------------------------
# TOP pin on m4 (place label inside the m4 plane near left edge)
text(top, label_layer("m4"), "TOP", TOP_X1 + 0.5, TOP_Y1 + (TOP_Y2 - TOP_Y1) / 2)
text(top, pin_layer("m4"), "TOP", TOP_X1 + 0.5, TOP_Y1 + (TOP_Y2 - TOP_Y1) / 2)

# Bit pins on m3 at top of each bus
for bit, bx in BUS_X.items():
    py = ORIGIN_Y + ARRAY_H + MARGIN + 0.5
    text(top, label_layer("m3"), bit, bx, py)
    text(top, pin_layer("m3"), bit, bx, py)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("cdac6.gds")
bbox = top.bbox()
print("cdac6.gds written, bbox: %.2f x %.2f = %.2f um2" % (
    bbox.width(), bbox.height(), bbox.width() * bbox.height()))

```