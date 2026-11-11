```
from icdsl.canvas import *

tech = use()
c1, c2, c3, c4 = tech.c1, tech.c2, tech.c3, tech.c4

# ------------------------------------------------------------------ unit cap
CAP = 5.0
PX = PY = 7.0
# one bit per column: B5 x4 (32), B4 x2 (16), B3 x1 (8), B2 x1 (4),
# B1 x1 (2), B0 x1 (1), VSS x1 (1)  -> 64 units
COL_BIT = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + ["B2"] + ["B1"] + ["B0"] + ["VSS"]
COL_ROWS = {"B5": 8, "B4": 8, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

c = Cell("cdac6")
by_bit = {b: [] for b in COL_ROWS}
all_caps = []
for col, bit in enumerate(COL_BIT):
    for row in range(COL_ROWS[bit]):
        k = c.capacitor("cap_mim", w=CAP, h=CAP,
                        at=(col * PX, row * PY), nets=("TOP", bit))
        by_bit[bit].append(k)
        all_caps.append(k)

top_layer = all_caps[0].top_pad.layer   # capm
bot_layer = by_bit["B5"][0].bottom_pad.layer  # m3

# ------------------------------------------------------------------ bottom plates: one m3 mesh per bit
# bits live in disjoint column ranges, so meshes never approach each other.
for bit, caps in by_bit.items():
    if not caps:
        continue
    x0 = min(k.bottom_pad.left for k in caps) - 0.1
    x1 = max(k.bottom_pad.right for k in caps) + 0.1
    y0 = min(k.bottom_pad.bottom for k in caps) - 0.1
    y1 = max(k.bottom_pad.top for k in caps) + 0.1
    mesh = c.rect(bot_layer, x0=x0, x1=x1, y0=y0, y1=y1, net=bit)
    c.port(bit, on=mesh)

# ------------------------------------------------------------------ TOP: m4 trunk + drops, one via3 per cap top plate
# m4 (min width/space 1.6 on sky130) runs over m3/capm without contact;
# via3 lands on the capm pad (enclosure 0.14) and on the m4 drop.
M4W = 1.6
for col, bit in enumerate(COL_BIT):
    xt = col * PX + CAP / 2.0
    colcaps = [k for k in all_caps
               if abs((k.top_pad.left + k.top_pad.right) / 2 - xt) < 0.4 * PX]
    if not colcaps:
        continue
    y0 = min(k.top_pad.bottom for k in colcaps) - 0.1
    y1 = max(k.top_pad.top for k in colcaps) + 0.1
    # vertical m4 drop through the column, ties every top plate of this column
    drop = c.rect(c4, x0=xt - M4W / 2, x1=xt + M4W / 2, y0=y0, y1=y1, net="TOP")
    for k in colcaps:
        cx = (k.top_pad.left + k.top_pad.right) / 2
        cy = (k.top_pad.bottom + k.top_pad.top) / 2
        c.rect(c4, x0=cx - M4W / 2, x1=cx + M4W / 2,
               y0=cy - M4W / 2, y1=cy + M4W / 2, net="TOP")
        c.rect("via3", x0=cx - 0.4, x1=cx + 0.4, y0=cy - 0.4, y1=cy + 0.4, net="TOP")

# horizontal m4 trunk above the array, ties all column drops
x0 = min(k.top_pad.left for k in all_caps) - 1.0
x1 = max(k.top_pad.right for k in all_caps) + 1.0
y1 = max(k.top_pad.top for k in all_caps) + 0.6
trunk = c.rect(c4, x0=x0, x1=x1, y0=y1 - M4W, y1=y1, net="TOP")
c.port("TOP", on=trunk)

TOP = c


```