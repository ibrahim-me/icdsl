from icdsl.canvas import *
import math

tech = use()
top = tech.stack[-1]          # top metal
below = tech.stack[-2]        # metal under the top metal (underpass layer)

w = 4.0                       # trace width (>= 4.0 um everywhere)
s = tech.space(top)           # minimum spacing on the top metal
pitch = w + s                 # centre-to-centre pitch between turns

c = Cell("spiral")

# ---- octagonal spiral centreline (rectangular spiral with mitered 45 deg corners) ----
dirs = [(1, 0), (0, 1), (-1, 0), (0, -1)]   # E, N, W, S  (counter-clockwise)
L0 = 6.0
nseg = 12                                   # 3 full turns
pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(nseg):
    L = L0 + 2.0 * pitch * (k // 2)
    dx, dy = dirs[k % 4]
    x += dx * L
    y += dy * L
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L")   # one continuous open coil

# ---- inner end: via down to the underpass metal ----
inner = pts[0]
v = c.via(below, top, at=inner, net="L", dir="h")

# ---- underpass on the metal below, runs from the via out beyond the coil ----
xs = [p[0] for p in pts]
ys = [p[1] for p in pts]
margin = 2.0 * pitch
ux1 = inner[0]
ux2 = max(xs) + margin
uy1 = inner[1] - 0.5 * w
uy2 = inner[1] + 0.5 * w
under = c.rect(below, x0=ux1, x1=ux2, y0=uy1, y1=uy2, net="L")

# ---- ports / labels: both ends of the inductor are net "L" ----
c.port("L", on=spiral)                      # outer end on top metal
c.port("L", on=under)                       # inner end brought out on the metal below

TOP = c
