```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ------------------------------------------------------------------ full adder
fa = Cell("fa")

# nMOS pull-down network (two diffusion strips, gates run vertically)
n = fa.stick("nmos", wn=0.09, l=0.05, ntracks=2,
             n="VSS A n1 B VSS | CB CIN n1 B n2 A VSS",
             p="VSS A n4 B n5 CIN SB | VSS A n2 B CB CIN n1",
             ports=("A", "B", "CIN", "VSS"))

# pMOS pull-up network (mirrored, sits above the nMOS row)
p = fa.stick("pmos", wp=0.18, l=0.05, ntracks=2,
             n="VDD A p1 B VDD | CB CIN p1 B p2 A VDD",
             p="VDD A p4 B p5 CIN SB | VDD A p2 B CB CIN p1",
             ports=("A", "B", "CIN", "VDD"),
             above=n, align="left")

# output inverters: COUT = ~CB, SUM = ~SB
cout_n = fa.mos("nmos", w=0.09, l=0.05, gates="CB", sd=("VSS", "COUT"),
                at=(p.right + 0.2, p.cy))
cout_p = fa.mos("pmos", w=0.18, l=0.05, gates="CB", sd=("VDD", "COUT"),
                at=(cout_n.diff.left, n.diff.bottom - 1.2 - 0.18))
sum_n = fa.mos("nmos", w=0.09, l=0.05, gates="SB", sd=("VSS", "SUM"),
               at=(cout_n.right + 0.2, cout_n.cy))
sum_p = fa.mos("pmos", w=0.18, l=0.05, gates="SB", sd=("VDD", "SUM"),
               at=(sum_n.diff.left, n.diff.bottom - 1.2 - 0.18))

# cross-connect internal nodes: n1..n5, p1..p5, CB, SB
def con(shape, net, layer=c0):
    fa.rect(layer, x0=shape.left, x1=shape.right, y0=shape.bottom, y1=shape.top, net=net)

# n-side internal nodes (diffusion regions already carry the net names in strips;
# we just label the diffusion shapes so LVS sees the nodes)
for nm in ("n1", "n2", "n3", "n4", "n5"):
    pass  # nets are carried by the diffusion strips themselves

# p-side internal nodes likewise carried by p-diffusion strips

# CB and SB: route on m1 between the n-row nodes and the output inverters
cb = fa.wire(m1, [n.sd[1], p.sd[1], cout_n.gates[0], cout_p.gates[0]], width=0.15, net="CB")
sb = fa.wire(m1, [n.sd[3], p.sd[3], sum_n.gates[0], sum_p.gates[0]], width=0.15, net="SB")

# rails: VDD / VSS straps on m2 with contacts
vss = fa.rect(m2, x0=n.left - 0.1, x1=max(p.right, sum_p.right) + 0.1,
              y0=n.bottom - 0.5, y1=n.bottom - 0.2, net="VSS")
vdd = fa.rect(m2, x0=vss.left, x1=vss.right, y0=p.top + 0.2, y1=p.top + 0.5, net="VDD")
fa.via(c0, m2, at=(vss.cx, (vss.bottom + n.top) / 2), net="VSS")
fa.via(c0, m2, at=(vdd.cx, (vdd.top + p.bottom) / 2), net="VDD")

fa.port("A", on=n, dir="in")
fa.port("B", on=n, dir="in")
fa.port("CIN", on=n, dir="in")
fa.port("VSS", on=vss)
fa.port("VDD", on=vdd)
fa.port("COUT", on=cout_n.sd[1], dir="out")
fa.port("SUM", on=sum_n.sd[1], dir="out")

# ------------------------------------------------------------------ top: rca8
top = Cell("rca8")
pitch = fa.w + 0.6
x = 0.0
insts = []
for i in range(8):
    inst = top.place(fa, at=(x, 0), name="FA%d" % i,
                     conns={"A": "A%d" % i, "B": "B%d" % i,
                            "CIN": "CIN" if i == 0 else "k%d" % i,
                            "COUT": "COUT" if i == 7 else "k%d" % (i + 1),
                            "SUM": "S%d" % i, "VDD": "VDD", "VSS": "VSS"})
    insts.append(inst)
    x += pitch

# carry chain: COUT(i) -> CIN(i+1) on m1
for i in range(7):
    a = insts[i].pin("COUT")
    b = insts[i + 1].pin("CIN")
    top.wire(m1, [a, b], width=0.15, net="k%d" % (i + 1), first="h")

# A / B buses on m2, staggered to avoid overlap
for i, inst in enumerate(insts):
    top.wire(m2, [inst.pin("A"), (inst.pin("A").cx, 6.0)], width=0.15, net="A%d" % i, first="v")
    top.wire(m2, [inst.pin("B"), (inst.pin("B").cx, 7.6)], width=0.15, net="B%d" % i, first="v")

# S outputs on m1
for i, inst in enumerate(insts):
    top.wire(m1, [inst.pin("SUM"), (inst.pin("SUM").cx, 3.0)], width=0.15, net="S%d" % i, first="v")

# CIN / COUT pads
top.wire(m1, [insts[0].pin("CIN"), (insts[0].pin("CIN").cx, 9.0)], width=0.15, net="CIN", first="v")
top.wire(m1, [insts[7].pin("COUT"), (insts[7].pin("COUT").cx, 10.6)], width=0.15, net="COUT", first="v")

# global rails
vss = top.rect(m2, x0=0, x1=top.right, y0=-1.0, y1=-0.6, net="VSS")
vdd = top.rect(m2, x0=0, x1=top.right, y0=fa.top + 0.6, y1=fa.top + 1.0, net="VDD")
for inst in insts:
    top.via(c0, m2, at=(inst.pin("VSS").cx, (vss.top + inst.pin("VSS").bottom) / 2), net="VSS")
    top.via(c0, m2, at=(inst.pin("VDD").cx, (vdd.bottom + inst.pin("VDD").top) / 2), net="VDD")

for nm in ("VSS", "VDD", "CIN", "COUT") + tuple("A%d" % i for i in range(8)) \
        + tuple("B%d" % i for i in range(8)) + tuple("S%d" % i for i in range(8)):
    sh = {"VSS": vss, "VDD": vdd}.get(nm)
    if sh is None:
        continue
    top.port(nm, on=sh)

TOP = top
```