```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
m2 = tech.conductor(2)
m3 = tech.conductor(3)

# ---- design rules (gf180mcuD)
cs   = tech.width("contact")           # 0.22
enc  = tech.enc("diff", "contact")     # (0.07, 0.07)
gs   = tech.rule("gate_contact_space") # 0.15
ds   = tech.space("diff")              # 0.28
nwe  = tech.enc("nwell", "diff")[0]    # 0.43
mw2  = tech.width(m2)                  # 0.28
mw3  = tech.width(m3)                  # 0.28
ms2  = tech.space(m2)                  # 0.28
ms3  = tech.space(m3)                  # 0.28

cpad = cs + 2 * 0.07                   # m1 pad around contact
cpad = max(cpad, mw2, mw3)

Wn, Wp, L = 0.36, 0.72, 0.28
PX, PY = 5.4, 5.8

def cell6t(c, name):
    c = Cell(name)
    W, H = PX, PY

    # nwell for PMOS (top half)
    c.rect("nwell", x0=-nwe, x1=W+nwe, y0=H*0.60-nwe, y1=H+nwe, net="VDD")

    # ---- transistor x positions
    xa_l, xq, xa_r = 1.1, 2.5, 3.9
    xqb = xq + 1.4

    # ---- transistor y positions
    y_pu, y_acc, y_pd = 4.9, 2.9, 1.2

    # ---- Left side: Q node
    ta  = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BL",  "Q"), at=(xa_l, y_acc))
    tnq = c.mos("nmos", w=Wn, l=L, nf=1, gates="QB",sd=("VSS", "Q"), at=(xq,   y_pd))
    tpq = c.mos("pmos",w=Wp, l=L, nf=1, gates="QB",sd=("VDD", "Q"), at=(xq,   y_pu))

    # ---- Right side: QB node
    tb   = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BLB","QB"), at=(xa_r, y_acc))
    tnqb = c.mos("nmos", w=Wn, l=L, nf=1, gates="Q", sd=("VSS","QB"), at=(xqb, y_pd))
    tpqb = c.mos("pmos",w=Wp, l=L, nf=1, gates="Q", sd=("VDD","QB"), at=(xqb, y_pu))

    # ---- Q node strap: connect access drain, pd drain, pu drain
    qpts = [ta.sd[1].cx, tnq.sd[1].cx, tpq.sd[1].cx]
    qy0  = min(ta.sd[1].bottom, tnq.sd[1].bottom, tpq.sd[1].bottom)
    qy1  = max(ta.sd[1].top,    tnq.sd[1].top,    tpq.sd[1].top)
    c.rect(c0, x0=min(qpts)-cpad/2, x1=max(qpts)+cpad/2, y0=qy0, y1=qy1, net="Q")
    for s in (ta.sd[1], tnq.sd[1], tpq.sd[1]):
        c.via(c0, m2, at=(s.cx, s.cy), net="Q", dir="v")

    # ---- QB node strap
    qbpts = [tb.sd[1].cx, tnqb.sd[1].cx, tpqb.sd[1].cx]
    qby0  = min(tb.sd[1].bottom, tnqb.sd[1].bottom, tpqb.sd[1].bottom)
    qby1  = max(tb.sd[1].top,    tnqb.sd[1].top,    tpqb.sd[1].top)
    c.rect(c0, x0=min(qbpts)-cpad/2, x1=max(qbpts)+cpad/2, y0=qby0, y1=qby1, net="QB")
    for s in (tb.sd[1], tnqb.sd[1], tpqb.sd[1]):
        c.via(c0, m2, at=(s.cx, s.cy), net="QB", dir="v")

    # ---- Gate straps: QB-side gates -> net Q ; Q-side gates -> net QB
    gq  = c.rect("poly", x0=tnq.gates[0].left-0.1, x1=tpq.gates[0].right+0.1,
                 y0=tnq.gates[0].bottom, y1=tnq.gates[0].top, net="Q")
    gqb = c.rect("poly", x0=tnqb.gates[0].left-0.1, x1=tpqb.gates[0].right+0.1,
                 y0=tnqb.gates[0].bottom, y1=tnqb.gates[0].top, net="QB")
    c.via(c0, m2, at=(gq.cx, gq.cy), net="Q", dir="v")
    c.via(c0, m2, at=(gqb.cx, gqb.cy), net="QB", dir="v")

    # ---- WL gate strap (access gates)
    gwl = c.rect("poly", x0=ta.gates[0].left-0.1, x1=tb.gates[0].right+0.1,
                 y0=ta.gates[0].bottom, y1=ta.gates[0].top, net="WL")
    c.via(c0, m2, at=(gwl.cx, gwl.cy), net="WL", dir="v")

    # ---- source straps: BL, BLB, VSS, VDD
    for s, net in ((ta.sd[0], "BL"), (tb.sd[0], "BLB")):
        c.rect(c0, x0=s.left-cpad/2, x1=s.right+cpad/2, y0=s.bottom, y1=s.top, net=net)
        c.via(c0, m2, at=(s.cx, s.cy), net=net, dir="v")
    for s, net in ((tnq.sd[0], "VSS"), (tnqb.sd[0], "VSS"),
                   (tpq.sd[0], "VDD"), (tpqb.sd[0], "VDD")):
        c.rect(c0, x0=s.left-cpad/2, x1=s.right+cpad/2, y0=s.bottom, y1=s.top, net=net)
        c.via(c0, m2, at=(s.cx, s.cy), net=net, dir="v")

    # ---- supply rails (m1, full cell width)
    c.rect(c0, x0=0, x1=W, y0=H-cpad, y1=H, net="VDD")
    c.rect(c0, x0=0, x1=W, y0=0, y1=cpad, net="VSS")
    c.via(c0, m2, at=(W/2, H-cpad/2), net="VDD", dir="v")
    c.via(c0, m2, at=(W/2, cpad/2),   net="VSS", dir="v")

    # ---- ports
    c.port("BL",  on=c.rect(c0, x0=xa_l-cpad/2, x1=xa_l+cpad/2,
                            y0=y_acc-cpad/2, y1=y_acc+cpad/2, net="BL"))
    c.port("BLB", on=c.rect(c0, x0=xa_r-cpad/2, x1=xa_r+cpad/2,
                            y0=y_acc-cpad/2, y1=y_acc+cpad/2, net="BLB"))
    c.port("WL",  on=c.rect(c0, x0=gwl.cx-cpad/2, x1=gwl.cx+cpad/2,
                            y0=gwl.cy-cpad/2, y1=gwl.cy+cpad/2, net="WL"))
    c.port("VDD", on=c.rect(c0, x0=W-cpad, x1=W, y0=H-cpad, y1=H, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=W-cpad, x1=W, y0=0, y1=cpad, net="VSS"))
    return c

# ================================================================== top
top = Cell("sram16x8")
cell = cell6t(top, "sram6t")
CW, CH = cell.w, cell.h

insts = {}
for r in range(16):
    for cc in range(8):
        insts[(r, cc)] = top.place(cell, at=(cc*PX, r*PY),
                                   name="XB%d_%d" % (r, cc),
                                   conns={"BL": "BL%d" % cc, "BLB": "BLB%d" % cc,
                                          "WL": "WL%d" % r, "VDD": "VDD", "VSS": "VSS"})

# ---- word lines: m2 horizontal per row
BW2 = mw2
for r in range(16):
    y = r*PY + 2.9
    top.rect(m2, x0=0, x1=8*PX, y0=y-BW2/2, y1=y+BW2/2, net="WL%d" % r)
    for cc in range(8):
        p = insts[(r, cc)].pin("WL")
        top.via(c0, m2, at=(p.cx, p.cy), net="WL%d" % r, dir="v")

# ---- bit lines: m3 vertical per column
BW3 = mw3
for cc in range(8):
    x = cc*PX + 1.1
    for net, yrel in (("BL", 2.9), ("BLB", 2.9)):
        top.rect(m3, x0=x-BW3/2, x1=x+BW3/2, y0=0, y1=16*PY, net=net)
        for r in range(16):
            p = insts[(r, cc)].pin(net)
            top.via(c0, m3, at=(p.cx, p.cy), net=net, dir="v")

# ---- power: per-row m2 rails + vertical m2 buses
for r in range(16):
    base = r*PY
    yvdd = base + CH - cpad/2
    yvss = base + cpad/2
    top.rect(m2, x0=0, x1=8*PX, y0=yvdd-BW2/2, y1=yvdd+BW2/2, net="VDD")
    top.rect(m2, x0=0, x1=8*PX, y0=yvss-BW2/2, y1=yvss+BW2/2, net="VSS")
    for cc in range(8):
        top.via(c0, m2, at=(insts[(r, cc)].pin("VDD").cx, yvdd), net="VDD", dir="v")
        top.via(c0, m2, at=(insts[(r, cc)].pin("VSS").cx, yvss), net="VSS", dir="v")

VB = 2.4
busx0 = 8*PX
top.rect(m2, x0=busx0, x1=busx0+VB/2, y0=0, y1=16*PY, net="VDD")
top.rect(m2, x0=busx0+VB/2, x1=busx0+VB, y0=0, y1=16*PY, net="VSS")
for r in range(16):
    base = r*PY
    top.via(c0, m2, at=(busx0+VB/4, base+CH-cpad/2), net="VDD", dir="v")
    top.via(c0, m2, at=(busx0+3*VB/4, base+cpad/2),   net="VSS", dir="v")

# ---- ports
for cc in range(8):
    x = cc*PX + 1.1
    top.port("BL%d" % cc, on=top.rect(m3, x0=x-BW3/2, x1=x+BW3/2,
                                      y0=16*PY, y1=16*PY+4*BW3, net="BL%d" % cc))
    top.port("BLB%d" % cc, on=top.rect(m3, x0=x-BW3/2, x1=x+BW3/2,
                                       y0=-4*BW3, y1=0, net="BLB%d" % cc))
for r in range(16):
    y = r*PY + 2.9
    top.port("WL%d" % r, on=top.rect(m2, x0=8*PX, x1=8*PX+4*BW2,
                                     y0=y-BW2/2, y1=y+BW2/2, net="WL%d" % r))
top.port("VDD", on=top.rect(m2, x0=busx0, x1=busx0+VB, y0=16*PY-BW2, y1=16*PY, net="VDD"))
top.port("VSS", on=top.rect(m2, x0=busx0, x1=busx0+VB, y0=0, y1=BW2, net="VSS"))

TOP = top
```