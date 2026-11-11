from icdsl.canvas import *

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
m4 = tech.metal(4)
m5 = tech.metal(5)

c = Cell("cdac6")

cap_w = 5.0
cap_h = 5.0
pitch = 7.6
cols = 8
rows = 8

def get_bit(col, row):
    if col < 4:
        return "B5"
    elif col < 6:
        return "B4"
    elif col < 7:
        return "B3"
    elif col == 7:
        if row < 4:
            return "B2"
        elif row < 6:
            return "B1"
        elif row == 6:
            return "B0"
        else:
            return "VSS"

# Place capacitors
caps = []
for row in range(rows):
    for col in range(cols):
        net = get_bit(col, row)
        cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                          at=(col * pitch, row * pitch),
                          nets=("TOP", net))
        caps.append((cap, net, col, row))

# TOP plate: m5 plane over array
array_right = cols * pitch
array_top = rows * pitch
top_plane = c.rect(m5, x0=-1.0, y0=-1.0,
                   x1=array_right + 1.0, y1=array_top + 1.0, net="TOP")

for cap, net, col, row in caps:
    c.via(m4, m5, at=(cap.top_pad.cx, cap.top_pad.cy), net="TOP", dir="v")

c.port("TOP", on=top_plane, dir="inout")

# Bottom plates: m2 row-gap segments + m2 right-edge spine + m2 buses above array
bus_y_start = array_top + 2.0
bus_pitch = 2.0
bus_h = 0.9
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]

m2_buses = {}
pin_rects = {}
for i, net in enumerate(bit_order):
    y = bus_y_start + i * bus_pitch
    m2_buses[net] = c.rect(m2, x0=array_right - 1.0, y0=y,
                           x1=array_right + 6.0, y1=y + bus_h, net=net)
    pin_rects[net] = c.rect(m1, x0=-6.0, y0=y + bus_h / 2 - 0.45,
                            x1=-2.0, y1=y + bus_h / 2 + 0.45, net=net)
    c.rect(m1, x0=-2.0, y0=y + bus_h / 2 - 0.45, x1=array_right + 6.0,
           y1=y + bus_h / 2 + 0.45, net=net)
    c.via(m1, m2, at=(array_right + 3.0, y + bus_h / 2), net=net, dir="v")

# Row-gap m2 segments and connections
for row in range(rows):
    gap_y = row * pitch + cap_h + 0.3
    gap_h = 1.0
    row_caps = [(cap, net, col) for cap, net, col, r in caps if r == row]
    for net in set(n for _, n, _ in row_caps):
        nets_caps = [(cap, col) for cap, n, col in row_caps if n == net]
        if not nets_caps:
            continue
        x0 = min(col for _, col in nets_caps) * pitch - 0.4
        x1 = max(col for _, col in nets_caps) * pitch + cap_w + 0.4
        seg = c.rect(m2, x0=x0, y0=gap_y, x1=x1, y1=gap_y + gap_h, net=net)
        for cap, col in nets_caps:
            c.via(m2, m3, at=(cap.b.cx, cap.b.top + 0.4), net=net, dir="v")
        # Connect segment to right-edge spine
        c.rect(m2, x0=x1, y0=gap_y, x1=array_right - 1.0,
               y1=gap_y + gap_h, net=net)

# Ports
c.port("TOP", on=top_plane, dir="inout")
for net in bit_order:
    c.port(net, on=pin_rects[net], dir="inout")

TOP = c
