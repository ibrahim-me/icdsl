from icdsl.canvas import *
import math

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3
POLY, DIFF, NWELL = "poly", "diff", "nwell"
NAME = tech.d.get("name", "freepdk45")

# ---------------------------------------------------------------- geometry
def t(name):
    return tech.width(name)

def sp(a, b=None, width=None):
    return tech.space(a, b, width=width)

GW = 0.05                      # gate length
NW, PW = 0.09, 0.18            # n / p transistor width
PX, PY = 2.05, 2.05            # cell pitch (x = bit-line direction, y = word-line direction)
COLS, ROWS = 8, 16

DEXT = tech.rule("diff_ext_gate")      # diffusion extends beyond gate
PEXT = tech.rule("poly_endcap")        # poly extends beyond diffusion
GCS  = tech.rule("gate_contact_space") # gate to contact
TDS  = tech.rule("tap_diff_space")     # tap to diffusion
MW   = max(t(c0), 0.30)                # rail width on c0
MSP  = sp(c0)

# ---------------------------------------------------------------- one cell
def sram6t(c, x, y, bl, blb, wl, vdd, vss):
    """One 6T cell with lower-left corner at (x, y)."""
    gy = y + PY * 0.28          # n-diffusion centre line
    gy2 = y + PY * 0.72         # p-diffusion centre line (inside n-well)

    # n-well for the pmos pair
    nw = c.rect(NWELL, x0=x, x1=x + PX, y0=y + PY * 0.55, y1=y + PY * 0.95, net=vdd)
    c.rect(NWELL, x0=x - TDS, x1=x + PX + TDS, y0=y + PY * 0.55 - TDS,
           y1=y + PY * 0.95 + TDS, net=vdd)

    def nmos(drain, gate, source, gx):
        d = c.mos("nmos", w=NW, l=GW, nf=1, gates=gate, sd=(source, drain),
                  at=(gx, gy), gate_ext=(DEXT, DEXT))
        return d

    def pmos(drain, gate, source, gx):
        d = c.mos("pmos", w=PW, l=GW, nf=1, gates=gate, sd=(source, drain),
                  at=(gx, gy2), gate_ext=(DEXT, DEXT), well=False)
        return d

    # left strip : BL - WL - Q - QB - VSS   (access Q, pull-down Q)
    aL = nmos("Q", wl, "BL", x + PX * 0.22)
    pL = nmos("VSS", "QB", "Q", x + PX * 0.22 + GW + sp(POLY) + 2 * DEXT)
    # right strip: BLB - WL - QB - Q - VSS  (access QB, pull-down QB)
    aR = nmos("QB", wl, "BLB", x + PX * 0.78 - (GW + sp(POLY) + 2 * DEXT))
    pR = nmos("VSS", "Q", "QB", x + PX * 0.78)

    # pmos pull-ups in the n-well
    puL = pmos("Q", "QB", vdd, x + PX * 0.22)
    puR = pmos("QB", "Q", vdd, x + PX * 0.78)

    # shared VDD diffusion strap on c0 over both pmos sources
    vdds = c.rect(c0, x0=puL.sd[0].left, x1=puR.sd[0].right,
                  y0=puL.sd[0].bottom, y1=puL.sd[0].top, net=vdd)
    c.rect(c1, x0=vdds.left - MSP, x1=vdds.right + MSP, y0=vdds.bottom - MSP,
           y1=vdds.top + MSP, net=vdd)
    c.via(c0, c1, at=(vdds.cx, vdds.cy), net=vdd, dir="v")

    # shared VSS diffusion strap on c0 over both pull-down drains
    vsss = c.rect(c0, x0=pL.sd[1].left, x1=pR.sd[1].right,
                  y0=pL.sd[1].bottom, y1=pL.sd[1].top, net=vss)
    c.rect(c1, x0=vsss.left - MSP, x1=vsss.right + MSP, y0=vsss.bottom - MSP,
           y1=vsss.top + MSP, net=vss)
    c.via(c0, c1, at=(vsss.cx, vsss.cy), net=vss, dir="v")

    # Q node : left access drain / left pulldown source / left pmos drain
    q = c.rect(c0, x0=min(aL.sd[1].left, pL.sd[0].left, puL.sd[1].left),
               x1=max(aL.sd[1].right, pL.sd[0].right, puL.sd[1].right),
               y0=min(aL.sd[1].bottom, pL.sd[0].bottom, puL.sd[1].bottom),
               y1=max(aL.sd[1].top, pL.sd[0].top, puL.sd[1].top), net="Q")
    # QB node : right access drain / right pulldown source / right pmos drain
    qb = c.rect(c0, x0=min(aR.sd[1].left, pR.sd[0].left, puR.sd[1].left),
                x1=max(aR.sd[1].right, pR.sd[0].right, puR.sd[1].right),
                y0=min(aR.sd[1].bottom, pR.sd[0].bottom, puR.sd[1].bottom),
                y1=max(aR.sd[1].top, pR.sd[0].top, puR.sd[1].top), net="QB")

    # cross-coupled gates : Q -> right pulldown gate, QB -> left pulldown gate
    c.rect(POLY, x0=q.left, x1=q.right, y0=pR.gates[0].bottom, y1=pR.gates[0].top, net="Q")
    c.rect(POLY, x0=qb.left, x1=qb.right, y0=pL.gates[0].bottom, y1=pL.gates[0].top, net="QB")
    c.via(c0, c1, at=(q.cx, q.cy), net="Q", dir="v")
    c.via(c0, c1, at=(qb.cx, qb.cy), net="QB", dir="v")

    # bit-line contacts : access sources
    for dev, net, b in ((aL, "BL", bl), (aR, "BLB", blb)):
        s = dev.sd[0]
        c.rect(c0, x0=s.left, x1=s.right, y0=s.bottom, y1=s.top, net=b)
        c.via(c0, c1, at=(s.cx, s.cy), net=b, dir="v")

    # word line : poly through both access gates, continues to cell edges
    wlpoly = c.rect(POLY, x0=x, x1=x + PX,
                    y0=min(aL.gates[0].bottom, aR.gates[0].bottom),
                    y1=max(aL.gates[0].top, aR.gates[0].top), net=wl)
    c.port(wl, on=wlpoly, dir="inout")
    c.port(bl, on=c.rect(c1, x0=x + PX * 0.22 - MSP, x1=x + PX * 0.22 + MSP,
                         y0=y, y1=y + PY, net=bl), dir="inout")
    c.port(blb, on=c.rect(c1, x0=x + PX * 0.78 - MSP, x1=x + PX * 0.78 + MSP,
                          y0=y, y1=y + PY, net=blb), dir="inout")
    return dict(q=q, qb=qb)

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
pins = ["VSS", "VDD"] + ["BL%d" % i for i in range(8)] + ["BLB%d" % i for i in range(8)] \
     + ["WL%d" % i for i in range(16)]

cells = {}
for r in range(ROWS):
    wl = "WL%d" % r
    for ccol in range(COLS):
        bl = "BL%d" % ccol
        blb = "BLB%d" % ccol
        cells[(r, ccol)] = sram6t(top, ccol * PX, r * PY, bl, blb, wl, "VDD", "VSS")

# global rails : VDD / VSS horizontal m1 lines, one per row
for r in range(ROWS):
    y = r * PY + PY / 2.0
    vdd = top.rect(c1, x0=0, x1=COLS * PX, y0=y - MW / 2, y1=y + MW / 2, net="VDD")
    vss = top.rect(c1, x0=0, x1=COLS * PX, y0=y - MW / 2 - PY * 0.44,
                   y1=y - MW / 2 - PY * 0.44 + MW, net="VSS")
    # strap the rails into every cell
    for ccol in range(COLS):
        x = ccol * PX + PX / 2.0
        top.via(c0, c1, at=(x, vdd.cy), net="VDD", dir="v")
        top.via(c0, c1, at=(x, vss.cy), net="VSS", dir="v")

# global bit lines : vertical m1 lines, one per bit / bit-bar
for ccol in range(COLS):
    x = ccol * PX + PX * 0.22
    top.rect(c1, x0=x - MW / 2, x1=x + MW / 2, y0=0, y1=ROWS * PY, net="BL%d" % ccol)
    xb = ccol * PX + PX * 0.78
    top.rect(c1, x0=xb - MW / 2, x1=xb + MW / 2, y0=0, y1=ROWS * PY, net="BLB%d" % ccol)

# global word lines : horizontal poly lines, one per row (over the access gates)
for r in range(ROWS):
    y = r * PY + PY * 0.28
    top.rect(POLY, x0=0, x1=COLS * PX, y0=y - GW / 2, y1=y + GW / 2, net="WL%d" % r)

# ---------------------------------------------------------------- ports
for name in pins:
    if name.startswith("BL") or name.startswith("BLB"):
        i = int(name[2:])
        x = i * PX + (PX * 0.22 if name.startswith("BL") else PX * 0.78)
        sh = top.rect(c1, x0=x - MW / 2, x1=x + MW / 2, y0=ROWS * PY,
                      y1=ROWS * PY + MW, net=name)
        top.port(name, on=sh, dir="inout")
    elif name.startswith("WL"):
        i = int(name[2:])
        y = i * PY + PY * 0.28
        sh = top.rect(POLY, x0=COLS * PX, x1=COLS * PX + MW, y0=y - GW / 2,
                      y1=y + GW / 2, net=name)
        top.port(name, on=sh, dir="inout")
    else:
        y = ROWS * PY + MW
        sh = top.rect(c1, x0=0, x1=COLS * PX, y0=y, y1=y + MW, net=name)
        top.port(name, on=sh, dir="inout")

TOP = top
