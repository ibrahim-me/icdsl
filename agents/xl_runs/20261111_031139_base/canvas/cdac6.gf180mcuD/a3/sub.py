from icdsl.canvas import *
from collections import defaultdict

tech = use()

CAP = 5.0
PITCH = 6.0
COLS = 8
GAP = 2.0
g = 0.3

bands = [("B5", 4), ("B4", 2), ("B3", 1), ("B2", 1), ("B1", 1), ("B0", 1), ("VSS", 1)]
band_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}

top = Cell("cdac6")

caps = []
cap_bits = []
y = 0
for bit, nrows in bands:
    placed = 0
    for r in range(nrows):
        for c in range(COLS):
            if placed >= band_counts[bit]:
                break
            cc = top.capacitor("cap_mim", w=CAP, h=CAP,
                               at=(c * PITCH, y + r * PITCH),
                               nets=("TOP", bit))
            caps.append(cc)
            cap_bits.append(bit)
            placed += 1
        else:
            continue
        break
    y += nrows * PITCH + GAP

assert len(caps) == 64

tpads = [c.top_pad for c in caps]
bpads = [c.bottom_pad for c in caps]
tlayer = tpads[0].layer
blayer = bpads[0].layer

# TOP: one solid top-plate plane over the whole array
x0 = min(p.left for p in tpads) - 0.6
y0 = min(p.bottom for p in tpads) - 0.6
x1 = max(p.right for p in tpads) + 0.6
y1 = max(p.top for p in tpads) + 0.6
plane = top.rect(tlayer, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")
top.port("TOP", on=plane, dir="out")

# bottom plates: one island per bit, trunk to a port on the right
by_bit = defaultdict(list)
for c, b in zip(caps, cap_bits):
    by_bit[b].append(c.bottom_pad)

trunk_w = max(1.0, 2 * tech.space(blayer))
for b, pads in sorted(by_bit.items()):
    isl = top.rect(blayer,
                   x0=min(p.left for p in pads) - g,
                   y0=min(p.bottom for p in pads) - g,
                   x1=max(p.right for p in pads) + g,
                   y1=max(p.top for p in pads) + g, net=b)
    iy = (isl.bottom + isl.top) / 2
    top.wire(blayer, [(isl.right, iy), (x1 + trunk_w, iy)],
             width=trunk_w, net=b, first="h")
    prect = top.rect(blayer, x0=x1 + 0.2, x1=x1 + trunk_w,
                     y0=iy - trunk_w / 2, y1=iy + trunk_w / 2, net=b)
    top.port(b, on=prect, dir="out")

TOP = top

