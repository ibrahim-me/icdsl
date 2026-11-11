from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

c = Cell("r2r8")

R, L, GAP = 1.0, 6.0, 0.4          # unit resistor W=1, L=6; small gap between chain resistors
X0, Y0 = 1.0, 1.0                  # chain start
PITCH = 2.6                        # vertical pitch between stacked bit cells
SIDE = 6.0                         # horizontal half-length of a bit cell (RA+RB = 12 um)

def up(pad):
    """bring a resistor terminal (on c0) up to m1, return the m1 shape"""
    v = c.via(c0, m1, at=(pad.cx, pad.cy), net=pad.net)
    return v.upper

# ---------------- main chain (horizontal) ----------------
chain = [("RT1","VSS","t"),("RT2","t","n0")] + \
        [("RS%d"%i,"n%d"%i,"n%d"%(i+1)) for i in range(7)]
res = {}
x = X0
joint_x = {"VSS": X0}
for name, a, b in chain:
    res[name] = c.resistor("res_poly", w=R, l=L, at=(x, Y0), nets=(a, b), orient="h")
    joint_x[b] = x + L
    x += L + GAP
out_x = x - GAP                    # right end of RS6 -> OUT

# ---------------- bit cells stacked above the chain ----------------
for i in range(8):
    jx = joint_x["n%d"%i] if i < 7 else out_x
    jnet = "n%d"%i if i < 7 else "OUT"
    by = Y0 + 1.0 + PITCH * i      # row for this bit's two resistors
    # RA_i : joint n_i -> x_i   (horizontal)
    res["RA%d"%i] = c.resistor("res_poly", w=R, l=L, at=(jx - SIDE, by),
                               nets=(jnet, "x%d"%i), orient="h")
    # RB_i : x_i -> B_i         (horizontal, continues from RA)
    res["RB%d"%i] = c.resistor("res_poly", w=R, l=L, at=(jx, by),
                               nets=("x%d"%i, "B%d"%i), orient="h")

# ---------------- every terminal to m1 ----------------
term = {}
for name, r in res.items():
    for side in ("a", "b"):
        p = r.a if side == "a" else r.b
        term[(name, side)] = up(p)

# ---------------- route chain joints on m1 ----------------
c.wire(m1, [term[("RT1", "a")], (X0 - 2.0, Y0)], width=0.2, net="VSS")
prev = None
for name, a, b in chain:
    if prev is not None:
        c.wire(m1, [term[(prev, "b")], term[(name, "a")]], width=0.2, net=a)
    prev = name
c.wire(m1, [term[("RS6", "b")], (out_x + 2.0, Y0)], width=0.2, net="OUT")

# ---------------- route bit cells ----------------
for i in range(8):
    jx = joint_x["n%d"%i] if i < 7 else out_x
    jnet = "n%d"%i if i < 7 else "OUT"
    by = Y0 + 1.0 + PITCH * i
    # vertical: chain joint n_i -> up to RA_i left end
    c.wire(m1, [(jx, Y0 + 1.0), term[("RA%d"%i, "a")]], width=0.2, net=jnet)
    # RA_i right end (x_i) -> RB_i left end (x_i)  [they abut; same net x_i]
    c.wire(m1, [term[("RA%d"%i, "b")], term[("RB%d"%i, "a")]], width=0.2, net="x%d"%i)
    # RB_i right end (B_i) -> up one more metal layer to the pin (m2)
    tb = term[("RB%d"%i, "b")]
    v = c.via(m1, m2, at=(tb.cx, tb.cy), net="B%d"%i)
    c.rect(m2, w=1.6, h=0.4, cx=v.upper.cx, cy=by + 1.2, net="B%d"%i)

# ---------------- ports ----------------
c.port("VSS", on=c.rect(m1, w=1.6, h=0.4, cx=X0 - 2.0, cy=Y0, net="VSS"), dir="in")
c.port("OUT", on=c.rect(m1, w=1.6, h=0.4, cx=out_x + 2.0, cy=Y0, net="OUT"), dir="out")
for i in range(8):
    jx = joint_x["n%d"%i] if i < 7 else out_x
    by = Y0 + 1.0 + PITCH * i
    c.port("B%d"%i, on=c.rect(m2, w=1.6, h=0.4, cx=jx, cy=by + 1.2, net="B%d"%i), dir="in")

TOP = c


