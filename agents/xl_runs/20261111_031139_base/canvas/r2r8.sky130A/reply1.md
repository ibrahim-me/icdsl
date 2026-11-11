```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2, m3 = tech.c0, tech.metal(1), tech.metal(2), tech.metal(3)

c = Cell("r2r8")

R, L, GAP = 1.0, 6.0, 3.0          # unit resistor: W=1, L=6 (um); gap between chain resistors
X0, Y0 = 1.0, 1.0                  # chain start
BR = 13.0                          # vertical pitch between bit branches

# ---------- place all 25 unit resistors ----------
# chain: VSS -RT1- t -RT2- n0 -RS0- n1 -RS1- ... -RS6- OUT  (9 resistors)
chain = [("RT1", "VSS", "t"), ("RT2", "t", "n0")] + \
        [("RS%d" % i, "n%d" % i, "n%d" % (i + 1)) for i in range(7)]
# branches: n_i -RA_i- x_i -RB_i- B_i  (i=0..6), OUT -RA7- x7 -RB7- B7
branches = [("RA%d" % i, "n%d" % i, "x%d" % i) for i in range(7)] + \
           [("RA7", "OUT", "x7")]
rb = [("RB%d" % i, "x%d" % i, "B%d" % i) for i in range(7)] + \
     [("RB7", "x7", "B7")]

res = {}          # name -> resistor object
x = X0
for name, a, b in chain:
    res[name] = c.resistor("res_poly", w=R, l=L, at=(x, Y0), nets=(a, b), orient="h")
    x += L + GAP
chain_x = {name: X0 + i * (L + GAP) for i, (name, a, b) in enumerate(chain)}
# joint x positions: left end of RT1, then each resistor right end
joint_x = {}
cx = X0
for name, a, b in chain:
    joint_x[a] = cx
    cx += L + GAP
joint_x["OUT"] = cx  # right end of last chain resistor

bx = {}
for i, (name, a, b) in enumerate(branches):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    res[name] = c.resistor("res_poly", w=R, l=L, at=(jx, Y0 + BR * i + 1.5), nets=(a, b), orient="v")
    bx[name] = jx
for i, (name, a, b) in enumerate(rb):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    res[name] = c.resistor("res_poly", w=R, l=L, at=(jx, Y0 + BR * i + 1.5 + L + 1.5), nets=(a, b), orient="v")

# ---------- bring every resistor terminal to m1 with a via ----------
def term_pin(resobj, side):
    p = resobj.a if side == "a" else resobj.b
    c.via(c0, m1, at=p.cx, net=p.net if hasattr(p, "net") else None)
    return c.rect(m1, w=0.34, h=0.34, cx=p.cx, cy=p.cy)

pins = {}   # net -> list of m1 pin shapes
for name, robj in res.items():
    for side in ("a", "b"):
        p = robj.a if side == "a" else robj.b
        mk = term_pin(robj, side)
        pins.setdefault(p.net, []).append(mk)

# explicit port nets
pins.setdefault("VSS", [])
pins.setdefault("OUT", [])
for i in range(8):
    pins.setdefault("B%d" % i, [])

# ---------- route the chain horizontally on m1 ----------
cx = X0
prev = None
for name, a, b in chain:
    r = res[name]
    if prev is not None:
        # connect previous right pad to this left pad (same net = joint node)
        p0 = res[prev].b; p1 = r.a
        c.wire(m1, [p0, p1], width=0.2, net=prev_net)
    prev = name
    prev_net = b  # net at right end of this resistor = next joint net
# left port VSS at left end of RT1, right port OUT at right end of RS6
c.wire(m1, [res["RT1"].a, (X0 - 2.0, Y0)], width=0.2, net="VSS")
c.wire(m1, [res["RS6"].b, (cx, Y0)], width=0.2, net="OUT")

# ---------- route branches vertically ----------
for i in range(8):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    # joint node -> RA bottom
    joint_net = "n%d" % i if i < 7 else "OUT"
    c.wire(m1, [(jx, Y0), (jx, Y0 + BR * i + 1.5 - 0.9)], width=0.2, net=joint_net)
    # RA top (x_i) -> RB bottom
    c.wire(m1, [(jx, Y0 + BR * i + 1.5 + L + 0.9), (jx, Y0 + BR * i + 1.5 + L + 1.5 - 0.9)],
           width=0.2, net="x%d" % i)
    # RB top -> B_i pin
    top = Y0 + BR * i + 1.5 + 2 * L + 1.5 + 0.9
    c.wire(m1, [(jx, Y0 + BR * i + 1.5 + 2 * L + 1.5 - 0.9), (jx, top)], width=0.2, net="B%d" % i)

# ---------- ports ----------
c.port("VSS", on=c.rect(m1, w=1.6, h=0.34, cx=X0 - 2.0, cy=Y0, net="VSS"), dir="in")
c.port("OUT", on=c.rect(m1, w=1.6, h=0.34, cx=cx, cy=Y0, net="OUT"), dir="out")
for i in range(8):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    top = Y0 + BR * i + 1.5 + 2 * L + 1.5 + 0.9
    c.port("B%d" % i, on=c.rect(m1, w=1.6, h=0.34, cx=jx, cy=top, net="B%d" % i), dir="in")

TOP = c
``````python
from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)

c = Cell("r2r8")

R, L, GAP = 1.0, 6.0, 3.0          # unit resistor W=1, L=6 (um); gap between chain resistors
X0, Y0 = 1.0, 1.0                  # chain start
BR = 13.0                          # vertical pitch between bit branches

# chain: VSS -RT1- t -RT2- n0 -RS0- n1 ... -RS6- OUT   (9 resistors)
chain = [("RT1", "VSS", "t"), ("RT2", "t", "n0")] + \
        [("RS%d" % i, "n%d" % i, "n%d" % (i + 1)) for i in range(7)]
# branches: n_i -RA_i- x_i -RB_i- B_i  (i=0..6),  OUT -RA7- x7 -RB7- B7
branches = [("RA%d" % i, "n%d" % i, "x%d" % i) for i in range(7)] + [("RA7", "OUT", "x7")]
rb = [("RB%d" % i, "x%d" % i, "B%d" % i) for i in range(7)] + [("RB7", "x7", "B7")]

res = {}
x = X0
for name, a, b in chain:
    res[name] = c.resistor("res_poly", w=R, l=L, at=(x, Y0), nets=(a, b), orient="h")
    x += L + GAP
joint_x = {}
cx = X0
for name, a, b in chain:
    joint_x[a] = cx
    cx += L + GAP
joint_x["OUT"] = cx
for i, (name, a, b) in enumerate(branches):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    res[name] = c.resistor("res_poly", w=R, l=L, at=(jx, Y0 + BR * i + 1.5), nets=(a, b), orient="v")
for i, (name, a, b) in enumerate(rb):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    res[name] = c.resistor("res_poly", w=R, l=L, at=(jx, Y0 + BR * i + 1.5 + L + 1.5), nets=(a, b), orient="v")

# bring every resistor terminal to m1 through a via; keep the m1 pad as routing pin
pins = {}
for name, r in res.items():
    for side in ("a", "b"):
        p = r.a if side == "a" else r.b
        c.via(c0, m1, at=p.cx)
        mk = c.rect(m1, w=0.34, h=0.34, cx=p.cx, cy=p.cy, net=p.net)
        pins.setdefault(p.net, []).append(mk)
pins.setdefault("VSS", [])
pins.setdefault("OUT", [])
for i in range(8):
    pins.setdefault("B%d" % i, [])

# chain segments on m1 (each segment = one joint net)
prev = None
for name, a, b in chain:
    r = res[name]
    if prev is not None:
        c.wire(m1, [res[prev].b, r.a], width=0.2, net=prev_net)
    prev = name
    prev_net = b
c.wire(m1, [res["RT1"].a, (X0 - 2.0, Y0)], width=0.2, net="VSS")
c.wire(m1, [res["RS6"].b, (cx, Y0)], width=0.2, net="OUT")

# branches: joint -> RA, RA top (x_i) -> RB bottom, RB top -> B_i pin
for i in range(8):
    jx = joint_x["n%d" % i] if i < 7 else joint_x["OUT"]
    jnet = "n%d" % i if i < 7 else "OUT"
    y_ra_b = Y0 + BR * i + 1.5 - 0.9
    y_ra_t = Y0 + BR * i + 1.5 + L + 0.9
    y_rb_b = Y0 + BR * i + 1.5 + L + 1.5 - 0.9
    y_rb_t = Y0 + BR * i + 1.5 + 2 * L + 1.5 - 0.9
    y_pin = y_rb_t + 0.9
    c.wire(m1, [(jx, Y0), (jx, y_ra_b)], width=0.2, net=jnet)
    c.wire(m1, [(jx, y_ra_t), (jx, y_rb_b)], width=0.2, net="x%d" % i)
    c.wire(m1, [(jx, y_rb_t), (jx, y_pin)], width=0.2, net="B%d" % i)
    c.port("B%d" % i,
           on=c.rect(m1, w=1.6, h=0.34, cx=jx, cy=y_pin, net="B%d" % i), dir="in")

c.port("VSS", on=c.rect(m1, w=1.6, h=0.34, cx=X0 - 2.0, cy=Y0, net="VSS"), dir="in")
c.port("OUT", on=c.rect(m1, w=1.6, h=0.34, cx=cx, cy=Y0, net="OUT"), dir="out")

TOP = c
```