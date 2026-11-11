```python
from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
stack = tech.stack
top = stack[-1]
below = stack[-2]
W = 4.0                      # trace width (>= 4.0 um everywhere)
space = tech.space(top)
pitch = W + space + 0.05     # centerline pitch between adjacent turns
T = 3                        # full turns
c = Cell("spiral")

# ---------- octagonal spiral centerline (H / V / 45 deg edges) ----------
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for i in range(8 * T + 1):
    d = dirs[i % 8]
    k = i // 8
    seg = W + (k + 1) * pitch          # segment grows by one pitch per turn
    x += d[0] * seg
    y += d[1] * seg
    pts.append((x, y))
p0, p1 = pts[0], pts[-1]

# ---------- top-metal spiral ----------
c.path(top, pts, width=W, net="L")

# ---------- inner end: via down, underpass on metal below, via up outside ----------
mid = len(pts) // 2
pin = pts[mid]
pout = (pts[-1][0] + pitch, pts[-1][1])
via_in = c.via(c0, below, at=pin, net="L", dir="h")
via_out = c.via(c0, below, at=pout, net="L", dir="h")
c.rect(below, x0=via_in.lower.left, x1=via_out.lower.right,
       y0=min(via_in.lower.bottom, via_out.lower.bottom),
       y1=max(via_in.lower.top, via_out.lower.top), net="L")

# ---------- outer end lead ----------
c.rect(top, x0=p1[0], y0=p1[1] - W / 2, x1=p1[0] + pitch, y1=p1[1] + W / 2, net="L")

# ---------- ports ----------
c.port("L", on=c.rect(top, x0=p0[0] - W / 2, x1=p0[0] + W / 2,
                      y0=p0[1] - W / 2, y1=p0[1] + W / 2, net="L"), dir="in")
c.port("L", on=c.rect(top, x0=pout[0] - W / 2, x1=pout[0] + W / 2,
                      y0=pout[1] - W / 2, y1=pout[1] + W / 2, net="L"), dir="out")

TOP = c
```