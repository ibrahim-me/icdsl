import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK / design data (freepdk45, all values in um)
# ----------------------------------------------------------------------
TECH = dict(
    dbu=0.0005,
    grid=0.005,
    layers=dict(
        diff=(1, 0), pwell=(2, 0), nwell=(3, 0), nplus=(4, 0), pplus=(5, 0),
        poly=(9, 0), contact=(10, 0), m1=(11, 0), via1=(12, 0), m2=(13, 0),
    ),
    label={m: (11 + 2 * i, 1) for i, m in enumerate(["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
    width=dict(diff=0.09, poly=0.05, nplus=0.045, pplus=0.045, m1=0.065, m2=0.07),
    space=dict(diff=0.08, poly=0.075, nplus=0.045, pplus=0.045, m1=0.065, m2=0.07),
    contact=dict(size=0.065, space=0.075),
    via1=dict(size=0.07, space=0.075),
    enc=dict(
        diff_contact=0.005, poly_contact=0.005, m1_contact=0.035,
        m1_via1=0.035, m2_via1=0.035,
        nplus_diff=0.035, pplus_diff=0.035,
        nwell_diff=0.055, pwell_diff=0.055,
    ),
    poly_endcap=0.055,
    diff_ext_gate=0.07,
    well_min_width=0.20,
    well_same_space=0.225,
    well_n_p_space=0.20,
    nwell_diff=0.055,
    pwell_diff=0.055,
    gate_contact_space=0.035,
    tap_diff_space=0.105,
    implant_gate_ext=0.07,
)

# ----------------------------------------------------------------------
# Geometry helpers (all coordinates in um)
# ----------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = TECH["dbu"]
top = ly.create_cell("ota_miller")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
for mname, spec in TECH["label"].items():
    L[mname + "_lab"] = ly.layer(*spec)

def R(x, y, w, h):
    return kdb.DBox(x, y, x + w, y + h)

def draw(cell, layer, x, y, w, h):
    cell.shapes(layer).insert(R(x, y, w, h))

def pin(cell, text, x, y, layer="m1", w=0.065, h=0.6):
    draw(cell, L[layer], x, y, w, h)
    cell.shapes(L[layer + "_lab"]).insert(kdb.DText(text, kdb.DTrans(x + w / 2, y + h / 2)))

def contact(cell, x, y, w=None, h=None, metal="m1"):
    w = w or TECH["contact"]["size"]
    h = h or TECH["contact"]["size"]
    draw(cell, L["contact"], x, y, w, h)
    e = TECH["enc"]["m1_contact"]
    draw(cell, L[metal], x - e, y - e, w + 2 * e, h + 2 * e)

def via1(cell, x, y, w=None, h=None):
    w = w or TECH["via1"]["size"]
    h = h or TECH["via1"]["size"]
    draw(cell, L["via1"], x, y, w, h)
    e = TECH["enc"]["m1_via1"]
    draw(cell, L["m1"], x - e, y - e, w + 2 * e, h + 2 * e)
    draw(cell, L["m2"], x - e, y - e, w + 2 * e, h + 2 * e)

def m1rect(cell, x, y, w, h):
    draw(cell, L["m1"], x, y, w, h)

def m2rect(cell, x, y, w, h):
    draw(cell, L["m2"], x, y, w, h)

def polyrect(cell, x, y, w, h):
    draw(cell, L["poly"], x, y, w, h)

def diffrect(cell, x, y, w, h):
    draw(cell, L["diff"], x, y, w, h)

def implant(cell, layer, x, y, w, h):
    draw(cell, L[layer], x, y, w, h)

def well(cell, layer, x, y, w, h):
    draw(cell, L[layer], x, y, w, h)

# ----------------------------------------------------------------------
# Transistor generator (multi-finger, fingers side-by-side in x)
# Returns dict with port contact-center lists: gate, source, drain, bulk
# ----------------------------------------------------------------------
def mos(cell, kind, x, y, w, l, nf, implant_layer, well_layer, well_enc=0.055):
    """kind: 'nmos' or 'pmos'.  Diffusion runs in y (width w), fingers in x."""
    ps = TECH["space"]["poly"]
    pe = TECH["poly_endcap"]
    de = TECH["diff_ext_gate"]
    ce = TECH["enc"]["diff_contact"]
    cs = TECH["contact"]["space"]
    cz = TECH["contact"]["size"]
    ige = TECH["implant_gate_ext"]
    we = well_enc

    pitch = l + ps
    total_x = nf * l + (nf - 1) * ps + 2 * de
    # diffusion rectangle (shared source/drain diffusion under all gates)
    diff_x = x - de
    diff_y = y - w / 2 - de
    diff_w = total_x
    diff_h = w + 2 * de

    # well around the diffusion
    well_x = diff_x - we
    well_y = diff_y - we
    well_w = diff_w + 2 * we
    well_h = diff_h + 2 * we

    # implant over diffusion
    imp_x = diff_x - ige
    imp_y = diff_y - ige
    imp_w = diff_w + 2 * ige
    imp_h = diff_h + 2 * ige

    # draw well, diffusion, implant
    well(cell, well_layer, well_x, well_y, well_w, well_h)
    diffrect(cell, diff_x, diff_y, diff_w, diff_h)
    implant(cell, implant_layer, imp_x, imp_y, imp_w, imp_h)

    # poly gates
    gate_xs = []
    for i in range(nf):
        gx = x + i * pitch
        gate_xs.append(gx)
        polyrect(cell, gx, y - w / 2 - pe, l, w + 2 * pe)

    # contacts: source on even fingers, drain on odd fingers (shared diffusion)
    # contact columns sit in the gaps between gates (shared diff regions)
    n_gaps = nf - 1
    gap_w = ps
    # we place contacts in the shared diffusion regions between gates
    # plus outer source/drain contacts at the ends
    source_ctrs = []
    drain_ctrs = []
    gate_ctrs = []

    # gate contacts: one contact on each gate poly (over poly, not diff)
    # place gate contact at the right end of each poly, over the poly extension
    gc_y = y + w / 2 + pe - cz / 2  # contact inside poly extension area
    for i in range(nf):
        gx = gate_xs[i]
        # contact on poly, to the right of the gate, within poly endcap
        cx = gx + l - cz
        # ensure contact is within poly (not over diff): poly extends pe past diff
        # diff right edge = gx + l ; poly right edge = gx + l + pe
        # contact from cx to cx+cz must be <= gx+l+pe  => cx <= gx+l+pe-cz
        cx = min(cx, gx + l + pe - cz)
        cx = max(cx, gx + l)  # start at diff edge (over poly extension)
        contact(cell, cx, gc_y)
        gate_ctrs.append((cx + cz / 2, gc_y + cz / 2))

    # source/drain contacts in shared diffusion regions (gaps between fingers)
    # gap i is between gate i and gate i+1, at x in [gx_i+l, gx_{i+1}]
    # place contact centered in gap
    for i in range(n_gaps):
        gap_left = gate_xs[i] + l
        gap_right = gate_xs[i + 1]
        gap_cx = (gap_left + gap_right) / 2
        # contact must be inside diffusion: diff from x-de to x+de+total_x... 
        # clamp to diffusion bounds minus contact size
        cx = min(max(gap_cx - cz / 2, diff_x + ce), diff_x + diff_w - cz - ce)
        cy = y  # center of diffusion in y
        contact(cell, cx, cy - cz / 2)
        if i % 2 == 0:
            source_ctrs.append((cx + cz / 2, cy))
        else:
            drain_ctrs.append((cx + cz / 2, cy))

    # if odd number of fingers, last finger's outer side needs a drain contact
    # and first finger's outer side needs a source contact (outer diffusion edges)
    # outer left diffusion edge (source side of finger 0)
    outer_left = diff_x
    outer_right = diff_x + diff_w
    # place source contact at outer left, drain at outer right
    cx = outer_left + ce
    if cx + cz <= outer_right - ce:
        contact(cell, cx, y - cz / 2)
        source_ctrs.append((cx + cz / 2, y))
    cx = outer_right - cz - ce
    if cx >= outer_left + ce:
        contact(cell, cx, y - cz / 2)
        drain_ctrs.append((cx + cz / 2, y))

    # bulk contact: well tap (diffusion inside well, opposite implant)
    # place a bulk contact in the well area but outside the main diffusion
    # We'll add a separate tap structure instead; return well bbox for tap
    return dict(
        gate=gate_ctrs, source=source_ctrs, drain=drain_ctrs,
        well=(well_x, well_y, well_w, well_h),
        diff=(diff_x, diff_y, diff_w, diff_h),
        x=x, y=y, w=w, l=l, nf=nf, kind=kind,
    )

# ----------------------------------------------------------------------
# Well tap (substrate contact): diffusion + implant inside a well
# ----------------------------------------------------------------------
def tap(cell, kind, x, y, w=0.2, h=0.2, implant_layer=None, well_layer=None):
    """kind: 'ptap' (p+ in pwell) or 'ntap' (n+ in nwell)."""
    cz = TECH["contact"]["size"]
    ce = TECH["enc"]["diff_contact"]
    ige = TECH["implant_gate_ext"]
    de = TECH["diff_ext_gate"]
    draw(cell, L[well_layer], x, y, w, h)
    # tap diffusion inside well, with enclosure
    tx = x + de
    ty = y + de
    tw = w - 2 * de
    th = h - 2 * de
    if tw < cz: tw = cz; tx = x + (w - cz) / 2
    if th < cz: th = cz; ty = y + (h - cz) / 2
    diffrect(cell, tx, ty, tw, th)
    implant(cell, implant_layer, tx - ige, ty - ige, tw + 2 * ige, th + 2 * ige)
    contact(cell, tx + (tw - cz) / 2, ty + (th - cz) / 2)
    return (tx + (tw - cz) / 2, ty + (th - cz) / 2)

# ----------------------------------------------------------------------
# Floorplan (um)
# ----------------------------------------------------------------------
# We place devices in two rows: NMOS (bottom, pwell) and PMOS (top, nwell).
# Power rails VDD (top) and VSS (bottom) run horizontally in m1.
# Vertical m2 tracks route signals between rows.

# Device parameters from netlist (each line = one finger)
devs = [
    # name, kind, x, y, w, l, nf, implant, well
    ("M1", "nmos", 1.00, 4.00, 4.0, 0.5, 2, "nplus", "pwell"),
    ("M2", "nmos", 2.70, 4.00, 4.0, 0.5, 2, "nplus", "pwell"),
    ("M5", "nmos", 4.60, 4.00, 2.0, 1.0, 4, "nplus", "pwell"),
    ("M7", "nmos", 7.00, 4.00, 2.0, 1.0, 8, "nplus", "pwell"),
    ("M8", "nmos", 10.60, 4.00, 2.0, 1.0, 2, "nplus", "pwell"),
    ("M9", "nmos", 12.30, 4.00, 2.0, 0.5, 1, "nplus", "pwell"),
    ("MC", "nmos", 13.30, 4.00, 4.0, 1.0, 8, "nplus", "pwell"),
    ("M3", "pmos", 1.00, 13.00, 4.0, 1.0, 2, "pplus", "nwell"),
    ("M4", "pmos", 2.70, 13.00, 4.0, 1.0, 2, "pplus", "nwell"),
    ("M6", "pmos", 4.60, 13.00, 4.0, 0.5, 8, "pplus", "nwell"),
]

# Place devices
mos_objs = {}
for name, kind, x, y, w, l, nf, imp, well_layer in devs:
    mos_objs[name] = mos(top, kind, x, y, w, l, nf, imp, well_layer)

# Add well taps around device rows
# PTAP ring around NMOS row (pwell), NTAP ring around PMOS row (nwell)
# NMOS row pwell: from mos M1..MC wells. We'll add a few taps.
tap(top, "ptap", 0.55, 2.6, 0.3, 0.3, "pplus", "pwell")
tap(top, "ptap", 12.6, 2.6, 0.3, 0.3, "pplus", "pwell")
tap(top, "ntap", 0.55, 11.6, 0.3, 0.3, "nplus", "nwell")
tap(top, "ntap", 12.6, 11.6, 0.3, 0.3, "nplus", "nwell")

# ----------------------------------------------------------------------
# Power rails (m1)
# ----------------------------------------------------------------------
VDD_Y = 17.2
VSS_Y = 0.4
RAIL_H = 0.5
m1rect(top, 0.0, VDD_Y, 16.0, RAIL_H)   # VDD rail
m1rect(top, 0.0, VSS_Y, 16.0, RAIL_H)   # VSS rail
pin(top, "VDD", 0.0, VDD_Y, "m1", 16.0, RAIL_H)
pin(top, "VSS", 0.0, VSS_Y, "m1", 16.0, RAIL_H)

# ----------------------------------------------------------------------
# Routing helper: connect a list of points with m1 (horizontal) + m2 (vertical)
# using vias. Simple Manhattan routing on a grid.
# ----------------------------------------------------------------------
GRID = TECH["grid"]

def snap(v):
    return round(v / GRID) * GRID

def route_h(cell, y, x1, x2, layer="m1", w=None):
    w = w or TECH["width"][layer]
    x1, x2 = sorted((x1, x2))
    draw(cell, L[layer], x1, y - w / 2, x2 - x1, w)

def route_v(cell, x, y1, y2, layer="m2", w=None):
    w = w or TECH["width"][layer]
    y1, y2 = sorted((y1, y2))
    draw(cell, L[layer], x - w / 2, y1, w, y2 - y1)

def connect(cell, pts, layer="m1", w=None, via_layer="via1", via_size=None):
    """Connect a sequence of (x,y) points with Manhattan routing on `layer`,
    adding vias to the other metal at each vertex."""
    w = w or TECH["width"][layer]
    other = "m2" if layer == "m1" else "m1"
    vs = via_size or (TECH["via1"]["size"] if via_layer == "via1" else TECH["contact"]["size"])
    for i in range(len(pts) - 1):
        x1, y1 = pts[i]
        x2, y2 = pts[i + 1]
        if abs(x1 - x2) < 1e-9:
            route_v(cell, x1, y1, y2, layer, w)
        elif abs(y1 - y2) < 1e-9:
            route_h(cell, y1, x1, x2, layer, w)
        else:
            # L-shape: horizontal then vertical
            route_h(cell, y1, x1, x2, layer, w)
            route_v(cell, x2, y1, y2, layer, w)
        # via at vertex to other metal
        if i > 0 and i < len(pts) - 1:
            via1(cell, x1, y1, vs, vs)

# ----------------------------------------------------------------------
# Net connections
# ----------------------------------------------------------------------
# We'll route signals on m2 (vertical) and m1 (horizontal segments).
# Contacts from diffusion/poly to m1, vias m1-m2.

def port_list(ports):
    return ports

# VSS rail connections: NMOS sources
# M1 sources -> tail; M2 sources -> tail; M5 sources -> VSS; M7 sources -> VSS
# M8 sources -> VSS; MC sources -> VSS

# Build tail net: M1 sources + M2 sources + M5 drains
tail_pts = []
for c in mos_objs["M1"]["source"]:
    tail_pts.append(c)
for c in mos_objs["M2"]["source"]:
    tail_pts.append(c)
for c in mos_objs["M5"]["drain"]:
    tail_pts.append(c)
# route tail: collect all source/drain points on a horizontal m1 line at y=4.0
# They are already at y=4.0 (diffusion center). Connect them with m1.
if tail_pts:
    xs = sorted(set(round(p[0], 3) for p in tail_pts))
    route_h(top, 4.0, xs[0] - 0.05, xs[-1] + 0.05, "m1", 0.1)
    # contacts already placed on diffusion; m1 over them connects

# VSS: M5 sources, M7 sources, M8 sources, MC sources, plus VSS rail
vss_pts = []
for c in mos_objs["M5"]["source"]:
    vss_pts.append(c)
for c in mos_objs["M7"]["source"]:
    vss_pts.append(c)
for c in mos_objs["M8"]["source"]:
    vss_pts.append(c)
for c in mos_objs["MC"]["source"]:
    vss_pts.append(c)
# connect to VSS rail via vertical m2 at several x positions
# route sources to a horizontal m1 line at y=4.0 then down to VSS rail
if vss_pts:
    xs = sorted(set(round(p[0], 3) for p in vss_pts))
    route_h(top, 4.0, xs[0] - 0.05, xs[-1] + 0.05, "m1", 0.1)
# vertical from y=4.0 to VSS rail at y=0.4+RAIL_H=0.9
via1_x = xs[len(xs) // 2] if xs else 6.0
route_v(top, via1_x, 0.9, 4.0, "m1", 0.1)
via1(top, via1_x, 0.9 - TECH["via1"]["size"] / 2)
# connect m1 segment to VSS rail: rail is at y=0.4..0.9, our m1 at y=0.9 touches rail

# VDD: PMOS sources (M3, M4, M6) -> VDD rail
vdd_pts = []
for c in mos_objs["M3"]["source"]:
    vdd_pts.append(c)
for c in mos_objs["M4"]["source"]:
    vdd_pts.append(c)
for c in mos_objs["M6"]["source"]:
    vdd_pts.append(c)
if vdd_pts:
    xs = sorted(set(round(p[0], 3) for p in vdd_pts))
    route_h(top, 13.0, xs[0] - 0.05, xs[-1] + 0.05, "m1", 0.1)
via1_x = xs[len(xs) // 2] if xs else 6.0
route_v(top, via1_x, 13.0, VDD_Y, "m1", 0.1)
via1(top, via1_x, VDD_Y - TECH["via1"]["size"] / 2)

# Inputs INP, INN -> gates of M2, M1
# INN -> M1 gates; INP -> M2 gates
# Route on m2 vertically from top, then m1 to gate contacts
# Place input pins on left side
pin(top, "INN", 0.0, 6.0, "m1", 0.065, 0.6)
pin(top, "INP", 0.0, 6.6, "m1", 0.065, 0.6)
# route INN to M1 gates
m1_gates = mos_objs["M1"]["gate"]
m2_gates = mos_objs["M2"]["gate"]
# vertical m2 track at x=0.5 from y=6.0 up to gate level
route_v(top, 0.5, 6.0, 13.0, "m2", 0.07)
via1(top, 0.5, 6.0)
# horizontal m1 at gate y to reach gate contacts
# M1 gates at y = 4.0 + w/2 + pe - cz/2 ... let's just route at y=4.0+2.0+... 
# simpler: route m1 horizontally at y = gate contact y
for c in m1_gates:
    route_h(top, c[1], 0.5, c[0], "m1", 0.07)
    via1(top, c[0], c[1])
for c in m2_gates:
    route_h(top, c[1], 0.5, c[0], "m1", 0.07)
    via1(top, c[0], c[1])

# IB pin -> gates of M5, M7, M8 ; drain of M8
pin(top, "IB", 16.2, 6.0, "m1", 0.065, 0.6)
ib_pts = []
ib_pts += mos_objs["M5"]["gate"]
ib_pts += mos_objs["M7"]["gate"]
ib_pts += mos_objs["M8"]["gate"]
ib_pts += mos_objs["M8"]["drain"]  # diode connected: drain = IB
# route IB on m2 at x=16.2, then m1 to each gate
route_v(top, 16.2, 6.0, 13.0, "m2", 0.07)
via1(top, 16.2, 6.0)
for c in ib_pts:
    route_h(top, c[1], 16.2, c[0], "m1", 0.07)
    via1(top, c[0], c[1])

# d1 net: M1 drains, M3 drains, M3 gates, M4 gates
d1_pts = []
d1_pts += mos_objs["M1"]["drain"]
d1_pts += mos_objs["M3"]["drain"]
d1_pts += mos_objs["M3"]["gate"]
d1_pts += mos_objs["M4"]["gate"]
# route d1: horizontal m1 at y=13.0 (PMOS row) connecting M3/M4, and vertical to M1
# M1 drains at y=4.0. Route m2 vertically.
# Collect all x positions
all_x = [p[0] for p in d1_pts]
route_h(top, 13.0, min(all_x) - 0.05, max(all_x) + 0.05, "m1", 0.1)
# connect M1 drains up to d1 line
for c in mos_objs["M1"]["drain"]:
    route_v(top, c[0], 4.0, 13.0, "m2", 0.07)
    via1(top, c[0], 4.0)
    via1(top, c[0], 13.0 - TECH["via1"]["size"] / 2)
# M3/M4 gates and drains are at y=13.0 already, m1 connects them

# d2 net: M2 drains, M4 drains, M6 gates, M9 source
d2_pts = []
d2_pts += mos_objs["M2"]["drain"]
d2_pts += mos_objs["M4"]["drain"]
d2_pts += mos_objs["M6"]["gate"]
d2_pts += mos_objs["M9"]["source"]
all_x = [p[0] for p in d2_pts]
route_h(top, 13.0, min(all_x) - 0.05, max(all_x) + 0.05, "m1", 0.1)
for c in mos_objs["M2"]["drain"]:
    route_v(top, c[0], 4.0, 13.0, "m2", 0.07)
    via1(top, c[0], 4.0)
    via1(top, c[0], 13.0 - TECH["via1"]["size"] / 2)
# M9 source at y=4.0, connect up
for c in mos_objs["M9"]["source"]:
    route_v(top, c[0], 4.0, 13.0, "m2", 0.07)
    via1(top, c[0], 4.0)
    via1(top, c[0], 13.0 - TECH["via1"]["size"] / 2)

# M9: gate = VDD, drain = x
# M9 gate contact -> VDD rail
for c in mos_objs["M9"]["gate"]:
    route_v(top, c[0], c[1], VDD_Y, "m2", 0.07)
    via1(top, c[0], c[1])
    via1(top, c[0], VDD_Y - TECH["via1"]["size"] / 2)
# M9 drain = x node
x_node = mos_objs["M9"]["drain"][0]

# MC: gate = OUT, source/drain = x node
# MC gates -> OUT; MC source/drain -> x
# Connect x node: M9 drain + MC source/drain
x_pts = [x_node] + mos_objs["MC"]["source"] + mos_objs["MC"]["drain"]
# route x on m1 at y=4.0 (MC/M9 are at y=4.0)
xs = sorted(set(round(p[0], 3) for p in x_pts))
route_h(top, 4.0, xs[0] - 0.05, xs[-1] + 0.05, "m1", 0.1)

# OUT: M6 drains, M7 drains, MC gates
pin(top, "OUT", 16.2, 12.0, "m1", 0.065, 0.6)
out_pts = []
out_pts += mos_objs["M6"]["drain"]
out_pts += mos_objs["M7"]["drain"]
out_pts += mos_objs["MC"]["gate"]
# route OUT: m2 vertical at x=16.2
route_v(top, 16.2, 12.0, 13.0, "m2", 0.07)
via1(top, 16.2, 12.0)
# connect M6/M7 drains (at y=13.0 and y=4.0) and MC gates (y=4.0)
for c in mos_objs["M6"]["drain"]:
    route_h(top, c[1], c[0], 16.2, "m1", 0.07)
    via1(top, c[0], c[1])
for c in mos_objs["M7"]["drain"]:
    route_v(top, c[0], 4.0, 12.0, "m2", 0.07)
    via1(top, c[0], 4.0)
    via1(top, 16.2, 4.0)
    route_h(top, 12.0, c[0], 16.2, "m1", 0.07)
    via1(top, c[0], 12.0)
for c in mos_objs["MC"]["gate"]:
    route_v(top, c[0], 4.0, 12.0, "m2", 0.07)
    via1(top, c[0], 4.0)
    via1(top, 16.2, 4.0)
    route_h(top, 12.0, c[0], 16.2, "m1", 0.07)
    via1(top, c[0], 12.0)

# ----------------------------------------------------------------------
# Bulk / well ties
# ----------------------------------------------------------------------
# NMOS bulk = VSS: pwell taps already connect to VSS? Tap diffusion contact -> m1.
# We need to connect pwell taps to VSS and nwell taps to VDD.
# The tap contacts are on m1 already; route them to rails.
# PTAP at (0.55,2.6) and (12.6,2.6): connect to VSS rail (y=0.4)
for tx, ty in [(0.7, 2.75), (12.75, 2.75)]:
    route_v(top, tx, 0.9, ty, "m1", 0.1)
    via1(top, tx, 0.9)
# NTAP at (0.55,11.6) and (12.6,11.6): connect to VDD rail (y=17.2)
for tx, ty in [(0.7, 11.75), (12.75, 11.75)]:
    route_v(top, tx, 13.0, 17.2, "m1", 0.1)
    via1(top, tx, 17.2 - TECH["via1"]["size"] / 2)

# ----------------------------------------------------------------------
# Boundary layer
# ----------------------------------------------------------------------
draw(top, L["boundary"], 0.0, 0.0, 16.5, 18.0)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("ota_miller.gds")
print("Written ota_miller.gds")
print("Top bbox:", top.bbox())
