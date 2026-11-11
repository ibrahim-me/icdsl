"""cdac6 - 6-bit binary-weighted capacitor array for gf180mcuD."""
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0
PITCH = 5.6
COLS, ROWS = 8, 8

col_net = ["B5"] * 4 + ["B4"] * 2 + ["B3"] + [None]
row_net_col7 = ["B2"] * 4 + ["B1"] * 2 + ["B0"] + ["VSS"]

c = Cell("cdac6")

caps = []
for col in range(COLS):
    for row in range(ROWS):
        net = row_net_col7[row] if col == COLS - 1 else col_net[col]
        k = c.capacitor("cap_mim", w=W, h=H,
                        at=(col * PITCH + W / 2, row * PITCH + H / 2),
                        nets=("TOP", net))
        caps.append(k)

x1 = COLS * PITCH
y1 = ROWS * PITCH

# TOP plane (m5)
top_plane = c.rect(c4, x0=0, y0=0, x1=x1, y1=y1, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

MW = tech.width(c3)   # m4 width 0.28
M3W = tech.width(c2)  # m3 width 0.28

# m4 column trunks (cols 0-6), one per bit, run full height + above array
TRUNK_TOP = y1 + 3.0
col_trunk_x = {}
for col in range(COLS - 1):
    tx = (col + 0.5) * PITCH
    col_trunk_x[col] = tx
    c.rect(c3, x0=tx - MW / 2, y0=0, x1=tx + MW / 2, y1=TRUNK_TOP, net=col_net[col])

# m3 collection trunks above the array, one per bit, full width to the right pins
CY = y1 + 0.6
PIN_X = x1 + 4.0
for net in ("B5", "B4", "B3"):
    c.rect(c2, x0=0, y0=CY, x1=PIN_X, y1=CY + M3W, net=net)
    CY += M3W + tech.space(c2)

# vias via3 (m3->m4) joining each column trunk to its bit's collection trunk
for col in range(COLS - 1):
    net = col_net[col]
    tx = col_trunk_x[col]
    # find collection trunk y for this net
    ...
