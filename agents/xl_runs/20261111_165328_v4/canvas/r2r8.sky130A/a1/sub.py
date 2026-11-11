from icdsl.canvas import *

tech = use()
c0, m1 = tech.c0, tech.metal(1)
PW = tech.width(m1)
VS = tech.space(m1)
ENC = tech.enc(m1, "via") if False else 0.07

c = Cell("r2r8")

RW, RL = 1.0, 6.0          # unit resistor: w=1, l=6 (sky130)
PITCH = RL + 1.6           # horizontal pitch of chain nodes
VSTEP = RL + 1.4           # vertical step between the two resistors of a 2R branch
X0, Y0 = 2.0, 2.0          # start of chain (node t)

def res(name, x, y, orient, nets):
    return c.resistor("res_poly", w=RW, l=RL, at=(x, y), orient=orient, nets=nets)

def link(p, q):
    """connect c0 pad p to c0 pad q with m1 + vias (p,q may be pads or m1 shapes)."""
    if hasattr(p, "lower"):
        p = p.upper
    if hasattr(q, "lower"):
        q = q.lower
    c.via(c0, m1, at=(p.cx, p.cy), net=p.net or "x", dir="v", top_dir="h")
    c.via(c0, m1, at=(q.cx, q.cy), net=q.net or "x", dir="v", top_dir="h")
    c.wire(m1, [p, q], width=PW, net=(p.net or q.net or "x"), first="h")

# ---------- main chain: t -n0- n1- ... -n6- OUT (8 resistors) ----------
chain = ["t", "n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]
prev = None
for i, node in enumerate(chain):
    x = X0 + i * PITCH
    r = res("R", x, Y0, "h", (node, node + "_r"))
    if prev is not None:
        link(prev.sd[1] if hasattr(prev, "sd") else prev.b, r.a)
    prev = r
    if node == "t":
        t_right = r.b
    if node == "OUT":
        out_left = r.a

# ---------- VSS termination at t: RT1 from t down to VSS ----------
rv = res("RV", X0, Y0 - VSTEP, "v", ("t", "VSS"))
link(t_right, rv.a)          # t_right (c0 pad) -> top of vertical resistor
c.via(c0, m1, at=(rv.b.cx, rv.b.cy), net="VSS", dir="v", top_dir="h")
vss_rail = c.rect(m1, x0=rv.b.cx - PW, x1=rv.b.cx + PW,
                  y0=rv.b.top + VS, y1=rv.b.top + VS + PW, net="VSS")
c.wire(m1, [rv.b, vss_rail], width=PW, net="VSS", first="h")

# ---------- 2R branches at n0..n6 and OUT ----------
for i, node in enumerate(["n0", "n1", "n2", "n3", "n4", "n5", "n6", "OUT"]):
    x = X0 + i * PITCH
    bit = "B%d" % i
    r1 = res("RA%d" % i, x, Y0 - VSTEP, "v", (node, "xi%d" % i))
    r2 = res("RB%d" % i, x, Y0 - 2 * VSTEP, "v", ("xi%d" % i, bit))
    link(getattr(locals().get("r_prev_" + str(i - 1)), "b", None) if False else None, r1.a) if False else None
    # top of r1 to chain node
    chain_res = None
    # find the chain resistor whose left pad is at this node
    link_top = None
    # we stored chain resistors implicitly; reconnect via the node's left pad:
    # the chain resistor at position i has .a at the node
    link_top = c.rect  # placeholder
    # connect r1.a (top) to the chain node pad:
    # chain resistor i left pad = r.a ; we need it. Rebuild chain keeping refs.
    break
