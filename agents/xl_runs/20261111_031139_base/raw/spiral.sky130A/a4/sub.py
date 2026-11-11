import klayout.db as kdb
import math

# ---------------------------------------------------------------- PDK (sky130A)
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "m4": (71, 20), "m5": (72, 20), "via4": (71, 44),
    },
    label={"m5": (72, 5)},
    cuts={
        "via4": dict(size=0.80, space=0.80, lower="m4", upper="m5"),
    },
    width={"m5": 1.60, "m4": 0.30},
    space={("m5", "m5"): 1.60, ("m4", "m4"): 0.30},
    enc={("m4", "via4"): (0.19, 0.19), ("m5", "via4"): (0.31, 0.31)},
)

GRID = TECH["grid"]

def snap(v):
    return round(v / GRID) * GRID

def layer(ly, name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def rect(cell, lay, x, y, w, h):
    cell.shapes(lay).insert(kdb.DBox(snap(x), snap(y), snap(x + w), snap(y + h)))

def via(cell, lay, x, y, size):
    hs = size / 2.0
    cell.shapes(lay).insert(kdb.DBox(snap(x - hs), snap(y - hs), snap(x + hs), snap(y + hs)))

def label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(snap(x), snap(y))))

def seg_poly(p1, p2, w):
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]
    length = math.hypot(dx, dy)
    if length < 1e-9:
        return []
    ux = dx / length
    uy = dy / length
    nx = -uy
    ny = ux
    h = w / 2.0
    return kdb.DPolygon([
        kdb.DPoint(snap(p1[0] + nx * h), snap(p1[1] + ny * h)),
        kdb.DPoint(snap(p2[0] + nx * h), snap(p2[1] + ny * h)),
        kdb.DPoint(snap(p2[0] - nx * h), snap(p2[1] - ny * h)),
        kdb.DPoint(snap(p1[0] - nx * h), snap(p1[1] - ny * h)),
    ])

def add_seg(cell, lay, p1, p2, w):
    cell.shapes(lay).insert(seg_poly(p1, p2, w))

def spiral_centerline(w, s, nturns):
    """Octagonal spiral centerline. Directions cycle E,NE,N,NW,W,SW,S,SE.
    Segment lengths grow so consecutive parallel runs are spaced by pitch=w+s.
    Returns on-grid points."""
    dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
    pitch = w + s
    pts = [(0.0, 0.0)]
    x, y = 0.0, 0.0
    nseg = 8 * nturns
    for i in range(nseg):
        d = dirs[i % 8]
        turn = i // 8
        side = i % 8
        if side in (0, 2, 4, 6):
            length = pitch * (2 * turn + 1)
        else:
            length = pitch * (2 * turn + 2)
        if d[0] != 0 and d[1] != 0:
            x += d[0] * length
            y += d[1] * length
        else:
            x += d[0] * length
            y += d[1] * length
        pts.append((snap(x), snap(y)))
    return pts

def build():
    ly = kdb.Layout()
    ly.dbu = 0.001
    top = ly.create_cell("spiral")

    m5 = layer(ly, "m5")
    m4 = layer(ly, "m4")
    via4 = layer(ly, "via4")
    lab5 = TECH["label"]["m5"]

    w = 4.0
    s = 2.0
    nturns = 4

    pts = spiral_centerline(w, s, nturns)

    overlap = 0.05
    for i in range(len(pts) - 1):
        p1 = pts[i]
        p2 = pts[i + 1]
        dx = p2[0] - p1[0]
        dy = p2[1] - p1[1]
        length = math.hypot(dx, dy)
        if length < 1e-9:
            continue
        ux = dx / length
        uy = dy / length
        ext1 = (p1[0] - ux * overlap, p1[1] - uy * overlap)
        ext2 = (p2[0] + ux * overlap, p2[1] + uy * overlap)
        add_seg(top, m5, ext1, ext2, w)

    via_size = TECH["cuts"]["via4"]["size"]
    enc5 = TECH["enc"][("m5", "via4")][0]
    enc4 = TECH["enc"][("m4", "via4")][0]
    pad = via_size / 2.0 + max(enc5, enc4) + 0.05

    # Inner end: via down to m4
    rect(top, m5, -pad, -pad, 2 * pad, 2 * pad)
    rect(top, m4, -pad, -pad, 2 * pad, 2 * pad)
    via(top, via4, 0.0, 0.0, via_size)

    # m4 underpass: right, up, left, up to clear coil
    ux = 22.0
    m4_pts = [(0.0, 0.0), (ux, 0.0), (ux, 28.0), (44.0, 28.0)]
    for i in range(len(m4_pts) - 1):
        add_seg(top, m4, m4_pts[i], m4_pts[i + 1], 2.0)

    via(top, via4, 44.0, 28.0, via_size)
    rect(top, m5, 44.0 - pad, 28.0 - pad, 2 * pad, 2 * pad)
    rect(top, m4, 44.0 - pad, 28.0 - pad, 2 * pad, 2 * pad)

    # Outer end pad
    ox, oy = pts[-1]
    rect(top, m5, ox - pad, oy - pad, 2 * pad, 2 * pad)

    label(top, lab5, "L", -pad, -pad)
    label(top, lab5, "L", ox, oy)

    bbox = top.bbox()
    print("bbox: (%.3f, %.3f) -> (%.3f, %.3f)" % (bbox.left, bbox.bottom, bbox.right, bbox.top))
    print("area: %.2f um^2" % ((bbox.right - bbox.left) * (bbox.top - bbox.bottom)))

    ly.write("spiral.gds")

if __name__ == "__main__":
    build()

