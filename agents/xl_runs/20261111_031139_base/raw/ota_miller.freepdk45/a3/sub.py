import klayout.db as kdb

# ----------------------------------------------------------------------
# PDK data (freepdk45), all values in um
# ----------------------------------------------------------------------
TECH = dict(
    dbu=0.0005,
    grid=0.005,
    layers=dict(
        diff=(1, 0), pwell=(2, 0), nwell=(3, 0), nplus=(4, 0), pplus=(5, 0),
        poly=(9, 0), contact=(10, 0), m1=(11, 0), via1=(12, 0), m2=(13, 0),
        boundary=(235, 0),
    ),
    label={m: (11 + 2 * i, 1) for i, m in enumerate(
        ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])},
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
    well_enc=0.055,
    implant_gate_ext=0.07,
    gate_space=0.14,
    tap_diff_space=0.105,
    well_min_width=0.20,
    well_same_space=0.225,
    well_n_p_space=0.20,
    nwell_diff=0.055,
    pwell_diff=0.055,
)

ly = kdb.Layout()
ly.dbu = TECH["dbu"]
top = ly.create_cell("ota_miller")

L = {name: ly.layer(*spec) for name, spec in TECH["layers"].items()}
for mname, spec in TECH["label"].items():
    L[mname + "_lab"] = ly.layer(*spec)

GRID = TECH["grid"]
def snap(v):
    return round(v / GRID) * GRID

def R(x, y, w, h):
    return kdb.DBox(snap(x), snap(y), snap(x + w), snap(y + h))

def draw(cell, layer, x, y, w, h):
    cell.shapes(layer).insert(R(x, y, w, h))

def pin(cell, text, x, y, layer="m1", w=0.065, h=0.6):
    draw(cell, L[layer], x, y, w, h)
    cell.shapes(L[layer + "_lab"]).insert(
        kdb.DText(text, kdb.DTrans(snap(x + w / 2), snap(y + h / 2))))

def contact(cell, x, y, w=None, h=None, metal="m1"):
    """Contact cut with metal enclosure.  w/h default to contact size."""
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
# Transistor: nf fingers side by side in x, diffusion runs in y (width w)
# Each netlist line = one finger.  Adjacent fingers share the diffusion
# region between them; the shared net must be identical.
# Layout (left to right):  region0 | gate0 | region1 | gate1 | ... | regionN
# region0 = snets[0], region i (1..nf-1) = dnets[i-1] == snets[i], region nf = dnets[nf-1]
# Returns dict with gate_contacts and diff_contacts [(x,y,net)].
# ----------------------------------------------------------------------
def mos(cell, kind, x, y, w, l, nf, dnets, snets, gnet, bnet,
        implant_layer, well_layer):
    ps = TECH["gate_space"]          # gate-to-gate spacing (POLY.2 = 140nm)
    pe = TECH["poly_endcap"]         # poly past active
    de = TECH["diff_ext_gate"]       # active past gate (POLY.4 = 70nm)
    ce = TECH["enc"]["diff_contact"] # contact enclosure on diff
    cz = TECH["contact"]["size"]     # contact size
    ige = TECH["implant_gate_ext"]   # implant past gate
    we = TECH["well_enc"]            # well enclosure of active

    # Outer diffusion regions must be wide enough for a contact with enclosure:
    # need cz + 2*ce = 0.075, and also de = 0.07 overhang past gate.  Use 0.08.
    outer = 0.08
    inner = ps                       # gap between gates = 0.14, fits contact

    # Diffusion region widths
    reg_w = [outer] + [inner] * (nf - 1) + [outer]

    # X positions of gates and regions
    cur = x
    gate_xs = []
    reg_xs = []
    for i in range(nf):
        reg_xs.append(cur)
        cur += reg_w[i]
        gate_xs.append(cur)
        cur += l
        if i < nf - 1:
            cur += ps  # gap to next gate (inner region width)
    reg_xs.append(cur)
    cur += reg_w[nf]

    diff_x = reg_xs[0]
    diff_y = y - w / 2 - de
    diff_w = cur - reg_xs[0]
    diff_h = w + 2 * de

    well_x = diff_x - we
    well_y = diff_y - we
    well_w = diff_w + 2 * we
    well_h = diff_h + 2 * we

    imp_x = diff_x - ige
    imp_y = diff_y - ige
    imp_w = diff_w + 2 * ige
    imp_h = diff_h + 2 * ige

    # Draw well, diffusion, implant
    well(cell, well_layer, well_x, well_y, well_w, well_h)
    diffrect(cell, diff_x, diff_y, diff_w, diff_h)
    implant(cell, implant_layer, imp_x, imp_y, imp_w, imp_h)

    # Poly gates with endcap past diffusion
    gate_contacts = []
    for i, gx in enumerate(gate_xs):
        polyrect(cell, gx, y - w / 2 - pe, l, w + 2 * pe)
        # Gate contact on poly, to the right of gate, within endcap
        cz_ = TECH["contact"]["size"]
        cx = gx + l + pe - cz_
        cx = max(cx, gx + l)  # must be on poly extension, not over diff
        cy = y + w / 2 + pe - cz_ / 2
        contact(cell, cx, cy)
        gate_contacts.append((cx + cz_ / 2, cy + cz_ / 2))

    # Diffusion contacts: one per region, centered
    diff_contacts = []
    for i in range(nf + 1):
        rx = reg_xs[i]
        rw = reg_w[i]
        net = snets[0] if i == 0 else (dnets[nf - 1] if i == nf else dnets[i - 1])
        # sanity: shared region consistency
        if 1 <= i <= nf - 1:
            assert dnets[i - 1] == snets[i], f"{kind}: region {i} net mismatch"
        cx = rx + rw / 2 - cz / 2
        # clamp inside region with enclosure
        cx = min(max(cx, rx + ce), rx + rw - cz - ce)
        cy = y
        contact(cell, cx, cy - cz / 2)
        diff_contacts.append((cx + cz / 2, cy, net))

    return dict(gate=gate_contacts, diff=diff_contacts,
                well=(well_x, well_y, well_w, well_h),
                x=x, y=y, w=w, l=l, nf=nf, kind=kind,
                bnet=bnet, gnet=gnet)

def tap(cell, kind, x, y, w=0.3, h=0.3, implant_layer=None, well_layer=None):
    """Well tap: diffusion + implant inside well, contact to bulk net."""
    cz = TECH["contact"]["size"]
    ce = TECH["enc"]["diff_contact"]
    de = TECH["diff_ext_gate"]
    draw(cell, L[well_layer], x, y, w, h)
    tx = x + de
    ty = y + de
    tw = w - 2 * de
    th = h - 2 * de
    if tw < cz:
        tw = cz; tx = x + (w - cz) / 2
    if th < cz:
        th = cz; ty = y + (h - cz) / 2
    diffrect(cell, tx, ty, tw, th)
    ige = TECH["implant_gate_ext"]
    implant(cell, implant_layer, tx - ige, ty - ige, tw + 2 * ige, th + 2 * ige)
    contact(cell, tx + (tw - cz) / 2, ty + (th - cz) / 2)
    return (tx + (tw - cz) / 2, ty + (th - cz) / 2)

# ----------------------------------------------------------------------
# Net collection
# ----------------------------------------------------------------------
nets = {}

def add_net(net, pts):
    if net not in nets:
        nets[net] = []
    nets[net].extend(pts)

# ----------------------------------------------------------------------
# Floorplan: place devices left to right, two rows
# ----------------------------------------------------------------------
Y_NMOS = 5.0
Y_PMOS = 13.0
X = 0.6
GAP = 0.30

devs = [
    # name, kind, w, l, nf, dnets, snets, gnet, bnet, implant, well
    ("M1", "nmos", 4.0, 0.5, 2, ["d1", "tail"], ["tail", "d1"], "INN", "VSS", "nplus", "pwell"),
    ("M2", "nmos", 4.0, 0.5, 2, ["d2", "tail"], ["tail", "d2"], "INP", "VSS", "nplus", "pwell"),
    ("M5", "nmos", 2.0, 1.0, 4, ["tail", "VSS", "tail", "VSS"],
     ["VSS", "tail", "VSS", "tail"], "IB", "VSS", "nplus", "pwell"),
    ("M7", "nmos", 2.0, 1.0, 8,
     ["OUT", "VSS", "OUT", "VSS", "OUT", "VSS", "OUT", "VSS"],
     ["VSS", "OUT", "VSS", "OUT", "VSS", "OUT", "VSS", "OUT"], "IB", "VSS",
     "nplus", "pwell"),
    ("M8", "nmos", 2.0, 1.0, 2, ["IB", "VSS"], ["VSS", "IB"], "IB", "VSS",
     "nplus", "pwell"),
    ("M9", "nmos", 2.0, 0.5, 1, ["x"], ["d2"], "VDD", "VSS", "nplus", "pwell"),
    ("MC", "nmos", 4.0, 1.0, 8, ["x"] * 8, ["x"] * 8, "OUT", "VSS",
     "nplus", "pwell"),
    ("M3", "pmos", 4.0, 1.0, 2, ["d1", "VDD"], ["VDD", "d1"], "d1", "VDD",
     "pplus", "nwell"),
    ("M4", "pmos", 4.0, 1.0, 2, ["d2", "VDD"], ["VDD", "d2"], "d1", "VDD",
     "pplus", "nwell"),
    ("M6", "pmos", 4.0, 0.5, 8,
     ["OUT", "VDD", "OUT", "VDD", "OUT", "VDD", "OUT", "VDD"],
     ["VDD", "OUT", "VDD", "OUT", "VDD", "OUT", "VDD", "OUT"], "d2", "VDD",
     "pplus", "nwell"),
]

mos_objs = {}
for name, kind, w, l, nf, dnets, snets, gnet, bnet, imp, well_layer in devs:
    mos_objs[name] = mos(top, kind, X, Y_NMOS if kind == "nmos" else Y_PMOS,
                         w, l, nf, dnets, snets, gnet, bnet, imp, well_layer)
    wx, wy, ww, wh = mos_objs[name]["well"]
    X = wx + ww + GAP

TOTAL_X = X

# Register contacts to nets
for name, m in mos_objs.items():
    for (cx, cy, net) in m["diff"]:
        add_net(net, [(cx, cy)])
    for (cx, cy) in m["gate"]:
        add_net(m["gnet"], [(cx, cy)])

# ----------------------------------------------------------------------
# Power rails (m1)
# ----------------------------------------------------------------------
VDD_Y = 17.4
VSS_Y = 0.2
RAIL_H = 0.6
RAIL_W = TOTAL_X + 1.0
m1rect(top, 0.0, VDD_Y, RAIL_W, RAIL_H)
m1rect(top, 0.0, VSS_Y, RAIL_W, RAIL_H)
pin(top, "VDD", 0.0, VDD_Y, "m1", RAIL_W, RAIL_H)
pin(top, "VSS", 0.0, VSS_Y, "m1", RAIL_W, RAIL_H)
add_net("VDD", [(RAIL_W / 2, VDD_Y + RAIL_H / 2)])
add_net("VSS", [(RAIL_W / 2, VSS_Y + RAIL_H / 2)])

# ----------------------------------------------------------------------
# I/O pins
# ----------------------------------------------------------------------
pin(top, "INP", 0.15, 7.6, "m1", 0.065, 0.5)
pin(top, "INN", 0.15, 7.0, "m1", 0.065, 0.5)
pin(top, "IB", TOTAL_X + 0.15, 7.6, "m1", 0.065, 0.5)
pin(top, "OUT", TOTAL_X + 0.15, 12.4, "m1", 0.065, 0.5)
add_net("INP", [(0.15 + 0.0325, 7.6 + 0.25)])
add_net("INN", [(0.15 + 0.0325, 7.0 + 0.25)])
add_net("IB", [(TOTAL_X + 0.15 + 0.0325, 7.6 + 0.25)])
add_net("OUT", [(TOTAL_X + 0.15 + 0.0325, 12.4 + 0.25)])

# ----------------------------------------------------------------------
# Routing: connect all points of each net on m1/m2 with vias
# Strategy: horizontal m1 trunk at median y, vertical m2 drops to each point.
# ----------------------------------------------------------------------
def route_net(net, pts, h_layer="m1", v_layer="m2", h_w=None, v_w=None):
    if len(pts) < 2:
        return
    h_w = h_w or TECH["width"][h_layer]
    v_w = v_w or TECH["width"][v_layer]
    vs = TECH["via1"]["size"]
    pts = sorted(set((round(p[0], 4), round(p[1], 4)) for p in pts))
    ys = sorted(p[1] for p in pts)
    trunk_y = ys[len(ys) // 2]
    xs = [p[0] for p in pts]
    x_min, x_max = min(xs), max(xs)
    # horizontal trunk on m1
    m1rect(top, x_min, trunk_y - h_w / 2, x_max - x_min, h_w)
    # vertical drops + vias
    for (px, py) in pts:
        if abs(py - trunk_y) > 1e-9:
            y_lo = min(py, trunk_y)
            y_hi = max(py, trunk_y)
            m1rect(top, px - v_w / 2, y_lo, v_w, y_hi - y_lo)
            via1(top, px, trunk_y - vs / 2)
        # ensure m1 touches the point (contact enclosure already does this,
        # but add a small m1 pad for safety)
        m1rect(top, px - h_w / 2, py - h_w / 2, h_w, h_w)

for net, pts in nets.items():
    if net.endswith("_well"):
        continue
    route_net(net, pts)

# ----------------------------------------------------------------------
# Well / bulk ties: place a tap in each well and route to its bulk rail
# ----------------------------------------------------------------------
tap_x = 0.5
for name, m in mos_objs.items():
    bnet = m["bnet"]
    wx, wy, ww, wh = m["well"]
    if bnet == "VSS":
        rail_y = VSS_Y + RAIL_H / 2
        tap_y = Y_NMOS
        well_layer = "pwell"
        imp_layer = "pplus"
    else:
        rail_y = VDD_Y + RAIL_H / 2
        tap_y = Y_PMOS
        well_layer = "nwell"
        imp_layer = "nplus"
    # place tap just to the right of the well
    tx = wx + ww + 0.05
    ty = tap_y - 0.15
    tcx, tcy = tap(top, bnet, tx, ty, w=0.3, h=0.3,
                   implant_layer=imp_layer, well_layer=well_layer)
    add_net(bnet, [(tcx, tcy)])
    route_net(bnet, [(tcx, tcy), (tcx, rail_y)])

# ----------------------------------------------------------------------
# Boundary
# ----------------------------------------------------------------------
draw(top, L["boundary"], 0.0, 0.0, TOTAL_X + 1.0, 18.5)

# ----------------------------------------------------------------------
# Write GDS
# ----------------------------------------------------------------------
ly.write("ota_miller.gds")
print("Written ota_miller.gds")
print("Top bbox:", top.bbox())
print("Area um2:", top.bbox().width() * top.bbox().height())
print("Nets:", sorted(nets.keys()))

