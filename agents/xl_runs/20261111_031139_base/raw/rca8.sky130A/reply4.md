```
import klayout.db as kdb

# ------------------------------------------------------------------------------
# PDK data (sky130A)
# ------------------------------------------------------------------------------
TECH = dict(
    name="sky130A",
    grid=0.005,
    layers={
        "nwell": (64, 20), "diff": (65, 20), "tap": (65, 44), "poly": (66, 20),
        "nsdm": (93, 44), "psdm": (94, 20), "npc": (95, 20),
        "licon": (66, 44), "li": (67, 20), "mcon": (67, 44),
        "m1": (68, 20), "via": (68, 44), "m2": (69, 20),
    },
    label={"m1": (68, 5), "m2": (69, 5)},
    pin={"m1": (68, 16), "m2": (69, 16)},
    cuts={
        "licon": dict(size=0.17, space=0.17),
        "mcon": dict(size=0.17, space=0.19),
        "via": dict(size=0.15, space=0.17),
    },
    width={"diff": 0.15, "poly": 0.15, "li": 0.17, "m1": 0.14, "m2": 0.14},
    space={
        ("diff", "diff"): 0.27, ("poly", "poly"): 0.21, ("poly", "diff"): 0.075,
        ("li", "li"): 0.17, ("m1", "m1"): 0.14, ("m2", "m2"): 0.14,
    },
    enc={
        ("diff", "licon"): (0.04, 0.06), ("poly", "licon"): (0.05, 0.08),
        ("li", "licon"): (0.0, 0.08), ("li", "mcon"): (0.0, 0.0),
        ("m1", "mcon"): (0.03, 0.06), ("m1", "via"): (0.055, 0.085),
        ("m2", "via"): (0.055, 0.085),
    },
    rules=dict(
        gate_contact_space=0.055,
        poly_endcap=0.13,
        diff_ext_gate=0.25,
        polycontact_diff_space=0.19,
        gate_space=0.21,
    ),
    devices={
        "nmos": dict(lmin=0.15, wmin=0.42, bulk="VSS"),
        "pmos": dict(lmin=0.15, wmin=0.84, bulk="VDD"),
    },
)

# ------------------------------------------------------------------------------
# Layout setup
# ------------------------------------------------------------------------------
ly = kdb.Layout()
ly.dbu = 0.001

def layername(nm):
    gds, dt = TECH["layers"][nm]
    return ly.layer(gds, dt)

DIFF = layername("diff")
POLY = layername("poly")
LICON = layername("licon")
LI = layername("li")
MCON = layername("mcon")
M1 = layername("m1")
VIA = layername("via")
M2 = layername("m2")
NWELL = layername("nwell")

M1_LAB = ly.layer(*TECH["label"]["m1"])
M1_PIN = ly.layer(*TECH["pin"]["m1"])
M2_LAB = ly.layer(*TECH["label"]["m2"])
M2_PIN = ly.layer(*TECH["pin"]["m2"])

def box(cell, l, x1, y1, x2, y2):
    cell.shapes(l).insert(kdb.DBox(x1, y1, x2, y2))

def text(cell, l, s, x, y):
    cell.shapes(l).insert(kdb.DText(s, kdb.DTrans(x, y)))

def contact(cell, x, y):
    """Full contact stack: licon(0.17) + li(0.33) + mcon(0.17) + m1 pad(0.30)."""
    hs = 0.085
    box(cell, LICON, x-hs, y-hs, x+hs, y+hs)
    box(cell, LI, x-0.165, y-0.165, x+0.165, y+0.165)
    box(cell, MCON, x-hs, y-hs, x+hs, y+hs)
    box(cell, M1, x-0.15, y-0.15, x+0.15, y+0.15)

def via12(cell, x, y):
    hs = 0.075
    box(cell, VIA, x-hs, y-hs, x+hs, y+hs)
    box(cell, M2, x-0.145, y-0.145, x+0.145, y+0.145)

def mos(cell, x, y, w, l, gate_net, src_net, drn_net, bulk_net, is_pmos, nets):
    """
    Correct MOS: diffusion horizontal (x), poly vertical (y) crossing it.
    x,y = left edge of diffusion, bottom of diffusion.
    Diffusion: x..x+L+2*sd (x), y..y+W (y)   -> W is transistor width (y-dir)
    Poly:      x+sd..x+sd+L (x), y-pe..y+W+pe (y) -> L is gate length (x-dir)
    """
    pe = TECH["rules"]["poly_endcap"]      # 0.13
    sd = 0.25                              # source/drain region (contact+enc)
    box(cell, DIFF, x, y, x + l + 2*sd, y + w)
    box(cell, POLY, x + sd, y - pe, x + sd + l, y + w + pe)
    # gate contact on poly
    contact(cell, x + sd + l/2, y + w/2)
    nets.setdefault(gate_net, []).append((x + sd + l/2, y + w/2))
    # source contact on diffusion (left end)
    contact(cell, x + sd/2, y + w/2)
    nets.setdefault(src_net, []).append((x + sd/2, y + w/2))
    # drain contact on diffusion (right end)
    contact(cell, x + l + sd + sd/2, y + w/2)
    nets.setdefault(drn_net, []).append((x + l + sd + sd/2, y + w/2))
    # bulk contact on diffusion side
    contact(cell, x - 0.12, y + w/2)
    nets.setdefault(bulk_net, []).append((x - 0.12, y + w/2))
    return x + l + 2*sd + TECH["space"][("diff","diff")]

def route_net(cell, net, points, track_y):
    if not points:
        return
    xs = [p[0] for p in points]
    x0, x1 = min(xs), max(xs)
    w = 0.14
    box(cell, M1, x0-w/2, track_y-w/2, x1+w/2, track_y+w/2)
    for px, py in points:
        y0, y1 = min(py, track_y), max(py, track_y)
        box(cell, M1, px-w/2, y0-w/2, px+w/2, y1+w/2)

def pin(cell, name, x, y, size=0.14, m2=False):
    hs = size/2
    pl = M2_PIN if m2 else M1_PIN
    ll = M2_LAB if m2 else M1_LAB
    ml = M2 if m2 else M1
    box(cell, pl, x-hs, y-hs, x+hs, y+hs)
    box(cell, ml, x-hs, y-hs, x+hs, y+hs)
    text(cell, ll, name, x, y)

# ------------------------------------------------------------------------------
# Full adder cell - compact shared-diffusion layout
# ------------------------------------------------------------------------------
fa = ly.create_cell("fa")

# Transistor dimensions
LN = 0.15; WN = 0.42   # nmos
LP = 0.15; WP = 0.84   # pmos
PE = 0.13              # poly endcap
SD = 0.25              # source/drain region
PITCH_N = LN + 2*SD + TECH["space"][("diff","diff")]   # 0.15+0.5+0.27 = 0.92
PITCH_P = LP + 2*SD + TECH["space"][("diff","diff")]   # same

nets = {}

# NMOS row: y = 1.0, diffusion height = WN = 0.42
nmos_y = 1.0
# Each transistor: (gate, source, drain)
nmos_list = [
    ("A",   "VSS", "n1"),
    ("B",   "n1",  "VSS"),
    ("CB",  "CIN", "n1"),
    ("B",   "n2",  "CB"),
    ("A",   "VSS", "n2"),
    ("A",   "n3",  "VSS"),
    ("B",   "VSS", "n3"),
    ("CIN", "n3",  "VSS"),
    ("CB",  "SB",  "n3"),
    ("CIN", "n5",  "SB"),
    ("B",   "n4",  "n5"),
    ("A",   "VSS", "n4"),
    ("CB",  "COUT","VSS"),
    ("SB",  "VSS", "SUM"),
]
x = 0.0
for g, s, d in nmos_list:
    x = mos(fa, x, nmos_y, WN, LN, g, s, d, "VSS", False, nets)

# PMOS row: y = 6.0, in nwell, diffusion height = WP = 0.84
pmos_y = 6.0
pmos_list = [
    ("A",   "VDD", "p1"),
    ("B",   "p1",  "VDD"),
    ("CB",  "CIN", "p1"),
    ("B",   "p2",  "CB"),
    ("A",   "VDD", "p2"),
    ("A",   "p3",  "VDD"),
    ("B",   "VDD", "p3"),
    ("CIN", "p3",  "VDD"),
    ("CB",  "SB",  "p3"),
    ("CIN", "p5",  "SB"),
    ("B",   "p4",  "p5"),
    ("A",   "VDD", "p4"),
    ("CB",  "COUT","VDD"),
    ("SB",  "VDD", "SUM"),
]
x = 0.0
for g, s, d in pmos_list:
    x = mos(fa, x, pmos_y, WP, LP, g, s, d, "VDD", True, nets)

# nwell around PMOS row
box(fa, NWELL, -0.5, pmos_y-0.5, x + 0.5, pmos_y + WP + 0.5)
# nwell tap
contact(fa, -0.25, pmos_y + WP/2)
nets.setdefault("VDD", []).append((-0.25, pmos_y + WP/2))

# Route all nets on m1 tracks
track_pitch = 0.62
track_start = 0.5
net_list = sorted(nets.keys())
for i, net in enumerate(net_list):
    ty = track_start + i*track_pitch
    if ty > 12.0 - 0.5:
        ty = 12.0 - 0.5
    route_net(fa, net, nets[net], ty)

# Pins on left/right
py = 0.5
for idx, pn in enumerate(["A", "B", "CIN"]):
    pin(fa, pn, -0.5, py + idx*1.0)
for idx, pn in enumerate(["SUM", "COUT"]):
    pin(fa, pn, x + 0.5, py + idx*1.0)
pin(fa, "VDD", x/2, 12.5)
pin(fa, "VSS", x/2, -0.5)

FA_W = x + 1.0
FA_H = 13.0

# ------------------------------------------------------------------------------
# Top cell: rca8
# ------------------------------------------------------------------------------
top = ly.create_cell("rca8")

for i in range(8):
    top.insert(kdb.DCellInstArray(fa.cell_index(), kdb.DTrans(i*FA_W, 0.0)))

# Power rails on m2
rx_l = -1.0
rx_r = 8*FA_W + 1.0
ry_b = -1.0
ry_t = FA_H + 1.0
box(top, M2, rx_l-0.3, ry_b, rx_l+0.3, ry_t)
box(top, M2, rx_r-0.3, ry_b, rx_r+0.3, ry_t)

# Connect FA supplies to rails
for i in range(8):
    cx = i*FA_W + FA_W/2
    box(top, M1, cx-0.07, FA_H+0.5, cx+0.07, ry_t)
    box(top, M1, cx-0.07, ry_b, cx+0.07, -0.5)

# Carry chain on m2
for i in range(7):
    x1 = i*FA_W + FA_W + 0.5
    x2 = (i+1)*FA_W - 0.5
    y = FA_H/2
    box(top, M2, x1, y-0.07, x2, y+0.07)
    via12(top, x1, y)
    via12(top, x2, y)

# Top pins
pty = ry_t + 0.5
pin(top, "VDD", rx_l, pty, size=0.2, m2=True)
pin(top, "VSS", rx_r, pty, size=0.2, m2=True)
for i in range(8):
    pin(top, f"A{i}", i*FA_W + FA_W/2, ry_b - 1.0)
    pin(top, f"B{i}", i*FA_W + FA_W/2, ry_b - 2.0)
pin(top, "CIN", rx_l - 2.0, FA_H/2, size=0.2, m2=True)
pin(top, "COUT", rx_r + 2.0, FA_H/2, size=0.2, m2=True)
for i in range(8):
    pin(top, f"S{i}", i*FA_W + FA_W/2, ry_t + 1.0)

ly.write("rca8.gds")
print("rca8.gds written, FA_W=%.2f FA_H=%.2f" % (FA_W, FA_H))
print("Total bbox: %.2f x %.2f = %.2f um^2" % (8*FA_W+4, FA_H+2, (8*FA_W+4)*(FA_H+2)))
```