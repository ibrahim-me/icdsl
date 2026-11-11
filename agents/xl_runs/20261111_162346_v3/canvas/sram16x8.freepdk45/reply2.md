```
from icdsl.canvas import *

tech = use()                      # freepdk45 (or sky130A / gf180mcuD)
c0 = tech.c0                      # m1 on freepdk45

# ------------------------------------------------------------------ cell
s6 = stick("sram6t",
           n="BL WL Q QB VSS Q QB WL BLB",
           p="Q QB VDD Q QB - - - -",
           ports="VSS VDD BL BLB WL", ntracks=4)

# ------------------------------------------------------------------ top
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

m2 = tech.metal(2)   # c1
m3 = tech.metal(3)   # c2
w2 = tech.width(m2)
w3 = tech.width(m3)

# Word lines: m3 horizontal per row, via c1->c2 down to each cell WL port
for r in range(ROWS):
    y = r * pitch_y + s6.stick["track_y"]
    wl = TOP.rect(m3, x0=-1.0, x1=COLS * pitch_x + 1.0,
                  y0=y - w3 / 2, y1=y + w3 / 2, net="WL%d" % r)
    for c in range(COLS):
        p = insts["XB%d_%d" % (r, c)].pin("WL")
        TOP.via(m2, m3, at=(p.cx, p.cy), net="WL%d" % r)
    TOP.port("WL%d" % r, on=wl, dir="in")

# Bit lines: m2 vertical per column, via c1->c2 up to each cell BL/BLB port
for c in range(COLS):
    x = c * pitch_x + pitch_x / 2
    for net, port in (("BL%d" % c, "BL"), ("BLB%d" % c, "BLB")):
        bl = TOP.rect(m2, x0=x - w2 / 2, x1=x + w2 / 2, y0=-1.0,
                      y1=ROWS * pitch_y + 1.0, net=net)
        for r in range(ROWS):
            p = insts["XB%d_%d" % (r, c)].pin(port)
            TOP.via(m2, m3, at=(p.cx, p.cy), net=net)
        TOP.port(net, on=bl, dir="inout")

# VDD / VSS: m2 horizontal rails per row, via c1->c2 to each cell rail port
for r in range(ROWS):
    y = r * pitch_y + s6.stick["track_y"]
    for net, port in (("VDD", "VDD"), ("VSS", "VSS")):
        rail = TOP.rect(m2, x0=-1.0, x1=COLS * pitch_x + 1.0,
                        y0=y - w2 / 2, y1=y + w2 / 2, net=net)
        for c in range(COLS):
            p = insts["XB%d_%d" % (r, c)].pin(port)
            TOP.via(m2, m3, at=(p.cx, p.cy), net=net)
        TOP.port(net, on=rail, dir="inout")

# ------------------------------------------------------------------ boundary
TOP.rect("boundary", x0=-1, y0=-1, x1=COLS * pitch_x + 1, y1=ROWS * pitch_y + 1)

```