from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
top = tech.stack[-1]          # top metal (m5 on sky130A)
below = tech.stack[-2]        # metal below top (m4 on sky130A)

W = 4.0                       # trace width (>= 4.0 um everywhere)
S = 2.0                       # space between turns (> 1.6 um DRC min)
P = W + S                     # centre-to-centre pitch = 6.0 um
SQRT2 = math.sqrt(2)
NSEG = 32                     # 4 octagonal turns (>= 3 full turns)

# ---- octagonal spiral centreline, every segment H, V or exactly 45 deg ----
# Diagonal segments use dx == dy exactly (grid value d). Axial segments use
# length L. Growth per segment g is chosen so the perpendicular spacing
# between adjacent turns equals the pitch P.
g = P / (2.0 * (1.0 + 1.0 / SQRT2))   # ~1.757 um per segment
d0 = 1.5                              # inner diagonal step (um)
L0 = d0 * SQRT2                       # matching inner axial length

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(NSEG):
    dx, dy = dirs[k % 8]
    a = d0 + k * g                    # size parameter for this segment
    if dx and dy:                     # diagonal: dx == dy exactly -> 45 deg
        step = a
    else:                             # axial: length chosen for equal pitch
        step = a * SQRT2
    x += dx * step
    y += dy * step
    pts.append((x, y))

# ---- top metal: one open spiral, net "L" ----
c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")

# inner end: via down to the metal below, underpass runs out from under the coil
inner = pts[0]
v = c.via(below, top, at=inner, net="L", dir="h")   # via4 (m4<->m5) on sky130A
up = c.rect(below,
            x0=inner[0] - 1.6, x1=inner[0] + 1.6,
            y0=v.lower.bottom, y1=v.lower.top, net="L")
under = c.rect(below,
               x0=inner[0] + 1.6,
               x1=inner[0] + 3.0 + P * (NSEG // 8 + 1),
               y0=v.lower.bottom, y1=v.lower.top, net="L")
c.via(below, top, at=(under.right, v.lower.cy), net="L", dir="h")

# outer end: short lead + pad outside the coil
lead = c.rect(top,
              x0=pts[-1][0], x1=pts[-1][0] + 3.0,
              y0=pts[-1][1] - W / 2, y1=pts[-1][1] + W / 2, net="L")
pad = c.rect(top,
             x0=lead.right, x1=lead.right + 6.0,
             y0=pts[-1][1] - W / 2, y1=pts[-1][1] + W / 2, net="L")

c.port("L", on=pad)
c.port("L", on=up)

TOP = c


