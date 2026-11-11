from icdsl.canvas import *
import math

tech = use()
SQRT2 = math.sqrt(2.0)

c0   = tech.c0
top  = tech.stack[-1]
bot  = tech.stack[-2]

W   = 4.0          # trace width (>= 4.0 um everywhere)
PIT = 6.0          # edge-to-edge spacing between turns
P   = W + PIT      # centreline pitch between turns

# ------------------------------------------------------------------ geometry
# Octagonal spiral centreline. Directions cycle E, NE, N, NW, W, SW, S, SE.
# Axial projection of segment k: A_k = first + k*(P/12).  This makes the
# centreline of turn m+1 exactly the centreline of turn m offset by P, so
# edge-to-edge spacing between turns is PIT everywhere and the coil never
# pinches.  Diagonal segments use equal x/y increments so they stay exactly
# 45 deg.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1),
        (-1, 0), (-1, -1), (0, -1), (1, -1)]

def spiral_points(n_turns=3, first=6.0):
    delta = P / 12.0
    pts = [(0.0, 0.0)]
    x = y = 0.0
    nseg = 8 * n_turns + 1          # +1 leaves the outer end open
    for k in range(nseg):
        d = k % 8
        A = first + k * delta       # axial projection of this segment
        dx, dy = DIRS[d]
        if d % 2 == 0:              # axial
            x += dx * A
            y += dy * A
        else:                       # diagonal at 45 deg
            x += dx * A
            y += dy * A
        pts.append((x, y))
    return pts

pts = spiral_points(3)

xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
minx, maxx = min(xs), max(xs)
miny, maxy = min(ys), max(ys)
print("centreline bbox: x [%g,%g] y [%g,%g]" % (minx, maxx, miny, maxy))

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# Draw the spiral one segment at a time (no path joins -> no off-angle edges).
# Consecutive segments overlap by W so the inside corners are fully filled.
OV = W
for k in range(len(pts) - 1):
    p0 = pts[k]
    p1 = pts[k+1]
    dx = p1[0] - p0[0]
    dy = p1[1] - p0[1]
    if dx == 0.0:                       # vertical
        c.rect(top,
               x0=p0[0] - W/2, x1=p0[0] + W/2,
               y0=min(p0[1], p1[1]) - OV, y1=max(p0[1], p1[1]) + OV,
               net="L")
    elif dy == 0.0:                     # horizontal
        c.rect(top,
               x0=min(p0[0], p1[0]) - OV, x1=max(p0[0], p1[0]) + OV,
               y0=p0[1] - W/2, y1=p0[1] + W/2,
               net="L")
    else:                               # diagonal at exactly 45 deg
        c.path(top, [p0, p1], width=W, net="L", first="ext", last="ext")

inner = pts[0]          # inner end of the coil
outer = pts[-1]         # outer end of the coil (terminal 1)

pad = max(tech.width(top), 0.6)

# terminal 1: outer end of the spiral on top metal
c.port("L", on=c.rect(top, x0=outer[0] - pad, x1=outer[0] + pad,
                      y0=outer[1] - pad, y1=outer[1] + pad, net="L"), dir="out")

# ------------------------------------------------------------------ inner end: via down + underpass on metal below
ip = c.rect(top, x0=inner[0] - pad, x1=inner[0] + pad,
            y0=inner[1] - pad, y1=inner[1] + pad, net="L")
v  = c.via(bot, top, at=inner, net="L")          # via + pads on bot and top

# underpass on the metal below: leave the inner end to the side of the coil,
# run clear of all turns, then come back up near the outer end (terminal 2).
# First segment is +E, so exit sideways (-Y) from the inner end.
ux = inner[0]
uy = inner[1] - PIT - W                          # clear of the innermost turn
lx = minx - PIT - W                              # left of the whole coil
ly = maxy + PIT + W                              # above the whole coil
ox = outer[0] + PIT + W                          # right of the outer turn, clear of it
oy = outer[1]

under = c.path(bot, [(inner[0], uy), (lx, uy), (lx, ly), (ox, ly), (ox, oy)],
               width=W, net="L")

v2 = c.via(bot, top, at=(ox, oy), net="L")       # via back up to top metal
c.port("L", on=c.rect(top, x0=ox - pad, x1=ox + pad,
                      y0=oy - pad, y1=oy + pad, net="L"), dir="out")

c.label("L", top, at=outer)
print("top cell:", c.name)
TOP = c



