from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
c3 = tech.c3   # metal below top (m4 on sky130)
top = tech.stack[-1]

w = 6.0          # trace width: 6/sqrt(2) = 4.24 >= 4.0 even on 45-deg edges
s = tech.space(top)          # min trace-to-trace spacing on top metal
p = w + s                    # centerline pitch
d = p * math.sqrt(2.0)

# Octagonal spiral centerline, inner -> outer.
# Dir cycle E,NE,N,NW,W,SW,S,SE; diagonals move (p,p) so laps nest with pitch p.
# Straight length grows by 2p per lap (p per two segments).
dirs = ["E", "NE", "N", "NW", "W", "SW", "S", "SE"]
L0 = 2.0
nseg = 28                    # 3.5 turns -> >3 full turns around the centre
seg = []
for i in range(nseg):
    seg.append((dirs[i % 8], L0 + (i // 2) * p))

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

# Spiral trace on top metal, single net "L"
sp = c.path(top, pts, width=w, net="L")

# Outer end: continue straight out of the coil on top metal
ox, oy = pts[-1]
last = dirs[(nseg - 1) % 8]
dx = dy = 0.0
if last == "E":   dx = 12.0
elif last == "W": dx = -12.0
elif last == "N": dy = 12.0
elif last == "S": dy = -12.0
elif last == "NE": dx = dy = 8.0
elif last == "NW": dx = -8.0; dy = 8.0
elif last == "SW": dx = dy = -8.0
elif last == "SE": dx = dy = 8.0
c.rect(top, x0=ox, x1=ox + dx, y0=oy - w / 2, y1=oy + w / 2, net="L") if dx or dy else None
if dy and not dx:
    c.rect(top, x0=ox - w / 2, x1=ox + w / 2, y0=oy, y1=oy + dy, net="L")
if dx and dy:  # diagonal exit: extend the path end with a mitered stub
    c.path(top, [(ox, oy), (ox + dx, oy + dy)], width=w, net="L")

# Inner end: via4 from top metal down to c3 at the coil start
ix, iy = pts[0]
v = c.via(c3, top, at=(ix, iy), net="L", dir="h")

# Underpass on c3: from the via pad, run left outside the coil
vs = tech.width(c3)
c.rect(c3, x0=ix - 60.0, x1=ix + vs / 2 + 0.2,
       y0=iy - w / 2, y1=iy + w / 2, net="L")

c.port("L", on=sp, dir="out")

TOP = c

