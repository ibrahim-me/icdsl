```
from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- cell
W, H = 4.30, 5.60
PW, NW, L = 0.84, 0.42, 0.15
GAP = 0.34
BLW = 0.30
VSR = 0.40
PAD = 0.12

def sram6t(c, at=(0, 0)):
    x0, y0 = at
    a  = c.mos("nmos", w=NW, l=L, gates="WL",  sd=("BL",  "Q"),  at=(x0 + 0.70, y0 + 0.90))
    n1 = c.mos("nmos", w=NW, l=L, gates="QB",  sd=("Q",   "VSS"), at=(x0 + 1.60, y0 + 0.90))
    n2 = c.mos("nmos", w=NW, l=L, gates="Q",   sd=("VSS", "QB"), at=(x0 + 2.50, y0 + 0.90))
    b  = c.mos("nmos", w=NW, l=L, gates="WL",  sd=("QB",  "BLB"), at=(x0 + 3.40, y0 + 0.90))
    p4 = c.mos("pmos", w=PW, l=L, gates="QB",  sd=("VDD", "Q"),  at=(x0 + 1.60, y0 + H - 0.90 - p4.diff.h if False else y0 + 0.90), well=False)
    p5 = c.mos("pmos", w=PW, l=L, gates="Q",   sd=("VDD", "QB"), at=(x0 + 2.50, y0 + 0.90), well=False)
    p4 = c.mos("pmos", w=PW, l=L, gates="QB",  sd=("VDD", "Q"),  at=(x0 + 1.60, y0 + H - 0.90 - p4.diff.h), well=False)
    p5 = c.mos("pmos", w=PW, l=L, gates="Q",   sd=("VDD", "QB"), at=(x0 + 2.50, y0 + H - 0.90 - p5.diff.h), well=False)
    c.rect("nwell", x0=p4.diff.left - 0.18, x1=p5.diff.right + 0.18,
           y0=p4.diff.bottom - 0.18, y1=p4.diff.top + 0.18, net="VDD")

    vss = c.rect(m1, x0=x0 - 0.30, x1=x0 + W + 0.30, y0=y0, y1=y0 + VSR, net="VSS")
    vdd = c.rect(m1, x0=x0 - 0.30, x1=x0 + W + 0.30, y0=y0 + H - VSR, y1=y0 + H, net="VDD")

    q  = c.rect(m1, x0=a.sd[1].left - 0.10, x1=n2.sd[1].right + 0.10,
                y0=y0 + 1.36, y1=y0 + 1.36 + 0.28, net="Q")
    qb = c.rect(m1, x0=n1.sd[1].left - 0.10, x1=b.sd[0].right + 0.10,
                y0=y0 + 1.80, y1=y0 + 1.80 + 0.28, net="QB")

    def mc(strap, y):
        c.via(c0, m1, at=(strap.cx, y), net=strap.net)
    for s, y in ((a.sd[1], q.cy), (n1.sd[0], q.cy), (n2.sd[1], q.cy), (p4.sd[1], q.cy),
                 (n1.sd[1], vss.cy), (n2.sd[0], vss.cy)):
        mc(s, y)
    for s, y in ((b.sd[0], qb.cy), (n1.sd[1], qb.cy), (n2.sd[0], qb.cy), (p5.sd[1], qb.cy)):
        mc(s, y)
    c.via("poly", c0, at=(p4.gates[0].cx, qb.cy), net="QB")
    c.via(c0, m1, at=(p4.gates[0].cx, qb.cy), net="QB")
    c.via("poly", c0, at=(p5.gates[0].cx, q.cy), net="Q")
    c.via(c0, m1, at=(p5.gates[0].cx, q.cy), net="Q")

    c.via(c0, m1, at=(a.sd[0].cx, y0 + 0.62), net="BL")
    c.via(c0, m1, at=(b.sd[1].cx, y0 + 0.62), net="BLB")
    c.via(c0, m1, at=(p4.sd[0].cx, y0 + H - 0.62), net="VDD")
    c.via(c0, m1, at=(p5.sd[0].cx, y0 + H - 0.62), net="VDD")

    c.port("BL",  on=c.rect(m2, x0=a.sd[0].cx - BLW/2, x1=a.sd[0].cx + BLW/2,
                            y0=y0, y1=y0 + H, net="BL"), dir="inout")
    c.port("BLB", on=c.rect(m2, x0=b.sd[1].cx - BLW/2, x1=b.sd[1].cx + BLW/2,
                            y0=y0, y1=y0 + H, net="BLB"), dir="inout")
    c.port("WL",  on=c.rect(m1, x0=x0 + 0.55, x1=x0 + W - 0.55,
                            y0=y0 + H - 0.85, y1=y0 + H - 0.85 + 0.30, net="WL"), dir="in")
    c.port("VDD", on=vdd, dir="in")
    c.port("VSS", on=vss, dir="in")
    return dict(w=W, h=H)

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
cell = Cell("sram6t")
sram6t(cell)
CW, CH = 4.30, 5.60
GX, GY = 1.20, 1.00
MX, LX = 0.60, 0.60
BW = 8 * CW + 7 * GX + 2 * LX
BH = 16 * CH + 15 * GY

for r in range(16):
    for ccol in range(8):
        top.place(cell, at=(LX + ccol * (CW + GX), r * (CH + GY)),
                  name=f"XB{r}_{ccol}",
                  conns={"BL": f"BL{ccol}", "BLB": f"BLB{ccol}",
                         "WL": f"WL{r}", "VDD": "VDD", "VSS": "VSS"})

for ccol in range(8):
    cx = LX + ccol * (CW + GX) + CW - 0.30
    top.rect(m2, x0=cx - BLW/2, x1=cx + BLW/2, y0=0, y1=BH, net=f"BL{ccol}")
    top.rect(m2, x0=cx + GX - BLW/2, x1=cx + GX + BLW/2, y0=0, y1=BH, net=f"BLB{ccol}")
for r in range(16):
    ry = r * (CH + GY) + CH - 0.85
    top.rect(m1, x0=0, x1=BW, y0=ry, y1=ry + 0.30, net=f"WL{r}")

for ccol in range(8):
    x0 = LX + ccol * (CW + GX)
    x1 = x0 + CW
    gx = x1 - 0.30
    top.rect(m1, x0=gx, x1=gx + 0.30, y0=0, y1=BH, net="VDD")
    top.rect(m1, x0=gx + GX - 0.30, x1=gx + GX, y0=0, y1=BH, net="VSS")
top.rect(m1, x0=0, x1=0.30, y0=0, y1=BH, net="VDD")
top.rect(m1, x0=BW - 0.30, x1=BW, y0=0, y1=BH, net="VSS")

for net in ("VDD", "VSS"):
    top.port(net, on=top.rect(m1, x0=0, x1=BW, y0=BH - 0.40, y1=BH, net=net) if net == "VDD"
             else top.rect(m1, x0=0, x1=BW, y0=0, y1=0.40, net=net))
for ccol in range(8):
    top.port(f"BL{ccol}", dir="inout")
    top.port(f"BLB{ccol}", dir="inout")
for r in range(16):
    top.port(f"WL{r}", dir="in")

TOP = top
```