```
from icdsl.canvas import *

tech = use()
c1, c2, c3 = tech.c1, tech.c2, tech.c3

# ------------------------------------------------------------------ unit cap
CAP = 5.0
PX = PY = 7.0
# one bit per column: B5 x4 (32), B4 x2 (16), B3 x1 (8), B2 x1 (4),
# B1 x1 (2), B0 x1 (1), VSS x1 (1)  -> 64 units
COL_BIT = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + ["B2"] + ["B1"] + ["B0"] + ["VSS"]
COL_ROWS = {"B5": 8, "B4": 8, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

c = Cell("cdac6")
by_bit = {b: [] for b in COL_ROWS}
all_tops = []
for col, bit in enumerate(COL_BIT):
    for row in range(COL_ROWS[bit]):
        k = c.capacitor("cap_mim", w=CAP, h=CAP,
                        at=(col * PX, row * PY), nets=("TOP", bit))
        by_bit[bit].append(k)
        all_tops.append(k)

# pad layers (MIM: top plate and bottom plate are on different layers)
top_layer = all_tops[0].top_pad.layer
bot_layer = by_bit["B5"][0].bottom_pad.layer

# ------------------------------------------------------------------ TOP mesh
# connect every top plate on the top-plate layer: vertical bar per column
# (overlaps all pads of that column) + horizontal bars at each row level
# linking the columns.  Same net everywhere -> no DRC between them, no vias.
for col, bit in enumerate(COL_BIT):
    nrows = COL_ROWS[bit]
    xt = col * PX + CAP / 2.0
    colcaps = [k for k in all_tops
               if abs((k.top_pad.left + k.top_pad.right) / 2 - xt) < 0.4 * PX]
    if not colcaps:
        continue
    y0 = min(k.top_pad.bottom for k in colcaps) - 0.1
    y1 = max(k.top_pad.top for k in colcaps) + 0.1
    c.rect(top_layer, x0=xt - CAP / 2, x1=xt + CAP / 2, y0=y0, y1=y1, net="TOP")

for row in range(8):
    y = row * PY + CAP / 2.0
    present = [k for k in all_tops
               if abs((k.top_pad.bottom + k.top_pad.top) / 2 - y) < 0.4 * PY]
    if len(present) < 2:
        continue
    x0 = min(k.top_pad.left for k in present) - 0.1
    x1 = max(k.top_pad.right for k in present) + 0.1
    c.rect(top_layer, x0=x0, x1=x1, y0=y - CAP / 2, y1=y + CAP / 2, net="TOP")

c.port("TOP", on=c.rect(top_layer,
                        x0=min(k.top_pad.left for k in all_tops) - 1,
                        x1=max(k.top_pad.right for k in all_tops) + 1,
                        y0=min(k.top_pad.bottom for k in all_tops) - 1,
                        y1=max(k.top_pad.top for k in all_tops) + 1, net="TOP"))

# ------------------------------------------------------------------ bit meshes
# bottom plates of one bit -> one mesh on the bottom-plate layer, per bit.
# bits occupy disjoint column ranges, so meshes never overlap -> no shorts.
for bit, caps in by_bit.items():
    if not caps:
        continue
    x0 = min(k.bottom_pad.left for k in caps) - 1
    x1 = max(k.bottom_pad.right for k in caps) + 1
    y0 = min(k.bottom_pad.bottom for k in caps) - 1
    y1 = max(k.bottom_pad.top for k in caps) + 1
    mesh = c.rect(bot_layer, x0=x0, x1=x1, y0=y0, y1=y1, net=bit)
    c.port(bit, on=mesh)

TOP = c


```