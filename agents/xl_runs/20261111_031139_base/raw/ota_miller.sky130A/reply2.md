```
import klayout.db as kdb

# ---------------------------------------------------------------------------
# PDK data (sky130A) - layers as (gds, datatype), rules in um
# ---------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "pwell": (64, 44), "dnwell": (64, 18),
        "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "polyres": (66, 13),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20),
        "via2": (69, 44), "m3": (70, 20), "via3": (70, 44),
        "m4": (71, 20), "via4": (71, 44), "m5": (72, 20),
        "capm": (89, 44),
    },
    label={"poly": (66, 5), "li": (67, 5), "m1": (68, 5), "m2": (69, 5),
           "m3": (70, 5), "m4": (71, 5), "m5": (72, 5),
           "nwell": (64, 5), "pwell": (64, 59)},
    pin={"poly": (66, 16), "li": (67, 16), "m1": (68, 16), "m2": (69, 16),
         "m3": (70, 16), "m4": (71, 16), "m5": (72, 16),
         "nwell": (64, 16), "pwell": (122, 16)},
    width={"diff": 0.15, "tap": 0.15, "poly": 0.15, "li": 0.17, "m1": 0.14,
           "m2": 0.14, "m3": 0.30, "m4": 0.30, "m5": 1.60},
    space={
        ("diff", "diff"): 0.27, ("tap", "tap"): 0.27, ("diff", "tap"): 0.27,
        ("poly", "poly"): 0.21, ("poly", "diff"): 0.075, ("poly", "tap"): 0.055,
        ("li", "li"): 0.17, ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
        ("m3", "m3"): 0.30, ("m4", "m4"): 0.30, ("m5", "m5"): 1.60,
        ("nwell", "diff"): 0.34, ("nwell", "tap"): 0.18,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06), ("tap", "licon"): (0.0, 0.12),
        ("poly", "licon"): (0.05, 0.08), ("li", "licon"): (0.0, 0.08),
        ("li", "mcon"): (0.0, 0.0), ("m1", "mcon"): (0.03, 0.06),
        ("m1", "via"): (0.055, 0.085), ("m2", "via"): (0.055, 0.085),
        ("npc", "licon"): (0.10, 0.10), ("nwell", "diff"): (0.18, 0.18),
        ("nwell", "tap"): (0.18, 0.18),
    },
    rules=dict(
        gate_contact_space=0.055, poly_endcap=0.13, diff_ext_gate=0.25,
        polycontact_diff_space=0.19, polycontact_implant_space=0.11,
        gate_space=0.21, tap_diff_space=0.27, latchup_dist=15.0,
        wide_metal=3.0,
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
# Helpers
# ---------------------------------------------------------------------------
LY = None
TOP = None
L = {}          # layer -> LayerInfo
LAB = {}        # layer -> label layer
PIN = {}        # layer -> pin layer


def init_tech():
    global LY, TOP, L, LAB, PIN
    LY = kdb.Layout()
    LY.dbu = 0.001
    TOP = LY.create_cell("ota_miller")
    t = TECH["layers"]
    for name, (g, dt) in t.items():
        L[name] = LY.layer(g, dt)
    for name, (g, dt) in TECH["label"].items():
        LAB[name] = LY.layer(g, dt)
    for name, (g, dt) in TECH["pin"].items():
        PIN[name] = LY.layer(g, dt)


def dbu(um):
    return int(round(um / LY.dbu))


def box(cell, layer, x, y, w, h):
    """x,y,w,h in um. Inserts a box."""
    cell.shapes(L[layer]).insert(
        kdb.DBox(dbu(x), dbu(y), dbu(x + w), dbu(y + h)))


def label(cell, layer, text, x, y):
    cell.shapes(LAB[layer]).insert(
        kdb.DText(text, kdb.DTrans(dbu(x), dbu(y))))


def pin(cell, layer, text, x, y, w, h):
    cell.shapes(PIN[layer]).insert(
        kdb.DBox(dbu(x), dbu(y), dbu(x + w), dbu(y + h)))
    label(cell, layer, text, x + w / 2, y + h / 2)


def via_stack(cell, x, y, w, h, layers, stack_via):
    """Rectangular via stack from x,y,w,h (um) across metal layers."""
    for i, m in enumerate(layers):
        box(cell, m, x, y, w, h)
        if i < len(layers) - 1:
            v = stack_via[i]
            box(cell, v, x, y, w, h)


def contact(cell, layer, x, y, w, h, enc_layer, enc):
    """Contact on `layer` at x,y,w,h enclosed by enc_layer by enc (um, all sides)."""
    box(cell, layer, x, y, w, h)
    box(cell, enc_layer, x - enc, y - enc, w + 2 * enc, h + 2 * enc)


def mos(cell, dev, x, y, w, l, nf, gate_net, s_net, d_net, b_net,
        g_layer="poly", s_label="S", d_label="D", g_label="G", b_label="B"):
    """
    One MOS finger (one netlist line). Gate runs vertically (length W in y),
    channel length L in x. Source left, drain right.
    """
    t = TECH["rules"]
    pe = t["poly_endcap"]
    de = t["diff_ext_gate"]
    gcs = t["gate_contact_space"]
    diff = dev["diff"]
    impl = dev.get("implant")
    well = dev.get("well")

    # well
    if well:
        box(cell, well, x - 0.2, y - 0.2, w + 0.4, l + 0.4)
    # implant
    if impl:
        box(cell, impl, x - 0.1, y - 0.1, w + 0.2, l + 0.2)
    # diffusion (channel region under gate + S/D extensions)
    box(cell, diff, x, y, l + 2 * de, w)
    # gate (poly): extends past diffusion by pe on all sides
    box(cell, g_layer, x + de - pe, y - pe, l + 2 * pe, w + 2 * pe)

    # source contact (left), drain contact (right)
    cs = 0.17
    ce = 0.04
    sx = x + de / 2 - cs / 2
    dx_ = x + de + l + de / 2 - cs / 2
    # ensure distance from gate edge (x+de-pe) >= gcs
    if (x + de - pe) - (sx + cs) < gcs:
        sx = x + de - pe - gcs - cs
    if (dx_ + cs) - (x + de + l + pe) < gcs:
        dx_ = x + de + l + pe + gcs
    contact(cell, "licon", sx, y + w / 2 - cs / 2, cs, cs, diff, ce)
    contact(cell, "licon", dx_, y + w / 2 - cs / 2, cs, cs, diff, ce)
    # li over contacts + m1
    contact(cell, "li", sx, y + w / 2 - cs / 2, cs, cs, "licon", 0.0)
    contact(cell, "li", dx_, y + w / 2 - cs / 2, cs, cs, "licon", 0.0)
    box(cell, "m1", sx - 0.1, y + w / 2 - 0.2, cs + 0.2, 0.4)
    box(cell, "m1", dx_ - 0.1, y + w / 2 - 0.2, cs + 0.2, 0.4)
    # m1 over gate for gate contact
    box(cell, "m1", x + de - pe - 0.1, y - pe - 0.1, l + 2 * pe + 0.2, 0.4)
    # labels
    label(cell, "m1", s_net, sx, y + w / 2 - 0.2)
    label(cell, "m1", d_net, dx_, y + w / 2 - 0.2)
    label(cell, "m1", gate_net, x + de - pe + l / 2, y - pe - 0.1)
    if b_net:
        label(cell, "m1", b_net, x + l / 2 + de, y + w + 0.2)


def res_poly(cell, x, y, w, l, net1, net2):
    """Poly resistor w (y) x l (x), contacts at both ends to m1."""
    t = TECH["rules"]
    pe = t["poly_endcap"]
    box(cell, "poly", x - pe, y - pe, l + 2 * pe, w + 2 * pe)
    box(cell, "polyres", x, y, l, w)
    box(cell, "npc", x - 0.1, y - 0.1, l + 0.2, w + 0.2)
    cs = 0.17
    ce = 0.04
    contact(cell, "licon", x + l / 2 - cs / 2, y - pe - 0.08 - cs, cs, cs, "poly", 0.05)
    contact(cell, "licon", x + l / 2 - cs / 2, y + w + pe + 0.08, cs, cs, "poly", 0.05)
    contact(cell, "li", x + l / 2 - cs / 2, y - pe - 0.08 - cs, cs, cs, "licon", 0.0)
    contact(cell, "li", x + l / 2 - cs / 2, y + w + pe + 0.08, cs, cs, "licon", 0.0)
    box(cell, "m1", x + l / 2 - 0.2, y - pe - 0.08 - cs - 0.2, 0.4, 0.4)
    box(cell, "m1", x + l / 2 - 0.2, y + w + pe + 0.08, 0.4, 0.4)
    label(cell, "m1", net1, x + l / 2 - 0.2, y - pe - 0.08 - cs - 0.2)
    label(cell, "m1", net2, x + l / 2 - 0.2, y + w + pe + 0.08)


def mim_cap(cell, x, y, w, l, net_bot, net_top):
    """MIM cap: bottom m3, capm plate, top m4, via3 between m3/m4."""
    t = TECH["devices"]["cap_mim"]
    be = t["bottom_enc"]
    ce = t["cut_enc"]
    box(cell, "m3", x - be, y - be, w + 2 * be, l + 2 * be)
    box(cell, "capm", x, y, w, l)
    box(cell, "m4", x - be, y - be, w + 2 * be, l + 2 * be)
    # via3 array over capm
    vs = 0.20
    vs_sp = 0.20
    nx = max(1, int((w - vs) / (vs + vs_sp)) + 1)
    ny = max(1, int((l - vs) / (vs + vs_sp)) + 1)
    ox = x + (w - (nx * vs + (nx - 1) * vs_sp)) / 2
    oy = y + (l - (ny * vs + (ny - 1) * vs_sp)) / 2
    for i in range(nx):
        for j in range(ny):
            via_stack(cell, ox + i * (vs + vs_sp), oy + j * (vs + vs_sp),
                      vs, vs, ["m3", "m4"], ["via3"])
    label(cell, "m3", net_bot, x + w / 2, y - be - 0.2)
    label(cell, "m4", net_top, x + w / 2, y + l + be + 0.2)


def tap(cell, x, y, w, l, net, kind="ptap"):
    """Well tap: tap diffusion + contact to m1."""
    dev = TECH["devices"][kind]
    diff = dev["diff"]
    impl = dev.get("implant")
    box(cell, diff, x, y, w, l)
    if impl:
        box(cell, impl, x - 0.1, y - 0.1, w + 0.2, l + 0.2)
    cs = 0.17
    ce = 0.04
    contact(cell, "licon", x + w / 2 - cs / 2, y + l / 2 - cs / 2, cs, cs, diff, ce)
    contact(cell, "li", x + w / 2 - cs / 2, y + l / 2 - cs / 2, cs, cs, "licon", 0.0)
    box(cell, "m1", x + w / 2 - 0.2, y + l / 2 - 0.2, 0.4, 0.4)
    label(cell, "m1", net, x + w / 2 - 0.2, y + l / 2 - 0.2)


def hline(cell, layer, net, y, x0, x1, label_x=None):
    box(cell, layer, x0, y, x1 - x0, 0.14)
    lx = label_x if label_x is not None else (x0 + x1) / 2
    label(cell, layer, net, lx, y)


def vline(cell, layer, net, x, y0, y1, label_y=None):
    box(cell, layer, x, y0, 0.14, y1 - y0)
    ly = label_y if label_y is not None else (y0 + y1) / 2
    label(cell, layer, net, x, ly)


# ---------------------------------------------------------------------------
# Build the OTA
# ---------------------------------------------------------------------------
init_tech()

# Floorplan (um)
X0, Y0 = 0.0, 0.0
pitch = 6.0          # finger cell pitch in x
cell_h = 10.0        # finger cell height in y
rail_y = 0.0         # VSS rail at bottom of row
rail_y_top = cell_h  # VDD rail at top

# Net -> (metal layer, y) for horizontal rails
nets = {
    "VSS": ("m1", rail_y),
    "VDD": ("m1", rail_y_top),
    "tail": ("m1", rail_y + 2.5),
    "d1": ("m1", rail_y + 5.0),
    "d2": ("m1", rail_y + 7.5),
    "OUT": ("m1", rail_y + 10.0),
    "IB": ("m1", rail_y + 12.5),
    "INP": ("m1", rail_y + 15.0),
    "INN": ("m1", rail_y + 17.5),
    "x": ("m1", rail_y + 20.0),
}

# Place finger cells in a column
x = X0
y = Y0
order = [
    ("nmos", "M8",  "IB",  "IB",  "VSS", "VSS", 2, 1, 2),
    ("nmos", "M5",  "tail","IB",  "VSS", "VSS", 2, 1, 4),
    ("nmos", "M7",  "OUT","IB",  "VSS", "VSS", 2, 1, 8),
    ("nmos", "M1",  "d1", "INN", "tail","VSS", 4, 0.5, 2),
    ("nmos", "M2",  "d2", "INP", "tail","VSS", 4, 0.5, 2),
    ("pmos", "M3",  "d1", "d1",  "VDD", "VDD", 4, 1, 2),
    ("pmos", "M4",  "d2", "d1",  "VDD", "VDD", 4, 1, 2),
    ("pmos", "M6",  "OUT","d2",  "VDD", "VDD", 4, 0.5, 8),
]
for devname, mname, dnet, gnet, snet, bnet, w, l, nf in order:
    dev = TECH["devices"][devname]
    for f in range(nf):
        mos(TOP, dev, x, y, w, l, 1, gnet, snet, dnet, bnet)
        x += pitch
    x += 2.0  # inter-device gap

# Resistor RZ: d2 -> x
res_poly(TOP, x, rail_y + 6.0, 1.0, 8.0, "d2", "x")
x += 12.0

# MIM cap CC: x -> OUT
mim_cap(TOP, x, rail_y + 18.0, 20.0, 20.0, "x", "OUT")
x += 26.0

# Taps
tap(TOP, x, rail_y, 2.0, 2.0, "VSS", "ntap")
x += 6.0
tap(TOP, x, rail_y_top, 2.0, 2.0, "VDD", "ptap")
x += 6.0

# Horizontal rails spanning the whole block
xmax = x + 10.0
for net, (layer, y) in nets.items():
    hline(TOP, layer, net, y, X0, xmax, label_x=X0 + 1.0)

# Determine rail x positions (one per net) spread across width
rail_x = {}
xr = X0 + 2.0
for net in nets:
    rail_x[net] = xr
    xr += 4.0

# Draw m2 verticals and connect to m1 rails
for net, (layer, y) in nets.items():
    rx = rail_x[net]
    # m2 vertical full height
    vline(TOP, "m2", net + "_v2", rx, Y0, Y0 + cell_h + 22.0, label_y=y)
    # via from m2 to m1 rail
    via_stack(TOP, rx - 0.075, y - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])

# Re-place interconnect: for each finger, connect source/drain m1 dots to
# the m2 vertical of their net via short m1 segments + vias.
x = X0
for devname, mname, dnet, gnet, snet, bnet, w, l, nf in order:
    dev = TECH["devices"][devname]
    t = TECH["rules"]
    de = t["diff_ext_gate"]
    pe = t["poly_endcap"]
    cs = 0.17
    for f in range(nf):
        cx = x
        fy = Y0
        # source dot m1 box
        sx = cx + de / 2 - cs / 2
        dx_ = cx + de + l + de / 2 - cs / 2
        sy = fy + w / 2 - 0.2
        # m1 jog from source dot to m2 vertical of snet
        rx = rail_x[snet]
        x1 = min(sx + cs / 2, rx - 0.1)
        x2 = max(sx + cs / 2, rx + 0.1)
        box(TOP, "m1", x1, sy - 0.07, x2 - x1, 0.14)
        via_stack(TOP, rx - 0.075, sy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        # drain
        rx = rail_x[dnet]
        x1 = min(dx_ + cs / 2, rx - 0.1)
        x2 = max(dx_ + cs / 2, rx + 0.1)
        box(TOP, "m1", x1, sy - 0.07, x2 - x1, 0.14)
        via_stack(TOP, rx - 0.075, sy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        # gate: m1 box over gate -> via to m2 vertical of gnet
        gx = cx + de - pe + l / 2
        gy = fy - pe - 0.1 + 0.2  # center of gate m1 box
        box(TOP, "m1", cx + de - pe - 0.1, fy - pe - 0.1, l + 2 * pe + 0.2, 0.4)
        rx = rail_x[gnet]
        x1 = min(gx, rx - 0.1)
        x2 = max(gx + (l + 2 * pe + 0.2), rx + 0.1)
        box(TOP, "m1", x1, gy - 0.07, x2 - x1, 0.14)
        via_stack(TOP, rx - 0.075, gy - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
        x += pitch
    x += 2.0

# After resistor and cap, connect their m1 terminals to m2 verticals
# Recompute resistor/cap x positions
xr = X0
for devname, mname, dnet, gnet, snet, bnet, w, l, nf in order:
    xr += pitch * nf + 2.0
# resistor at xr, y = rail_y+6.0, w=1.0, l=8.0
rx0 = xr
ry0 = rail_y + 6.0
t = TECH["rules"]
pe = t["poly_endcap"]
cs = 0.17
bx = rx0 + 8.0 / 2 - 0.2
by = ry0 - pe - 0.08 - cs - 0.2
box(TOP, "m1", bx, by, 0.4, 0.4)
via_stack(TOP, rail_x["d2"] - 0.075, by - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
box(TOP, "m1", min(bx, rail_x["d2"] - 0.1), by - 0.07,
    abs(bx - (rail_x["d2"])) + 0.4, 0.14)
# top m1 box (net x)
by2 = ry0 + 1.0 + pe + 0.08
box(TOP, "m1", bx, by2, 0.4, 0.4)
via_stack(TOP, rail_x["x"] - 0.075, by2 - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
box(TOP, "m1", min(bx, rail_x["x"] - 0.1), by2 - 0.07,
    abs(bx - (rail_x["x"])) + 0.4, 0.14)

# Cap: bottom m3 label net x, top m4 label net OUT
cx_cap = xr + 12.0
cy_cap = rail_y + 18.0
# connect cap bottom m3 to m2 rail x via via2 (m2-m3)
via_stack(TOP, rail_x["x"] - 0.1, cy_cap - 0.1, 0.2, 0.2, ["m2", "m3"], ["via2"])
box(TOP, "m3", rail_x["x"] - 0.1, cy_cap - 0.1, 0.2, 0.2)
# connect cap top m4 (net OUT) to m2 rail OUT via via2 (m2->m3) and via3 (m3->m4)
via_stack(TOP, rail_x["OUT"] - 0.1, cy_cap + 20.0 - 0.1, 0.2, 0.2,
          ["m2", "m3", "m4"], ["via2", "via3"])
box(TOP, "m4", rail_x["OUT"] - 0.1, cy_cap + 20.0 - 0.1, 0.2, 0.2)

# Power rails: connect VDD/VSS m1 rails to m2 verticals (already done via via at rail y)
via_stack(TOP, rail_x["VSS"] - 0.075, rail_y - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])
via_stack(TOP, rail_x["VDD"] - 0.075, rail_y_top - 0.075, 0.15, 0.15, ["m1", "m2"], ["via"])

# Pin labels on m1 pin layer at rail ends
for net, (layer, y) in nets.items():
    pin(TOP, layer, net, X0 - 2.0, y - 0.07, 2.0, 0.14)

# Boundary layer
box(TOP, "boundary", X0 - 5, Y0 - 5, xmax - X0 + 10, cell_h + 30)

# ---------------------------------------------------------------------------
# Write GDS
# ---------------------------------------------------------------------------
LY.write("ota_miller.gds")
print("written ota_miller.gds")
print("bbox um:", TOP.bbox().left * LY.dbu, TOP.bbox().bottom * LY.dbu,
      TOP.bbox().right * LY.dbu, TOP.bbox().top * LY.dbu)
```