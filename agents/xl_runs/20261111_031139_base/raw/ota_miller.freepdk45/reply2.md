```
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
    gate_contact_space=0.035,
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
# region between them; the shared net is consistent in the netlist.
# Returns dict with gate_contacts [(x,y)] and diff_contacts [(x,y,net)].
# ----------------------------------------------------------------------
def mos(cell, kind, x, y, w, l, nf, dnets, snets, gnet, bnet,
        implant_layer, well_layer):
    ps = TECH["space"]["poly"]
    pe = TECH["poly_endcap"]
    de = TECH["diff_ext_gate"]
    ce = TECH["enc"]["diff_contact"]
    cz = TECH["contact"]["size"]
    cs = TECH["contact"]["space"]
    ige = TECH["implant_gate_ext"]
    we = TECH["well_enc"]

    pitch = l + ps
    # diffusion regions: nf+1 regions, region j between finger j-1 and j
    # region 0 is left of finger 0, region nf is right of finger nf-1
    diff_nets = [snets[0]] + [dnets[i] for i in range(nf)]
    # verify consistency: Dnet[i] == Snet[i+1]
    for i in range(nf - 1):
        assert dnets[i] == snets[i + 1], f"diffusion mismatch {kind} finger {i}"

    total_x = nf * l + (nf - 1) * ps + 2 * de
    diff_x = x - de
    diff_y = y - w / 2 - de
    diff_w = total_x
    diff_h = w + 2 * de

    well_x = diff_x - we
    well_y = diff_y - we
    well_w = diff_w + 2 * we
    well_h = diff_h + 2 * we

    imp_x = diff_x - ige
    imp_y = diff_y - ige
    imp_w = diff_w + 2 * ige
    imp_h = diff_h + 2 * ige

    well(cell, well_layer, well_x, well_y, well_w, well_h)
    diffrect(cell, diff_x, diff_y, diff_w, diff_h)
    implant(cell, implant_layer, imp_x, imp_y, imp_w, imp_h)

    gate_xs = [x + i * pitch for i in range(nf)]
    for gx in gate_xs:
        polyrect(cell, gx, y - w / 2 - pe, l, w + 2 * pe)

    gate_contacts = []
    diff_contacts = []
    gc_y = y + w / 2 + pe - cz / 2
    for i, gx in enumerate(gate_xs):
        cx = gx + l - cz
        cx = min(cx, gx + l + pe - cz)
        cx = max(cx, gx + l)
        contact(cell, cx, gc_y)
        gate_contacts.append((cx + cz / 2, gc_y + cz / 2))

    # one contact per diffusion region, centered
    region_w = diff_w / (nf + 1)
    for j in range(nf + 1):
        rx = diff_x + j * region_w + region_w / 2 - cz / 2
        rx = min(max(rx, diff_x + ce), diff_x + diff_w - cz - ce)
        contact(cell, rx, y - cz / 2)
        diff_contacts.append((rx + cz / 2, y, diff_nets[j]))

    return dict(gate=gate_contacts, diff=diff_contacts,
                well=(well_x, well_y, well_w, well_h),
                x=x, y=y, w=w, l=l, nf=nf, kind=kind,
                bnet=bnet, gnet=gnet)

def tap(cell, kind, x, y, w=0.3, h=0.3, implant_layer=None, well_layer=None):
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
# Nets collection
# ----------------------------------------------------------------------
nets = {}   # net name -> list of (x,y) contact points to connect

def add_net(net, pts):
    if net not in nets:
        nets[net] = []
    nets[net].extend(pts)

# ----------------------------------------------------------------------
# Floorplan
# ----------------------------------------------------------------------
Y_NMOS = 5.0
Y_PMOS = 13.0
X = 0.6
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
    X += (mos_objs[name]["well"][2] + 0.30)  # well width + gap

TOTAL_X = X

# ----------------------------------------------------------------------
# Register diffusion and gate contacts to nets
# ----------------------------------------------------------------------
for name, m in mos_objs.items():
    for (cx, cy, net) in m["diff"]:
        add_net(net, [(cx, cy)])
    for (cx, cy) in m["gate"]:
        add_net(m["gnet"], [(cx, cy)])
    # bulk: connect well tap later; mark well bbox
    add_net(m["bnet"] + "_well", [m["well"]])

# ----------------------------------------------------------------------
# Power rails
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
# ----------------------------------------------------------------------
def route_net(net, pts, h_layer="m1", v_layer="m2", h_w=None, v_w=None):
    if len(pts) < 2:
        return
    h_w = h_w or TECH["width"][h_layer]
    v_w = v_w or TECH["width"][v_layer]
    vs = TECH["via1"]["size"]
    # sort and dedupe
    pts = sorted(set((round(p[0], 4), round(p[1], 4)) for p in pts))
    # route: pick a horizontal trunk y = median y, vertical drops to each point
    ys = sorted(p[1] for p in pts)
    trunk_y = ys[len(ys) // 2]
    xs = [p[0] for p in pts]
    x_min, x_max = min(xs), max(xs)
    # horizontal trunk
    m1rect(top, x_min, trunk_y - h_w / 2, x_max - x_min, h_w)
    # vertical drops + vias to each point
    for (px, py) in pts:
        if abs(py - trunk_y) > 1e-9:
            m1rect(top, px - v_w / 2, min(py, trunk_y), v_w, abs(py - trunk_y))
            # via at trunk
            via1(top, px, trunk_y - vs / 2)
        # contact from point (already on m1 via contact enclosure) - the contact
        # metal enclosure already connects to m1; ensure m1 touches the point
        m1rect(top, px - h_w / 2, py - h_w / 2, h_w, h_w)

# Route each net
for net, pts in nets.items():
    if net.endswith("_well"):
        continue
    route_net(net, pts)

# ----------------------------------------------------------------------
# Well / bulk ties: connect each well to its bulk net via a tap
# ----------------------------------------------------------------------
# Place taps near each device well and route to rail
tap_x = 0.5
for name, m in mos_objs.items():
    bnet = m["bnet"]
    wx, wy, ww, wh = m["well"]
    # tap just outside the well, same row
    if bnet == "VSS":
        rail_y = VSS_Y + RAIL_H / 2
        tap_y = Y_NMOS
    else:
        rail_y = VDD_Y + RAIL_H / 2
        tap_y = Y_PMOS
    # place tap diffusion contact at well edge
    tx = wx + ww + 0.05
    ty = tap_y
    # tap structure
    cz = TECH["contact"]["size"]
    ce = TECH["enc"]["diff_contact"]
    de = TECH["diff_ext_gate"]
    tw = max(0.2, cz + 2 * ce)
    th = max(0.2, cz + 2 * ce)
    tdx = tx - de
    tdy = ty - th / 2
    well_layer = "pwell" if bnet == "VSS" else "nwell"
    imp_layer = "pplus" if bnet == "VSS" else "nplus"
    draw(top, L[well_layer], wx, wy, ww, wh)  # ensure well drawn (already)
    draw(top, L[well_layer], tdx - 0.05, tdy - 0.05, tw + 0.1, th + 0.1)
    diffrect(top, tdx, tdy, tw, th)
    ige = TECH["implant_gate_ext"]
    implant(top, imp_layer, tdx - ige, tdy - ige, tw + 2 * ige, th + 2 * ige)
    contact(top, tdx + (tw - cz) / 2, tdy + (th - cz) / 2)
    tcx = tdx + (tw - cz) / 2
    tcy = tdy + (th - cz) / 2
    add_net(bnet, [(tcx, tcy)])
    # route tap contact to rail
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

```