```
from icdsl.canvas import *
import math

tech = use()
top = tech.stack[-1]          # top metal (m5 on gf180)
bot = tech.stack[-2]          # metal below top (m4 on gf180) -> underpass layer

W = 4.0                       # trace width (>= 4.0 um everywhere)
S = 4.0                       # turn spacing (>> any PDK min metal space)
P = W + S                     # centreline pitch between adjacent turns
D = 5.0                       # 45 deg chamfer length
G = 1.7                       # length growth per segment
L0 = 4.0                      # first segment length
SQRT2 = math.sqrt(2)

# ---- octagonal spiral centreline: 8 directions, 3 full turns (24 segments) ----
dirs = [(1, 0), (SQRT2 / 2, SQRT2 / 2), (0, 1), (-SQRT2 / 2, SQRT2 / 2),
        (-1, 0), (-SQRT2 / 2, -SQRT2 / 2), (0, -1), (SQRT2 / 2, -SQRT2 / 2)]
lengths = [L0]
for k in range(1, 24):
    lengths.append(lengths[-1] + G)

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for k in range(24):
    dx, dy = dirs[k % 8]
    x += dx * lengths[k]
    y += dy * lengths[k]
    pts.append((x, y))

c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")          # one open coil, all one net

# ---- inner end: via down at a point fully surrounded by metal, then underpass out ----
# start the path a little before the via so the via pad is enclosed by metal
pad = W / 2 + 0.6
inner = (-pad, 0.0)
sp2 = c.path(top, [(inner, pts[0])] + pts[1:], width=W, net="L")
v = c.via(bot, top, at=(0.0, 0.0), net="L")      # via sits in the middle of the first segment

# underpass on the metal below, runs left out of the coil footprint
minx = min(p[0] for p in pts)
ux = minx - 3.0
uy = 0.0
up = c.rect(bot, x0=ux, x1=v.lower.right, y0=v.lower.bottom - W / 2,
            y1=v.lower.top + W / 2, net="L")

# ---- ports: outer end of the coil, and the underpass end outside the coil ----
c.port("L", on=sp2, dir="out")
c.port("L", on=up, dir="out")

TOP = c

```