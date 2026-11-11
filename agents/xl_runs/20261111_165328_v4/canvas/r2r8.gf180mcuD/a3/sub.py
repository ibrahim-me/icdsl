from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1, first conductor
assert "res_poly" in tech.d["devices"], "gf180mcuD needs res_poly"

# ------------------------------------------------------------------ netlist
# 25 unit poly resistors, ppolyf_u, drawn W=1u L=6u.
# Spine (horizontal, y=0):  VSS -RT1- t -RT2- n0 -RS0- n1 -RS1- n2 ... n6 -RS6- OUT
# Bit taps (vertical at each spine node): n_i -RA_i- x_i -RB_i- B_i   (i=0..6), OUT -RA7- x7 -RB7- B7
# Terminals that share a net are co-located so they connect naturally; no extra node bars.

RW, RL = 1.0, 6.0
PITCH = 8.0
SPINE_Y = 0.0

c = Cell("r2r8")

# ---- spine nodes along x
sx = {"VSS": -12.0, "t": -6.0}
for i in range(7):
    sx["n%d" % i] = 0.0 + i * PITCH          # 0, 8, 16, ..., 48
sx["OUT"] = 56.0

# spine resistors, end-to-end horizontally
c.resistor("res_poly", w=RW, l=RL, at=((sx["VSS"] + sx["t"]) / 2, SPINE_Y),
           nets=("VSS", "t"), orient="h")                    # RT1
c.resistor("res_poly", w=RW, l=RL, at=((sx["t"] + sx["n0"]) / 2, SPINE_Y),
           nets=("t", "n0"), orient="h")                      # RT2
for i in range(7):
    a = "n%d" % i
    b = "n%d" % (i + 1) if i < 6 else "OUT"
    c.resistor("res_poly", w=RW, l=RL, at=((sx[a] + sx[b]) / 2, SPINE_Y),
               nets=(a, b), orient="h")                       # RS0..RS6

# bit taps: n_i -RA_i- x_i -RB_i- B_i   (vertical, going up from each spine node)
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    x = sx[node]
    c.resistor("res_poly", w=RW, l=RL, at=(x, SPINE_Y + RL),
               nets=(node, "x%d" % i), orient="v")            # RA_i: n_i -> x_i
    c.resistor("res_poly", w=RW, l=RL, at=(x, SPINE_Y + 2 * RL),
               nets=("x%d" % i, "B%d" % i), orient="v")       # RB_i: x_i -> B_i

# ---- substrate guard ring around the array, tied to VSS
allx = [sx[n] for n in ("VSS", "t", "n0", "n6", "OUT")]
ally = [SPINE_Y, SPINE_Y + 3 * RL]
ring = c.guard_ring("ptap",
                    around=(min(allx) - 2.0, min(ally) - 2.0,
                            max(allx) + 2.0, max(ally) + 2.0),
                    space=1.0, net="VSS", well=False)

# tie the VSS spine terminal to the ring strap
vss_pad = c.rect(c0, x0=sx["VSS"] - RL / 2 - 0.4, x1=sx["VSS"] - RL / 2 + 0.4,
                 y0=SPINE_Y - 0.4, y1=SPINE_Y + 0.4, net="VSS")
c.rect(c0, x0=min(vss_pad.left, ring.straps[0].left) - 0.2,
       x1=max(vss_pad.right, ring.straps[0].right) + 0.2,
       y0=min(vss_pad.bottom, ring.straps[0].bottom) - 0.2,
       y1=max(vss_pad.top, ring.straps[0].top) + 0.2, net="VSS")

# ---- ports
c.port("VSS", on=ring.straps[0])
c.port("OUT", on=c.rect(c0, x0=sx["OUT"] + RL / 2 - 0.4, x1=sx["OUT"] + RL / 2 + 0.4,
                        y0=SPINE_Y - 0.4, y1=SPINE_Y + 0.4, net="OUT"))
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    x = sx[node]
    c.port("B%d" % i, on=c.rect(c0, x0=x - 0.4, x1=x + 0.4,
                                y0=SPINE_Y + 3 * RL - 0.4, y1=SPINE_Y + 3 * RL + 0.4,
                                net="B%d" % i), dir="in")

TOP = c


