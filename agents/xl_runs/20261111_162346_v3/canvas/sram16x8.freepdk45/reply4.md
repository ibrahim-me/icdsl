```
from icdsl.canvas import *

tech = use()
c1 = tech.c1   # m2: stick-cell port layer
c2 = tech.c2   # m3: bit lines + VDD/VSS vertical buses
c3 = tech.c3   # m4: word lines

s6 = stick("sram6t",
           n="BL WL Q QB VSS Q QB WL BLB",
           p="Q QB VDD Q QB - - - -",
           ports="VSS VDD BL BLB WL")

TOP = Cell("sram16x8")
COLS, ROWS = 8, 16
pitch_x = s6.stick["W"]
pitch_y = s6.stick["H"]

insts = {}
for r in range(ROWS):
    for c in range(COLS):
        name = "XB%d_%d" % (r, c)
        insts[name] = TOP.place(s6, at=(c * pitch_x, r * pitch_y), name=name,
                                conns={"VSS": "VSS", "VDD": "VDD",
                                       "BL": "BL%d" % c, "BLB": "BLB%d" % c,
                                       "WL": "WL%d" % r})

w2 = tech.width(c1)
w3 = tech.width(c2)
w4 = tech.width(c3)

# Word lines: horizontal on c3, one per row
for r in range(ROWS):
    y = insts["XB%d_0" % r].pin("WL").cy
    wl = TOP.rect(c3, x0=-1.0, x1=COLS * pitch_x + 1.0,
                  y0=y - w4 / 2, y1=y + w4 / 2, net="WL%d" % r)
    for c in range(COLS):
        p = insts["XB%d_%d" % (r, c)].pin("WL")
        TOP.via(c1, c3, at=(p.cx, p.cy), net="WL%d" % r)
    TOP.port("WL%d" % r, on=wl, dir="in")

# VDD / VSS rails: horizontal on c1 per row (touch cell ports directly)
for r in range(ROWS):
    for net in ("VDD", "VSS"):
        y = insts["XB%d_0" % r].pin(net).cy
        TOP.rect(c1, x0=-1.0, x1=COLS * pitch_x + 1.0,
                 y0=y - w2 / 2, y1=y + w2 / 2, net=net)

# VDD / VSS vertical buses on c2 connecting all rows
for net in ("VDD", "VSS"):
    x = -0.5 if net == "VDD" else COLS * pitch_x + 0.5
    bus = TOP.rect(c2, x0=x - w3 / 2, x1=x + w3 / 2, y0=-1.0,
                   y1=ROWS * pitch_y + 1.0, net=net)
    for r in range(ROWS):
        y = insts["XB%d_0" % r].pin(net).cy
        TOP.via(c1, c2, at=(x, y), net=net)
    TOP.port(net, on=bus, dir="inout")

# Bit lines: vertical on c2, one per column
for c in range(COLS):
    for net, port in (("BL%d" % c, "BL"), ("BLB%d" % c, "BLB")):
        x = insts["XB0_%d" % c].pin(port).cx
        bl = TOP.rect(c2, x0=x - w3 / 2, x1=x + w3 / 2, y0=-1.0,
                      y1=ROWS * pitch_y + 1.0, net=net)
        for r in range(ROWS):
            p = insts["XB%d_%d" % (r, c)].pin(port)
            TOP.via(c1, c2, at=(p.cx, p.cy), net=net)
        TOP.port(net, on=bl, dir="inout")

TOP.rect("boundary", x0=-1, y0=-1, x1=COLS * pitch_x + 1, y1=ROWS * pitch_y + 1)
```