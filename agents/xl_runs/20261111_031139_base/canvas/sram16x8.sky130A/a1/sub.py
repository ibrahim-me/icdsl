from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- cell
W, H = 4.30, 5.60          # cell width (x) / height (y); 8 x 16 array
PW, NW = 0.84, 0.42        # pmos / nmos width (sky130: wmin nmos 0.42, pmos 0.84)
L = 0.15
GAP = 0.34                 # horizontal gap between transistor columns
BLW = 0.30                 # bit-line metal width
VSR = 0.40                 # VDD/VSS rail height
PAD = 0.12                 # cell padding

def sram6t(c, at=(0, 0)):
    x0, y0 = at
    # ---- transistors -------------------------------------------------
    a  = c.mos("nmos", w=NW, l=L, gates="WL",  sd=("BL",  "Q"),  at=(x0 + PAD, y0 + PAD))
    n1 = c.mos("nmos", w=NW, l=L, gates="QB",  sd=("Q",   "VSS"), at=(a.sd[1].right + GAP, y0 + PAD))
    p1 = c.mos("pmos", w=PW, l=L, gates="QB",  sd=("VDD", "Q"),  at=(n1.sd[1].right + GAP, y0 + H - PAD - p1.diff.h if False else y0 + PAD), well=False)
    p2 = c.mos("pmos", w=PW, l=L, gates="Q",   sd=("VDD", "QB"), at=(p1.sd[1].right + GAP, y0 + PAD), well=False)
    n2 = c.mos("nmos", w=NW, l=L, gates="Q",   sd=("VSS", "QB"), at=(p2.sd[1].right + GAP, y0 + PAD))
    b  = c.mos("nmos", w=NW, l=L, gates="WL",  sd=("QB", "BLB"), at=(n2.sd[1].right + GAP, y0 + PAD))
    # align pmos row to the top of the cell
    dy = (y0 + H - PAD - p1.diff.h) - p1.diff.bottom
    for m in (p1, p2):
        c.mos("pmos", w=PW, l=L, gates=m.gates[0].net, sd=(m.sd[0].net, m.sd[1].net),
              at=(m.diff.left, m.diff.bottom + dy), well=False) if False else None
    p1 = c.mos("pmos", w=PW, l=L, gates="QB",  sd=("VDD", "Q"),  at=(n1.sd[1].right + GAP, y0 + H - PAD - p1.diff.h), well=False)
    p2 = c.mos("pmos", w=PW, l=L, gates="Q",   sd=("VDD", "QB"), at=(p1.sd[1].right + GAP, y0 + H - PAD - p2.diff.h), well=False)
    # nwell around the pmos pair
    nw = c.rect("nwell", x0=p1.diff.left - 0.18, x1=p2.diff.right + 0.18,
                y0=p1.diff.bottom - 0.18, y1=p1.diff.top + 0.18, net="VDD")
    # ---- rails (m1) --------------------------------------------------
    vss = c.rect(m1, x0=a.diff.left - 0.15, x1=b.diff.right + 0.15,
                 y0=y0, y1=y0 + VSR, net="VSS")
    vdd = c.rect(m1, x0=p1.diff.left - 0.15, x1=p2.diff.right + 0.15,
                 y0=y0 + H - VSR, y1=y0 + H, net="VDD")
    # ---- internal nodes Q / QB (m1 horizontal) -----------------------
    q  = c.rect(m1, x0=a.sd[1].left - 0.10, x1=p1.sd[0].right + 0.10,
                y0=(a.diff.bottom + p1.diff.top) / 2 - 0.14,
                y1=(a.diff.bottom + p1.diff.top) / 2 + 0.14, net="Q")
    qb = c.rect(m1, x0=n2.sd[1].left - 0.10, x1=b.sd[0].right + 0.10,
                y0=(n2.diff.bottom + p2.diff.top) / 2 - 0.14,
                y1=(n2.diff.bottom + p2.diff.top) / 2 + 0.14, net="QB")
    # contacts from sd straps (c0) to rails / nodes (m1)
    def strap_conn(strap, rail):
        c.via(c0, m1, at=strap.cx, net=strap.net, dir="v") if False else None
    for strap, rail in ((a.sd[1], q), (n1.sd[0], q), (p1.sd[1], q), (p2.gates[0], q),
                        (n2.sd[1], qb), (b.sd[0], qb), (p1.gates[0], qb), (p2.sd[1], qb)):
        c.via(c0, m1, at=strap.cx, net=strap.net, dir="v")
    for strap, rail in ((n1.sd[1], vss), (n2.sd[0], vss), (p1.sd[0], vdd), (p2.sd[0], vdd)):
        c.via(c0, m1, at=strap.cx, net=strap.net, dir="v")
    # word line: poly gate pieces of the two access transistors tied by m1
    wl = c.rect(m1, x0=a.gates[0].left - 0.10, x1=b.gates[0].right + 0.10,
                y0=y0 + H - 0.30, y1=y0 + H - 0.30 + 0.28, net="WL")
    c.via("poly", c0, at=a.gates[0].cx, net="WL", dir="v")
    c.via(c0, m1, at=(a.gates[0].cx, wl.cy), net="WL", dir="v")
    c.via("poly", c0, at=b.gates[0].cx, net="WL", dir="v")
    c.via(c0, m1, at=(b.gates[0].cx, wl.cy), net="WL", dir="v")
    # ---- bit lines (m2 vertical) -------------------------------------
    bl  = c.rect(m2, x0=a.sd[0].cx - BLW/2, x1=a.sd[0].cx + BLW/2,
                 y0=y0, y1=y0 + H, net="BL")
    blb = c.rect(m2, x0=b.sd[1].cx - BLW/2, x1=b.sd[1].cx + BLW/2,
                 y0=y0, y1=y0 + H, net="BLB")
    c.via(c0, m2, at=(a.sd[0].cx, bl.cy), net="BL", dir="v")
    c.via(c0, m2, at=(b.sd[1].cx, blb.cy), net="BLB", dir="v")
    # ---- ports -------------------------------------------------------
    c.port("BL",  on=bl,  dir="inout")
    c.port("BLB", on=blb, dir="inout")
    c.port("WL",  on=wl,  dir="in")
    c.port("VDD", on=vdd, dir="in")
    c.port("VSS", on=vss, dir="in")
    return dict(w=W, h=H, bl=bl.cx, blb=blb.cx)

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
cell = Cell("sram6t")
sram6t(cell)
cell_w, cell_h = W, H

# place array: 16 rows (y) x 8 columns (x); WL per row, BL/BLB per column
pitch_x = cell_w
pitch_y = cell_h
for r in range(16):
    for ccol in range(8):
        inst = top.place(cell, at=(ccol * pitch_x, r * pitch_y),
                         name=f"XB{r}_{ccol}",
                         conns={"BL": f"BL{ccol}", "BLB": f"BLB{ccol}",
                                "WL": f"WL{r}", "VDD": "VDD", "VSS": "VSS"})

# global rails: VDD / VSS horizontal m1 spanning the array, plus edge taps
vdd = top.rect(m1, x0=0, x1=8 * pitch_x, y0=16 * pitch_y - VSR, y1=16 * pitch_y, net="VDD")
vss = top.rect(m1, x0=0, x1=8 * pitch_x, y0=0, y1=VSR, net="VSS")
# bit lines: m2 vertical spanning the array height at each column
for ccol in range(8):
    top.rect(m2, x0=ccol * pitch_x + cell_w/2 - BLW/2 - 0.55,
             x1=ccol * pitch_x + cell_w/2 - BLW/2 - 0.55 + BLW,
             y0=0, y1=16 * pitch_y, net=f"BL{ccol}")
    top.rect(m2, x0=ccol * pitch_x + cell_w/2 + BLW/2 + 0.55,
             x1=ccol * pitch_x + cell_w/2 + BLW/2 + 0.55 + BLW,
             y0=0, y1=16 * pitch_y, net=f"BLB{ccol}")
# word lines: m1 horizontal per row spanning array width
for r in range(16):
    top.rect(m1, x0=0, x1=8 * pitch_x,
             y0=r * pitch_y + cell_h - 0.30, y1=r * pitch_y + cell_h - 0.30 + 0.28, net=f"WL{r}")

# connect cell rails to global rails at left edge (vertical m1 straps at column 0)
for r in range(16):
    top.rect(m1, x0=0, x1=pitch_x, y0=r * pitch_y, y1=r * pitch_y + VSR, net="VSS")
    top.rect(m1, x0=0, x1=pitch_x, y0=r * pitch_y + cell_h - VSR, y1=r * pitch_y + cell_h, net="VDD")

# ports
for net in ["VDD", "VSS"]:
    top.port(net, on=(vdd if net == "VDD" else vss))
for ccol in range(8):
    top.port(f"BL{ccol}", dir="inout")
    top.port(f"BLB{ccol}", dir="inout")
for r in range(16):
    top.port(f"WL{r}", dir="in")

TOP = top
