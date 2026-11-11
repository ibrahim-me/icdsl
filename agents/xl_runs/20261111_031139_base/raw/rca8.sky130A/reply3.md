```
import klayout.db as kdb

ly = kdb.Layout()
ly.dbu = 0.001

def layer(gds, dt):
    return ly.layer(gds, dt)

DIFF = layer(65, 20)
POLY = layer(66, 20)
LICON = layer(66, 44)
LI = layer(67, 20)
MCON = layer(67, 44)
M1 = layer(68, 20)
VIA = layer(68, 44)
M2 = layer(69, 20)
NWELL = layer(64, 20)

M1_LABEL = layer(68, 5)
M1_PIN = layer(68, 16)
M2_LABEL = layer(69, 5)
M2_PIN = layer(69, 16)

def box(cell, l, x1, y1, x2, y2):
    cell.shapes(l).insert(kdb.DBox(x1, y1, x2, y2))

def text(cell, l, s, x, y):
    cell.shapes(l).insert(kdb.DText(s, kdb.DTrans(x, y)))

def via_stack(cell, x, y):
    """Contact from diff/poly to m1: licon+li+mcon+m1, all DRC-clean."""
    hs = 0.085
    box(cell, LICON, x-hs, y-hs, x+hs, y+hs)
    box(cell, LI, x-0.165, y-0.165, x+0.165, y+0.165)
    box(cell, MCON, x-hs, y-hs, x+hs, y+hs)
    box(cell, M1, x-0.145, y-0.145, x+0.145, y+0.145)

def transistor(cell, x, y, w, l, gate_net, src_net, drn_net, bulk_net, is_pmos, nets):
    pe = 0.13
    de = 0.25
    box(cell, DIFF, x, y, x+w, y+l)
    box(cell, POLY, x-pe, y, x+w+pe, y+l)
    via_stack(cell, x+w/2, y)
    nets.setdefault(src_net, []).append((x+w/2, y))
    via_stack(cell, x+w/2, y+l)
    nets.setdefault(drn_net, []).append((x+w/2, y+l))
    via_stack(cell, x+w/2, y+l/2)
    nets.setdefault(gate_net, []).append((x+w/2, y+l/2))
    via_stack(cell, x-de/2, y+l/2)
    nets.setdefault(bulk_net, []).append((x-de/2, y+l/2))

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
    ll = M2_LABEL if m2 else M1_LABEL
    ml = M2 if m2 else M1
    box(cell, pl, x-hs, y-hs, x+hs, y+hs)
    box(cell, ml, x-hs, y-hs, x+hs, y+hs)
    text(cell, ll, name, x, y)

# ---------------- full adder cell ----------------
fa = ly.create_cell("fa")
CELL_W = 10.0
CELL_H = 12.0
PITCH = 0.6
nets = {}

nmos_y = 1.0
nmos_list = [
    ("A", "VSS", "n1"), ("B", "n1", "VSS"), ("CB", "CIN", "n1"),
    ("B", "n2", "CB"), ("A", "VSS", "n2"), ("A", "n3", "VSS"),
    ("B", "VSS", "n3"), ("CIN", "n3", "VSS"), ("SB", "CB", "n3"),
    ("CIN", "n5", "SB"), ("B", "n4", "n5"), ("A", "VSS", "n4"),
    ("CB", "COUT", "VSS"), ("SB", "VSS", "SUM"),
]
for i, (g, s, d) in enumerate(nmos_list):
    transistor(fa, i*PITCH, nmos_y, 0.42, 0.15, g, s, d, "VSS", False, nets)

pmos_y = 9.16
pmos_list = [
    ("A", "VDD", "p1"), ("B", "p1", "VDD"), ("CB", "CIN", "p1"),
    ("B", "p2", "CB"), ("A", "VDD", "p2"), ("A", "p3", "VDD"),
    ("B", "VDD", "p3"), ("CIN", "p3", "VDD"), ("SB", "CB", "p3"),
    ("CIN", "p5", "SB"), ("B", "p4", "p5"), ("A", "VDD", "p4"),
    ("CB", "COUT", "VDD"), ("SB", "VDD", "SUM"),
]
for i, (g, s, d) in enumerate(pmos_list):
    transistor(fa, i*PITCH, pmos_y, 0.84, 0.15, g, s, d, "VDD", True, nets)

# nwell around PMOS row
box(fa, NWELL, -0.3, pmos_y-0.3, 14*PITCH+0.3, pmos_y+0.84+0.3)
via_stack(fa, -0.15, pmos_y+0.42)
nets.setdefault("VDD", []).append((-0.15, pmos_y+0.42))

# route nets on m1 tracks
track_pitch = 0.5
track_start = 0.5
net_list = sorted(nets.keys())
for i, net in enumerate(net_list):
    ty = track_start + i*track_pitch
    if ty > CELL_H - 0.5:
        ty = CELL_H - 0.5
    route_net(fa, net, nets[net], ty)

# pins on left/right
py = 0.5
for idx, pn in enumerate(["A", "B", "CIN"]):
    pin(fa, pn, -0.5, py + idx*1.0)
for idx, pn in enumerate(["SUM", "COUT"]):
    pin(fa, pn, CELL_W+0.5, py + idx*1.0)
pin(fa, "VDD", CELL_W/2, CELL_H+0.5)
pin(fa, "VSS", CELL_W/2, -0.5)

# ---------------- top cell ----------------
top = ly.create_cell("rca8")
FA_W = 11.0
FA_H = 13.0
for i in range(8):
    top.insert(kdb.DCellInstArray(fa.cell_index(), kdb.DTrans(i*FA_W, 0.0)))

# power rails on m2
rx_l = -1.0
rx_r = 8*FA_W + 1.0
ry_b = -1.0
ry_t = FA_H + 1.0
box(top, M2, rx_l-0.3, ry_b, rx_l+0.3, ry_t)
box(top, M2, rx_r-0.3, ry_b, rx_r+0.3, ry_t)

# connect FA supplies to rails
for i in range(8):
    x = i*FA_W + FA_W/2
    box(top, M1, x-0.07, FA_H+0.5, x+0.07, ry_t)
    box(top, M1, x-0.07, ry_b, x+0.07, -0.5)

# carry chain on m2
for i in range(7):
    x1 = i*FA_W + FA_W + 0.5
    x2 = (i+1)*FA_W - 0.5
    y = FA_H/2
    box(top, M2, x1, y-0.07, x2, y+0.07)
    hs = 0.075
    box(top, VIA, x1-hs, y-hs, x1+hs, y+hs)
    box(top, VIA, x2-hs, y-hs, x2+hs, y+hs)

# top pins
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
print("rca8.gds written")

```