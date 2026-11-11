```
from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal: spiral trace
below = tech.stack[-2]        # metal below top: underpass layer

c = Cell("spiral")

w = 4.0                       # trace width (>= 4.0 um everywhere)
spacing = tech.space(top, width=w)   # width-dependent spacing for top metal
miter = 0.42 * w              # extra gap for 45-degree corner miters
gap = max(spacing, 1.5) + miter      # edge-to-edge gap between turns
p = w + gap                   # centerline pitch

# ------------------------------------------------------------------ spiral path
# Octagonal spiral, 3 full turns, starting from the centre.
# Each turn is 8 segments: Manhattan leg, 45-degree corner, repeated.
# Leg lengths grow by 2p every two segments so consecutive turns stay
# exactly one pitch apart (edge gap = gap everywhere, including corners).
segs = []
a = 2.0 * p                   # inner leg length
for t in range(3):            # 3 turns
    off = 4 * t * p
    segs += [("E", a + off), ("NE", p), ("N", a + 2 * p + off),
             ("NW", p), ("W", a + 4 * p + off), ("SW", p),
             ("S", a + 4 * p + off), ("SE", p)]

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for d, val in segs:
    if d == "E":   x += val
    elif d == "N": y += val
    elif d == "W": x -= val
    elif d == "S": y -= val
    elif d == "NE": x += val; y += val
    elif d == "NW": x -= val; y += val
    elif d == "SW": x -= val; y -= val
    elif d == "SE": x += val; y -= val
    pts.append((x, y))

spiral = c.path(top, pts, width=w, net="L")   # one continuous open coil
c.port("L", on=spiral, dir="out")             # outer end on top metal

# ------------------------------------------------------------------ inner end: via down + underpass out
# via placed at the start of the first leg (inner end), underpass runs
# out from under the coil on the metal below.
v = c.via(below, top, at=(p / 2, 0.0), net="L", dir="h")
up = c.rect(below,
            x0=v.lower.right, y0=v.lower.bottom,
            x1=v.lower.right + 6.0 * p, y1=v.lower.top, net="L")
c.port("L", on=up, dir="out")                 # inner end brought out underneath

TOP = c



```