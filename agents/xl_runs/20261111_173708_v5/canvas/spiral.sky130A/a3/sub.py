from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
below = tech.stack[-2]   # metal just under the top metal (m4 on sky130)
top = tech.stack[-1]

w = 6.0                  # perpendicular trace width; 6/sqrt(2)=4.24 >= 4.0 on 45-deg edges
s = tech.space(top)      # min trace-to-trace spacing on top metal
p = w + s                # centerline pitch (minimal, keeps the coil compact)

# Octagonal spiral centerline, inner -> outer.
# Heading cycles E,NE,N,NW,W,SW,S,SE (one full revolution per 8 segments).
# Diagonals move (p,p) so consecutive parallel laps nest with pitch p.
# Straight length grows by p every half-turn (2p per revolution).
dirs = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]
nseg = 20                # 2.5 revolutions -> 3 full turns around the centre
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

# Spiral trace on the top metal, single net "L"
sp = c.path(top, pts, width=w, net="L")

# Outer end: continue straight out of the coil so the port sits outside the turns
ox, oy = pts[-1]
last = dirs[(nseg - 1) % 8]
if last in ("E", "W"):
    x1 = ox + (12.0 if last == "E" else -12.0)
    c.rect(top, x0=min(ox, x1), x1=max(ox, x1), y0=oy - w / 2, y1=oy + w / 2, net="L")
elif last in ("N", "S"):
    y1 = oy + (12.0 if last == "N" else -12.0)
    c.rect(top, x0=ox - w / 2, x1=ox + w / 2, y0=min(oy, y1), y1=max(oy, y1), net="L")
else:  # diagonal exit: mitered stub
    sx = 12.0 if last in ("NE", "SE") else -12.0
    sy = 12.0 if last in ("NE", "NW") else -12.0
    c.path(top, [(ox, oy), (ox + sx, oy + sy)], width=w, net="L")

# Inner end: via from top metal down to the metal below, right at the coil start
ix, iy = pts[0]
c.via(below, top, at=(ix, iy), net="L", dir="h")

# Underpass on the metal below: from the via pad, run out from under the coil
vs = tech.width(below)
c.rect(below, x0=ix - 55.0, x1=ix + vs / 2 + 0.2,
       y0=iy - w / 2, y1=iy + w / 2, net="L")

c.port("L", on=sp, dir="out")

TOP = c

