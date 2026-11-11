```python
from icdsl.canvas import *
import math

tech = use()
top = tech.stack[-1]          # top metal
bot = tech.stack[-2]          # metal below top (underpass layer)

W = 4.5                       # trace width (>= 4.0 um)
S = 6.0                       # turn spacing (>> any PDK min metal space)
P = W + S                     # centerline pitch
D = 8.0                       # 45 deg chamfer length
SQRT2 = math.sqrt(2)

# ---- octagonal spiral centreline (8 directions, 3 full turns + outer lead) ----
dirs = [(1, 0), (SQRT2 / 2, SQRT2 / 2), (0, 1), (-SQRT2 / 2, SQRT2 / 2),
        (-1, 0), (-SQRT2 / 2, -SQRT2 / 2), (0, -1), (SQRT2 / 2, -SQRT2 / 2)]
lengths = [14.0]
for k in range(1, 25):
    lengths.append(lengths[-1] + (P if k % 2 == 1 else D))

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for k in range(24):
    dx, dy = dirs[k % 8]
    x += dx * lengths[k]
    y += dy * lengths[k]
    pts.append((x, y))

c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")          # one open coil, all one net

# ---- inner end: via down + underpass on the metal below, out of the coil ----
inner = pts[0]
v = c.via(bot, top, at=inner, net="L")
ux, uy = inner[0] - 3.0 * P, inner[1]          # run left, clear of the coil
up = c.rect(bot, x0=v.lower.left, x1=ux, y0=v.lower.bottom - W / 2,
            y1=v.lower.top + W / 2, net="L")

# ---- ports: outer end of the coil, and the underpass end outside the coil ----
c.port("L", on=sp, dir="out")
c.port("L", on=up, dir="out")

TOP = c
``````python
from icdsl.canvas import *
import math

tech = use()
top = tech.stack[-1]          # top metal
bot = tech.stack[-2]          # metal below top (underpass layer)

W = 4.5                       # trace width (>= 4.0 um everywhere)
S = 6.0                       # turn spacing (>> any PDK min metal space)
P = W + S                     # centreline pitch between adjacent turns
D = 8.0                       # 45 deg chamfer length
SQRT2 = math.sqrt(2)

# ---- octagonal spiral centreline: 8 directions, 3 full turns + outer lead ----
dirs = [(1, 0), (SQRT2 / 2, SQRT2 / 2), (0, 1), (-SQRT2 / 2, SQRT2 / 2),
        (-1, 0), (-SQRT2 / 2, -SQRT2 / 2), (0, -1), (SQRT2 / 2, -SQRT2 / 2)]
lengths = [14.0]
for k in range(1, 24):
    lengths.append(lengths[-1] + (P if k % 2 == 1 else D))

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for k in range(24):
    dx, dy = dirs[k % 8]
    x += dx * lengths[k]
    y += dy * lengths[k]
    pts.append((x, y))

c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")          # one open coil, all one net

# ---- inner end: via down + underpass on the metal below, routed out of the coil ----
inner = pts[0]
v = c.via(bot, top, at=inner, net="L")
ux = inner[0] - 3.0 * P                          # clear of the coil turns
uy = inner[1]
up = c.rect(bot, x0=v.lower.left, x1=ux, y0=v.lower.bottom - W / 2,
            y1=v.lower.top + W / 2, net="L")

# ---- ports: outer end of the coil, and the underpass end outside the coil ----
c.port("L", on=sp, dir="out")
c.port("L", on=up, dir="out")

TOP = c
```