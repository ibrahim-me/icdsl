"""cdac6 - 6-bit binary-weighted capacitor array (gf180mcuD)."""
from icdsl.canvas import *

tech = use()
assert tech.d.get("name") == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0          # unit cap (cap_mim wmin=5)
PITCH = 5.6          # W + capm min space 0.6
COLS, ROWS = 8, 8

# bit assignment: 32 B5, 16 B4, 8 B3, then B2(4) B1(2) B0(1) VSS(1) in last col
col_net = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + [None]   # col 7 filled per-row below
row_net_col7 = ["B2"] * 4 + ["B1"] * 2 + ["B0"] + ["VSS"]

c = Cell("cdac6")

# --- place 64 unit capacitors ---
caps = []
for col in range(COLS):
    for row in range(ROWS):
        if col == COLS - 1:
            net = row_net_col7[row]
        else:
            net = col_net[col]
        x = col * PITCH
        y = row * PITCH
        k = c.capacitor("cap_mim", w=W, h=H, at=(x + W / 2, y + W / 2),
                        nets=("TOP", net))
        caps.append(k)

# --- TOP plane: solid m5 over the whole array (all top plates are TOP) ---
x0 = 0.0
y0 = 0.0
x1 = COLS * PITCH
y1 = ROWS * PITCH
top_plane = c.rect(c4, x0=x0, y0=y0, x1=x1, y1=y1, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

# --- bottom plate routing: m4 column trunks + via3 to m3, per-bit collection trunks ---
MW = tech.width(c3)          # m3 width 0.28
MS = tech.space(c3)          # m3 space 0.28
PAD = 0.15                   # trunk extension above array
trunk_y = y1 + PAD           # column trunks run up here to meet collection trunks

col_trunk_x = {}
for col in range(COLS - 1):          # cols 0..6 have a single bit
    net = col_net[col]
    tx = (col + 0.5) * PITCH
    col_trunk_x[col] = tx
    c.rect(c3, x0=tx - MW / 2, y0=y0, x1=tx + MW / 2, y1=trunk_y, net=net)

# collection trunks stacked above the array, one per bit
cy = y1 + PAD
for net in ("B5", "B4", "B3"):
    cols = [col for col in range(COLS - 1) if col_net[col] == net]
    xa = cols[0] * PITCH
    xb = (cols[-1] + 1) * PITCH
    c.rect(c3, x0=xa, y0=cy, x1=xb, y1=cy + MW, net=net)
    cy += MW + MS

# vias + short m3 jogs from each bottom pad to its column trunk
for col in range(COLS - 1):
    net = col_net[col]
    tx = col_trunk_x[col]
    for row in range(ROWS):
        k = caps[col * ROWS + row]
        pad = k.bottom_pad
        px = pad.cx
        c.via(c3, c4, at=(px, pad.cy), net=net)          # via3 m4<->m3? wait args
