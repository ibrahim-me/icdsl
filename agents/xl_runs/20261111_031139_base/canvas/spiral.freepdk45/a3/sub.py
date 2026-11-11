"""Octagonal spiral inductor on the top metal, same script on sky130A / gf180mcuD / freepdk45."""
from icdsl.canvas import *
from icdsl.canvas.route import Router
import math

tech = use()
SQRT2 = math.sqrt(2)

# ------------------------------------------------------------------ geometry
w = 4.0          # trace width (>= 4.0 um everywhere)
gap = 3.0        # turn-to-turn edge clearance
pitch = w + gap  # centre-line pitch between adjacent turns
n_turns = 3      # full turns counted from the centre
n_seg = 8 * n_turns

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

# Segment lengths grow so the radius increases by `pitch` per turn (8 segments).
# Axial segments grow by 2*pitch per turn; 45 deg corners keep x/y extent = pitch.
L0 = 2.0 * pitch
straight = [L0 + 2.0 * pitch * t for t in range(n_turns)]

pts = [(0.0, 0.0)]
for k in range(n_seg):
    dx, dy = dirs[k % 8]
    t = k // 8
    if dx == 0 or dy == 0:          # axial segment
        length = straight[t]
    else:                            # 45 deg corner: x- and y-extent = pitch
        length = pitch * SQRT2
    x, y = pts[-1]
    pts.append((x + dx * length, y + dy * length))

# ------------------------------------------------------------------ cell
top = Cell("spiral")
Mtop = tech.stack[-1]
Mbelow = tech.stack[-2]

# spiral centre line, width >= w everywhere (path helper never narrows)
sp = top.path(Mtop, pts, w, net="L")

# inner end: via down to the metal below, underpass runs out from under the coil
inner = pts[0]
via = top.via(Mbelow, Mtop, at=inner, net="L")
up = top.wire(Mbelow, [(via.lower.cx, via.lower.cy),
                       (via.lower.cx - 2.0 * pitch, via.lower.cy)],
              width=w, net="L", first="h")

# port pads: small conductor rectangles overlapping the two open ends
outer = pts[-1]
po = top.rect(Mtop, x0=outer[0] - w / 2, x1=outer[0] + w / 2,
              y0=outer[1] - w / 2, y1=outer[1] + w / 2, net="L")
pi = top.rect(Mbelow, x0=via.lower.cx - w / 2, x1=via.lower.cx + w / 2,
              y0=via.lower.cy - w / 2, y1=via.lower.cy + w / 2, net="L")

top.port("L", on=po, dir="in")
top.port("L", on=pi, dir="out")

print("bbox:", top.bbox, "area:", top.bbox.w * top.bbox.h, "um^2")


