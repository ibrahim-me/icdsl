from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]

w = 4.0
sp = tech.space(top)
pitch = w + sp
n_turns = 3
n_seg = 8 * n_turns

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

c = Cell("spiral")

pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(n_seg):
    dx, dy = dirs[k % 8]
    L = w + (k // 4) * pitch
    x += dx * L
    y += dy * L
    pts.append((x, y))

c.path(top, pts, w, net="L")

inner = pts[0]
outer = pts[-1]
via = c.via(top, below, at=inner, net="L")
dx, dy = dirs[0]
lead = (inner[0] - dx * (w + sp), inner[1] - dy * (w + sp))
c.path(below, [inner, lead], w, net="L")

c.port("L", on=c.rect(top, w=w, h=w, cx=outer[0], cy=outer[1], net="L"), dir="inout")
c.port("L", on=c.rect(below, w=w, h=w, cx=lead[0], cy=lead[1], net="L"), dir="inout")

TOP = c
