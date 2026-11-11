```
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # li
m1 = tech.metal(1)
m2 = tech.metal(2)
top_metal = tech.stack[-1]   # m5 on sky130A

c = Cell("cdac6")

# ---------- unit capacitor grid (clustered by bit) ----------
cap_w = 5.0
cap_h = 5.0
pitch_x = 7.6
pitch_y = 7.6
cols = 8
rows = 8

# bit blocks: (net, x0, x1, y0, y1) in column/row units
blocks = [
    ("B5",  0, 4, 0, 8),   # 32 units
    ("B4",  4, 6, 0, 8),   # 16 units
    ("B3",  6, 7, 0, 8),   # 8 units
    ("B2",  7, 8, 0, 4),   # 4 units
    ("B1",  7, 8, 4, 6),   # 2 units
    ("B0",  7, 8, 6, 7),   # 1 unit
    ("VSS", 7, 8, 7, 8),   # 1 unit
]

caps = []
for net, cx0, cx1, cy0, cy1 in blocks:
    for cr in range(cx0, cx1):
        for rr in range(cy0, cy1):
            cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                              at=(cr * pitch_x, rr * pitch_y),
                              nets=("TOP", net))
            caps.append(cap)

array_right = cols * pitch_x
array_top = rows * pitch_y

# ---------- TOP plate: common m5 plane over the array ----------
top_plane = c.rect(top_metal, x0=-2.0, y0=-2.0,
                   x1=array_right + 2.0, y1=array_top + 2.0, net="TOP")
for cap in caps:
    c.via(c0, top_metal, at=(cap.top_pad.cx, cap.top_pad.cy), net="TOP", dir="v")

# ---------- bottom plates: m2 block per bit (merges with the m2 plates) ----------
block_rect = {}
for net, cx0, cx1, cy0, cy1 in blocks:
    r = c.rect(m2,
               x0=cx0 * pitch_x - 0.5, y0=cy0 * pitch_y - 0.5,
               x1=cx1 * pitch_x + 0.5, y1=cy1 * pitch_y + 0.5,
               net=net)
    block_rect[net] = r

# ---------- pin assignment on the left edge ----------
pin_y = -3.0
pin_step = 1.6
pin_net = ["TOP", "B0", "B1", "B2", "B3", "VSS", "B4", "B5"]
pins = {}
for i, net in enumerate(pin_net):
    py = pin_y + i * pin_step
    pins[net] = c.rect(m1, x0=-6.0, y0=py, x1=-2.0, y1=py + 0.9, net=net)

# ---------- TOP pin: via stack m1 -> top_metal into the plane ----------
c.via(m1, top_metal, at=(-1.5, pins["TOP"].cy), net="TOP", dir="v")

# ---------- bit escapes: m1 L-shapes, one jog x per bit ----------
escape = {
    "B5": dict(block="B5", esc_y=30.4, jog_x=15.2, pin_y=pins["B5"].cy),
    "B4": dict(block="B4", esc_y=30.4, jog_x=38.0, pin_y=pins["B4"].cy),
    "B3": dict(block="B3", esc_y=30.4, jog_x=49.4, pin_y=pins["B3"].cy),
    "B2": dict(block="B2", esc_y=15.2, jog_x=57.0, pin_y=pins["B2"].cy),
    "B1": dict(block="B1", esc_y=53.2, jog_x=57.0, pin_y=pins["B1"].cy),
    "B0": dict(block="B0", esc_y=66.8, jog_x=57.0, pin_y=pins["B0"].cy),
    "VSS": dict(block="VSS", esc_y=66.8, jog_x=57.0, pin_y=pins["VSS"].cy),
}
for net, e in escape.items():
    blk = block_rect[e["block"]]
    # via m1-m2 into the bit block
    c.via(m1, m2, at=(e["jog_x"], e["esc_y"]), net=net, dir="v")
    # vertical jog inside the block (m1 over m2 of the same net)
    c.rect(m1, x0=e["jog_x"] - 0.45, x1=e["jog_x"] + 0.45,
           y0=min(e["esc_y"], e["pin_y"]), y1=max(e["esc_y"], e["pin_y"]), net=net)
    # horizontal run to the pin (crosses other m2 blocks on a different layer: OK)
    c.rect(m1, x0=-2.0, x1=e["jog_x"] + 0.45,
           y0=e["pin_y"] - 0.45, y1=e["pin_y"] + 0.45, net=net)

# ---------- ports ----------
for net in pin_net:
    c.port(net, on=pins[net], dir="inout")

TOP = c

```