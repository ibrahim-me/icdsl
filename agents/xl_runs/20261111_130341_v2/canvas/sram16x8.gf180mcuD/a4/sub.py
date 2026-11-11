from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2

# ------------------------------------------------------------------ rules / sizes
L   = 0.28
Wn  = 0.36
Wp  = 0.72
m1w = tech.width(c0)   # 0.23
m2w = tech.width(c2)   # 0.28
cs  = 0.22
peg = tech.rule("poly_endcap")          # 0.22
gcs = tech.rule("gate_contact_space")   # 0.15
deg = tech.rule("diff_ext_gate")        # 0.23
v1s = 0.26                              # via1 size (gf180mcuD)
stubw = max(cs, v1s + 0.12)             # m1 stub wide enough for a via1

Wc = 5.6   # cell width
Hc = 6.0   # cell height
COLS, ROWS = 8, 16
YCON = Hc / 2.0          # local y where m1 stubs meet the m2 trunks

# ------------------------------------------------------------------ 6T cell
acell = Cell("sram6t")

# rails (m1) span the full cell width; abutting cells make continuous rails
vss = acell.rect(c0, x0=0, x1=Wc, y0=0, y1=m1w, net="VSS")
vdd = acell.rect(c0, x0=0, x1=Wc, y0=Hc - m1w, y1=Hc, net="VDD")

# nmos row: MnL MnDL MnDR MnR  (diffusion centre yn)
yn = 1.5
np_ = 1.30
xn = [0.80, 0.80 + np_, 0.80 + 2 * np_, 0.80 + 3 * np_]

MnL = acell.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BL", "Q"),  at=(xn[0], yn))
MnDL = acell.mos("nmos", w=Wn, l=L, nf=1, gates="QB", sd=("Q", "VSS"), at=(xn[1], yn))
MnDR = acell.mos("nmos", w=Wn, l=L, nf=1, gates="Q",  sd=("VSS", "QB"), at=(xn[2], yn))
MnR = acell.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("QB", "BLB"), at=(xn[3], yn))

# pmos row: MpL MpR inside one nwell
yp = Hc - 1.5 - Wp
xp = [1.40, 4.20]
nwell = acell.rect("nwell", x0=-0.3, x1=Wc + 0.3,
                   y0=yp - Wp / 2 - 0.3, y1=yp + Wp / 2 + 0.3, net=None)
MpL = acell.mos("pmos", w=Wp, l=L, nf=1, gates="QB", sd=("VDD", "Q"),  at=(xp[0], yp), well=False)
MpR = acell.mos("pmos", w=Wp, l=L, nf=1, gates="Q",  sd=("VDD", "QB"), at=(xp[1], yp), well=False)

# storage node Q : MnL.drain(sd[1])  MnDL.source(sd[0])  MpL.drain(sd[1])
Q = acell.rect(c0,
    x0=min(MnL.sd[1].left, MnDL.sd[0].left, MpL.sd[1].left),
    x1=max(MnL.sd[1].right, MnDL.sd[0].right, MpL.sd[1].right),
    y0=min(MnL.sd[1].bottom, MnDL.sd[0].bottom, MpL.sd[1].bottom),
    y1=max(MnL.sd[1].top, MnDL.sd[0].top, MpL.sd[1].top), net="Q")
for r in (MnL.sd[1], MnDL.sd[0], MpL.sd[1]):
    acell.rect(c0, x0=r.left, y0=r.bottom, x1=r.right, y1=r.top, net="Q")

# storage node QB : MnR.source(sd[0])  MnDR.drain(sd[1])  MpR.drain(sd[1])
QB = acell.rect(c0,
    x0=min(MnR.sd[0].left, MnDR.sd[1].left, MpR.sd[1].left),
    x1=max(MnR.sd[0].right, MnDR.sd[1].right, MpR.sd[1].right),
    y0=min(MnR.sd[0].bottom, MnDR.sd[1].bottom, MpR.sd[1].bottom),
    y1=max(MnR.sd[0].top, MnDR.sd[1].top, MpR.sd[1].top), net="QB")
for r in (MnR.sd[0], MnDR.sd[1], MpR.sd[1]):
    acell.rect(c0, x0=r.left, y0=r.bottom, x1=r.right, y1=r.top, net="QB")

# VSS strap : pulldown drains to VSS rail
for d in (MnDL.sd[1], MnDR.sd[0]):
    acell.rect(c0, x0=d.left, x1=d.right, y0=vss.top - m1w, y1=vss.top, net="VSS")
    acell.via("diff", c0, at=(d.cx, vss.top - m1w / 2), net="VSS", dir="v")

# VDD strap : pmos sources to VDD rail
for s in (MpL.sd[0], MpR.sd[0]):
    acell.rect(c0, x0=s.left, x1=s.right, y0=vdd.bottom, y1=vdd.bottom + m1w, net="VDD")
    acell.via("diff", c0, at=(s.cx, vdd.bottom + m1w / 2), net="VDD", dir="v")

# ---- local m1 stubs that reach up to YCON, where the m2 trunks cross ----
def stub(acell, net, cx, cy_top):
    acell.rect(c0, x0=cx - stubw / 2, x1=cx + stubw / 2,
               y0=cy_top - stubw, y1=cy_top, net=net)

# WL : poly endcap, poly->m1 contact at each access gate, m1 stub up to YCON
for mn in (MnL, MnR):
    g = mn.gates[0]
    acell.rect("poly", x0=g.left, x1=g.right, y0=g.top, y1=g.top + peg, net="WL")
    acell.rect("poly", x0=g.left, x1=g.right, y0=g.bottom - peg, y1=g.bottom, net="WL")
    acell.via("poly", c0, at=(g.cx, g.top + peg / 2), net="WL", dir="v")
    stub(acell, "WL", g.cx, YCON)

# BL : diff->m1 contact on MnL source, m1 stub up to YCON
acell.via("diff", c0, at=(MnL.sd[0].cx, MnL.sd[0].top - cs / 2 - gcs), net="BL", dir="v")
stub(acell, "BL", MnL.sd[0].cx, YCON)

# BLB : diff->m1 contact on MnR source, m1 stub up to YCON
acell.via("diff", c0, at=(MnR.sd[1].cx, MnR.sd[1].top - cs / 2 - gcs), net="BLB", dir="v")
stub(acell, "BLB", MnR.sd[1].cx, YCON)

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

refs = {}
for r in range(ROWS):
    for col in range(COLS):
        conns = {"VDD": "VDD", "VSS": "VSS",
                 "BL": bl_nets[col], "BLB": blb_nets[col],
                 "WL": wl_nets[r]}
        refs[(r, col)] = top.place(acell, at=(col * Wc, r * Hc),
                                   name="XB%d_%d" % (r, col), conns=conns)

# global word lines : m2 horizontal trunks, one per row
for r in range(ROWS):
    y = r * Hc + YCON
    top.rect(c2, x0=0, x1=COLS * Wc, y0=y - m2w / 2, y1=y + m2w / 2, net=wl_nets[r])
    for col in range(COLS):
        ref = refs[(r, col)]
        for mn_name in ("MnL", "MnR"):
            # via1 from the cell's WL m1 stub up to the m2 trunk
            gx = ref.pin("WL").cx  # both access gates share WL; use one via per cell
        top.via(c0, c2, at=(ref.pin("WL").cx, y), net=wl_nets[r], dir="v")

# global bit lines : m2 vertical trunks, one per column per net
for col in range(COLS):
    x_bl  = col * Wc + refs[(0, col)].pin("BL").cx
    x_blb = col * Wc + refs[(0, col)].pin("BLB").cx
    top.rect(c2, x0=x_bl - m2w / 2, x1=x_bl + m2w / 2, y0=0, y1=ROWS * Hc, net=bl_nets[col])
    top.rect(c2, x0=x_blb - m2w / 2, x1=x_blb + m2w / 2, y0=0, y1=ROWS * Hc, net=blb_nets[col])
    for r in range(ROWS):
        ref = refs[(r, col)]
        top.via(c0, c2, at=(x_bl,  r * Hc + YCON), net=bl_nets[col],  dir="v")
        top.via(c0, c2, at=(x_blb, r * Hc + YCON), net=blb_nets[col], dir="v")

# VDD / VSS : continuous m1 rails per row (abutting cells); bring to ports
top.rect(c1, x0=0, x1=COLS * Wc, y0=0, y1=0.3, net="VSS")
top.rect(c1, x0=0, x1=COLS * Wc, y0=ROWS * Hc - 0.3, y1=ROWS * Hc, net="VDD")
for r in range(ROWS):
    for col in range(COLS):
        ref = refs[(r, col)]
        top.via(c0, c1, at=(ref.pin("VSS").cx, 0.15), net="VSS", dir="v")
        top.via(c0, c1, at=(ref.pin("VDD").cx, ROWS * Hc - 0.15), net="VDD", dir="v")

# ports on top
for i in range(COLS):
    xb = i * Wc + refs[(0, i)].pin("BL").cx
    xt = i * Wc + refs[(0, i)].pin("BLB").cx
    top.port("BL%d"  % i, on=top.rect(c2, x0=xb - m2w / 2, x1=xb + m2w / 2,
                                      y0=ROWS * Hc, y1=ROWS * Hc + 0.4, net="BL%d" % i))
    top.port("BLB%d" % i, on=top.rect(c2, x0=xt - m2w / 2, x1=xt + m2w / 2,
                                      y0=ROWS * Hc, y1=ROWS * Hc + 0.4, net="BLB%d" % i))
for r in range(ROWS):
    y = r * Hc + YCON
    top.port("WL%d" % r, on=top.rect(c2, x0=0, x1=0.4,
                                     y0=y - m2w / 2, y1=y + m2w / 2, net="WL%d" % r))
top.port("VDD", on=top.rect(c1, x0=0, x1=0.4, y0=ROWS * Hc - m1w, y1=ROWS * Hc, net="VDD"))
top.port("VSS", on=top.rect(c1, x0=0, x1=0.4, y0=0, y1=m1w, net="VSS"))

TOP = top
