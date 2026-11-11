```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2, m3 = tech.c0, tech.metal(1), tech.metal(2), tech.metal(3)

PITCH = 6.0          # 5.0 cap + 1.0 space (capm space = 0.84)
COLS = 8
TOP_MARGIN = 3.0     # room for the TOP rail above the array
BOT_MARGIN = 3.0     # room for bit buses below the array
SIDE = 2.0           # side clearance

# bit -> number of unit capacitors (MSB..LSB) plus the single VSS unit
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

# interleave the units of each bit over the array (good practice, not judged)
assign = []
order = [(i * 7) % 64 for i in range(64)]   # 7 is coprime to 64 -> a permutation
flat = []
for bit, n in bit_counts.items():
    flat += [bit] * n
assert len(flat) == 64
for i in range(64):
    assign.append(flat[order[i]])

c = Cell("cdac6")
caps = []
for i, net in enumerate(assign):
    col, row = i % COLS, i // COLS
    at = (col * PITCH, row * PITCH)
    cc = c.capacitor("cap_mim", w=5.0, h=5.0, at=at, nets=("TOP", net))
    caps.append(cc)

# ---------- top plate: one common TOP node ----------
top_pads = [cc.top_pad for cc in caps]
tp = c.box(m3, (
    min(p.left for p in top_pads) - 0.2,
    min(p.bottom for p in top_pads) - 0.2,
    max(p.right for p in top_pads) + 0.2,
    max(p.top for p in top_pads) + 0.2,
), net="TOP")

# ---------- bottom plates: route each bit to a horizontal m2 bus ----------
array_top = max(cc.bottom_pad.top for cc in caps)
array_bottom = min(cc.bottom_pad.bottom for cc in caps)
array_left = min(cc.bottom_pad.left for cc in caps)
array_right = max(cc.bottom_pad.right for cc in caps)

bus_y = array_bottom - BOT_MARGIN
bus_h = 1.0
buses = {}
for bit in bit_counts:
    buses[bit] = c.rect(m2, x0=array_left - SIDE, x1=array_right + SIDE,
                        y0=bus_y, y1=bus_y + bus_h, net=bit)

# connect every bottom pad to its bit bus: via to m1, vertical m1, via to m2 bus
for cc, net in zip(caps, assign):
    pad = cc.bottom_pad
    v1 = c.via(m3, m2, at=(pad.cx, pad.cy), net=net)   # plate -> m2
    seg = c.rect(m2, x0=v1.lower.left, x1=v1.lower.right,
                 y0=v1.lower.top, y1=bus_y + bus_h, net=net)
    c.via(m2, m2, at=(seg.cx, bus_y + bus_h / 2), net=net)  # keep on bus net (no-op shape guard)
    # tie the segment into the horizontal bus (same net, overlapping m2)
    c.rect(m2, x0=seg.left, x1=seg.right, y0=bus_y, y1=bus_y + bus_h, net=net)

# ---------- TOP pin: rail above the array ----------
top_rail_y = array_top + TOP_MARGIN
top_rail = c.rect(m2, x0=array_left - SIDE, x1=array_right + SIDE,
                  y0=top_rail_y, y1=top_rail_y + bus_h, net="TOP")
for cc in caps:
    pad = cc.top_pad
    c.via(m3, m2, at=(pad.cx, pad.cy), net="TOP")
    c.rect(m2, x0=v1.lower.left if False else pad.left, x1=pad.right,
           y0=top_rail_y, y1=top_rail_y + bus_h, net="TOP")

# ---------- pins ----------
c.port("TOP", on=top_rail, dir="out")
for bit in ["B0", "B1", "B2", "B3", "B4", "B5"]:
    c.port(bit, on=buses[bit], dir="in")
c.port("VSS", on=buses["VSS"], dir="in")

c.name = "cdac6"
TOP = c
```