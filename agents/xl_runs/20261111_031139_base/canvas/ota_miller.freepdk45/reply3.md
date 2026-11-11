```
from icdsl.canvas import *

tech = use()
c0 = tech.c0          # m1 on freepdk45
M2 = tech.metal(2)    # m2 global rails

c = Cell("ota_miller")

# ---------- global rails on m2 ----------
vss = c.rect(M2, x0=0, x1=2.4, y0=0, y1=1, net="VSS")
vdd = c.rect(M2, x0=vss.right + 1.6, x1=vss.right + 1.6 + 2.4, y0=0, y1=1, net="VDD")

# ---------- devices in one row, bottoms aligned ----------
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
cur_x = vdd.right + 1.2
dev_info = []   # (mos, kind, sd_nets, gate_net)
for kind, w, l, nf, gnet, sd in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0.6))
    dev_info.append((m, kind, sd, gnet))
    cur_x = m.diff.right + 0.5

Hmax = max(m.diff.top for m, _, _, _ in dev_info)

# ---------- body / well ties ----------
for m, kind, sd, gnet in dev_info:
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")

# ---------- m1 buses, one per net, stacked above the devices ----------
BY = {}
y = Hmax + 1.2
for net in ("INN", "INP", "tail", "d1", "d2", "IB", "VSS", "x", "OUT", "VDD"):
    BY[net] = y
    y += 0.8

def bus(net, x0, x1):
    return c.rect(c0, x0=x0, x1=x1, y0=BY[net], y1=BY[net] + 0.07, net=net)

def drop(term, net):
    t = BY[net]
    if t > term.top:
        c.rect(c0, x0=term.left, x1=term.right, y0=term.top, y1=t, net=net)
    elif t < term.bottom:
        c.rect(c0, x0=term.left, x1=term.right, y0=t, y1=term.bottom, net=net)

def gconn(gate, net):
    v = c.via("poly", c0, at=(gate.cx, gate.cy), net=net, dir="v")
    c.rect(c0, x0=v.upper.left, x1=v.upper.right, y0=v.upper.top, y1=BY[net], net=net)

X0 = dev_info[0][0].diff.left - 0.4
X1 = dev_info[-1][0].diff.right + 0.4

# connect every diffusion column and every gate to its net bus
for m, kind, sd, gnet in dev_info:
    for i, s in enumerate(m.sd):
        drop(s, sd[i % len(sd)])
    for g in m.gates:
        gconn(g, gnet)

# draw the buses spanning all devices
for net in BY:
    bus(net, X0, X1)

# tie VSS / VDD buses to the m2 rails
c.via(c0, M2, at=((X0 + X1) / 2, (BY["VSS"] + vss.top) / 2), net="VSS", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VSS"], y1=vss.top, net="VSS")
c.via(c0, M2, at=((X0 + X1) / 2, (BY["VDD"] + vdd.top) / 2), net="VDD", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VDD"], y1=vdd.top, net="VDD")

# make the rails span the full cell height
vss.top = BY["VDD"] + 0.07
vdd.top = BY["VDD"] + 0.07

# ---------- ports ----------
def port(net, shape, dir_="in"):
    c.port(net, on=shape, dir=dir_)

M1, M2_, M5, M8, M9, MC, M7, M3, M4, M6 = [m for m, _, _, _ in dev_info]

port("INN", c.rect(c0, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
                   y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN"), "in")
port("INP", c.rect(c0, x0=M2_.gates[0].left - 0.2, x1=M2_.gates[0].right + 0.2,
                   y0=M2_.gates[0].bottom, y1=M2_.gates[0].top, net="INP"), "in")
port("IB", c.rect(c0, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
                  y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB"), "in")
port("OUT", c.rect(c0, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
                   y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
                   y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT"), "out")
port("VDD", on=vdd)
port("VSS", on=vss)

TOP = c

```