```
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0          # m1 on freepdk45
M2 = tech.metal(2)    # m2 global rails

c = Cell("ota_miller")

# ---------- global rails on m2 ----------
vss = c.rect(M2, x0=0, x1=2.4, y0=0, y1=30, net="VSS")
vdd = c.rect(M2, x0=vss.right + 1.6, x1=vss.right + 1.6 + 2.4, y0=0, y1=30, net="VDD")

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
devs = []   # (mos, kind)
for kind, w, l, nf, gnet, sd in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, left=cur_x, bottom=0)
    devs.append((m, kind))
    cur_x = m.diff.right + 0.7

Hmax = max(m.diff.top for m, _ in devs)

# ---------- body / well ties ----------
for m, kind in devs:
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right, y0=vdd.bottom, y1=vdd.top, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right, y0=vss.bottom, y1=vss.top, net="VSS")

# ---------- m1 buses (one per net) above the devices ----------
BY = {}
y = Hmax + 0.6
for net in ("INN", "INP", "tail", "d1", "d2", "IB", "VSS", "x", "OUT", "VDD"):
    BY[net] = y
    y += 0.85

def bus(net, x0, x1):
    return c.rect(c0, x0=x0, x1=x1, y0=BY[net], y1=BY[net] + 0.07, net=net)

def drop(term, net):
    """vertical m1 drop from an m1 terminal up to its bus"""
    t = BY[net]
    if t > term.top:
        c.rect(c0, x0=term.left, x1=term.right, y0=term.top, y1=t, net=net)
    elif t < term.bottom:
        c.rect(c0, x0=term.left, x1=term.right, y0=t, y1=term.bottom, net=net)

def gconn(gate, net):
    """contact poly gate to m1 and drop to bus"""
    v = c.via("poly", c0, at=(gate.cx, gate.cy), net=net, dir="v")
    c.rect(c0, x0=v.upper.left, x1=v.upper.right, y0=v.upper.top, y1=BY[net], net=net)

# x-range spanning all devices for full buses
X0 = devs[0][0].diff.left - 0.4
X1 = devs[-1][0].diff.right + 0.4

M1, M2, M5, M8, M9, MC, M7, M3, M4, M6 = [m for m, _ in devs]

# INN / INP (gate only)
gconn(M1.gates[0], "INN"); gconn(M2.gates[0], "INP")
# tail
for t in (M1.sd[1], M2.sd[1], M5.sd[0], M5.sd[2]): drop(t, "tail")
# d1
for t in (M1.sd[0], M3.sd[0]): drop(t, "d1")
for g in (M3.gates[0], M3.gates[1], M4.gates[0], M4.gates[1]): gconn(g, "d1")
# d2
for t in (M2.sd[0], M4.sd[0], M9.sd[1]): drop(t, "d2")
for g in M6.gates: gconn(g, "d2")
# IB
for t in (M8.sd[0],): drop(t, "IB")
for g in (M8.gates[0], M5.gates[0]) + tuple(M5.gates) + tuple(M7.gates): gconn(g, "IB")
# VSS (device terminals to VSS bus; bus ties to rail below)
for t in (M5.sd[1], M5.sd[3], M8.sd[1]) + tuple(M7.sd[1::2]): drop(t, "VSS")
# x
for t in (M9.sd[0],) + tuple(MC.sd[0::2]): drop(t, "x")
# OUT
for t in tuple(M7.sd[0::2]) + tuple(M6.sd[0::2]): drop(t, "OUT")
for g in MC.gates: gconn(g, "OUT")
# VDD
for t in (M3.sd[1], M4.sd[1]) + tuple(M6.sd[1::2]): drop(t, "VDD")
gconn(M9.gates[0], "VDD")

# draw buses spanning all devices
for net in BY:
    bus(net, X0, X1)

# tie VSS/VDD buses to m2 rails
c.via(c0, M2, at=((X0 + X1) / 2, (BY["VSS"] + vss.top) / 2), net="VSS", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VSS"], y1=vss.top, net="VSS")
c.via(c0, M2, at=((X0 + X1) / 2, (BY["VDD"] + vdd.top) / 2), net="VDD", dir="v")
c.rect(c0, x0=X0, x1=X1, y0=BY["VDD"], y1=vdd.top, net="VDD")

# ---------- ports ----------
def port(net, shape, dir_="in"):
    c.port(net, on=shape, dir=dir_)

port("INN", c.rect(c0, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
                   y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN"), "in")
port("INP", c.rect(c0, x0=M2.gates[0].left - 0.2, x1=M2.gates[0].right + 0.2,
                   y0=M2.gates[0].bottom, y1=M2.gates[0].top, net="INP"), "in")
port("IB", c.rect(c0, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
                  y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB"), "in")
port("OUT", c.rect(c0, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
                   y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
                   y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT"), "out")
port("VDD", on=vdd)
port("VSS", on=vss)

TOP = c
```