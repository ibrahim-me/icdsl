```
from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1   # m1, m2
POLY = "poly"
NWELL = "nwell"

GW = 0.05
NW = 0.09
PW = 0.18
PX, PY = 2.0, 2.0
COLS, ROWS = 8, 16

DEXT = tech.rule("diff_ext_gate")
PSPACE = tech.space(POLY)
TDS = tech.rule("tap_diff_space")
MW = max(tech.width(c0), 0.30)
MSP = tech.space(c0)

def blx(i): return i * PX + PX * 0.28
def blbx(i): return i * PX + PX * 0.72
def wly(r): return r * PY + PY * 0.30

def sram6t(c, x, y, bl, blb, wl, vdd, vss):
    # n-well for pull-ups (top half)
    c.rect(NWELL, x0=x+0.15, x1=x+PX-0.15, y0=y+PY*0.60, y1=y+PY*0.95, net=vdd)
    c.rect(NWELL, x0=x+0.15-TDS, x1=x+PX-0.15+TDS, y0=y+PY*0.60-TDS,
           y1=y+PY*0.95+TDS, net=vdd)

    gy = y + PY * 0.20   # n-diff center (access + pulldown)
    gy2 = y + PY * 0.80  # p-diff center (pullup)

    def nmos(drain, gate, source, gx, gyc):
        return c.mos("nmos", w=NW, l=GW, nf=1, gates=gate, sd=(source, drain),
                     at=(gx, gyc), gate_ext=(DEXT, DEXT))

    def pmos(drain, gate, source, gx, gyc):
        return c.mos("pmos", w=PW, l=GW, nf=1, gates=gate, sd=(source, drain),
                     at=(gx, gyc), gate_ext=(DEXT, DEXT), well=False)

    gxL = blx(0) - x   # left column gate x
    gxR = blbx(0) - x  # right column gate x

    # WL poly horizontal through both access gates
    wlpoly = c.rect(POLY, x0=x, x1=x+PX,
                    y0=gy-GW/2, y1=gy+GW/2, net=wl)

    # Access transistors: gate = WL
    aL = nmos("Q", wl, "BL", gxL, gy)     # source=BL, drain=Q
    aR = nmos("QB", wl, "BLB", gxR, gy)   # source=BLB, drain=QB

    # Pull-downs: gates cross-coupled
    pL = nmos("VSS", "QB", "Q", gxL + GW + PSPACE + 2*DEXT, gy)   # gate=QB
    pR = nmos("VSS", "Q", "QB", gxR - (GW + PSPACE + 2*DEXT), gy) # gate=Q

    # Pull-ups in n-well: sources=VDD, gates cross-coupled
    puL = pmos("Q", "QB", vdd, gxL, gy2)   # drain=Q, gate=QB
    puR = pmos("QB", "Q", vdd, gxR, gy2)   # drain=QB, gate=Q

    # VDD strap over pull-up sources (m1)
    vdds = c.rect(c0, x0=min(puL.sd[0].left, puR.sd[0].left),
                  x1=max(puL.sd[0].right, puR.sd[0].right),
                  y0=min(puL.sd[0].bottom, puR.sd[0].bottom),
                  y1=max(puL.sd[0].top, puR.sd[0].top), net=vdd)
    c.rect(c1, x0=vdds.left-MSP, x1=vdds.right+MSP, y0=vdds.bottom-MSP,
           y1=vdds.top+MSP, net=vdd)
    c.via(c0, c1, at=(vdds.cx, vdds.cy), net=vdd, dir="v")

    # VSS strap over pull-down drains (m1)
    vsss = c.rect(c0, x0=min(pL.sd[1].left, pR.sd[1].left),
                  x1=max(pL.sd[1].right, pR.sd[1].right),
                  y0=min(pL.sd[1].bottom, pR.sd[1].bottom),
                  y1=max(pL.sd[1].top, pR.sd[1].top), net=vss)
    c.rect(c1, x0=vsss.left-MSP, x1=vsss.right+MSP, y0=vsss.bottom-MSP,
           y1=vsss.top+MSP, net=vss)
    c.via(c0, c1, at=(vsss.cx, vsss.cy), net=vss, dir="v")

    # Storage nodes Q (left, at gy) and QB (right, at gy2) on m1
    q = c.rect(c0, x0=min(aL.sd[1].left, pL.sd[0].left, puL.sd[1].left),
               x1=max(aL.sd[1].right, pL.sd[0].right, puL.sd[1].right),
               y0=min(aL.sd[1].bottom, pL.sd[0].bottom, puL.sd[1].bottom),
               y1=max(aL.sd[1].top, pL.sd[0].top, puL.sd[1].top), net="Q")
    qb = c.rect(c0, x0=min(aR.sd[1].left, pR.sd[0].left, puR.sd[1].left),
                x1=max(aR.sd[1].right, pR.sd[0].right, puR.sd[1].right),
                y0=min(aR.sd[1].bottom, pR.sd[0].bottom, puR.sd[1].bottom),
                y1=max(aR.sd[1].top, pR.sd[0].top, puR.sd[1].top), net="QB")

    # Cross-coupling Q -> right gates (pR at gy, puR at gy2): m1 at gy then jog up
    c.rect(c1, x0=q.right, x1=pR.gates[0].right, y0=gy-MW/2, y1=gy+MW/2, net="Q")
    c.via(c0, c1, at=(q.cx, gy), net="Q", dir="v")
    c.via("poly", c1, at=(pR.gates[0].cx, gy), net="Q", dir="v")
    c.rect(c1, x0=pR.gates[0].right-MW/2, x1=pR.gates[0].right+MW/2,
           y0=gy-MW/2, y1=gy2+MW/2, net="Q")
    c.rect(c1, x0=pR.gates[0].right-MW/2, x1=pR.gates[0].right+MW/2,
           y0=gy2-MW/2, y1=gy2+MW/2, net="Q")
    c.via("poly", c1, at=(puR.gates[0].cx, gy2), net="Q", dir="v")

    # Cross-coupling QB -> left gates (puL at gy2, pL at gy): m1 at gy2 then jog down
    c.rect(c1, x0=puL.gates[0].left, x1=qb.left, y0=gy2-MW/2, y1=gy2+MW/2, net="QB")
    c.via(c0, c1, at=(qb.cx, gy2), net="QB", dir="v")
    c.via("poly", c1, at=(puL.gates[0].cx, gy2), net="QB", dir="v")
    c.rect(c1, x0=puL.gates[0].left-MW/2, x1=puL.gates[0].left+MW/2,
           y0=gy-MW/2, y1=gy2+MW/2, net="QB")
    c.rect(c1, x0=pL.gates[0].left-MW/2, x1=pL.gates[0].left+MW/2,
           y0=gy-MW/2, y1=gy+MW/2, net="QB")
    c.via("poly", c1, at=(pL.gates[0].cx, gy), net="QB", dir="v")

    # Bit-line contacts on access sources (m1 over c0)
    for dev, net, bx in ((aL, "BL", gxL), (aR, "BLB", gxR)):
        s = dev.sd[0]
        c.rect(c0, x0=s.left, x1=s.right, y0=s.bottom, y1=s.top, net=net)
        c.via(c0, c1, at=(bx, s.cy), net=net, dir="v")

    # BL/BLB ports on m1 spanning cell height
    c.port(bl, on=c.rect(c1, x0=gxL-MSP, x1=gxL+MSP, y0=y, y1=y+PY, net=bl), dir="inout")
    c.port(blb, on=c.rect(c1, x0=gxR-MSP, x1=gxR+MSP, y0=y, y1=y+PY, net=blb), dir="inout")

top = Cell("sram16x8")
for r in range(ROWS):
    wl = "WL%d" % r
    for cc in range(COLS):
        sram6t(top, cc*PX, r*PY, "BL%d"%cc, "BLB%d"%cc, wl, "VDD", "VSS")

# Global rails (m2 horizontal)
for r in range(ROWS):
    y = r*PY + PY/2.0
    top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW/2, y1=y+MW/2, net="VDD")
    top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW/2-PY*0.42, y1=y-MW/2-PY*0.42+MW, net="VSS")
    for cc in range(COLS):
        x = cc*PX + PX/2.0
        top.via(c0, c1, at=(x, y), net="VDD", dir="v")
        top.via(c0, c1, at=(x, y-PY*0.42), net="VSS", dir="v")

# Global bit lines (m2 vertical)
for cc in range(COLS):
    top.rect(c1, x0=blx(cc)-MW/2, x1=blx(cc)+MW/2, y0=0, y1=ROWS*PY, net="BL%d"%cc)
    top.rect(c1, x0=blbx(cc)-MW/2, x1=blbx(cc)+MW/2, y0=0, y1=ROWS*PY, net="BLB%d"%cc)

# Global word lines: m2 horizontal over each row, vias to cell WL polys, port on m2 at right edge
for r in range(ROWS):
    wl = "WL%d" % r
    y = wly(r)
    top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW/2, y1=y+MW/2, net=wl)
    for cc in range(COLS):
        x = cc*PX + PX/2.0
        top.via(c0, c1, at=(x, y), net=wl, dir="v")
    sh = top.rect(c1, x0=COLS*PX, x1=COLS*PX+MW, y0=y-MW/2, y1=y+MW/2, net=wl)
    top.port(wl, on=sh, dir="inout")

# Ports for BL/BLB at top edge (m2)
for cc in range(COLS):
    x = blx(cc)
    sh = top.rect(c1, x0=x-MW/2, x1=x+MW/2, y0=ROWS*PY, y1=ROWS*PY+MW, net="BL%d"%cc)
    top.port("BL%d"%cc, on=sh, dir="inout")
    xb = blbx(cc)
    sh = top.rect(c1, x0=xb-MW/2, x1=xb+MW/2, y0=ROWS*PY, y1=ROWS*PY+MW, net="BLB%d"%cc)
    top.port("BLB%d"%cc, on=sh, dir="inout")

# VDD/VSS ports at top (m2)
y = ROWS*PY + MW
sh = top.rect(c1, x0=0, x1=COLS*PX, y0=y, y1=y+MW, net="VDD")
top.port("VDD", on=sh, dir="inout")
sh = top.rect(c1, x0=0, x1=COLS*PX, y0=y-MW-PY*0.42, y1=y-PY*0.42, net="VSS")
top.port("VSS", on=sh, dir="inout")

TOP = top



```