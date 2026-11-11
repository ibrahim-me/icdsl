```python
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
    space_wide={"m10": [(0.50, 0.50), (0.90, 0.90), (1.50, 1.50)],
                "m9": [(0.50, 0.50), (0.90, 0.90), (1.50, 1.50)]},
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

# ---------------------------------------------------------------- geometry helpers
def dbox(ly, cell, layer, x1, y1, x2, y2):
    cell.shapes(ly.layer(*TECH["layers"][layer])).insert(
        kdb.DBox(x1, y1, x2, y2))

def via(ly, cell, cut, x, y, nx=1, ny=1, sp=None):
    """via array (cut layer) centered at (x,y), nx by ny, pitch sp (defaults to size+space)."""
    c = TECH["cuts"][cut]
    sz = c["size"]
    sp = sp if sp is not None else sz + c["space"]
    lay = ly.layer(*TECH["layers"][cut])
    for ix in range(nx):
        for iy in range(ny):
            cx = x + (ix - (nx - 1) / 2.0) * sp
            cy = y + (iy - (ny - 1) / 2.0) * sp
            cell.shapes(lay).insert(kdb.DBox(cx - sz / 2, cy - sz / 2,
                                             cx + sz / 2, cy + sz / 2))

def via_stack(ly, cell, x, y, lower_metal, upper_metal, cut, pad=1.35, nx=2, ny=1):
    """metal pad on lower metal, via array, metal pad on upper metal."""
    dbox(ly, cell, lower_metal, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    dbox(ly, cell, upper_metal, x - pad / 2, y - pad / 2, x + pad / 2, y + pad / 2)
    via(ly, cell, cut, x, y, nx, ny)

def label_pin(ly, cell, metal, x, y, text):
    lay = ly.layer(*TECH["label"][metal])
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(x, y)))

# ---------------------------------------------------------------- constant-width mitered spiral
def spiral_polygon(center, start_angle_deg, seg0, step, nseg, width):
    """Return list of DPoint forming a constant-width mitered polygon around an
    octagonal polyline. Directions rotate 45 deg per segment; lengths grow by
    `step` each segment. All left turns (convex), so miter joins are safe."""
    pts = []
    cx, cy = center
    # centerline vertices
    v = [(cx, cy)]
    x, y = cx, cy
    ang = math.radians(start_angle_deg)
    for i in range(nseg):
        L = seg0 + i * step
        x += L * math.cos(ang)
        y += L * math.sin(ang)
        v.append((x, y))
        ang += math.radians(45.0)

    d = width / 2.0
    # left boundary (start -> end)
    left = []
    n = len(v)
    for i in range(n):
        if i == 0:
            tx = v[1][0] - v[0][0]
            ty = v[1][1] - v[0][1]
            ln = math.hypot(tx, ty)
            t = (tx / ln, ty / ln)
            nl = (-t[1], t[0])
        elif i == n - 1:
            tx = v[i][0] - v[i - 1][0]
            ty = v[i][1] - v[i - 1][1]
            ln = math.hypot(tx, ty)
            t = (tx / ln, ty / nl) if False else (tx / ln, ty / ln)
            nl = (-t[1], t[0])
        else:
            t1x = v[i][0] - v[i - 1][0]
            t1y = v[i][1] - v[i - 1][1]
            l1 = math.hypot(t1x, t1y)
            t1 = (t1x / l1, t1y / l1)
            n1 = (-t1[1], t1[0])
            t2x = v[i + 1][0] - v[i][0]
            t2y = v[i + 1][1] - v[i][1]
            l2 = math.hypot(t2x, t2y)
            t2 = (t2x / l2, t2y / l2)
            n2 = (-t2[1], t2[0])
            # intersection of left offset lines of the two segments
            # p = v[i] + d*n1 + s*t1 = v[i] + d*n2 + u*t2
            # solve [t1, -t2] [s,u]^T = d*(n2-n1)
            a = t1[0]; b = -t2[0]
            cc = t1[1]; dd = -t2[1]
            det = a * dd - b * cc
            rhsx = d * (n2[0] - n1[0])
            rhsy = d * (n2[1] - n1[1])
            s = (rhsx * dd - b * rhsy) / det
            left.append(kdb.DPoint(v[i][0] + d * n1[0] + s * t1[0],
                                   v[i][1] + d * n1[1] + s * t1[1]))
            continue
        left.append(kdb.DPoint(v[i][0] + d * nl[0], v[i][1] + d * nl[1]))

    # right boundary (end -> start)
    right = []
    for i in range(n - 1, -1, -1):
        if i == 0:
            tx = v[1][0] - v[0][0]
            ty = v[1][1] - v[0][1]
            ln = math.hypot(tx, ty)
            t = (tx / ln, ty / ln)
            nr = (t[1], -t[0])
            right.append(kdb.DPoint(v[i][0] - d * nr[0], v[i][1] - d * nr[1]))
        elif i == n - 1:
            tx = v[i][0] - v[i - 1][0]
            ty = v[i][1] - v[i - 1][1]
            ln = math.hypot(tx, ty)
            t = (tx / ln, ty / ln)
            nr = (t[1], -t[0])
            right.append(kdb.DPoint(v[i][0] - d * nr[0], v[i][1] - d * nr[1]))
        else:
            t1x = v[i][0] - v[i - 1][0]
            t1y = v[i][1] - v[i - 1][1]
            l1 = math.hypot(t1x, t1y)
            t1 = (t1x / l1, t1y / l1)
            r1 = (t1[1], -t1[0])
            t2x = v[i + 1][0] - v[i][0]
            t2y = v[i + 1][1] - v[i][1]
            l2 = math.hypot(t2x, t2y)
            t2 = (t2x / l2, t2y / l2)
            r2 = (t2[1], -t2[0])
            det = t1[0] * (-t2[1]) - (-t2[0]) * t1[1]
            rhsx = d * (r2[0] - r1[0])
            rhsy = d * (r2[1] - r1[1])
            s = (rhsx * (-t2[1]) - (-t2[0]) * rhsy) / det
            right.append(kdb.DPoint(v[i][0] - d * r1[0] + s * t1[0],
                                    v[i][1] - d * r1[1] + s * t1[1]))
    return left + right

# ---------------------------------------------------------------- build layout
ly = kdb.Layout()
ly.dbu = TECH["gds_dbu"]
top = ly.create_cell("spiral")

M10 = "m10"
M9 = "m9"
W = 4.0                      # trace width (>> 0.80 um min width)
CENTER = (55.0, 55.0)        # spiral centre
SEG0 = 6.0                   # first segment length
STEP = 6.6                   # length growth per segment -> ~6.0 um turn spacing
NSEG = 27                    # 3 full turns (8 seg/turn) + 3 lead segments

poly_pts = spiral_polygon(CENTER, 0.0, SEG0, STEP, NSEG, W)
top.shapes(ly.layer(*TECH["layers"][M10])).insert(kdb.DPolygon(poly_pts))

# endpoints of the centerline (recompute to know where they are)
ang = 0.0
x, y = CENTER
end_inner = CENTER
for i in range(NSEG):
    L = SEG0 + i * STEP
    nx_ = x + L * math.cos(ang)
    ny_ = y + L * math.sin(ang)
    if i == NSEG - 2:
        end_inner = (x, y)          # vertex before last segment (inner end)
    x, y = nx_, ny_
end_outer = (x, y)                # outer end

# inner end: via down to m9, underpass runs out from centre, via up to m10 lead
via_stack(ly, top, end_inner[0], end_inner[1], M9, M10, "via9", pad=2.6, nx=2, ny=1)
# m9 underpass: straight track from centre out past the outer coil edge
ux, uy = end_inner
dbox(ly, top, M9, ux - 2.0, uy - W / 2, 105.0, uy + W / 2)
# connect underpass to outer m10 end with a via + short m10 lead
via_stack(ly, top, end_outer[0], end_outer[1], M9, M10, "via9", pad=2.6, nx=2, ny=1)
dbox(ly, top, M9, end_outer[0] - W / 2, end_outer[1] - 2.0,
     end_outer[0] + W / 2, 105.0)

# pin label on the top metal (one net, name L)
label_pin(ly, top, M10, end_outer[0] + 1.0, end_outer[1], "L")

# ---------------------------------------------------------------- write GDS
ly.write("spiral.gds")
print("written spiral.gds, bbox:", top.bbox())
```