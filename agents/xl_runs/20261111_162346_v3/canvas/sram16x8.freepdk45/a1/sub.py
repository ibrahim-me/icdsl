from icdsl.canvas import *

tech = use()                      # freepdk45 (or sky130A / gf180mcuD)
c0 = tech.c0                      # m1 on freepdk45

# ------------------------------------------------------------------ cell
s6 = Cell("sram6t")

# n-strip: BL-WL-Q | Q-QB-VSS | VSS-Q-QB | QB-WL-BLB  (shared diffusions are one net)
# p-strip: Q-QB-VDD | VDD-Q-QB  (two empty columns to match column count)
s6 = stick("sram6t",
           n="BL WL Q  Q QB VSS  VSS Q QB  QB WL BLB",
           p="Q QB VDD  VDD Q QB  - - -  - - -",
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
        wl = "WL%d" % r
        bl = "BL%d" % c
        blb = "BLB%d" % c
        insts[name] = TOP.place(s6, at=(c * pitch_x, r * pitch_y), name=name,
                                conns={"VSS": "VSS", "VDD": "VDD",
                                       "BL": bl, "BLB": blb, "WL": wl})

# ------------------------------------------------------------------ global rails / word lines / bit lines
m2 = tech.metal(2)
m3 = tech.metal(3)
sp = lambda L, w=None: tech.space(L, width=w) if w is not None else tech.space(L)

# VDD / VSS: horizontal m2 rails per row, staggered vias to the cell c1 rails
for r in range(ROWS):
    y = r * pitch_y + s6.stick["track_y"]  # centre of the c1 port tracks
    for net, port in (("VDD", "VDD"), ("VSS", "VSS")):
        rail = TOP.rect(m2, x0=0, x1=COLS * pitch_x, y0=y - 0.035, y1=y + 0.035, net=net)
        for c in range(COLS):
            p = insts["XB%d_%d" % (r, c)].pin(port)
            TOP.via(c0, m2, at=(p.cx, p.cy), net=net)
        TOP.port(net, on=rail, dir="inout")

# Word lines: m3 horizontal per row, vias down to each cell WL port (c1)
for r in range(ROWS):
    y = r * pitch_y + s6.stick["track_y"]
    wl = TOP.rect(m3, x0=-1.0, x1=COLS * pitch_x + 1.0,
                  y0=y - 0.05, y1=y + 0.05, net="WL%d" % r)
    for c in range(COLS):
        p = insts["XB%d_%d" % (r, c)].pin("WL")
        TOP.via(c0, m3, at=(p.cx, p.cy), net="WL%d" % r, nx=1, ny=1)
    TOP.port("WL%d" % r, on=wl, dir="in")

# Bit lines: m2 vertical per column, vias to each cell BL/BLB port (c1)
for c in range(COLS):
    x = c * pitch_x + pitch_x / 2
    for net, port in (("BL%d" % c, "BL"), ("BLB%d" % c, "BLB")):
        bl = TOP.rect(m2, x0=x - 0.035, x1=x + 0.035, y0=-1.0,
                      y1=ROWS * pitch_y + 1.0, net=net)
        for r in range(ROWS):
            p = insts["XB%d_%d" % (r, c)].pin(port)
            TOP.via(c0, m2, at=(p.cx, p.cy), net=net)
        TOP.port(net, on=bl, dir="inout")

# ------------------------------------------------------------------ boundary
TOP.rect("boundary", x0=-1, y0=-1, x1=COLS * pitch_x + 1, y1=ROWS * pitch_y + 1)
