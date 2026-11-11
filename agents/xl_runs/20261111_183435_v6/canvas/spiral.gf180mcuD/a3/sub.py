from icdsl.canvas import *
import math

tech = use()
stack = tech.stack
top = stack[-1]
below = stack[-2]

c = Cell("spiral")

w = 4.0          # trace width (>= 4.0 um everywhere)
gap = 2.0        # gap between turns
grid = tech.grid / 1000.0

def snap(v):
    return round(v / grid) * grid

n_turns = 3
n_seg = 8 * n_turns + 1
delta = (w + gap) / (4.0 * (1.0 + math.sqrt(2.0)))

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x, y = 0.0, 0.0

for n in range(n_seg):
    l = w + n * delta
    dx, dy = dirs[n % 8]
    if dx and dy:
        step = snap(l / math.sqrt(2.0))
        x = snap(x + dx * step)
        y = snap(y + dy * step)
    else:
        x = snap(x + dx * snap(l))
        y = snap(y + dy * snap(l))
    pts.append((x, y))

inner = pts[0]

# Top-metal octagonal spiral, one net "L"
sp = c.path(top, pts, width=w, net="L", ends="flush")

# Via from top metal down to the metal below at the inner end
c.via(below, top, at=inner, net="L")

# Underpass on the metal below: leaves the centre towards +x, outside the coil
ux = snap(inner[0] + 70.0)
uy = inner[1]
up = c.path(below, [inner, (ux, uy)], width=w, net="L", ends="flush")

# Ports: outer end of the spiral and far end of the underpass
c.port("L", on=sp, dir="in")
c.port("L", on=up, dir="out")
c.label("L", top, at=sp)

TOP = c

