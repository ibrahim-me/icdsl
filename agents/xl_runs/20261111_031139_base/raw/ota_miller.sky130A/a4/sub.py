import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data (sky130A)
# ---------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "polyres": (66, 13),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20),
        "via2": (69, 44), "m3": (70, 20), "via3": (70, 44),
        "m4": (71, 20), "capm": (89, 44),
        "boundary": (235, 4),
    },
    label={"poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5),
           "m3": (70, 5), "m4": (71, 5), "nwell": (64, 5), "pwell": (64, 59)},
    pin={"poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16),
         "m3": (70, 16), "m4": (71, 16), "nwell": (64, 16), "pwell": (122, 16)},
    rules=dict(
        poly_endcap=0.13, diff_ext_gate=0.25, gate_contact_space=0.055,
        polycontact_diff_space=0.19,
    ),
    devices={
        "nmos": dict(type="mos", model="sky130_fd_pr__nfet_01v8", diff="diff",
                     implant="nsdm", well=None, lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(type="mos", model="sky130_fd_pr__pfet_01v8", diff="diff",
                     implant="psdm", well="nwell", lmin=0.15, wmin=0.42, bulk="VDD"),
        "ptap": dict(type="tap", diff="tap", implant="psdm", well=None),
        "ntap": dict(type="tap", diff="tap", implant="nsdm", well="nwell"),
        "res_poly": dict(type="res", model="sky130_fd_pr__res_generic_po",
                         body="poly", markers=[("polyres", 0.0)], wmin=0.33,
                         lmin=0.5, terminals=2, contact="poly"),
        "cap_mim": dict(type="mim", model="sky130_fd_pr__cap_mim_m3_1",
                        bottom="m3", plate="capm", top="m4", cut="via3",
                        wmin=2.0, bottom_enc=0.14, cut_enc=0.2),
    },
    supplies=dict(power="VDD", ground="VSS"),
)

# ---------------------------------------------------------------------------
# Layout database
# ---------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell("ota_miller")

def LYR(name):
    g, dt = TECH["layers"][name]
    return ly.layer(g, dt)

L = {n: LYR(n) for n in TECH["layers"]}
LAB = {n: ly.layer(*TECH["label"][n]) for n in TECH["label"]}
PIN = {n: ly.layer(*TECH["pin"][n]) for n in TECH["pin"]}

def dbu(um):
    return int(round(um / ly.dbu))

def box(layer, x, y, w, h):
    top.shapes(L[layer]).insert(kdb.DBox(dbu(x), dbu(y), dbu(x + w), dbu(y + h)))

def tlabel(layer, text, x, y):
    top.shapes(LAB[layer]).insert(kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))

def tpin(layer, text, x, y, w, h):
    top.shapes(PIN[layer]).insert(kdb.DBox(dbu(x), dbu(y), dbu(x + w), dbu(y + h)))
    tlabel(layer, text, x + w / 2, y + h / 2)

def via_stack(x, y, w, h, metals, vias):
    for i, m in enumerate(metals):
        box(m, x, y, w, h)
        if i < len(vias):
            box(vias[i], x, y, w, h)

def diff_contact(x, y, net=None):
    """licon on diff, enclosed by li (0.08) and diff (0.04). Size 0.17x0.17."""
    cs = 0.17
    box("licon", x, y, cs, cs)
    box("diff", x - 0.04, y - 0.04, cs + 0.08, cs + 0.08)
    box("li", x - 0.08, y - 0.08, cs + 0.16, cs + 0.16)
    if net:
        box("m1", x - 0.1, y - 0.1, cs + 0.2, cs + 0.2)
        tlabel("m1", net, x + cs / 2, y + cs / 2)

def poly_contact(x, y, net=None):
    """licon on poly, enclosed by npc (0.10) and poly (0.05). Size 0.17x0.17."""
    cs = 0.17
    box("licon", x, y, cs, cs)
    box("poly", x - 0.05, y - 0.05, cs + 0.10, cs + 0.10)
    box("npc", x - 0.10, y - 0.10, cs + 0.20, cs + 0.20)
    if net:
        box("m1", x - 0.1, y - 0.1, cs + 0.2, cs + 0.2)
        tlabel("m1", net, x + cs / 2, y + cs / 2)

def mos(dev, x, y, w, l, gate_net, s_net, d_net, b_net):
    """One MOS finger. Gate along y (width W), channel L in x. Source=left, Drain=right."""
    t = TECH["rules"]
    pe = t["poly_endcap"]
    de = t["diff_ext_gate"]
    gcs = t["gate_contact_space"]
    diff = dev["diff"]
    impl = dev.get("implant")
    well = dev.get("well")

    if well:
        box(well, x - 0.2, y - 0.2, w + 0.4, l + 0.4)
    if impl:
        box(impl, x - 0.1, y - 0.1, w + 0.2, l + 0.2)

    # diffusion
    box(diff, x, y, l + 2 * de, w)
    # gate (poly)
    box("poly", x + de - pe, y - pe, l + 2 * pe, w + 2 * pe)

    cs = 0.17
    # source contact (left of gate)
    sx = x + de - gcs - cs
    # drain contact (right of gate)
    dx_ = x + de + l + gcs
    diff_contact(sx, y + w / 2 - cs / 2, s_net)
    diff_contact(dx_, y + w / 2 - cs / 2, d_net)

    # gate contact on poly (center of gate, top edge)
    gcx = x + de - pe + l / 2 - cs / 2
    gcy = y - pe - gcs - cs
    poly_contact(gcx, gcy, gate_net)

    # m1 over source/drain/gate contacts already added by diff_contact/poly_contact
    # connect gate poly to m1 gate contact (m1 box already there)

def res_poly(x, y, w, l, net1, net2):
    pe = TECH["rules"]["poly_endcap"]
    box("poly", x - pe, y - pe, l + 2 * pe, w + 2 * pe)
    box("polyres", x, y, l, w)
    box("npc", x - 0.1, y - 0.1, l + 0.2, w + 0.2)
    cs = 0.17
    # bottom contact (net1)
    poly_contact(x + l / 2 - cs / 2, y - pe - 0.08 - cs, net1)
    # top contact (net2)
    poly_contact(x + l / 2 - cs / 2, y + w + pe + 0.08, net2)

def mim_cap(x, y, w, l, net_bot, net_top):
    be = TECH["devices"]["cap_mim"]["bottom_enc"]
    box("m3", x - be, y - be, w + 2 * be, l + 2 * be)
    box("capm", x, y, w, l)
    box("m4", x - be, y - be, w + 2 * be, l + 2 * be)
    # via3 array
    vs = 0.20
    vsp = 0.20
    nx = max(1, int((w - vs) / (vs + vsp)) + 1)
    ny = max(1, int((l - vs) / (vs + vsp)) + 1)
    ox = x + (w - (nx * vs + (nx - 1) * vsp)) / 2
    oy = y + (l - (ny * vs + (ny - 1) * vsp)) / 2
    for i in range(nx):
        for j in range(ny):
            via_stack(ox + i * (vs + vsp), oy + j * (vs + vsp), vs, vs,
                      ["m3", "m4"], ["via3"])
    tlabel("m3", net_bot, x + w / 2, y - be - 0.2)
    tlabel("m4", net_top, x + w / 2, y + l + be + 0.2)

def tap(x, y, w, l, net, kind):
    dev = TECH["devices"][kind]
    diff = dev["diff"]
    impl = dev.get("implant")
    box(diff, x, y, w, l)
    if impl:
        box(impl, x - 0.1, y - 0.1, w + 0.2, l + 0.2)
    diff_contact(x + w / 2 - 0.085, y + l / 2 - 0.085, net)

def rail(layer, net, y, x0, x1, lx=None):
    box(layer, x0, y, x1 - x0, 0.14)
    tlabel(layer, net, lx if lx is not None else (x0 + x1) / 2, y)

def vrail(layer, net, x, y0, y1, ly_=None):
    box(layer, x, y0, 0.14, y1 - y0)
    tlabel(layer, net, x, ly_ if ly_ is not None else (y0 + y1) / 2)

# ---------------------------------------------------------------------------
# Floorplan (compact, ~70 x 25 um)
# ---------------------------------------------------------------------------
X0, Y0 = 0.0, 0.0
pitch = 3.2          # finger pitch in x
row_h = 8.0          # row height
nmos_y = Y0 + 1.5    # NMOS row
pmos_y = Y0 + 13.5   # PMOS row
vss_y = Y0 + 0.0     # VSS rail
vdd_y = Y0 + 22.0    # VDD rail

# Device placement order: (devname, dnet, gnet, snet, bnet, w, l, nf)
order = [
    ("nmos", "IB",  "IB",  "VSS", "VSS", 2, 1, 2),   # M8
    ("nmos", "tail","IB",  "VSS", "VSS", 2, 1, 4),   # M5
    ("nmos", "OUT","IB",  "VSS", "VSS", 2, 1, 8),    # M7
    ("nmos", "d1", "INN", "tail","VSS", 4, 0.5, 2),  # M1
    ("nmos", "d2", "INP", "tail","VSS", 4, 0.5, 2),  # M2
    ("pmos", "d1", "d1",  "VDD", "VDD", 4, 1, 2),    # M3
    ("pmos", "d2", "d1",  "VDD", "VDD", 4, 1, 2),    # M4
    ("pmos", "OUT","d2",  "VDD", "VDD", 4, 0.5, 8),  # M6
]

x = X0
for devname, dnet, gnet, snet, bnet, w, l, nf in order:
    dev = TECH["devices"][devname]
    row_y = nmos_y if devname == "nmos" else pmos_y
    for f in range(nf):
        mos(dev, x, row_y, w, l, gnet, snet, dnet, bnet)
        x += pitch
    x += 2.0

# Resistor RZ: d2 -> x
res_x = x
res_poly(res_x, nmos_y + 2.0, 1.0, 8.0, "d2", "x")
x = res_x + 12.0

# MIM cap CC: x -> OUT
cap_x = x
mim_cap(cap_x, pmos_y + 2.0, 20.0, 20.0, "x", "OUT")
x = cap_x + 26.0

# Taps
tap(x, nmos_y, 2.0, 2.0, "VSS", "ntap")
x += 6.0
tap(x, pmos_y, 2.0, 2.0, "VDD", "ptap")
x += 6.0

xmax = x + 4.0

# ---------------------------------------------------------------------------
# Power rails (m1 horizontal)
# ---------------------------------------------------------------------------
rail("m1", "VSS", vss_y, X0 - 2, xmax + 2, X0)
rail("m1", "VDD", vdd_y, X0 - 2, xmax + 2, X0)

# Local signal rails (m1 horizontal) at device rows
rail("m1", "tail", nmos_y + row_h + 0.5, X0, xmax, X0)
rail("m1", "d1", nmos_y + row_h + 2.5, X0, xmax, X0)
rail("m1", "d2", nmos_y + row_h + 4.5, X0, xmax, X0)
rail("m1", "OUT", pmos_y - 1.0, X0, xmax, X0)
rail("m1", "IB", pmos_y - 3.0, X0, xmax, X0)
rail("m1", "INP", pmos_y - 5.0, X0, xmax, X0)
rail("m1", "INN", pmos_y - 7.0, X0, xmax, X0)

# ---------------------------------------------------------------------------
# Vertical m2 rails + vias to m1
# ---------------------------------------------------------------------------
rail_nets = ["VSS", "VDD", "tail", "d1", "d2", "OUT", "IB", "INP", "INN", "x"]
rail_x = {}
xr = X0 + 2.0
for net in rail_nets:
    rail_x[net] = xr
    xr += 3.5

for net in rail_nets:
    rx = rail_x[net]
    # find y for this net's m1 rail
    ymap = {"VSS": vss_y, "VDD": vdd_y, "tail": nmos_y + row_h + 0.5,
            "d1": nmos_y + row_h + 2.5, "d2": nmos_y + row_h + 4.5,
            "OUT": pmos_y - 1.0, "IB": pmos_y - 3.0, "INP": pmos_y - 5.0,
            "INN": pmos_y - 7.0, "x": nmos_y + 2.0}
    ry = ymap[net]
    vrail("m2", net, rx, Y0 - 1, Y0 + 24, ry)
    via_stack(rx - 0.075, ry - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])

# ---------------------------------------------------------------------------
# Connect device source/drain/gate m1 dots to vertical m2 rails
# ---------------------------------------------------------------------------
x = X0
for devname, dnet, gnet, snet, bnet, w, l, nf in order:
    dev = TECH["devices"][devname]
    t = TECH["rules"]
    pe = t["poly_endcap"]
    de = t["diff_ext_gate"]
    gcs = t["gate_contact_space"]
    cs = 0.17
    row_y = nmos_y if devname == "nmos" else pmos_y
    for f in range(nf):
        # source m1 dot
        sx = x + de - gcs - cs
        sy = row_y + w / 2 - 0.07
        rx = rail_x[snet]
        x1 = min(sx + cs / 2, rx - 0.1)
        x2 = max(sx + cs / 2, rx + 0.1)
        box("m1", x1, sy - 0.07, x2 - x1, 0.14)
        via_stack(rx - 0.075, sy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        # drain m1 dot
        dx_ = x + de + l + gcs
        rx = rail_x[dnet]
        x1 = min(dx_ + cs / 2, rx - 0.1)
        x2 = max(dx_ + cs / 2, rx + 0.1)
        box("m1", x1, sy - 0.07, x2 - x1, 0.14)
        via_stack(rx - 0.075, sy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        # gate m1 dot (over poly contact)
        gcx = x + de - pe + l / 2 - cs / 2
        gcy = row_y - pe - gcs - cs + cs / 2
        rx = rail_x[gnet]
        x1 = min(gcx, rx - 0.1)
        x2 = max(gcx + cs, rx + 0.1)
        box("m1", x1, gcy - 0.07, x2 - x1, 0.14)
        via_stack(rx - 0.075, gcy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        x += pitch
    x += 2.0

# ---------------------------------------------------------------------------
# Resistor and cap connections to m2 rails
# ---------------------------------------------------------------------------
# Resistor: bottom contact (d2) at res_x + 4, y = nmos_y+2 - pe - 0.08 - cs
cs = 0.17
pe = TECH["rules"]["poly_endcap"]
rbx = res_x + 4.0 - cs / 2
rby = nmos_y + 2.0 - pe - 0.08 - cs
box("m1", rbx - 0.2, rby - 0.2, 0.4, 0.4)
via_stack(rail_x["d2"] - 0.075, rby - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
box("m1", min(rbx, rail_x["d2"] - 0.1), rby - 0.07,
    abs(rbx - rail_x["d2"]) + 0.4, 0.14)

# Resistor top contact (x)
rby2 = nmos_y + 2.0 + 1.0 + pe + 0.08
box("m1", rbx - 0.2, rby2 - 0.2, 0.4, 0.4)
via_stack(rail_x["x"] - 0.075, rby2 - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
box("m1", min(rbx, rail_x["x"] - 0.1), rby2 - 0.07,
    abs(rbx - rail_x["x"]) + 0.4, 0.14)

# Cap: bottom m3 -> m2 rail x (via2)
cbx = cap_x + 10.0
cby = pmos_y + 2.0 - 0.1
via_stack(rail_x["x"] - 0.1, cby - 0.1, 0.2, 0.2, ["m2", "m3"], ["via2"])
box("m3", rail_x["x"] - 0.1, cby - 0.1, 0.2, 0.2)

# Cap: top m4 -> m2 rail OUT (via2 + via3)
cby2 = pmos_y + 2.0 + 20.0 + 0.1
via_stack(rail_x["OUT"] - 0.1, cby2 - 0.1, 0.2, 0.2, ["m2", "m3", "m4"], ["via2", "via3"])
box("m4", rail_x["OUT"] - 0.1, cby2 - 0.1, 0.2, 0.2)

# ---------------------------------------------------------------------------
# Pins
# ---------------------------------------------------------------------------
for net in ["INP", "INN", "OUT", "IB", "VDD", "VSS"]:
    ymap = {"INP": pmos_y - 5.0, "INN": pmos_y - 7.0, "OUT": pmos_y - 1.0,
            "IB": pmos_y - 3.0, "VDD": vdd_y, "VSS": vss_y}
    tpin("m1", net, X0 - 2.5, ymap[net] - 0.07, 2.5, 0.14)

# ---------------------------------------------------------------------------
# Boundary
# ---------------------------------------------------------------------------
box("boundary", X0 - 5, Y0 - 5, xmax - X0 + 10, 29)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
ly.write("ota_miller.gds")
print("written ota_miller.gds")
bb = top.bbox()
print("bbox um:", bb.left * ly.dbu, bb.bottom * ly.dbu,
      bb.right * ly.dbu, bb.top * ly.dbu)
print("area um2:", (bb.right - bb.left) * ly.dbu * (bb.top - bb.bottom) * ly.dbu)


