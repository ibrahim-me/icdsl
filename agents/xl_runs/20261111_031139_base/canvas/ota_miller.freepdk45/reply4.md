```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
m2 = tech.metal(2)

c = Cell("ota_miller")

GROUPS = [
    ("nmos", 4.0, 0.5, 2, "INN",  ("d1", "tail")),
    ("nmos", 4.0, 0.5, 2, "INP",  ("d2", "tail")),
    ("nmos", 2.0, 1.0, 4, "IB",   ("tail", "VSS")),
    ("nmos", 2.0, 1.0, 2, "IB",   ("IB", "VSS")),
    ("nmos", 2.0, 0.5, 1, "VDD",  ("x", "d2")),
    ("nmos", 4.0, 1.0, 8, "OUT",  ("x", "x")),
    ("nmos", 2.0, 1.0, 8, "IB",   ("OUT", "VSS")),
    ("pmos", 4.0, 1.0, 2, "d1",   ("d1", "VDD")),
    ("pmos", 4.0, 1.0, 2, "d1",   ("d2", "VDD")),
    ("pmos", 4.0, 0.5, 8, "d2",   ("OUT", "VDD")),
]

cur_x = 0.0
dev_info = []
for kind, w, l, nf, gnet, sd in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0.0))
    dev_info.append((m, kind, sd, gnet))
    cur_x = m.diff.right + 0.3

Hmax = max(m.diff.top for m, _, _, _ in dev_info)

BY = {}
y = Hmax + 0.6
for net in ("INN", "INP", "tail", "d1", "d2", "IB", "VSS", "x", "OUT", "VDD"):
    BY[net] = y
    y += 0.6

X0 = dev_info[0][0].diff.left - 0.4
X1 = dev_info[-1][0].diff.right + 0.4

vss = c.rect(m2, x0=0.0, x1=2.4, y0=0.0, y1=BY["VDD"] + 0.07, net="VSS")
vdd = c.rect(m2, x0=vss.right + 1.6, x1=vss.right + 1.6 + 2.4, y0=0.0, y1=BY["VDD"] + 0.07, net="VDD")

def bus(net):
    return c.rect(c0, x0=X0, x1=X1, y0=BY[net], y1=BY[net] + 0.07, net=net)

def drop(term, net):
    t = BY[net]
    if t > term.top:
        c.rect(c0, x0=term.left, x1=term.right, y0=term.top, y1=t, net=net)
    elif t < term.bottom:
        c.rect(c0, x0=term.left, x1=term.right, y0=t, y1=term.bottom, net=net)

def gconn(gate, net):
    v = c.via("poly", c0, at=(gate.cx, gate.cy), net=net, dir="v")
    c.rect(c0, x0=v.upper.left, x1=v.upper.right, y0=v.upper.top, y1=BY[net], net=net)

for m, kind, sd, gnet in dev_info:
    if kind == "pmos":
        c.rect(m.well.layer, x0=m.well.left, x1=m.well.right, y0=m.well.bottom, y1=m.well.top, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        drop(tk.strap, "VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        drop(tk.strap, "VSS")

for m, kind, sd, gnet in dev_info:
    for i, s in enumerate(m.sd):
        drop(s, sd[i % len(sd)])
    for g in m.gates:
        gconn(g, gnet)

for net in BY:
    bus(net)

c.via(c0, m2, at=((X0 + X1) / 2, (BY["VSS"] + vss.top) / 2), net="VSS", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VSS"], y1=vss.top, net="VSS")
c.via(c0, m2, at=((X0 + X1) / 2, (BY["VDD"] + vdd.top) / 2), net="VDD", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VDD"], y1=vdd.top, net="VDD")

M1, M2d, M5, M8, M9, MC, M7, M3, M4, M6 = [m for m, _, _, _ in dev_info]

c.port("INN", on=c.rect(c0, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
                        y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN"), dir="in")
c.port("INP", on=c.rect(c0, x0=M2d.gates[0].left - 0.2, x1=M2d.gates[0].right + 0.2,
                        y0=M2d.gates[0].bottom, y1=M2d.gates[0].top, net="INP"), dir="in")
c.port("IB", on=c.rect(c0, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
                       y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB"), dir="in")
c.port("OUT", on=c.rect(c0, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
                        y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
                        y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT"), dir="out")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c


```