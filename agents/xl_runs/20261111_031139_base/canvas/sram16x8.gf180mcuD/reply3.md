```
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # gf180: m1
m2 = tech.conductor(2)
m3 = tech.conductor(3)

# ---------------------------------------------------------------- design rules
cs   = tech.width("contact")
enc  = tech.enc("m1", "contact")
mpad = cs + 2 * enc[1]          # m1 pad around a contact
mpad = max(mpad, tech.width(c0))
ct   = cs + 2 * enc[0]          # contact cut size
gs   = tech.rule("gate_contact_space")
ds   = tech.space("diff")
ps   = tech.space("poly")
nwe  = tech.enc("nwell", "diff")[0]
nws  = tech.space("nwell")
ms1  = tech.space(m2)
ms2  = tech.space(m3)
vw, vh = tech.via_size(c0, m2)["lower"]

# ---------------------------------------------------------------- cell pitch
Wn, Wp, L = 0.36, 0.72, 0.28

# column x-centres
xg = 2.6 * mpad + 2 * gs + L          # gate column (WL strap)
xa = XA = 2.0 * mpad + 2 * gs + L     # access column (BL/BLB straps)
xp = XP = 2.0 * mpad + 2 * gs + L     # pmos column
xn = XN = 2.0 * mpad + 2 * gs + L     # nmos column
W  = xg + xa + xp + xn

# row y-centres
ybl  = mpad + 2 * enc[1]
yblb = ybl + ds + (mpad + 2 * enc[1])
yqn  = yblb + ds + (mpad + 2 * enc[1])
yqb  = yqn  + ds + (mpad + 2 * enc[1])
yg   = yqb  + ds + mpad + gs + L / 2
PITCH_Y = yg + mpad + gs + L / 2 + ds + mpad
H = PITCH_Y

PX = W + 1.6
PY = H + 1.6

# ---------------------------------------------------------------- 6T cell
def cell6t(c, name):
    c = Cell(name)

    def strap(xc, yc, net):
        s = c.rect(c0, w=ct, h=ct, cx=xc, cy=yc, net=net)
        c.via(c0, m2, at=(xc, yc), net=net, dir="v")
        return s

    # nwell under pmos column
    c.rect("nwell", x0=xg + xa - nwe, x1=W + nwe, y0=-nwe, y1=H + nwe, net="VDD")

    # transistors (diffusion vertical, gate = horizontal poly strip)
    ta = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BL", "Q"),  at=(xa, 0))
    tb = c.mos("nmos", w=Wn, l=L, nf=1, gates="WL", sd=("BLB", "QB"),at=(xa, 0))
    tpq  = c.mos("pmos", w=Wp, l=L, nf=1, gates="QB", sd=("VDD", "Q"), at=(xp, 0))
    tpqb = c.mos("pmos", w=Wp, l=L, nf=1, gates="Q",  sd=("VDD", "QB"),at=(xp, 0))
    tnq  = c.mos("nmos", w=Wn, l=L, nf=1, gates="QB", sd=("VSS", "Q"), at=(xn, 0))
    tnqb = c.mos("nmos", w=Wn, l=L, nf=1, gates="Q",  sd=("VSS", "QB"), at=(xn, 0))

    # move access transistors so their gates sit in the gate column
    for m in (ta, tb):
        dx = xg - m.gates[0].cx
        for g in m.gates: c.rect("poly", x0=g.left+dx, x1=g.right+dx,
                                 y0=g.bottom, y1=g.top, net=m.gates_net)
        m.diff = c.rect("diff", x0=m.diff.left+dx, x1=m.diff.right+dx,
                        y0=m.diff.bottom, y1=m.diff.top)
        for s in m.sd:
            s2 = c.rect(c0, x0=s.left+dx, x1=s.right+dx, y0=s.bottom, y1=s.top, net=s.net)
            c.via(c0, m2, at=(s.cx+dx, s.cy), net=s.net, dir="v")

    # bit-line straps at access source ends
    strap(xa, ybl,  "BL")
    strap(xa, yblb, "BLB")

    # storage-node straps (drains of the three devices on each side)
    strap(xa, yqn, "Q"); strap(xp, yqn, "Q"); strap(xn, yqn, "Q")
    strap(xa, yqb, "QB"); strap(xp, yqb, "QB"); strap(xn, yqb, "QB")

    # gate straps: QB-side gates -> net Q ; Q-side gates -> net QB
    strap(xp, yg, "Q");  strap(xn, yg, "Q")
    strap(xp, yg, "QB"); strap(xn, yg, "QB")

    # WL gate strap at the gate column
    strap(xg, yg, "WL")

    # supply rails (m1, full cell width)
    c.rect(c0, x0=0, x1=W, y0=H-mpad, y1=H,   net="VDD")
    c.rect(c0, x0=0, x1=W, y0=0,   y1=mpad,   net="VSS")
    c.via(c0, m2, at=(W/2, H-mpad/2), net="VDD", dir="v")
    c.via(c0, m2, at=(W/2, mpad/2),   net="VSS", dir="v")

    # ports
    c.port("BL",  on=c.rect(c0, x0=xa-mpad/2, x1=xa+mpad/2,
                            y0=ybl-mpad/2, y1=ybl+mpad/2, net="BL"))
    c.port("BLB", on=c.rect(c0, x0=xa-mpad/2, x1=xa+mpad/2,
                            y0=yblb-mpad/2, y1=yblb+mpad/2, net="BLB"))
    c.port("WL",  on=c.rect(c0, x0=xg-mpad/2, x1=xg+mpad/2,
                            y0=yg-mpad/2, y1=yg+mpad/2, net="WL"))
    c.port("VDD", on=c.rect(c0, x0=W-mpad, x1=W, y0=H-mpad, y1=H, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=W-mpad, x1=W, y0=0,   y1=mpad, net="VSS"))
    return c

# ---------------------------------------------------------------- top
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

# y position of WL strap inside a cell (relative)
yg_rel = yg

# ------------------------------------------------- word lines: m2 horizontal
BW2 = tech.width(m2)
for r in range(16):
    y = r*PY + yg_rel
    top.rect(m2, x0=0, x1=8*PX, y0=y-BW2/2, y1=y+BW2/2, net="WL%d" % r)
    for cc in range(8):
        p = insts[(r, cc)].pin("WL")
        top.via(c0, m2, at=(p.cx, p.cy), net="WL%d" % r, dir="v")

# ------------------------------------------------- bit lines: m3 vertical
BW3 = tech.width(m3)
for cc in range(8):
    x = cc*PX + xa
    for net, yrel in (("BL", ybl), ("BLB", yblb)):
        top.rect(m3, x0=x-BW3/2, x1=x+BW3/2, y0=0, y1=16*PY, net=net)
        for r in range(16):
            p = insts[(r, cc)].pin(net)
            top.via(c0, m3, at=(p.cx, p.cy), net=net, dir="v")

# ------------------------------------------------- power: per-row m2 rails + vertical m2 buses
for r in range(16):
    base = r*PY
    yvdd = base + H - mpad/2
    yvss = base + mpad/2
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
    top.via(c0, m2, at=(busx0+VB/4, base+H-mpad/2), net="VDD", dir="v")
    top.via(c0, m2, at=(busx0+3*VB/4, base+mpad/2),   net="VSS", dir="v")

# ------------------------------------------------- ports
for cc in range(8):
    x = cc*PX + xa
    top.port("BL%d" % cc, on=top.rect(m3, x0=x-BW3/2, x1=x+BW3/2,
                                      y0=16*PY, y1=16*PY+4*BW3, net="BL%d" % cc))
    top.port("BLB%d" % cc, on=top.rect(m3, x0=x-BW3/2, x1=x+BW3/2,
                                       y0=-4*BW3, y1=0, net="BLB%d" % cc))
for r in range(16):
    y = r*PY + yg_rel
    top.port("WL%d" % r, on=top.rect(m2, x0=8*PX, x1=8*PX+4*BW2,
                                     y0=y-BW2/2, y1=y+BW2/2, net="WL%d" % r))
top.port("VDD", on=top.rect(m2, x0=busx0, x1=busx0+VB, y0=16*PY-BW2, y1=16*PY, net="VDD"))
top.port("VSS", on=top.rect(m2, x0=busx0, x1=busx0+VB, y0=0, y1=BW2, net="VSS"))

TOP = top
```