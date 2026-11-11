```python
from icdsl.canvas import *
import math

tech = use()
SQRT2 = math.sqrt(2)

# ------------------------------------------------------------------ layers
c0   = tech.c0                 # first conductor (device terminals land here)
top  = tech.stack[-1]          # top metal: the spiral
bot  = tech.stack[-2]          # metal below top: the underpass
# via between the two top metals
via_kind = None
for name in ("via%d" % (len(tech.stack) - 1),):
    pass
# find the cut between bot and top
cut = None
for v in tech.d.get("cuts", []):
    pass
# The PDK data describes cuts; we just ask for a via stack from bot to top:
# c.via(bot, top, ...) builds the correct cut stack automatically.

W = 4.0                        # trace width (>= 4.0 um everywhere)
SPACE = 6.0                    # edge-to-edge spacing between turns
PITCH = W + SPACE              # centreline pitch between turns

# ------------------------------------------------------------------ geometry
# Octagonal spiral centreline: directions E, NE, N, NW, W, SW, S, SE repeat.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

def spiral_points(n_turns=3, first=14.0):
    """Return centreline points of an octagonal spiral with constant pitch.

    Segment lengths grow so that the normal offset between turn m and m+1 is
    exactly PITCH: axial segments grow by 2*PITCH per turn, diagonal segments
    by 2*sqrt(2)*PITCH per turn (their axial projection is 2*PITCH).
    """
    pts = [(0.0, 0.0)]
    x = y = 0.0
    for k in range(8 * n_turns + 1):          # +1 so the last (outer) end is open
        m, d = divmod(k, 8)                   # turn m, direction d
        if d % 2 == 0:                        # axial segment
            L = first + 2 * m * PITCH
        else:                                 # diagonal segment
            L = first + 2 * m * PITCH * SQRT2
        dx, dy = DIRS[d]
        if d % 2 == 0:
            x += dx * L
            y += dy * L
        else:
            x += dx * L / SQRT2
            y += dy * L / SQRT2
        pts.append((x, y))
    return pts

pts = spiral_points(3)

# bounding box of the centreline
xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
minx, maxx = min(xs), max(xs)
miny, maxy = min(ys), max(ys)
Wd = maxx - minx + 2 * W + 2 * SPACE
Hd = maxy - miny + 2 * W + 2 * SPACE
print("spiral centreline bbox: x [%g,%g] y [%g,%g]" % (minx, maxx, miny, maxy))
print("estimated drawing bbox: %g x %g um = %g um^2" % (Wd, Hd, Wd * Hd))

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# top-metal spiral (open coil, one net "L")
c.path(top, pts, width=W, net="L")

inner = pts[0]          # inner end of the coil
outer = pts[-1]         # outer end of the coil (terminal 1)

# terminal 1: outer end of the spiral on top metal
c.port("L", on=c.rect(top, x0=outer[0] - W, x1=outer[0] + W,
                      y0=outer[1] - W, y1=outer[1] + W, net="L"), dir="out")

# ------------------------------------------------------------------ inner end: via down + underpass on metal below
# via pad on top metal must cover the inner end of the path; extend the path
# end slightly so the via pad overlaps metal.
pad = max(tech.width(top), 0.6)
ip = c.rect(top, x0=inner[0] - pad, x1=inner[0] + pad,
            y0=inner[1] - pad, y1=inner[1] + pad, net="L")

v = c.via(bot, top, at=inner, net="L")          # via + pads on bot and top

# underpass on the metal below: from the inner via straight out of the coil,
# then up to the outer end area where a second via brings it back to top metal.
# Route: from inner end go left past the coil, then up to the outer end's y,
# then right to just outside the outer end (clear of the outer turn).
ux = minx - SPACE - W                           # exit to the left of the coil
uy = inner[1]
ox = outer[0] + W + SPACE                       # stop clear of the outer turn
oy = outer[1]

under = c.path(bot, [(inner[0], uy), (ux, uy), (ux, oy), (ox, oy)],
               width=W, net="L")

# via back up to top metal at the outer end (terminal 2)
v2 = c.via(bot, top, at=(ox, oy), net="L")
c.port("L", on=c.rect(top, x0=ox - pad, x1=ox + pad,
                      y0=oy - pad, y1=oy + pad, net="L"), dir="out")

c.label("L", top, at=outer)
print("top cell:", c.name)
TOP = c
``````python
from icdsl.canvas import *
import math

tech = use()
SQRT2 = math.sqrt(2)

# ------------------------------------------------------------------ layers
c0   = tech.c0
top  = tech.stack[-1]          # top metal: the spiral
bot  = tech.stack[-2]          # metal below top: the underpass

# ------------------------------------------------------------------ parameters
W   = 4.0                      # trace width (>= 4.0 um everywhere)
SPACE = 6.0                    # edge-to-edge spacing between turns
PITCH = W + SPACE              # centreline pitch between turns

# ------------------------------------------------------------------ octagonal spiral centreline
# Directions E, NE, N, NW, W, SW, S, SE repeat.  Segment lengths grow so that
# the normal offset between turn m and m+1 is exactly PITCH: axial segments
# grow by 2*PITCH per turn, diagonal segments by 2*sqrt(2)*PITCH per turn
# (their axial projection is 2*PITCH).
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

def spiral_points(n_turns=3, first=14.0):
    pts = [(0.0, 0.0)]
    x = y = 0.0
    for k in range(8 * n_turns + 1):          # +1: last (outer) end stays open
        m, d = divmod(k, 8)
        if d % 2 == 0:
            L = first + 2 * m * PITCH
        else:
            L = first + 2 * m * PITCH * SQRT2
        dx, dy = DIRS[d]
        if d % 2 == 0:
            x += dx * L
            y += dy * L
        else:
            x += dx * L / SQRT2
            y += dy * L / SQRT2
        pts.append((x, y))
    return pts

pts = spiral_points(3)
xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
minx, maxx = min(xs), max(xs)
miny, maxy = min(ys), max(ys)
Wd = maxx - minx + 2 * W + 2 * SPACE
Hd = maxy - miny + 2 * W + 2 * SPACE
print("centreline bbox: x [%g,%g] y [%g,%g]" % (minx, maxx, miny, maxy))
print("drawing bbox: %g x %g um = %g um^2" % (Wd, Hd, Wd * Hd))

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# top-metal open coil, one net "L"
c.path(top, pts, width=W, net="L")

inner = pts[0]          # inner end of the coil
outer = pts[-1]         # outer end of the coil (terminal 1)

pad = max(tech.width(top), 0.6)

# terminal 1: outer end of the spiral on top metal
c.port("L", on=c.rect(top, x0=outer[0] - W, x1=outer[0] + W,
                      y0=outer[1] - W, y1=outer[1] + W, net="L"), dir="out")

# ------------------------------------------------------------------ inner end: via down + underpass on metal below
ip = c.rect(top, x0=inner[0] - pad, x1=inner[0] + pad,
            y0=inner[1] - pad, y1=inner[1] + pad, net="L")
v = c.via(bot, top, at=inner, net="L")          # via + pads on bot and top

# underpass on the metal below: inner via -> left past the coil -> up to the
# outer end area -> stop just outside the outer turn (clear of the top metal)
ux = minx - SPACE - W
uy = inner[1]
ox = outer[0] + W + SPACE
oy = outer[1]

c.path(bot, [(inner[0], uy), (ux, uy), (ux, oy), (ox, oy)],
       width=W, net="L")

# via back up to top metal at the outer end (terminal 2)
v2 = c.via(bot, top, at=(ox, oy), net="L")
c.port("L", on=c.rect(top, x0=ox - pad, x1=ox + pad,
                      y0=oy - pad, y1=oy + pad, net="L"), dir="out")

c.label("L", top, at=outer)
TOP = c
```