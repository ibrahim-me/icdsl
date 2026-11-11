```
from icdsl.canvas import *

tech = use()
stack = tech.stack
top_metal = stack[-1]
bot_metal = stack[-2]

w = 4.2          # trace width (> 4.0 um, margin for miter joins)
pitch = 8.6      # centre-line pitch -> edge gap = 4.4 um > 1.6 um
d = 3.0          # 45-deg leg projection
L0 = 6.0         # first straight length

c = Cell("spiral")

# ---- octagonal spiral centreline on top metal, 3 full turns ----
# Directions: E, NE, N, NW, W, SW, S, SE  (always turn left, spiral outwards)
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
nseg = 24  # 3 turns x 8 segments
for s in range(nseg):
    sx, sy = dirs[s % 8]
    if sx and sy:          # 45-degree segment
        x += sx * d; y += sy * d
    else:                  # axial segment; length grows every two axial segments
        a = s // 2
        length = L0 + (a // 2) * pitch
        x += sx * length; y += sy * length
    pts.append((x, y))

spiral = c.path(top_metal, pts, width=w, net="L")
c.label("L", top_metal, at=spiral)           # outer end = top-metal port

# ---- inner end: via down to metal below, underpass to outside the coil ----
ix, iy = pts[0]
c.via(top_metal, bot_metal, at=(ix, iy), net="L", dir="h")
ux = spiral.right + 2.0                      # outside the coil on the right
under = c.rect(bot_metal, x0=ix, x1=ux, y0=iy - w / 2, y1=iy + w / 2, net="L")
c.port("L", on=under, dir="out")

TOP = c


```