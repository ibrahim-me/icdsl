from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- full adder
fa = Cell("fa")

# NMOS pulldown: gate A, B, CIN (input poly rails)
nA  = fa.mos("nmos", w=0.42, gates="A",  sd=("VSS", "n1"), at=(0, 0))
nB1 = fa.mos("nmos", w=0.42, gates="B",  sd=("n1", "VSS"), right_of=nA, space=0.2)
nA2 = fa.mos("nmos", w=0.42, gates="A",  sd=("VSS", "n2"), right_of=nB1, space=0.2)
nB2 = fa.mos("nmos", w=0.42, gates="B",  sd=("n2", "CB"), right_of=nA2, space=0.2)
nC1 = fa.mos("nmos", w=0.42, gates="CIN",sd=("CB", "n1"), right_of=nB2, space=0.2)
nA3 = fa.mos("nmos", w=0.42, gates="A",  sd=("n3", "VSS"), right_of=nC1, space=0.2)
nB3 = fa.mos("nmos", w=0.42, gates="B",  sd=("VSS", "n3"), right_of=nA3, space=0.2)
nC2 = fa.mos("nmos", w=0.42, gates="CIN",sd=("n3", "VSS"), right_of=nB3, space=0.2)
nC3 = fa.mos("nmos", w=0.42, gates="CIN",sd=("n5", "SB"), right_of=nC2, space=0.2)
nB4 = fa.mos("nmos", w=0.42, gates="B",  sd=("n4", "n5"), right_of=nC3, space=0.2)
nA4 = fa.mos("nmos", w=0.42, gates="A",  sd=("VSS", "n4"), right_of=nB4, space=0.2)
nCB = fa.mos("nmos", w=0.42, gates="CB", sd=("COUT", "VSS"), right_of=nA4, space=0.2)
nSB = fa.mos("nmos", w=0.42, gates="SB", sd=("VSS", "SUM"), right_of=nCB, space=0.2)
nCB2= fa.mos("nmos", w=0.42, gates="CB", sd=("SB", "n3"), at=(nSB.diff.right + 0.6, 0))

# PMOS pullup: gate A, B, CIN (input poly rails)
pitch = nB1.gates[0].left - nA.gates[0].left
pA  = fa.mos("pmos", w=0.84, gates="A",  sd=("VDD", "p1"), at=(nA.gates[0].cx, nA.diff.top + 1.6))
pB1 = fa.mos("pmos", w=0.84, gates="B",  sd=("p1", "VDD"), at=(pA.gates[0].left + pitch, pA.diff.bottom))
pC1 = fa.mos("pmos", w=0.84, gates="CIN",sd=("CB", "p1"), at=(pB1.gates[0].left + pitch, pA.diff.bottom))
pB2 = fa.mos("pmos", w=0.84, gates="B",  sd=("p2", "CB"), at=(pC1.gates[0].left + pitch, pA.diff.bottom))
pA2 = fa.mos("pmos", w=0.84, gates="A",  sd=("VDD", "p2"), at=(pB2.gates[0].left + pitch, pA.diff.bottom))
pA3 = fa.mos("pmos", w=0.84, gates="A",  sd=("p3", "VDD"), at=(pA2.gates[0].left + pitch, pA.diff.bottom))
pB3 = fa.mos("pmos", w=0.84, gates="B",  sd=("VDD", "p3"), at=(pA3.gates[0].left + pitch, pA.diff.bottom))
pC2 = fa.mos("pmos", w=0.84, gates="CIN",sd=("p3", "VDD"), at=(pB3.gates[0].left + pitch, pA.diff.bottom))
pCB = fa.mos("pmos", w=0.84, gates="CB", sd=("SB", "p3"), at=(pC2.gates[0].left + pitch, pA.diff.bottom))
pC3 = fa.mos("pmos", w=0.84, gates="CIN",sd=("p5", "SB"), at=(pCB.gates[0].left + pitch, pA.diff.bottom))
pB4 = fa.mos("pmos", w=0.84, gates="B",  sd=("p4", "p5"), at=(pC3.gates[0].left + pitch, pA.diff.bottom))
pA4 = fa.mos("pmos", w=0.84, gates="A",  sd=("VDD", "p4"), at=(pB4.gates[0].left + pitch, pA.diff.bottom))
pCB2= fa.mos("pmos", w=0.84, gates="CB", sd=("COUT", "VDD"), at=(pA4.gates[0].left + pitch, pA.diff.bottom))
pSB = fa.mos("pmos", w=0.84, gates="SB", sd=("VDD", "SUM"), at=(pCB2.gates[0].left + pitch, pA.diff.bottom))

# input poly rails A, B, CIN through n and p gates
for net, ng, pg in (("A", nA.gates[0], pA.gates[0]),
                    ("B", nB1.gates[0], pB1.gates[0]),
                    ("CIN", nC1.gates[0], pC1.gates[0])):
    y0 = min(ng.bottom, pg.bottom) - 0.1
    y1 = max(ng.top, pg.top) + 0.1
    x0 = min(ng.left, pg.left) - 0.05
    x1 = max(ng.right, pg.right) + 0.05
    fa.rect("poly", x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# internal poly gates CB and SB: connect diffusion node to poly gate
def poly_gate_from_diff(net, diff_shape, gate_mos, gate_index=0):
    g = gate_mos.gates[gate_index]
    # metal1 on the diffusion
    m = fa.rect(c0, x0=diff_shape.left, x1=diff_shape.right,
                y0=diff_shape.bottom, y1=diff_shape.top, net=net)
    # contact diff->c0
    fa.via("diff", c0, at=(m.cx, (m.bottom + m.top) / 2), net=net, dir="h")
    # c0 stub up to poly gate level
    stub = fa.rect(c0, x0=g.left - 0.05, x1=g.right + 0.05,
                   y0=m.top, y1=g.bottom - 0.05, net=net)
    fa.via(c0, "poly", at=(stub.cx, (stub.bottom + stub.top) / 2), net=net, dir="v")
    # poly gate extension over the stub
    fa.rect("poly", x0=stub.left, x1=stub.right, y0=g.bottom, y1=g.top, net=net)

# CB diffusion = nB2.sd[1] (also nC1.sd[0], nCB2.sd[0], pC1.sd[0], pB2.sd[1])
poly_gate_from_diff("CB", nB2.sd[1], nCB)
# SB diffusion = nC3.sd[1] (also nSB.sd[0], pCB.sd[0], pC3.sd[1])
poly_gate_from_diff("SB", nC3.sd[1], nSB)

# VSS rail under NMOS, VDD rail over PMOS
vss = fa.rect(c0, x0=nA.diff.left - 0.2, x1=nCB2.diff.right + 0.2,
              y0=nA.diff.bottom - 1.4, y1=nA.diff.bottom - 0.6, net="VSS")
vdd = fa.rect(c0, x0=pA.diff.left - 0.2, x1=pSB.diff.right + 0.2,
              y0=pA.diff.top + 0.6, y1=pA.diff.top + 1.4, net="VDD")

# strap NMOS sources to VSS rail
for t in (nA, nB1, nA2, nA3, nB3, nC2, nA4, nCB, nSB, nCB2):
    for s in t.sd:
        if s.net == "VSS":
            fa.rect(c0, x0=s.left, x1=s.right, y0=s.top, y1=vss.bottom, net="VSS")
            fa.via("diff", c0, at=(s.cx, (s.top + vss.bottom) / 2), net="VSS", dir="v")
# strap PMOS sources to VDD rail
for t in (pA, pB1, pA2, pA3, pB3, pCB2, pSB, pCB, pC1, pC2, pC3, pB4, pA4):
    for s in t.sd:
        if s.net == "VDD":
            fa.rect(c0, x0=s.left, x1=s.right, y0=s.bottom, y1=vdd.top, net="VDD")
            fa.via("diff", c0, at=(s.cx, (s.bottom + vdd.top) / 2), net="VDD", dir="v")

# taps
ntap = fa.tap("ntap", x0=nA.diff.left - 0.3, y0=vss.bottom - 1.0,
              x1=nCB2.diff.right + 0.3, y1=vss.bottom - 0.4, net="VSS")
ptap = fa.tap("ptap", x0=pA.diff.left - 0.3, y0=vdd.top + 0.4,
              x1=pSB.diff.right + 0.3, y1=vdd.top + 1.0, net="VDD")
fa.rect(p.ntap.well.layer if hasattr(p,'well') else 'nwell',
        x0=min(ntap.well.left, ptap.well.left), x1=max(ntap.well.right, ptap.well.right),
        y0=ntap.well.bottom, y1=ptap.well.top, net="VDD")

# internal metal1 connections
def m1_conn(net, shapes, y):
    xs = [s for s in shapes if s.net == net]
    if not xs:
        return
    x0 = min(s.left for s in xs); x1 = max(s.right for s in xs)
    r = fa.rect(c0, x0=x0 - 0.1, x1=x1 + 0.1, y0=y, y1=y + 0.4, net=net)
    for s in xs:
        fa.rect(c0, x0=s.left, x1=s.right, y0=min(s.bottom, y), y1=max(s.top, y + 0.4), net=net)
        fa.via("diff", c0, at=(s.cx, (min(s.bottom, y) + max(s.top, y + 0.4)) / 2), net=net, dir="v")
    return r

# n1: nA.sd[1], nB1.sd[0], nC1.sd[1]
m1_conn("n1", [nA.sd[1], nB1.sd[0], nC1.sd[1]], nA.diff.top + 0.6)
# n2: nA2.sd[1], nB2.sd[0]
m1_conn("n2", [nA2.sd[1], nB2.sd[0]], nA.diff.top + 1.4)
# n3: nA3.sd[0], nB3.sd[1], nC2.sd[0], nCB2.sd[1]
m1_conn("n3", [nA3.sd[0], nB3.sd[1], nC2.sd[0], nCB2.sd[1]], nA.diff.top + 2.2)
# n4: nB4.sd[0], nA4.sd[1]
m1_conn("n4", [nB4.sd[0], nA4.sd[1]], nA.diff.top + 3.0)
# n5: nC3.sd[0], nB4.sd[1]
m1_conn("n5", [nC3.sd[0], nB4.sd[1]], nA.diff.top + 3.8)
# COUT: nCB.sd[0], pCB2.sd[0]
m1_conn("COUT", [nCB.sd[0], pCB2.sd[0]], pA.diff.bottom - 0.6)
# SUM: nSB.sd[1], pSB.sd[1]
m1_conn("SUM", [nSB.sd[1], pSB.sd[1]], pA.diff.bottom - 1.4)

# p1: pA.sd[1], pB1.sd[0], pC1.sd[1]
m1_conn("p1", [pA.sd[1], pB1.sd[0], pC1.sd[1]], pA.diff.bottom - 2.2)
# p2: pB2.sd[0], pA2.sd[1]
m1_conn("p2", [pB2.sd[0], pA2.sd[1]], pA.diff.bottom - 3.0)
# p3: pA3.sd[0], pB3.sd[1], pC2.sd[0], pCB.sd[1]
m1_conn("p3", [pA3.sd[0], pB3.sd[1], pC2.sd[0], pCB.sd[1]], pA.diff.bottom - 3.8)
# p4: pB4.sd[0], pA4.sd[1]
m1_conn("p4", [pB4.sd[0], pA4.sd[1]], pA.diff.bottom - 4.6)
# p5: pC3.sd[0], pB4.sd[1]
m1_conn("p5", [pC3.sd[0], pB4.sd[1]], pA.diff.bottom - 5.4)

# ports
fa.port("A", on=nA.gates[0], dir="in")
fa.port("B", on=nB1.gates[0], dir="in")
fa.port("CIN", on=nC1.gates[0], dir="in")
fa.port("COUT", on=fa.rect(c0, x0=nCB.sd[0].left, x1=nCB.sd[0].right,
                           y0=nCB.sd[0].bottom, y1=nCB.sd[0].top, net="COUT"), dir="out")
fa.port("SUM", on=fa.rect(c0, x0=nSB.sd[1].left, x1=nSB.sd[1].right,
                          y0=nSB.sd[1].bottom, y1=nSB.sd[1].top, net="SUM"), dir="out")
fa.port("VDD", on=vdd)
fa.port("VSS", on=vss)

fa_w = max(nCB2.diff.right, pSB.diff.right, vdd.right) - min(nA.diff.left, vss.left)
fa_h = max(vdd.top, ptap.well.top) - min(vss.bottom, ntap.well.bottom)

# ---------------------------------------------------------------- top rca8
top = Cell("rca8")
insts = []
x = 0.0
for i in range(8):
    cin = "CIN" if i == 0 else ("COUT" if i == 7 else f"k{i}")
    conns = {"VSS": "VSS", "VDD": "VDD", "A": f"A{i}", "B": f"B{i}",
             "CIN": cin, "COUT": ("COUT" if i == 7 else f"k{i+1}"), "SUM": f"S{i}"}
    insts.append(top.place(fa, at=(x, 0), name=f"U{i}", conns=conns))
    x += fa_w + 0.6

# rails
vss_r = top.rect(c0, x0=0, x1=x, y0=-1.0, y1=-0.2, net="VSS")
vdd_r = top.rect(c0, x0=0, x1=x, y0=fa_h + 0.2, y1=fa_h + 1.0, net="VDD")
for it in insts:
    top.rect(c0, x0=it.pin("VSS").left, x1=it.pin("VSS").right,
             y0=it.pin("VSS").top, y1=vss_r.bottom, net="VSS")
    top.rect(c0, x0=it.pin("VDD").left, x1=it.pin("VDD").right,
             y0=it.pin("VDD").bottom, y1=vdd_r.top, net="VDD")

# input/output pins on m1
for i in range(8):
    it = insts[i]
    top.wire(m1, [it.pin("A"), (it.pin("A").cx, vss_r.bottom - 0.8)], width=0.3, net=f"A{i}")
    top.wire(m1, [it.pin("B"), (it.pin("B").cx, vss_r.bottom - 0.8)], width=0.3, net=f"B{i}")
    top.wire(m1, [it.pin("SUM"), (it.pin("SUM").cx, fa_h + 1.8)], width=0.3, net=f"S{i}")
top.wire(m1, [insts[0].pin("CIN"), (insts[0].pin("CIN").cx, vss_r.bottom - 0.8)], width=0.3, net="CIN")
top.wire(m1, [insts[7].pin("COUT"), (insts[7].pin("COUT").cx, fa_h + 1.8)], width=0.3, net="COUT")

# carry chain k1..k7 on m2
for i in range(7):
    a = insts[i].pin("COUT"); b = insts[i + 1].pin("CIN")
    top.wire(m2, [a, (a.cx, fa_h / 2), (b.cx, fa_h / 2), b], width=0.3, net=f"k{i+1}")

for net in ("VSS", "VDD"):
    top.port(net, on=(vss_r if net == "VSS" else vdd_r))
for i in range(8):
    top.port(f"A{i}", on=top.shapes[-1] if False else None)
# recreate input ports properly
for i in range(8):
    it = insts[i]
    top.port(f"A{i}", on=top.rect(m1, x0=it.pin("A").left - 0.1, x1=it.pin("A").right + 0.1,
                                  y0=vss_r.bottom - 0.8, y1=vss_r.bottom - 0.4, net=f"A{i}"))
    top.port(f"B{i}", on=top.rect(m1, x0=it.pin("B").left - 0.1, x1=it.pin("B").right + 0.1,
                                  y0=vss_r.bottom - 0.8, y1=vss_r.bottom - 0.4, net=f"B{i}"))
    top.port(f"S{i}", on=top.rect(m1, x0=it.pin("SUM").left - 0.1, x1=it.pin("SUM").right + 0.1,
                                  y0=fa_h + 1.4, y1=fa_h + 1.8, net=f"S{i}"))
top.port("CIN", on=top.rect(m1, x0=insts[0].pin("CIN").left - 0.1, x1=insts[0].pin("CIN").right + 0.1,
                            y0=vss_r.bottom - 0.8, y1=vss_r.bottom - 0.4, net="CIN"))
top.port("COUT", on=top.rect(m1, x0=insts[7].pin("COUT").left - 0.1, x1=insts[7].pin("COUT").right + 0.1,
                             y0=fa_h + 1.4, y1=fa_h + 1.8, net="COUT"))

TOP = top
