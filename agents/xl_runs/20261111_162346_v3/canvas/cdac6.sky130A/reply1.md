```python
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # li
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
m4 = tech.metal(4)
top_metal = tech.stack[-1]   # m5 on sky130A

c = Cell("cdac6")

# ---------- unit capacitor grid ----------
cap_w = 5.0
cap_h = 5.0
pitch_x = 7.6
pitch_y = 7.6
cols = 8
rows = 8

# bit assignment: B5 x32, B4 x16, B3 x8, B2 x4, B1 x2, B0 x1, VSS x1  (total 64)
col_net = ["B5", "B5", "B5", "B5", "B4", "B4", "B3", "B2"]
row_net = [None] * rows
row_net[7] = ["B1", "B1", "B0", "VSS", None, None, None, None]

caps = []
for r in range(rows):
    for col in range(cols):
        net = row_net[r][col] if row_net[r] else col_net[col]
        cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                          at=(col * pitch_x, r * pitch_y),
                          nets=("TOP", net))
        caps.append(cap)

array_right = cols * pitch_x
array_top = rows * pitch_y

# ---------- TOP plate: common m5 plane over the array ----------
top_plane = c.rect(top_metal, x0=-2.0, y0=-2.0,
                   x1=array_right + 2.0, y1=array_top + 2.0, net="TOP")
for cap in caps:
    c.via(c0, top_metal, at=cap.top_pad, net="TOP", dir="v")
c.port("TOP", on=top_plane)

# ---------- bottom plates: bit buses on m2, vertical m1 feeders ----------
bus_pitch = 1.1
bus_y = array_top + 1.5
bit_order = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
bus = {}
for i, net in enumerate(bit_order):
    b = c.rect(m2, x0=-2.0, y0=bus_y + i * bus_pitch,
               x1=array_right + 2.0, y1=bus_y + i * bus_pitch + 0.55, net=net)
    bus[net] = b

for cap in caps:
    bottom_net = cap.nets[1]
    if bottom_net == "TOP":
        continue
    feeder = c.rect(m1, x0=cap.b.left, x1=cap.b.right,
                    y0=cap.b.top, y1=bus[bottom_net].bottom, net=bottom_net)
    c.via(c0, m1, at=cap.b, net=bottom_net, dir="v")
    c.via(m1, m2, at=(feeder.cx, feeder.top), net=bottom_net, dir="v")

# ---------- bring nets out to pins on the left edge ----------
pin_y = -3.0
pin_step = 1.6
for i, net in enumerate(["TOP", "B0", "B1", "B2", "B3", "B4", "B5", "VSS"]):
    if net == "TOP":
        src = top_plane
    else:
        src = bus[net]
    pin = c.rect(m1, x0=-6.0, y0=pin_y + i * pin_step,
                 x1=-2.0, y1=pin_y + i * pin_step + 0.9, net=net)
    c.via(m1, top_metal, at=(src.left, pin.cy), net=net, dir="v")
    c.wire(m1, [pin, (src.left, pin.cy)], net=net, width=0.9)
    c.port(net, on=pin, dir="inout")

TOP = c
```