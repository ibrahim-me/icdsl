```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0          # gf180: m1
m2 = tech.conductor(2)

# ------------------------------------------------------------------ cell
Wn, Wp, L = 0.36, 0.72, 0.28
cs = tech.width("contact")
cp = tech.space("contact")
enc = tech.enc("m1", "contact")
mpad = cs + 2 * enc[1]
mpad = max(mpad, tech.width(c0))
ct = cs + 2 * enc[0]
gs = tech.rule("gate_contact_space")
ps = tech.space("poly")
ds = tech.space("diff")
nwe = tech.enc("nwell", "diff")[0]
nws = tech.space("nwell")

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
    # nwell under pmos columns
    x0 = XG + XA - nwe; x1 = W + nwe
    y0 = -nwe; y1 = H + nwe
    c.rect("nwell", x0=x0, x1=x1, y0=y0, y1=y1, net="VDD")

    def mos(kind, gate, snet, dnet, w, xc):
        m = c.mos(kind, w=w, l=L, nf=1, gates=gate, sd=(snet, dnet), at=(xc, 0))
        return m

    # column x-centres
    xg = XG / 2
    xa = XG + XA / 2
    xp = XG + XA + XP / 2
    xn = XG + XA + XP + XN / 2

    # y-centres of the five horizontal tracks
    ybl = BL / 2
    yblb = BL + ds + BLB / 2
    yqn = yblb + ds + QN / 2
    yqb = yqn + ds + QB / 2
    yg = yqb + ds + mpad + gs + L / 2

    # access transistors (gate = WL)
    ta = mos("nmos", "WL", "BL", "Q", Wn, xa)
    tb = mos("nmos", "WL", "BLB", "QB", Wn, xa)
    # pull-ups (pmos)
    tpq = mos("pmos", "QB", "VDD", "Q", Wp, xp)
    tpqb = mos("pmos", "Q", "VDD", "QB", Wp, xp)
    # pull-downs (nmos)
    tnq = mos("nmos", "QB", "VSS", "Q", Wn, xn)
    tnqb = mos("nmos", "Q", "VSS", "QB", Wn, xn)

    def strap(m, i, xc, yc, net):
        s = c.rect(c0, w=ct, h=ct, center=(xc, yc), net=net)
        c.via(c0, m2, at=(xc, yc), net=net, dir="v")
        return s

    # bit lines (vertical m1 straps at the access source ends)
    strap(ta, 0, xa, ybl, "BL")
    strap(tb, 0, xa, yblb, "BLB")
    # storage nodes: drain straps of the three devices on each side
    strap(ta, 1, xa, yqn, "Q")
    strap(tpq, 1, xp, yqn, "Q")
    strap(tnq, 1, xn, yqn, "Q")
    strap(tb, 1, xa, yqb, "QB")
    strap(tpqb, 1, xp, yqb, "QB")
    strap(tnqb, 1, xn, yqb, "QB")
    # gate straps: Q gate of pmos/nmos QB side, QB gate of pmos/nmos Q side
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
    c.via(c0, m2, at=(W / 2, H - mpad / 2), net="VDD", dir="v")
    c.via(c0, m2, at=(W / 2, mpad / 2), net="VSS", dir="v")

    c.port("BL", on=c.rect(c0, x0=xa - mpad / 2, x1=xa + mpad / 2,
                           y0=ybl - mpad / 2, y1=ybl + mpad / 2, net="BL"), dir="inout")
    c.port("BLB", on=c.rect(c0, x0=xa - mpad / 2, x1=xa + mpad / 2,
                            y0=yblb - mpad / 2, y1=yblb + mpad / 2, net="BLB"), dir="inout")
    c.port("WL", on=c.rect(c0, x0=xg - mpad / 2, x1=xg + mpad / 2,
                           y0=yg - mpad / 2, y1=yg + mpad / 2, net="WL"), dir="in")
    c.port("VDD", on=c.rect(c0, x0=W - mpad, x1=W, y0=H - mpad, y1=H, net="VDD"), dir="inout")
    c.port("VSS", on=c.rect(c0, x0=W - mpad, x1=W, y0=0, y1=mpad, net="VSS"), dir="inout")
    return c

# ------------------------------------------------------------------ top
top = Cell("sram16x8")
cell = cell6t(top, "sram6t")
CW, CH = cell.w, cell.h
PX = CW + 1.2
PY = CH + 1.2

# place 16 rows x 8 columns
for r in range(16):
    for ccol in range(8):
        top.place(cell, at=(ccol * PX, r * PY),
                  name="XB%d_%d" % (r, ccol),
                  conns={"BL": "BL%d" % ccol, "BLB": "BLB%d" % ccol,
                         "WL": "WL%d" % r, "VDD": "VDD", "VSS": "VSS"})

# global metal-2 routing: bit lines vertical, word lines horizontal
BW = tech.width(m2); BS = tech.space(m2)
V = tech.via_size(c0, m2)
vw, vh = V["lower"]
pad = max(vw, vh) / 2 + 0.03

for ccol in range(8):
    x = ccol * PX + CW / 2
    for net, yc in (("BL", 0.25 * CH), ("BLB", 0.75 * CH)):
        seg = top.rect(m2, x0=x - BW / 2, x1=x + BW / 2,
                       y0=0, y1=16 * PY, net=net)
        for r in range(16):
            inst = top.insts["XB%d_%d" % (r, ccol)]
            p = inst.pin(net)
            top.via(c0, m2, at=(p.cx, p.cy), net=net, dir="v")

for r in range(16):
    y = r * PY + CH / 2
    seg = top.rect(m2, x0=0, x1=8 * PX, y0=y - BW / 2, y1=y + BW / 2, net="WL%d" % r)
    for ccol in range(8):
        inst = top.insts["XB%d_%d" % (r, ccol)]
        p = inst.pin("WL")
        top.via(c0, m2, at=(p.cx, p.cy), net="WL%d" % r, dir="v")

# VDD / VSS rails on metal 2
for net, y in (("VDD", 16 * PY - 0.6 * BW), ("VSS", 0.6 * BW)):
    top.rect(m2, x0=0, x1=8 * PX, y0=y - BW / 2, y1=y + BW / 2, net=net)
    for r in range(16):
        for ccol in range(8):
            inst = top.insts["XB%d_%d" % (r, ccol)]
            top.via(c0, m2, at=(inst.pin(net).cx, y), net=net, dir="v")

# ports
for ccol in range(8):
    top.port("BL%d" % ccol, on=top.rect(m2, x0=ccol * PX + CW / 2 - BW / 2,
                                        x1=ccol * PX + CW / 2 + BW / 2,
                                        y0=16 * PY, y1=16 * PY + 3 * BW, net="BL%d" % ccol))
    top.port("BLB%d" % ccol, on=top.rect(m2, x0=ccol * PX + CW / 2 - BW / 2,
                                         x1=ccol * PX + CW / 2 + BW / 2,
                                         y0=-3 * BW, y1=0, net="BLB%d" % ccol))
for r in range(16):
    top.port("WL%d" % r, on=top.rect(m2, x0=8 * PX, x1=8 * PX + 3 * BW,
                                     y0=r * PY + CH / 2 - BW / 2,
                                     y1=r * PY + CH / 2 + BW / 2, net="WL%d" % r))
top.port("VDD", on=top.rect(m2, x0=8 * PX - 3 * BW, x1=8 * PX,
                            y0=16 * PY - BW, y1=16 * PY, net="VDD"))
top.port("VSS", on=top.rect(m2, x0=8 * PX - 3 * BW, x1=8 * PX,
                            y0=0, y1=BW, net="VSS"))

TOP = top
```