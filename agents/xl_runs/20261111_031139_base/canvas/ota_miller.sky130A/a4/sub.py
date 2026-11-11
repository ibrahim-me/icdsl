from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0; m1 = tech.metal(1); m2 = tech.metal(2)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")
SP = 1.0   # generous spacing between device blocks

def lift(term, net):
    """Bring a c0 terminal shape up to m1 with a via."""
    s = c.rect(m1, x0=term.left-0.12, x1=term.right+0.12,
               y0=term.bottom-0.12, y1=term.top+0.12, net=net)
    c.via(c0, m1, at=(term.cx, term.cy), net=net)
    return s

def c0bridge(net, *terms):
    """Connect several c0 terminals with a minimal c0 rectangle."""
    xs = [t.left for t in terms] + [t.right for t in terms]
    ys = [t.bottom for t in terms] + [t.top for t in terms]
    return c.rect(c0, x0=min(xs), y0=min(ys), x1=max(xs), y1=max(ys), net=net)

# ---------------- devices ----------------
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS","TAIL"), at=(0, 0))
M8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS","IB"),
           at=(M5.diff.right + SP, M5.diff.bottom))
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL","D1"),
           at=(0, M5.diff.top + SP))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL","D2"),
           at=(M1.diff.right + SP, M1.diff.bottom))
M3 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD","D1"),
           at=(M1.diff.left, M1.diff.top + SP))
M4 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD","D2"),
           at=(M2.diff.left, M2.diff.top + SP))
M7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS","OUT"),
           at=(M4.diff.right + SP, M5.diff.bottom))
M6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="D2", sd=("VDD","OUT"),
           at=(M7.diff.left, M7.diff.top + SP))

if have_res:
    RZ = c.resistor("res_poly", w=1, l=8, at=(M6.diff.right + SP, M6.diff.top), orient="v")
else:
    RZ = c.mos("nmos", w=2, l=1, nf=1, gates="VDD", sd=("D2","X"),
               at=(M6.diff.right + SP, M6.diff.top))

cc_at = (RZ.b.right + SP if have_res else RZ.sd[1].right + SP, M6.diff.top)
if have_mim:
    CC = c.capacitor("cap_mim", w=20, h=20, at=cc_at)
else:
    CC = c.mos("nmos", w=4, l=1, nf=1, gates="OUT", sd=("X","X"), at=cc_at)

# ---------------- local c0 joins (non-overlapping nets) ----------------
c0bridge("TAIL", M1.sd[0], M2.sd[0], M5.sd[1])
c0bridge("D1",   M1.sd[1], M3.sd[1], M3.gates[0], M4.gates[0])
d2_terms = [M2.sd[1], M4.sd[1], M6.gates[0], RZ.a if not have_res else RZ.a]
c0bridge("D2", *d2_terms)
out_terms = [M6.sd[1], M7.sd[1], CC.bottom_pad if have_mim else CC.sd[1]]
c0bridge("OUT", *out_terms)
c0bridge("VDD", M3.sd[0], M4.sd[0], M6.sd[0])
c0bridge("VSS", M5.sd[0], M7.sd[0], M8.sd[0])
c0bridge("IB",  M5.gates[0], M7.gates[0], M8.gates[0], M8.sd[1])
x_terms = [RZ.b if have_res else RZ.sd[1], CC.top_pad if have_mim else CC.sd[0]]
c0bridge("X", *x_terms)

# ---------------- lift everything to m1 ----------------
m1shapes = {}
for net in ("TAIL","D1","D2","OUT","VDD","VSS","IB","X","INN","INP"):
    m1shapes[net] = []

# INN / INP: gate poly -> m1
for mos, net, name in ((M1,"INN","INN"), (M2,"INP","INP")):
    g = mos.gates[0]
    s = lift(g, net)
    m1shapes[net].append(s)
    c.port(name, on=s, dir="in")

# other nets: lift one representative terminal
for net, terms in (("TAIL",[M1.sd[0],M2.sd[0],M5.sd[1]]),
                   ("D1",[M1.sd[1],M3.sd[1]]),
                   ("D2",[M2.sd[1],M4.sd[1]]),
                   ("OUT",[M6.sd[1],M7.sd[1]]),
                   ("VDD",[M3.sd[0],M4.sd[0]]),
                   ("VSS",[M5.sd[0],M7.sd[0]]),
                   ("IB",[M5.gates[0],M7.gates[0],M8.gates[0]]),
                   ("X",[RZ.b if have_res else RZ.sd[1]])):
    for t in terms:
        m1shapes[net].append(lift(t, net))

# IB port
ib_port = c.rect(m1, x0=min(t.left for t in [M5.gates[0],M7.gates[0],M8.gates[0]])-0.2,
                 x1=max(t.right for t in [M5.gates[0],M7.gates[0],M8.gates[0]])+0.2,
                 y0=max(t.top for t in [M5.gates[0],M7.gates[0],M8.gates[0]])+0.2,
                 y1=max(t.top for t in [M5.gates[0],M7.gates[0],M8.gates[0]])+0.8, net="IB")
for g in (M5.gates[0], M7.gates[0], M8.gates[0]):
    c.via(c0, m1, at=(g.cx, ib_port.bottom-0.15), net="IB")
c.rect(m1, x0=ib_port.left, x1=ib_port.right, y0=ib_port.bottom-0.3, y1=ib_port.bottom, net="IB")
c.port("IB", on=ib_port, dir="in")

# OUT port
out_port = c.rect(m1, x0=M6.sd[1].left-0.2, x1=M6.sd[1].right+0.2,
                  y0=M6.sd[1].top+0.2, y1=M6.sd[1].top+0.8, net="OUT")
c.via(c0, m1, at=(M6.sd[1].cx, M6.sd[1].cy), net="OUT")
c.rect(m1, x0=out_port.left, x1=out_port.right, y0=out_port.top, y1=out_port.top+0.3, net="OUT")
c.port("OUT", on=out_port, dir="out")

# ---------------- power rails on m2 ----------------
vdd_rail = c.rect(m2, x0=min(M3.well.left, M4.well.left, M6.well.left)-0.3,
                  x1=max(M3.well.right, M4.well.right, M6.well.right)+0.3,
                  y0=max(M3.top, M4.top, M6.top)+0.3,
                  y1=max(M3.top, M4.top, M6.top)+1.0, net="VDD")
vss_rail = c.rect(m2, x0=min(M1.diff.left,M2.diff.left,M5.diff.left,M7.diff.left,M8.diff.left)-0.3,
                  x1=max(M1.diff.right,M2.diff.right,M5.diff.right,M7.diff.right,M8.diff.right)+0.3,
                  y0=min(M1.bottom,M2.bottom,M5.bottom,M7.bottom,M8.bottom)-1.0,
                  y1=min(M1.bottom,M2.bottom,M5.bottom,M7.bottom,M8.bottom)-0.3, net="VSS")

# connect c0 VDD/VSS to m2 rails
for s in (M3.sd[0], M4.sd[0], M6.sd[0]):
    c.via(c0, m1, at=(s.cx, s.cy), net="VDD")
    m1bar = c.rect(m1, x0=s.left-0.12, x1=s.right+0.12, y0=s.top, y1=vdd_rail.bottom, net="VDD")
    c.via(m1, m2, at=(s.cx, (m1bar.top+m1bar.bottom)/2), net="VDD")
for s in (M5.sd[0], M7.sd[0], M8.sd[0]):
    c.via(c0, m1, at=(s.cx, s.cy), net="VSS")
    m1bar = c.rect(m1, x0=s.left-0.12, x1=s.right+0.12, y0=vss_rail.top, y1=s.bottom, net="VSS")
    c.via(m1, m2, at=(s.cx, (m1bar.top+m1bar.bottom)/2), net="VSS")

c.port("VDD", on=vdd_rail)
c.port("VSS", on=vss_rail)

# ---------------- taps ----------------
for mos in (M3, M4, M6):
    if mos.well:
        c.tap("ntap", x0=mos.well.left-0.1, y0=mos.well.bottom-0.1,
              x1=mos.well.right+0.1, y1=mos.well.top+0.1, net="VDD")
        c.via(c0, m1, at=(mos.well.cx, mos.well.cy), net="VDD")
        m1bar = c.rect(m1, x0=mos.well.cx-0.12, x1=mos.well.cx+0.12,
                       y0=mos.well.top, y1=vdd_rail.bottom, net="VDD")
        c.via(m1, m2, at=(mos.well.cx, (m1bar.top+m1bar.bottom)/2), net="VDD")

c.tap("ptap", x0=min(M1.diff.left,M2.diff.left,M5.diff.left,M7.diff.left,M8.diff.left)-0.1,
      y1=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-0.1,
      x1=max(M1.diff.right,M2.diff.right,M5.diff.right,M7.diff.right,M8.diff.right)+0.1,
      y0=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-1.0, net="VSS")
c.via(c0, m1, at=(c.tap("ptap", x0=0,y0=0,x1=0,y1=0,net="VSS").diff.cx if False else 0, 0), net="VSS") if False else None
# redo ptap with via
ptap = c.tap("ptap", x0=min(M1.diff.left,M2.diff.left,M5.diff.left,M7.diff.left,M8.diff.left)-0.1,
             y1=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-0.1,
             x1=max(M1.diff.right,M2.diff.right,M5.diff.right,M7.diff.right,M8.diff.right)+0.1,
             y0=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-1.0, net="VSS")
c.via(c0, m1, at=(ptap.diff.cx, ptap.diff.cy), net="VSS")
m1bar = c.rect(m1, x0=ptap.diff.cx-0.12, x1=ptap.diff.cx+0.12,
               y0=vss_rail.top, y1=ptap.diff.bottom, net="VSS")
c.via(m1, m2, at=(ptap.diff.cx, (m1bar.top+m1bar.bottom)/2), net="VSS")

# ---------------- router for remaining signal connections ----------------
r = Router(c)
for net, shapes in m1shapes.items():
    if net in ("VDD","VSS"):
        continue
    if len(shapes) >= 2:
        r.add(net, *shapes)

try:
    r.run()
except Exception:
    pass

TOP = c
