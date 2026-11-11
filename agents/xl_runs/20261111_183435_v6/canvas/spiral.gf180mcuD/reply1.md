```python
from icdsl.canvas import *
import math

tech = use()
stack = tech.stack
top = stack[-1]          # top metal
below = stack[-2]        # metal below top metal
cut = None
for name in ("via4", "via9", "via8", "via7", "via6", "via5", "via3", "via2", "via1"):
    if name in tech.d["layers"]:
        cut = name
        break

c = Cell("spiral")

# ---- geometry parameters (scaled to the PDK grid) ----
w = 4.0                  # trace width (>= 4.0 um everywhere)
gap = 2.0                # spacing between turns (>= min metal space)
p = w + gap              # centre-to-centre pitch
n_turns = 3              # full turns
n_seg = 8 * n_turns + 1  # segments: 8 per turn, last one ends at the inner via

# increment per segment so that the perpendicular gap between turn k and k+1 is `gap`
delta = p / (4.0 * (1.0 + math.sqrt(2.0)))

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0
for n in range(n_seg):
    l = w + n * delta
    dx, dy = dirs[n % 8]
    if dx and dy:
        x += dx * l / math.sqrt(2.0)
        y += dy * l / math.sqrt(2.0)
    else:
        x += dx * l
        y += dy * l
    pts.append((x, y))

inner = pts[-1]          # inner end of the top-metal trace
outer = pts[0]           # outer end (first segment start)

# ---- top-metal spiral (one net "L") ----
sp = c.path(top, pts, width=w, net="L", first="flush", last="flush")

# via from top metal down to the metal below at the inner end
v = c.via(below, top, at=inner, net="L", dir="h")

# underpass on the metal below: leaves the via towards the outside of the coil
ux, uy = inner
if abs(pts[-1][0] - pts[-2][0]) > abs(pts[-1][1] - pts[-2][1]):
    ux = inner[0] + (w + gap) * (1 if pts[-1][0] >= pts[-2][0] else -1)
else:
    uy = inner[1] + (w + gap) * (1 if pts[-1][1] >= pts[-2][1] else -1)

up = c.path(below, [inner, (ux, uy), (ux, uy + 6.0)], width=w, net="L",
            first="flush", last="flush")
c.via(below, top, at=inner, net="L")  # same via location, ensures the stack cut

# ---- ports: outer end of the spiral and the far end of the underpass ----
c.port("L", on=sp, dir="in")
c.port("L", on=up, dir="out")
c.label("L", top, at=sp)

TOP = c
```