```python
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data (sky130A) – layers, rules and device parameters
# ---------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "lvtn": (125, 44), "hvtp": (78, 44), "hvi": (75, 20), "hvntm": (125, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20), "via2": (69, 44), "m3": (70, 20),
        "via3": (70, 44), "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
        "capm": (89, 44), "cap2m": (97, 44), "rpm": (86, 20), "urpm": (79, 20),
        "polyres": (66, 13), "diffres": (65, 13), "lires": (67, 13),
        "m1res": (68, 13), "m2res": (69, 13), "m3res": (70, 13), "m4res": (71, 13), "m5res": (72, 13),
        "boundary": (235, 4), "areaid_sc": (81, 4), "inductor": (82, 24),
    },
    label={
        "poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5), "m3": (70, 5),
        "m4": (71, 5), "m5": (72, 5), "nwell": (64, 5), "pwell": (64, 59),
    },
    pin={
        "poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16), "m3": (70, 16),
        "m4": (71, 16), "m5": (72, 16), "nwell": (64, 16), "pwell": (122, 16),
    },
    stack=["li", "m1", "m2", "m3", "m4", "m5"],
    metal1="m1",
    cuts={
        "licon": dict(size=0.17, space=0.17, lower=["diff", "tap", "poly"], upper="li"),
        "mcon": dict(size=0.17, space=0.19, lower="li", upper="m1"),
        "via": dict(size=0.15, space=0.17, lower="m1", upper="m2"),
        "via2": dict(size=0.20, space=0.20, lower="m2", upper="m3"),
        "via3": dict(size=0.20, space=0.20, lower="m3", upper="m4"),
        "via4": dict(size=0.80, space=0.80, lower="m4", upper="m5"),
    },
    width={
        "nwell": 0.84, "diff": 0.15, "tap": 0.15, "poly": 0.15, "npc": 0.27, "nsdm": 0.38,
        "psdm": 0.38, "lvtn": 0.38, "hvtp": 0.38, "li": 0.17, "m1": 0.14, "m2": 0.14,
        "m3": 0.30, "m4": 0.30, "m5": 1.60, "capm": 1.0,
    },
    space={
        ("nwell", "nwell"): 1.27, ("diff", "diff"): 0.27, ("tap", "tap"): 0.27,
        ("diff", "tap"): 0.27, ("poly", "poly"): 0.21, ("poly", "diff"): 0.075,
        ("poly", "tap"): 0.055, ("nsdm", "nsdm"): 0.38, ("psdm", "psdm"): 0.38,
        ("npc", "npc"): 0.27, ("li", "li"): 0.17, ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
        ("m3", "m3"): 0.30, ("m4", "m4"): 0.30, ("m5", "m5"): 1.60,
        ("nwell", "diff"): 0.34, ("capm", "capm"): 0.84,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06), ("tap", "licon"): (0.0, 0.12),
        ("poly", "licon"): (0.05, 0.08), ("li", "licon"): (0.0, 0.08),
        ("li", "mcon"): (0.0, 0.0), ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085), ("m2", "via"): (0.055, 0.085),
        ("m2", "via2"): (0.04, 0.085), ("m3", "via2"): (0.065, 0.065),
        ("m3", "via3"): (0.06, 0.09), ("m4", "via3"): (0.065, 0.065),
        ("m4", "via4"): (0.19, 0.19), ("m5", "via4"): (0.31, 0.31),
        ("nsdm", "diff"): (0.125, 0.125), ("psdm", "diff"): (0.125, 0.125),
        ("nsdm", "tap"): (0.125, 0.125), ("psdm", "tap"): (0.125, 0.125),
        ("nwell", "diff"): (0.18, 0.18), ("nwell", "tap"): (0.18, 0.18),
        ("npc", "licon"): (0.10, 0.10), ("m3", "capm"): (0.14, 0.14),
        ("capm", "via3"): (0.14, 0.14),
    },
    area={"li": 0.0561, "m1": 0.083, "m2": 0.0676, "m3": 0.24, "m4": 0.24, "m5": 4.0,
          "nsdm": 0.255, "psdm": 0.255, "nwell": 0.0},
    rules=dict(
        gate_contact_space=0.055, poly_endcap=0.13, diff_ext_gate=0.25,
        polycontact_diff_space=0.19, polycontact_implant_space=0.11,
        gate_space=0.21, tap_diff_space=0.27, latchup_dist=15.0, wide_metal=3.0,
    ),
    roles=dict(poly="poly", contact="licon", boundary="boundary", nwell="nwell"),
    contact_extra={"poly": [("npc", 0.10)]},
    devices={
        "nmos": dict(type="mos", model="sky130_fd_pr__nfet_01v8", diff="diff",
                     implant="nsdm", well=None, lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(type="mos", model="sky130_fd_pr__pfet_01v8", diff="diff",
                     implant="psdm", well="nwell", lmin=0.15, wmin=0.42, bulk="VDD"),
        "nmos_lvt": dict(type="mos", model="sky130_fd_pr__nfet_01v8_lvt", diff="diff",
                         implant="nsdm", well=None, lmin=0.15, wmin=0.42, bulk="VSS",
                         gate_extra=[("lvtn", 0.18)]),
        "pmos_hvt": dict(type="mos", model="sky130_fd_pr__pfet_01v8_hvt", diff="diff",
                         implant="psdm", well="nwell", lmin=0.15, wmin=0.42, bulk="VDD",
                         gate_extra=[("hvtp", 0.18)]),
        "pmos_lvt": dict(type="mos", model="sky130_fd_pr__pfet_01v8_lvt", diff="diff",
                         implant="psdm", well="nwell", lmin=0.35, wmin=0.42, bulk="VDD",
                         gate_extra=[("lvtn", 0.18)]),
        "ptap": dict(type="tap", diff="tap", implant="psdm", well=None),
        "ntap": dict(type="tap", diff="tap", implant="nsdm", well="nwell"),
        "res_poly": dict(type="res", model="sky130_fd_pr__res_generic_po", body="poly",
                         markers=[("polyres", 0.0)], wmin=0.33, lmin=0.5, terminals=2,
                         contact="poly"),
        "cap_mim": dict(type="mim", model="sky130_fd_pr__cap_mim_m3_1", bottom="m3",
                        plate="capm", top="m4", cut="via3", wmin=2.0, bottom_enc=0.14,
                        cut_enc=0.2),
    },
    libs=[
        dict(prefix="sky130_fd_sc_hd__",
             gds="libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds",
             spice="libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice"),
        dict(prefix="sky130_fd_pr__", gds="libs.ref/sky130_fd_pr/gds/sky130_fd_pr.gds"),
    ],
    signoff=dict(magicrc="libs.tech/magic/sky130A.magicrc",
                 netgen="libs.tech/netgen/sky130A_setup.tcl", drc_style="drc(full)",
                 klayout=dict(deck="libs.tech/klayout/drc/sky130A_mr.drc", top="top_cell",
                              args=dict(feol="true", beol="true", offgrid="true"), waive={})),
    supplies=dict(power="VDD", ground="VSS"),
    conn=dict(conductors=["poly", "diff", "tap"],
              cut_by={"diff": ["poly"], "poly": ["polyres"], "li": ["lires"],
                      "m1": ["m1res"], "m2": ["m2res"], "m3": ["m3res"],
                      "m4": ["m4res"], "m5": ["m5res"]},
              plates={"capm": "via3"}),
)

# ---------------------------------------------------------------------------
# Layout helpers
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001  # 1 nm database unit
top = ly.create_cell("cdac6")

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def label_layer(name):
    return ly.layer(*TECH["label"][name])

def pin_layer(name):
    return ly.layer(*TECH["pin"][name])

def dbu(um):
    return int(round(um / ly.dbu))

def box(Cell, lay, x1, y1, x2, y2):
    Cell.shapes(lay).insert(kdb.DBox(x1, y1, x2, y2))

def text(Cell, lay, s, x, y):
    Cell.shapes(lay).insert(kdb.DText(s, kdb.DTrans(x, y)))

def via(Cell, cut_name, x, y):
    """Place a single via/contact at (x,y) um."""
    c = TECH["cuts"][cut_name]
    s = c["size"]
    box(Cell, layer(cut_name), x - s / 2, y - s / 2, x + s / 2, y + s / 2)

def rect(Cell, lay, x, y, w, h):
    box(Cell, lay, x, y, x + w, y + h)

# ---------------------------------------------------------------------------
# Unit MIM capacitor (sky130_fd_pr__cap_mim_m3_1, w=5 l=5)
# ---------------------------------------------------------------------------
CAP_W = 5.0
CAP_H = 5.0
CAPM_ENC = 0.14          # capm over m3 on every side
VIA3_ENC = 0.2           # via3 over capm on every side (cut_enc)
VIA3_SIZE = TECH["cuts"]["via3"]["size"]   # 0.20
VIA3_SPACE = TECH["cuts"]["via3"]["space"] # 0.20

# Derived dimensions
m3_w = CAP_W
m3_h = CAP_H
capm_w = m3_w + 2 * CAPM_ENC
capm_h = m3_h + 2 * CAPM_ENC
# via3 array inside capm, keep VIA3_ENC from capm edge
via_pitch = VIA3_SIZE + VIA3_SPACE
via_start = CAPM_ENC + VIA3_ENC
via_usable_w = capm_w - 2 * via_start
via_usable_h = capm_h - 2 * via_start
nx = max(1, int(via_usable_w // via_pitch) + 1)
ny = max(1, int(via_usable_h // via_pitch) + 1)
# centre the array
vx0 = (capm_w - ((nx - 1) * via_pitch + VIA3_SIZE)) / 2.0
vy0 = (capm_h - ((ny - 1) * via_pitch + VIA3_SIZE)) / 2.0

# m4 top plate: cover capm + via3 enc on all sides
m4_w = capm_w + 2 * VIA3_ENC
m4_h = capm_h + 2 * VIA3_ENC

def unit_cap(Cell, cx, cy):
    """Place one unit capacitor centred at (cx,cy). Returns nothing."""
    # m3 bottom plate
    rect(Cell, layer("m3"), cx - m3_w / 2, cy - m3_h / 2, m3_w, m3_h)
    # capm dielectric
    rect(Cell, layer("capm"), cx - capm_w / 2, cy - capm_h / 2, capm_w, capm_h)
    # via3 array (connects m3 to m4)
    for ix in range(nx):
        for iy in range(ny):
            vx = cx - capm_w / 2 + via_start + vx0 + ix * via_pitch
            vy = cy - capm_h / 2 + via_start + vy0 + iy * via_pitch
            via(Cell, "via3", vx, vy)
    # m4 top plate
    rect(Cell, layer("m4"), cx - m4_w / 2, cy - m4_h / 2, m4_w, m4_h)

# ---------------------------------------------------------------------------
# Bit assignment: 64 units, interleaved within each bit group
# ---------------------------------------------------------------------------
# counts per bit (MSB..LSB) and VSS gets the remaining unit
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
# build ordered list of (net, unit_index) interleaved
assignments = []
for bit, cnt in bit_counts.items():
    for i in range(cnt):
        assignments.append((bit, i))
# total units
assert len(assignments) == 64

# ---------------------------------------------------------------------------
# Placement: 8 columns x 8 rows, unit pitch 6 um (fits area budget)
# ---------------------------------------------------------------------------
PITCH_X = 6.0
PITCH_Y = 6.0
COLS = 8
ROWS = 8
ORIGIN_X = 0.0
ORIGIN_Y = 0.0

# place units row-major
for idx, (net, _) in enumerate(assignments):
    col = idx % COLS
    row = idx // COLS
    cx = ORIGIN_X + col * PITCH_X + PITCH_X / 2
    cy = ORIGIN_Y + row * PITCH_Y + PITCH_Y / 2
    unit_cap(top, cx, cy)

# ---------------------------------------------------------------------------
# Routing: vertical bit buses on m3, horizontal TOP bus on m4
# ---------------------------------------------------------------------------
# m3 vertical buses: one per bit net, spaced across the array
# We route each bit's units to a vertical m3 bus at a fixed x position.
# Bus x positions: spread across array width
ARRAY_W = COLS * PITCH_X
ARRAY_H = ROWS * PITCH_Y
BUS_X = {}
bus_pitch = ARRAY_W / (len(bit_counts) + 1)
for i, bit in enumerate(bit_counts.keys()):
    BUS_X[bit] = ORIGIN_X + (i + 1) * bus_pitch

# connect each unit's m3 plate to its bit bus
# We'll drop a via3 from m3 plate to m4? No: bottom plate is m3, connect m3 to bus.
# Since m3 plate is already on m3, we just need to extend m3 to the bus.
# Simplest: draw m3 vertical bus and connect each unit's m3 to it with m3 segments.
# To avoid DRC, keep m3 width 0.3 (min) and space 0.3.
M3_BUS_W = 0.30
M3_BUS_SPACE = 0.30

# draw vertical m3 buses
for bit, bx in BUS_X.items():
    rect(top, layer("m3"), bx - M3_BUS_W / 2, ORIGIN_Y, bx + M3_BUS_W / 2,
         ORIGIN_Y + ARRAY_H)

# connect each unit to its bus: horizontal m3 segment from unit centre to bus
for idx, (net, _) in enumerate(assignments):
    col = idx % COLS
    row = idx // COLS
    cx = ORIGIN_X + col * PITCH_X + PITCH_X / 2
    cy = ORIGIN_Y + row * PITCH_Y + PITCH_Y / 2
    bx = BUS_X[net]
    # horizontal segment from unit edge to bus edge
    x1 = min(cx + m3_w / 2, bx - M3_BUS_W / 2) if cx < bx else max(cx - m3_w / 2, bx + M3_BUS_W / 2)
    x2 = max(cx + m3_w / 2, bx - M3_BUS_W / 2) if cx < bx else min(cx - m3_w / 2, bx + M3_BUS_W / 2)
    if abs(x2 - x1) > 0.001:
        rect(top, layer("m3"), x1, cy - M3_BUS_W / 2, x2, cy + M3_BUS_W / 2)

# m4 horizontal TOP bus: one long m4 stripe across top of array, all m4 plates connect
TOP_BUS_Y = ORIGIN_Y + ARRAY_H + 2.0
TOP_BUS_H = 1.0
rect(top, layer("m4"), ORIGIN_X - 1.0, TOP_BUS_Y, ORIGIN_X + ARRAY_W + 2.0, TOP_BUS_Y + TOP_BUS_H)

# connect each unit's m4 plate to TOP bus: vertical m4 segment from unit to bus
for idx, (net, _) in enumerate(assignments):
    col = idx % COLS
    row = idx // COLS
    cx = ORIGIN_X + col * PITCH_X + PITCH_X / 2
    cy = ORIGIN_Y + row * PITCH_Y + PITCH_Y / 2
    # vertical m4 from unit top edge to bus bottom edge
    y1 = cy + m4_h / 2
    y2 = TOP_BUS_Y
    if abs(y2 - y1) > 0.001:
        rect(top, layer("m4"), cx - M3_BUS_W / 2, y1, cx + M3_BUS_W / 2, y2)

# ---------------------------------------------------------------------------
# Pins (labels on appropriate metal label layers)
# ---------------------------------------------------------------------------
# TOP pin on m4 label layer
text(top, label_layer("m4"), "TOP", ORIGIN_X - 2.0, TOP_BUS_Y + TOP_BUS_H / 2)
# bit pins on m3 label layer at bus top
for bit, bx in BUS_X.items():
    text(top, label_layer("m3"), bit, bx, ORIGIN_Y + ARRAY_H + 0.5)
# VSS pin already in BUS_X

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("cdac6.gds")
print("cdac6.gds written, bbox:", top.bbox().to_dum())
```