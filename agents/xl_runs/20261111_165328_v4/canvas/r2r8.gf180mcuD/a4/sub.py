from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1
assert "res_poly" in tech.d["devices"]

# ------------------------------------------------------------------ netlist
# 25 unit poly resistors, ppolyf_u, drawn W=1u L=6u.
# Spine:  VSS -RT1- t -RT2- n0 -RS0- n1 ... n6 -RS6- OUT   (horizontal, y=0)
# Taps:   n_i -RA_i- x_i -RB_i- B_i   (vertical, going up from each spine node)
# Every resistor body is isolated; its two ends are joined to neighbours by
# short m1 jumpers so no resistor PCell structures touch each other.

RW, RL = 1.0, 6.0
GAP = 3.0                         # gap between resistor bodies (m1 jumper fills it)
SPINE_Y = 0.0

c = Cell("r2r8")

# node x-positions along the spine (m1 connection points)
sx = {}
sx["VSS"] = -16.0
sx["t"]   = sx["VSS"] + RL + GAP          # -7
sx["n0"]  = sx["t"]   + RL + GAP          # 2
for i in range(1, 7):
    sx["n%d" % i] = sx["n%d" % (i-1)] + RL + GAP
sx["OUT"] = sx["n6"] + RL + GAP           # 50

def res_h(name, nets, xc):
    """Horizontal resistor body centred at xc, y=SPINE_Y. Returns (left_pad, right_pad) m1 shapes."""
    r = c.resistor("res_poly", w=RW, l=RL, at=(xc, SPINE_Y), nets=nets, orient="h")
    # m1 pads at the two ends of the resistor (the PCell pads may be too close to poly;
    # we place our own m1 rectangles on the contact pads)
    return r.a, r.b

def res_v(name, nets, xc, yc):
    r = c.resistor("res_poly", w=RW, l=RL, at=(xc, yc), nets=nets, orient="v")
    return r.a, r.b

# ---- spine resistors (horizontal)
ra, rb = res_h("RT1", ("VSS", "t"), (sx["VSS"] + sx["t"]) / 2)
ra, rb = res_h("RT2", ("t", "n0"), (sx["t"] + sx["n0"]) / 2)
for i in range(7):
    a = "n%d" % i
    b = "n%d" % (i + 1) if i < 6 else "OUT"
    res_h("RS%d" % i, (a, b), (sx[a] + sx[b]) / 2)

# ---- tap resistors (vertical), stacked above each spine node
for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    x = sx[node]
    res_v("RA%d" % i, (node, "x%d" % i), x, SPINE_Y + RL + GAP / 2)
    res_v("RB%d" % i, ("x%d" % i, "B%d" % i), x, SPINE_Y + 2 * RL + 3 * GAP / 2)

# ---- m1 jumpers: connect the right pad of each spine resistor to the left pad of the next
#    (same net at each node).  Also connect tap stacks.
def join(pads, net):
    """Join a list of m1 pad shapes with m1 rectangles so they form one node."""
    pts = [p for p in pads]
    if len(pts) < 2:
        return
    # sort by position along the connection direction
    xs = [p.cx for p in pts]; ys = [p.cy for p in pts]
    if max(xs) - min(xs) > max(ys) - min(ys):
        pts.sort(key=lambda p: p.cx)
        for a, b in zip(pts, pts[1:]):
            c.rect(c0, x0=a.right, x1=b.left, y0=min(a.bottom, b.bottom) - 0.2,
                   y1=max(a.top, b.top) + 0.2, net=net)
    else:
        pts.sort(key=lambda p: p.cy)
        for a, b in zip(pts, pts[1:]):
            c.rect(c0, x0=min(a.left, b.left) - 0.2, x1=max(a.right, b.right) + 0.2,
                   y0=a.top, y1=b.bottom, net=net)

# collect pads per net for the spine
spine_pads = {}
# We need the pads; re-capture them. Simpler: rebuild with pad capture.
# (The above res_h/res_v calls discarded pads; redo cleanly below.)

# ---- redo cleanly, capturing pads
c = Cell("r2r8")

def res_h2(name, nets, xc):
    r = c.resistor("res_poly", w=RW, l=RL, at=(xc, SPINE_Y), nets=nets, orient="h")
    return r

def res_v2(name, nets, xc, yc):
    r = c.resistor("res_poly", w=RW, l=RL, at=(xc, yc), nets=nets, orient="v")
    return r

spine_pads = {n: [] for n in sx}
tap_pads = {}   # net -> [pad]

r1 = res_h2("RT1", ("VSS", "t"), (sx["VSS"] + sx["t"]) / 2)
spine_pads["VSS"].append(r1.a); spine_pads["t"].append(r1.b)
r2 = res_h2("RT2", ("t", "n0"), (sx["t"] + sx["n0"]) / 2)
spine_pads["t"].append(r2.a); spine_pads["n0"].append(r2.b)
for i in range(7):
    a = "n%d" % i
    b = "n%d" % (i + 1) if i < 6 else "OUT"
    r = res_h2("RS%d" % i, (a, b), (sx[a] + sx[b]) / 2)
    spine_pads[a].append(r.a); spine_pads[b].append(r.b)

for i in range(8):
    node = "n%d" % i if i < 7 else "OUT"
    x = sx[node]
    ra = res_v2("RA%d" % i, (node, "x%d" % i), x, SPINE_Y + RL + GAP / 2)
    spine_pads[node].append(ra.a)
    tap_pads.setdefault("x%d" % i, []).append(ra.b)
    rb = res_v2("RB%d" % i, ("x%d" % i, "B%d" % i), x, SPINE_Y + 2 * RL + 3 * GAP / 2)
    tap_pads["x%d" % i].append(rb.a)
    tap_pads["B%d" % i] = [rb.b]

# join pads of each net with m1
for net, plist in spine_pads.items():
    join(plist, net)
for net, plist in tap_pads.items():
    join(plist, net)

# ---- substrate guard ring around the whole array, tied to VSS
allx = list(sx.values())
ally = [SPINE_Y, SPINE_Y + 2 * RL + 2 * GAP]
ring = c.guard_ring("ptap",
                    around=(min(allx) - 2.0, min(ally) - 2.0,
                            max(allx) + 2.0, max(ally) + 2.0),
                    space=1.0, net="VSS", well=False)
# tie VSS spine pad to ring strap
join(spine_pads["VSS"] + [ring.straps[0]], "VSS")

# ---- ports
c.port("VSS", on=ring.straps[0])
c.port("OUT", on=spine_pads["OUT"][-1])
for i in range(8):
    c.port("B%d" % i, on=tap_pads["B%d" % i][0], dir="in")

TOP = c



