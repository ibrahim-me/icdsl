"""cdac6 - 6-bit binary-weighted capacitor array (gf180mcuD)."""
from icdsl.canvas import *

tech = use()
assert tech.d.get("name") == "gf180mcuD", "this script targets gf180mcuD"
c0, c1, c2, c3, c4 = tech.c0, tech.c1, tech.c2, tech.c3, tech.c4  # m1..m5

W = H = 5.0          # unit cap (capm wmin=5)
PITCH = 5.6          # W + capm min space 0.6
ENC = 0.6            # bottom plate overlap of cap (MIMTM.3)
M4W = tech.width(c3)   # m4 min width 0.28
M4S = tech.space(c3)   # m4 min space 0.28

bit_counts = {"B5": 32, "B4": 16, "B3": 8, "B2": 4, "B1": 2, "B0": 1, "VSS": 1}
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]

c = Cell("cdac6")

# --- place caps clustered by bit, one row per bit ---
row_y = {}
y = 0.0
for net in bit_order:
    row_y[net] = y
    n = bit_counts[net]
    cols = min(n, 4)
    rows_ = (n + cols - 1) // cols
    y += rows_ * PITCH + ENC * 2 + M4S
array_h = y
array_w = 4 * PITCH + ENC * 2

y = 0.0
caps = {}
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
            x = ENC + cc * PITCH + W / 2
            cy = y + r * PITCH + H / 2
            k = c.capacitor("cap_mim", w=W, h=H, at=(x, cy), nets=("TOP", net))
            caps[net].append(k)
            placed += 1
    y += rows_ * PITCH + ENC * 2 + M4S

# --- TOP plane: solid m5 over the whole array; all top plates merge into it ---
top_plane = c.rect(c4, x0=0, y0=0, x1=array_w, y1=array_h, net="TOP")
c.port("TOP", on=top_plane, dir="inout")

# --- bottom plates: one m4 electrode per bit covering its caps + ENC margin ---
# route each electrode to the right array edge; port on m4 (no via on bottom plate: MIMTM.10)
pin_x = array_w + ENC + M4W
pin_w = M4W
pin_h = M4W

cy = 0.0
for net in bit_order:
    n = bit_counts[net]
    cols = min(n, 4)
    rows_ = (n + cols - 1) // cols
    y0 = row_y[net]
    bh = rows_ * PITCH
    # m4 electrode: spans all caps of this bit horizontally, plus ENC margin; vertically the row + ENC
    x0 = 0.0
    x1 = array_w
    c.rect(c3, x0=x0, y0=y0 - ENC, x1=x1, y1=y0 + bh + ENC, net=net)
    # extend electrode to the right edge for the pin (already to x1=array_w); add pin pad
    c.rect(c3, x0=array_w, y0=cy + bh / 2 - pin_h / 2, x1=pin_x, y1=cy + bh / 2 + pin_h / 2, net=net)
    c.port(net, on=c.rect(c3, x0=pin_x - pin_w, y0=cy + bh / 2 - pin_h / 2,
                          x1=pin_x, y1=cy + bh / 2 + pin_h / 2, net=net), dir="inout")
    cy += bh + ENC * 2 + M4S

bbox_w = pin_x + M4S
bbox_h = array_h
TOP = c

