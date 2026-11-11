from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------- parameters (gf180mcuD) ----------------
L = 0.28
pw = 0.72   # pmos width
nw = 0.36   # nmos width
gx = 1.10   # column pitch
row_p = 3.6     # pmos row centre
row_n = 0.0     # nmos row centre
m1w = 0.30
m2w = 0.45
cpad = 0.55     # m1 contact pad

def pad(cx, cy, w=cpad, h=cpad):
    return (cx - w/2, cy - h/2, cx + w/2, cy + h/2)

# ---------------- dff cell ----------------
dff = Cell("dff")

def mos(kind, x, y, w, gate_net, s_net, d_net):
    t = dff.mos(kind, w=w, l=L, gates=gate_net, sd=(s_net, d_net), at=(x, y), well=False)
    return t

# transistor placement: (name, kind, x, y, w, gate, source, drain)
devs = [
 # master latch pmos (row_p)
 ("p0_0","pmos",0*gx,row_p,pw,"CK","CKB","VDD"),
 ("p0_1","pmos",1*gx,row_p,pw,"D","VDD","p1"),
 ("p0_2","pmos",2*gx,row_p,pw,"CK","p1","m"),
 ("p0_3","pmos",3*gx,row_p,pw,"CKB","m","p2"),
 ("p0_4","pmos",4*gx,row_p,pw,"mb","VDD","p2"),
 ("p0_5","pmos",5*gx,row_p,pw,"m","VDD","mb"),
 # master latch nmos (row_n)
 ("n0_0","nmos",0*gx,row_n,nw,"CK","CKB","VSS"),
 ("n0_1","nmos",1*gx,row_n,nw,"D","VSS","n1"),
 ("n0_2","nmos",2*gx,row_n,nw,"CKB","n1","m"),
 ("n0_3","nmos",3*gx,row_n,nw,"CK","m","n2"),
 ("n0_4","nmos",4*gx,row_n,nw,"mb","n2","VSS"),
 ("n0_5","nmos",5*gx,row_n,nw,"m","VSS","mb"),
 # slave latch pmos (row_p)
 ("p7_0","pmos",6*gx,row_p,pw,"Q","VDD","p3"),
 ("p7_1","pmos",7*gx,row_p,pw,"CK","p3","s"),
 ("p7_2","pmos",8*gx,row_p,pw,"CKB","s","p4"),
 ("p7_3","pmos",9*gx,row_p,pw,"mb","VDD","p4"),
 ("p7_4","pmos",10*gx,row_p,pw,"s","VDD","Q"),
 # slave latch nmos (row_n)
 ("n7_0","nmos",6*gx,row_n,nw,"Q","VSS","n3"),
 ("n7_1","nmos",7*gx,row_n,nw,"CKB","n3","s"),
 ("n7_2","nmos",8*gx,row_n,nw,"CK","s","n4"),
 ("n7_3","nmos",9*gx,row_n,nw,"mb","n4","VSS"),
 ("n7_4","nmos",10*gx,row_n,nw,"s","VSS","Q"),
]

tr = {}
for name, kind, x, y, w, g, s, d in devs:
    tr[name] = mos(kind, x, y, w, g, s, d)

# collect m1-connectable terminals per net: (shape, net)
from collections import defaultdict
terms = defaultdict(list)

def add(shape, net):
    terms[net].append(shape)

# diffusion source/drain straps are already on c0==m1; gate needs a contact pad on m1
for name, t in tr.items():
    kind = name[0]
    # source strap sd[0], drain strap sd[1]
    # find nets from devs
    pass

# rebuild net map from devs
net_of = {}
for name, kind, x, y, w, g, s, d in devs:
    net_of[name] = (g, s, d)

for name, t in tr.items():
    kind = name[0]
    g, s, d = net_of[name]
    # gate: poly -> m1 contact pad on poly extension above the diffusion
    gp = t.gates[0]
    gcx, gcy = gp.cx, gp.top + 0.42
    gpad = dff.rect(m1, *pad(gcx, gcy), net=g)
    dff.via("poly", c0, at=(gcx, gcy), net=g)
    add(gpad, g)
    # source / drain straps (already m1)
    add(t.sd[0], s)
    add(t.sd[1], d)

# route each net on m1: vertical spine + horizontal runs to each terminal
def route_net(net, ts):
    if not ts:
        return
    xs = [t.cx for t in ts]
    mx = sum(xs) / len(xs)
    y0 = min(t.bottom for t in ts) - m1w/2
    y1 = max(t.top for t in ts) + m1w/2
    dff.rect(m1, mx - m1w/2, y0, mx + m1w/2, y1, net=net)
    for t in ts:
        x0 = min(t.left, mx); x1 = max(t.right, mx)
        dff.rect(m1, x0, t.cy - m1w/2, x1, t.cy + m1w/2, net=net)

for net, ts in terms.items():
    route_net(net, ts)

# wells: nwell for pmos row, pwell for nmos row, tied to VDD / VSS
xmin = -0.6; xmax = 10*gx + 0.6
nwell = dff.rect("nwell", xmin, row_p - pw/2 - 0.5, xmax, row_p + pw/2 + 0.5, net="VDD")
pwell = dff.rect("pwell", xmin, row_n - nw/2 - 0.5, xmax, row_n + nw/2 + 0.5, net="VSS")
# well contacts
ntap = dff.tap("ntap", x0=xmax-0.9, y0=row_p-pw/2-0.55, x1=xmax-0.3, y1=row_p+pw/2+0.55, net="VDD")
ptap = dff.tap("ptap", x0=xmax-0.9, y0=row_n-nw/2-0.55, x1=xmax-0.3, y1=row_n+nw/2+0.55, net="VSS")
# connect well straps to rails
dff.rect(m1, ntap.strap.left, ntap.strap.bottom, ntap.strap.right, row_p + pw/2 + 0.55, net="VDD")
dff.rect(m1, ptap.strap.left, ptap.strap.bottom, ptap.strap.right, row_n - nw/2 - 0.55, net="VSS")

# edge ports
W = xmax - xmin
D_shape = dff.rect(m1, xmin - 1.4, row_n - m1w/2, xmin - 0.4, row_n + m1w/2, net="D")
# connect D port to D-net terminals (gates of p0_1/n0_1)
d_terms = terms["D"]
if d_terms:
    dx = min(t.left for t in d_terms)
    dff.rect(m1, D_shape.right, row_n - m1w/2, dx - m1w/2, row_n + m1w/2, net="D")
Q_shape = dff.rect(m1, xmax + 0.4, row_p - m1w/2, xmax + 1.4, row_p + m1w/2, net="Q")
q_terms = terms["Q"]
if q_terms:
    dx = max(t.right for t in q_terms)
    dff.rect(m1, dx + m1w/2, row_p - m1w/2, Q_shape.left - m1w/2, row_p + m1w/2, net="Q")
CK_shape = dff.rect(m1, xmin - 0.4, row_p + 1.9, xmax + 0.4, row_p + 1.9 + m1w, net="CK")
for t in terms["CK"]:
    dff.rect(m1, t.cx - m1w/2, CK_shape.bottom, t.cx + m1w/2, row_p + pw/2 + 0.5, net="CK")
VDD_shape = dff.rect(m1, xmin - 0.4, row_p + 2.9, xmax + 0.4, row_p + 2.9 + m1w, net="VDD")
VSS_shape = dff.rect(m1, xmin - 0.4, row_n - 2.9 - m1w, xmax + 0.4, row_n - 2.9, net="VSS")
for net, rail in (("VDD", VDD_shape), ("VSS", VSS_shape)):
    for t in terms[net]:
        if t.cy < rail.cy:
            dff.rect(m1, t.cx - m1w/2, t.top, t.cx + m1w/2, rail.bottom, net=net)
        else:
            dff.rect(m1, t.cx - m1w/2, rail.top, t.cx + m1w/2, t.bottom, net=net)

dff.port("D", on=D_shape, dir="in")
dff.port("Q", on=Q_shape, dir="out")
dff.port("CK", on=CK_shape, dir="in")
dff.port("VDD", on=VDD_shape, dir="in")
dff.port("VSS", on=VSS_shape, dir="in")

# ---------------- top cell shreg16 ----------------
top = Cell("shreg16")
pitch = W + 1.6
insts = []
for i in range(16):
    inst = top.place(dff, at=(i * pitch, 0), name="FF%d" % i,
                     conns={"VDD": "VDD", "VSS": "VSS", "CK": "CK",
                            "D": ("D" if i == 0 else "Q%d" % (i - 1)),
                            "Q": "Q%d" % i})
    insts.append(inst)

# CK bus on m2
ck_y = row_p + 2.9 + m1w + 0.8 + m2w/2
ck_bus = top.rect(m2, 0, ck_y - m2w/2, 16 * pitch, ck_y + m2w/2, net="CK")
for inst in insts:
    ckpin = inst.pin("CK")
    drop = top.rect(m1, ckpin.cx - m1w/2, ckpin.top, ckpin.cx + m1w/2, ck_bus.bottom - m1w/2, net="CK")
    top.via(m1, m2, at=(drop.cx, (drop.top + ck_bus.bottom) / 2), net="CK")
top.port("CK", on=ck_bus, dir="in")

# Q bus on m2, D chain on m1
q_y = ck_y + m2w + 1.2
q_bus = top.rect(m2, 0, q_y - m2w/2, 16 * pitch, q_y + m2w/2, net="Qbus")
dport = top.rect(m1, -1.4, row_n - m1w/2, -0.4, row_n + m1w/2, net="D")
top.port("D", on=dport, dir="in")
ff0 = insts[0]
dpin = ff0.pin("D")
top.rect(m1, dport.right, row_n - m1w/2, dpin.left - m1w/2, row_n + m1w/2, net="D")
top.rect(m1, dpin.left - m1w/2, dpin.bottom - m1w/2, dpin.right + m1w/2, dpin.top + m1w/2, net="D")

for i, inst in enumerate(insts):
    qpin = inst.pin("Q")
    v = top.rect(m1, qpin.cx - m1w/2, qpin.top, qpin.cx + m1w/2, q_bus.bottom - m1w/2, net="Q%d" % i)
    top.via(m1, m2, at=(v.cx, (v.top + q_bus.bottom) / 2), net="Q%d" % i)
    qp = top.rect(m2, qpin.cx - m2w/2, q_bus.bottom - m2w/2, qpin.cx + m2w/2, q_bus.top + m2w/2, net="Q%d" % i)
    top.port("Q%d" % i, on=qp, dir="out")
    if i < 15:
        dpin_next = insts[i + 1].pin("D")
        h = top.rect(m1, qpin.right, qpin.cy - m1w/2, dpin_next.left - m1w/2, qpin.cy + m1w/2, net="Q%d" % i)
        top.rect(m1, dpin_next.left - m1w/2, dpin_next.bottom - m1w/2, dpin_next.right + m1w/2, dpin_next.top + m1w/2, net="Q%d" % i)

# VDD / VSS rails on m2
vdd_y = q_y + m2w + 1.6
vss_y = row_n - 2.9 - m1w - 0.8 - m2w/2
vdd = top.rect(m2, 0, vdd_y - m2w/2, 16 * pitch, vdd_y + m2w/2, net="VDD")
vss = top.rect(m2, 0, vss_y - m2w/2, 16 * pitch, vss_y + m2w/2, net="VSS")
for inst in insts:
    for net, rail in (("VDD", vdd), ("VSS", vss)):
        pin = inst.pin(net)
        if net == "VDD":
            drop = top.rect(m1, pin.cx - m1w/2, pin.top, pin.cx + m1w/2, rail.bottom - m1w/2, net=net)
            cy = (drop.top + rail.bottom) / 2
        else:
            drop = top.rect(m1, pin.cx - m1w/2, rail.top + m1w/2, pin.cx + m1w/2, pin.bottom, net=net)
            cy = (drop.bottom + rail.top) / 2
        top.via(m1, m2, at=(drop.cx, cy), net=net)
top.port("VDD", on=vdd, dir="in")
top.port("VSS", on=vss, dir="in")

TOP = top
