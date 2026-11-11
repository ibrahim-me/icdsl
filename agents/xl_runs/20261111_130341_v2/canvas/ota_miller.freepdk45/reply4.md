```
"""ota_miller - two-stage Miller OTA, manual layout from netlist.spice (freepdk45: MOS-only).

NMOS diff pair M1/M2 with PMOS mirror load M3/M4, tail M5, bias diode M8,
output stage PMOS M6 / NMOS sink M7, and MOS-only compensation: M9 triode
resistor (gate VDD) in series with MC gate capacitor (gate OUT).  Signal and
supply connections run on c0 (m1); OUT is brought out on c1 (m2) to cross over
other c0 nets without shorting.  NMOS bodies -> VSS, PMOS n-wells -> VDD.
All ports sit on metal layers.
"""
from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1
c1 = tech.conductor(1)            # m2
poly = "poly"
diff = "diff"
nwell = "nwell"

c = Cell("ota_miller")

def MOS(kind, w, l, nf, gate_net, sd, at, body_net):
    m = c.mos(kind, w=w, l=l, nf=nf, gates=gate_net, sd=sd, at=at)
    pad = c.rect(c0, x0=m.diff.left, x1=m.diff.right,
                 y0=m.diff.bottom - 0.14, y1=m.diff.bottom - 0.04, net=body_net)
    c.via(diff, c0, at=(pad.cx, pad.cy), net=body_net)
    return m

def rail(net, x0, x1, y0, y1):
    return c.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

def con(a, b, net, width=0.2):
    c.wire(c0, [a, b], net=net, width=width)

def g2m(gate, net):
    """bring a poly gate down to c0 and return the c0 pad"""
    v = c.via(poly, c0, at=(gate.cx, gate.cy), net=net)
    return v.upper

def gate_port(name, gate, net):
    c.port(name, on=g2m(gate, net), dir="in")

# global rails on c0
VDD = rail("VDD", 0, 56, 40.0, 41.2)
VSS = rail("VSS", 0, 56, -3.4, -2.2)

# ---- NMOS input pair M1/M2 (w=4 l=0.5 nf=2), sources = tail ----
M1 = MOS("nmos", 4.0, 0.5, 2, "INN", ("tail", "d1"), (2.0, 2.0), "VSS")
M2 = MOS("nmos", 4.0, 0.5, 2, "INP", ("tail", "d2"), (M1.diff.right + 0.8, 2.0), "VSS")
con(M1.sd[1], M2.sd[1], "tail")

# ---- PMOS load M3/M4 (w=4 l=1 nf=2) in n-well; M3 diode (gate=d1) ----
M3 = MOS("pmos", 4.0, 1.0, 2, "d1", ("VDD", "d1"), (2.0, M1.diff.top + 2.0), "VDD")
M4 = MOS("pmos", 4.0, 1.0, 2, "d1", ("VDD", "d2"), (M3.diff.right + 0.8, M1.diff.top + 2.0), "VDD")
c.rect(nwell, x0=M3.diff.left - 0.8, x1=M4.diff.right + 0.8,
       y0=M3.diff.bottom - 0.8, y1=M3.diff.top + 0.8, net="VDD")
con(g2m(M3.gates[0], "d1"), M1.sd[0], "d1")   # M3 gate = d1
con(g2m(M4.gates[0], "d1"), M1.sd[0], "d1")   # M4 gate = d1
con(M2.sd[0], M4.sd[0], "d2")                 # d2 node

# ---- tail M5 (w=2 l=1 nf=4), gate IB ----
M5 = MOS("nmos", 2.0, 1.0, 4, "IB", ("VSS", "tail"), (M2.diff.right + 1.0, 2.0), "VSS")
con(M5.sd[0], VSS, "VSS")
con(M5.sd[1], M1.sd[1], "tail")

# ---- bias diode M8 (w=2 l=1 nf=2), gate=IB, drain=IB ----
M8 = MOS("nmos", 2.0, 1.0, 2, "IB", ("VSS", "IB"), (M5.diff.right + 0.9, 2.0), "VSS")
con(M8.sd[0], VSS, "VSS")

# ---- M9 triode resistor (w=2 l=0.5 nf=1), gate VDD, source=d2 drain=x ----
M9 = MOS("nmos", 2.0, 0.5, 1, "VDD", ("d2", "x"), (M8.diff.right + 0.9, 2.0), "VSS")
con(g2m(M9.gates[0], "VDD"), VDD, "VDD")
con(M9.sd[0], M2.sd[0], "d2")

# ---- output stage PMOS M6 (w=4 l=0.5 nf=8), gate d2, source VDD, drain OUT ----
M6 = MOS("pmos", 4.0, 0.5, 8, "d2", ("VDD", "OUT"), (M4.diff.right + 1.2, M1.diff.top + 2.0), "VDD")
c.rect(nwell, x0=M6.diff.left - 0.8, x1=M6.diff.right + 0.8,
       y0=M6.diff.bottom - 0.8, y1=M6.diff.top + 0.8, net="VDD")
con(g2m(M6.gates[0], "d2"), M2.sd[0], "d2")
con(VDD, M6.sd[1], "VDD")

# ---- NMOS sink M7 (w=2 l=1 nf=8), gate IB, source VSS, drain OUT ----
M7 = MOS("nmos", 2.0, 1.0, 8, "IB", ("VSS", "OUT"), (M6.diff.right + 1.0, 2.0), "VSS")
con(M7.sd[0], VSS, "VSS")

# ---- compensation cap MC (w=4 l=1 nf=8), gate OUT, source/drain joined to x ----
MC = MOS("nmos", 4.0, 1.0, 8, "OUT", ("x", "x"), (M7.diff.right + 1.0, 2.0), "VSS")
con(MC.sd[0], MC.sd[1], "x")
con(M9.sd[1], MC.sd[0], "x")

# ---- OUT on c1 (m2) to cross over other c0 nets ----
c.via(c0, c1, at=(M6.sd[0].cx, M6.sd[0].cy), net="OUT")
c.via(c0, c1, at=(M7.sd[0].cx, M7.sd[0].cy), net="OUT")
c.via(c0, c1, at=(MC.gates[0].cx, MC.gates[0].cy), net="OUT")
out_top = c.rect(c1,
    x0=min(M6.sd[0].left, M7.sd[0].left, MC.gates[0].left),
    x1=max(M6.sd[0].right, M7.sd[0].right, MC.gates[0].right),
    y0=M6.sd[0].top + 0.06, y1=M6.sd[0].top + 0.36, net="OUT")
c.wire(c1, [out_top, (out_top.cx, M7.sd[0].top + 0.22)], net="OUT", width=0.3)
c.via(c0, c1, at=(out_top.cx, M7.sd[0].top + 0.22), net="OUT")

# ---- ports (all on metal) ----
gate_port("INN", M1.gates[0], "INN")
gate_port("INP", M2.gates[0], "INP")
c.port("IB", on=M8.sd[1], dir="in")
c.port("VDD", on=VDD)
c.port("VSS", on=VSS)
c.port("OUT", on=out_top, dir="out")

TOP = c

```