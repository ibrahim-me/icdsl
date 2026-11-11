```python
from icdsl.canvas import *
import math

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
stack = tech.stack
top_metal = stack[-1]
second = stack[-2]

assert "cap_mim" in tech.d["devices"], "cdac6 needs the cap_mim recipe"

PITCH = 6.0          # unit cap is 5x5; capm min space on gf180 is 0.6 um
COLS = 8
ROWS = 8
UNIT = 5.0

# bit -> number of unit capacitors (32/16/8/4/2/1 plus the spare unit to VSS)
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]

c = Cell("cdac6")

# ---- place 64 unit MIM capacitors in an 8x8 grid -------------------------
caps = []
k = 0
for row in range(ROWS):
    for col in range(COLS):
        if k < 64:
            net = "TOP" if False else None  # placeholder
        k += 1

# assign nets: fill row-major, 32 units B5, 16 B4, 8 B3, 4 B2, 2 B1, 1 B0, 1 VSS
assign = []
for bit in bit_order:
    assign += [bit] * bit_counts[bit]
assert len(assign) == 64

first_cap = None
for idx in range(64):
    row = idx // COLS
    col = idx % COLS
    x = col * PITCH
    y = row * PITCH
    cap = c.capacitor("cap_mim", w=UNIT, h=UNIT, at=(x, y),
                      nets=("TOP", assign[idx]))
    if first_cap is None:
        first_cap = cap
    caps.append(cap)

top_layer = first_cap.top_pad.layer
bot_layer = first_cap.bottom_pad.layer
assert top_layer != bot_layer, "expected top and bottom pads on different metals"

# ---- TOP: solid plane on the top-plate metal over the whole array ---------
x0 = -1.0
y0 = -1.0
x1 = COLS * PITCH + 1.0
y1 = ROWS * PITCH + 1.0
top_plane = c.rect(top_layer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")

# ---- bottom plates: one trunk per bit row + vertical stubs to each pad ----
TRUNK_W = max(tech.width(bot_layer), 0.6)
TRUNK_H = 0.55
STUB_W = max(tech.width(bot_layer), 0.6)

for bit in bit_order:
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    xs = sorted({round(p.cx, 6) for p in pads})
    ys = sorted({round(p.cy, 6) for p in pads})
    # trunk along the top edge of the bit's row span
    trunk_y = max(ys) + PITCH / 2 + 0.35
    trunk = c.rect(bot_layer, x0=min(xs) - 1.0, x1=max(xs) + 1.0,
                   y0=trunk_y - TRUNK_H / 2, y1=trunk_y + TRUNK_H / 2,
                   net=bit)
    for p in pads:
        c.rect(bot_layer, x0=p.cx - STUB_W / 2, x1=p.cx + STUB_W / 2,
               y0=min(p.cy, trunk_y), y1=max(p.cy, trunk_y), net=bit)

# ---- bring nets out to the top cell ports ---------------------------------
c.port("TOP", on=top_plane)
for bit in bit_order:
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    # port on the stub of the first pad of this bit
    p = pads[0]
    stub = c.rect(bot_layer, x0=p.cx - STUB_W / 2, x1=p.cx + STUB_W / 2,
                  y0=p.cy, y1=p.cy + 0.6, net=bit)
    c.port(bit, on=stub)

TOP = c
``````python
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
stack = tech.stack
top_metal = stack[-1]

assert "cap_mim" in tech.d["devices"], "cdac6 needs the cap_mim recipe"

PITCH = 6.0          # unit cap is 5x5; capm min space on gf180 is 0.6 um
COLS, ROWS = 8, 8
UNIT = 5.0

# 32/16/8/4/2/1 units for B5..B0, last unit to VSS (row-major placement)
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
assign = []
for bit in ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]:
    assign += [bit] * bit_counts[bit]
assert len(assign) == 64

c = Cell("cdac6")
caps = []
for idx in range(64):
    x = (idx % COLS) * PITCH
    y = (idx // COLS) * PITCH
    caps.append(c.capacitor("cap_mim", w=UNIT, h=UNIT, at=(x, y),
                            nets=("TOP", assign[idx])))

first_cap = caps[0]
top_layer = first_cap.top_pad.layer
bot_layer = first_cap.bottom_pad.layer
assert top_layer != bot_layer

# TOP plane: solid rectangle on the top-plate metal over the whole array
x0 = -1.0
y0 = -1.0
x1 = COLS * PITCH + 1.0
y1 = ROWS * PITCH + 1.0
top_plane = c.rect(top_layer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")

# bottom plates: one trunk per bit row plus vertical stubs to each pad
TRUNK_W = max(tech.width(bot_layer), 0.6)
TRUNK_H = 0.55
STUB_W = max(tech.width(bot_layer), 0.6)

for bit in bit_counts:
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    xs = sorted({round(p.cx, 6) for p in pads})
    ys = sorted({round(p.cy, 6) for p in pads})
    trunk_y = max(ys) + PITCH / 2 + 0.35
    c.rect(bot_layer, x0=min(xs) - 1.0, x1=max(xs) + 1.0,
           y0=trunk_y - TRUNK_H / 2, y1=trunk_y + TRUNK_H / 2, net=bit)
    for p in pads:
        c.rect(bot_layer, x0=p.cx - STUB_W / 2, x1=p.cx + STUB_W / 2,
               y0=min(p.cy, trunk_y), y1=max(p.cy, trunk_y), net=bit)

# ports
c.port("TOP", on=top_plane)
for bit in bit_counts:
    p = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit][0]
    stub = c.rect(bot_layer, x0=p.cx - STUB_W / 2, x1=p.cx + STUB_W / 2,
                  y0=p.cy, y1=p.cy + 0.6, net=bit)
    c.port(bit, on=stub)

TOP = c
```