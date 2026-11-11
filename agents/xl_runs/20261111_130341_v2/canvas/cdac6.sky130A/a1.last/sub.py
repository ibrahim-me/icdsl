from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3

CAP_W, CAP_H = 5.0, 5.0          # cap_mim w=5 l=5 (matches the netlist)
PX, PY = 7.0, 7.0                # grid pitch (5x5 cap + 2 um spacing > capm 0.84 space)
COLS, ROWS = 8, 8                # 64 unit capacitors

# bit per column: 32/16/8 units for B5/B4/B3, last column splits B2/B1/B0/VSS
COL_BIT = ["B5", "B5", "B5", "B5", "B4", "B4", "B3", None]
LAST_COL_BIT = {0: "B2", 1: "B2", 2: "B2", 3: "B2",
                4: "B1", 5: "B1", 6: "B0", 7: "VSS"}
TOP_NET = "TOP"

c = Cell("cdac6")
caps = []
for col in range(COLS):
    for row in range(ROWS):
        net = LAST_COL_BIT[row] if col == COLS - 1 else COL_BIT[col]
        if net is None:
            continue
        k = c.capacitor("cap_mim", w=CAP_W, h=CAP_H,
                        at=(col * PX, row * PY),
                        nets=(TOP_NET, net))
        caps.append(k)

# TOP bus: solid m3 fill over the array, every top pad (m2) vias up to it
x0 = min(k.top_pad.left for k in caps) - 0.6
x1 = max(k.top_pad.right for k in caps) + 0.6
y0 = min(k.top_pad.bottom for k in caps) - 0.6
y1 = max(k.top_pad.top for k in caps) + 0.6
top_bus = c.rect(c3, x0=x0, x1=x1, y0=y0, y1=y1, net=TOP_NET)
for k in caps:
    c.via(c2, c3, at=k.top_pad, net=TOP_NET)

# bit buses: one m2 horizontal bus per bit below the array, vertical m2 trunk
# per column, via from each bottom pad (m1) to the trunk, trunk joins its bus
BIT_ORDER = ["B5", "B4", "B3", "B2", "B1", "B0", "VSS"]
BIT_Y = {}
by = y1 + 1.2
for bit in BIT_ORDER:
    BIT_Y[bit] = by
    by += 1.6

for bit in BIT_ORDER:
    bus = c.rect(c2, x0=x0 - 1.0, x1=x1 + 1.0,
                 y0=BIT_Y[bit] - 0.8, y1=BIT_Y[bit] + 0.8, net=bit)
    for col in range(COLS):
        serves = any((LAST_COL_BIT[r] if col == COLS - 1 else COL_BIT[col]) == bit
                     for r in range(ROWS))
        if not serves:
            continue
        xt = col * PX + CAP_W / 2.0
        trunk = c.rect(c2, x0=xt - 0.45, x1=xt + 0.45,
                       y0=BIT_Y[bit] + 0.8, y1=y1 + 0.6, net=bit)
        for row in range(ROWS):
            b = LAST_COL_BIT[row] if col == COLS - 1 else COL_BIT[col]
            if b != bit:
                continue
            k = caps[row * COLS + col]
            c.via(c1, c2, at=k.bottom_pad, net=bit)
            c.rect(c2, x0=k.bottom_pad.left - 0.45, x1=k.bottom_pad.right + 0.45,
                   y0=k.bottom_pad.top, y1=BIT_Y[bit] + 0.8, net=bit)
    c.port(bit, on=bus, dir="out")

c.port(TOP_NET, on=top_bus, dir="out")

TOP = c
