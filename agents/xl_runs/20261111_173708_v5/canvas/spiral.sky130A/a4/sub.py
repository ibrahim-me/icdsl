from icdsl.canvas import *
import math

tech = use()
below = tech.stack[-2]   # metal just under the top metal (m4 on sky130)
top = tech.stack[-1]

w = 5.0                  # perpendicular trace width; 5/sqrt(2)=3.54 on 45-deg legs -> need wider
w = 6.0                  # use 6.0 so even projected width stays >= 4.0
s = tech.space(top)      # min trace-to-trace spacing on top metal (1.6 for m5 on sky130)
p = w + s                # centerline pitch

# Octagonal spiral centerline, inner -> outer.
# Heading cycles E,NE,N,NW,W,SW,S,SE (one full revolution per 8 segments).
# Diagonals move (p,p) so consecutive parallel laps nest with pitch p.
# Straight length grows by p every half-turn.
dirs = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]
nseg = 32                # 4 revolutions -> >= 3 full turns around centre
seg = []
for i in range(nseg):
    seg.append((dirs[i % 8], 2.0 + (i // 2) * p))

pts = [(0.0, 0.0)]
x = y = 0.0
for direc, length in seg:
    if direc == "E":   x += length
    elif direc == "W": x -= length
    elif direc == "N": y += length
    elif direc == "S": y -= length
    elif direc == "NE": x += p; y += p
    elif direc == "NW": x -= p; y += p
    elif direc == "SW": x -= p; y -= p
    elif direc == "SE": x += p; y -= p
    pts.append((x, y))

c = Cell("spiral")

# Draw each segment as its own rectangle/polygon with overlap at joints.
# This avoids mitered path joins that create narrow spots at 45-degree turns.
hw = w / 2.0
overlap = w * 0.6          # generous overlap so joints are never narrow
for i in range(len(pts) - 1):
    x0, y0 = pts[i]
    x1, y1 = pts[i + 1]
    dx = x1 - x0
    dy = y1 - y0
    L = math.hypot(dx, dy)
    ux = dx / L
    uy = dy / L
    nx = -uy
    ny = ux
    # extend beyond both endpoints for overlap
    ex0 = x0 - ux * overlap
    ey0 = y0 - uy * overlap
    ex1 = x1 + ux * overlap
    ey1 = y1 + uy * overlap
    poly = [
        (ex0 + nx * hw, ey0 + ny * hw),
        (ex0 - nx * hw, ey0 - ny * hw),
        (ex1 - nx * hw, ey1 - ny * hw),
        (ex1 + nx * hw, ey1 + ny * hw),
    ]
    c.polygon(top, poly, net="L")

# Outer end: continue straight out of the coil so the port sits outside the turns
ox, oy = pts[-1]
last = dirs[(nseg - 1) % 8]
if last in ("E", "W"):
    x1 = ox + (14.0 if last == "E" else -14.0)
    c.rect(top, x0=min(ox, x1), x1=max(ox, x1), y0=oy - hw, y1=oy + hw, net="L")
elif last in ("N", "S"):
    y1 = oy + (14.0 if last == "N" else -14.0)
    c.rect(top, x0=ox - hw, x1=ox + hw, y0=min(oy, y1), y1=max(oy, y1), net="L")
else:
    sx = 14.0 if last in ("NE", "SE") else -14.0
    sy = 14.0 if last in ("NE", "NW") else -14.0
    # diagonal stub as a polygon
    ux = sx / math.hypot(sx, sy)
    uy = sy / math.hypot(sx, sy)
    nx = -uy
    ny = ux
    poly = [
        (ox + nx * hw, oy + ny * hw),
        (ox - nx * hw, oy - ny * hw),
        (ox + sx - nx * hw, oy + sy - ny * hw),
        (ox + sx + nx * hw, oy + sy + ny * hw),
    ]
    c.polygon(top, poly, net="L")

# Inner end: via from top metal down to the metal below, right at the coil start
ix, iy = pts[0]
c.via(below, top, at=(ix, iy), net="L", dir="h")

# Underpass on the metal below: from the via pad, run out from under the coil
vs = tech.width(below)
c.rect(below, x0=ix - 55.0, x1=ix + vs / 2 + 0.2,
       y0=iy - hw, y1=iy + hw, net="L")

c.port("L", on=c.rect(top, x0=pts[-1][0] - hw, x1=pts[-1][0] + hw,
                      y0=pts[-1][1] - hw, y1=pts[-1][1] + hw, net="L"), dir="out")

TOP = c


