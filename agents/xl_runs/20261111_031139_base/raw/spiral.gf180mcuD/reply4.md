```
import klayout.db as kdb
import math

# -----------------------------------------------------------------------------
# PDK data for gf180mcuD
# -----------------------------------------------------------------------------
TECH = dict(
    name="gf180mcuD",
    grid=0.005,
    layers={
        "nwell": (21, 0), "pwell": (204, 0), "dnwell": (12, 0),
        "diff": (22, 0), "poly": (30, 0), "nplus": (32, 0), "pplus": (31, 0), "sab": (49, 0),
        "contact": (33, 0), "m1": (34, 0), "via1": (35, 0), "m2": (36, 0), "via2": (38, 0), "m3": (42, 0),
        "via3": (40, 0), "m4": (46, 0), "via4": (41, 0), "m5": (81, 0),
        "capm": (75, 0), "cap_mk": (117, 5), "res_mk": (110, 5), "hres": (62, 0), "dualgate": (55, 0),
        "v5_xtor": (112, 1), "nat": (5, 0), "diode_mk": (115, 5), "mos_cap_mk": (166, 5),
        "m1res": (110, 11), "m2res": (110, 12), "m3res": (110, 13), "m4res": (110, 14), "m5res": (110, 15),
        "boundary": (0, 0), "ind_mk": (151, 5),
    },
    label={"poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
           "nwell": (21, 10), "pwell": (204, 10)},
    stack=["m1", "m2", "m3", "m4", "m5"],
    metal1="m1",
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"nwell": 0.86, "diff": 0.22, "poly": 0.18, "nplus": 0.40, "pplus": 0.40, "m1": 0.23, "m2": 0.28,
           "m3": 0.28, "m4": 0.28, "m5": 0.44, "capm": 5.0},
    space={
        ("nwell", "nwell"): 0.60, ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("nplus", "nplus"): 0.40, ("pplus", "pplus"): 0.40,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28, ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
        ("nwell", "diff"): 0.43, ("capm", "capm"): 0.60,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06), ("m2", "via2"): (0.01, 0.06),
        ("m3", "via2"): (0.01, 0.06), ("m3", "via3"): (0.01, 0.06), ("m4", "via3"): (0.01, 0.06),
        ("m4", "via4"): (0.01, 0.06), ("m5", "via4"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
        ("nwell", "diff"): (0.43, 0.43),
    },
    area={"m1": 0.1444, "m2": 0.1444, "m3": 0.1444, "m4": 0.1444, "m5": 0.5625, "nplus": 0.35, "pplus": 0.35,
          "diff": 0.2025},
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        polycontact_implant_space=0.0,
        gate_space=0.24,
        tap_diff_space=0.32,
        latchup_dist=15.0,
        wide_metal=10.0,
    ),
    roles=dict(poly="poly", contact="contact", boundary="boundary", nwell="nwell"),
    contact_extra={},
    devices={
        "nmos": dict(type="mos", model="nfet_03v3", diff="diff", implant="nplus", well=None,
                     lmin=0.28, wmin=0.22, bulk="VSS", implant_gate_ext=0.23),
        "pmos": dict(type="mos", model="pfet_03v3", diff="diff", implant="pplus", well="nwell",
                     lmin=0.28, wmin=0.22, bulk="VDD", implant_gate_ext=0.23),
        "ptap": dict(type="tap", diff="diff", implant="pplus", well=None),
        "ntap": dict(type="tap", diff="diff", implant="nplus", well="nwell", well_enc=0.12),
        "res_poly": dict(type="res", model="ppolyf_u", body="poly", markers=[("res_mk", 0.0), ("sab", 0.28)],
                         covers=[("pplus", 0.30, 0.30)], head_space=0.22, wmin=0.80, lmin=1.0, terminals=3,
                         bulk="VSS", params={"w": "r_width", "l": "r_length"}),
        "cap_mim": dict(type="mim", model="cap_mim_2f0_m4m5_noshield", bottom="m4", plate="capm", top="m5",
                        cut="via4", wmin=5.0, bottom_enc=0.60, cut_enc=0.40, markers=[("cap_mk", -0.40)],
                        params={"w": "c_width", "l": "c_length"}),
    },
    libs=[
        dict(prefix="gf180mcu_fd_sc_mcu7t5v0__",
             gds="libs.ref/gf180mcu_fd_sc_mcu7t5v0/gds/gf180mcu_fd_sc_mcu7t5v0.gds",
             spice="libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice"),
    ],
    signoff=dict(magicrc="libs.tech/magic/gf180mcuD.magicrc", netgen="libs.tech/netgen/gf180mcuD_setup.tcl",
                 drc_style="drc(full)",
                 klayout=dict(deck="libs.tech/klayout/tech/drc/gf180mcu.drc", top="topcell",
                              args=dict(variant="D", run_mode="flat"),
                              waive={r: "die-level density / fill rule, not applicable to a block"
                                     for r in ("M1.4", "M2.4", "M3.4", "M4.4", "M5.4", "MT.3", "PL.8",
                                               "DCF.1a", "DCF.1b")})),
    supplies=dict(power="VDD", ground="VSS"),
    spice_unit="u",
    conn=dict(conductors=["poly", "diff"],
              cut_by={"diff": ["poly"], "poly": ["res_mk"], "m1": ["m1res"], "m2": ["m2res"], "m3": ["m3res"],
                      "m4": ["m4res"], "m5": ["m5res"]},
              plates={"capm": "via4"}),
)

# -----------------------------------------------------------------------------
# Layout
# -----------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("spiral")

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def label_layer(metal):
    return ly.layer(*TECH["label"][metal])

M5 = layer("m5")
M4 = layer("m4")
VIA4 = layer("via4")
M5_LAB = label_layer("m5")
M4_LAB = label_layer("m4")

GRID = 0.01
def g(x):
    return round(x / GRID) * GRID

def box(cell, lay, x1, y1, x2, y2):
    cell.shapes(lay).insert(kdb.DBox(g(x1), g(y1), g(x2), g(y2)))

def via(cell, lay, x, y, size):
    box(cell, lay, x - size / 2, y - size / 2, x + size / 2, y + size / 2)

def pin_label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(kdb.DVector(g(x), g(y)))))

# -----------------------------------------------------------------------------
# Spiral parameters
# -----------------------------------------------------------------------------
w = 5.0          # trace width (>= 4.0 um)
gap = 6.0        # edge-to-edge gap between turns (>= m5 space 0.46 um)
pitch = w + gap  # centerline pitch between turns = 11.0 um
n_turns = 3.5    # >= 3 full turns
start_len = 6.0  # first segment length
step = 2 * pitch  # length increase per turn = 22.0 um

# Centerline directions: E, NE, N, NW, W, SW, S, SE (45-degree steps)
dirs = [
    (1.0, 0.0),
    (1.0, 1.0),
    (0.0, 1.0),
    (-1.0, 1.0),
    (-1.0, 0.0),
    (-1.0, -1.0),
    (0.0, -1.0),
    (1.0, -1.0),
]

# Build centerline points. For 45-degree segments use dx=dy=S (on grid).
# Segment lengths grow so successive turns are separated by pitch.
pts = [(0.0, 0.0)]
cx, cy = 0.0, 0.0
n_segments = int(math.ceil(n_turns * 8))
for i in range(n_segments):
    dx, dy = dirs[i % 8]
    turn = i // 8
    length = start_len + turn * step
    if abs(dx) == 1 and abs(dy) == 1:
        # 45-degree segment: use dx=dy=S on grid
        S = g(length / math.sqrt(2))
        cx += dx * S
        cy += dy * S
    else:
        cx += dx * length
        cy += dy * length
    pts.append((g(cx), g(cy)))

# Translate so bounding box is centered at origin
xs = [p[0] for p in pts]
ys = [p[1] for p in pts]
box_cx = (min(xs) + max(xs)) / 2.0
box_cy = (min(ys) + max(ys)) / 2.0
pts = [(g(x - box_cx), g(y - box_cy)) for x, y in pts]

inner_end = pts[0]
outer_end = pts[-1]

# -----------------------------------------------------------------------------
# Build constant-width polygon from centerline using offset-and-intersect.
# All edges end up horizontal, vertical, or 45 degrees. All vertices on grid.
# -----------------------------------------------------------------------------
hw = w / 2.0  # 2.5 um, on grid

def unit(dx, dy):
    L = math.hypot(dx, dy)
    return (dx / L, dy / L)

def left_normal(dx, dy):
    ux, uy = unit(dx, dy)
    return (-uy, ux)

def offset_point(px, py, nx, ny, dist):
    return (g(px + nx * dist), g(py + ny * dist))

def line_intersection(p1, d1, p2, d2):
    """Intersection of line p1 + t*d1 and p2 + s*d2. Returns (x, y) on grid."""
    x1, y1 = p1
    x2, y2 = p2
    dx1, dy1 = d1
    dx2, dy2 = d2
    den = dx1 * dy2 - dy1 * dx2
    if abs(den) < 1e-9:
        return None
    t = ((x2 - x1) * dy2 - (y2 - y1) * dx2) / den
    ix = x1 + t * dx1
    iy = y1 + t * dy1
    return (g(ix), g(iy))

# Compute left and right offset points for each segment vertex
n = len(pts)
left_pts = []
right_pts = []
for i in range(n):
    # Determine normal at this point based on adjacent segments
    if i == 0:
        dx, dy = pts[1][0] - pts[0][0], pts[1][1] - pts[0][1]
    elif i == n - 1:
        dx, dy = pts[n - 1][0] - pts[n - 2][0], pts[n - 1][1] - pts[n - 2][1]
    else:
        dx1, dy1 = pts[i][0] - pts[i - 1][0], pts[i][1] - pts[i - 1][1]
        dx2, dy2 = pts[i + 1][0] - pts[i][0], pts[i + 1][1] - pts[i][1]
        # Use average direction for normal at vertex
        dx, dy = dx1 + dx2, dy1 + dy2
    nx, ny = left_normal(dx, dy)
    left_pts.append(offset_point(pts[i][0], pts[i][1], nx, ny, hw))
    right_pts.append(offset_point(pts[i][0], pts[i][1], nx, ny, -hw))

# Build outer boundary: for each segment, go from left_pts[i] to intersection
# of left offset lines of segment i and i+1
outer = []
for i in range(n - 1):
    p1 = pts[i]
    p2 = pts[i + 1]
    dx, dy = p2[0] - p1[0], p2[1] - p1[1]
    ux, uy = unit(dx, dy)
    # Left offset line of segment i: passes through left_pts[i], direction (ux, uy)
    # Left offset line of segment i+1: passes through left_pts[i+1], direction of seg i+1
    if i + 1 < n - 1:
        dx2, dy2 = pts[i + 2][0] - pts[i + 1][0], pts[i + 2][1] - pts[i + 1][1]
        ux2, uy2 = unit(dx2, dy2)
        corner = line_intersection(left_pts[i], (ux, uy), left_pts[i + 1], (ux2, uy2))
    else:
        corner = left_pts[i + 1]
    if i == 0:
        outer.append(left_pts[0])
    if corner is not None:
        outer.append(corner)
    else:
        outer.append(left_pts[i + 1])

# Build inner boundary (reverse order)
inner = []
for i in range(n - 1, 0, -1):
    p1 = pts[i]
    p2 = pts[i - 1]
    dx, dy = p2[0] - p1[0], p2[1] - p1[1]
    ux, uy = unit(dx, dy)
    if i - 1 > 0:
        dx2, dy2 = pts[i - 2][0] - pts[i - 1][0], pts[i - 2][1] - pts[i - 1][1]
        ux2, uy2 = unit(dx2, dy2)
        corner = line_intersection(right_pts[i], (ux, uy), right_pts[i - 1], (ux2, uy2))
    else:
        corner = right_pts[i - 1]
    if i == n - 1:
        inner.append(right_pts[n - 1])
    if corner is not None:
        inner.append(corner)
    else:
        inner.append(right_pts[i - 1])

# Combine into full polygon: outer + inner (inner already in reverse)
poly_pts = outer + inner
poly = kdb.DPolygon([kdb.DPoint(x, y) for x, y in poly_pts])

# Merge and insert
reg = kdb.Region()
reg.insert(poly)
reg = reg.merge()
top.shapes(M5).insert(reg)

# -----------------------------------------------------------------------------
# Inner end: via4 down to m4 underpass (pad large enough for m5 min area)
# -----------------------------------------------------------------------------
ix, iy = inner_end
via_size = TECH["cuts"]["via4"]["size"]  # 0.26 um
pad = 0.40  # m5 pad 1.06 x 1.06 um -> area ~1.12 um^2 > 0.5625 um^2 (MT.4)
box(top, M5, ix - via_size / 2 - pad, iy - via_size / 2 - pad,
    ix + via_size / 2 + pad, iy + via_size / 2 + pad)
box(top, M4, ix - via_size / 2 - pad, iy - via_size / 2 - pad,
    ix + via_size / 2 + pad, iy + via_size / 2 + pad)
via(top, VIA4, ix, iy, via_size)

# Underpass on m4: from inner end, run West past the coil bounding box
coil_half_x = (max(xs) - min(xs)) / 2.0 + w + 10.0
coil_half_y = (max(ys) - min(ys)) / 2.0 + w + 10.0
run_len = max(coil_half_x, coil_half_y) + 20.0
end_x = g(ix - run_len)
end_y = iy
box(top, M4, min(ix, end_x) - w / 2, min(iy, end_y) - w / 2,
    max(ix, end_x) + w / 2, max(iy, end_y) + w / 2)

# -----------------------------------------------------------------------------
# Outer end pad and labels (single net L)
# -----------------------------------------------------------------------------
ox, oy = outer_end
box(top, M5, ox - w / 2 - 2.0, oy - w / 2 - 2.0,
    ox + w / 2 + 2.0, oy + w / 2 + 2.0)
pin_label(top, M5_LAB, "L", ox, oy)
pin_label(top, M4_LAB, "L", end_x, end_y)

# -----------------------------------------------------------------------------
# Write GDS
# -----------------------------------------------------------------------------
ly.write("spiral.gds")
print("wrote spiral.gds")
print(f"bbox: {top.bbox()}")
print(f"area: {top.bbox().width() * top.bbox().height():.2f} um^2")
print(f"turns: {n_turns}, width: {w} um, gap: {gap} um")
```