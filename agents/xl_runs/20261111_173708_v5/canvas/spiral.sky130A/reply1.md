```python
from icdsl.canvas import *
import math

tech = use()
c0, c1 = tech.c0, tech.c1
top = tech.stack[-1]
penult = tech.stack[-2]

# ---------- PDK parameters ----------
w = 4.0                      # trace width (>= 4.0 um)
s = 4.0                      # trace-to-trace spacing (conservative vs DRC)
p = w + s                    # centerline pitch
d = p * math.sqrt(2)         # 45-deg segment length (projection p in x and y)
via_w = tech.width(tech.via_layer(c0, c1)) if hasattr(tech, "via_layer") else 0.17
# via size for the cut between c0 and c1
try:
    vsize = tech.width(c0)   # fallback
except Exception:
    vsize = 0.17
# find the cut layer between c0 and c1
cut = None
for name in ("mcon", "via", "via2", "via3", "via4", "contact"):
    if name in tech.d.get("layers", {}):
        pass
# use the stack: cut between c0 and c1 is the via named after c1 in most PDKs
cut = tech.conductor(1) if False else None
# Determine via stack layers from tech data
stack = tech.stack
i0 = stack.index(c0)
i1 = stack.index(c1)
cut_layer = None
for lname, ldata in tech.d.get("layers", {}).items():
    pass
# Simpler: via(c0, c1) uses the correct cut automatically via the PDK recipe.

# ---------- Spiral centerline (octagonal, inner -> outer) ----------
# Directions cycle: E, NE, N, NW, W, SW, S, SE.  Diagonal segments have
# x/y projection = p so consecutive turns are spaced by pitch p.
a0 = 2.0                     # innermost straight segment length
a1 = a0 + 2 * p              # N segment of turn 0
seg = [
    ("E", a0), ("NE", d), ("N", a1), ("NW", d),
    ("W", a0 + 2 * p), ("SW", d), ("S", a1 + p), ("SE", d),
    ("E", a0 + 4 * p), ("NE", d), ("N", a1 + 2 * p), ("NW", d),
    ("W", a0 + 6 * p), ("SW", d), ("S", a1 + 3 * p), ("SE", d),
    ("E", a0 + 8 * p), ("NE", d), ("N", a1 + 4 * p),
]
# 3 full turns (24 dir-steps) end heading E; we stop after the N of turn 3
# so the outer end is on the top side, ready to exit.

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for direc, length in seg:
    if direc == "E":
        x += length
    elif direc == "W":
        x -= length
    elif direc == "N":
        y += length
    elif direc == "S":
        y -= length
    elif direc == "NE":
        x += p; y += p
    elif direc == "NW":
        x -= p; y += p
    elif direc == "SW":
        x -= p; y -= p
    elif direc == "SE":
        x += p; y -= p
    pts.append((x, y))

# ---------- Build cell ----------
c = Cell("spiral")

# Spiral trace on top metal, one net "L"
sp = c.path(top, pts, width=w, net="L")

# Outer end: extend a short straight segment to the right to reach the outside
ox, oy = pts[-1]
ext = c.rect(top, x0=ox, x1=ox + 6.0, y0=oy - w / 2, y1=oy + w / 2, net="L")

# Inner end: via down to c1 at the center, underpass on c1 runs out from under
# the coil to the left side (outside the outer turns).
ix, iy = pts[0]
v = c.via(c0, c1, at=(ix, iy), net="L", dir="h")
up = c.rect(c1, x0=ix - 40.0, x1=ix - vsize / 2 - 0.2, y0=iy - w / 2,
            y1=iy + w / 2, net="L")
# connect underpass to the via (overlap on c1)
c.rect(c1, x0=ix - vsize / 2 - 0.2, x1=ix + vsize / 2 + 0.2,
       y0=iy - w / 2, y1=iy + w / 2, net="L")

# Port on the outer end (top metal)
c.port("L", on=ext, dir="out")

TOP = c
``````python
from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
c1 = tech.c1
top = tech.stack[-1]

w = 4.0          # trace width (>= 4.0 um)
s = 4.0          # trace-to-trace spacing (conservative vs DRC)
p = w + s        # centerline pitch
d = p * math.sqrt(2.0)   # 45-deg segment length (projection p in x and y)

# Octagonal spiral centerline, inner -> outer.
# Directions cycle E,NE,N,NW,W,SW,S,SE; diagonals move (p,p) so turns nest
# with pitch p. 3 full turns (24 dir-steps) end heading E; we stop after the
# N of turn 3 so the outer end is on the top side.
a0 = 2.0
a1 = a0 + 2 * p
seg = [
    ("E", a0), ("NE", d), ("N", a1), ("NW", d),
    ("W", a0 + 2 * p), ("SW", d), ("S", a1 + p), ("SE", d),
    ("E", a0 + 4 * p), ("NE", d), ("N", a1 + 2 * p), ("NW", d),
    ("W", a0 + 6 * p), ("SW", d), ("S", a1 + 3 * p), ("SE", d),
    ("E", a0 + 8 * p), ("NE", d), ("N", a1 + 4 * p),
]
pts = [(0.0, 0.0)]
x = y = 0.0
for direc, length in seg:
    if direc == "E":   x += length
    elif direc == "W": x -= length
    elif direc == "N": y += length
    elif direc == "S": y -= length
    elif direc == "NE": x += p; y += p
    elif direc == "NW": x -= p; y += p
    elif direc == "SW": x -= p; y -= p
    elif direc == "SE": x += p; y -= p
    pts.append((x, y))

c = Cell("spiral")

# Spiral trace on top metal, single net "L"
sp = c.path(top, pts, width=w, net="L")

# Outer end: short straight extension to the right, reaching outside the coil
ox, oy = pts[-1]
ext = c.rect(top, x0=ox, x1=ox + 6.0, y0=oy - w / 2, y1=oy + w / 2, net="L")

# Inner end: via down to c1 at the center, underpass on c1 runs left from under
# the coil to outside the outer turns.
ix, iy = pts[0]
v = c.via(c0, c1, at=(ix, iy), net="L", dir="h")
vs = tech.width(c0)  # via pad size on c1 (approx); overlap is what matters
c.rect(c1, x0=ix - 44.0, x1=ix + vs / 2 + 0.2,
       y0=iy - w / 2, y1=iy + w / 2, net="L")

c.port("L", on=ext, dir="out")

TOP = c
```