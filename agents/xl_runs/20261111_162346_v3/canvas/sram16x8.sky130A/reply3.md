```
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2

# ------------------------------------------------------------------ cell
A = Cell("sram6t")

# bottom row: four nmos (diffusion along x, gates are vertical poly strips)
n_acc_bl  = A.mos("nmos", w=0.42, nf=1, gates="WL", sd=("BL", "Q"),  at=(0, 0))
n_pd_q    = A.mos("nmos", w=0.42, nf=1, gates="QB", sd=("Q", "VSS"), at=(n_acc_bl.gates[0].right + 0.5, 0))
n_pd_qb   = A.mos("nmos", w=0.42, nf=1, gates="Q",  sd=("VSS", "QB"), at=(n_pd_q.gates[0].right + 0.5, 0))
n_acc_blb = A.mos("nmos", w=0.42, nf=1, gates="WL", sd=("QB", "BLB"), at=(n_pd_qb.gates[0].right + 0.5, 0))

# top row: two pmos pullups in nwell, above the two pulldowns
p_pu_q  = A.mos("pmos", w=0.84, nf=1, gates="QB", sd=("VDD", "Q"),  at=(n_pd_q.gates[0].cx, n_acc_bl.diff.top + 1.5), well=False)
p_pu_qb = A.mos("pmos", w=0.84, nf=1, gates="Q",  sd=("QB", "VDD"), at=(n_pd_qb.gates[0].cx, n_acc_bl.diff.top + 1.5), well=False)

WN = min(tech.width("nwell"), 1.6)
nw = A.rect("nwell",
    x0=min(p_pu_q.diff.left, p_pu_qb.diff.left) - WN,
    x1=max(p_pu_q.diff.right, p_pu_qb.diff.right) + WN,
    y0=min(p_pu_q.diff.bottom, p_pu_qb.diff.bottom) - WN,
    y1=max(p_pu_q.diff.top, p_pu_qb.diff.top) + WN, net="VDD")

# storage node Q: c1 strap joining access drain, pulldown drain, pullup drain
q = A.rect(c1,
    x0=min(n_acc_bl.sd[1].left, n_pd_q.sd[0].left, p_pu_q.sd[1].left),
    x1=max(n_acc_bl.sd[1].right, n_pd_q.sd[0].right, p_pu_q.sd[1].right),
    y0=min(n_acc_bl.sd[1].bottom, n_pd_q.sd[0].bottom, p_pu_q.sd[1].bottom),
    y1=max(n_acc_bl.sd[1].top, n_pd_q.sd[0].top, p_pu_q.sd[1].top), net="Q")
for s in (n_acc_bl.sd[1], n_pd_q.sd[0], p_pu_q.sd[1]):
    A.via(c0, c1, at=(s.cx, s.cy), net="Q")

# storage node QB: c1 strap joining pulldown drain, access source, pullup source
qb = A.rect(c1,
    x0=min(n_pd_qb.sd[1].left, n_acc_blb.sd[0].left, p_pu_qb.sd[0].left),
    x1=max(n_pd_qb.sd[1].right, n_acc_blb.sd[0].right, p_pu_qb.sd[0].right),
    y0=min(n_pd_qb.sd[1].bottom, n_acc_blb.sd[0].bottom, p_pu_qb.sd[0].bottom),
    y1=max(n_pd_qb.sd[1].top, n_acc_blb.sd[0].top, p_pu_qb.sd[0].top), net="QB")
for s in (n_pd_qb.sd[1], n_acc_blb.sd[0], p_pu_qb.sd[0]):
    A.via(c0, c1, at=(s.cx, s.cy), net="QB")

# cross-coupling: QB node -> gates of n_pd_q and p_pu_q ; Q node -> gates of n_pd_qb and p_pu_qb
for g, node in ((n_pd_q.gates[0], qb), (p_pu_q.gates[0], qb),
                (n_pd_qb.gates[0], q), (p_pu_qb.gates[0], q)):
    A.rect("poly", x0=min(g.left, node.left), x1=max(g.right, node.right),
           y0=min(g.bottom, node.bottom), y1=max(g.top, node.top), net=node.net)
    A.via(c0, c1, at=(g.cx, node.cy), net=node.net)

# word line: poly strip over both access gates, extended to cell edges
wl = A.rect("poly", x0=A.bbox.left, x1=A.bbox.right,
            y0=n_acc_bl.gates[0].bottom, y1=n_acc_bl.gates[0].top, net="WL")

# bit lines: metal2 vertical straps over the access source diffusions
bl = A.rect(c2, x0=n_acc_bl.sd[0].cx - 0.55, x1=n_acc_bl.sd[0].cx + 0.55,
            y0=n_acc_bl.diff.bottom - 0.6, y1=n_acc_bl.diff.top + 0.6, net="BL")
A.via(c0, c2, at=(bl.cx, n_acc_bl.sd[0].cy), net="BL")
blb = A.rect(c2, x0=n_acc_blb.sd[1].cx - 0.55, x1=n_acc_blb.sd[1].cx + 0.55,
             y0=n_acc_blb.diff.bottom - 0.6, y1=n_acc_blb.diff.top + 0.6, net="BLB")
A.via(c0, c2, at=(blb.cx, n_acc_blb.sd[1].cy), net="BLB")

# rails: VDD over pmos sources, VSS over pulldown sources
vdd = A.rect(c1,
    x0=min(p_pu_q.sd[0].left, p_pu_qb.sd[1].left),
    x1=max(p_pu_q.sd[0].right, p_pu_qb.sd[1].right),
    y0=min(p_pu_q.sd[0].bottom, p_pu_qb.sd[1].bottom),
    y1=max(p_pu_q.sd[0].top, p_pu_qb.sd[1].top), net="VDD")
vss = A.rect(c1,
    x0=min(n_pd_q.sd[1].left, n_pd_qb.sd[0].left),
    x1=max(n_pd_q.sd[1].right, n_pd_qb.sd[0].right),
    y0=min(n_pd_q.sd[1].bottom, n_pd_qb.sd[0].bottom),
    y1=max(n_pd_q.sd[1].top, n_pd_qb.sd[0].top), net="VSS")
for s in (p_pu_q.sd[0], p_pu_qb.sd[1]):
    A.via(c0, c1, at=(s.cx, s.cy), net="VDD")
for s in (n_pd_q.sd[1], n_pd_qb.sd[0]):
    A.via(c0, c1, at=(s.cx, s.cy), net="VSS")

# nwell tie to VDD: tap diffusion under the VDD rail
tap = A.rect("tap", x0=vdd.left - 0.2, x1=vdd.right + 0.2,
             y0=vdd.bottom - 0.6, y1=vdd.top + 0.6, net="VDD")
A.rect(c0, x0=tap.left, x1=tap.right, y0=vdd.bottom, y1=vdd.top, net="VDD")
A.via(c0, c1, at=(tap.cx, (vdd.bottom + tap.bottom) / 2), net="VDD")

A.port("VDD", on=vdd)
A.port("VSS", on=vss)
A.port("BL", on=bl)
A.port("BLB", on=blb)
A.port("WL", on=wl)
CELL = A

# ------------------------------------------------------------------ array
TOP = Cell("sram16x8")
pitch_x = A.bbox.w + 0.9
pitch_y = A.bbox.h + 0.9
insts = {}
for r in range(16):
    for c in range(8):
        insts[(r, c)] = TOP.place(A, at=(c * pitch_x, r * pitch_y),
                                  name="XB%d_%d" % (r, c),
                                  conns={"VDD": "VDD", "VSS": "VSS",
                                         "BL": "BL%d" % c, "BLB": "BLB%d" % c,
                                         "WL": "WL%d" % r})

BLW = max(tech.width(c2), 0.6)
for c in range(8):
    x = c * pitch_x + insts[(0, c)].pin("BL").cx
    for net, pin in (("BL%d" % c, "BL"), ("BLB%d" % c, "BLB")):
        segs = [insts[(r, c)].pin(pin) for r in range(16)]
        line = TOP.rect(c2, x0=x - BLW / 2, x1=x + BLW / 2,
                        y0=min(s.bottom for s in segs) - 0.4,
                        y1=max(s.top for s in segs) + 0.4, net=net)
        for s in segs:
            TOP.via(c1, c2, at=(line.cx, s.cy), net=net)

for r in range(16):
    y = r * pitch_y + insts[(r, 0)].pin("WL").cy
    segs = [insts[(r, c)].pin("WL") for c in range(8)]
    line = TOP.rect(c2, x0=min(s.left for s in segs) - 0.4,
                    x1=max(s.right for s in segs) + 0.4,
                    y0=y - BLW / 2, y1=y + BLW / 2, net="WL%d" % r)
    for s in segs:
        TOP.via("poly", c2, at=(s.cx, line.cy), net="WL%d" % r)

vdd_segs = [insts[(r, c)].pin("VDD") for r in range(16) for c in range(8)]
vss_segs = [insts[(r, c)].pin("VSS") for r in range(16) for c in range(8)]
TOP.rect(c1, x0=min(s.left for s in vdd_segs) - 0.4,
         x1=max(s.right for s in vdd_segs) + 0.4,
         y0=min(s.bottom for s in vdd_segs) - 0.4,
         y1=max(s.top for s in vdd_segs) + 0.4, net="VDD")
TOP.rect(c1, x0=min(s.left for s in vss_segs) - 0.4,
         x1=max(s.right for s in vss_segs) + 0.4,
         y0=min(s.bottom for s in vss_segs) - 0.4,
         y1=max(s.top for s in vss_segs) + 0.4, net="VSS")

for name in ("VDD", "VSS") + ["BL%d" % i for i in range(8)] + \
              ["BLB%d" % i for i in range(8)] + ["WL%d" % i for i in range(16)]:
    TOP.port(name, dir="inout")

TOP = TOP

```