import math
from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]

w = 4.0                      # trace width everywhere
sp = tech.space(top)         # min spacing on the top metal
pitch = w + sp               # centre-line pitch between turns
n_turns = 4                  # full turns (>3 required)
n_seg = 8 * n_turns + 2      # segments: 8 per turn, plus lead-in and lead-out

c = Cell("spiral")

# ---- octagonal spiral centre-line (45 deg steps), growing outward ----
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(n_seg):
    dx, dy = dirs[k % 8]
    L = w + (k + 1) * pitch          # segment k+1 length
    x += dx * L
    y += dy * L
    pts.append((x, y))

# ---- top-metal spiral, one net "L" ----
c.path(top, pts, w, net="L")

# ---- inner end: via down to the metal below, underpass out of the coil ----
inner = pts[0]
outer = pts[-1]
dx, dy = dirs[0]
lead = (inner[0] - dx * w, inner[1] - dy * w)   # just inside the first bend
via = c.via(top, below, at=inner, net="L")
c.path(below, [inner, lead], w, net="L")        # underpass leaves the coil area

# ---- ports: outer end on top metal, underpass end on the metal below ----
c.port("L", on=c.rect(top, w=w, h=w, centre=outer, net="L"), dir="inout")
c.port("L", on=c.rect(below, w=w, h=w, centre=lead, net="L"), dir="inout")

TOP = c
