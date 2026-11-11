from icdsl.canvas import *
import math

tech = use()
top_metal = tech.stack[-1]   # m10 on freepdk45
low_metal = tech.stack[-2]   # m9
c0 = tech.c0                 # contact

# ------------------------------------------------------------------ geometry
w = 4.0                      # trace width (>= 4.0 um everywhere)
space = max(tech.space(top_metal, width=w), 2.0)
pitch = w + space            # centre-to-centre pitch between turns
c = 2.0                      # chamfer (axial projection of each 45 deg corner)
A0 = 28.0                    # outer half-size
n_turns = 4                  # full turns (>= 3)

# Centreline of an octagonal spiral, counter-clockwise inward.
# Each turn is an octagon that does NOT close: after the bottom side the
# trace steps inward at the bottom-right corner, leaving a clear gap between
# the outer end and the first turn so the thick trace never self-touches.
pts = []
x, y = A0, -(A0 - c)         # start: bottom of outer right side
pts.append((x, y))
A = A0
for k in range(n_turns):
    pts.append((x, y + 2 * (A - c))); y += 2 * (A - c)          # N  right side
    pts.append((x - c, y + c)); x -= c; y += c                    # 45 NW
    pts.append((x - 2 * (A - c), y)); x -= 2 * (A - c)           # W  top side
    pts.append((x - c, y - c)); x -= c; y -= c                    # 45 SW
    pts.append((x, y - 2 * (A - c))); y -= 2 * (A - c)           # S  left side
    pts.append((x + c, y - c)); x += c; y -= c                    # 45 SE
    pts.append((x + 2 * (A - c) - c, y)); x += 2 * (A - c) - c   # E  bottom side (stop short)
    if k < n_turns - 1:                                           # step inward
        pts.append((x, y + pitch)); y += pitch                    # N
        pts.append((x - pitch, y)); x -= pitch                    # W
        A -= pitch
ix, iy = pts[-1]                                                  # inner end

# ------------------------------------------------------------------ cell
c = Cell("spiral")

# spiral trace on the top metal, one net "L"
c.path(top_metal, pts, width=w, net="L")

# inner end: via down from top metal to metal below
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


