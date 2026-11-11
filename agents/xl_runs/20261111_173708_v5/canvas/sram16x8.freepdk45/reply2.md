```
from icdsl.canvas import *
import math

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
POLY, DIFF, NWELL = "poly", "diff", "nwell"
NAME = tech.d.get("name", "freepdk45")

def t(name):
    return tech.width(name)

def sp(a, b=None, width=None):
    return tech.space(a, b, width=width)

GW = 0.05
NW, PW = 0.09, 0.18
PX, PY = 2.05, 2.15
COLS, ROWS = 8, 16

DEXT = tech.rule("diff_ext_gate")
PEXT = tech.rule("poly_endcap")
GCS  = tech.rule("gate_contact_space")
TDS  = tech.rule("tap_diff_space")
MW   = max(t(c0), 0.30)
MSP  = sp(c0)
VIA  = t("contact")

def blx(i):   return i * PX + PX * 0.22
def blbx(i):  return i * PX + PX * 0.78
def wly(r):   return r * PY + PY * 0.50

def sram6t(c, x, y, bl, blb, wl, vdd, vss):
    gy = y + PY * 0.22          # n-diff centre
    gy2 = y + PY * 0.78         # p-diff centre
    nw = c.rect(NWELL, x0=x+0.15, x1=x+PX-0.15, y0=y+PY*0.55, y1=y+PY*0.92, net=vdd)
    c.rect(NWELL, x0=x+0.15-TDS, x1=x+PX-0.15+TDS, y0=y+PY*0.55-TDS,
           y1=y+PY*0.92+TDS, net=vdd)

    def nmos(drain, gate, source, gx, gyc):
        return c.mos("nmos", w=NW, l=GW, nf=1, gates=gate, sd=(source, drain),
                     at=(gx, gyc), gate_ext=(DEXT, DEXT))

    def pmos(drain, gate, source, gx, gyc):
        return c.mos("pmos", w=PW, l=GW, nf=1, gates=gate, sd=(source, drain),
                     at=(gx, gyc), gate_ext=(DEXT, DEXT), well=False)

    # access transistors: channel vertical, gate = WL (horizontal poly)
    aL = nmos("Q", wl, "BL", blx(0)-x, gy)          # source=BL, drain=Q
    aR = nmos("QB", wl, "BLB", blbx(0)-x, gy)       # source=BLB, drain=QB
    # pull-downs
    pL = nmos("VSS", "QB", "Q", blx(0)-x + GW + sp(POLY) + 2*DEXT, gy)   # gate=QB
    pR = nmos("VSS", "Q", "QB", blbx(0)-x - (GW + sp(POLY) + 2*DEXT), gy) # gate=Q
    # pull-ups in n-well
    puL = pmos("Q", "QB", vdd, blx(0)-x, gy2)       # source=VDD, drain=Q, gate=QB
    puR = pmos("QB", "Q", vdd, blbx(0)-x, gy2)      # source=VDD, drain=QB, gate=Q

    # shared VDD strap over pull-up sources
    vdds = c.rect(c0, x0=min(puL.sd[0].left, puR.sd[0].left),
                  x1=max(puL.sd[0].right, puR.sd[0].right),
                  y0=min(puL.sd[0].bottom, puR.sd[0].bottom),
                  y1=max(puL.sd[0].top, puR.sd[0].top), net=vdd)
    c.rect(c1, x0=vdds.left-MSP, x1=vdds.right+MSP, y0=vdds.bottom-MSP,
           y1=vdds.top+MSP, net=vdd)
    c.via(c0, c1, at=(vdds.cx, vdds.cy), net=vdd, dir="v")

    # shared VSS strap over pull-down drains
    vsss = c.rect(c0, x0=min(pL.sd[1].left, pR.sd[1].left),
                  x1=max(pL.sd[1].right, pR.sd[1].right),
                  y0=min(pL.sd[1].bottom, pR.sd[1].bottom),
                  y1=max(pL.sd[1].top, pR.sd[1].top), net=vss)
    c.rect(c1, x0=vsss.left-MSP, x1=vsss.right+MSP, y0=vsss.bottom-MSP,
           y1=vsss.top+MSP, net=vss)
    c.via(c0, c1, at=(vsss.cx, vsss.cy), net=vss, dir="v")

    # storage nodes
    q = c.rect(c0, x0=min(aL.sd[1].left, pL.sd[0].left, puL.sd[1].left),
               x1=max(aL.sd[1].right, pL.sd[0].right, puL.sd[1].right),
               y0=min(aL.sd[1].bottom, pL.sd[0].bottom, puL.sd[1].bottom),
               y1=max(aL.sd[1].top, pL.sd[0].top, puL.sd[1].top), net="Q")
    qb = c.rect(c0, x0=min(aR.sd[1].left, pR.sd[0].left, puR.sd[1].left),
                x1=max(aR.sd[1].right, pR.sd[0].right, puR.sd[1].right),
                y0=min(aR.sd[1].bottom, pR.sd[0].bottom, puR.sd[1].bottom),
                y1=max(aR.sd[1].top, pR.sd[0].top, puR.sd[1].top), net="QB")

    # cross-coupling on m1: Q -> pR gate (right), QB -> pL gate (left), two heights
    yq = gy + 0.30
    yqb = gy - 0.30
    rq = c.rect(c1, x0=q.right, x1=pR.gates[0].right, y0=yq-MW/2, y1=yq+MW/2, net="Q")
    c.via(c0, c1, at=(q.cx, yq), net="Q", dir="v")
    c.via(c0, c1, at=(pR.gates[0].cx, yq), net="Q", dir="v")
    rqb = c.rect(c1, x0=pL.gates[0].left, x1=qb.left, y0=yqb-MW/2, y1=yqb+MW/2, net="QB")
    c.via(c0, c1, at=(qb.cx, yqb), net="QB", dir="v")
    c.via(c0, c1, at=(pL.gates[0].cx, yqb), net="QB", dir="v")

    # bit-line contacts on access sources
    for dev, net, bx in ((aL, "BL", blx(0)-x), (aR, "BLB", blbx(0)-x)):
        s = dev.sd[0]
        c.rect(c0, x0=s.left, x1=s.right, y0=s.bottom, y1=s.top, net=net)
        c.via(c0, c1, at=(bx, s.cy), net=net, dir="v")

    # word line: horizontal poly through both access gates, spans cell
    wlpoly = c.rect(POLY, x0=x, x1=x+PX,
                    y0=min(aL.gates[0].bottom, aR.gates[0].bottom),
                    y1=max(aL.gates[0].top, aR.gates[0].top), net=wl)
    c.port(wl, on=wlpoly, dir="inout")
    c.port(bl, on=c.rect(c1, x0=blx(0)-x-MSP, x1=blx(0)-x+MSP, y0=y, y1=y+PY, net=bl), dir="inout")
    c.port(blb, on=c.rect(c1, x0=blbx(0)-x-MSP, x1=blbx(0)-x+MSP, y0=y, y1=y+PY, net=blb), dir="inout")

top = Cell("sram16x8")
cells = {}
for r in range(ROWS):
    wl = "WL%d" % r
    for cc in range(COLS):
        cells[(r, cc)] = sram6t(top, cc*PX, r*PY, "BL%d"%cc, "BLB%d"%cc, wl, "VDD", "VSS")

# global rails
for r in range(ROWS):
    y = r*PY + PY/2.0
    top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW/2, y1=y+MW/2, net="VDD")
    top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW/2-PY*0.42, y1=y-MW/2-PY*0.42+MW, net="VSS")
    for cc in range(COLS):
        x = cc*PX + PX/2.0
        top.via(c0, c1, at=(x, y), net="VDD", dir="v")
        top.via(c0, c1, at=(x, y-PY*0.42), net="VSS", dir="v")

# global bit lines (vertical m1)
for cc in range(COLS):
    top.rect(c1, x0=blx(cc)-MW/2, x1=blx(cc)+MW/2, y0=0, y1=ROWS*PY, net="BL%d"%cc)
    top.rect(c1, x0=blbx(cc)-MW/2, x1=blbx(cc)+MW/2, y0=0, y1=ROWS*PY, net="BLB%d"%cc)

# global word lines (horizontal poly)
for r in range(ROWS):
    y = wly(r)
    top.rect(POLY, x0=0, x1=COLS*PX, y0=y-GW/2, y1=y+GW/2, net="WL%d"%r)

# ports
for name in ["VSS","VDD"]+["BL%d"%i for i in range(8)]+["BLB%d"%i for i in range(8)]+["WL%d"%i for i in range(16)]:
    if name.startswith("BL") and not name.startswith("BLB"):
        i = int(name[2:]); x = blx(i)
        sh = top.rect(c1, x0=x-MW/2, x1=x+MW/2, y0=ROWS*PY, y1=ROWS*PY+MW, net=name)
        top.port(name, on=sh, dir="inout")
    elif name.startswith("BLB"):
        i = int(name[3:]); x = blbx(i)
        sh = top.rect(c1, x0=x-MW/2, x1=x+MW/2, y0=ROWS*PY, y1=ROWS*PY+MW, net=name)
        top.port(name, on=sh, dir="inout")
    elif name.startswith("WL"):
        i = int(name[2:]); y = wly(i)
        sh = top.rect(POLY, x0=COLS*PX, x1=COLS*PX+MW, y0=y-GW/2, y1=y+GW/2, net=name)
        top.port(name, on=sh, dir="inout")
    else:
        y = ROWS*PY + MW
        sh = top.rect(c1, x0=0, x1=COLS*PX, y0=y, y1=y+MW, net=name)
        top.port(name, on=sh, dir="inout")

TOP = top

```