```
from icdsl.canvas import *

tech = use()
top_metal = tech.stack[-1]   # m5 for gf180mcuD
under_metal = tech.stack[-2] # m4 for gf180mcuD

w = 6.0                      # trace width (perp. width; horizontal width on 45 deg = w/sqrt2 = 4.24 >= 4.0)
g = 0.6                      # gap between turns (>= m5 min space 0.46)
p = w + g
n_turns = 3.0
n_seg = int(8 * n_turns)     # 24 segments = 3 full turns

# 8 octagonal directions; diagonal steps use dx == dy so edges are exactly 45 deg
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

steps = []
s = w
for k in range(n_seg):
    steps.append(s)
    s += p * 0.5

pts = [(0.0, 0.0)]
for k in range(n_seg):
    dx, dy = dirs[k % 8]
    step = steps[k]
    x, y = pts[-1]
    pts.append((x + dx * step, y + dy * step))

# centre the spiral on the origin
xs = [q[0] for q in pts]
ys = [q[1] for q in pts]
cx = (min(xs) + max(xs)) / 2.0
cy = (min(ys) + max(ys)) / 2.0
pts = [(x - cx, y - cy) for x, y in pts]

inner = pts[0]
max_x = max(q[0] for q in pts)

c = Cell("spiral")

# spiral on top metal, one net "L", flush ends (no curved / non-45 edges)
sp = c.path(top_metal, pts, w, net="L", ends="flush")

# via down from the coil (top metal) to the metal below, placed on the trace near the inner end
v_in = c.via(under_metal, top_metal, at=inner, net="L")

# underpass on the metal below: runs from under the coil out past the coil edge in +x
under_len = max_x - inner[0] + 6.0
under_y = inner[1]
under_x0 = inner[0]
under_x1 = inner[0] + under_len
up = c.rect(under_metal, x0=under_x0, x1=under_x1,
            y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

# via back up to top metal at the exit of the underpass, plus a short stub for a port
v_out = c.via(under_metal, top_metal, at=(under_x1, under_y), net="L")
stub = c.rect(top_metal, x0=under_x1, x1=under_x1 + w,
              y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

c.port("L", on=sp, dir="in")
c.port("L", on=stub, dir="out")

TOP = c

```