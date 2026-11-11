from icdsl.canvas import *

tech = use()                      # gf180mcuD (target); same script builds on sky130A
m4 = tech.metal(4)
m5 = tech.metal(5)
top_m = tech.stack[-1]            # top metal layer
bot_m = tech.stack[-2]            # metal below it

CAP = 5.0                         # unit cap: 5 x 5 um (matches netlist)
PITCH = 6.0
COLS, ROWS = 8, 8                 # 64 units in an 8 x 8 array

# bit assignment (index = row*COLS + col, row 0 = bottom)
bits = (["B5"] * 32 + ["B4"] * 16 + ["B3"] * 8 +
        ["B2"] * 4 + ["B1"] * 2 + ["B0"] + ["VSS"])
assert len(bits) == COLS * ROWS

top = Cell("cdac6")

caps = []
for idx in range(COLS * ROWS):
    col, row = idx % COLS, idx // COLS
    cc = top.capacitor("cap_mim", w=CAP, h=CAP,
                       at=(col * PITCH, row * PITCH),
                       nets=("TOP", bits[idx]))
    caps.append(cc)

# pad layers (dynamic so the script is PDK-portable)
tlayer = caps[0].top_pad.layer
blayer = caps[0].bottom_pad.layer

# ---- TOP: common top plate - one solid plane over the whole array ----
tpads = [c.top_pad for c in caps]
x0 = min(p.left for p in tpads) - 0.6
y0 = min(p.bottom for p in tpads) - 0.6
x1 = max(p.right for p in tpads) + 0.6
y1 = max(p.top for p in tpads) + 0.6
top_plane = top.rect(tlayer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")
# every top pad touches the plane on the same layer -> all tied to TOP

# ---- bottom plates: one island per bit, then a trunk to a side port ----
from collections import defaultdict
by_bit = defaultdict(list)
for c, b in zip(caps, bits):
    by_bit[b].append(c.bottom_pad)

g = 0.30                          # island growth beyond pad bounding box
trunk_w = max(1.0, 2 * tech.space(blayer))
islands = {}
for b, pads in by_bit.items():
    islands[b] = top.rect(blayer,
        x0=min(p.left for p in pads) - g,
        y0=min(p.bottom for p in pads) - g,
        x1=max(p.right for p in pads) + g,
        y1=max(p.top for p in pads) + g, net=b)

# port locations fanned out on the right side
bitnames = sorted(by_bit)
pitch_y = max(4.0, (y1 - y0) / (len(bitnames) + 1))
for i, b in enumerate(bitnames):
    py = y0 + (i + 1) * pitch_y
    iy = (islands[b].bottom + islands[b].top) / 2
    top.wire(blayer, [islands[b].right, (x1 + trunk_w, iy), (x1 + trunk_w, py)],
             width=trunk_w, net=b, first="h")
    pad = top.rect(blayer,
        x0=x1 + 0.2, x1=x1 + trunk_w,
        y0=py - trunk_w / 2, y1=py + trunk_w / 2, net=b)
    top.port(b, on=pad, dir="out")

top.port("TOP", on=top_plane, dir="out")
