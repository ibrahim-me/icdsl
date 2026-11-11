```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.conductor(len(tech.stack) - 2)

# ------------------------------------------------------------------ geometry
W   = 4.5                        # trace width  (>= 4.0 um everywhere)
GAP = 4.0                        # edge-to-edge gap between turns
PIT = W + GAP                    # centre-to-centre pitch between turns
DS  = 0.90                       # per-segment growth  (>= PIT/9.66 for gap)
S0  = 1.6                        # first segment length
NSEG = 25                        # 3 full turns (24 seg) + 1 outer segment

DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(NSEG):
    s = S0 + k * DS
    dx, dy = DIRS[k % 8]
    x += dx * s
    y += dy * s
    pts.append((x, y))

xs = [p[0] for p in pts]
ys = [p[1] for p in pts]
cx = (min(xs) + max(xs)) / 2
cy = (min(ys) + max(ys)) / 2
cpts = [(px - cx, py - cy) for (px, py) in pts]

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# spiral trace on the top metal, one net "L"
c.path(top, cpts, width=W, net="L", ends="ext")

inner = cpts[0]
out   = cpts[-1]
cxs = [p[0] for p in cpts]
cys = [p[1] for p in cpts]
maxcx = max(cxs)

# inner end: via down to the metal below, underpass, via back up outside coil
c.via(top, below, at=inner, net="L")
ux, uy = inner
under = c.rect(below,
               x0=ux - 1.6, x1=ux + 1.6,
               y0=uy - 6.0, y1=uy + 6.0, net="L")
c.via(below, top, at=(under.right + 0.6, uy), net="L")

# outer end: via down, short jog on metal below, via up outside the coil
c.via(top, below, at=out, net="L")
ox, oy = out
c.rect(below,
       x0=ox - 1.6, x1=ox + 1.6,
       y0=oy - 1.6, y1=oy + 1.6, net="L")
c.rect(below,
       x0=ox + 1.6, x1=maxcx + 2.0,
       y0=oy - 1.6, y1=oy + 1.6, net="L")
c.via(below, top, at=(maxcx + 1.4, oy), net="L")
c.rect(top,
       x0=maxcx + 0.6, x1=maxcx + 2.2,
       y0=oy - 1.6, y1=oy + 1.6, net="L")

c.port("L", on=under, dir="out")
c.label("L", top, at=(maxcx + 1.4, oy))

TOP = c
print("spiral bbox um: w=%.2f h=%.2f area=%.0f" % (c.w, c.h, c.w * c.h))
print("turns >= 3, width=%.1f um, gap=%.1f um" % (W, GAP))
```