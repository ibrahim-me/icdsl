from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0          # gf180: m1
m2 = tech.conductor(2)
m3 = tech.conductor(3)

# ------------------------------------------------------------------ cell
Wn, Wp, L = 0.36, 0.72, 0.28
cs = tech.width("contact")
enc = tech.enc("m1", "contact")
mpad = cs + 2 * enc[1]
mpad = max(mpad, tech.width(c0))
ct = cs + 2 * enc[0]
gs = tech.rule("gate_contact_space")
ds = tech.space("diff")
nwe = tech.enc("nwell", "diff")[0]

XG = 2.6 * mpad + 2 * gs + L          # gate column pitch
XA = 2.0 * mpad + 2 * gs + L          # access column pitch
XP = 2.0 * mpad + 2 * gs + L          # pmos column pitch
XN = 2.0 * mpad + 2 * gs + L          # nmos column pitch
W = XG + XA + XP + XN

BL = mpad + 2 * enc[1]
BLB = mpad + 2 * enc[1]
QN = mpad + 2 * enc[1]
QB = mpad + 2 * enc[1]
PITCH_Y = max(BL, BLB, QN, QB) + 2 * ds + 2 * mpad + 2 * gs + L
H = PITCH_Y

def cell6t(c, name):
    c = Cell(name)
    xg = XG / 2
    xa = XG + XA / 2
    xp = XG + XA + XP / 2
    xn = XG + XA + XP + XN / 2

    ybl = BL / 2
    yblb = BL + ds + BLB / 2
    yqn = yblb + ds + QN / 2
    yqb = yqn + ds + QB / 2
    yg = yqb + ds + mpad + gs + L / 2

    # nwell under pmos columns (pmos well drawn by mos too; same-layer overlap is fine)
    c.rect("nwell", x0=XG + XA - nwe, x1=W + nwe, y0=-nwe, y1=H + nwe, net="VDD")

    def mos(kind, gate, snet, dnet, w, xc):
        return c.mos(kind, w=w, l=L, nf=1, gates=gate, sd=(snet, dnet), at=(xc, 0))

    ta = mos("nmos", "WL", "BL", "Q", Wn, xa)     # access: gate WL, source BL, drain Q
    tb = mos("nmos", "WL", "BLB", "QB", Wn, xa)   # access: gate WL, source BLB, drain QB
    tpq  = mos("pmos", "QB", "VDD", "Q", Wp, xp)  # pull-up
    tpqb = mos("pmos", "Q",  "VDD", "QB", Wp, xp) # pull-up
    tnq  = mos("nmos", "QB", "VSS", "Q", Wn, xn)  # pull-down
    tnqb = mos("nmos", "Q",  "VSS", "QB", Wn, xn) # pull-down

    def strap(m, i, xc, yc, net):
        s = c.rect(c0, w=ct, h=ct, cx=xc, cy=yc, net=net)
        c.via(c0, m2, at=(xc, yc), net=net, dir="v")
        return s

    # bit-line straps on m1 at the access source ends
    strap(ta, 0, xa, ybl, "BL")
    strap(tb, 0, xa, yblb, "BLB")
    # storage-node straps (drains of the three devices on each side)
    strap(ta, 1, xa, yqn, "Q")
    strap(tpq, 1, xp, yqn, "Q")
    strap(tnq, 1, xn, yqn, "Q")
    strap(tb, 1, xa, yqb, "QB")
    strap(tpqb, 1, xp, yqb, "QB")
    strap(tnqb, 1, xn, yqb, "QB")
    # gate straps: QB side gates -> net Q ; Q side gates -> net QB
    strap(tpqb, 0, xp, yg, "Q")
    strap(tnqb, 0, xn, yg, "Q")
    strap(tpq, 0, xp, yg, "QB")
    strap(tnq, 0, xn, yg, "QB")
    # WL gate strap at the gate column
    strap(ta, 0, xg, yg, "WL")
    strap(tb, 0, xg, yg, "WL")

    # supply rails (m1, full cell width)
    c.rect(c0, x0=0, x1=W, y0=H - mpad, y1=H, net="VDD")
    c.rect(c0, x0=0, x1=W, y0=0, y1=mpad, net="VSS")

    c.port("BL", on=c.rect(c0, x0=xa - mpad / 2, x1=xa + mpad / 2,
                           y0=ybl - mpad / 2, y1=ybl + mpad / 2, net="BL"))
    c.port("BLB", on=c.rect(c0, x0=xa - mpad / 2, x1=xa + mpad / 2,
                            y0=yblb - mpad / 2, y1=yblb + mpad / 2, net="BLB"))
    c.port("WL", on=c.rect(c0, x0=xg - mpad / 2, x1=xg + mpad / 2,
                           y0=yg - mpad / 2, y1=yg + mpad / 2, net="WL"))
    c.port("VDD", on=c.rect(c0, x0=W - mpad, x1=W, y0=H - mpad, y1=H, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=W - mpad, x1=W, y0=0, y1=mpad, net="VSS"))
    return c

# ------------------------------------------------------------------ top
top = Cell("sram16x8")
cell = cell6t(top, "sram6t")
CW, CH = cell.w, cell.h
PX = CW + 1.2
PY = CH + 1.2

insts = {}
for r in range(16):
    for ccol in range(8):
        insts[(r, ccol)] = top.place(cell, at=(ccol * PX, r * PY),
                                     name="XB%d_%d" % (r, ccol),
                                     conns={"BL": "BL%d" % ccol, "BLB": "BLB%d" % ccol,
                                            "WL": "WL%d" % r, "VDD": "VDD", "VSS": "VSS"})

BW2 = tech.width(m2)
BW3 = tech.width(m3)

# ---- word lines: m2 horizontal per row, via m1->m2 at the WL gate strap
for r in range(16):
    y = r * PY + (PITCH_Y - (PITCH_Y - (QB + ds + mpad + gs + L / 2)))  # yg absolute
    # yg relative = yqb + ds + mpad + gs + L/2 ; compute directly:
    yg_rel = (BL + ds + BLB / 2) + ds + QB / 2 + ds + QB / 2 + ds + mpad + gs + L / 2
    y = r * PY + yg_rel
    top.rect(m2, x0=0, x1=8 * PX, y0=y - BW2 / 2, y1=y + BW2 / 2, net="WL%d" % r)
    for ccol in range(8):
        p = insts[(r, ccol)].pin("WL")
        top.via(c0, m2, at=(p.cx, p.cy), net="WL%d" % r, dir="v")

# ---- bit lines: m3 vertical per column, via stack m1->m2->m3 at the BL/BLB strap
for ccol in range(8):
    x = ccol * PX + (XG + XA / 2)
    for net, yrel in (("BL", BL / 2), ("BLB", BL + ds + BLB / 2)):
        top.rect(m3, x0=x - BW3 / 2, x1=x + BW3 / 2, y0=0, y1=16 * PY, net=net)
        for r in range(16):
            p = insts[(r, ccol)].pin(net)
            top.via(c0, m3, at=(p.cx, p.cy), net=net, dir="v")

# ---- power: per-row m2 VDD/VSS rails + vertical bus at right edge
VBB = 1.2   # vertical bus width
for r in range(16):
    base = r * PY
    # VDD rail at cell top strap, VSS rail at cell bottom strap
    yvdd = base + H - mpad / 2
    yvss = base + mpad / 2
    top.rect(m2, x0=0, x1=8 * PX, y0=yvdd - BW2 / 2, y1=yvdd + BW2 / 2, net="VDD")
    top.rect(m2, x0=0, x1=8 * PX, y0=yvss - BW2 / 2, y1=yvss + BW2 / 2, net="VSS")
    for ccol in range(8):
        top.via(c0, m2, at=(insts[(r, ccol)].pin("VDD").cx, yvdd), net="VDD", dir="v")
        top.via(c0, m2, at=(insts[(r, ccol)].pin("VSS").cx, yvss), net="VSS", dir="v")

# vertical buses tying all rows together at the right edge
busx0 = 8 * PX
busx1 = busx0 + VBB
top.rect(m2, x0=busx0, x1=busx1, y0=0, y1=16 * PY, net="VDD")
top.rect(m2, x0=busx0, x1=busx1, y0=0, y1=16 * PY, net="VSS")  # will be replaced by separate buses
# redo: two separate buses side by side
top.rect(m2, x0=busx0, x1=busx0 + VBB / 2, y0=0, y1=16 * PY, net="VDD")
top.rect(m2, x0=busx0 + VBB / 2, x1=busx1, y0=0, y1=16 * PY, net="VSS")
for r in range(16):
    base = r * PY
    yvdd = base + H - mpad / 2
    yvss = base + mpad / 2
    top.via(c0, m2, at=(busx0 + VBB / 4, yvdd), net="VDD", dir="v")
    top.via(c0, m2, at=(busx0 + 3 * VBB / 4, yvss), net="VSS", dir="v")

# ---- ports
for ccol in range(8):
    x = ccol * PX + (XG + XA / 2)
    top.port("BL%d" % ccol, on=top.rect(m3, x0=x - BW3 / 2, x1=x + BW3 / 2,
                                        y0=16 * PY, y1=16 * PY + 4 * BW3, net="BL%d" % ccol))
    top.port("BLB%d" % ccol, on=top.rect(m3, x0=x - BW3 / 2, x1=x + BW3 / 2,
                                         y0=-4 * BW3, y1=0, net="BLB%d" % ccol))
for r in range(16):
    yg_rel = (BL + ds + BLB / 2) + ds + QB / 2 + ds + QB / 2 + ds + mpad + gs + L / 2
    y = r * PY + yg_rel
    top.port("WL%d" % r, on=top.rect(m2, x0=8 * PX, x1=8 * PX + 4 * BW2,
                                     y0=y - BW2 / 2, y1=y + BW2 / 2, net="WL%d" % r))
top.port("VDD", on=top.rect(m2, x0=busx0, x1=busx1, y0=16 * PY - BW2, y1=16 * PY, net="VDD"))
top.port("VSS", on=top.rect(m2, x0=busx0, x1=busx1, y0=0, y1=BW2, net="VSS"))

TOP = top

