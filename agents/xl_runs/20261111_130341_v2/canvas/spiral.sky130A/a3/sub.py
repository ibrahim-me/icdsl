from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.conductor(len(tech.stack) - 2)

# ------------------------------------------------------------------ geometry
W   = 4.5                        # trace width  (>= 4.0 um everywhere)
S0  = 1.6                        # first segment length
DS  = 0.90                       # per-segment growth
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
trace = c.path(top, cpts, width=W, net="L", ends="ext")

inner = cpts[0]
out   = cpts[-1]
maxx = max(p[0] for p in cpts)

# inner end: via down to the metal below, underpass runs out of the coil
c.via(below, top, at=inner, net="L")
ux, uy = inner
under = c.rect(below,
               x0=ux, x1=maxx + 3.0,
               y0=uy - W / 2, y1=uy + W / 2, net="L")
c.port("L", on=under, dir="out")

# outer end: pad on the top metal, port there
ox, oy = out
opad = c.rect(top,
              x0=ox - W / 2, x1=ox + W / 2,
              y0=oy - W / 2, y1=oy + W / 2, net="L")
c.port("L", on=opad, dir="out")

c.label("L", top, at=(maxx + 3.0, uy))

TOP = c
print("spiral bbox um: w=%.2f h=%.2f area=%.0f" % (c.w, c.h, c.w * c.h))
print("turns >= 3, width=%.1f um" % W)

