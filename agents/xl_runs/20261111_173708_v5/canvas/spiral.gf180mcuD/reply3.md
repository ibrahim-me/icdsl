```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]

W = 4.0          # trace width (>= 4.0 um on every PDK)
PITCH = 12.0     # centre-to-centre pitch; edge gap = PITCH - W = 8.0 um >> min space
n_turns = 3

# ---------- octagonal spiral centreline (CCW, expands by PITCH per turn) ----------
# Segment k goes in direction DIRS[k % 8]. Straight lengths and diagonal extents
# grow by PITCH every two segments, exactly like a square spiral, so consecutive
# turns are separated by PITCH and the path never self-intersects.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x = y = 0.0
n_seg = 8 * n_turns + 1          # one extra segment so the outer end is free
for k in range(n_seg):
    dx, dy = DIRS[k % 8]
    m = k // 2 + 1               # 1,1,2,2,3,3,... growth
    if dx and dy:                # 45-degree diagonal: x and y extent
        x += dx * m * PITCH
        y += dy * m * PITCH
    else:                        # horizontal / vertical straight
        x += dx * m * PITCH
        y += dy * m * PITCH
    pts.append((x, y))

# ---------- cell ----------
c = Cell("spiral")

# spiral on top metal, one net "L"
sp = c.path(top, pts, width=W, net="L")

# inner end: via down to the metal below, then an underpass out of the coil
v = c.via(below, top, at=pts[0], net="L", dir="v")
bx0 = v.lower.left - W / 2
bx1 = v.lower.right + W / 2
by1 = v.lower.top
by0 = min(p[1] for p in pts) - 2.0 * PITCH   # clearly outside the coil footprint
up = c.rect(below, x0=bx0, x1=bx1, y0=by0, y1=by1, net="L")

# ports (both ends of the open coil are net "L")
c.port("L", on=sp, dir="out")
c.port("L", on=up, dir="out")

TOP = c

```