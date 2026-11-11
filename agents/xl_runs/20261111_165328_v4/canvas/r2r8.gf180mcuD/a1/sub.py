from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1          # c0 = m1 (first conductor), c1 = m2
assert "res_poly" in tech.d["devices"], "gf180mcuD must have res_poly"

# ------------------------------------------------------------------ netlist
# 25 unit poly resistors, each W=1u L=6u (ppolyf_u).  Topology:
#   VSS -XRT1- t -XRT2- n0 -XRS0- n1 -XRS1- n2 ... n6 -XRS6- OUT   (spine)
#   each n_i (and OUT) -XRA_i- x_i -XRB_i- B_i                      (bit taps)
# All resistors identical orientation is "good practice, not judged";
# here the spine runs horizontally and the taps/terminator run vertically,
# which is the natural, compact R-2R embedding.

RW, RL = 1.0, 6.0                  # drawn W, L of every unit resistor
SPINE_Y = 0.0                      # spine runs along y = 0
PITCH_X = 8.0                      # centre-to-centre of spine nodes
TAP_XOFF = 4.0                     # tap column x offset from its spine node
TAP_PITCH_Y = 8.0                  # vertical pitch inside a tap column

c = Cell("r2r8")

def res(name, nets, x, y, orient="h"):
    """Place one unit resistor and return it."""
    return c.resistor("res_poly", w=RW, l=RL, at=(x, y), nets=nets,
                      orient=orient)

# ------------------------------------------------------------------ spine
# spine nodes n0..n6, OUT at x = 0,8,16,...,56 ; VSS at x=-8 (left end)
spine = ["VSS"] + ["n%d" % i for i in range(7)] + ["OUT"]
sx = {name: -8.0 + i * PITCH_X for i, name in enumerate(spine)}
# VSS(-8) -XRT1- t(-8,-8) -XRT2- n0(0) ; then XRS0..XRS6 along the spine
res("RT1", ("VSS", "t"), sx["VSS"], SPINE_Y - TAP_PITCH_Y, orient="v")
res("RT2", ("t", "n0"),  sx["VSS"], SPINE_Y, orient="v")
for i in range(7):
    res("RS%d" % i, ("n%d" % i, "n%d" % (i + 1) if i < 6 else "OUT"),
        sx["n%d" % i], SPINE_Y, orient="h")

# ------------------------------------------------------------------ bit taps
# n_i -XRA_i- x_i -XRB_i- B_i   (vertical column at x = sx[n_i] + TAP_XOFF)
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    tx = sx[node] + TAP_XOFF
    res("RA%d" % i, (node, "x%d" % i), tx, SPINE_Y, orient="v")
    res("RB%d" % i, ("x%d" % i, "B%d" % i), tx, SPINE_Y + TAP_PITCH_Y, orient="v")

# ------------------------------------------------------------------ guard ring
# substrate guard ring around the whole array, tied to VSS
xs = [sx[n] for n in spine] + [sx[n] + TAP_XOFF for n in ("n0", "n6", "OUT")]
ys = [SPINE_Y - TAP_PITCH_Y, SPINE_Y, SPINE_Y + TAP_PITCH_Y,
      SPINE_Y + 2 * TAP_PITCH_Y]
ring = c.guard_ring("ptap", x0=min(xs) - 1.5, x1=max(xs) + 1.5,
                    y0=min(ys) - 1.5, y1=max(ys) + 1.5, net="VSS", space=1.0)

# ------------------------------------------------------------------ ports
c.port("VSS", on=ring.straps[0])
c.port("OUT", on=c.resistor if False else None)  # placeholder, replaced below

# OUT port: on the right end of the last spine resistor (RS6)
rs6 = None
# find RS6 shape: it's the last spine resistor; reconnect via its net
# We'll attach OUT to the m1 pad of RS6's right end by locating the shape named OUT net.
# Simpler: place a small m1 port bar at the OUT node and short it to RS6.
outpad = c.rect(c0, x0=sx["OUT"] - 0.6, x1=sx["OUT"] + 0.6,
                y0=SPINE_Y - 0.6, y1=SPINE_Y + 0.6, net="OUT")
c.port("OUT", on=outpad)

# bit ports B0..B7 : on the top pad of each RB resistor
for i in range(8):
    tx = sx[("n%d" % i) if i < 7 else "OUT"] + TAP_XOFF
    rb = None
    # locate the RB resistor shape by net name B%i
    for s in c.shapes:
        if getattr(s, "net", None) == "B%d" % i:
            rb = s
            break
    c.port("B%d" % i, on=rb, dir="in")

TOP = c
