"""cdac6 - 6-bit binary-weighted capacitor array (gf180mcuD)."""
from icdsl.canvas import *

tech = use()
assert tech.d.get("name") == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0          # unit cap (capm wmin=5)
PITCH = 5.6          # W + capm min space 0.6
ENC = 0.6            # bottom plate overlap of capm (MIMTM.3)
M4W = tech.width(c3)   # m4 min width 0.28
M4S = tech.space(c3)   # m4 min space 0.28
M3W = tech.width(c2)   # m3 min width 0.28
M3S = tech.space(c2)   # m3 min space 0.28

# bit -> unit count
bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]

c = Cell("cdac6")

# --- place caps clustered by bit, in rows (one row per bit) ---
# row height: caps stacked vertically with pitch; row pitch = H + ENC*2 + M4S (gap between different-bit m4 electrodes)
row_pitch = H + 2 * ENC + M4S
cap_x_start = ENC  # left margin for bottom plate extension

row_y = {}
y = 0.0
for net in bit_order:
    row_y[net] = y
    n = bit_counts[net]
    cols = (n + 3) // 4          # up to 4 caps per row segment
    rows_ = (n + cols - 1) // cols
    y += rows_ * PITCH + row_pitch
array_h = y
array_w = 4 * PITCH + 2 * ENC    # 4 caps wide max

y = 0.0
caps = {}   # net -> list of cap instances
for net in bit_order:
    caps[net] = []
    n = bit_counts[net]
    cols = min(n, 4)
    rows_ = (n + cols - 1) // cols
    placed = 0
    for r in range(rows_):
        for cc in range(cols):
            if placed >= n:
                break
            x = cap_x_start + cc * PITCH + W / 2
            cy = y + r * PITCH + H / 2
            k = c.capacitor("cap_mim", w=W, h=H, at=(x, cy), nets=("TOP", net))
            caps[net].append(k)
            placed += 1
    y += rows_ * PITCH + row_pitch

# --- TOP plane: solid m5 over the whole array; all top plates (m5) merge into it ---
top_plane = c.rect(c4, x0=0, y0=0, x1=array_w, y1=array_h, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

# --- bottom plates: each bit's m4 electrode extends down from its row to a collection trunk ---
# trunk for each bit runs vertically at the right side of the array, on m4, then m3 to pin.
trunk_x = array_w + ENC + M4W / 2
trunk_y0 = 0.0
trunk_y1 = array_h
# vertical trunk per bit is shared: one m4 trunk per bit stacked horizontally? Instead route each bit's
# m4 electrode to its own m4 trunk segment, then up on m3.
# Simpler: bring each bit's bottom plate out on m4 to the right edge, then jog up on m3 to a pin.

pin_x = array_w + ENC + M4W + M3S + M3W   # rightmost pin column
pin_w = M3W
pin_h = M4W

pin_y = {}
cy = 0.0
for net in bit_order:
    n = bit_counts[net]
    rows_ = (n + min(n, 4) - 1) // min(n, 4)
    bh = rows_ * PITCH
    # m4 electrode: extend bottom plate of this row down to a trunk at trunk_x
    # route m4 from row area to trunk_x, then up m3 to pin
    # m4 horizontal segment at row bottom
    y0 = row_y[net]
    y1 = y0 + bh
    # m4 trunk segment for this bit (vertical) at trunk_x, spanning the row height + margin
    c.rect(c3, x0=trunk_x - M4W / 2, y0=y0 - ENC, x1=trunk_x + M4W / 2, y1=y1 + ENC, net=net)
    # connect each cap bottom pad to the trunk: m4 jog from pad down to trunk level, then to trunk_x
    for k in caps[net]:
        pad = k.bottom_pad
        px = pad.cx
        py = pad.cy
        # m4 vertical jog from pad to row bottom edge
        c.rect(c3, x0=px - M4W / 2, y0=y0 - ENC, x1=px + M4W / 2, y1=py + H / 2, net=net)
        # m4 horizontal jog to trunk
        c.rect(c3, x0=px + M4W / 2, y0=y0 - ENC, x1=trunk_x + M4W / 2, y1=y0 - ENC + M4W, net=net)
    # m3 via + trunk up to pin
    pin_cy = cy + bh / 2
    pin_y[net] = pin_cy
    # via3 m4->m3 at trunk
    c.via(c3, c2, at=(trunk_x, y0 - ENC + M4W / 2), net=net)
    # m3 vertical trunk from via to pin height
    c.rect(c2, x0=trunk_x - M3W / 2, y0=y0 - ENC + M4W / 2, x1=trunk_x + M3W / 2, y1=pin_cy, net=net)
    # m3 pin at right edge
    c.rect(c2, x0=pin_x - pin_w, y0=pin_cy - pin_h / 2, x1=pin_x, y1=pin_cy + pin_h / 2, net=net)
    # m3 horizontal from trunk to pin
    c.rect(c2, x0=trunk_x + M3W / 2, y0=pin_cy - M3W / 2, x1=pin_x, y1=pin_cy + M3W / 2, net=net)
    c.port(net, on=c.rect(c2, x0=pin_x - pin_w, y0=pin_cy - pin_h / 2, x1=pin_x, y1=pin_cy + pin_h / 2, net=net), dir="inout")
    cy += bh + row_pitch

bbox_w = pin_x + M3S
bbox_h = array_h
TOP = c

