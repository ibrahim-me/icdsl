from icdsl.canvas import *

tech = use()
m2 = tech.metal(2)
m3 = tech.metal(3)
m4 = tech.metal(4)
m5 = tech.metal(5)

cap_w = 5.0
cap_h = 5.0
pitch_x = 8.0
pitch_y = 8.0
cols = 8
rows = 8
array_w = cols * pitch_x
array_h = rows * pitch_y

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
    return "B0"

c = Cell("cdac6")

caps = []
for r in range(rows):
    for col in range(cols):
        idx = r * cols + col
        cap = c.capacitor("cap_mim", w=cap_w, h=cap_h,
                          at=(col * pitch_x, r * pitch_y),
                          nets=("TOP", bottom_net(idx)))
        caps.append(cap)

# TOP plate: m4 bus over the whole array, port on m5
top_bus = c.rect(m4, x0=0, y0=0, x1=array_w, y1=array_h, net="TOP")
top_port = c.rect(m5, x0=array_w + 2.0, x1=array_w + 4.0,
                  y0=array_h / 2 - 1.0, y1=array_h / 2 + 1.0, net="TOP")
c.via(m4, m5, at=(top_port.cx, array_h / 2), net="TOP")
c.port("TOP", on=top_port)

# Bottom plates: columns 1,3,5,7 -> B5 ; 2,6 -> B4 ; 4 -> B3 ; column 0 individual
col_net = {1: "B5", 3: "B5", 5: "B5", 7: "B5",
           2: "B4", 6: "B4",
           4: "B3"}

for col, net in col_net.items():
    x = col * pitch_x + cap_w / 2
    bus = c.rect(m2, x0=x - 0.6, x1=x + 0.6, y0=0, y1=array_h, net=net)
    for r in range(rows):
        cap = caps[r * cols + col]
        pad = cap.bottom_pad
        c.rect(m2, x0=pad.cx - 0.6, x1=pad.cx + 0.6,
               y0=pad.cy - 0.6, y1=pad.cy + 0.6, net=net)
        c.via(m2, m3, at=(pad.cx, pad.cy), net=net)

# Column 0: route each pad on m2 to the left edge at its own y
col0_by_net = {}
for r in range(rows):
    cap = caps[r * cols + 0]
    net = bottom_net(r * cols + 0)
    pad = cap.bottom_pad
    col0_by_net.setdefault(net, []).append(pad)

left_x = -3.0
port_y = {}
y_cursor = array_h / 2 + 4.0
for net in sorted(col0_by_net.keys()):
    port_y[net] = y_cursor
    y_cursor -= 6.0

for net, pads in col0_by_net.items():
    ys = sorted(p.cy for p in pads)
    y0, y1 = ys[0], ys[-1]
    spine_x = left_x - 1.0
    spine = c.rect(m2, x0=spine_x - 0.6, x1=spine_x + 0.6,
                   y0=y0 - 0.6, y1=y1 + 0.6, net=net)
    port = c.rect(m2, x0=left_x, x1=left_x + 2.0,
                  y0=port_y[net] - 0.8, y1=port_y[net] + 0.8, net=net)
    c.rect(m2, x0=spine_x + 0.6, x1=left_x + 2.0,
           y0=port_y[net] - 0.6, y1=port_y[net] + 0.6, net=net)
    c.port(net, on=port)
    for pad in pads:
        c.rect(m2, x0=pad.cx - 0.6, x1=pad.cx + 0.6,
               y0=pad.cy - 0.6, y1=pad.cy + 0.6, net=net)
        c.via(m2, m3, at=(pad.cx, pad.cy), net=net)
        x0 = min(0.0, pad.cx)
        x1 = max(0.0, pad.cx)
        c.rect(m2, x0=x0, x1=x1,
               y0=pad.cy - 0.6, y1=pad.cy + 0.6, net=net)
        c.rect(m2, x0=min(0.0, spine_x + 0.6), x1=max(0.0, spine_x + 0.6),
               y0=min(pad.cy, port_y[net]) - 0.6,
               y1=max(pad.cy, port_y[net]) + 0.6, net=net)

# Right-edge ports for B5, B4, B3
right_x = array_w + 2.0
right_y = {"B5": array_h / 2 + 6.0, "B4": array_h / 2 + 2.0, "B3": array_h / 2 - 2.0}
for net, y in right_y.items():
    port = c.rect(m2, x0=right_x, x1=right_x + 2.0,
                  y0=y - 0.8, y1=y + 0.8, net=net)
    c.port(net, on=port)
    for col, n in col_net.items():
        if n == net:
            x = col * pitch_x + cap_w / 2
            c.rect(m2, x0=x - 0.6, x1=right_x + 2.0,
                   y0=y - 0.6, y1=y + 0.6, net=net)

TOP = c

