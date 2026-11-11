from icdsl.canvas import *
import math

tech = use()
top_metal = tech.stack[-1]   # m10 on freepdk45
low_metal = tech.stack[-2]   # m9
c0 = tech.c0                 # contact (diff/poly -> m1)

# ------------------------------------------------------------------ geometry
w = 4.0                      # trace width (>= 4.0 um everywhere)
space = max(tech.space(top_metal, width=w), 2.0)
pitch = w + space            # centre-to-centre pitch between turns
c = 1.0                      # chamfer (axial projection of each 45 deg corner)
A0 = 30.0                    # outer half-size (keeps the coil inside the area budget)
n_turns = 4                  # full turns (>= 3)

# centreline of an octagonal spiral, walking counter-clockwise inward.
# Each turn: N, 45(NW), W, 45(SW), S, 45(SE), E  (7 sides), then a Manhattan
# step-in to the next smaller octagon.  The last turn ends at its bottom-right
# corner where the inner via lands.  Some edges are 45 deg (the chamfers).
pts = []
x, y = A0, -(A0 - c)         # start: outer octagon, right side, bottom
pts.append((x, y))
A = A0
for k in range(n_turns):
    pts.append((x, y + 2 * (A - c))); y += 2 * (A - c)          # N
    pts.append((x - c, y + c)); x -= c; y += c                   # 45 NW
    pts.append((x - 2 * (A - c), y)); x -= 2 * (A - c)           # W
    pts.append((x - c, y - c)); x -= c; y -= c                   # 45 SW
    pts.append((x, y - 2 * (A - c))); y -= 2 * (A - c)           # S
    pts.append((x + c, y - c)); x += c; y -= c                   # 45 SE
    pts.append((x + 2 * (A - c), y)); x += 2 * (A - c)           # E -> bottom-right
    if k < n_turns - 1:                                          # step inward
        pts.append((x, y + (pitch + c))); y += (pitch + c)       # N
        pts.append((x - (pitch - c), y)); x -= (pitch - c)       # W
        A -= pitch                                               # next radius
ix, iy = pts[-1]                                                 # inner end

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# spiral trace on the top metal, one net "L"
c.path(top_metal, pts, width=w, net="L")

# inner end: via down from the top metal to the metal below
c.via(c0, low_metal, at=(ix, iy), net="L", dir="v")

# outer end: pad on the top metal at the start of the spiral
ox, oy = pts[0]
c.rect(top_metal,
       x0=ox - 6.0, x1=ox + 6.0,
       y0=oy - 6.0, y1=oy + 6.0, net="L")

c.port("L", on=c.rect(top_metal,
                      x0=ox - 6.0, x1=ox + 6.0,
                      y0=oy - 6.0, y1=oy + 6.0, net="L"))

TOP = c


