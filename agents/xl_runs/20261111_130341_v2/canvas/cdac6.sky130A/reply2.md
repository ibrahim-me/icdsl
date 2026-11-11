```
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3

# ------------------------------------------------------------------ unit cap
CAP_W, CAP_H = 5.0, 5.0
PX, PY = 7.0, 7.0
ROWS = 8

# One bit per column (no column mixes bits -> no vertical-net conflicts).
# B5 x4 cols (32), B4 x2 cols (16), B3 x1 col (8), B2 x1 col (4),
# B1 x1 col (2), B0 x1 col (1), VSS x1 col (1)  = 64 units
COL_BIT = (["B5"] * 4 + ["B4"] * 2 + ["B3"] * 1 +
           ["B2"] * 1 + ["B1"] * 1 + ["B0"] * 1 + ["VSS"] * 1)
COLS = len(COL_BIT)
COL_ROWS = {"B5": ROWS, "B4": ROWS, "B3": ROWS, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

TOP_NET = "TOP"

c = Cell("cdac6")
caps = []
for col in range(COLS):
    bit = COL_BIT[col]
    for row in range(COL_ROWS[bit]):
        k = c.capacitor("cap_mim", w=CAP_W, h=CAP_H,
                        at=(col * PX, row * PY),
                        nets=(TOP_NET, bit))
        caps.append(k)

# ------------------------------------------------------------------ TOP bus
# solid c3 fill over the whole array; every top plate ties to it
x0 = min(k.top_pad.left for k in caps) - 0.6
x1 = max(k.top_pad.right for k in caps) + 0.6
y0 = min(k.top_pad.bottom for k in caps) - 0.6
y1 = max(k.top_pad.top for k in caps) + 0.6
top_bus = c.rect(c3, x0=x0, x1=x1, y0=y0, y1=y1, net=TOP_NET)
for k in caps:
    if k.top_pad.layer != c3:
        c.via(k.top_pad.layer, c3, at=k.top_pad, net=TOP_NET)
c.port(TOP_NET, on=top_bus, dir="out")

# ------------------------------------------------------------------ bit buses (c2, horizontal, above the array)
BIT_ORDER = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
BIT_Y = {}
by = y1 + 1.2
for bit in BIT_ORDER:
    BIT_Y[bit] = by
    by += 1.6

strip_w = max(tech.width(c1), 1.0)
for bit in BIT_ORDER:
    bus = c.rect(c2, x0=x0 - 1.0, x1=x1 + 1.0,
                 y0=BIT_Y[bit] - 0.8, y1=BIT_Y[bit] + 0.8, net=bit)
    c.port(bit, on=bus, dir="out")

# ------------------------------------------------------------------ vertical drops (c1), one per column, to that column's bit bus
for col in range(COLS):
    bit = COL_BIT[col]
    nrows = COL_ROWS[bit]
    xt = col * PX + CAP_W / 2.0
    first = caps[0]  # placeholder
    col_caps = [k for k in caps
                if abs((k.top_pad.left + k.top_pad.right) / 2 - xt) < 0.5 * PX
                and k.nets[1] == bit] if hasattr(k, "nets") else None
    # rebuild: caps belonging to this column (by x centre)
    col_caps = [k for k in caps
                if abs((k.top_pad.left + k.top_pad.right) / 2 - xt) < 0.4 * PX]
    if not col_caps:
        continue
    ybot = min(k.bottom_pad.bottom for k in col_caps) - 0.3
    ytop = BIT_Y[bit] - 0.8          # bottom of the bit bus
    strip = c.rect(c1, x0=xt - strip_w / 2, x1=xt + strip_w / 2,
                   y0=ybot, y1=ytop, net=bit)
    for k in col_caps:
        if k.bottom_pad.layer != c1:
            c.via(k.bottom_pad.layer, c1, at=k.bottom_pad, net=bit)
    c.via(c1, c2, at=(strip.cx, strip.top), net=bit)

TOP = c

```