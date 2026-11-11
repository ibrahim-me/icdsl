from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]          # top metal of the stack
below = tech.stack[-2]        # metal below top (underpass layer)

W = 4.0                       # trace width (>= 4.0 um everywhere)
P = 8.0                       # centre-to-centre arm pitch (space = 4.0 um >= DRC min)
NSEG = 28                     # 3.5 octagonal turns (>= 3 full turns)
SQRT2 = 2.0 ** 0.5

# ---- octagonal spiral centreline, built from the centre outwards ----
dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(NSEG):
    dx, dy = dirs[k % 8]
    diag = (dx != 0 and dy != 0)
    L = W + k * P if diag else W + k * P * SQRT2
    x += dx * (L / SQRT2 if diag else L)
    y += dy * (L / SQRT2 if diag else L)
    pts.append((x, y))

# ---- top metal: one open spiral, net "L" ----
c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")

# inner end: via down to the metal below, then an underpass out of the coil
inner = pts[0]
v = c.via(c0, below, at=inner, net="L", dir="h")
up = c.rect(below,
            x0=inner[0] - 1.6, x1=inner[0] + 1.6,
            y0=v.lower.bottom, y1=v.lower.top, net="L")
under = c.rect(below,
               x0=inner[0] + 1.6, x1=inner[0] + 3.0 + P * (NSEG // 8 + 1),
               y0=v.lower.bottom, y1=v.lower.top, net="L")
c.via(below, top, at=(under.right, v.lower.cy), net="L", dir="h")

# outer end: short lead to a pad outside the coil
lead = c.rect(top,
              x0=pts[-1][0], x1=pts[-1][0] + 3.0,
              y0=pts[-1][1] - W / 2, y1=pts[-1][1] + W / 2, net="L")
pad = c.rect(top,
             x0=lead.right, x1=lead.right + 6.0,
             y0=pts[-1][1] - W / 2, y1=pts[-1][1] + W / 2, net="L")

c.port("L", on=pad)
c.port("L", on=up)

TOP = c
