from icdsl.canvas import *
import math

tech = use()
c0 = tech.c0                      # first conductor above devices
stack = tech.stack
top_metal = stack[-1]             # top metal (m5 on gf180)
under_metal = stack[-2]           # metal below top (m4 on gf180)

# via cut between under_metal and top_metal (via4 on gf180: m4->m5)
via_up = "via%d" % (stack.index(under_metal) + 1)

SQRT2 = math.sqrt(2.0)
C = 1.0 / SQRT2

# ---------- spiral parameters ----------
w = 4.0          # trace width (>= 4.0 um everywhere)
g = 4.0          # gap between turns
p = w + g        # centerline pitch
n_turns = 3.5    # open coil: outer end + inner end brought out underneath

# ---------- octagonal spiral centerline (CCW, from center outward) ----------
dirs = [(1, 0), (C, C), (0, 1), (-C, C), (-1, 0), (-C, -C), (0, -1), (C, -C)]

Lseg = []
nseg = int(8 * n_turns)
for k in range(nseg):
    t = k // 8
    r = k % 8
    base = p / 2.0 + t * 2.0 * p
    if r == 0:
        Lseg.append(base)
    elif r == 2:
        Lseg.append(base + p)
    elif r in (4, 6):
        Lseg.append(base + 2.0 * p)
    else:
        Lseg.append(base + p)

pts = [(0.0, 0.0)]
for k in range(nseg):
    dx, dy = dirs[k % 8]
    x, y = pts[-1]
    pts.append((x + Lseg[k] * dx, y + Lseg[k] * dy))

# center the spiral on the origin
xs = [q[0] for q in pts]; ys = [q[1] for q in pts]
cx = (min(xs) + max(xs)) / 2.0; cy = (min(ys) + max(ys)) / 2.0
half = max(max(xs) - min(xs), max(ys) - min(ys)) / 2.0 + w
pts = [(x - cx, y - cy) for x, y in pts]

inner = pts[0]          # center of coil (inner end)
outer_end = pts[-1]     # outer tip of coil

# ---------- cell ----------
c = Cell("spiral")

# the coil on the top metal, one net "L"
sp = c.path(top_metal, pts, w, net="L", first="round", last="round")

# inner end: via down to the metal below
v_in = c.via(under_metal, top_metal, at=inner, net="L")

# underpass on the metal below the coil, running out to the side
under_len = half + 2.0
under_x1 = inner[0] + under_len
up = c.rect(under_metal, x0=inner[0], x1=under_x1,
            y0=inner[1] - w / 2.0, y1=inner[1] + w / 2.0, net="L")

# via back up to top metal at the far end of the underpass
v_out = c.via(under_metal, top_metal, at=(under_x1, inner[1]), net="L")

# top-metal stub at the exit of the underpass (port for the inner end)
stub = c.rect(top_metal, x0=under_x1, x1=under_x1 + w,
              y0=inner[1] - w / 2.0, y1=inner[1] + w / 2.0, net="L")

# ports: outer terminal = coil tip; inner terminal = stub (connected via underpass)
c.port("L", on=sp, dir="in")
c.port("L", on=stub, dir="out")

TOP = c
