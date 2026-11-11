from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]
cut = None
for name in ("via9", "via8", "via7", "via6", "via5", "via4", "via3", "via2", "via1", "contact"):
    if name in tech.d["layers"]:
        cut = name
        break

w = 4.0
s = tech.space(top, width=w)
p = w + s
n_turns = 3
margin = 3.0

# Octagonal spiral centreline: directions rotate 45 deg CCW each segment,
# segment length grows linearly so each turn sits outside the previous one.
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
nseg = 8 * n_turns
L0 = 2.0
g = p                      # length growth per segment
pts = [(0.0, 0.0)]
x = y = 0.0
for i in range(nseg):
    dx, dy = dirs[i % 8]
    seg = L0 + i * g
    if dx and dy:          # 45-degree diagonal: axis projection = seg / sqrt(2)
        t = seg / math.sqrt(2)
        x += dx * t
        y += dy * t
    else:
        x += dx * seg
        y += dy * seg
    pts.append((x, y))

xs = [q[0] for q in pts]
ys = [q[1] for q in pts]
ox = -min(xs) + margin
oy = -min(ys) + margin
pts = [(q[0] + ox, q[1] + oy) for q in pts]

c = Cell("spiral")
tr = c.path(top, pts, width=w, net="L")

inner = pts[0]
outer = pts[-1]
v_in = c.via(c0, below, at=inner, net="L")
v_out = c.via(c0, below, at=outer, net="L")

xmin = min(q[0] for q in pts) - w / 2 - margin
xmax = max(q[0] for q in pts) + w / 2 + margin
ymin = min(q[1] for q in pts) - w / 2 - margin
ymax = max(q[1] for q in pts) + w / 2 + margin
up = c.rect(below, x0=xmin, x1=xmax, y0=ymin, y1=ymax, net="L")

c.port("L", on=tr)
c.port("L", on=up)

TOP = c

