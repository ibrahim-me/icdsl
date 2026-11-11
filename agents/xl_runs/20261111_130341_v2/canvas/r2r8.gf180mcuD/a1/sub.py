from icdsl.canvas import *

tech = use()
c0 = tech.c0                      # m1 on gf180mcuD
m1 = tech.metal(1)                # m2
poly = "poly"
diff = "diff"

# ------------------------------------------------------------------ resistor
def unit_res(c, x, y, nets, orient="h"):
    """One ppolyf_u unit resistor: W=1u, L=6u (drawn), poly over diff."""
    rw, rl = 1.0, 6.0
    if orient == "h":
        pd = c.rect(diff, x0=x, y0=y - rw / 2, x1=x + rl, y1=y + rw / 2)
        pp = c.rect(poly, x0=x + rl / 2 - rw / 2, y0=y - rl / 2,
                    x1=x + rl / 2 + rw / 2, y1=y + rl / 2)
        pa = c.rect(c0, x0=x - 0.2, y0=y - rw / 2 - 0.2,
                    x1=x + 0.2, y1=y + rw / 2 + 0.2, net=nets[0])
        pb = c.rect(c0, x0=x + rl - 0.2, y0=y - rw / 2 - 0.2,
                    x1=x + rl + 0.2, y1=y + rw / 2 + 0.2, net=nets[1])
        return pa, pb, (x + rl, y)
    else:
        pd = c.rect(diff, x0=x - rw / 2, y0=y, x1=x + rw / 2, y1=y + rl)
        pp = c.rect(poly, x0=x - rl / 2, y0=y + rl / 2 - rw / 2,
                    x1=x + rl / 2, y1=y + rl / 2 + rw / 2)
        pa = c.rect(c0, x0=x - rw / 2 - 0.2, y0=y - 0.2,
                    x1=x + rw / 2 + 0.2, y1=y + 0.2, net=nets[0])
        pb = c.rect(c0, x0=x - rw / 2 - 0.2, y0=y + rl - 0.2,
                    x1=x + rw / 2 + 0.2, y1=y + rl + 0.2, net=nets[1])
        return pa, pb, (x, y + rl)

# ------------------------------------------------------------------ build
c = Cell("r2r8")
PITCH = 9.0                       # horizontal pitch per bit stage
x = 1.0
y = 6.0

# terminating 2R leg: VSS --R-- t --R-- n0  (t floating midpoint)
pa, pb, end = unit_res(c, x, y, ("VSS", "t"))   # XRT1 VSS-t
x = end[0] + PITCH
pa, pb, end = unit_res(c, x, y, ("n0", "t"))    # XRT2 n0-t
n0x = x
x = end[0] + PITCH

# bit stages B0..B6 : each stage  R(n_i-1, x_i), R(B_i, x_i), R(n_i-1, n_i)
for i in range(7):
    nin = "VSS" if i == 0 else "n%d" % (i - 1)
    nout = "n%d" % i
    pa, pb, end = unit_res(c, x, y, (nin, "x%d" % i))   # XRAi
    x = end[0] + PITCH
    pa, pb, end = unit_res(c, x, y, ("B%d" % i, "x%d" % i))  # XRBi
    x = end[0] + PITCH
    pa, pb, end = unit_res(c, x, y, (nin, nout))        # XRSi
    x = end[0] + PITCH

# last stage : R(n6, OUT), R(OUT, x7), R(B7, x7)
pa, pb, end = unit_res(c, x, y, ("n6", "OUT"))          # XRS6
x = end[0] + PITCH
pa, pb, end = unit_res(c, x, y, ("OUT", "x7"))          # XRA7
x = end[0] + PITCH
pa, pb, end = unit_res(c, x, y, ("B7", "x7"))           # XRB7
x = end[0] + PITCH

# ------------------------------------------------------------------ pins
def pin(net, shape, d):
    c.port(net, on=shape, dir=d)

# VSS pin on the first resistor's VSS pad (need a handle): re-derive a VSS pad at left edge
vss_pad = c.rect(c0, x0=0.0, y0=y - 0.2, x1=0.6, y1=y + 0.2, net="VSS")
pin("VSS", vss_pad, "in")
for i in range(8):
    # B_i pin: place a small c0 pad at the B_i resistor pad location -> reuse by drawing a dedicated pad
    bp = c.rect(c0, x0=0.0, y0=y - 0.2 + (i + 1) * 2.6, x1=0.6, y1=y + 0.2 + (i + 1) * 2.6, net="B%d" % i)
    pin("B%d" % i, bp, "in")
outp = c.rect(c0, x0=x - 0.6, y0=y - 0.2, x1=x, y1=y + 0.2, net="OUT")
pin("OUT", outp, "out")

TOP = c
