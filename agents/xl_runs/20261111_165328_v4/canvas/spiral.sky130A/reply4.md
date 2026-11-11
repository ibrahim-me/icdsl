```
from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal (m5 on sky130)
below = tech.stack[-2]        # metal under the top metal (m4 on sky130)

w = 4.0                       # trace width (>= 4.0 um everywhere)
space = tech.space(top)       # min spacing on the top metal
pitch = w + space             # centre-to-centre pitch between turns

c = Cell("spiral")

# ---- octagonal spiral centreline ----
# All segment increments are on-grid numbers, so every vertex is on-grid
# and every edge is exactly horizontal, vertical, or 45 degrees.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

nseg = 24                     # 3 full turns (8 segments per turn)
step0 = 4.0                   # first segment length
grow = 1.0                    # length growth per segment

pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(nseg):
    size = step0 + grow * k
    dx, dy = DIRS[k % 8]
    x += size * dx
    y += size * dy
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L", ends="ext")   # one open coil

# ---- inner end: via down to the underpass metal ----
inner = pts[0]
v = c.via(below, top, at=inner, net="L", dir="h")

# ---- underpass on the metal below, from the via out beyond the coil ----
xs = [p[0] for p in pts]
ys = [p[1] for p in pts]
margin = 2.0 * pitch
ux1 = inner[0]
ux2 = max(xs) + margin
uy1 = inner[1] - 0.5 * w
uy2 = inner[1] + 0.5 * w
under = c.rect(below, x0=ux1, x1=ux2, y0=uy1, y1=uy2, net="L")

# ---- ports: both ends of the inductor are net "L" ----
c.port("L", on=spiral)        # outer end on top metal
c.port("L", on=under)         # inner end brought out on the metal below

TOP = c



```