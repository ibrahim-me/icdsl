import klayout.db as kdb

# ---------------------------------------------------------------- PDK (sky130A)
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20), "via2": (69, 44), "m3": (70, 20),
        "via3": (70, 44), "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
    },
    label={"m5": (72, 5), "m4": (71, 5)},
    cuts={
        "via4": dict(size=0.80, space=0.80, lower="m4", upper="m5"),
    },
    width={"m5": 1.60, "m4": 0.30},
    space={("m5", "m5"): 1.60, ("m4", "m4"): 0.30},
    enc={("m4", "via4"): (0.19, 0.19), ("m5", "via4"): (0.31, 0.31)},
    rules=dict(
        gate_contact_space=0.055,
        poly_endcap=0.13,
        diff_ext_gate=0.25,
        polycontact_diff_space=0.19,
        polycontact_implant_space=0.11,
        gate_space=0.21,
        tap_diff_space=0.27,
        latchup_dist=15.0,
        wide_metal=3.0,
    ),
)

# ---------------------------------------------------------------- layout helpers
def layer(ly, name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def rect(cell, lay, x, y, w, h):
    cell.shapes(lay).insert(kdb.DBox(x, y, x + w, y + h))

def via(cell, lay, x, y, size):
    """square via centered at (x,y)"""
    hs = size / 2.0
    cell.shapes(lay).insert(kdb.DBox(x - hs, y - hs, x + hs, y + hs))

def label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(x, y)))

def trace_poly(points, width):
    """Return a DPolygon sweeping `width` along the polyline `points`.
    Mitered joints, square ends. All edges are H/V/45 deg because the input
    points only use H/V/45 moves."""
    pts = [kdb.DPoint(p[0], p[1]) for p in points]
    n = len(pts)
    if n < 2:
        return kdb.DPolygon()
    half = width / 2.0

    def unit(d):
        L = d.abs()
        return kdb.DPoint(d.x / L, d.y / L) if L > 0 else kdb.DPoint(0, 0)

    def left_normal(d):
        u = unit(d)
        return kdb.DPoint(-u.y, u.x)

    def miter_point(p, d_in, d_out):
        """outside corner point for a mitered joint"""
        u_in = unit(d_in)
        u_out = unit(d_out)
        # direction bisector (sum of unit vectors)
        bis = kdb.DPoint(u_in.x + u_out.x, u_in.y + u_out.y)
        bl = bis.abs()
        if bl < 1e-9:
            return p
        bis = kdb.DPoint(bis.x / bl, bis.y / bl)
        # miter length = half / sin(angle/2) ; sin(a/2) = |cross| / (2|u_in||u_out|)
        cross = abs(u_in.x * u_out.y - u_in.y * u_out.x)
        if cross < 1e-9:
            # straight or 180 deg: just go straight
            return p + bis * 0
        sin_half = cross / 2.0
        miter = half / sin_half if sin_half > 1e-9 else half * 4
        return p + bis * miter

    # collect outer and left boundary points
    outer = []
    leftb = []
    for i in range(n - 1):
        d = pts[i + 1] - pts[i]
        nrm = left_normal(d)
        outer.append(pts[i] + nrm * half)
        outer.append(pts[i + 1] + nrm * half)
        leftb.append(pts[i] - nrm * half)
        leftb.append(pts[i + 1] - nrm * half)

    # build polygon: start point, outer boundary to end, end cap, reversed left boundary back to start
    poly = [pts[0] - left_normal(pts[1] - pts[0]) * half]
    # outer boundary (with miters at joints)
    for i in range(n - 1):
        d = pts[i + 1] - pts[i]
        nrm = left_normal(d)
        if i > 0:
            d_prev = pts[i] - pts[i - 1]
            poly.append(miter_point(pts[i], d_prev, d))
        poly.append(pts[i + 1] + nrm * half)
    # end cap
    d_last = pts[-1] - pts[-2]
    nrm_last = left_normal(d_last)
    poly.append(pts[-1] + nrm_last * half)
    poly.append(pts[-1] - nrm_last * half)
    # left boundary backwards (with miters)
    for i in range(n - 2, 0, -1):
        d = pts[i + 1] - pts[i]
        nrm = left_normal(d)
        d_next = pts[i + 1] - pts[i]
        d_prev = pts[i] - pts[i - 1]
        poly.append(miter_point(pts[i], d_next, d_prev) * 0 + (pts[i] - nrm * half))
        # the miter point for the inner corner uses the same bisector but pointing inward;
        # for simplicity we just use the offset point; the small overlap/underlap at inside
        # corners is acceptable because width is large and spacing is generous.
    poly.append(pts[0] - left_normal(pts[1] - pts[0]) * half)
    return kdb.DPolygon(poly)

def add_trace(cell, lay, points, width):
    cell.shapes(lay).insert(trace_poly(points, width))

# ---------------------------------------------------------------- spiral generator
def spiral_points(w, s, c, nturns):
    """Return centerline points of an octagonal spiral starting at (0,0) and
    winding outward.  Segments are H/V/45-deg.  `c` is the chamfer size (dx=dy=c)
    used at every corner."""
    pitch = w + s
    L = [w + i * pitch for i in range(nturns * 4 + 2)]
    dirs = [(1, 0), (1, 1), (0, 1), (-1, 1),
            (-1, 0), (-1, -1), (0, -1), (1, -1)]
    pts = [(0.0, 0.0)]
    x, y = 0.0, 0.0
    seg = 0
    while seg < len(L):
        length = L[seg]
        d = dirs[seg % 8]
        if d[0] != 0 and d[1] != 0:
            # diagonal segment: fixed chamfer size c in x and y
            step = c
            x += d[0] * step
            y += d[1] * step
        else:
            x += d[0] * length
            y += d[1] * length
        pts.append((x, y))
        seg += 1
    return pts

# ---------------------------------------------------------------- main
def build():
    ly = kdb.Layout()
    ly.dbu = 0.001
    top = ly.create_cell("spiral")

    m5 = layer(ly, "m5")
    m4 = layer(ly, "m4")
    via4 = layer(ly, "via4")
    lab5 = TECH["label"]["m5"]
    lab4 = TECH["label"]["m4"]

    # spiral parameters
    w = 4.0          # trace width (>= 4.0 um)
    s = 4.0          # spacing between turns
    c = 4.0          # 45-deg chamfer size
    nturns = 4       # full turns (>3)

    pts = spiral_points(w, s, c, nturns)

    # draw the spiral on m5
    add_trace(top, m5, pts, w)

    # inner end: start point (0,0) -> via down to m4
    via_size = TECH["cuts"]["via4"]["size"]
    enc5 = TECH["enc"][("m5", "via4")][0]
    enc4 = TECH["enc"][("m4", "via4")][0]
    pad = via_size / 2.0 + max(enc5, enc4) + 0.05

    # m5 pad around inner via
    rect(top, m5, -pad, -pad, 2 * pad, 2 * pad)
    via(top, via4, 0.0, 0.0, via_size)

    # m4 underpass: from via location, run out to the right, then up, then left
    # to clear the coil, then up to m5 at the outer area.
    ux = 20.0   # x where underpass leaves the coil area
    uy = 0.0
    # m4 trace: via -> (ux, 0) -> (ux, 30) -> (outer_x, 30)
    m4_pts = [(0.0, 0.0), (ux, 0.0), (ux, 30.0), (40.0, 30.0)]
    add_trace(top, m4, m4_pts, 2.0)   # m4 width 2.0 um (> min 0.30)

    # via up at outer end of underpass
    via(top, via4, 40.0, 30.0, via_size)
    rect(top, m5, 40.0 - pad, 30.0 - pad, 2 * pad, 2 * pad)

    # outer end of spiral: last point of pts
    ox, oy = pts[-1]
    rect(top, m5, ox - pad, oy - pad, 2 * pad, 2 * pad)

    # labels (pin L on m5)
    label(top, lab5, "L", -pad, -pad)
    label(top, lab5, "L", ox, oy)

    # bounding box check
    bbox = top.bbox()
    print("bbox: (%.3f, %.3f) -> (%.3f, %.3f)" % (bbox.left, bbox.bottom, bbox.right, bbox.top))
    print("area: %.2f um^2" % ((bbox.right - bbox.left) * (bbox.top - bbox.bottom)))

    ly.write("spiral.gds")

if __name__ == "__main__":
    build()
