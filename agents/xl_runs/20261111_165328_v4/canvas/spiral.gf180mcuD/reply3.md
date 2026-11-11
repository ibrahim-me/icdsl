```
from icdsl.canvas import *

tech = use()
top = tech.stack[-1]          # top metal (m5 on gf180)
bot = tech.stack[-2]          # metal below top (m4 on gf180) -> underpass layer

W = 4.0                       # trace width (>= 4.0 um everywhere)
P = 8.0                       # centre-to-centre pitch between turns (edge gap = W)

SQRT2 = 2.0 ** 0.5
C4 = 4.0 / SQRT2              # 45-degree chamfer length (projection = 2.83)

# ---- octagonal spiral centreline: 3 full turns (24 segments) ----
# directions: E, NE, N, NW, W, SW, S, SE  (repeating)
# cardinal lengths grow by 2*P per turn; 45-degree segments are short chamfers
pts = [(-3.0, 0.0)]           # start a little before the via so the via is enclosed
x, y = -3.0, 0.0

# turn 1
x += 9.0; pts.append((x, y))                       # E
x += C4; y += C4; pts.append((x, y))               # NE
y += 14.0; pts.append((x, y))                      # N
x -= C4; y += C4; pts.append((x, y))               # NW
x -= 22.0; pts.append((x, y))                      # W
x -= C4; y -= C4; pts.append((x, y))               # SW
y -= 22.0; pts.append((x, y))                      # S
x += C4; y -= C4; pts.append((x, y))               # SE

# turn 2
x += 30.0; pts.append((x, y))                      # E
x += C4; y += C4; pts.append((x, y))               # NE
y += 30.0; pts.append((x, y))                      # N
x -= C4; y += C4; pts.append((x, y))               # NW
x -= 38.0; pts.append((x, y))                      # W
x -= C4; y -= C4; pts.append((x, y))               # SW
y -= 38.0; pts.append((x, y))                      # S
x += C4; y -= C4; pts.append((x, y))               # SE

# turn 3
x += 46.0; pts.append((x, y))                      # E
x += C4; y += C4; pts.append((x, y))               # NE
y += 46.0; pts.append((x, y))                      # N
x -= C4; y += C4; pts.append((x, y))               # NW
x -= 54.0; pts.append((x, y))                      # W
x -= C4; y -= C4; pts.append((x, y))               # SW
y -= 54.0; pts.append((x, y))                      # S
x += C4; y -= C4; pts.append((x, y))               # SE

c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")            # one open coil, all one net

# ---- inner end: via down at (0,0) which lies on the first segment, then underpass out ----
v = c.via(bot, top, at=(0.0, 0.0), net="L")        # via sits in the middle of the first segment

minx = min(p[0] for p in pts)
ux = minx - 2.0                                    # underpass end outside the coil
up = c.rect(bot, x0=ux, x1=v.lower.right,
            y0=v.lower.bottom - W / 2, y1=v.lower.top + W / 2, net="L")

# ---- ports: outer end of the coil, and the underpass end outside the coil ----
c.port("L", on=sp, dir="out")
c.port("L", on=up, dir="out")

TOP = c

```