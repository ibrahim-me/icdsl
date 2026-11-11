```
"""ota_miller - two-stage Miller OTA, manual layout from netlist.spice.

freepdk45 has no poly resistor / MIM, so the compensation network is MOS-only:
M9 = triode resistor (gate VDD) between x and d2; MC = gate capacitor (gate OUT,
source/drain joined to x) between OUT and x.  NMOS bodies -> VSS, PMOS n-wells -> VDD.
"""
from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1
c2 = tech.conductor(2) if len(tech.stack) > 2 else c1
poly = "poly"
diff = "diff"
nwell = "nwell"
pwell = "pwell"

# ---------------------------------------------------------------- helpers
def MOS(cell, kind, w, l, nf, gate_net, sd_nets, at, body_net, gate_ext=(0.0, 0.0)):
    """Place one MOS (nf fingers) plus a body contact strap on body_net."""
    m = cell.mos(kind, w=w, l=l, nf=nf, gates=gate_net, sd=sd_nets, at=at,
                 gate_ext=gate_ext)
    # body contact: one c0 pad on the diffusion/well area tied to body_net
    if kind == "nmos":
        b = cell.rect(c0, x0=m.diff.left, x1=m.diff.right, y0=m.diff.bottom - 0.12,
                      y1=m.diff.bottom - 0.04, net=body_net)
        cell.via(diff, c0, at=(b.cx, b.cy), net=body_net)
    else:
        b = cell.rect(c0, x0=m.diff.left, x1=m.diff.right, y0=m.diff.top + 0.04,
                      y1=m.diff.top + 0.12, net=body_net)
        cell.via(diff, c0, at=(b.cx, b.cy), net=body_net)
    return m

def strap(cell, layer, net, x0, x1, y0, y1):
    return cell.rect(layer, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

def contact(cell, layers, at, net, dir="h"):
    return cell.via(layers[0], layers[1], at=at, net=net, dir=dir)

# ---------------------------------------------------------------- top cell
c = Cell("ota_miller")

# ---- global rails (m1 = c0) ---------------------------------------
VDD_rail = strap(c, c0, "VDD", 0, 40, 43.0, 44.2)
VSS_rail = strap(c, c0, "VSS", 0, 40, -3.2, -2.0)

# ---- first stage: NMOS diff pair M1/M2 (w=4, l=0.5, nf=2) ---------
# sources joined to tail, drains d1 (M1) and d2 (M2), gates INN/INP
M1 = MOS(c, "nmos", 4.0, 0.5, 2, "INN", ("d1", "tail"), (2.0, 2.0), "VSS")
M2 = MOS(c, "nmos", 4.0, 0.5, 2, "INP", ("d2", "tail"), (M1.diff.right + 0.6, 2.0), "VSS")
# join the two sources (tail) on c0
tail_bar = strap(c, c0, "tail", M1.sd[1].left, M2.sd[1].right, M1.sd[1].bottom, M1.sd[1].top)
c.wire(c0, [M1.sd[1], M2.sd[1]], net="tail", width=0.2)

# ---- PMOS load M3/M4 (w=4, l=1, nf=2) in n-well -------------------
# placed above the diff pair; M3 diode-connected (gate=d1), M4 gate=d1
M3 = MOS(c, "pmos", 4.0, 1.0, 2, "d1", ("d1", "VDD"), (2.0, M1.diff.top + 1.6), "VDD")
M4 = MOS(c, "pmos", 4.0, 1.0, 2, "d1", ("d2", "VDD"), (M3.diff.right + 0.6, M1.diff.top + 1.6), "VDD")
# n-well covering M3/M4
c.rect(nwell, x0=M3.diff.left - 0.6, x1=M4.diff.right + 0.6,
       y0=M3.diff.bottom - 0.6, y1=M3.diff.top + 0.6, net="VDD")
# M3 gate = d1: connect d1 node (M3.sd[0] / M3.gates) to M1 drain
c.wire(c0, [M1.sd[0], M3.sd[0]], net="d1", width=0.2)
# M4 gate = d1 already (gates net "d1"); M4 drain = d2
c.wire(c0, [M2.sd[0], M4.sd[0]], net="d2", width=0.2)

# ---- tail source M5 (w=2, l=1, nf=4), gate IB ---------------------
M5 = MOS(c, "nmos", 2.0, 1.0, 4, "IB", ("tail", "VSS"), (M2.diff.right + 1.0, 2.0), "VSS")
c.wire(c0, [tail_bar, M5.sd[1]], net="tail", width=0.2)

# ---- bias diode M8 (w=2, l=1, nf=2), gate=IB, between IB and VSS ---
M8 = MOS(c, "nmos", 2.0, 1.0, 2, "IB", ("IB", "VSS"), (M5.diff.right + 0.8, 2.0), "VSS")
c.wire(c0, [M8.sd[0], M8.sd[1]], net="IB", width=0.2)   # diode: both terminals to IB pin later

# ---- M9 triode resistor (w=2, l=0.5, nf=1), gate VDD, x <-> d2 ---
M9 = MOS(c, "nmos", 2.0, 0.5, 1, "VDD", ("x", "d2"), (M8.diff.right + 0.8, 2.0), "VSS")

# ---- output stage: PMOS M6 (w=4, l=0.5, nf=8), gate d2, OUT <-> VDD
M6 = MOS(c, "pmos", 4.0, 0.5, 8, "d2", ("OUT", "VDD"), (M4.diff.right + 1.2, M1.diff.top + 1.6), "VDD")
c.rect(nwell, x0=M6.diff.left - 0.6, x1=M6.diff.right + 0.6,
       y0=M6.diff.bottom - 0.6, y1=M6.diff.top + 0.6, net="VDD")

# ---- NMOS sink M7 (w=2, l=1, nf=8), gate IB, OUT <-> VSS ----------
M7 = MOS(c, "nmos", 2.0, 1.0, 8, "IB", ("OUT", "VSS"), (M6.diff.right + 1.0, 2.0), "VSS")

# ---- compensation capacitor MC (w=4, l=1, nf=8), gate OUT, x joined
MC = MOS(c, "nmos", 4.0, 1.0, 8, "OUT", ("x", "x"), (M7.diff.right + 1.0, 2.0), "VSS")
# MC source/drain both = x: join them
c.wire(c0, [MC.sd[0], MC.sd[1]], net="x", width=0.2)
# M9 source = d2, drain = x ; connect x node
c.wire(c0, [M9.sd[0], MC.sd[0]], net="x", width=0.2)

# ---- connect rails to device terminals -----------------------------
c.wire(c0, [VDD_rail, M3.sd[1]], net="VDD", width=0.2)
c.wire(c0, [VDD_rail, M4.sd[1]], net="VDD", width=0.2)
c.wire(c0, [VDD_rail, M6.sd[1]], net="VDD", width=0.2)
c.wire(c0, [VSS_rail, M1.sd[1]], net="VSS", width=0.2)   # via tail_bar already
c.wire(c0, [VSS_rail, M5.sd[0]], net="VSS", width=0.2)
c.wire(c0, [VSS_rail, M8.sd[1]], net="VSS", width=0.2)
c.wire(c0, [VSS_rail, M7.sd[1]], net="VSS", width=0.2)

# ---- ports ---------------------------------------------------------
c.port("INP", on=M2.gates[0], dir="in")
c.port("INN", on=M1.gates[0], dir="in")
c.port("IB",  on=M8.sd[0], dir="in")
c.port("VDD", on=VDD_rail)
c.port("VSS", on=VSS_rail)
# OUT: join M6.sd[0] and M7.sd[0] on c0, then port
out_bar = strap(c, c0, "OUT", M6.sd[0].left, M7.sd[0].right, M6.sd[0].bottom, M7.sd[0].top)
c.wire(c0, [M6.sd[0], out_bar], net="OUT", width=0.2)
c.wire(c0, [M7.sd[0], out_bar], net="OUT", width=0.2)
c.port("OUT", on=out_bar, dir="out")

TOP = c
```