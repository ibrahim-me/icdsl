from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1

# ------------------------------------------------------------------
# R-2R ladder, 8-bit.  25 unit poly resistors, r_width=1u l_length=6u.
# Netlist connectivity (resistor between first two nodes, 3rd is bulk=VSS):
#   t--VSS (RT1), n0--t (RT2), n0--x0 (RA0), B0--x0 (RB0), n0--n1 (RS0),
#   n1--x1 (RA1), B1--x1 (RB1), n1--n2 (RS1), ... n6--OUT (RS6), OUT--x7 (RA7), B7--x7 (RB7)
# ------------------------------------------------------------------

W, L = 1.0, 6.0          # drawn resistor W and L (um)
pitch = 2.6              # centre-to-centre pitch of adjacent resistors
tap_w = 1.2              # metal strap width
c0_w = max(tech.width(c0), 0.3)

c = Cell("r2r8")

def resistor(name, a, b, at, orient="h"):
    """One unit poly resistor; returns the c.resistor object."""
    r = c.resistor("res_poly", w=W, l=L, at=at, nets=(a, b), orient=orient)
    return r

# ---- place all 25 resistors --------------------------------------
# Node t is the left end of the ladder (terminating leg to VSS).
# We lay the chain out as a single serpentine strip of resistors so
# every resistor has identical orientation (horizontal) and the
# metal1 straps between consecutive nodes run straight along the top.

# x positions: node n_i at x = i*pitch, node t at x = -pitch
# resistor between node i and node i+1 sits at x = (i+0.5)*pitch
# resistor between B_i and x_i sits below the chain at x = i*pitch

res = {}   # name -> resistor object

# RT1: VSS -- t   (terminating 2R leg, drawn as two unit R's: VSS-t)
# Actually RT1 is one unit R from VSS to t, RT2 is one unit R from n0 to t.
# Together n0 sees 2R to VSS via t.  Place RT1 left of t, RT2 right of t.
xt = -pitch                      # x of node t
res["RT1"] = resistor("RT1", "VSS", "t", at=(xt - pitch/2, 0), orient="h")
res["RT2"] = resistor("RT2", "n0", "t", at=(xt + pitch/2, 0), orient="h")

# main chain: n0..n6, OUT and x0..x7
# node n_i at x = i*pitch (i=0..6), node OUT at x = 7*pitch
# node x_i at x = i*pitch, y = -pitch  (i=0..7)
for i in range(7):
    # RS_i: n_i -- n_{i+1}   (for i=0..5), RS_6: n6 -- OUT
    a = "n%d" % i
    b = "n%d" % (i + 1) if i < 6 else "OUT"
    res["RS%d" % i] = resistor("RS%d" % i, a, b, at=((i + 0.5) * pitch, 0), orient="h")
    # RA_i: n_i -- x_i
    res["RA%d" % i] = resistor("RA%d" % i, "n%d" % i, "x%d" % i, at=(i * pitch, -pitch), orient="h")
    # RB_i: B_i -- x_i
    res["RB%d" % i] = resistor("RB%d" % i, "B%d" % i, "x%d" % i, at=(i * pitch, -2 * pitch), orient="h")
# RA7: OUT -- x7
res["RA7"] = resistor("RA7", "OUT", "x7", at=(7 * pitch, -pitch), orient="h")
# RB7: B7 -- x7
res["RB7"] = resistor("RB7", "B7", "x7", at=(7 * pitch, -2 * pitch), orient="h")

# ---- metal1 straps to interconnect the resistor ends -------------
# Each resistor has pads r.a and r.b on c0 (m1).  We connect them with
# c1 straps and vias.  Simpler: run a continuous c1 bus along each node
# and strap each resistor terminal to the bus with a via.

# Collect terminal points per net.
from collections import defaultdict
terms = defaultdict(list)   # net -> list of (shape, padname)
for name, r in res.items():
    terms[r.nets[0]].append((r.a, "a"))
    terms[r.nets[1]].append((r.b, "b"))

# For each net, draw a c1 trunk that passes through all terminal pads,
# then via each pad to the trunk.
for net, pads in terms.items():
    if net == "VSS":
        continue  # VSS handled by the guard ring / rail
    xs = [p[0].cx for p in pads]
    ys = [p[0].cy for p in pads]
    x0, x1 = min(xs), max(xs)
    y0, y1 = min(ys), max(ys)
    # trunk: horizontal at the median y, spanning all x
    my = (y0 + y1) / 2
    trunk = c.rect(c1, x0=x0 - 0.6, x1=x1 + 0.6, y0=my - c0_w / 2, y1=my + c0_w / 2, net=net)
    # also a vertical segment at each distinct x to reach pads off the trunk line
    for pad, _ in pads:
        v = c.via(c0, c1, at=(pad.cx, pad.cy), net=net, dir="h")
        # connect pad (c0) to trunk (c1): via already does c0->c1 at pad location
        # make sure trunk covers the via: extend trunk vertically at this x
        c.rect(c1, x0=pad.cx - c0_w / 2, x1=pad.cx + c0_w / 2,
               y0=min(pad.cy, my) - c0_w / 2, y1=max(pad.cy, my) + c0_w / 2, net=net)

# ---- VSS rail: horizontal c1 strap at the bottom, tied to guard ring ----
vss_y = -3.2 * pitch
vss_rail = c.rect(c1, x0=xt - 2 * pitch, x1=7 * pitch + 2 * pitch,
                  y0=vss_y - c0_w / 2, y1=vss_y + c0_w / 2, net="VSS")
# connect every resistor whose terminal is VSS (RT1) and the bulk terminals
# All resistor bulks are VSS: strap each resistor body?  For poly resistor the
# bulk is implicit; we just tie the VSS rail to the guard ring.
# RT1: VSS terminal already on the chain; strap it to the VSS rail.
for pad, _ in terms["VSS"]:
    c.via(c0, c1, at=(pad.cx, vss_y), net="VSS", dir="v")
    c.rect(c1, x0=pad.cx - c0_w / 2, x1=pad.cx + c0_w / 2,
           y0=min(pad.cy, vss_y) - c0_w / 2, y1=max(pad.cy, vss_y) + c0_w / 2, net="VSS")

# ---- substrate guard ring (ptap) around the whole array, tied to VSS ----
pad_x0 = xt - 2.2 * pitch
pad_x1 = 7 * pitch + 2.2 * pitch
pad_y0 = -2.6 * pitch - 0.8
pad_y1 = 0.8
gr = c.guard_ring("ptap", x0=pad_x0, y0=pad_y0, x1=pad_x1, y1=pad_y1, net="VSS", space=1.0)
# tie guard ring strap to VSS rail
c.via(c0, c1, at=(gr.straps[0].cx, vss_y), net="VSS", dir="v")
c.rect(c1, x0=gr.straps[0].cx - c0_w / 2, x1=gr.straps[0].cx + c0_w / 2,
       y0=min(gr.straps[0].cy, vss_y) - c0_w / 2, y1=max(gr.straps[0].cy, vss_y) + c0_w / 2, net="VSS")

# ---- ports --------------------------------------------------------
for i in range(8):
    # B_i port: strap from RB_i 'a' pad up to a c1 port line at top
    pad = res["RB%d" % i].a
    c.port("B%d" % i, on=pad, dir="in")
c.port("OUT", on=res["RA7"].b, dir="out")
c.port("VSS", on=vss_rail, dir="inout")

TOP = c
