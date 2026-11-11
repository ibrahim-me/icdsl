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

# ---------------------------------------------------------------- helpers
def layer(ly, name):
    return ly.layer(*TECH["layers"][name])

def dbox(ly, cell, name, x1, y1, x2, y2):
    cell.shapes(layer(ly, name)).insert(kdb.DBox(x1, y1, x2, y2))

def via(ly, cell, cut, x, y, nx=1, ny=1, sp=None):
    c = TECH["cuts"][cut]
    sz = c["size"]
    sp = sp if sp is not None else sz + c["space"]
    lay = layer(ly, cut)
    for ix in range(nx):
        for iy in range(ny):
            cx = x + (ix - (nx - 1) / 2.0) * sp
            cy = y + (iy - (ny - 1) / 2.0) * sp
            cell.shapes(lay).insert(kdb.DBox(cx - sz / 2, cy - sz / 2,
                                             cx + sz / 2, cy + sz / 2))

def via_stack(ly, cell, x, y, lower, upper, cut, pad, nx=2, ny=1):
    dbox(ly, cell, lower, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    dbox(ly, cell, upper, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    via(ly, cell, cut, x, y, nx, ny)

def label_pin(ly, cell, metal, x, y, text):
    cell.shapes(layer(ly, metal)).insert(
        kdb.DText(text, kdb.DTrans(x, y))) if False else None
    cell.shapes(TECH["label"][metal] and ly.layer(*TECH["label"][metal])).insert(
        kdb.DText(text, kdb.DTrans(x, y)))

def line_intersection(p1, d1, p2, d2):
    """Intersection of ray p1 + s*d1 and ray p2 + t*d2."""
    x1, y1 = p1; x2, y2 = p2
    dx1, dy1 = d1; dx2, dy2 = d2
    det = dx1 * (-dy2) - (-dx2) * dy1
    if abs(det) < 1e-12:
        return None
    rhsx = x2 - x1
    rhsy = y2 - y1
    s = (rhsx * (-dy2) - (-dx2) * rhsy) / det
    return (x1 + s * dx1, y1 + s * dy1)

# ---------------------------------------------------------------- spiral parameters
W = 4.0                      # trace width (>= 4.0 um, >> m10 min 0.8 um)
CENTER = (50.0, 50.0)        # spiral centre
SEG0 = 5.0                   # first segment length
STEP = 5.6                   # length growth per segment -> ~4.4 um turn gap
NSEG = 27                    # 3 full turns (24 seg) + 3 lead segments
PAD = 3.0                    # via pad size

# ---------------------------------------------------------------- build constant-width spiral
# centreline vertices
v = [CENTER]
x, y = CENTER
ang = 0.0
for i in range(NSEG):
    L = SEG0 + i * STEP
    x += L * math.cos(ang)
    y += L * math.sin(ang)
    v.append((x, y))
    ang += math.radians(45.0)

end_inner = v[0]     # centre (start of spiral)
end_outer = v[-1]    # outer end

d = W / 2.0
# outer and inner boundary vertices
outer = []
inner = []
for i in range(len(v)):
    # segment direction leaving v[i] (if any)
    if i < len(v) - 1:
        a = math.radians(i * 45.0)
        t = (math.cos(a), math.sin(a))
        n = (-t[1], t[0])          # left normal
    else:
        a = math.radians((len(v) - 2) * 45.0)
        t = (math.cos(a), math.sin(a))
        n = (-t[1], t[0])
    outer.append((v[i][0] + d * n[0], v[i][1] + d * n[1]))
    inner.append((v[i][0] - d * n[0], v[i][1] - d * n[1]))

# compute corner vertices: intersection of consecutive offset lines
outer_corners = [outer[0]]
inner_corners = [inner[0]]
for i in range(1, len(v)):
    # segment i-1 direction and segment i direction
    a0 = math.radians((i - 1) * 45.0)
    t0 = (math.cos(a0), math.sin(a0))
    n0 = (-t0[1], t0[0])
    a1 = math.radians(i * 45.0)
    t1 = (math.cos(a1), math.sin(a1))
    n1 = (-t1[1], t1[0])
    p = v[i]
    # outer: line through outer[i-1] dir t0, and line through outer[i] dir t1
    oi = line_intersection(outer[i - 1], t0, outer[i], t1)
    ii = line_intersection(inner[i - 1], t0, inner[i], t1)
    outer_corners.append(oi if oi else outer[i])
    inner_corners.append(ii if ii else inner[i])

# end caps: perpendicular to first/last segment
a_first = 0.0
t_first = (math.cos(a_first), math.sin(a_first))
n_first = (-t_first[1], t_first[0])
a_last = math.radians((NSEG - 1) * 45.0)
t_last = (math.cos(a_last), math.sin(a_last))
n_last = (-t_last[1], t_last[0])

# Build polygon: start cap -> outer boundary -> end cap -> inner boundary (reversed) -> start cap
poly = []
# start cap (at end_inner): segment 0 goes outward, cap is perpendicular at start
poly.append(kdb.DPoint(end_inner[0] - d * n_first[0], end_inner[1] - d * n_first[1]))
# outer boundary from start to end
for pt in outer_corners[1:]:
    poly.append(kdb.DPoint(pt[0], pt[1]))
# end cap at outer end
poly.append(kdb.DPoint(end_outer[0] + d * n_last[0], end_outer[1] + d * n_last[1]))
poly.append(kdb.DPoint(end_outer[0] - d * n_last[0], end_outer[1] - d * n_last[1]))
# inner boundary from end back to start (reversed)
for pt in reversed(inner_corners[1:-1]):
    poly.append(kdb.DPoint(pt[0], pt[1]))
# close back to start cap first point
poly.append(kdb.DPoint(end_inner[0] + d * n_first[0], end_inner[1] + d * n_first[1]))

# ---------------------------------------------------------------- create layout
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]
top = ly.create_cell("spiral")

M10 = "m10"
M9 = "m9"

# spiral trace on m10 (single polygon, constant width W, all edges 0/45/90 deg)
top.shapes(layer(ly, M10)).insert(kdb.DPolygon(poly))

# inner end: via9 from m10 down to m9
via_stack(ly, top, end_inner[0], end_inner[1], M9, M10, "via9", PAD, nx=2, ny=1)

# m9 underpass: straight track from centre out past the coil, then up to outer end
ux, uy = end_inner
ox, oy = end_outer
# horizontal underpass at y = uy from centre to beyond outer extent
xmin = min(ux, ox) - 2.0
xmax = max(ux, ox) + 2.0
dbox(ly, top, M9, xmin, uy - W / 2, xmax, uy + W / 2)
# vertical connector at outer end to reach the m10 outer-end pad
dbox(ly, top, M9, ox - W / 2, min(uy, oy) - 2.0, ox + W / 2, max(uy, oy) + 2.0)

# outer end: via9 from m9 up to m10
via_stack(ly, top, ox, oy, M9, M10, "via9", PAD, nx=2, ny=1)

# pin label on the top metal (one net, name L)
label_pin(ly, top, M10, ox + 1.0, oy, "L")

# ---------------------------------------------------------------- write GDS
ly.write("spiral.gds")
print("written spiral.gds, bbox:", top.bbox())
