```
from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- dff cell
dff = Cell("dff")

WN, WP, L = 0.09, 0.18, 0.05

def nfet(name, gate, s, d, at):
    return dff.mos("nmos", w=WN, l=L, gates=gate, sd=(s, d),
                   contacts=[c0, c0], at=at)

def pfet(name, gate, s, d, at):
    return dff.mos("pmos", w=WP, l=L, gates=gate, sd=(s, d),
                   contacts=[c0, c0], at=at)

xn, xp = 0.28, 0.92
y0 = 0.0
pitch = 0.62

rows = [
    (("n01","D","VSS","n1"),   ("p01","D","VDD","p1")),
    (("n00","CK","CKB","VSS"), ("p00","CK","CKB","VDD")),
    (("n02","CKB","n1","m"),   ("p02","CK","p1","m")),
    (("n03","CK","m","n2"),    ("p03","CKB","m","p2")),
    (("n04","mb","n2","VSS"),  ("p04","mb","p2","VDD")),
    (("n05","m","VSS","mb"),   ("p05","m","VDD","mb")),
    (("n71","CKB","n3","s"),   ("p71","CK","p3","s")),
    (("n72","CK","s","n4"),    ("p72","CKB","s","p4")),
    (("n73","mb","n4","VSS"),  ("p73","mb","p4","VDD")),
    (("n70","Q","VSS","n3"),   ("p70","Q","VDD","p3")),
    (("n74","s","VSS","Q"),    ("p74","s","VDD","Q")),
]

tr = {}
for r, (na, pa) in enumerate(rows):
    y = y0 + r * pitch
    nm_name, ng, ns, nd = na
    pm_name, pg, ps, pd = pa
    tr[nm_name] = nfet(nm_name, ng, ns, nd, at=(xn, y))
    tr[pm_name] = pfet(pm_name, pg, ps, pd, at=(xp, y))

# local clock inverter -> CKB
ckb = dff.rect(c0,
    x0=min(tr["n00"].sd[1].left, tr["p00"].sd[1].left),
    x1=max(tr["n00"].sd[1].right, tr["p00"].sd[1].right),
    y0=min(tr["n00"].sd[1].bottom, tr["p00"].sd[1].bottom),
    y1=max(tr["n00"].sd[1].top, tr["p00"].sd[1].top), net="CKB")

def join(shapes, net):
    return dff.rect(c0,
        x0=min(s.left for s in shapes), x1=max(s.right for s in shapes),
        y0=min(s.bottom for s in shapes), y1=max(s.top for s in shapes), net=net)

join([tr["n02"].sd[0], tr["n03"].sd[1], tr["p02"].sd[0], tr["p03"].sd[1],
      tr["n05"].sd[0], tr["p05"].sd[0]], "m")
join([tr["n04"].sd[0], tr["n05"].sd[1], tr["p04"].sd[0], tr["p05"].sd[1],
      tr["n73"].sd[0], tr["p73"].sd[0]], "mb")
join([tr["n71"].sd[1], tr["n72"].sd[0], tr["p71"].sd[1], tr["p72"].sd[0],
      tr["n74"].sd[0], tr["p74"].sd[0]], "s")
join([tr["n01"].sd[0], tr["n02"].sd[1]], "n1")
join([tr["n03"].sd[0], tr["n04"].sd[1]], "n2")
join([tr["n70"].sd[0], tr["n71"].sd[0]], "n3")
join([tr["n72"].sd[0], tr["n73"].sd[1]], "n4")
join([tr["p01"].sd[0], tr["p02"].sd[1]], "p1")
join([tr["p03"].sd[0], tr["p04"].sd[1]], "p2")
join([tr["p70"].sd[0], tr["p71"].sd[1]], "p3")
join([tr["p72"].sd[0], tr["p73"].sd[1]], "p4")

# rails on c0 (=m1 in freepdk45): VSS bottom, VDD top, no Y overlap
dff_h = (len(rows)-1) * pitch
vss = dff.rect(c0, x0=xn - 0.18, x1=xp + WP + 0.18, y0=-0.12, y1=0.0, net="VSS")
vdd = dff.rect(c0, x0=xn - 0.18, x1=xp + WP + 0.18, y0=dff_h, y1=dff_h + 0.12, net="VDD")

def connect(a, b, net, layer):
    """Union bounding box of two shapes on `layer`, only if non-zero area."""
    x0 = min(a.left, b.left); x1 = max(a.right, b.right)
    y0 = min(a.bottom, b.bottom); y1 = max(a.top, b.top)
    if x1 > x0 and y1 > y0:
        dff.rect(layer, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

for nm in ["n01","n04","n05","n70","n73","n74"]:
    connect(tr[nm].sd[1], vss, "VSS", c0)
for pm in ["p01","p04","p05","p70","p73","p74"]:
    connect(tr[pm].sd[1], vdd, "VDD", c0)

# CK on m2 vertical rail (avoids c0/m1 VSS/VDD rails)
ck_rail = dff.rect(m2, x0=xn - 0.06, x1=xn + WN + 0.06,
                   y0=-0.12, y1=dff_h + 0.12, net="CK")
for nm in ["n00","n03","n72"]:
    g = tr[nm].gates[0]
    connect(g, ck_rail, "CK", m1)
for pm in ["p00","p02","p71"]:
    g = tr[pm].gates[0]
    connect(g, ck_rail, "CK", m1)

# D on m1 horizontal at row 0 (above VSS rail, no overlap)
d_rail = dff.rect(m1, x0=xn - 0.2, x1=xp + WP + 0.2,
                  y0=0.08, y1=0.18, net="D")
for nm in ["n01","p01"]:
    g = tr[nm].gates[0]
    connect(g, d_rail, "D", m1)

# Q on m1 horizontal at last row (below VDD rail, no overlap)
q_rail = dff.rect(m1, x0=xn - 0.2, x1=xp + WP + 0.2,
                  y0=dff_h + 0.08, y1=dff_h + 0.18, net="Q")
for nm in ["n70","p70"]:
    g = tr[nm].gates[0]
    connect(g, q_rail, "Q", m1)

dff.port("D", on=d_rail, dir="in")
dff.port("CK", on=ck_rail, dir="in")
dff.port("Q", on=q_rail, dir="out")
dff.port("VSS", on=vss)
dff.port("VDD", on=vdd)

dff_w = xp + WP + 0.30
dff_h = dff_h + 0.24

# ---------------------------------------------------------------- top cell
top = Cell("shreg16")

col_pitch = dff_w + 0.18
row_pitch = dff_h + 0.20

insts = []
for i in range(16):
    r = i // 8
    ci = i % 8
    x = ci * col_pitch + (col_pitch - dff_w) / 2
    y = r * row_pitch
    if r == 1:
        x = (7 - ci) * col_pitch + (col_pitch - dff_w) / 2
    insts.append(top.place(dff, at=(x, y), name=f"FF{i}",
        conns={"VSS":"VSS","VDD":"VDD","D":f"D{i}","CK":"CK","Q":f"Q{i}"}))

# chain Q[i] -> D[i+1] on m1
for i in range(15):
    top.wire(m1, [insts[i].pin("Q"), insts[i+1].pin("D")], width=0.10, net=f"ch{i}")

# rails
vss_rail = top.rect(m1, x0=0, x1=16*col_pitch, y0=-0.18, y1=0, net="VSS")
vdd_rail = top.rect(m1, x0=0, x1=16*col_pitch, y0=2*row_pitch, y1=2*row_pitch+0.18, net="VDD")
for inst in insts:
    top.wire(m1, [inst.pin("VSS"), vss_rail], width=0.15, net="VSS")
    top.wire(m1, [inst.pin("VDD"), vdd_rail], width=0.15, net="VDD")

# CK trunk m2 + m1 branches
ck_trunk = top.rect(m2, x0=16*col_pitch - 0.12, x1=16*col_pitch + 0.12,
                    y0=-0.18, y1=2*row_pitch+0.36, net="CK")
for inst in insts:
    top.wire(m1, [inst.pin("CK"), ck_trunk], width=0.10, net="CK")

# D input port -> FF0.D
d_in = top.rect(m1, x0=-0.45, x1=-0.15,
                y0=insts[0].pin("D").cy-0.05, y1=insts[0].pin("D").cy+0.05, net="D")
top.wire(m1, [d_in, insts[0].pin("D")], width=0.10, net="D")

# output ports Q0..Q15
port_x = 16*col_pitch + 0.45
for i in range(16):
    inst = insts[i]
    py = inst.pin("Q").cy
    top.wire(m1, [inst.pin("Q"), (port_x, py)], width=0.10, net=f"Q{i}")
    top.port(f"Q{i}", on=top.rect(m1, x0=port_x-0.15, x1=port_x+0.15,
                                  y0=py-0.05, y1=py+0.05, net=f"Q{i}"))

top.port("D", on=d_in)
top.port("CK", on=ck_trunk)
top.port("VSS", on=vss_rail)
top.port("VDD", on=vdd_rail)

TOP = top


```