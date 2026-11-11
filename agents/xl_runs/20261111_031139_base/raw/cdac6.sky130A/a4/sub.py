import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data (sky130A)
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
M3_W = CAPM_W + 2 * 0.14   # 5.28
M3_H = CAPM_H + 2 * 0.14
M4_W = CAPM_W + 2 * 0.14   # 5.28
M4_H = CAPM_H + 2 * 0.14

PITCH = 7.0
CLUSTER_GAP = 3.0

# ---------------------------------------------------------------------------
# Clustered placement: units of the same bit are grouped (allowed by task)
# Each cluster: (bit_net, cols, rows)
# ---------------------------------------------------------------------------
clusters = [
    ("B5", 8, 4),
    ("B4", 8, 2),
    ("B3", 8, 1),
    ("B2", 4, 1),
    ("B1", 2, 1),
    ("B0", 1, 1),
    ("VSS", 1, 1),
]

# Place clusters, track unit positions
unit_info = []  # (cx, cy, net)
cur_x = 0.0
cur_y = 0.0
max_width = 0.0

for bit_net, cols, rows in clusters:
    cw = cols * PITCH
    ch = rows * PITCH
    max_width = max(max_width, cw)
    for r in range(rows):
        for c in range(cols):
            cx = cur_x + c * PITCH + PITCH / 2
            cy = cur_y + r * PITCH + PITCH / 2
            # m3 bottom plate (separate island per unit)
            rect(top, layer("m3"), cx - M3_W / 2, cy - M3_H / 2, M3_W, M3_H)
            # capm dielectric
            rect(top, layer("capm"), cx - CAPM_W / 2, cy - CAPM_H / 2, CAPM_W, CAPM_H)
            # m4 top plate (separate island per unit)
            rect(top, layer("m4"), cx - M4_W / 2, cy - M4_H / 2, M4_W, M4_H)
            unit_info.append((cx, cy, bit_net))
    cur_y += ch + CLUSTER_GAP

total_height = cur_y - CLUSTER_GAP
ARRAY_W = max_width
ARRAY_H = total_height

# ---------------------------------------------------------------------------
# Bit buses: horizontal m3 strips above each cluster
# ---------------------------------------------------------------------------
M3_BUS_W = 0.30
BUS_Y = {}
cluster_y = 0.0
for bit_net, cols, rows in clusters:
    ch = rows * PITCH
    bus_y = cluster_y + ch + 0.5
    BUS_Y[bit_net] = bus_y
    rect(top, layer("m3"), 0.0, bus_y - M3_BUS_W / 2, ARRAY_W, bus_y + M3_BUS_W / 2)
    cluster_y += ch + CLUSTER_GAP

# Connect each unit's m3 plate to its cluster's bit bus
M3_CONN_W = 0.30
for cx, cy, net in unit_info:
    by = BUS_Y[net]
    y1 = cy + M3_H / 2
    y2 = by - M3_BUS_W / 2
    if y2 > y1 + 0.02:
        rect(top, layer("m3"), cx - M3_CONN_W / 2, y1, cx + M3_CONN_W / 2, y2)

# ---------------------------------------------------------------------------
# TOP bus: horizontal m4 strip above everything, connect all m4 plates
# ---------------------------------------------------------------------------
TOP_BUS_Y = cluster_y + 2.0
TOP_BUS_H = 1.0
TOP_BUS_X1 = -2.0
TOP_BUS_X2 = ARRAY_W + 2.0
rect(top, layer("m4"), TOP_BUS_X1, TOP_BUS_Y, TOP_BUS_X2 - TOP_BUS_X1, TOP_BUS_H)

# Connect each unit's m4 plate to TOP bus
M4_CONN_W = 0.30
for cx, cy, net in unit_info:
    y1 = cy + M4_H / 2
    y2 = TOP_BUS_Y
    if y2 > y1 + 0.02:
        rect(top, layer("m4"), cx - M4_CONN_W / 2, y1, cx + M4_CONN_W / 2, y2)

# ---------------------------------------------------------------------------
# Right-side routing: bring bit buses and TOP to pins at right edge
# ---------------------------------------------------------------------------
PIN_X = ARRAY_W + 4.0
PIN_W = 1.0
PIN_H = 1.0
pin_y = {}
pin_pitch = 3.0
pin_start_y = 2.0

for i, (bit_net, _, _) in enumerate(clusters):
    py = pin_start_y + i * pin_pitch
    pin_y[bit_net] = py
    # m3 pin pad
    rect(top, layer("m3"), PIN_X - PIN_W / 2, py - PIN_H / 2, PIN_W, PIN_H)
    # connect bit bus to pin pad with m3 vertical segment
    by = BUS_Y[bit_net]
    y1 = min(by + M3_BUS_W / 2, py - PIN_H / 2)
    y2 = max(by + M3_BUS_W / 2, py + PIN_H / 2)
    if y2 > y1 + 0.02:
        rect(top, layer("m3"), ARRAY_W, y1, PIN_X - PIN_W / 2, y2)

# TOP pin pad on m4
rect(top, layer("m4"), PIN_X - PIN_W / 2, pin_y["VSS"] + pin_pitch + 2.0 - PIN_H / 2,
     PIN_W, PIN_H)
# Connect TOP bus to TOP pin pad
top_pin_y = pin_y["VSS"] + pin_pitch + 2.0
y1 = min(TOP_BUS_Y + TOP_BUS_H, top_pin_y - PIN_H / 2)
y2 = max(TOP_BUS_Y + TOP_BUS_H, top_pin_y + PIN_H / 2)
if y2 > y1 + 0.02:
    rect(top, layer("m4"), ARRAY_W, y1, PIN_X - PIN_W / 2, y2)

# ---------------------------------------------------------------------------
# Pins: labels on label layers and pin layers
# ---------------------------------------------------------------------------
# Bit pins on m3
for bit_net, py in pin_y.items():
    text(top, label_layer("m3"), bit_net, PIN_X + 0.5, py)
    text(top, pin_layer("m3"), bit_net, PIN_X + 0.5, py)

# TOP pin on m4
top_pin_y = pin_y["VSS"] + pin_pitch + 2.0
text(top, label_layer("m4"), "TOP", PIN_X + 0.5, top_pin_y)
text(top, pin_layer("m4"), "TOP", PIN_X + 0.5, top_pin_y)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("cdac6.gds")
bbox = top.bbox()
print("cdac6.gds written, bbox: %.2f x %.2f = %.2f um2" % (
    bbox.width(), bbox.height(), bbox.width() * bbox.height()))

