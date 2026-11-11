from icdsl.canvas import *

tech = use()
c0 = tech.c0
top = tech.stack[-1]
below = tech.stack[-2]

W = 4.0          # trace width (>= 4.0 um on every PDK)
PITCH = 12.0     # centre-to-centre pitch; edge gap = PITCH - W = 8.0 um >> min space
n_turns = 3

# ---------- octagonal spiral centreline (CCW, expands by PITCH per turn) ----------
DIRS = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
SQRT2 = 2.0 ** 0.5

pts = [(0.0, 0.0)]
x = y = 0.0
n_seg = 8 * n_turns
for i in range(n_seg):
    r = i // 8
    d = i % 8
    dx, dy = DIRS[d]
    if dx and dy:                      # 45-degree diagonal
        extent = (r + 1) * PITCH
        x += dx * extent
        y += dy * extent
    else:                              # horizontal / vertical straight
        m = i // 2
        length = (m // 2 + 1) * PITCH
        x += dx * length
        y += dy * length
    pts.append((x, y))

# ---------- cell ----------
c = Cell("spiral")

# spiral on top metal, one net "L"
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
