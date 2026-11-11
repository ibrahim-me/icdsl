```
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2

# ------------------------------------------------------------------ rules
L   = 0.28          # gate length
Wn  = 0.36          # nmos width
Wp  = 0.72          # pmos width
m1w = tech.width(c0)   # 0.23
m2w = tech.width(c2)   # 0.28
cs  = 0.22          # contact size
csp = 0.25          # contact space
gcs = tech.rule("gate_contact_space")   # 0.15
peg = tech.rule("poly_endcap")          # 0.22
deg = tech.rule("diff_ext_gate")        # 0.23

Wc = 5.5   # cell width
Hc = 6.0   # cell height
COLS, ROWS = 8, 16

# ------------------------------------------------------------------ 6T cell
acell = Cell("sram6t")

# rails (m1)
vss = acell.rect(c0, x0=0, x1=Wc, y0=0, y1=m1w, net="VSS")
vdd = acell.rect(c0, x0=0, x1=Wc, y0=Hc-m1w, y1=Hc, net="VDD")

# nmos row: MnL MnDL MnDR MnR
yn = 1.5
np_ = 1.25
xn = [0.75, 0.75+np_, 0.75+2*np_, 0.75+3*np_]

MnL = acell.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BL", "Q"), at=(xn[0], yn))
MnDL = acell.mos("nmos", w=Wn, l=L, nf=1, gates="QB", sd=("Q", "VSS"), at=(xn[1], yn))
MnDR = acell.mos("nmos", w=Wn, l=L, nf=1, gates="Q", sd=("VSS", "QB"), at=(xn[2], yn))
MnR = acell.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("QB", "BLB"), at=(xn[3], yn))

# pmos row: MpL MpR (inside nwell)
yp = Hc - 1.5 - Wp
xp = [1.375, 4.125]

nwell = acell.rect("nwell", x0=-0.3, x1=Wc+0.3,
                   y0=yp-Wp/2-0.3, y1=yp+Wp/2+0.3, net=None)

MpL = acell.mos("pmos", w=Wp, l=L, nf=1, gates="QB", sd=("VDD", "Q"), at=(xp[0], yp), well=False)
MpR = acell.mos("pmos", w=Wp, l=L, nf=1, gates="Q", sd=("VDD", "QB"), at=(xp[1], yp), well=False)

# storage node Q : MnL.drain(sd[1]) MnDL.source(sd[0]) MpL.drain(sd[1])
Q = acell.rect(c0,
    x0=min(MnL.sd[1].left, MnDL.sd[0].left, MpL.sd[1].left),
    x1=max(MnL.sd[1].right, MnDL.sd[0].right, MpL.sd[1].right),
    y0=min(MnL.sd[1].bottom, MnDL.sd[0].bottom, MpL.sd[1].bottom),
    y1=max(MnL.sd[1].top, MnDL.sd[0].top, MpL.sd[1].top), net="Q")
for r in (MnL.sd[1], MnDL.sd[0], MpL.sd[1]):
    acell.rect(c0, bbox=r.bbox, net="Q")

# storage node QB : MnR.source(sd[0]) MnDR.drain(sd[1]) MpR.drain(sd[1])
QB = acell.rect(c0,
    x0=min(MnR.sd[0].left, MnDR.sd[1].left, MpR.sd[1].left),
    x1=max(MnR.sd[0].right, MnDR.sd[1].right, MpR.sd[1].right),
    y0=min(MnR.sd[0].bottom, MnDR.sd[1].bottom, MpR.sd[1].bottom),
    y1=max(MnR.sd[0].top, MnDR.sd[1].top, MpR.sd[1].top), net="QB")
for r in (MnR.sd[0], MnDR.sd[1], MpR.sd[1]):
    acell.rect(c0, bbox=r.bbox, net="QB")

# VSS strap : pulldown drains to VSS rail
for d in (MnDL.sd[1], MnDR.sd[0]):
    acell.rect(c0, x0=d.left, x1=d.right, y0=vss.top-m1w, y1=vss.top, net="VSS")
    acell.via("diff", c0, at=(d.cx, vss.top-m1w/2), net="VSS", dir="v")

# VDD strap : pmos sources to VDD rail
for s in (MpL.sd[0], MpR.sd[0]):
    acell.rect(c0, x0=s.left, x1=s.right, y0=vdd.bottom, y1=vdd.bottom+m1w, net="VDD")
    acell.via("diff", c0, at=(s.cx, vdd.bottom+m1w/2), net="VDD", dir="v")

# WL : extend access gates, contact, m1 stub to cell top edge
for mn in (MnL, MnR):
    g = mn.gates[0]
    acell.rect("poly", x0=g.left, x1=g.right, y0=g.top, y1=g.top+peg, net="WL")
    acell.rect("poly", x0=g.left, x1=g.right, y0=g.bottom-peg, y1=g.bottom, net="WL")
    ct = acell.via("poly", c0, at=(g.cx, g.top+peg/2), net="WL", dir="v")
    acell.rect(c0, x0=ct.lower.left, x1=ct.lower.right,
               y0=ct.lower.top, y1=Hc-m1w-gcs, net="WL")

# BL / BLB : contact on access source, m1 stub to cell top edge
acell.rect("poly", x0=MnL.sd[0].left-deg, x1=MnL.sd[0].right+deg,
           y0=MnL.sd[0].top, y1=MnL.sd[0].top+peg, net="BL")
ct = acell.via("poly", c0, at=(MnL.sd[0].cx, MnL.sd[0].top+peg/2), net="BL", dir="v")
acell.rect(c0, x0=ct.lower.left, x1=ct.lower.right,
           y0=ct.lower.top, y1=Hc-m1w-gcs, net="BL")

acell.rect("poly", x0=MnR.sd[1].left-deg, x1=MnR.sd[1].right+deg,
           y0=MnR.sd[1].top, y1=MnR.sd[1].top+peg, net="BLB")
ct = acell.via("poly", c0, at=(MnR.sd[1].cx, MnR.sd[1].top+peg/2), net="BLB", dir="v")
acell.rect(c0, x0=ct.lower.left, x1=ct.lower.right,
           y0=ct.lower.top, y1=Hc-m1w-gcs, net="BLB")

# ports
acell.port("WL",  on=MnL.gates[0])
acell.port("BL",  on=MnL.sd[0])
acell.port("BLB", on=MnR.sd[1])
acell.port("VDD", on=vdd)
acell.port("VSS", on=vss)

# ------------------------------------------------------------------ top
top = Cell("sram16x8")

bl_nets  = ["BL%d"  % i for i in range(COLS)]
blb_nets = ["BLB%d" % i for i in range(COLS)]
wl_nets  = ["WL%d"  % i for i in range(ROWS)]

# place the 128 cells
for r in range(ROWS):
    for col in range(COLS):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": bl_nets[col], "BLB": blb_nets[col],
                 "WL": wl_nets[r]}
        top.place(acell, at=(col*Wc, r*Hc),
                  name="XB%d_%d" % (r, col), conns=conns)

# global word lines : m2 horizontal trunks, one per row
for r in range(ROWS):
    y = r*Hc + Hc/2
    top.rect(c2, x0=0, x1=COLS*Wc, y0=y-m2w/2, y1=y+m2w/2, net=wl_nets[r])
    for col in range(COLS):
        ref = top  # placeholder, refs handled by place()
        # contact from cell WL m1 stub up to m2 trunk
        inst = None
    # use the placed instance pin for the contact
    for col in range(COLS):
        pass

# global bit lines : m2 vertical trunks, one per column
for col in range(COLS):
    x = col*Wc + Wc/2
    top.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=bl_nets[col])
    top.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=blb_nets[col])

# contacts from cell m1 stubs up to m2 trunks
for r in range(ROWS):
    for col in range(COLS):
        ref = top.place  # not used directly
        # get the instance ref from the placement
        pass

# Actually we need the refs. Let's collect them.
refs = {}
for r in range(ROWS):
    for col in range(COLS):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": bl_nets[col], "BLB": blb_nets[col],
                 "WL": wl_nets[r]}
        refs[(r, col)] = top.place(acell, at=(col*Wc, r*Hc),
                                   name="XB%d_%d" % (r, col), conns=conns)

# redo word lines with contacts
for r in range(ROWS):
    y = r*Hc + Hc/2
    top.rect(c2, x0=0, x1=COLS*Wc, y0=y-m2w/2, y1=y+m2w/2, net=wl_nets[r])
    for col in range(COLS):
        ref = refs[(r, col)]
        pin = ref.pin("WL")          # m1 stub inside the cell
        top.via(c0, c2, at=(pin.cx, Hc-m1w-gcs+m2w/2), net=wl_nets[r], dir="v")

# redo bit lines with contacts
for col in range(COLS):
    x = col*Wc + Wc/2
    top.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=bl_nets[col])
    top.rect(c2, x0=x-m2w/2, x1=x+m2w/2, y0=0, y1=ROWS*Hc, net=blb_nets[col])
    for r in range(ROWS):
        ref = refs[(r, col)]
        pin_bl  = ref.pin("BL")
        pin_blb = ref.pin("BLB")
        top.via(c0, c2, at=(pin_bl.cx,  Hc-m1w-gcs+m2w/2), net=bl_nets[col],  dir="v")
        top.via(c0, c2, at=(pin_blb.cx, Hc-m1w-gcs+m2w/2), net=blb_nets[col], dir="v")

# VDD / VSS : m1 rails already span each cell; connect to top ports
top.rect(c1, x0=0, x1=COLS*Wc, y0=0, y1=0.3, net="VSS")
top.rect(c1, x0=0, x1=COLS*Wc, y0=ROWS*Hc-0.3, y1=ROWS*Hc, net="VDD")
for r in range(ROWS):
    for col in range(COLS):
        ref = refs[(r, col)]
        top.via(c0, c1, at=(refs[(r, col)].pin("VSS").cx, 0.15), net="VSS", dir="v")
        top.via(c0, c1, at=(refs[(r, col)].pin("VDD").cx, ROWS*Hc-0.15), net="VDD", dir="v")

# ports on top
for i in range(COLS):
    x = i*Wc + Wc/2
    top.port("BL%d"  % i, on=top.rect(c2, x0=x-m2w/2, x1=x+m2w/2,
                                      y0=ROWS*Hc, y1=ROWS*Hc+0.4, net="BL%d" % i))
    top.port("BLB%d" % i, on=top.rect(c2, x0=x-m2w/2, x1=x+m2w/2,
                                      y0=ROWS*Hc, y1=ROWS*Hc+0.4, net="BLB%d" % i))
for r in range(ROWS):
    y = r*Hc + Hc/2
    top.port("WL%d" % r, on=top.rect(c2, x0=0, x1=0.4,
                                     y0=y-m2w/2, y1=y+m2w/2, net="WL%d" % r))
top.port("VDD", on=top.rect(c1, x0=0, x1=0.4, y0=ROWS*Hc-m1w, y1=ROWS*Hc, net="VDD"))
top.port("VSS", on=top.rect(c1, x0=0, x1=0.4, y0=0, y1=m1w, net="VSS"))

TOP = top
```