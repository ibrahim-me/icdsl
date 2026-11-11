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
# Directions cycle E, NE, N, NW, W, SW, S, SE.
# Manhattan segments move by `step`; 45-deg segments move by (d, d) with d on grid
# so every vertex is on-grid and every edge is exactly H, V or 45 deg.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

nseg = 24                     # 3 full turns (8 segments per turn)
step0 = 4.0                   # first Manhattan segment length
d0 = 4.0                      # first 45-deg increment (x and y)
grow = 2.0 * pitch            # size growth per segment -> keeps one pitch spacing

pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(nseg):
    size = step0 + grow * k
    dx, dy = DIRS[k % 8]
    if dx and dy:             # 45-degree segment: x and y move by the same on-grid amount
        x += size * dx
        y += size * dy
    else:                     # Manhattan segment
        x += size * dx
        y += size * dy
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L")   # one open coil

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