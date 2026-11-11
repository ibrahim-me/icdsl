```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------- device groups from freepdk45.spice ----------------
# (kind, w, l, nf, gate_net, sd_sequence, body_net)
GROUPS = [
    ("nmos", 4.0, 0.5, 2, "INN",  ("d1", "tail"),   "VSS"),   # M1
    ("nmos", 4.0, 0.5, 2, "INP",  ("d2", "tail"),   "VSS"),   # M2
    ("nmos", 2.0, 1.0, 4, "IB",   ("tail", "VSS"),  "VSS"),   # M5
    ("nmos", 2.0, 1.0, 2, "IB",   ("IB", "VSS"),    "VSS"),   # M8
    ("nmos", 2.0, 0.5, 1, "VDD",  ("x", "d2"),      "VSS"),   # M9 (RZ)
    ("nmos", 4.0, 1.0, 8, "OUT",  ("x", "x"),       "VSS"),   # MC (CC)
    ("nmos", 2.0, 1.0, 8, "IB",   ("OUT", "VSS"),   "VSS"),   # M7
    ("pmos", 4.0, 1.0, 2, "d1",   ("d1", "VDD"),    "VDD"),   # M3
    ("pmos", 4.0, 1.0, 2, "d1",   ("d2", "VDD"),    "VDD"),   # M4
    ("pmos", 4.0, 0.5, 8, "d2",   ("OUT", "VDD"),   "VDD"),   # M6
]

c = Cell("ota_miller")

# global rails on m2
vdd = c.rect(m2, w=2.4, h=40, net="VDD")
vss = c.rect(m2, w=2.4, h=40, net="VSS")
vss.left = 0; vss.bottom = 0
vdd.right_of(vss, space=1.6)

cur_x = vdd.right + 1.2
row_bottoms = []
for kind, w, l, nf, gnet, sd, body in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0))
    # body / well tie
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vdd.bottom, y1=vdd.top, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vss.bottom, y1=vss.top, net="VSS")
    row_bottoms.append(m.diff.bottom)
    cur_x = m.diff.right + 1.2

row_top = max(g.top for g in [c.mos.__self__ and None] ) if False else 0
# compute actual row top from devices placed
# (recompute: track max top)
cur_x = vdd.right + 1.2
max_top = 0
devs = []
for kind, w, l, nf, gnet, sd, body in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0))
    devs.append(m)
    max_top = max(max_top, m.diff.top, m.gates[0].top if m.gates else 0)
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vdd.bottom, y1=vdd.top, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vss.bottom, y1=vss.top, net="VSS")
    cur_x = m.diff.right + 1.2

# rebuild cleanly (first pass above was exploratory)
c = Cell("ota_miller")
vdd = c.rect(m2, w=2.4, h=40, net="VDD")
vss = c.rect(m2, w=2.4, h=40, net="VSS")
vss.left = 0; vss.bottom = 0
vdd.right_of(vss, space=1.6)

cur_x = vdd.right + 1.2
devs = []
for kind, w, l, nf, gnet, sd, body in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0))
    devs.append(m)
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vdd.bottom, y1=vdd.top, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right,
               y0=vss.bottom, y1=vss.top, net="VSS")
    cur_x = m.diff.right + 1.2

# ---------------- local interconnect on m1 ----------------
def strap(net, shapes):
    """join a list of same-net shapes with an m1 bar spanning their vertical extent"""
    x0 = min(s.left for s in shapes); x1 = max(s.right for s in shapes)
    y0 = min(s.bottom for s in shapes); y1 = max(s.top for s in shapes)
    return c.rect(m1, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

M1, M2, M5, M8, M9, MC, M7, M3, M4, M6 = devs

# diff pair sources -> tail
strap("tail", [M1.sd[1], M2.sd[1]])
# drains d1 / d2
strap("d1", [M1.sd[0], M3.sd[0], M3.sd[2], M4.sd[1]])
strap("d2", [M2.sd[0], M4.sd[0], M4.sd[2], M9.sd[1]])
# M5 drains -> tail
strap("tail", [M5.sd[0], M5.sd[2]] + [strap("tail", [M1.sd[1], M2.sd[1]])] if False else [M5.sd[0], M5.sd[2]])
tail_bar = c.rect(m1, x0=min(M1.sd[1].left, M2.sd[1].left, M5.sd[0].left, M5.sd[2].left),
                  x1=max(M1.sd[1].right, M2.sd[1].right, M5.sd[0].right, M5.sd[2].right),
                  y0=min(M1.sd[1].bottom, M2.sd[1].bottom, M5.sd[0].bottom, M5.sd[2].bottom),
                  y1=max(M1.sd[1].top, M2.sd[1].top, M5.sd[0].top, M5.sd[2].top), net="tail")

# M8 diode: gate=drain=IB, source=VSS
strap("IB", [M8.sd[0], M8.gates[0]])
strap("VSS", [M8.sd[1]])

# M9: gate=VDD
c.rect(m1, x0=M9.gates[0].left, x1=M9.gates[0].right, y0=vdd.bottom, y1=vdd.top, net="VDD")

# MC: gate=OUT, source/drain=x
strap("x", [MC.sd[0], MC.sd[2], MC.sd[4], MC.sd[6], MC.sd[8], MC.sd[10], MC.sd[12], MC.sd[14]])
c.rect(m1, x0=MC.gates[0].left, x1=MC.gates[-1].right, y0=vss.bottom, y1=vss.top, net="OUT")  # temp, replaced below

# M7 sources -> VSS, drains -> OUT
strap("VSS", [M7.sd[1], M7.sd[3], M7.sd[5], M7.sd[7], M7.sd[9], M7.sd[11], M7.sd[13], M7.sd[15]])
strap("OUT", [M7.sd[0], M7.sd[2], M7.sd[4], M7.sd[6], M7.sd[8], M7.sd[10], M7.sd[12], M7.sd[14]])

# M3/M4 gates = d1 (diode + mirror)
strap("d1", [M3.gates[0], M3.gates[1], M4.gates[0], M4.gates[1]])
# M6 gates = d2
strap("d2", [M6.gates[0], M6.gates[2], M6.gates[4], M6.gates[6], M6.gates[8], M6.gates[10], M6.gates[12], M6.gates[14]])
# M6 sources -> VDD
strap("VDD", [M6.sd[1], M6.sd[3], M6.sd[5], M6.sd[6] if False else M6.sd[5], M6.sd[7], M6.sd[9], M6.sd[11], M6.sd[13], M6.sd[15]])

# MC gate = OUT (route to OUT net)
mc_gate_bar = c.rect(m1, x0=MC.gates[0].left, x1=MC.gates[-1].right,
                     y0=MC.gates[0].bottom, y1=MC.gates[0].top, net="OUT")

# ---------------- global connections & ports ----------------
c.rect(m1, x0=vss.left, x1=vss.right, y0=vss.bottom, y1=vss.top, net="VSS")
c.rect(m1, x0=vdd.left, x1=vdd.right, y0=vdd.bottom, y1=vdd.top, net="VDD")

# input ports INP/INN on m1 over the gates
c.rect(m1, x0=M2.gates[0].left - 0.2, x1=M2.gates[0].right + 0.2,
       y0=M2.gates[0].bottom, y1=M2.gates[0].top, net="INP")
c.rect(m1, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
       y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN")

# IB port: extend M8 gate strap
c.rect(m1, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
       y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB")

# OUT port at M6/M7 drain region
c.rect(m1, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
       y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
       y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT")

# x node: M9 drain to MC source/drain
c.rect(m1, x0=M9.sd[0].right, x1=MC.sd[0].left - 0.2,
       y0=min(M9.sd[0].bottom, MC.sd[0].bottom),
       y1=max(M9.sd[0].top, MC.sd[0].top), net="x")

# ---------------- vias to m2 rails ----------------
def rail_via(net, shape, rail):
    c.via(m1, m2, at=(shape.cx, (shape.top + rail.bottom) / 2), net=net, dir="v")
    c.rect(m1, x0=shape.left, x1=shape.right, y0=shape.top, y1=rail.bottom, net=net)

rail_via("VSS", vss, vss)
rail_via("VDD", vdd, vdd)
# tail strap to VSS? no, tail is internal. Connect tail strap down to vss rail area? tail is internal node.
# bring tail, d1, d2, x, OUT up where needed via router instead

# ---------------- router for remaining nets ----------------
r = Router(c, v=m2, h=m1, pin_layer=m1)
# place pins: horizontal m1 strips at the right edge for router to grab
pins = {}
for net, shape in [("INP", None), ("INN", None), ("IB", None), ("OUT", None)]:
    pass
r.auto()
h = r.run()

# ---------------- ports ----------------
def port_on(net, shape, dir_="in"):
    c.port(net, on=shape, dir=dir_)

# find shapes for ports
# INP/INN: the m1 gate bars
port_on("INP", c.rect(m1, x0=M2.gates[0].left - 0.2, x1=M2.gates[0].right + 0.2,
                      y0=M2.gates[0].bottom, y1=M2.gates[0].top, net="INP"), "in")
port_on("INN", c.rect(m1, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
                      y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN"), "in")
port_on("IB", c.rect(m1, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
                     y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB"), "in")
port_on("OUT", c.rect(m1, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
                      y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
                      y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT"), "out")
port_on("VDD", on=vdd)
port_on("VSS", on=vss)

TOP = c
``````python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# (kind, w, l, nf, gate_net, sd_sequence, body_net)  sd alternates across shared diffusions
GROUPS = [
    ("nmos", 4.0, 0.5, 2, "INN",  ("d1", "tail"),   "VSS"),   # M1  diff pair INN
    ("nmos", 4.0, 0.5, 2, "INP",  ("d2", "tail"),   "VSS"),   # M2  diff pair INP
    ("nmos", 2.0, 1.0, 4, "IB",   ("tail", "VSS"),  "VSS"),   # M5  tail source
    ("nmos", 2.0, 1.0, 2, "IB",   ("IB", "VSS"),    "VSS"),   # M8  bias diode
    ("nmos", 2.0, 0.5, 1, "VDD",  ("x", "d2"),      "VSS"),   # M9  nulling R (triode)
    ("nmos", 4.0, 1.0, 8, "OUT",  ("x", "x"),       "VSS"),   # MC  Miller C (gate cap)
    ("nmos", 2.0, 1.0, 8, "IB",   ("OUT", "VSS"),   "VSS"),   # M7  second-stage sink
    ("pmos", 4.0, 1.0, 2, "d1",   ("d1", "VDD"),    "VDD"),   # M3  diode load
    ("pmos", 4.0, 1.0, 2, "d1",   ("d2", "VDD"),    "VDD"),   # M4  mirror
    ("pmos", 4.0, 0.5, 8, "d2",   ("OUT", "VDD"),   "VDD"),   # M6  second-stage load
]

c = Cell("ota_miller")

# global rails on m2
vss = c.rect(m2, w=2.4, h=40, net="VSS")
vdd = c.rect(m2, w=2.4, h=40, net="VDD")
vss.left = 0; vss.bottom = 0
vdd.right_of(vss, space=1.6)

cur_x = vdd.right + 1.2
devs = []
for kind, w, l, nf, gnet, sd, body in GROUPS:
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gnet, sd=sd, at=(cur_x, 0))
    devs.append(m)
    if kind == "pmos":
        c.rect(m.well.layer, bbox=m.well.bbox, net="VDD")
        tk = c.tap("ntap", x0=m.well.left - 0.2, y0=m.well.bottom - 0.6,
                   x1=m.well.right + 0.2, y1=m.well.top + 0.6, net="VDD")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right, y0=vdd.bottom, y1=vdd.top, net="VDD")
    else:
        tk = c.tap("ptap", x0=m.diff.left - 0.2, y0=m.diff.bottom - 0.6,
                   x1=m.diff.right + 0.2, y1=m.diff.top + 0.6, net="VSS")
        c.rect(c0, x0=tk.strap.left, x1=tk.strap.right, y0=vss.bottom, y1=vss.top, net="VSS")
    cur_x = m.diff.right + 1.2

M1, M2, M5, M8, M9, MC, M7, M3, M4, M6 = devs

def bar(net, shapes):
    x0 = min(s.left for s in shapes); x1 = max(s.right for s in shapes)
    y0 = min(s.bottom for s in shapes); y1 = max(s.top for s in shapes)
    return c.rect(m1, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# local interconnect on m1
bar("tail", [M1.sd[1], M2.sd[1], M5.sd[0], M5.sd[2]])
bar("d1",   [M1.sd[0], M3.sd[0], M3.sd[2], M4.sd[1],
             M3.gates[0], M3.gates[1], M4.gates[0], M4.gates[1]])
bar("d2",   [M2.sd[0], M4.sd[0], M4.sd[2], M9.sd[1],
             M6.gates[0], M6.gates[2], M6.gates[4], M6.gates[6],
             M6.gates[8], M6.gates[10], M6.gates[12], M6.gates[14]])
bar("IB",   [M8.sd[0], M8.gates[0]])
bar("VSS",  [M8.sd[1], M7.sd[1], M7.sd[3], M7.sd[5], M7.sd[7],
             M7.sd[9], M7.sd[11], M7.sd[13], M7.sd[15]])
bar("VDD",  [M6.sd[1], M6.sd[3], M6.sd[5], M6.sd[7], M6.sd[9],
             M6.sd[11], M6.sd[13], M6.sd[15]])
bar("x",    [M9.sd[0], MC.sd[0], MC.sd[2], MC.sd[4], MC.sd[6],
             MC.sd[8], MC.sd[10], MC.sd[12], MC.sd[14]])
bar("OUT",  [MC.gates[0], MC.gates[1], MC.gates[2], MC.gates[3],
             MC.gates[4], MC.gates[5], MC.gates[6], MC.gates[7],
             M7.sd[0], M7.sd[2], M7.sd[4], M7.sd[6],
             M7.sd[8], M7.sd[10], M7.sd[12], M7.sd[14],
             M6.sd[0], M6.sd[2], M6.sd[4], M6.sd[6],
             M6.sd[8], M6.sd[10], M6.sd[12], M6.sd[14]])

# gate of M9 to VDD
c.rect(m1, x0=M9.gates[0].left, x1=M9.gates[0].right, y0=vdd.bottom, y1=vdd.top, net="VDD")

# rail straps on m1
c.rect(m1, x0=vss.left, x1=vss.right, y0=vss.bottom, y1=vss.top, net="VSS")
c.rect(m1, x0=vdd.left, x1=vdd.right, y0=vdd.bottom, y1=vdd.top, net="VDD")

# input port bars (extend slightly beyond gate for pin)
c.rect(m1, x0=M2.gates[0].left - 0.2, x1=M2.gates[0].right + 0.2,
       y0=M2.gates[0].bottom, y1=M2.gates[0].top, net="INP")
c.rect(m1, x0=M1.gates[0].left - 0.2, x1=M1.gates[0].right + 0.2,
       y0=M1.gates[0].bottom, y1=M1.gates[0].top, net="INN")
c.rect(m1, x0=M8.gates[0].left, x1=M8.gates[0].right + 1.5,
       y0=M8.gates[0].bottom, y1=M8.gates[0].top, net="IB")
c.rect(m1, x0=M6.sd[0].right, x1=M6.sd[0].right + 2.0,
       y0=min(M6.sd[0].bottom, M7.sd[0].bottom),
       y1=max(M6.sd[0].top, M7.sd[0].top), net="OUT")

# vias from m1 straps to m2 rails
def to_rail(net, shape, rail):
    c.rect(m1, x0=shape.left, x1=shape.right, y0=shape.top, y1=rail.bottom, net=net)
    c.via(m1, m2, at=(shape.cx, (shape.top + rail.bottom) / 2), net=net, dir="v")

to_rail("VSS", bar("VSS", [M7.sd[1]]), vss)
to_rail("VDD", bar("VDD", [M6.sd[1]]), vdd)

# router pins: short m1 strips at right edge for nets that need metal2 reach
pin_y = vss.top + 1.0
for net, shape in [("INP", M2.gates[0]), ("INN", M1.gates[0]), ("IB", M8.gates[0]),
                   ("OUT", M6.sd[0])]:
    c.rect(m1, x0=shape.right + 0.5, x1=shape.right + 2.5,
           y0=shape.bottom, y1=shape.top, net=net)

r = Router(c, v=m2, h=m1, pin_layer=m1)
r.auto()
r.run()

c.port("INP", on=M2.gates[0], dir="in")
c.port("INN", on=M1.gates[0], dir="in")
c.port("IB",  on=M8.gates[0], dir="in")
c.port("OUT", on=M6.sd[0], dir="out")
c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c
```