from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal: spiral trace
below = tech.stack[-2]        # metal below top: underpass layer

c = Cell("spiral")

w = 4.0                       # trace width (>= 4.0 um everywhere)
s = 2.0                       # gap between turns
p = w + s                     # centerline pitch
diag = p * (2 ** 0.5)         # 45-degree corner length (centerline)
d = p                         # x/y shift of a 45-degree corner
l = 2.0 * p                   # base straight length
turns = 3
segs = 8 * turns              # 8 segments per octagonal turn

# ------------------------------------------------------------------ spiral path
dirs = [(1, 0), (d, d), (0, 1), (-d, d), (-1, 0), (-d, -d), (0, -1), (d, -d)]
pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for k in range(segs):
    length = l + (k // 2) * p if k % 2 == 0 else diag
    dx, dy = dirs[k % 8]
    x += dx * length
    y += dy * length
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L")   # one continuous open coil
c.port("L", on=spiral, dir="out")             # outer end on top metal

# ------------------------------------------------------------------ inner end: via down + underpass out
vx, vy = p, 0.0                               # via in the middle of the first segment
v = c.via(below, top, at=(vx, vy), net="L", dir="h")
up = c.rect(below,
            x0=v.lower.right, y0=v.lower.bottom,
            x1=v.lower.right + 6.0 * p, y1=v.lower.top, net="L")
c.port("L", on=up, dir="out")                 # inner end brought out underneath

TOP = c

