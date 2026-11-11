"""cdac6 - 6-bit binary-weighted capacitor array (gf180mcuD)."""
from icdsl.canvas import *

tech = use()
assert tech.d.get("name") == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0          # unit cap (capm wmin=5)
PITCH = 5.6          # W + capm min space 0.6
COLS, ROWS = 8, 8

c = Cell("cdac6")

def bit_net(col, row):
    if col < 4:   return "B5"   # 32 units
    if col < 6:   return "B4"   # 16 units
    if col == 6:  return "B3"   # 8 units
    if row < 4:   return "B2"   # 4 units
    if row < 6:   return "B1"   # 2 units
    if row == 6:  return "B0"   # 1 unit
    return "VSS"                # 1 unit

# --- place 64 unit capacitors ---
caps = []
for col in range(COLS):
    for row in range(ROWS):
        net = bit_net(col, row)
        x = col * PITCH + W / 2
        y = row * PITCH + H / 2
        k = c.capacitor("cap_mim", w=W, h=H, at=(x, y), nets=("TOP", net))
        caps.append(k)

# --- TOP plane: solid m5 over the whole array ---
x1 = COLS * PITCH
y1 = ROWS * PITCH
top_plane = c.rect(c4, x0=0, y0=0, x1=x1, y1=y1, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

# --- bottom plate routing: m4 vertical trunks per column (cols 0-6) ---
M4W = tech.width(c3)   # m4 min width 0.28
M4S = tech.space(c3)   # m4 min space 0.28
M3W = tech.width(c2)   # m3 min width 0.28
M3S = tech.space(c2)   # m3 min space 0.28

col_trunk_x = {}
for col in range(COLS - 1):
    net = bit_net(col, 0)
    tx = col * PITCH + W / 2
    col_trunk_x[col] = tx
    c.rect(c3, x0=tx - M4W / 2, y0=0, x1=tx + M4W / 2, y1=y1, net=net)

# --- collection trunks on m3 above the array ---
TRUNK_Y = y1 + 0.6
trunk_h = M3W
trunk_s = M3S
cy = TRUNK_Y
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
bit_trunk_y = {}
for net in bit_order:
    bit_trunk_y[net] = cy
    xa = 0.0
    xb = (COLS - 1) * PITCH + W / 2
    c.rect(c2, x0=xa, y0=cy, x1=xb, y1=cy + trunk_h, net=net)
    cy += trunk_h + trunk_s

PIN_Y = cy + trunk_h + 0.6
PIN_H = M3W

# --- vias + jogs: bottom pad (m4) -> m4 trunk -> via3 -> m3 collection trunk ---
for col in range(COLS - 1):
    net = bit_net(col, 0)
    tx = col_trunk_x[col]
    ty = bit_trunk_y[net]
    for row in range(ROWS):
        k = caps[col * ROWS + row]
        pad = k.bottom_pad
        px = pad.cx
        py = pad.cy
        # m4 jog from pad to column trunk
        c.rect(c3, x0=min(px, tx - M4W / 2), y0=py, x1=max(px, tx + M4W / 2), y1=py + M4W, net=net)
        # via3 m4->m3 at trunk
        c.via(c3, c2, at=(tx, py + M4W / 2), net=net)
        # m3 jog from via to collection trunk
        c.rect(c2, x0=tx - M3W / 2, y0=py + M4W / 2, x1=tx + M3W / 2, y1=ty, net=net)

# --- col 7: individual routing per row ---
col7_x = (COLS - 1) * PITCH + W / 2
for row in range(ROWS):
    net = bit_net(7, row)
    k = caps[7 * ROWS + row]
    pad = k.bottom_pad
    px = pad.cx
    py = pad.cy
    ty = bit_trunk_y[net]
    # m4 jog from pad to col7 x
    c.rect(c3, x0=min(px, col7_x - M4W / 2), y0=py, x1=max(px, col7_x + M4W / 2), y1=py + M4W, net=net)
    # via3 m4->m3
    c.via(c3, c2, at=(col7_x, py + M4W / 2), net=net)
    # m3 jog to collection trunk
    c.rect(c2, x0=col7_x - M3W / 2, y0=py + M4W / 2, x1=col7_x + M3W / 2, y1=ty, net=net)

# --- pins on m3 at right edge ---
for net in bit_order:
    ty = bit_trunk_y[net]
    pin = c.rect(c2, x0=x1 - M3W, y0=ty, x1=x1, y1=ty + trunk_h, net=net)
    c.port(net, on=pin, dir="inout")
    # connect trunk to pin
    c.rect(c2, x0=bit_trunk_y[net] and 0 or 0, y0=ty, x1=x1, y1=ty + trunk_h, net=net)

# --- VSS pin ---
vss_pin = c.rect(c2, x0=x1 - M3W, y0=bit_trunk_y["VSS"], x1=x1, y1=bit_trunk_y["VSS"] + trunk_h, net="VSS")
c.port("VSS", on=vss_pin, dir="inout")

TOP = c
