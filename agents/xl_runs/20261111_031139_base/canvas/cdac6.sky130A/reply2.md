```python
from icdsl.canvas import *

tech = use()
c0, m1, m2, m3 = tech.c0, tech.metal(1), tech.metal(2), tech.metal(3)

PITCH = 6.0
COLS = 8
SIDE = 2.0
BUS_H = 1.0
BOT_MARGIN = 3.0
TOP_MARGIN = 3.0

bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

order = [(i * 7) % 64 for i in range(64)]
flat = []
for bit, n in bit_counts.items():
    flat += [bit] * n
assert len(flat) == 64
assign = [flat[order[i]] for i in range(64)]

c = Cell("cdac6")
caps = []
for i, net in enumerate(assign):
    col, row = i % COLS, i // COLS
    cc = c.capacitor("cap_mim", w=5.0, h=5.0, at=(col * PITCH, row * PITCH), nets=("TOP", net))
    caps.append(cc)

# bounding box of all capacitor pads
all_pads = [cc.top_pad for cc in caps] + [cc.bottom_pad for cc in caps]
array_left = min(p.left for p in all_pads)
array_right = max(p.right for p in all_pads)
array_top = max(p.top for p in all_pads)
array_bottom = min(p.bottom for p in all_pads)

# ---------- TOP rail on m2 above the array ----------
top_rail_y = array_top + TOP_MARGIN
top_rail = c.rect(m2, x0=array_left - SIDE, x1=array_right + SIDE,
                  y0=top_rail_y, y1=top_rail_y + BUS_H, net="TOP")

# connect every top pad to the TOP rail (via to m2, vertical m2 segment up to rail)
for cc in caps:
    pad = cc.top_pad
    v = c.via(m2, m3, at=(pad.cx, pad.cy), net="TOP")   # lower=m2 pad, upper=m3 pad
    mp = v.lower                                        # m2 pad of the via
    y0 = min(mp.top, top_rail_y)
    y1 = max(mp.bottom, top_rail_y + BUS_H)
    c.rect(m2, x0=mp.left, x1=mp.right, y0=y0, y1=y1, net="TOP")

# ---------- bit buses on m2 below the array ----------
bus_y = array_bottom - BOT_MARGIN
buses = {}
for bit in bit_counts:
    buses[bit] = c.rect(m2, x0=array_left - SIDE, x1=array_right + SIDE,
                        y0=bus_y, y1=bus_y + BUS_H, net=bit)

# connect every bottom pad to its bit bus (via to m2, vertical m2 segment down to bus)
for cc, net in zip(caps, assign):
    pad = cc.bottom_pad
    v = c.via(m2, m3, at=(pad.cx, pad.cy), net=net)
    mp = v.lower                                        # m2 pad of the via
    y0 = min(mp.bottom, bus_y + BUS_H)
    y1 = max(mp.top, bus_y + BUS_H)
    c.rect(m2, x0=mp.left, x1=mp.right, y0=y0, y1=y1, net=net)

# ---------- pins ----------
c.port("TOP", on=top_rail, dir="out")
for bit in ["B0", "B1", "B2", "B3", "B4", "B5"]:
    c.port(bit, on=buses[bit], dir="in")
c.port("VSS", on=buses["VSS"], dir="in")

c.name = "cdac6"
TOP = c
```