from icdsl.canvas import *
from collections import defaultdict

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ================================================================== full adder
fa = Cell("fa")

tp = 0.32   # transistor x-pitch
rp = 1.05   # row y-pitch
nw = 0.09
pw = 0.18
gl = 0.05

nmos_list = [
    ("A", "VSS", "n1"), ("B", "n1", "VSS"), ("CIN", "CB", "n1"),
    ("B", "n2", "CB"), ("A", "VSS", "n2"), ("A", "n3", "VSS"),
    ("B", "VSS", "n3"), ("CIN", "n3", "VSS"), ("CB", "SB", "n3"),
    ("CIN", "n5", "SB"), ("B", "n4", "n5"), ("A", "VSS", "n4"),
    ("CB", "COUT", "VSS"), ("SB", "VSS", "SUM"),
]

pmos_list = [
    ("A", "VDD", "p1"), ("B", "p1", "VDD"), ("CIN", "CB", "p1"),
    ("B", "p2", "CB"), ("A", "VDD", "p2"), ("A", "p3", "VDD"),
    ("B", "VDD", "p3"), ("CIN", "p3", "VDD"), ("CB", "SB", "p3"),
    ("CIN", "p5", "SB"), ("B", "p4", "p5"), ("A", "VDD", "p4"),
    ("CB", "COUT", "VDD"), ("SB", "VDD", "SUM"),
]

nmos_devs = []
for i, (g, s, d) in enumerate(nmos_list):
    m = fa.mos("nmos", w=nw, l=gl, gates=g, sd=(s, d),
               at=(i * tp, 0))
    nmos_devs.append(m)

pmos_devs = []
for i, (g, s, d) in enumerate(pmos_list):
    m = fa.mos("pmos", w=pw, l=gl, gates=g, sd=(s, d),
               at=(i * tp, rp))
    pmos_devs.append(m)

all_devs = nmos_devs + pmos_devs

fa_left = min(m.diff.left for m in all_devs) - 0.25
fa_right = max(m.diff.right for m in all_devs) + 0.25
fa_bottom = min(m.diff.bottom for m in all_devs) - 0.25
fa_top = max(m.diff.top for m in all_devs) + 0.25

net_gates = defaultdict(list)
net_sd = defaultdict(list)
for m in all_devs:
    net_gates[m.gates[0].net].append(m.gates[0])
    net_sd[m.sd[0].net].append(m.sd[0])
    net_sd[m.sd[1].net].append(m.sd[1])

# Contacts from poly gates to m1
for net, gates in net_gates.items():
    for g in gates:
        fa.via("poly", c0, at=(g.cx, g.cy), net=net)

# Route internal nets on m1
for net in ("n1", "n2", "n3", "n4", "n5", "p1", "p2", "p3", "p4", "p5", "CB", "SB"):
    straps = net_sd.get(net, [])
    if len(straps) >= 2:
        fa.wire(m1, straps, width=0.15, net=net, first="h")

# Power rails on m2
rail_h = 0.35
vss = fa.rect(m2, x0=fa_left, x1=fa_right,
              y0=fa_bottom - rail_h, y1=fa_bottom - 0.05, net="VSS")
vdd = fa.rect(m2, x0=fa_left, x1=fa_right,
              y0=fa_top + 0.05, y1=fa_top + rail_h, net="VDD")

for m in all_devs:
    for strap in (m.sd[0], m.sd[1]):
        if strap.net == "VSS":
            fa.via(c0, m2, at=(strap.cx, (vss.top + strap.top) / 2), net="VSS")
        elif strap.net == "VDD":
            fa.via(c0, m2, at=(strap.cx, (vdd.bottom + strap.bottom) / 2), net="VDD")

# Port pads on m1
port_y0 = fa_bottom - rail_h - 0.55
port_h = 0.3
port_spacing = 0.5

a_port = fa.rect(m1, x0=fa_left - 0.35, x1=fa_left, y0=port_y0, y1=port_y0 + port_h, net="A")
b_port = fa.rect(m1, x0=fa_left - 0.35, x1=fa_left, y0=port_y0 + port_spacing, y1=port_y0 + port_spacing + port_h, net="B")
cin_port = fa.rect(m1, x0=fa_left - 0.35, x1=fa_left, y0=port_y0 + 2 * port_spacing, y1=port_y0 + 2 * port_spacing + port_h, net="CIN")
cout_port = fa.rect(m1, x0=fa_right, x1=fa_right + 0.35, y0=port_y0, y1=port_y0 + port_h, net="COUT")
sum_port = fa.rect(m1, x0=fa_right, x1=fa_right + 0.35, y0=port_y0 + port_spacing, y1=port_y0 + port_spacing + port_h, net="SUM")

# Route inputs to gates
fa.wire(m1, [a_port] + net_gates["A"], width=0.15, net="A", first="h")
fa.wire(m1, [b_port] + net_gates["B"], width=0.15, net="B", first="h")
fa.wire(m1, [cin_port] + net_gates["CIN"], width=0.15, net="CIN", first="h")

# Route outputs from drains
fa.wire(m1, net_sd["COUT"] + [cout_port], width=0.15, net="COUT", first="h")
fa.wire(m1, net_sd["SUM"] + [sum_port], width=0.15, net="SUM", first="h")

fa.port("A", on=a_port)
fa.port("B", on=b_port)
fa.port("CIN", on=cin_port)
fa.port("VSS", on=vss)
fa.port("VDD", on=vdd)
fa.port("COUT", on=cout_port)
fa.port("SUM", on=sum_port)

fa.width = fa_right - fa_left + 0.7
fa.height = fa_top - fa_bottom + rail_h * 2 + 1.6

# ================================================================== top: rca8
top = Cell("rca8")

pitch = fa.width + 0.3
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

# Carry chain on m1
for i in range(7):
    top.wire(m1, [insts[i].pin("COUT"), insts[i + 1].pin("CIN")],
             width=0.15, net="k%d" % (i + 1), first="h")

# Global rails on m2
vss = top.rect(m2, x0=0, x1=top.right, y0=-0.85, y1=-0.5, net="VSS")
vdd = top.rect(m2, x0=0, x1=top.right, y0=fa.top + 0.5, y1=fa.top + 0.85, net="VDD")
for inst in insts:
    top.via(c0, m2, at=(inst.pin("VSS").cx, (vss.top + inst.pin("VSS").bottom) / 2), net="VSS")
    top.via(c0, m2, at=(inst.pin("VDD").cx, (vdd.bottom + inst.pin("VDD").top) / 2), net="VDD")

top.port("VSS", on=vss)
top.port("VDD", on=vdd)

# A, B buses on m2
for i, inst in enumerate(insts):
    top.wire(m2, [inst.pin("A"), (inst.pin("A").cx, 6.2)], width=0.15, net="A%d" % i, first="v")
    top.wire(m2, [inst.pin("B"), (inst.pin("B").cx, 7.9)], width=0.15, net="B%d" % i, first="v")

# S outputs on m1
for i, inst in enumerate(insts):
    top.wire(m1, [inst.pin("SUM"), (inst.pin("SUM").cx, 3.2)], width=0.15, net="S%d" % i, first="v")

# CIN / COUT pads
cin_pad = top.rect(m1, x0=insts[0].pin("CIN").left, x1=insts[0].pin("CIN").right,
                   y0=9.6, y1=9.9, net="CIN")
cout_pad = top.rect(m1, x0=insts[7].pin("COUT").left, x1=insts[7].pin("COUT").right,
                    y0=11.3, y1=11.6, net="COUT")
top.wire(m1, [insts[0].pin("CIN"), cin_pad], width=0.15, net="CIN", first="v")
top.wire(m1, [insts[7].pin("COUT"), cout_pad], width=0.15, net="COUT", first="v")

top.port("CIN", on=cin_pad)
top.port("COUT", on=cout_pad)

for i in range(8):
    ap = top.rect(m2, x0=insts[i].pin("A").left, x1=insts[i].pin("A").right,
                  y0=6.2, y1=6.5, net="A%d" % i)
    bp = top.rect(m2, x0=insts[i].pin("B").left, x1=insts[i].pin("B").right,
                  y0=7.9, y1=8.2, net="B%d" % i)
    top.port("A%d" % i, on=ap)
    top.port("B%d" % i, on=bp)

for i in range(8):
    sp = top.rect(m1, x0=insts[i].pin("SUM").left, x1=insts[i].pin("SUM").right,
                  y0=3.2, y1=3.5, net="S%d" % i)
    top.port("S%d" % i, on=sp)

TOP = top
