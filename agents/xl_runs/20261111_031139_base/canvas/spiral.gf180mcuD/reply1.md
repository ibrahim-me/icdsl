```python
from icdsl.canvas import *
from icdsl.canvas.route import Router
import math

tech = use()
c0 = tech.c0                      # first conductor (m1 on gf180)
top_metal = tech.stack[-1]        # top metal (m5 on gf180)
under_metal = tech.stack[-2]      # metal below top (m4 on gf180)
via_top = tech.via_below(top_metal) if hasattr(tech, "via_below") else None

# via names for the stack
def via_name(a, b):
    stack = tech.stack
    ia = stack.index(a); ib = stack.index(b)
    if abs(ia - ib) != 1:
        raise ValueError("not adjacent")
    lo, hi = sorted([a, b])
    for nm in tech.d.get("cuts", {}):
        pass
    return ("via%d" % (min(ia, ib) + 1))  # via1 between m1/m2, etc.

# gf180: c0=m1, stack m1..m5, top=m5, under=m4, via between m4/m5 = via4
via_up = via_name(under_metal, top_metal)   # e.g. via4

SQRT2 = math.sqrt(2.0)
C = 1.0 / SQRT2

# ---------- spiral parameters (tuned per PDK for area budget) ----------
w = 4.0          # trace width (>= 4.0 um everywhere)
g = 4.0          # gap between turns
p = w + g        # centerline pitch
n_turns = 3.5    # number of turns (open coil: outer end + inner end)

# ---------- build octagonal spiral centerline (CCW, from center outward) ----------
dirs = [(1, 0), (C, C), (0, 1), (-C, C), (-1, 0), (-C, -C), (0, -1), (C, -C)]

L = []
for k in range(8 * n_turns):
    t = k // 8
    r = k % 8
    base = p / 2.0 + t * 2.0 * p
    if r == 0:
        L.append(base)
    elif r == 2:
        L.append(base + p)
    elif r == 4:
        L.append(base + 2.0 * p)
    elif r == 6:
        L.append(base + 2.0 * p)
    else:
        L.append(base + p)

pts = [(0.0, 0.0)]
for k in range(int(8 * n_turns)):
    dx, dy = dirs[k % 8]
    x, y = pts[-1]
    pts.append((x + L[k] * dx, y + L[k] * dy))

# bounding box of centerline
xs = [q[0] for q in pts]; ys = [q[1] for q in pts]
minx, maxx = min(xs), max(xs); miny, maxy = min(ys), max(ys)
cx = (minx + maxx) / 2.0; cy = (miny + maxy) / 2.0
half = max(maxx - minx, maxy - miny) / 2.0 + w
# shift so spiral is centered near origin; we will place the cell at (0,0)
shift = (-cx, -cy)
pts = [(x + shift[0], y + shift[1]) for x, y in pts]

# ---------- cell ----------
c = Cell("spiral")

# draw the spiral on top metal (one net "L")
sp = c.path(top_metal, pts, w, net="L", first="round", last="round")

# inner end = pts[0] (center). Bring it out underneath on under_metal.
inner = pts[0]
outer_end = pts[-1]

# via from top metal (inner end) down to under_metal
# place via centered on the inner end point; pad must cover the wire end
v_in = c.via(under_metal, top_metal, at=inner, net="L")

# underpass: run on under_metal from the via out to the side, clear of the coil
# choose direction: +x (east) until outside the coil bounding box
under_len = half + 2.0
under_y = inner[1]
under_x0 = inner[0]
under_x1 = inner[0] + under_len
up = c.rect(under_metal, x0=under_x0, x1=under_x1,
            y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

# via from under_metal back up to top metal at the outer end of the underpass
v_out = c.via(under_metal, top_metal, at=(under_x1, under_y), net="L")

# short top-metal stub from the upper via to the outside (port location)
stub = c.rect(top_metal, x0=under_x1, x1=under_x1 + w,
              y0=under_y - w / 2.0, y1=under_y + w / 2.0, net="L")

# outer end port: the spiral's outer tip (top metal)
# inner end port: the stub on top metal (connected via underpass)
c.port("L", on=sp, dir="in")          # outer terminal of the coil
c.port("L", on=stub, dir="out")       # inner terminal (brought out underneath)

TOP = c
``````python
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
```