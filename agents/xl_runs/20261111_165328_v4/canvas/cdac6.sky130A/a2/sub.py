from icdsl.canvas import *

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
m3 = tech.metal(3)
m4 = tech.metal(4)
top_m = tech.stack[-1]

# ------------------------------------------------------------------
# Array parameters (sky130A cap_mim unit = 5 x 5 um)
# ------------------------------------------------------------------
cap_w = 5.0
cap_h = 5.0
pitch_x = 8.0
pitch_y = 8.0
cols = 8
rows = 8
array_w = cols * pitch_x
array_h = rows * pitch_y

# ------------------------------------------------------------------
# Bottom-plate net for capacitor index 0..63 (matches sky130A.spice)
# ------------------------------------------------------------------
def bottom_net(idx):
    if idx == 0:
        return "VSS"
    if idx % 2 == 1:
        return "B5"
    if idx % 4 == 2:
        return "B4"
    if idx % 8 == 4:
        return "B3"
    if idx % 16 == 8:
        return "B2"
    if idx % 32 == 16:
        return "B1"
    return "B0"  # idx == 32

# ------------------------------------------------------------------
c = Cell("cdac6")

# Place 64 unit capacitors in an 8 x 8 grid (interleaved by bit)
caps = []
for r in range(rows):
    for col in range(cols):
        idx = r * cols + col
        cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                          at=(col * pitch_x, r * pitch_y),
                          nets=("TOP", bottom_net(idx)))
        caps.append(cap)

# ------------------------------------------------------------------
# TOP plate: all top pads tied together on m4, brought out on m5
# ------------------------------------------------------------------
top_bus = c.rect(m4, x0=0, y0=0, x1=array_w, y1=array_h, net="TOP")
for cap in caps:
    c.via(m4, cap.top_pad.layer, at=cap.top_pad.cx, net="TOP",
          dir="h") if hasattr(cap.top_pad, 'cx') else None
    # robust via: place at pad centre, stack m4 -> pad layer
    c.via(m4, cap.top_pad.layer, at=(cap.top_pad.cx, cap.top_pad.cy),
          net="TOP")

# TOP port on top metal
top_port = c.rect(top_m, x0=array_w + 1.0, x1=array_w + 3.0,
                  y0=array_h / 2 - 1.0, y1=array_h / 2 + 1.0, net="TOP")
c.via(top_m, m4, at=(top_port.cx, top_port.cy), net="TOP")
c.port("TOP", on=top_port)

# ------------------------------------------------------------------
# Bottom plates: route each column's uniform nets on m2, column 0 individually
# ------------------------------------------------------------------
# Columns 1,3,5,7 -> B5 ; columns 2,6 -> B4 ; column 4 -> B3
col_net = {1: "B5", 3: "B5", 5: "B5", 7: "B5",
           2: "B4", 6: "B4",
           4: "B3"}

for col, net in col_net.items():
    x = col * pitch_x + cap_w / 2
    bus = c.rect(m2, x0=x - 0.5, x1=x + 0.5, y0=0, y1=array_h, net=net)
    for r in range(rows):
        cap = caps[r * cols + col]
        c.via(m2, cap.bottom_pad.layer, at=(cap.bottom_pad.cx, cap.bottom_pad.cy),
              net=net)

# Column 0: mixed nets (VSS, B2, B1, B2, B0, B2, B1, B2) - route individually
col0_x = cap_w / 2
for r in range(rows):
    cap = caps[r * cols + 0]
    net = bottom_net(r * cols + 0)
    # horizontal m2 segment from pad to a vertical collection line at left edge
    seg = c.rect(m2, x0=0.0, x1=cap.bottom_pad.cx,
                 y0=cap.bottom_pad.cy - 0.5, y1=cap.bottom_pad.cy + 0.5, net=net)
    c.via(m2, cap.bottom_pad.layer, at=(cap.bottom_pad.cx, cap.bottom_pad.cy), net=net)

# Bring column-0 nets out on the left edge at staggered y positions
left_port_x = -3.0
port_pitch_y = 6.0
col0_nets_order = ["VSS", "B2", "B1", "B0"]  # distinct nets in column 0
col0_y = {}
y_cursor = array_h / 2
for net in col0_nets_order:
    col0_y[net] = y_cursor
    y_cursor += port_pitch_y

# Actually place ports for B0, B1, B2, VSS on the left
for net, y in col0_y.items():
    p = c.rect(m2, x0=left_port_x, x1=left_port_x + 2.0,
               y0=y - 0.8, y1=y + 0.8, net=net)
    c.port(net, on=p)

# Connect column-0 pads to their left-edge ports with m2 jogs
for r in range(rows):
    idx = r * cols + 0
    net = bottom_net(idx)
    cap = caps[idx]
    pad = cap.bottom_pad
    target_y = col0_y[net]
    # horizontal from pad to x=0, then vertical to target_y, then horizontal to port
    c.rect(m2, x0=0.0, x1=pad.cx, y0=pad.cy - 0.5, y1=pad.cy + 0.5, net=net)
    c.via(m2, pad.layer, at=(pad.cx, pad.cy), net=net)
    c.rect(m2, x0=0.0, x1=0.6, y0=min(pad.cy, target_y) - 0.5,
           y1=max(pad.cy, target_y) + 0.5, net=net)
    c.rect(m2, x0=0.6, x1=left_port_x + 2.0,
           y0=target_y - 0.5, y1=target_y + 0.5, net=net)

# ------------------------------------------------------------------
# B5, B4, B3 ports on the right edge
# ------------------------------------------------------------------
right_port_x = array_w + 1.0
right_y = {"B5": array_h / 2 + 6.0, "B4": array_h / 2 + 2.0, "B3": array_h / 2 - 2.0}
for net, y in right_y.items():
    p = c.rect(m2, x0=right_port_x, x1=right_port_x + 2.0,
               y0=y - 0.8, y1=y + 0.8, net=net)
    c.port(net, on=p)
    # connect the column buses to this port
    for col, n in col_net.items():
        if n == net:
            x = col * pitch_x + cap_w / 2
            c.rect(m2, x0=x - 0.5, x1=right_port_x + 2.0,
                   y0=y - 0.5, y1=y + 0.5, net=net)

# ------------------------------------------------------------------
# Bounding box & ports
# ------------------------------------------------------------------
c.port("B0", on=c.rect(m2, x0=left_port_x, x1=left_port_x + 2.0,
                       y0=col0_y["B0"] - 0.8, y1=col0_y["B0"] + 0.8, net="B0"))
c.port("B1", on=c.rect(m2, x0=left_port_x, x1=left_port_x + 2.0,
                       y0=col0_y["B1"] - 0.8, y1=col0_y["B1"] + 0.8, net="B1"))
c.port("B2", on=c.rect(m2, x0=left_port_x, x1=left_port_x + 2.0,
                       y0=col0_y["B2"] - 0.8, y1=col0_y["B2"] + 0.8, net="B2"))
c.port("VSS", on=c.rect(m2, x0=left_port_x, x1=left_port_x + 2.0,
                        y0=col0_y["VSS"] - 0.8, y1=col0_y["VSS"] + 0.8, net="VSS"))

TOP = c
