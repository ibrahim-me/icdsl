```
from icdsl.canvas import *
import math

tech = use()
top_metal = tech.stack[-1]
low_metal = tech.stack[-2]
c0 = tech.c0

SQRT2 = math.sqrt(2)

# ------------------------------------------------------------------ geometry
w = 4.0                      # trace width (>= 4.0 um everywhere)
space = max(tech.space(top_metal, width=w), 2.0)
pitch = w + space
c = 1.0                      # chamfer (axial projection of each 45 deg corner)
A0 = 44.0                    # outer right-side / top-side coordinate
n_turns = 4                  # full turns (>= 3)

# centreline vertices of the octagonal spiral (H / V / 45 deg only)
pts = [(A0, -(A0 - c))]
x, y = A0, -(A0 - c)
for k in range(n_turns):
    A = A0 - k * pitch
    L = 2.0 * (A - c)
    pts.append((x, y + L)); y += L                      # N
    pts.append((x - c, y + c)); x -= c; y += c          # NW
    pts.append((x - L, y)); x -= L                      # W
    pts.append((x - c, y - c)); x -= c; y -= c          # SW
    pts.append((x, y - L)); y -= L                      # S
    pts.append((x + c, y - c)); x += c; y -= c          # SE
    pts.append((x + L, y)); x += L                      # E
    pts.append((x + c, y + c)); x += c; y += c          # NE (to next inner side)

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# spiral trace on the top metal, one net "L"
tr = c.path(top_metal, pts, width=w, net="L")

# inner end: via down to the metal below, underpass underneath the coil,
# via back up outside the coil, short top-metal lead to an outer pad
ix, iy = pts[-1]
v1 = c.via(c0, low_metal, at=(ix, iy), net="L", dir="v")
under = c.rect(low_metal,
               x0=ix - w / 2, x1=ix + w / 2,
               y0=iy - 30.0, y1=iy + w / 2, net="L")
ux, uy = under.left - 2.0, under.cy
v2 = c.via(c0, low_metal, at=(ux, uy), net="L", dir="v")
lead = c.rect(top_metal,
              x0=v2.lower.left - 6.0, x1=v2.lower.right + 6.0,
              y0=v2.lower.bottom, y1=v2.lower.top, net="L")
pad = c.rect(top_metal,
             x0=lead.left - 6.0, x1=lead.right + 6.0,
             y0=lead.bottom - 6.0, y1=lead.top + 6.0, net="L")

# outer end: pad on the top metal at the start of the spiral
ox, oy = pts[0]
opad = c.rect(top_metal,
              x0=ox - 6.0, x1=ox + 6.0,
              y0=oy - 6.0, y1=oy + 6.0, net="L")

c.port("L", on=pad)
c.port("L", on=opad)

TOP = c

```