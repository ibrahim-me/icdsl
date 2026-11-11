```
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data for gf180mcuD (layers as (gds, datatype), rules in um)
# ---------------------------------------------------------------------------
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
    label={
        "poly": (30, 10), "m1": (34, 10), "m2": (36, 10), "m3": (42, 10), "m4": (46, 10), "m5": (81, 10),
        "nwell": (21, 10), "pwell": (204, 10),
    },
    stack=["m1", "m2", "m3", "m4", "m5"],
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"m1": 0.23, "m2": 0.28, "m3": 0.28, "m4": 0.28, "m5": 0.44},
    space={
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28,
        ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
    },
    enc={
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06),
        ("m2", "via2"): (0.01, 0.06), ("m3", "via2"): (0.01, 0.06),
        ("m3", "via3"): (0.01, 0.06), ("m4", "via3"): (0.01, 0.06),
        ("m4", "via4"): (0.01, 0.06), ("m5", "via4"): (0.01, 0.06),
    },
    devices={
        "cap_mim": dict(type="mim", model="cap_mim_2f0_m4m5_noshield",
                        bottom="m4", plate="capm", top="m5", cut="via4",
                        wmin=5.0, bottom_enc=0.60, cut_enc=0.40,
                        markers=[("cap_mk", -0.40)],
                        params={"w": "c_width", "l": "c_length"}),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------------------
# Layout helpers
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001  # 1 nm database unit

def layer(name):
    gds, dt = TECH["layers"][name]
    return ly.layer(gds, dt)

def label_layer(name):
    gds, dt = TECH["label"][name]
    return ly.layer(gds, dt)

def dbu(um):
    return int(round(um / ly.dbu))

def box(cell, layername, x1, y1, x2, y2):
    cell.shapes(layer(layername)).insert(
        kdb.Box(dbu(x1), dbu(y1), dbu(x2), dbu(y2))
    )

def label(cell, layername, text, x, y):
    cell.shapes(label_layer(layername)).insert(
        kdb.DText(text, kdb.DTrans(kdb.DVector(x, y)))
    )

def via(cell, layername, x, y, size=None):
    cut = TECH["cuts"][layername]
    s = size if size is not None else cut["size"]
    hs = s / 2.0
    box(cell, layername, x - hs, y - hs, x + hs, y + hs)

# ---------------------------------------------------------------------------
# Unit MIM capacitor (5 x 5 um effective area)
# ---------------------------------------------------------------------------
CAP_W = 5.0
CAP_L = 5.0
PITCH = 9.0  # placement pitch (m4 plate is 7x7, 2um gap between plates)

def unit_cap(cell, x, y):
    """Draw one 5x5 um MIM unit capacitor at (x,y) centre.

    Layer stack (bottom to top):
      m4   bottom plate  : 7.0 x 7.0  (extends beyond capm by bottom_enc=0.60)
      capm dielectric    : 5.8 x 5.8  (extends beyond m5 by cut_enc=0.40)
      m5   top plate     : 5.0 x 5.0  (FuseTop, area = 25um^2 >= MIMTM.8a)
      via4 cut           : 0.26 x 0.26 centred on m5
      cap_mk marker      : 5.0 x 5.0  (same as m5 -> 0 um enclosure of fuse top)
    """
    be = TECH["devices"]["cap_mim"]["bottom_enc"]   # 0.60
    ce = TECH["devices"]["cap_mim"]["cut_enc"]      # 0.40

    # bottom plate m4: 7.0 x 7.0
    m4_half = CAP_W / 2.0 + be
    box(cell, "m4", x - m4_half, y - m4_half, x + m4_half, y + m4_half)

    # dielectric capm: 5.8 x 5.8
    capm_half = CAP_W / 2.0 + ce
    box(cell, "capm", x - capm_half, y - capm_half, x + capm_half, y + capm_half)

    # top plate m5: 5.0 x 5.0
    t_half = CAP_W / 2.0
    box(cell, "m5", x - t_half, y - t_half, x + t_half, y + t_half)

    # via4 cut (enclosed by m5)
    via(cell, "via4", x, y)

    # cap_mk marker (same size as m5 -> 0 um enclosure)
    box(cell, "cap_mk", x - t_half, y - t_half, x + t_half, y + t_half)

# ---------------------------------------------------------------------------
# Bit assignment for 64 unit capacitors (clustered by bit, row by row)
# ---------------------------------------------------------------------------
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
bits = []
for bit, cnt in bit_counts.items():
    bits.extend([bit] * cnt)
assert len(bits) == 64

# ---------------------------------------------------------------------------
# Build the layout
# ---------------------------------------------------------------------------
top = ly.create_cell("cdac6")

cols = 8
rows = 8
x0 = 0.0
y0 = 0.0

# Place all unit capacitors (clustered by bit: rows 0-3=B5, 4-5=B4, 6=B3, 7=mixed)
for idx in range(64):
    cx = x0 + (idx % cols) * PITCH + PITCH / 2.0
    cy = y0 + (idx // cols) * PITCH + PITCH / 2.0
    unit_cap(top, cx, cy)

# ---------------------------------------------------------------------------
# Route TOP (m5 top plates) to the left edge
# ---------------------------------------------------------------------------
TOP_TRACK_Y = y0 - 3.0
m5_w = TECH["width"]["m5"]
m5_hs = m5_w / 2.0

# Horizontal trunk on m5 (left of array)
box(top, "m5", x0 - 2.0, TOP_TRACK_Y - m5_hs,
        x0 + cols * PITCH + 2.0, TOP_TRACK_Y + m5_hs)

# Vertical drops from trunk to each m5 plate (m5 can cross over m4 freely)
t_half = CAP_W / 2.0
for idx in range(64):
    cx = x0 + (idx % cols) * PITCH + PITCH / 2.0
    cy = y0 + (idx // cols) * PITCH + PITCH / 2.0
    y1 = min(TOP_TRACK_Y - m5_hs, cy - t_half)
    y2 = max(TOP_TRACK_Y + m5_hs, cy + t_half)
    box(top, "m5", cx - m5_hs, y1, cx + m5_hs, y2)

label(top, "m5", "TOP", x0 - 1.0, TOP_TRACK_Y)

# ---------------------------------------------------------------------------
# Route bottom plates (m4) per bit to the right edge
# ---------------------------------------------------------------------------
m4_w = TECH["width"]["m4"]
m4_hs = m4_w / 2.0
m4_half = CAP_W / 2.0 + TECH["devices"]["cap_mim"]["bottom_enc"]  # 3.5

# Collect centres per bit
bit_centres = {b: [] for b in bit_counts}
for idx, bit in enumerate(bits):
    cx = x0 + (idx % cols) * PITCH + PITCH / 2.0
    cy = y0 + (idx // cols) * PITCH + PITCH / 2.0
    bit_centres[bit].append((cx, cy))

# Horizontal m4 tracks for each bit, stacked above the array
track_y = y0 + rows * PITCH + 4.0
track_pitch = 4.0

x_pin_start = x0 + cols * PITCH + 3.0

for ti, bit in enumerate(["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]):
    centres = bit_centres[bit]
    if not centres:
        continue
    ty = track_y + ti * track_pitch
    xs = [c[0] for c in centres]

    # Horizontal m4 track spanning all columns of this bit's caps
    xmin = min(xs) - m4_half
    xmax = max(xs) + m4_half
    box(top, "m4", xmin, ty - m4_hs, xmax, ty + m4_hs)

    # Vertical drops from track to each plate (in column gaps, no plate overlap)
    for cx, cy in centres:
        y1 = min(ty - m4_hs, cy - m4_half)
        y2 = max(ty + m4_hs, cy + m4_half)
        box(top, "m4", cx - m4_hs, y1, cx + m4_hs, y2)

    # Route track to pin on the right
    x_end = x_pin_start + ti * 6.0
    box(top, "m4", xmax, ty - m4_hs, x_end, ty + m4_hs)
    label(top, "m4", bit, x_end + 1.0, ty)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("cdac6.gds")
print("cdac6.gds written")

```