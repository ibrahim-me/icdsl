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
