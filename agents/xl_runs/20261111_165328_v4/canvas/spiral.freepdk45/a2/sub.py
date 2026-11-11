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
# Segment k length = first + 2*P*floor(k/2); axial segments keep full length,
# diagonal segments are scaled by 1/sqrt(2) so their axial projection matches,
# which keeps the normal pitch between turns equal to P and never closes.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1),
        (-1, 0), (-1, -1), (0, -1), (1, -1)]

def spiral_points(n_turns=3, first=6.0):
    pts = [(0.0, 0.0)]
    x = y = 0.0
    nseg = 8 * n_turns + 1          # +1 leaves the outer end open
    for k in range(nseg):
        m, d = divmod(k, 8)
        L = first + 2.0 * P * (k // 2)
        dx, dy = DIRS[d]
        if d % 2 == 0:              # axial
            x += dx * L
            y += dy * L
        else:                       # diagonal (45 deg)
            x += dx * L / SQRT2
            y += dy * L / SQRT2
        pts.append((x, y))
    return pts

pts = spiral_points(3)

xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
minx, maxx = min(xs), max(xs)
miny, maxy = min(ys), max(ys)
print("centreline bbox: x [%g,%g] y [%g,%g]" % (minx, maxx, miny, maxy))

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# top-metal spiral (open coil, one net "L")
c.path(top, pts, width=W, net="L")

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
# Exit perpendicular to the first segment (first segment is +E, so exit -Y).
ux = inner[0]
uy = inner[1] - PIT - W                          # clear of the innermost turn
# go left past the whole coil, then up past it, then right to the outer end
lx = minx - PIT - W
ly = maxy + PIT + W
ox = outer[0] + PIT + W                          # stop clear of the outer turn
oy = outer[1]

under = c.path(bot, [(inner[0], uy), (lx, uy), (lx, ly), (ox, ly), (ox, oy)],
               width=W, net="L")

v2 = c.via(bot, top, at=(ox, oy), net="L")       # via back up to top metal
c.port("L", on=c.rect(top, x0=ox - pad, x1=ox + pad,
                      y0=oy - pad, y1=oy + pad, net="L"), dir="out")

c.label("L", top, at=outer)
print("top cell:", c.name)
TOP = c

