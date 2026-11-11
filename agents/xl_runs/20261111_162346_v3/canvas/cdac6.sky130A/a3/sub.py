from icdsl.canvas import *

tech = use()
c0 = tech.c0          # li
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
m4 = tech.metal(4)
m5 = tech.metal(5)    # top metal on sky130A

c = Cell("cdac6")

# ---------- Parameters ----------
cap_w = 5.0
cap_h = 5.0
pitch = 7.6
cols = 8
rows = 8

# Bit map: (net, col_range, row_range)  clustered by bit
bit_map = [
    ("B5",  range(0, 4),  range(0, 8)),   # 32 units
    ("B4",  range(4, 6),  range(0, 8)),   # 16 units
    ("B3",  range(6, 7),  range(0, 8)),   # 8 units
    ("B2",  range(7, 8),  range(0, 4)),   # 4 units
    ("B1",  range(7, 8),  range(4, 6)),   # 2 units
    ("B0",  range(7, 8),  range(6, 7)),   # 1 unit
    ("VSS", range(7, 8),  range(7, 8)),   # 1 unit
]

# ---------- Place capacitors ----------
cap_by_net = {}
for net, _, _ in bit_map:
    cap_by_net[net] = []
cap_by_net["TOP"] = []

for net, col_range, row_range in bit_map:
    for col in col_range:
        for row in row_range:
            cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                              at=(col * pitch, row * pitch),
                              nets=("TOP", net))
            cap_by_net[net].append(cap)
            cap_by_net["TOP"].append(cap)

array_right = cols * pitch   # 60.8
array_top = rows * pitch     # 60.8

# ---------- TOP plate: m5 plane ----------
# m5 min width = 1.6um on sky130A; make plane generous
top_plane = c.rect(m5, x0=-1.0, y0=-1.0,
                   x1=array_right + 1.0, y1=array_top + 1.0, net="TOP")

# Connect each cap's top pad (m4) to m5 plane via via4 (m4->m5)
# via4: 0.8x0.8, space 0.8. At 7.6um pitch, no spacing violations.
for cap in cap_by_net["TOP"]:
    c.via(m4, m5, at=(cap.top_pad.cx, cap.top_pad.cy), net="TOP", dir="v")

c.port("TOP", on=top_plane)

# ---------- Bottom plates: m1 within array, m2 buses above ----------
# Each cap's bottom pad (m3) -> via3 to m4 -> via4 to m5? No, that's TOP layer.
# Instead: bottom pad (m3) -> via2 to m2 -> m2 horizontal bus in row -> via to m1 -> m1 vertical to pin

# m2 row buses inside the array (one per bit row, running horizontally between capacitor columns)
# These sit in the gaps between capacitor rows, outside capm regions.
row_bus_y = {}
for row in range(rows):
    # Place bus in the gap below row 'row' (or above the last row)
    if row < rows - 1:
        by = row * pitch + pitch - 1.3   # 1.3um wide bus in 2.6um gap
    else:
        by = array_top + 0.4
    row_bus_y[row] = by

# Collect bottom plates by bit using m2 row buses + m1 verticals
for net, col_range, row_range in bit_map:
    if net == "TOP":
        continue
    # m2 horizontal bus for this bit (spans all columns that have this bit)
    cols_used = sorted(set(col_range))
    x0 = cols_used[0] * pitch - 0.4
    x1 = cols_used[-1] * pitch + 0.4 + cap_w
    # Find a free y for this bit's bus
    # Use row buses: each row that has this bit gets an m2 segment
    for row in sorted(set(row_range)):
        by = row_bus_y[row]
        # m2 segment spanning the columns of this bit in this row
        c.rect(m2, x0=x0, y0=by, x1=x1, y1=by + 1.3, net=net)
        # Connect each cap in this row to the m2 bus
        for col in col_range:
            if row not in row_range:
                continue
            # Find the cap
            cap = None
            for ccap in cap_by_net[net]:
                if abs(ccap.cx - col * pitch) < 0.1 and abs(ccap.cy - row * pitch) < 0.1:
                    cap = ccap
                    break
            if cap is None:
                continue
            # via2 from m2 bus to m3 bottom pad (m3->m2 via2)
            # Place via2 at the edge of the cap, outside capm region
            # Bottom pad is on m3; via2 connects m2 to m3
            vx = cap.b.right + 0.6   # just outside the cap's right edge
            vy = cap.b.cy
            # Make sure via2 is within the m2 bus
            if vx > x1 - 0.6:
                vx = cap.b.left - 0.6
            c.via(m2, m3, at=(vx, vy), net=net, dir="h")

# ---------- m2 bit buses above array, connecting row buses to pins ----------
bus2_y = array_top + 3.0
bus2_h = 0.9
bus2_pitch = 1.7
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
m2_buses = {}
pin_rects = {}
for i, net in enumerate(bit_order):
    y = bus2_y + i * bus2_pitch
    m2_buses[net] = c.rect(m2, x0=-1.0, y0=y, x1=array_right + 1.0,
                           y1=y + bus2_h, net=net)
    # Pin on left edge (m1)
    pin_rects[net] = c.rect(m1, x0=-6.0, y0=y + bus2_h/2 - 0.45,
                            x1=-2.0, y1=y + bus2_h/2 + 0.45, net=net)
    # via m1->m2 from pin to bus
    c.via(m1, m2, at=(-2.0, y + bus2_h/2), net=net, dir="v")

# Connect row buses to bit buses above array using m1 verticals + vias
for net, col_range, row_range in bit_map:
    if net == "TOP" or net not in m2_buses:
        continue
    # Find columns used by this bit
    cols_used = sorted(set(col_range))
    # Route from row buses up to the bit bus using m1 verticals at column edges
    for col in cols_used:
        x = col * pitch + cap_w / 2
        # m1 vertical from bottom of array to bit bus
        c.rect(m1, x0=x - 0.45, x1=x + 0.45,
               y0=-1.0, y1=bus2_y + bit_order.index(net) * bus2_pitch + bus2_h, net=net)
        # vias m1->m2 at each row bus and at the top bit bus
        for row in sorted(set(row_range)):
            by = row_bus_y[row]
            c.via(m1, m2, at=(x, by + 0.65), net=net, dir="v")
        c.via(m1, m2, at=(x, bus2_y + bit_order.index(net) * bus2_pitch + bus2_h/2), net=net, dir="v")

# ---------- Ports ----------
for net in ["TOP"] + bit_order:
    if net == "TOP":
        c.port("TOP", on=top_plane, dir="inout")
    else:
        c.port(net, on=pin_rects[net], dir="inout")

TOP = c


