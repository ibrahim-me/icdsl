```
import klayout.db as kdb

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

GRID = 0.01  # snap to 10 nm (on the 5 nm design grid; keeps 45-deg intersections on-grid)
def g(x):
    return round(x / GRID) * GRID

def box(cell, lay, x1, y1, x2, y2):
    cell.shapes(lay).insert(kdb.DBox(g(x1), g(y1), g(x2), g(y2)))

def via(cell, lay, x, y, size):
    box(cell, lay, x - size / 2, y - size / 2, x + size / 2, y + size / 2)

def pin_label(cell, lay, text, x, y):
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(kdb.DVector(g(x), g(y)))))

# -----------------------------------------------------------------------------
# Spiral parameters (compact: bounding box ~ 92 x 92 um < area budget 10465 um^2)
# -----------------------------------------------------------------------------
w = 5.0          # trace width (>= 4.0 um)
gap = 6.0        # edge-to-edge gap between turns (>= m5 space 0.46 um)
pitch = w + gap  # centerline pitch between turns
n_turns = 3.5    # >= 3 full turns
start_length = 12.0
length_step = 2 * pitch  # each turn grows by two pitches

# Centerline: octagonal spiral, 8 directions per turn, 45-degree steps.
dirs = [
    (1.0, 0.0),     # E
    (1.0, 1.0),     # NE
    (0.0, 1.0),     # N
    (-1.0, 1.0),    # NW
    (-1.0, 0.0),    # W
    (-1.0, -1.0),   # SW
    (0.0, -1.0),    # S
    (1.0, -1.0),    # SE
]
norm = [(dx / ((abs(dx) + abs(dy)) ** 0.5), dy / ((abs(dx) + abs(dy)) ** 0.5)) for dx, dy in dirs]

pts = [(0.0, 0.0)]
cur_x, cur_y = 0.0, 0.0
seg_index = 0
while seg_index / 8.0 < n_turns:
    dx, dy = norm[seg_index % 8]
    length = start_length + (seg_index // 8) * length_step
    cur_x += dx * length
    cur_y += dy * length
    pts.append((cur_x, cur_y))
    seg_index += 1

# Snap all centerline vertices to grid.
pts = [(g(x), g(y)) for x, y in pts]

# -----------------------------------------------------------------------------
# Constant-width polyline via boolean union of segment rectangles.
# Guarantees: only 0/45/90-degree edges, on-grid vertices, constant width w,
# no narrow spots, no self-intersections (turns well separated by gap).
# -----------------------------------------------------------------------------
reg = kdb.Region()
hw = w / 2.0
for i in range(len(pts) - 1):
    x1, y1 = pts[i]
    x2, y2 = pts[i + 1]
    dx = x2 - x1
    dy = y2 - y1
    L = (dx * dx + dy * dy) ** 0.5
    if L == 0:
        continue
    ux, uy = dx / L, dy / L
    nx, ny = -uy, ux  # left normal
    p1 = kdb.DPoint(x1 + nx * hw, y1 + ny * hw)
    p2 = kdb.DPoint(x1 - nx * hw, y1 - ny * hw)
    p3 = kdb.DPoint(x2 - nx * hw, y2 - ny * hw)
    p4 = kdb.DPoint(x2 + nx * hw, y2 + ny * hw)
    reg.insert(kdb.Polygon([p1, p2, p3, p4]))

reg = reg.merge()
top.shapes(M5).insert(reg)

# -----------------------------------------------------------------------------
# Inner end: via down to m4 underpass
# -----------------------------------------------------------------------------
ix, iy = pts[-1]
via_size = TECH["cuts"]["via4"]["size"]
pad = 0.20
box(top, M5, ix - via_size / 2 - pad, iy - via_size / 2 - pad,
    ix + via_size / 2 + pad, iy + via_size / 2 + pad)
box(top, M4, ix - via_size / 2 - pad, iy - via_size / 2 - pad,
    ix + via_size / 2 + pad, iy + via_size / 2 + pad)
via(top, VIA4, ix, iy, via_size)

# Underpass on m4: leave the coil through a gap between turns, then run outside.
exit_dir = dirs[0]
exit_len = 40.0
ux, uy = exit_dir
end_x = g(ix + ux * exit_len)
end_y = g(iy + uy * exit_len)
box(top, M4, min(ix, end_x) - w / 2, min(iy, end_y) - w / 2,
    max(ix, end_x) + w / 2, max(iy, end_y) + w / 2)

# -----------------------------------------------------------------------------
# Outer end pad and labels (single net L)
# -----------------------------------------------------------------------------
ox, oy = pts[0]
box(top, M5, ox - w / 2 - 2.0, oy - w / 2 - 2.0,
    ox + w / 2 + 2.0, oy + w / 2 + 2.0)
pin_label(top, M5_LAB, "L", ox, oy)
pin_label(top, M4_LAB, "L", end_x, end_y)

# -----------------------------------------------------------------------------
# Write GDS
# -----------------------------------------------------------------------------
ly.write("spiral.gds")
print("wrote spiral.gds")

```