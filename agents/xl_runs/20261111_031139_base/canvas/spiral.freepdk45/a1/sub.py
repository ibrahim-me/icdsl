"""Octagonal spiral inductor on the top metal, same script on sky130A / gf180mcuD / freepdk45."""
from icdsl.canvas import *
from icdsl.canvas.route import Router
import math

tech = use()
SQRT2 = math.sqrt(2)

# ------------------------------------------------------------------ geometry
w = 4.0          # trace width (>= 4.0 um everywhere)
gap = 3.0        # turn-to-turn clearance (above any PDK metal space rule)
pitch = w + gap  # centre-line pitch between adjacent turns
n_turns = 3      # full turns counted from the centre
n_seg = 8 * n_turns

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

# Lengths of the straight (axial) segments per turn; diagonal corner extent = pitch.
# With these increments the perpendicular spacing between consecutive turns is
# exactly `pitch` on axial segments and >= pitch on the 45 deg corners.
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
outer = pts[-1]
via = top.via(Mbelow, Mtop, at=inner, net="L")
up = top.wire(Mbelow, [via.upper, (via.upper.x - 2.0 * pitch, via.upper.y)],
              width=w, net="L", first="h")

# outer end label / port
top.port("L", on=sp, dir="in")
top.port("L", on=up, dir="out")

# keep the bounding box tidy: the underpass sticks out to the left of the coil
print("bbox:", top.bbox, "area:", top.bbox.w * top.bbox.h, "um^2")
