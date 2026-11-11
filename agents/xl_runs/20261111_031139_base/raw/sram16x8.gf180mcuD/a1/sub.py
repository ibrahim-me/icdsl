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
# Geometry helpers
# ---------------------------------------------------------------------------
def dbu(um, dbu=0.001):
    return int(round(um / dbu))

def box(ly, layer, x, y, w, h):
    return kdb.Box(dbu(x), dbu(y), dbu(x + w), dbu(y + h))

def via_grid(cell, layer, cut, x0, y0, w, h, cs, ss, enc_outer, enc_inner, enc_mode="all"):
    """Place a grid of cuts inside [x0,x0+w]x[y0,y0+h] on the outer layer.
    enc_mode: "all" -> enc on every side; "x" -> enc only on left/right (y sides get 0)."""
    cw, ch = cut["size"], cut["size"]
    sp = cut["space"]
    ex, ey = enc_outer
    # effective inner opening
    ix0 = x0 + ex
    iy0 = y0 + ey
    ix1 = x0 + w - ex
    iy1 = y0 + h - ey
    if enc_mode == "x":
        iy0 = y0
        iy1 = y0 + h
    if ix1 < ix0 + cw or iy1 < iy0 + ch:
        return
    nx = max(1, int((ix1 - ix0 - cw) // (cw + sp)) + 1)
    ny = max(1, int((iy1 - iy0 - ch) // (ch + sp)) + 1)
    # center the grid within the effective opening
    tot_x = nx * cw + (nx - 1) * sp
    tot_y = ny * ch + (ny - 1) * sp
    ox = ix0 + (ix1 - ix0 - tot_x) / 2.0
    oy = iy0 + (iy1 - iy0 - tot_y) / 2.0
    lay = TECH["layers"][layer]
    cut_lay = TECH["layers"][cut["layer"]] if isinstance(cut, dict) and "layer" in cut else TECH["layers"][layer]
    for i in range(nx):
        for j in range(ny):
            cx = ox + i * (cw + sp)
            cy = oy + j * (ch + sp)
            cell.shapes(cut_lay).insert(box(ly, cut["layer"] if isinstance(cut, str) else layer, cx, cy, cw, ch))

def contact(cell, layer, x, y, w, h, cut_layer="contact", enc=0.07):
    """Place contact(s) on cut_layer within an outer rectangle on `layer`."""
    cut = TECH["cuts"][cut_layer]
    cw, ch = cut["size"], cut["size"]
    sp = cut["space"]
    ix0 = x + enc; iy0 = y + enc
    ix1 = x + w - enc; iy1 = y + h - enc
    if ix1 < ix0 + cw or iy1 < iy0 + ch:
        # single centered cut if possible
        cx = x + w / 2 - cw / 2
        cy = y + h / 2 - ch / 2
        if cx + cw <= x + w and cy + ch <= y + h and cx >= x and cy >= y:
            cell.shapes(TECH["layers"][cut_layer]).insert(box(ly, cut_layer, cx, cy, cw, ch))
        return
    nx = max(1, int((ix1 - ix0 - cw) // (cw + sp)) + 1)
    ny = max(1, int((iy1 - iy0 - ch) // (ch + sp)) + 1)
    tot_x = nx * cw + (nx - 1) * sp
    tot_y = ny * ch + (ny - 1) * sp
    ox = ix0 + (ix1 - ix0 - tot_x) / 2.0
    oy = iy0 + (iy1 - iy0 - tot_y) / 2.0
    for i in range(nx):
        for j in range(ny):
            cx = ox + i * (cw + sp)
            cy = oy + j * (ch + sp)
            cell.shapes(TECH["layers"][cut_layer]).insert(box(ly, cut_layer, cx, cy, cw, ch))

def label(cell, layer, text, x, y):
    lay = TECH["label"][layer]
    cell.shapes(lay).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def poly_gate(cell, x, y, w, h, is_pmos=False):
    """Draw a poly gate rectangle with endcaps and implant."""
    lay_poly = TECH["layers"]["poly"]
    cell.shapes(lay_poly).insert(box(ly, "poly", x, y, w, h))
    # endcap: poly extends poly_endcap beyond diff on both sides
    ep = TECH["rules"]["poly_endcap"]
    cell.shapes(lay_poly).insert(box(ly, "poly", x - ep, y, w + 2 * ep, h))
    # implant
    imp = "pplus" if is_pmos else "nplus"
    lay_imp = TECH["layers"][imp]
    # implant covers diff under gate plus implant_gate_ext beyond
    ige = TECH["rules"]["implant_gate_ext"]
    cell.shapes(lay_imp).insert(box(ly, imp, x - ige, y - ige, w + 2 * ige, h + 2 * ige))

def mos(cell, x, y, w, l, is_pmos=False, nwell_box=None):
    """Draw one transistor: diff, poly gate, implant, nwell (if pmos).
    Returns dict with gate poly rect and diff rect."""
    diff_rect = box(ly, "diff", x, y, w, l)
    cell.shapes(TECH["layers"]["diff"]).insert(diff_rect)
    # poly gate crosses diff: poly width = l (in x), height = w + 2*endcap (in y)
    poly_x = x - l / 2.0
    poly_y = y - TECH["rules"]["poly_endcap"]
    poly_w = l
    poly_h = l + 2 * TECH["rules"]["poly_endcap"]
    poly_gate(cell, poly_x, poly_y, poly_w, poly_h, is_pmos=is_pmos)
    if is_pmos and nwell_box is not None:
        cell.shapes(TECH["layers"]["nwell"]).insert(nwell_box)
    return {"diff": (x, y, w, l), "gate": (poly_x, poly_y, poly_w, poly_h)}

# ---------------------------------------------------------------------------
# Build layout
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("sram16x8")

# Cell pitch (matches reference closely, well within 2x area budget)
Wc = 5.13   # cell width  (x)  -> bit-line direction
Hc = 5.52   # cell height (y)  -> word-line direction

# Transistor sizes (from netlist)
n_w, n_l = 0.36, 0.28   # NMOS
p_w, p_l = 0.72, 0.28   # PMOS

# ---------------------------------------------------------------------------
# Build one 6T cell (hierarchy cell "CELL")
# ---------------------------------------------------------------------------
cell = ly.create_cell("CELL")

# Coordinates within cell (local, 0..Wc x 0..Hc)
# Diffusion strips (vertical, along y). x positions:
#   A: access left  (BL -> Q)   NMOS n_w
#   B: pull-down    (Q -> VSS)  NMOS n_w   gate = QB
#   C: pull-up      (Q -> VDD)  PMOS p_w   gate = QB   (nwell)
#   D: pull-up      (QB -> VDD) PMOS p_w   gate = Q    (nwell)
#   E: pull-down    (QB -> VSS) NMOS n_w   gate = Q
#   F: access right (QB -> BLB) NMOS n_w   gate = WL
gap = 0.30   # diff-diff spacing (>=0.28)
xA = 0.20
xB = xA + n_w + gap
xC = xB + n_w + gap
xD = xC + p_w + gap
xE = xD + p_w + gap
xF = xE + n_w + gap
cell_right = xF + n_w + 0.20
# cell_right ~ 4.93 < Wc  OK

# y positions (horizontal poly strips run along x)
y_wl = 0.55          # word line poly (gate of access transistors)
y_gQB = 1.75         # poly gate = node QB  (inverters driving Q)
y_gQ  = 3.05         # poly gate = node Q   (inverters driving QB)
# diffusion vertical extent (must cover all gates with diff_ext_gate=0.23)
de = TECH["rules"]["diff_ext_gate"]
y_diff_top = y_wl - de
y_diff_bot = y_gQ + de
diff_h = y_diff_bot - y_diff_top   # ~2.73

# n-well for PMOS strips C and D (merge into one well)
nw_x0 = xC - 0.43
nw_x1 = xD + p_w + 0.43
nw_y0 = y_diff_top - 0.43
nw_y1 = y_diff_bot + 0.43
cell.shapes(TECH["layers"]["nwell"]).insert(box(ly, "nwell", nw_x0, nw_y0, nw_x1 - nw_x0, nw_y1 - nw_y0))

# --- Diffusion strips ---
for (x, tw, is_p) in [(xA, n_w, False), (xB, n_w, False), (xC, p_w, True),
                      (xD, p_w, True), (xE, n_w, False), (xF, n_w, False)]:
    cell.shapes(TECH["layers"]["diff"]).insert(box(ly, "diff", x, y_diff_top, tw, diff_h))
    imp = "pplus" if is_p else "nplus"
    cell.shapes(TECH["layers"][imp]).insert(box(ly, imp, x - 0.16, y_diff_top - 0.16, tw + 0.32, diff_h + 0.32))

# --- Poly gates (horizontal strips along x) ---
# WL gate: crosses access diffs A and F
for (x, tw) in [(xA, n_w), (xF, n_w)]:
    poly_gate(cell, x - n_l / 2.0, y_wl - TECH["rules"]["poly_endcap"], n_l, n_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=False)
# gate QB: crosses B (NMOS) and C (PMOS)
poly_gate(cell, xB - n_l / 2.0, y_gQB - TECH["rules"]["poly_endcap"], n_l, n_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=False)
poly_gate(cell, xC - p_l / 2.0, y_gQB - TECH["rules"]["poly_endcap"], p_l, p_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=True)
# gate Q: crosses D (PMOS) and E (NMOS)
poly_gate(cell, xD - p_l / 2.0, y_gQ - TECH["rules"]["poly_endcap"], p_l, p_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=True)
poly_gate(cell, xE - n_l / 2.0, y_gQ - TECH["rules"]["poly_endcap"], n_l, n_l + 2 * TECH["rules"]["poly_endcap"], is_pmos=False)

# Extend WL poly to cell edges so it can chain horizontally (abuts at cell boundary)
cell.shapes(TECH["layers"]["poly"]).insert(box(ly, "poly", 0.0, y_wl - TECH["rules"]["poly_endcap"], Wc, n_l + 2 * TECH["rules"]["poly_endcap"]))

# ---------------------------------------------------------------------------
# Contacts and metal1 connections inside the cell
# ---------------------------------------------------------------------------
co = TECH["cuts"]["contact"]
cs = co["size"]; sp = co["space"]
enc_diff = 0.07; enc_poly = 0.07; enc_m1 = 0.005

def place_contacts_in_rect(x, y, w, h, layers):
    """Place contacts in rect on `layer`, cutting the listed lower layers."""
    ix0 = x + enc_diff; iy0 = y + enc_diff
    ix1 = x + w - enc_diff; iy1 = y + h - enc_diff
    # also need m1 enc: contact must be inside m1 by enc_m1; we place m1 after
    if ix1 < ix0 + cs or iy1 < iy0 + cs:
        return []
    nx = max(1, int((ix1 - ix0 - cs) // (cs + sp)) + 1)
    ny = max(1, int((iy1 - iy0 - cs) // (cs + sp)) + 1)
    tot_x = nx * cs + (nx - 1) * sp
    tot_y = ny * cs + (ny - 1) * sp
    ox = ix0 + (ix1 - ix0 - tot_x) / 2.0
    oy = iy0 + (iy1 - iy0 - tot_y) / 2.0
    pts = []
    for i in range(nx):
        for j in range(ny):
            cx = ox + i * (cs + sp)
            cy = oy + j * (cs + sp)
            pts.append((cx, cy))
            cell.shapes(TECH["layers"]["contact"]).insert(box(ly, "contact", cx, cy, cs, cs))
    return pts

def m1_rect(x, y, w, h):
    cell.shapes(TECH["layers"]["m1"]).insert(box(ly, "m1", x, y, w, h))

# Contact layer for m1: contact enc on m1 is 0.005 (outer) / 0.06 (two opposite sides).
# We'll draw m1 rectangles that fully cover contacts with 0.06 margin on the two "more" sides.
# Simplest: make m1 contact pads larger than contact by enc on all sides.

def m1_pad(cx, cy, cw=cs, ch=cs, extra=0.06):
    pad_w = cw + 2 * extra
    pad_h = ch + 2 * extra
    m1_rect(cx - extra, cy - extra, pad_w, pad_h)

# --- Node Q: drain of A(access), B(pulldown), C(pullup) ---
# Contacts on diff of A, B, C at the y-level of node Q.
# We'll route node Q on m1 horizontally at y = y_nodeQ connecting these three.
y_nodeQ = 2.30   # between gQB(1.75) and gQ(3.05), within diff
# contacts on A, B, C diffs at y_nodeQ
for (x, tw) in [(xA, n_w), (xB, n_w), (xC, p_w)]:
    pts = place_contacts_in_rect(x, y_nodeQ - 0.10, tw, 0.20, ["diff"])
    for (cx, cy) in pts:
        m1_pad(cx, cy)
# m1 horizontal rail for node Q from A to C
m1_rect(xA, y_nodeQ - 0.115, xC + p_w - xA, 0.23)
# connect node Q to gate Q poly (which crosses D and E) via a vertical m1 jog at xE area
# gate Q poly is at y_gQ; node Q rail at y_nodeQ. Vertical m1 at x = xE + n_l/2 (center of gate Q on E)
x_gQ_on_E = xE + n_l / 2.0
m1_rect(x_gQ_on_E - 0.115, y_nodeQ, 0.23, y_gQ + TECH["rules"]["poly_endcap"] + 0.115 - y_nodeQ)
# contact on gate Q poly (on E diff area) to connect poly to m1
# poly contact: cut on poly, enc 0.07 on poly
place_contacts_in_rect(x_gQ_on_E - 0.115, y_gQ - TECH["rules"]["poly_endcap"] - 0.05, 0.23, TECH["rules"]["poly_endcap"] + 0.10, ["poly"])
for (cx, cy) in place_contacts_in_rect(x_gQ_on_E - 0.115, y_gQ - TECH["rules"]["poly_endcap"] - 0.05, 0.23, TECH["rules"]["poly_endcap"] + 0.10, ["poly"]):
    m1_pad(cx, cy)

# --- Node QB: drain of F(access), E(pulldown), D(pullup) ---
y_nodeQB = 2.30
for (x, tw) in [(xF, n_w), (xE, n_w), (xD, p_w)]:
    pts = place_contacts_in_rect(x, y_nodeQB - 0.10, tw, 0.20, ["diff"])
    for (cx, cy) in pts:
        m1_pad(cx, cy)
m1_rect(xD, y_nodeQB - 0.115, xF + n_w - xD, 0.23)
# connect node QB to gate QB poly (crosses B and C) via vertical m1 jog at xB area
x_gQB_on_B = xB + n_l / 2.0
m1_rect(x_gQB_on_B - 0.115, y_nodeQB, 0.23, y_gQB + TECH["rules"]["poly_endcap"] + 0.115 - y_nodeQB)
for (cx, cy) in place_contacts_in_rect(x_gQB_on_B - 0.115, y_gQB - TECH["rules"]["poly_endcap"] - 0.05, 0.23, TECH["rules"]["poly_endcap"] + 0.10, ["poly"]):
    m1_pad(cx, cy)

# --- VSS rail: sources of B and E (NMOS pull-downs) ---
y_vss = 0.20
for (x, tw) in [(xB, n_w), (xE, n_w)]:
    pts = place_contacts_in_rect(x, y_diff_top, tw, y_wl - de - y_diff_top, ["diff"])
    for (cx, cy) in pts:
        m1_pad(cx, cy)
m1_rect(xB, y_vss - 0.115, xE + n_w - xB, 0.23)
# VSS rail extends to cell edges for chaining
m1_rect(0.0, y_vss - 0.115, Wc, 0.23)

# --- VDD rail: sources of C and D (PMOS pull-ups) ---
y_vdd = Hc - 0.20
for (x, tw) in [(xC, p_w), (xD, p_w)]:
    pts = place_contacts_in_rect(x, y_gQ + de + 0.10, tw, y_diff_bot - (y_gQ + de + 0.10), ["diff"])
    for (cx, cy) in pts:
        m1_pad(cx, cy)
m1_rect(xC, y_vdd - 0.115, xD + p_w - xC, 0.23)
m1_rect(0.0, y_vdd - 0.115, Wc, 0.23)

# --- Bit lines BL (left, from access A) and BLB (right, from access F) ---
# Access transistor source = bit line. Contact on diff of A and F at lower portion.
y_bl = y_wl + de + 0.10   # below WL gate
for (x, tw, blname) in [(xA, n_w, "BL"), (xF, n_w, "BLB")]:
    pts = place_contacts_in_rect(x, y_bl, tw, y_diff_bot - y_bl, ["diff"])
    for (cx, cy) in pts:
        m1_pad(cx, cy)
# m1 vertical bit lines at xA and xF, running full cell height (chain vertically)
m1_rect(xA - 0.115, 0.0, 0.23, Hc)
m1_rect(xF - 0.115, 0.0, 0.23, Hc)
# contacts from bit line m1 to access diff
# (already have contact on diff; m1 vertical line covers it via pad)
# ensure m1 vertical line overlaps the contact pads: pads are around contact on diff; m1 line width 0.23 centered on xA/xF.
# contact pad extra=0.06 -> pad width 0.34 centered on contact. m1 line 0.23 centered on xA. Overlap OK if contact near xA.
# Place contacts centered on xA/xF so m1 line covers them.
# Redo: place contact at center of diff strip
for (x, tw) in [(xA, n_w), (xF, n_w)]:
    cx = x + tw / 2.0
    cy = y_bl + 0.20
    cell.shapes(TECH["layers"]["contact"]).insert(box(ly, "contact", cx - cs/2, cy - cs/2, cs, cs))
    m1_pad(cx, cy)

# --- Word line: already a full-width poly strip at y_wl ---
# WL pin: label on poly? WL runs in poly. We'll label WL on m1? No pin layer for poly in this PDK label dict has poly (30,10).
# Actually label dict has "poly": (30,10). So we can label poly. But WL is a global pin; label at top level after array.
# For now, no internal label; WL connects via poly abutment.

# --- Pins on m1 (label layer m1 = (34,10)) ---
# BL, BLB on m1 vertical lines: label at top of cell
label(cell, "m1", "BL", xA, Hc - 0.15)
label(cell, "m1", "BLB", xF, Hc - 0.15)
# VDD, VSS on m1 horizontal rails: label at right edge
label(cell, "m1", "VDD", Wc - 0.15, y_vdd)
label(cell, "m1", "VSS", Wc - 0.15, y_vss)

# ---------------------------------------------------------------------------
# Place 16x8 array of cells
# ---------------------------------------------------------------------------
n_rows = 16   # WL0..WL15 (y direction)
n_cols = 8    # BL0..BL7 (x direction)

# Place cells
for r in range(n_rows):
    for c in range(n_cols):
        top.insert(kdb.DCellInstArray(cell.cell_index(), kdb.DTrans(c * Wc, r * Hc)))

# ---------------------------------------------------------------------------
# Top-level metal2: word lines (horizontal) and bit lines (vertical)
# ---------------------------------------------------------------------------
m2 = TECH["layers"]["m2"]
v1 = TECH["layers"]["via1"]

# Word lines: m2 horizontal rails, one per row, at y = r*Hc + y_wl (center of WL poly)
# Connect to cell WL poly via via1. But WL is poly; need contact poly->m1 then via1 m1->m2.
# Simpler: run m2 over the cell and drop via1 to m1 at the WL poly location? m1 doesn't exist at WL poly (WL is poly).
# We need: poly(WL) -> contact -> m1 -> via1 -> m2(WL rail).
# Place a contact on WL poly inside each cell, m1 pad, via1 to m2 rail.
# Do it once per row at column 0 (the m2 rail runs continuously, contact in one cell per row suffices, but better in every cell for robustness; we'll do every cell).

# Actually, to keep it simple and DRC-clean: run m2 word-line rails above the array, and connect each row's WL poly
# via a local contact+via1 stack at the left edge of each cell in that row.

wl_m2_y = [r * Hc + y_wl for r in range(n_rows)]
# m2 rail width 0.28, centered on y_wl
for ry in wl_m2_y:
    cell_m2 = top  # draw m2 on top cell
    cell_m2.shapes(m2).insert(box(ly, "m2", 0.0, ry - 0.14, n_cols * Wc, 0.28))

# Bit lines: m2 vertical rails, one per column pair (BL and BLB). 
# We have 8 BL and 8 BLB = 16 bit lines. But each cell column has BL at xA and BLB at xF.
# Run m2 vertical rails at xA and xF of each column.
# Connect cell m1 bit lines to m2 via via1.

# Place via1 + contacts in each cell for WL, BL, BLB, VDD, VSS
for r in range(n_rows):
    for c in range(n_cols):
        ox = c * Wc
        oy = r * Hc
        # --- WL: poly -> contact -> m1 -> via1 -> m2 ---
        # contact on WL poly at center of cell (x = Wc/2), on the WL poly strip
        wx = ox + Wc / 2.0
        wy = oy + y_wl
        # contact on poly: enc 0.07 on poly. poly strip height = n_l + 2*endcap centered on y_wl.
        ph = n_l + 2 * TECH["rules"]["poly_endcap"]
        py0 = oy + y_wl - ph / 2.0
        cell.shapes(TECH["layers"]["contact"]).insert(box(ly, "contact", wx - cs/2, py0 - cs/2, cs, cs))
        # m1 pad over contact
        m1_pad_top = None
        # draw m1 pad on top cell
        top.shapes(TECH["layers"]["m1"]).insert(box(ly, "m1", wx - 0.06 - cs/2, py0 - 0.06 - cs/2, cs + 0.12, cs + 0.12))
        # via1 from m1 to m2
        top.shapes(v1).insert(box(ly, "via1", wx - 0.13, py0 - 0.13, 0.26, 0.26))
        # --- BL: m1 vertical line (in cell) -> via1 -> m2 vertical rail ---
        bx = ox + xA
        # via1 at top of cell bit line
        top.shapes(v1).insert(box(ly, "via1", bx - 0.13, oy + Hc - 0.13 - 0.26, 0.26, 0.26))
        # m2 vertical rail for BL drawn below
        # --- BLB ---
        bbx = ox + xF
        top.shapes(v1).insert(box(ly, "via1", bbx - 0.13, oy + Hc - 0.13 - 0.26, 0.26, 0.26))
        # --- VDD / VSS: m1 horizontal rails -> via1 -> m2 rails? 
        # We'll bring VDD/VSS as m2 horizontal rails at top/bottom of array instead.
        pass

# m2 vertical bit-line rails (run full array height)
for c in range(n_cols):
    ox = c * Wc
    bx = ox + xA
    bbx = ox + xF
    top.shapes(m2).insert(box(ly, "m2", bx - 0.14, 0.0, 0.28, n_rows * Hc))
    top.shapes(m2).insert(box(ly, "m2", bbx - 0.14, 0.0, 0.28, n_rows * Hc))

# m2 horizontal VDD and VSS rails at top and bottom of array
top.shapes(m2).insert(box(ly, "m2", 0.0, n_rows * Hc - 0.20 - 0.14, n_cols * Wc, 0.28))   # VDD
top.shapes(m2).insert(box(ly, "m2", 0.0, 0.20 - 0.14, n_cols * Wc, 0.28))                   # VSS
# Connect cell VDD/VSS m1 rails to m2 rails via via1 at right edge of each cell
for r in range(n_rows):
    for c in range(n_cols):
        ox = c * Wc
        oy = r * Hc
        # VDD via1
        top.shapes(v1).insert(box(ly, "via1", ox + Wc - 0.13 - 0.15, oy + (Hc - 0.20) - 0.13, 0.26, 0.26))
        # VSS via1
        top.shapes(v1).insert(box(ly, "via1", ox + Wc - 0.13 - 0.15, oy + 0.20 - 0.13, 0.26, 0.26))

# ---------------------------------------------------------------------------
# Top-level pins (labels on m1 label layer (34,10))
# ---------------------------------------------------------------------------
# VDD, VSS pins on m2 rails -> label on m1? Pin labels should be on the metal layer of the pin.
# Use m2 label layer (36,10) for m2 pins. But label dict only has m1..m5. m2 label = (36,10).
# We'll place labels on appropriate metal label layers.
def top_label(layer, text, x, y):
    lay = TECH["label"][layer]
    top.shapes(lay).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

# VDD, VSS on m2
top_label("m2", "VDD", n_cols * Wc - 0.5, n_rows * Hc - 0.20)
top_label("m2", "VSS", n_cols * Wc - 0.5, 0.20)
# Bit lines and WLs on m2
for c in range(n_cols):
    ox = c * Wc
    top_label("m2", f"BL{c}", ox + xA, n_rows * Hc - 0.5)
    top_label("m2", f"BLB{c}", ox + xF, n_rows * Hc - 0.5)
for r in range(n_rows):
    top_label("m2", f"WL{r}", n_cols * Wc - 0.5, r * Hc + y_wl)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
top_name = "sram16x8"
ly.write(f"{top_name}.gds")
print(f"Wrote {top_name}.gds")
print(f"Top bbox: {top.bbox()} um (dbu units) -> area = {top.bbox().width()*0.001 * top.bbox().height()*0.001:.2f} um^2")
