from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal (spiral trace)
below = tech.stack[-2]        # metal below top (underpass layer)
c0 = tech.c0                  # first conductor (via stack)

w = 4.0                       # trace width (>= 4.0 um everywhere)
s = 2.0                       # gap between turns (>= min metal space)
p = w + s                     # centerline pitch
c = p * (2 ** 0.5)            # 45-degree corner length (centerline)
d = p                         # x/y shift of a 45-degree corner (c/sqrt(2))
l = 2.0 * p                   # base straight length
turns = 3                     # full turns
segs = 8 * turns              # 8 segments per octagonal turn

# ------------------------------------------------------------------ spiral path
dirs = [(1, 0), (d, d), (0, 1), (-d, d), (-1, 0), (-d, -d), (0, -1), (d, -d)]
pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for k in range(segs):
    length = l + (k // 2) * p if k % 2 == 0 else c
    dx, dy = dirs[k % 8]
    x += dx * length
    y += dy * length
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L")   # one continuous open coil
c.port("L", on=spiral, dir="out")             # outer end on top metal

# ------------------------------------------------------------------ inner end underpass
ix, iy = pts[0]                               # inner end (centre)
bar = c.rect(top, x0=ix, y0=iy - w / 2, x1=ix + 2.0 * p, y1=iy + w / 2, net="L")
vx, vy = bar.right, bar.cy
via = c.via(c0, below, at=(vx, vy), net="L", dir="h")   # via down to underpass layer
up = c.rect(below,
            x0=via.lower.right, y0=via.lower.bottom,
            x1=via.lower.right + 6.0 * p, y1=via.lower.top, net="L")
c.port("L", on=up, dir="out")                 # inner end brought out underneath

TOP = c
