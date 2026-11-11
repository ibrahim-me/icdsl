from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
WN = min(tech.width("nwell"), 1.6)

# ------------------------------------------------------------------ 6T cell
A = Cell("sram6t")
n = A.mos("nmos", w=0.42, nf=1, gates="WL", sd=("BL", "Q"), at=(0, 0),
          gate_ext=(0.0, 0.0))
p = A.mos("pmos", w=0.84, nf=1, gates="Q", sd=("VDD", "Q"),
          at=(0, n.diff.top + 1.0), well=False)
A.rect("nwell", x0=p.diff.left - WN, y0=p.diff.bottom - WN,
       x1=p.diff.right + WN, y1=p.diff.top + WN, net="VDD")

ndn = A.mos("nmos", w=0.42, nf=1, gates="QB", sd=("Q", "VSS"),
            at=(n.gates[0].right + 0.6, 0), gate_ext=(0.0, 0.0))
pup = A.mos("pmos", w=0.84, nf=1, gates="Q", sd=("Q", "VDD"),
            at=(ndn.gates[0].right + 0.6, n.diff.top + 1.0), well=False)
A.rect("nwell", x0=pup.diff.left - WN, y0=pup.diff.bottom - WN,
       x1=pup.diff.right + WN, y1=pup.diff.top + WN, net="VDD")

q = A.rect(c1, x0=min(n.sd[1].left, ndn.sd[0].left, pup.sd[0].left),
           x1=max(n.sd[1].right, ndn.sd[0].right, pup.sd[0].right),
           y0=min(n.sd[1].bottom, ndn.sd[0].bottom, pup.sd[0].bottom),
           y1=max(n.sd[1].top, ndn.sd[0].top, pup.sd[0].top), net="Q")
qb = A.rect(c1, x0=min(ndn.sd[1].left, n.sd[1].left),
            x1=max(ndn.sd[1].right, n.sd[1].right),
            y0=min(ndn.sd[1].bottom, n.sd[1].bottom),
            y1=max(ndn.sd[1].top, n.sd[1].top), net="QB")
A.via(c0, c1, at=(q.cx, q.cy), net="Q")
A.via(c0, c1, at=(qb.cx, qb.cy), net="QB")

A.rect("poly", x0=ndn.gates[0].left, x1=qb.right, y0=ndn.gates[0].bottom,
       y1=ndn.gates[0].top, net="QB")
A.rect("poly", x0=pup.gates[0].left, x1=q.right, y0=pup.gates[0].bottom,
       y1=pup.gates[0].top, net="Q")

bl = A.rect(c2, x0=n.sd[0].cx - 0.55, y0=n.diff.bottom - 0.6,
            x1=n.sd[0].cx + 0.55, y1=pup.diff.top + 0.6, net="BL")
A.via(c1, c2, at=(bl.cx, n.sd[0].cy), net="BL")
A.rect(c1, x0=bl.left, x1=bl.right, y0=n.sd[0].bottom, y1=n.sd[0].top, net="BL")

blb = A.rect(c2, x0=ndn.sd[1].cx - 0.55, y0=ndn.diff.bottom - 0.6,
             x1=ndn.sd[1].cx + 0.55, y1=pup.diff.top + 0.6, net="BLB")
A.via(c1, c2, at=(blb.cx, ndn.sd[1].cy), net="BLB")
A.rect(c1, x0=blb.left, x1=blb.right, y0=ndn.sd[1].bottom, y1=ndn.sd[1].top, net="BLB")

wl = A.rect("poly", x0=A.bbox.left, x1=A.bbox.right,
            y0=n.gates[0].bottom, y1=n.gates[0].top, net="WL")

vdd = A.rect(c1, x0=p.sd[0].left, x1=pup.sd[1].right,
             y0=p.sd[0].bottom, y1=pup.sd[1].top, net="VDD")
vss = A.rect(c1, x0=ndn.sd[1].left, x1=ndn.sd[1].right,
             y0=ndn.sd[1].bottom, y1=ndn.sd[1].top, net="VSS")
A.rect(c0, x0=p.sd[0].left, x1=pup.sd[1].right, y0=vdd.bottom, y1=vdd.top, net="VDD")
A.via(c0, c1, at=(vdd.cx, vdd.cy), net="VDD")
A.via(c0, c1, at=(vss.cx, vss.cy), net="VSS")

tap = A.rect("tap", x0=vdd.left - 0.2, y0=vdd.bottom - 0.6,
             x1=vdd.right + 0.2, y1=vdd.top + 0.6, net="VDD")
A.rect(c0, x0=tap.left, x1=tap.right, y0=vdd.bottom, y1=vdd.top, net="VDD")
A.via(c0, c1, at=(tap.cx, (vdd.bottom + tap.bottom) / 2), net="VDD")

A.port("VDD", on=vdd)
A.port("VSS", on=vss)
A.port("BL", on=bl)
A.port("BLB", on=blb)
A.port("WL", on=wl)

# ------------------------------------------------------------------ array
TOP = Cell("sram16x8")
pitch_x = A.bbox.w + 0.9
pitch_y = A.bbox.h + 0.9
insts = {}
for r in range(16):
    for c in range(8):
        insts[(r, c)] = TOP.place(
            A, at=(c * pitch_x, r * pitch_y), name="XB%d_%d" % (r, c),
            conns={"VDD": "VDD", "VSS": "VSS",
                   "BL": "BL%d" % c, "BLB": "BLB%d" % c,
                   "WL": "WL%d" % r})

BLW = max(tech.width(c2), 0.6)
for c in range(8):
    x = c * pitch_x + insts[(0, c)].pin("BL").cx
    segs = [insts[(r, c)].pin("BL") for r in range(16)]
    line = TOP.rect(c2, x0=x - BLW / 2, x1=x + BLW / 2,
                    y0=min(s.bottom for s in segs) - 0.4,
                    y1=max(s.top for s in segs) + 0.4, net="BL%d" % c)
    for s in segs:
        TOP.via(c1, c2, at=(line.cx, s.cy), net="BL%d" % c)
    segs = [insts[(r, c)].pin("BLB") for r in range(16)]
    line = TOP.rect(c2, x0=x - BLW / 2, x1=x + BLW / 2,
                    y0=min(s.bottom for s in segs) - 0.4,
                    y1=max(s.top for s in segs) + 0.4, net="BLB%d" % c)
    for s in segs:
        TOP.via(c1, c2, at=(line.cx, s.cy), net="BLB%d" % c)

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
