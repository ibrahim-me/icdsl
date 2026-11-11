```
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
stack = tech.stack
top_metal = stack[-1]

assert "cap_mim" in tech.d["devices"], "cdac6 needs cap_mim"

PITCH = 6.0
COLS = 8
ROWS = 8
UNIT = 5.0

bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]

c = Cell("cdac6")

# ---- place 64 unit MIM capacitors in an 8x8 grid -------------------------
assign = []
for bit in bit_order:
    assign += [bit] * bit_counts[bit]
assert len(assign) == COLS * ROWS

caps = []
for idx in range(COLS * ROWS):
    col = idx % COLS
    row = idx // COLS
    cap = c.capacitor("cap_mim", w=UNIT, h=UNIT,
                      at=(col * PITCH, row * PITCH),
                      nets=("TOP", assign[idx]))
    caps.append(cap)

first_cap = caps[0]
top_layer = first_cap.top_pad.layer
bot_layer = first_cap.bottom_pad.layer
assert top_layer != bot_layer

# ---- TOP plate: solid plane over the whole array --------------------------
pad = 1.0
x0 = -pad
y0 = -pad
x1 = COLS * PITCH + pad
y1 = ROWS * PITCH + pad
top_plane = c.rect(top_layer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")

# ---- bottom plates: one trunk per bit on a metal above the pads -----------
bi = stack.index(bot_layer)
trunk_layer = stack[bi + 1] if bi + 1 < len(stack) else top_metal
trunk_w = max(tech.width(trunk_layer), 0.3)
trunk_h = 0.5

n_bits = len(bit_order)
trunk_ys = [y0 + pad + (i + 0.5) * (y1 - y0 - 2 * pad) / n_bits for i in range(n_bits)]

for bit, ty in zip(bit_order, trunk_ys):
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    xs = [p.cx for p in pads]
    trunk = c.rect(trunk_layer, x0=min(xs) - 1.0, x1=max(xs) + 1.0,
                   y0=ty - trunk_h / 2, y1=ty + trunk_h / 2, net=bit)
    for p in pads:
        c.via(bot_layer, trunk_layer, at=(p.cx, p.cy), net=bit)
        c.rect(trunk_layer, x0=p.cx - trunk_w / 2, x1=p.cx + trunk_w / 2,
               y0=min(p.cy, ty), y1=max(p.cy, ty), net=bit)

# ---- ports ----------------------------------------------------------------
c.port("TOP", on=top_plane)
for bit in bit_order:
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    p = pads[0]
    bar = c.rect(trunk_layer, x0=p.cx - trunk_w / 2, x1=p.cx + trunk_w / 2,
                 y0=p.cy, y1=p.cy + trunk_w, net=bit)
    c.port(bit, on=bar)

TOP = c

```