```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
stack = tech.stack
top = stack[-1]
below = stack[-2]          # metal below top (m4 for gf180)
W = 4.0                    # trace width (>= 4.0 um everywhere)
space = tech.space(top)
pitch = W + space + 0.4    # centerline pitch between adjacent turns
L0 = 5.0                   # first segment length
dL = pitch / 3.0           # length growth per segment -> ~pitch spacing per turn
T = 3                      # full turns
c = Cell("spiral")

# ---------- octagonal spiral centerline (H / V / 45 deg edges) ----------
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for i in range(8 * T):
    d = dirs[i % 8]
    seg = L0 + i * dL
    x += d[0] * seg
    y += d[1] * seg
    pts.append((x, y))
p0 = pts[0]                # inner end (centre)
p1 = pts[-1]               # outer end

# ---------- top-metal spiral ----------
c.path(top, pts, width=W, net="L")

# ---------- inner end: via4 down to metal below, underpass leaves the coil ----------
via_in = c.via(below, top, at=p0, net="L", dir="h")
pad = via_in.lower
xmax = max(p[0] for p in pts)
xout = xmax + 2 * pitch
c.rect(below, x0=pad.left, x1=xout, y0=pad.bottom, y1=pad.top, net="L")

# ---------- ports ----------
c.port("L", on=c.rect(top, x0=p1[0] - W / 2, x1=p1[0] + W / 2,
                      y0=p1[1] - W / 2, y1=p1[1] + W / 2, net="L"), dir="in")
c.port("L", on=c.rect(below, x0=xout - W / 2, x1=xout + W / 2,
                      y0=pad.bottom - W / 2, y1=pad.top + W / 2, net="L"), dir="out")

TOP = c
```