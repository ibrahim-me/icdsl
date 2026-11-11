import klayout.db as kdb
import math

# ---------------------------------------------------------------- PDK (freepdk45)
TECH = dict(
    name="freepdk45",
    grid=0.005,
    gds_dbu=0.0005,
    layers={
        "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0), "pplus": (5, 0),
        "vtg": (6, 0), "vth": (7, 0), "thkox": (8, 0), "poly": (9, 0), "contact": (10, 0),
        "m1": (11, 0), "via1": (12, 0), "m2": (13, 0), "via2": (14, 0), "m3": (15, 0),
        "via3": (16, 0), "m4": (17, 0), "via4": (18, 0), "m5": (19, 0), "via5": (20, 0),
        "m6": (21, 0), "via6": (22, 0), "m7": (23, 0), "via7": (24, 0), "m8": (25, 0),
        "via8": (26, 0), "m9": (27, 0), "via9": (28, 0), "m10": (29, 0),
        "boundary": (235, 0),
    },
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    cuts=dict(
        contact=dict(size=0.065, space=0.075),
        via1=dict(size=0.07, space=0.075), via2=dict(size=0.07, space=0.085),
        via3=dict(size=0.07, space=0.085), via4=dict(size=0.14, space=0.16),
        via5=dict(size=0.14, space=0.16), via6=dict(size=0.14, space=0.16),
        via7=dict(size=0.40, space=0.44), via8=dict(size=0.40, space=0.44),
        via9=dict(size=0.80, space=0.88),
    ),
    width={"m1": 0.065, "m2": 0.07, "m3": 0.07, "m4": 0.14, "m5": 0.14,
           "m6": 0.14, "m7": 0.40, "m8": 0.40, "m9": 0.80, "m10": 0.80},
    space={("m1", "m1"): 0.065, ("m2", "m2"): 0.07, ("m3", "m3"): 0.07,
           ("m4", "m4"): 0.14, ("m5", "m5"): 0.14, ("m6", "m6"): 0.14,
           ("m7", "m7"): 0.40, ("m8", "m8"): 0.40, ("m9", "m9"): 0.80,
           ("m10", "m10"): 0.80},
    enc={("m1", "via1"): (0.0, 0.035), ("m2", "via1"): (0.0, 0.035),
         ("m2", "via2"): (0.0, 0.035), ("m3", "via2"): (0.0, 0.035),
         ("m3", "via3"): (0.0, 0.035), ("m4", "via3"): (0.0, 0.035),
         ("m4", "via4"): (0.0, 0.035), ("m5", "via4"): (0.0, 0.035),
         ("m5", "via5"): (0.0, 0.035), ("m6", "via5"): (0.0, 0.035),
         ("m6", "via6"): (0.0, 0.035), ("m7", "via6"): (0.0, 0.035),
         ("m7", "via7"): (0.0, 0.035), ("m8", "via7"): (0.0, 0.035),
         ("m8", "via8"): (0.0, 0.035), ("m9", "via8"): (0.0, 0.035),
         ("m9", "via9"): (0.0, 0.035), ("m10", "via9"): (0.0, 0.035)},
)

GRID = 0.0025  # KLayout deck checks 2.5 nm grid

def snap(v):
    return round(v / GRID) * GRID

def layer(ly, name):
    return ly.layer(*TECH["layers"][name])

def dbox(ly, cell, name, x1, y1, x2, y2):
    cell.shapes(layer(ly, name)).insert(kdb.DBox(snap(x1), snap(y1), snap(x2), snap(y2)))

def via(ly, cell, cut, x, y, nx=1, ny=1, sp=None):
    c = TECH["cuts"][cut]
    sz = c["size"]
    sp = sp if sp is not None else sz + c["space"]
    lay = layer(ly, cut)
    hs = snap(sz / 2)
    for ix in range(nx):
        for iy in range(ny):
            cx = snap(x + (ix - (nx - 1) / 2.0) * sp)
            cy = snap(y + (iy - (ny - 1) / 2.0) * sp)
            cell.shapes(lay).insert(kdb.DBox(cx - hs, cy - hs, cx + hs, cy + hs))

def via_stack(ly, cell, x, y, lower, upper, cut, pad, nx=2, ny=1):
    dbox(ly, cell, lower, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    dbox(ly, cell, upper, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    via(ly, cell, cut, x, y, nx, ny)

def label_pin(ly, cell, metal, x, y, text):
    cell.shapes(layer(ly, metal)).insert(
        kdb.DText(text, kdb.DTrans(snap(x), snap(y))))

# ---------------------------------------------------------------- spiral parameters
W = 4.0          # trace width (>= 4.0 um, >> m10 min width 0.8 um)
P = 5.0          # pitch = W + gap (gap 1.0 um >= m10 min space 0.8 um)
S = 4.0          # first segment length
CENTER = (50.0, 50.0)
PAD = 3.0        # via pad size (>= via9 size 0.8 + 2*0.035 enc)

# Directions: E, S, W, N (clockwise square spiral)
DIRS = [(1.0, 0.0), (0.0, -1.0), (-1.0, 0.0), (0.0, 1.0)]

# Centerline: 12 segments = 3 full turns
NSEG = 12
verts = [CENTER]
x, y = CENTER
for i in range(NSEG):
    L = S + i * P
    dx, dy = DIRS[i % 4]
    x += L * dx
    y += L * dy
    verts.append((x, y))

end_inner = verts[0]     # spiral start (center)
end_outer = verts[-1]    # spiral end (outer)

# ---------------------------------------------------------------- build constant-width polygon
# All edges are Manhattan or 45 degrees. 45-degree chamfers at every corner.
d = W / 2.0
N = len(verts)

def left_normal(dx, dy):
    return (-dy, dx)

poly = []

# --- start cap (perpendicular to first segment) ---
d0x, d0y = DIRS[0]
n0x, n0y = left_normal(d0x, d0y)
sx, sy = verts[0]
poly.append((snap(sx - d * n0x), snap(sy - d * n0y)))   # inner start cap
poly.append((snap(sx + d * n0x), snap(sy + d * n0y)))   # outer start cap

# --- outer boundary (left side of travel) ---
for i in range(1, N):
    if i == N - 1:
        # end point outer
        dLx, dLy = DIRS[(NSEG - 1) % 4]
        nLx, nLy = left_normal(dLx, dLy)
        ex, ey = verts[-1]
        poly.append((snap(ex + d * nLx), snap(ey + d * nLy)))
    else:
        # corner: 45-degree chamfer between the two outer offset points
        d1x, d1y = DIRS[(i - 1) % 4]
        d2x, d2y = DIRS[i % 4]
        n1x, n1y = left_normal(d1x, d1y)
        n2x, n2y = left_normal(d2x, d2y)
        vx, vy = verts[i]
        p1 = (snap(vx + d * n1x), snap(vy + d * n1y))
        p2 = (snap(vx + d * n2x), snap(vy + d * n2y))
        poly.append(p1)
        poly.append(p2)

# --- end cap (perpendicular to last segment) ---
dLx, dLy = DIRS[(NSEG - 1) % 4]
nLx, nLy = left_normal(dLx, dLy)
ex, ey = verts[-1]
poly.append((snap(ex - d * nLx), snap(ey - d * nLy)))   # inner end cap

# --- inner boundary (right side, reversed) ---
for i in range(N - 2, 0, -1):
    d1x, d1y = DIRS[(i - 1) % 4]
    d2x, d2y = DIRS[i % 4]
    n1x, n1y = left_normal(d1x, d1y)
    n2x, n2y = left_normal(d2x, d2y)
    vx, vy = verts[i]
    p1 = (snap(vx - d * n1x), snap(vy - d * n1y))
    p2 = (snap(vx - d * n2x), snap(vy - d * n2y))
    poly.append(p1)
    poly.append(p2)

# close back to inner start cap (already first point)

# ---------------------------------------------------------------- create layout
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]
top = ly.create_cell("spiral")

M10 = "m10"
M9 = "m9"

# Spiral trace on m10 (single polygon, constant width W)
dpoly = kdb.DPolygon([kdb.DPoint(px, py) for px, py in poly])
top.shapes(layer(ly, M10)).insert(dpoly)

# Inner end: via9 from m10 down to m9
via_stack(ly, top, end_inner[0], end_inner[1], M9, M10, "via9", PAD, nx=2, ny=1)

# m9 underpass: L-shape from center out past the coil, then to outer end
ux, uy = end_inner
ox, oy = end_outer

# Horizontal underpass at y = uy from center to beyond outer extent (go West)
xmin = min(ux, ox) - 3.0
xmax = ux + 0.1
dbox(ly, top, M9, xmin, uy - W / 2, xmax, uy + W / 2)

# Vertical connector at outer end x
dbox(ly, top, M9, ox - W / 2, min(uy, oy) - 3.0, ox + W / 2, max(uy, oy) + 3.0)

# Outer end: via9 from m9 up to m10
via_stack(ly, top, ox, oy, M9, M10, "via9", PAD, nx=2, ny=1)

# Pin label on top metal (one net, name L)
label_pin(ly, top, M10, ox + 1.0, oy, "L")

# ---------------------------------------------------------------- write GDS
ly.write("spiral.gds")
print("written spiral.gds, bbox:", top.bbox())


