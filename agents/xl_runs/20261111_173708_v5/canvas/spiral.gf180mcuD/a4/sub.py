from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]

W = 4.0          # trace width (>= 4.0 um on every PDK)
GAP = 1.0        # gap between adjacent turns (> min metal space on every PDK)
PITCH = W + GAP  # centre-to-centre pitch between turns
n_turns = 3

# ---------- octagonal spiral centreline (CCW, expands by PITCH per turn) ----------
# Directions cycle E, NE, N, NW, W, SW, S, SE.  Straight (Manhattan) legs grow as
# PITCH, PITCH, 2*PITCH, 2*PITCH, ... so adjacent turns stay PITCH apart.  The
# 45-degree diagonal at each corner has x- and y-extent PITCH/2 so its perpendicular
# spacing from the neighbouring straight is PITCH/sqrt(2) > GAP, keeping every edge
# at least W wide after the constant-width path offset.
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x = y = 0.0
n_seg = 8 * n_turns          # 8 segments per turn, open at both ends
for k in range(n_seg):
    dx, dy = DIRS[k % 8]
    m = k // 2 + 1           # 1,1,2,2,3,3,... growth of the straight legs
    if dx and dy:            # 45-degree diagonal: extent PITCH/2 in x and y
        x += dx * (PITCH / 2)
        y += dy * (PITCH / 2)
    else:                    # horizontal / vertical straight: length m * PITCH
        x += dx * m * PITCH
        y += dy * m * PITCH
    pts.append((x, y))

# ---------- cell ----------
c = Cell("spiral")

# spiral on the top metal, one net "L"
sp = c.path(top, pts, width=W, net="L")

# inner end: via down to the metal below, then an underpass out of the coil
v = c.via(below, top, at=pts[0], net="L", dir="v")
bx0 = v.lower.left - W / 2
bx1 = v.lower.right + W / 2
by1 = v.lower.top
by0 = min(p[1] for p in pts) - 2.0 * PITCH   # clearly outside the coil footprint
up = c.rect(below, x0=bx0, x1=bx1, y0=by0, y1=by1, net="L")

# ports (both ends of the open coil are net "L")
c.port("L", on=sp, dir="out")
c.port("L", on=up, dir="out")

TOP = c


