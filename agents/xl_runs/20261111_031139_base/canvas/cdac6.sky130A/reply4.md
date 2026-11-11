```
from icdsl.canvas import *

tech = use()
m1, m2, m3, m4 = tech.metal(1), tech.metal(2), tech.metal(3), tech.metal(4)

PITCH = 9.0
COLS = 8
CAP = 5.0
GAP = 0.6
SIDE = 3.0
RAIL_H = 2.0
MARGIN = 3.0

# cluster by bit (interleaving is only "good practice, not judged")
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

c = Cell("cdac6")
strips = []          # (bit, y0, y1, [caps])
y = 0.0
for bit, n in bit_counts.items():
    rows = (n + COLS - 1) // COLS
    cap_list = []
    for i in range(n):
        col, row = i % COLS, i // COLS
        cc = c.capacitor("cap_mim", w=CAP, h=CAP,
                         at=(col * PITCH, y + row * PITCH),
                         nets=("TOP", bit))
        cap_list.append(cc)
    strips.append((bit, y, y + rows * PITCH, cap_list))
    y += rows * PITCH

array_top = y
array_left = 0.0
array_right = COLS * PITCH

# ---------- TOP rail on m4 above the whole array ----------
top_rail_y = array_top + MARGIN
top_rail = c.rect(m4, x0=array_left - SIDE, x1=array_right + SIDE,
                  y0=top_rail_y, y1=top_rail_y + RAIL_H, net="TOP")

# connect every top plate (m3) to TOP rail (m4): via3 + m4 vertical (m4 over caps is fine)
for bit, y0, y1, cap_list in strips:
    for cc in cap_list:
        pad = cc.top_pad
        v = c.via(m3, m4, at=(pad.cx, pad.cy), net="TOP")
        mp = v.upper
        seg_y0 = min(mp.bottom, top_rail_y)
        seg_y1 = max(mp.top, top_rail_y + RAIL_H)
        c.rect(m4, x0=mp.left, x1=mp.right, y0=seg_y0, y1=seg_y1, net="TOP")

# ---------- bit buses on m1 below the array, stacked with clearance ----------
bus_y = -MARGIN
buses = {}
for i, (bit, y0, y1, cap_list) in enumerate(strips):
    by = bus_y + i * (RAIL_H + GAP)
    buses[bit] = c.rect(m1, x0=array_left - SIDE, x1=array_right + SIDE,
                        y0=by, y1=by + RAIL_H, net=bit)

# connect every bottom plate (m2) to its strip's bit bus (m1):
# m2 horizontal segment within the strip row to the strip's right edge,
# via m1/m2 at the edge, m1 vertical down to the bus.
for bit, y0, y1, cap_list in strips:
    if not cap_list:
        continue
    cy = (cap_list[0].bottom_pad.bottom + cap_list[-1].bottom_pad.top) / 2
    # right-edge via, placed in the gap just right of the array
    vx = array_right + SIDE - 0.5
    # m2 segment from the rightmost bottom pad to the via x
    rightmost = max(cap_list, key=lambda cc: cc.bottom_pad.right)
    rp = rightmost.bottom_pad
    x0 = min(rp.right, vx)
    x1 = max(rp.left, vx)
    if x1 > x0:
        c.rect(m2, x0=x0, x1=x1, y0=rp.bottom, y1=rp.top, net=bit)
    v = c.via(m1, m2, at=(vx, cy), net=bit)
    mp = v.lower                      # m1 pad of the via
    by = buses[bit].bottom
    seg_y0 = min(mp.top, by + RAIL_H)
    seg_y1 = max(mp.bottom, by)
    if seg_y1 > seg_y0:
        c.rect(m1, x0=mp.left, x1=mp.right, y0=seg_y0, y1=seg_y1, net=bit)

# ---------- ports ----------
c.port("TOP", on=top_rail, dir="out")
for bit in ["B0", "B1", "B2", "B3", "B4", "B5"]:
    c.port(bit, on=buses[bit], dir="in")
c.port("VSS", on=buses["VSS"], dir="in")

c.name = "cdac6"
TOP = c

```