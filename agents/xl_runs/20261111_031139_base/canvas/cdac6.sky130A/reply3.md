```
from icdsl.canvas import *

tech = use()
m1, m2, m3, m4 = tech.metal(1), tech.metal(2), tech.metal(3), tech.metal(4)

PITCH = 10.0
COLS = 8
ROWS = 8
SIDE = 3.0
BUS_H = 2.0
RAIL_H = 2.0
MARGIN = 3.0

bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

order = [(i * 7) % 64 for i in range(64)]
flat = []
for bit, n in bit_counts.items():
    flat += [bit] * n
assign = [flat[order[i]] for i in range(64)]

c = Cell("cdac6")
caps = []
for i, net in enumerate(assign):
    col, row = i % COLS, i // COLS
    cc = c.capacitor("cap_mim", w=5.0, h=5.0, at=(col * PITCH, row * PITCH), nets=("TOP", net))
    caps.append(cc)

array_left = min(cc.bottom_pad.left for cc in caps)
array_right = max(cc.bottom_pad.right for cc in caps)
array_top = max(cc.bottom_pad.top for cc in caps)
array_bottom = min(cc.bottom_pad.bottom for cc in caps)

# TOP rail on m4 above the array
top_rail_y = array_top + MARGIN
top_rail = c.rect(m4, x0=array_left - SIDE, x1=array_right + SIDE,
                  y0=top_rail_y, y1=top_rail_y + RAIL_H, net="TOP")

# Connect each top pad (m3) to TOP rail (m4) via via3 + m4 vertical segment
for cc in caps:
    pad = cc.top_pad
    v = c.via(m3, m4, at=(pad.cx, pad.cy), net="TOP")
    mp = v.upper
    y0 = min(mp.bottom, top_rail_y)
    y1 = max(mp.top, top_rail_y + RAIL_H)
    c.rect(m4, x0=mp.left, x1=mp.right, y0=y0, y1=y1, net="TOP")

# Bit buses on m1 below the array, stacked vertically
bus_y = array_bottom - MARGIN
buses = {}
for i, bit in enumerate(bit_counts):
    by = bus_y + i * (BUS_H + 0.6)
    buses[bit] = c.rect(m1, x0=array_left - SIDE, x1=array_right + SIDE,
                        y0=by, y1=by + BUS_H, net=bit)

# Connect each bottom pad (m2) to its bit bus (m1) via via + m1 vertical segment
for cc, net in zip(caps, assign):
    pad = cc.bottom_pad
    v = c.via(m1, m2, at=(pad.cx, pad.cy), net=net)
    mp = v.lower
    by = buses[net].bottom
    y0 = min(mp.top, by + BUS_H)
    y1 = max(mp.bottom, by)
    c.rect(m1, x0=mp.left, x1=mp.right, y0=y0, y1=y1, net=net)

# Ports
c.port("TOP", on=top_rail, dir="out")
for bit in ["B0", "B1", "B2", "B3", "B4", "B5"]:
    c.port(bit, on=buses[bit], dir="in")
c.port("VSS", on=buses["VSS"], dir="in")

c.name = "cdac6"
TOP = c
```