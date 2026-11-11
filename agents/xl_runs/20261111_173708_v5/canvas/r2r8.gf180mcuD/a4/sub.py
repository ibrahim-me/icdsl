from icdsl.canvas import *
from collections import defaultdict

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3

W, L = 1.0, 6.0
pitch = 7.5
c0_w = max(tech.width(c0), 0.3)

c = Cell("r2r8")

placements = [
    ("RT1", "VSS", "t",   -1.5*pitch,  0),
    ("RT2", "n0",  "t",   -0.5*pitch,  0),
    ("RA0", "n0",  "x0",   0,           -pitch),
    ("RB0", "B0",  "x0",   0,          -2*pitch),
    ("RS0", "n0",  "n1",  0.5*pitch,    0),
    ("RA1", "n1",  "x1",   pitch,      -pitch),
    ("RB1", "B1",  "x1",   pitch,     -2*pitch),
    ("RS1", "n1",  "n2",  1.5*pitch,    0),
    ("RA2", "n2",  "x2",  2*pitch,     -pitch),
    ("RB2", "B2",  "x2",  2*pitch,    -2*pitch),
    ("RS2", "n2",  "n3",  2.5*pitch,    0),
    ("RA3", "n3",  "x3",  3*pitch,     -pitch),
    ("RB3", "B3",  "x3",  3*pitch,    -2*pitch),
    ("RS3", "n3",  "n4",  3.5*pitch,    0),
    ("RA4", "n4",  "x4",  4*pitch,     -pitch),
    ("RB4", "B4",  "x4",  4*pitch,    -2*pitch),
    ("RS4", "n4",  "n5",  4.5*pitch,    0),
    ("RA5", "n5",  "x5",  5*pitch,     -pitch),
    ("RB5", "B5",  "x5",  5*pitch,    -2*pitch),
    ("RS5", "n5",  "n6",  5.5*pitch,    0),
    ("RA6", "n6",  "x6",  6*pitch,     -pitch),
    ("RB6", "B6",  "x6",  6*pitch,    -2*pitch),
    ("RS6", "n6",  "OUT", 6.5*pitch,    0),
    ("RA7", "OUT", "x7",  7*pitch,     -pitch),
    ("RB7", "B7",  "x7",  7*pitch,    -2*pitch),
]

res = {}
for name, na, nb, x, y in placements:
    r = c.resistor("res_poly", w=W, l=L, at=(x, y), nets=(na, nb), orient="h")
    res[name] = (r, na, nb)

terms = defaultdict(list)
for name, (r, na, nb) in res.items():
    terms[na].append((r.a, name))
    terms[nb].append((r.b, name))

rtr = Router(c, v=c2, h=c3, pin_layer=c1)
for net, pads in terms.items():
    if net == "VSS":
        continue
    pins = []
    for pad, _ in pads:
        v = c.via(c0, c1, at=(pad.cx, pad.cy), net=net, dir="h")
        pins.append(v.upper)
    rtr.add(net, *pins)
routed = rtr.run()

vss_y = -2.5 * pitch
vss_rail = c.rect(c1, x0=-2*pitch, x1=8*pitch,
                  y0=vss_y-c0_w/2, y1=vss_y+c0_w/2, net="VSS")
for pad, _ in terms.get("VSS", []):
    v = c.via(c0, c1, at=(pad.cx, pad.cy), net="VSS", dir="h")
    c.wire(c1, [v.upper, (pad.cx, vss_y)], net="VSS", width=c0_w)

all_pads = []
for name, (r, na, nb) in res.items():
    all_pads.extend([r.a, r.b])
gr = c.guard_ring("ptap", around=all_pads, net="VSS", space=1.0, well=False)
v = c.via(c0, c1, at=(gr.straps[0].cx, vss_y), net="VSS", dir="v")
c.wire(c1, [v.upper, (gr.straps[0].cx, vss_y)], net="VSS", width=c0_w)

for i in range(8):
    net = "B%d" % i
    shape = routed.get(net, res["RB%d" % i][0].a)
    c.port(net, on=shape, dir="in")
c.port("OUT", on=routed.get("OUT", res["RA7"][0].b), dir="out")
c.port("VSS", on=vss_rail, dir="inout")

TOP = c
