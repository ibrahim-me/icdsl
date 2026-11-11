```
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data for gf180mcuD (um)
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
    cuts={
        "contact": dict(size=0.22, space=0.25, lower=["diff", "poly"], upper="m1"),
        "via1": dict(size=0.26, space=0.26, lower="m1", upper="m2"),
        "via2": dict(size=0.26, space=0.26, lower="m2", upper="m3"),
        "via3": dict(size=0.26, space=0.26, lower="m3", upper="m4"),
        "via4": dict(size=0.26, space=0.26, lower="m4", upper="m5"),
    },
    width={"diff": 0.22, "poly": 0.18, "m1": 0.23, "m2": 0.28, "m3": 0.28, "m4": 0.28, "m5": 0.44},
    space={
        ("diff", "diff"): 0.28, ("poly", "poly"): 0.24, ("poly", "diff"): 0.10,
        ("m1", "m1"): 0.23, ("m2", "m2"): 0.28, ("m3", "m3"): 0.28, ("m4", "m4"): 0.28, ("m5", "m5"): 0.46,
        ("nwell", "diff"): 0.43,
    },
    enc={
        ("diff", "contact"): (0.07, 0.07), ("poly", "contact"): (0.07, 0.07), ("m1", "contact"): (0.005, 0.06),
        ("m1", "via1"): (0.0, 0.06), ("m2", "via1"): (0.01, 0.06), ("m2", "via2"): (0.01, 0.06),
        ("m3", "via2"): (0.01, 0.06), ("m3", "via3"): (0.01, 0.06), ("m4", "via3"): (0.01, 0.06),
        ("m4", "via4"): (0.01, 0.06), ("m5", "via4"): (0.01, 0.06),
        ("nplus", "diff"): (0.16, 0.16), ("pplus", "diff"): (0.16, 0.16),
        ("nwell", "diff"): (0.43, 0.43),
    },
    rules=dict(
        gate_contact_space=0.15,
        poly_endcap=0.22,
        diff_ext_gate=0.23,
        polycontact_diff_space=0.17,
        gate_space=0.24,
        tap_diff_space=0.32,
        latchup_dist=15.0,
        wide_metal=10.0,
        implant_gate_ext=0.23,
    ),
    devices={
        "nmos": dict(type="mos", model="nfet_03v3", diff="diff", implant="nplus", well=None,
                     lmin=0.28, wmin=0.22, bulk="VSS", implant_gate_ext=0.23),
        "pmos": dict(type="mos", model="pfet_03v3", diff="diff", implant="pplus", well="nwell",
                     lmin=0.28, wmin=0.22, bulk="VDD", implant_gate_ext=0.23),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
def dbu(um):
    return int(round(um / 0.001))

def box(layer, x, y, w, h):
    return kdb.Box(dbu(x), dbu(y), dbu(x + w), dbu(y + h))

def rect(cell, layer, x, y, w, h):
    cell.shapes(TECH["layers"][layer]).insert(box(layer, x, y, w, h))

def contact(cell, x, y, cw=None, ch=None):
    cw = cw or TECH["cuts"]["contact"]["size"]
    ch = ch or TECH["cuts"]["contact"]["size"]
    cell.shapes(TECH["layers"]["contact"]).insert(box("contact", x - cw / 2, y - ch / 2, cw, ch))

def m1pad(cell, cx, cy, extra=0.06):
    cs = TECH["cuts"]["contact"]["size"]
    rect(cell, "m1", cx - extra - cs / 2, cy - extra - cs / 2, cs + 2 * extra, cs + 2 * extra)

def via1(cell, cx, cy):
    v = TECH["cuts"]["via1"]
    rect(cell, "via1", cx - v["size"] / 2, cy - v["size"] / 2, v["size"], v["size"])

def label(cell, layer, text, x, y):
    cell.shapes(TECH["label"][layer]).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def poly_gate(cell, x, y, w, h, is_pmos=False):
    rect(cell, "poly", x, y, w, h)
    imp = "pplus" if is_pmos else "nplus"
    ige = TECH["rules"]["implant_gate_ext"]
    rect(cell, imp, x - ige, y - ige, w + 2 * ige, h + 2 * ige)

# ---------------------------------------------------------------------------
# Top cell
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("sram16x8")

Wc = 5.13   # cell width  (x)  -> bit-line direction
Hc = 5.52   # cell height (y)  -> word-line direction
n_rows = 16
n_cols = 8

n_w, n_l = 0.36, 0.28   # NMOS
p_w, p_l = 0.72, 0.28   # PMOS
gap = 0.28              # diff-diff spacing
ep = TECH["rules"]["poly_endcap"]      # 0.22
de = TECH["rules"]["diff_ext_gate"]    # 0.23

# ---------------------------------------------------------------------------
# Build one 6T cell ("CELL")
# ---------------------------------------------------------------------------
cell = ly.create_cell("CELL")

# Diffusion strip x-positions (vertical strips)
xA = 0.30                      # access   NMOS (BL  -> Q)
xB = xA + n_w + gap            # pulldown NMOS (Q   -> VSS)  gate=QB
xC = xB + n_w + gap            # pullup   PMOS (VDD -> Q)    gate=QB  [nwell]
xD = xC + p_w + gap            # pullup   PMOS (VDD -> QB)   gate=Q   [nwell]
xE = xD + p_w + gap            # pulldown NMOS (QB  -> VSS)  gate=Q
xF = xE + n_w + gap            # access   NMOS (QB  -> BLB)  gate=WL

# Poly gate y-levels (horizontal strips)
y_wl = 1.50    # crosses A, F
y_qb = 3.20    # crosses B, C
y_q  = 4.80    # crosses D, E

# Diffusion vertical span (covers all gates + extensions + contacts)
dy0 = 0.55
dy1 = 5.25
dh = dy1 - dy0

# n-well over PMOS strips C and D
nw_x0 = xC - 0.43
nw_x1 = xD + p_w + 0.43
nw_y0 = dy0 - 0.43
nw_y1 = dy1 + 0.43
rect(cell, "nwell", nw_x0, nw_y0, nw_x1 - nw_x0, nw_y1 - nw_y0)

# --- Diffusion strips + implants ---
for (x, tw, is_p) in [(xA, n_w, False), (xB, n_w, False), (xC, p_w, True),
                      (xD, p_w, True), (xE, n_w, False), (xF, n_w, False)]:
    rect(cell, "diff", x, dy0, tw, dh)
    imp = "pplus" if is_p else "nplus"
    rect(cell, imp, x - 0.16, dy0 - 0.16, tw + 0.32, dh + 0.32)

# --- Poly gates ---
# WL: full-width horizontal strip (chains between cells)
rect(cell, "poly", 0.0, y_wl - n_l / 2, Wc, n_l)
# QB gate: crosses B (NMOS) and C (PMOS)
poly_gate(cell, xB - n_l / 2, y_qb - (n_l + 2 * ep) / 2, n_l, n_l + 2 * ep, is_pmos=False)
poly_gate(cell, xC - p_l / 2, y_qb - (p_l + 2 * ep) / 2, p_l, p_l + 2 * ep, is_pmos=True)
# Q gate: crosses D (PMOS) and E (NMOS)
poly_gate(cell, xD - p_l / 2, y_q - (p_l + 2 * ep) / 2, p_l, p_l + 2 * ep, is_pmos=True)
poly_gate(cell, xE - n_l / 2, y_q - (n_l + 2 * ep) / 2, n_l, n_l + 2 * ep, is_pmos=False)

# --- Contacts on diffusion ---
# Q node: A-top(drain), B-top(source), C-bottom(drain)  -> all at y=2.50
yQ = 2.50
for (x, tw) in [(xA, n_w), (xB, n_w), (xC, p_w)]:
    contact(cell, x + tw / 2, yQ)
    m1pad(cell, x + tw / 2, yQ)
# QB node: D-bottom(drain), E-top(source), F-top(drain) -> all at y=3.50
yQB = 3.50
for (x, tw) in [(xD, p_w), (xE, n_w), (xF, n_w)]:
    contact(cell, x + tw / 2, yQB)
    m1pad(cell, x + tw / 2, yQB)
# VSS: B-bottom(drain), E-bottom(drain) -> y=0.80
yVSS = 0.80
for (x, tw) in [(xB, n_w), (xE, n_w)]:
    contact(cell, x + tw / 2, yVSS)
    m1pad(cell, x + tw / 2, yVSS)
# VDD: C-top(source), D-top(source) -> y=5.00
yVDD = 5.00
for (x, tw) in [(xC, p_w), (xD, p_w)]:
    contact(cell, x + tw / 2, yVDD)
    m1pad(cell, x + tw / 2, yVDD)
# BL: A-bottom(source) -> y=0.80
contact(cell, xA + n_w / 2, yVSS)
m1pad(cell, xA + n_w / 2, yVSS)
# BLB: F-top(drain) -> y=5.00
contact(cell, xF + n_w / 2, yVDD)
m1pad(cell, xF + n_w / 2, yVDD)

# --- m1 rails ---
# Q node rail (horizontal) from A to C
rect(cell, "m1", xA, yQ - 0.115, xC + p_w - xA, 0.23)
# QB node rail (horizontal) from D to F
rect(cell, "m1", xD, yQB - 0.115, xF + n_w - xD, 0.23)
# VSS rail (horizontal, full width)
rect(cell, "m1", 0.0, yVSS - 0.115, Wc, 0.23)
# VDD rail (horizontal, full width)
rect(cell, "m1", 0.0, yVDD - 0.115, Wc, 0.23)
# BL vertical (at xA) and BLB vertical (at xF)
rect(cell, "m1", xA - 0.115, 0.0, 0.23, Hc)
rect(cell, "m1", xF - 0.115, 0.0, 0.23, Hc)

# --- Cross-coupling jogs ---
# Q node -> Q gate poly (vertical jog at center of D)
xjQ = xD + p_l / 2
rect(cell, "m1", xjQ - 0.115, yQ + 0.115, 0.23, y_q - (n_l + 2 * ep) / 2 - (yQ + 0.115))
contact(cell, xjQ, y_q - (n_l + 2 * ep) / 2 - 0.11)
m1pad(cell, xjQ, y_q - (n_l + 2 * ep) / 2 - 0.11)
# QB node -> QB gate poly (vertical jog at center of B)
xjQB = xB + n_l / 2
rect(cell, "m1", xjQB - 0.115, yQB - 0.115 - 0.23, 0.23, (y_qb + (n_l + 2 * ep) / 2 + 0.11) - (yQB - 0.115 - 0.23))
contact(cell, xjQB, y_qb + (n_l + 2 * ep) / 2 + 0.11)
m1pad(cell, xjQB, y_qb + (n_l + 2 * ep) / 2 + 0.11)

# --- Cell pins (m1 label layer) ---
label(cell, "m1", "BL",  xA, Hc - 0.15)
label(cell, "m1", "BLB", xF, Hc - 0.15)
label(cell, "m1", "VDD", Wc - 0.15, yVDD)
label(cell, "m1", "VSS", Wc - 0.15, yVSS)

# ---------------------------------------------------------------------------
# Place 16x8 array
# ---------------------------------------------------------------------------
for r in range(n_rows):
    for c in range(n_cols):
        top.insert(kdb.DCellInstArray(cell.cell_index(), kdb.DTrans(c * Wc, r * Hc)))

# ---------------------------------------------------------------------------
# Top-level m2: word lines, bit lines, VDD, VSS rails + vias
# ---------------------------------------------------------------------------
m2 = TECH["layers"]["m2"]
v1 = TECH["layers"]["via1"]
v1s = TECH["cuts"]["via1"]["size"]

def m2rect(x, y, w, h):
    top.shapes(m2).insert(box("m2", x, y, w, h))

def v1at(x, y):
    top.shapes(v1).insert(box("via1", x - v1s / 2, y - v1s / 2, v1s, v1s))

# Word lines: m2 horizontal rails, one per row, at WL poly level
for r in range(n_rows):
    oy = r * Hc
    m2rect(0.0, oy + y_wl - 0.14, n_cols * Wc, 0.28)
    # connect WL poly (in cell column 0) to m2 via contact+via1
    wx = 0.0 + Wc / 2.0
    wy = oy + y_wl
    ph = n_l + 2 * ep
    py0 = oy + y_wl - ph / 2
    contact(top, wx, py0 + ph / 2 - 0.11)
    m1pad(top, wx, py0 + ph / 2 - 0.11)
    v1at(wx, py0 + ph / 2 - 0.11)

# Bit lines: m2 vertical rails at xA and xF of each column
for c in range(n_cols):
    ox = c * Wc
    m2rect(ox + xA - 0.14, 0.0, 0.28, n_rows * Hc)
    m2rect(ox + xF - 0.14, 0.0, 0.28, n_rows * Hc)
    for r in range(n_rows):
        oy = r * Hc
        # BL via1 at top of cell
        v1at(ox + xA, oy + Hc - 0.15 - v1s / 2)
        # BLB via1 at top of cell
        v1at(ox + xF, oy + Hc - 0.15 - v1s / 2)

# VDD / VSS m2 rails at top/bottom of array
m2rect(0.0, n_rows * Hc - 0.34 - 0.14, n_cols * Wc, 0.28)   # VDD
m2rect(0.0, 0.06 - 0.14, n_cols * Wc, 0.28)                  # VSS
# via1 from cell m1 rails to m2 rails (right edge of each cell)
for r in range(n_rows):
    oy = r * Hc
    for c in range(n_cols):
        ox = c * Wc
        vx = ox + Wc - 0.15 - v1s / 2
        v1at(vx, oy + yVDD - v1s / 2)
        v1at(vx, oy + yVSS - v1s / 2)

# ---------------------------------------------------------------------------
# Top-level pins (labels on m2 label layer)
# ---------------------------------------------------------------------------
def tlabel(layer, text, x, y):
    top.shapes(TECH["label"][layer]).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

tlabel("m2", "VDD", n_cols * Wc - 0.5, n_rows * Hc - 0.34)
tlabel("m2", "VSS", n_cols * Wc - 0.5, 0.06)
for c in range(n_cols):
    ox = c * Wc
    tlabel("m2", f"BL{c}",  ox + xA, n_rows * Hc - 0.5)
    tlabel("m2", f"BLB{c}", ox + xF, n_rows * Hc - 0.5)
for r in range(n_rows):
    tlabel("m2", f"WL{r}", n_cols * Wc - 0.5, r * Hc + y_wl)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("sram16x8.gds")
bb = top.bbox()
w_um = bb.width() * 0.001
h_um = bb.height() * 0.001
print(f"Wrote sram16x8.gds  bbox={w_um:.2f}x{h_um:.2f} um  area={w_um*h_um:.2f} um^2")

```