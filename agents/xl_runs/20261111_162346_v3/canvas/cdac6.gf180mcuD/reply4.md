```
from icdsl.canvas import *

tech = use()
stack = tech.stack
c0 = tech.c0
top_metal = stack[-1]

assert "cap_mim" in tech.d["devices"], "cdac6 needs cap_mim"

PITCH = 9.0
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
bot_layer = first_cap.bottom_pad.layer
top_layer = first_cap.top_pad.layer
assert bot_layer != top_layer

# routing layer for bottom plates: one conductor below the bottom-plate layer
bi = stack.index(bot_layer)
route_layer = stack[bi - 1] if bi - 1 >= 0 else bot_layer
via_down = stack[bi - 1]  # cut between route_layer and bot_layer
# via_down is the cut name; the actual via call uses the two conductor layers

pad = 1.0
x0 = -pad
y0 = -pad
x1 = COLS * PITCH + pad
y1 = ROWS * PITCH + pad

# ---- TOP plate: solid plane on the top-plate layer ------------------------
top_plane = c.rect(top_layer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")

# ---- bottom plates: route on the layer below the bottom plate -------------
route_w = max(tech.width(route_layer), 0.3)
via_w = max(tech.width(via_down), 0.3) if via_down in tech.stack else 0.3

# via_down is a cut layer name; find the conductor pair
cut_idx = None
for i, lyr in enumerate(stack):
    if lyr == via_down:
        cut_idx = i
        break
if cut_idx is not None and cut_idx > 0:
    via_lower = stack[cut_idx - 1]
    via_upper = stack[cut_idx]
else:
    via_lower = route_layer
    via_upper = bot_layer

for bit in bit_order:
    pads = [cap.bottom_pad for cap, b in zip(caps, assign) if b == bit]
    # trunk at the right edge of the array
    trunk_x = x1 - route_w / 2
    trunk_y0 = min(p.cy for p in pads) - route_w / 2
    trunk_y1 = max(p.cy for p in pads) + route_w / 2
    trunk = c.rect(route_layer, x0=trunk_x - route_w / 2, x1=trunk_x + route_w / 2,
                   y0=trunk_y0, y1=trunk_y1, net=bit)
    for p in pads:
        # link from pad to trunk on route_layer
        c.rect(route_layer, x0=p.cx, x1=trunk_x,
               y0=p.cy - route_w / 2, y1=p.cy + route_w / 2, net=bit)
        # via from route_layer up to bottom_pad layer
        c.via(via_lower, via_upper, at=(trunk_x, p.cy), net=bit)
    # port on the trunk
    c.port(bit, on=trunk)

c.port("TOP", on=top_plane)

TOP = c


```