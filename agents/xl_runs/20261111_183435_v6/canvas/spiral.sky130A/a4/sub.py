from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0
top = tech.stack[-1]          # top metal (m5 on sky130A)
below = tech.stack[-2]        # metal below top (m4 on sky130A)

W = 4.0                       # trace width (>= 4.0 um everywhere)
GAP = 2.0                     # gap between turns (> 1.6 um DRC min)
PITCH = W + GAP               # centre-to-centre pitch = 6.0 um
GRID = 0.005                  # 5 nm grid

def snap(v):
    return round(v / GRID) * GRID

# ---- octagonal spiral centreline: every segment H, V, or exactly 45 deg ----
# Segment k goes in direction dirs[k % 8].  Length grows linearly so that
# parallel segments in adjacent turns are spaced by PITCH.
# All lengths are multiples of GRID so vertices stay on-grid and diagonals
# have |dx| == |dy| exactly.
NSEG = 24                     # exactly 3 octagonal turns
L0 = 2.0                      # inner segment length (on grid)
DK = PITCH / 8.0              # 0.75 um per segment (on grid: 150 grids)

dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]

pts = [(0.0, 0.0)]
x = y = 0.0
for k in range(NSEG):
    dx, dy = dirs[k % 8]
    l = snap(L0 + k * DK)
    step = l                  # axial: length = l ; diagonal: |dx|=|dy|=l
    x = snap(x + dx * step)
    y = snap(y + dy * step)
    pts.append((x, y))

# ---- top metal: one open spiral, net "L" ----
c = Cell("spiral")
sp = c.path(top, pts, width=W, net="L")

inner = pts[0]                # centre of spiral (inner end)
outer = pts[-1]               # outer end

# inner end: via down to m4, underpass runs out from under the coil
v = c.via(below, top, at=inner, net="L", dir="h")   # via4 (m4<->m5) on sky130A
vp = v.lower                  # m4 pad of the via
# m4 bar at the via location
bar = c.rect(below,
             x0=inner[0] - 1.0, x1=inner[0] + 1.0,
             y0=vp.bottom, y1=vp.top, net="L")
# underpass: m4 wire from the via out to the right, clear of the coil
# find how far right we need to go to clear the spiral
max_x = max(p[0] for p in pts)
under_end = snap(max_x + GAP + 2.0)
under = c.rect(below,
               x0=bar.right, x1=under_end,
               y0=vp.bottom, y1=vp.top, net="L")
# via from m4 up to m5 at the outer end of the underpass (outside the coil)
c.via(below, top, at=(under_end, vp.cy), net="L", dir="h")

# outer end: pad on top metal outside the coil
pad = c.rect(top,
             x0=outer[0], x1=outer[0] + 6.0,
             y0=outer[1] - W / 2, y1=outer[1] + W / 2, net="L")

c.port("L", on=pad)
c.port("L", on=under)

TOP = c


