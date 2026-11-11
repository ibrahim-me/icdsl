from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0                     # first conductor (li / m1 / m1)
top = tech.stack[-1]             # top metal (m5 / m5 / m5)
below = tech.conductor(len(tech.stack) - 2)   # metal below top (m4 / m4 / m4)

# ------------------------------------------------------------------ geometry
W   = 4.5                        # trace width  (>= 4.0 um everywhere)
GAP = 4.0                        # edge-to-edge gap between turns
PIT = W + GAP                    # centre-to-centre pitch between turns
DS  = PIT / 12.0                 # per-segment growth (gives >= PIT on all 8 dirs)
S0  = 1.6                        # first segment coordinate-delta
NSEG = 25                        # 3 full turns = 24 segments + 1 (outer end)

# octagonal spiral: directions E, NE, N, NW, W, SW, S, SE repeating
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
minx, maxx = min(xs), max(xs)
miny, maxy = min(ys), max(ys)
cx = (minx + maxx) / 2
cy = (miny + maxy) / 2

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# spiral trace on the top metal, one net "L"
c.path(top, pts, width=W, net="L", first="ext", last="ext")

# inner end: via down to the metal below, short underpass, via back up
inner = pts[0]
pad = c.via(c0, below, at=inner, net="L")
under = c.rect(below,
               x0=inner.x - 1.6, x1=inner.x + 1.6,
               y0=inner.y - 6.0, y1=inner.y + 6.0, net="L")
pad2 = c.via(c0, below, at=(under.right + 0.6, inner.y), net="L")

# outer end: route out on the metal below, then via up outside the coil
out = pts[-1]
c.via(top, below, at=out, net="L")
c.rect(below,
       x0=out.x - 1.6, x1=out.x + 1.6,
       y0=out.y - 1.6, y1=out.y + 1.6, net="L")
c.rect(below,
       x0=out.x + 1.6, x1=maxx + 2.0,
       y0=out.y - 1.6, y1=out.y + 1.6, net="L")
c.via(below, top, at=(maxx + 1.4, out.y), net="L")
c.rect(top,
       x0=maxx + 0.6, x1=maxx + 2.2,
       y0=out.y - 1.6, y1=out.y + 1.6, net="L")

# bring everything to a common origin and add ports / label
dx0, dy0 = -cx, -cy
c.translate(dx0, dy0)

c.port("L", on=under, dir="out")
c.label("L", top, at=(maxx + 1.4 + dx0, out.y + dy0))

TOP = c
print("spiral bbox um: w=%.2f h=%.2f area=%.0f" % (
    c.w, c.h, c.w * c.h))
print("turns >= 3, width=%.1f um, gap=%.1f um" % (W, GAP))
