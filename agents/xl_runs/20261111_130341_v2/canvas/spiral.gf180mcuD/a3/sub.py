from icdsl.canvas import *

tech = use()
c0 = tech.c0
stack = tech.stack
top = stack[-1]
below = stack[-2]
W = 4.0
space = tech.space(top)
pitch = W + space + 0.10
T = 3
c = Cell("spiral")

# ---------- octagonal spiral centerline, compact, uniform pitch ----------
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for i in range(8 * T):
    d = dirs[i % 8]
    seg = 2.0 + i * (pitch / 2.0)
    x += d[0] * seg
    y += d[1] * seg
    pts.append((x, y))
p0 = pts[0]
p1 = pts[-1]

# ---------- top-metal spiral ----------
c.path(top, pts, width=W, net="L")

# ---------- inner end: via down, underpass on metal below to outside ----------
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

