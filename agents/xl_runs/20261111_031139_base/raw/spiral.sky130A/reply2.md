```
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

# ---------------------------------------------------------------- helpers
def layer(ly, name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def rect(cell, lay, x, y, w, h):
    cell.shapes(lay).insert(kdb.DBox(x, y, x + w, y + h))

def via(cell, lay, x, y, size):
    hs = size / 2.0
    cell.shapes(lay).insert(kdb.DBox(x - hs, y - hs, x + hs, y + hs))

def label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(x, y)))

def seg_poly(p1, p2, w):
    """Rectangle from p1 to p2 with width w. Edges are parallel/perp to segment,
    so for 45-deg segments edges are at 45/135 deg (allowed)."""
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]
    length = (dx * dx + dy * dy) ** 0.5
    if length < 1e-9:
        return []
    ux = dx / length
    uy = dy / length
    nx = -uy
    ny = ux
    h = w / 2.0
    return kdb.DPolygon([
        kdb.DPoint(p1[0] + nx * h, p1[1] + ny * h),
        kdb.DPoint(p2[0] + nx * h, p2[1] + ny * h),
        kdb.DPoint(p2[0] - nx * h, p2[1] - ny * h),
        kdb.DPoint(p1[0] - nx * h, p1[1] - ny * h),
    ])

def add_seg(cell, lay, p1, p2, w):
    cell.shapes(lay).insert(seg_poly(p1, p2, w))

# ---------------------------------------------------------------- spiral generator
def spiral_centerline(w, s, nturns):
    """
    Octagonal spiral centerline. Directions cycle: E, NE, N, NW, W, SW, S, SE.
    Each turn around adds `pitch` to the radius. Segment lengths grow so that
    consecutive parallel runs are spaced by `pitch` (edge-to-edge = s).
    Returns list of (x,y) points.
    """
    dirs = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
    pitch = w + s
    pts = [(0.0, 0.0)]
    x, y = 0.0, 0.0
    nseg = 8 * nturns
    for i in range(nseg):
        d = dirs[i % 8]
        turn = i // 8
        side = i % 8
        # length grows each turn; within a turn, axial segments are longer than
        # diagonal ones so that the spiral closes properly with spacing `pitch`
        if d[0] != 0 and d[1] != 0:
            length = pitch * turn + 0.5 * w   # diagonal (chamfer) segment
        else:
            length = pitch * (turn + 1) + 0.5 * w   # axial segment
        if d[0] != 0 and d[1] != 0:
            # diagonal: move by `length` in x and y (45-deg line)
            x += d[0] * length
            y += d[1] * length
        else:
            x += d[0] * length
            y += d[1] * length
        pts.append((x, y))
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

    # Spiral parameters: width 4.0 um (>= 4.0 requirement, >= 1.6 DRC min)
    w = 4.0
    s = 2.0          # edge-to-edge spacing between turns (>= 1.6 DRC min)
    nturns = 4       # full turns (> 3)

    pts = spiral_centerline(w, s, nturns)

    # Draw each segment of the spiral on m5. Segments overlap slightly at
    # corners to guarantee electrical continuity without creating narrow spots.
    overlap = 0.05
    for i in range(len(pts) - 1):
        p1 = pts[i]
        p2 = pts[i + 1]
        # extend each segment a tiny bit past its nominal end for corner overlap
        dx = p2[0] - p1[0]
        dy = p2[1] - p1[1]
        length = (dx * dx + dy * dy) ** 0.5
        if length < 1e-9:
            continue
        ux = dx / length
        uy = dy / length
        ext1 = (p1[0] - ux * overlap, p1[1] - uy * overlap)
        ext2 = (p2[0] + ux * overlap, p2[1] + uy * overlap)
        add_seg(top, m5, ext1, ext2, w)

    # Inner end: start point (0,0) -> via down to m4
    via_size = TECH["cuts"]["via4"]["size"]
    enc5 = TECH["enc"][("m5", "via4")][0]
    enc4 = TECH["enc"][("m4", "via4")][0]
    pad = via_size / 2.0 + max(enc5, enc4) + 0.05

    # m5 pad around inner via
    rect(top, m5, -pad, -pad, 2 * pad, 2 * pad)
    via(top, via4, 0.0, 0.0, via_size)

    # m4 underpass: from via, run right, up, left to clear coil, then up to m5 pad
    ux = 22.0
    uy = 0.0
    m4_pts = [(0.0, 0.0), (ux, 0.0), (ux, 28.0), (44.0, 28.0)]
    for i in range(len(m4_pts) - 1):
        add_seg(top, m4, m4_pts[i], m4_pts[i + 1], 2.0)

    # via up at outer end of underpass
    via(top, via4, 44.0, 28.0, via_size)
    rect(top, m5, 44.0 - pad, 28.0 - pad, 2 * pad, 2 * pad)

    # Outer end of spiral: pad around last point
    ox, oy = pts[-1]
    rect(top, m5, ox - pad, oy - pad, 2 * pad, 2 * pad)

    # Pin label on m5
    label(top, lab5, "L", -pad, -pad)
    label(top, lab5, "L", ox, oy)

    bbox = top.bbox()
    print("bbox: (%.3f, %.3f) -> (%.3f, %.3f)" % (bbox.left, bbox.bottom, bbox.right, bbox.top))
    print("area: %.2f um^2" % ((bbox.right - bbox.left) * (bbox.top - bbox.bottom)))

    ly.write("spiral.gds")

if __name__ == "__main__":
    build()

```