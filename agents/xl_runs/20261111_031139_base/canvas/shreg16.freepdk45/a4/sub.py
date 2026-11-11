from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- dff cell
dff = Cell("dff")

WN, WP, L = 0.09, 0.18, 0.05
PITCH = 0.30          # row pitch (device width + diff space)
XN, XP = 0.10, 0.50   # nmos / pmos column origins
Y0 = 0.0

def nfet(name, gate, s, d, row):
    return dff.mos("nmos", w=WN, l=L, gates=gate, sd=(s, d),
                   contacts=[c0, c0], at=(XN, Y0 + row * PITCH))

def pfet(name, gate, s, d, row):
    return dff.mos("pmos", w=WP, l=L, gates=gate, sd=(s, d),
                   contacts=[c0, c0], at=(XP, Y0 + row * PITCH))

# rows: (nmos, pmos) with (name, gate, source, drain)
rows = [
    (("n01","D","VSS","n1"),   ("p01","D","VDD","p1")),
    (("n02","CKB","n1","m"),   ("p02","CK","p1","m")),
    (("n03","CK","m","n2"),    ("p03","CKB","m","p2")),
    (("n04","mb","n2","VSS"),  ("p04","mb","p2","VDD")),
    (("n05","m","VSS","mb"),   ("p05","m","VDD","mb")),
    (("n00","CK","CKB","VSS"), ("p00","CK","CKB","VDD")),
    (("n71","CKB","n3","s"),   ("p71","CK","p3","s")),
    (("n72","CK","s","n4"),    ("p72","CKB","s","p4")),
    (("n73","mb","n4","VSS"),  ("p73","mb","p4","VDD")),
    (("n74","s","VSS","Q"),    ("p74","s","VDD","Q")),
    (("n70","Q","VSS","n3"),   ("p70","Q","VDD","p3")),
]

tr = {}
for r, (na, pa) in enumerate(rows):
    nm_name, ng, ns, nd = na
    pm_name, pg, ps, pd = pa
    tr[nm_name] = nfet(nm_name, ng, ns, nd, r)
    tr[pm_name] = pfet(pm_name, pg, ps, pd, r)

def join(shapes, net):
    """Union bounding box of shapes on c0/m1 (same layer in freepdk45)."""
    x0 = min(s.left for s in shapes); x1 = max(s.right for s in shapes)
    y0 = min(s.bottom for s in shapes); y1 = max(s.top for s in shapes)
    dff.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# local c0/m1 nets (source/drain straps already on c0 from PCell contacts)
join([tr["n01"].sd[1], tr["n02"].sd[0]], "n1")
join([tr["n02"].sd[1], tr["n03"].sd[0]], "m")
join([tr["n03"].sd[1], tr["n04"].sd[0]], "n2")
join([tr["p01"].sd[1], tr["p02"].sd[0]], "p1")
join([tr["p02"].sd[1], tr["p03"].sd[0]], "m")
join([tr["p03"].sd[1], tr["p04"].sd[0]], "p2")
join([tr["n71"].sd[1], tr["n72"].sd[0]], "s")
join([tr["n72"].sd[1], tr["n73"].sd[0]], "n4")
join([tr["p71"].sd[1], tr["p72"].sd[0]], "s")
join([tr["p72"].sd[1], tr["p73"].sd[0]], "p4")

# gate nets on poly
def poly_join(shapes, net):
    x0 = min(s.left for s in shapes); x1 = max(s.right for s in shapes)
    y0 = min(s.bottom for s in shapes); y1 = max(s.top for s in shapes)
    dff.rect("poly", x0=x0, x1=x1, y0=y0, y1=y1, net=net)

poly_join([tr["n00"].gates[0], tr["n03"].gates[0], tr["n72"].gates[0],
           tr["p00"].gates[0], tr["p02"].gates[0], tr["p71"].gates[0]], "CK")
poly_join([tr["n02"].gates[0], tr["n71"].gates[0],
           tr["p03"].gates[0], tr["p72"].gates[0]], "CKB")
poly_join([tr["n01"].gates[0], tr["p01"].gates[0]], "D")
poly_join([tr["n70"].gates[0], tr["p70"].gates[0]], "Q")
poly_join([tr["n04"].gates[0], tr["n05"].sd[1], tr["p04"].gates[0], tr["p05"].sd[1],
           tr["n73"].gates[0], tr["p73"].gates[0]], "mb")
poly_join([tr["n05"].gates[0], tr["p05"].gates[0], tr["n74"].gates[0], tr["p74"].gates[0]], "s")

# VSS / VDD rails on c0/m1 (bottom / top, no overlap with devices)
dff_h = (len(rows) - 1) * PITCH
vss = dff.rect(c0, x0=XN - 0.10, x1=XP + WP + 0.10, y0=Y0 - 0.12, y1=Y0, net="VSS")
vdd = dff.rect(c0, x0=XN - 0.10, x1=XP + WP + 0.10, y0=dff_h, y1=dff_h + 0.12, net="VDD")

for nm in ["n01","n04","n05","n70","n73","n74"]:
    dff.rect(c0, x0=tr[nm].sd[1].left, x1=tr[nm].sd[1].right,
             y0=min(tr[nm].sd[1].bottom, vss.top), y1=vss.top, net="VSS")
for pm in ["p01","p04","p05","p70","p73","p74"]:
    dff.rect(c0, x0=tr[pm].sd[1].left, x1=tr[pm].sd[1].right,
             y0=vdd.bottom, y1=max(tr[pm].sd[1].top, vdd.bottom), net="VDD")

# CK vertical trunk on m2 (crosses over c0/m1 devices without touching them)
ck_trunk = dff.rect(m2, x0=XN - 0.06, x1=XN + WN + 0.06,
                    y0=Y0 - 0.12, y1=dff_h + 0.12, net="CK")
for nm in ["n00","n03","n72"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_trunk.bottom, y1=ck_trunk.top, net="CK")
    dff.via(c0, m2, at=(g.cx, (g.bottom + ck_trunk.top) / 2), net="CK", dir="v")
for pm in ["p00","p02","p71"]:
    g = tr[pm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_trunk.bottom, y1=ck_trunk.top, net="CK")
    dff.via(c0, m2, at=(g.cx, (g.top + ck_trunk.bottom) / 2), net="CK", dir="v")

# D input on m1 at row 0
d_bar = dff.rect(m1, x0=XN - 0.15, x1=XP + WP + 0.15,
                 y0=Y0 + 0.06, y1=Y0 + 0.16, net="D")
for nm in ["n01","p01"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=d_bar.bottom, y1=d_bar.top, net="D")
    dff.via(c0, m1, at=(g.cx, (g.bottom + d_bar.top) / 2), net="D", dir="v")

# Q output on m1 at last row
q_bar = dff.rect(m1, x0=XN - 0.15, x1=XP + WP + 0.15,
                 y0=dff_h + 0.06, y1=dff_h + 0.16, net="Q")
for nm in ["n70","p70"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=q_bar.bottom, y1=q_bar.top, net="Q")
    dff.via(c0, m1, at=(g.cx, (g.top + q_bar.bottom) / 2), net="Q", dir="v")

dff.port("D", on=d_bar, dir="in")
dff.port("CK", on=ck_trunk, dir="in")
dff.port("Q", on=q_bar, dir="out")
dff.port("VSS", on=vss)
dff.port("VDD", on=vdd)

dff_w = XP + WP + 0.25
dff_h = dff_h + 0.24

# ---------------------------------------------------------------- top cell
top = Cell("shreg16")

COL = dff_w + 0.12
ROW = dff_h + 0.12

insts = []
for i in range(16):
    r = i // 8
    ci = i % 8
    x = ci * COL + (COL - dff_w) / 2
    y = r * ROW
    if r == 1:
        x = (7 - ci) * COL + (COL - dff_w) / 2
    insts.append(top.place(dff, at=(x, y), name=f"FF{i}",
        conns={"VSS":"VSS","VDD":"VDD","D":f"D{i}","CK":"CK","Q":f"Q{i}"}))

# chain Q[i] -> D[i+1] on m1
for i in range(15):
    top.wire(m1, [insts[i].pin("Q"), insts[i+1].pin("D")], width=0.10, net=f"ch{i}")

# rails
vss_rail = top.rect(m1, x0=0, x1=8*COL, y0=-0.12, y1=0, net="VSS")
vdd_rail = top.rect(m1, x0=0, x1=8*COL, y0=2*ROW, y1=2*ROW+0.12, net="VDD")
for inst in insts:
    top.wire(m1, [inst.pin("VSS"), vss_rail], width=0.12, net="VSS")
    top.wire(m1, [inst.pin("VDD"), vdd_rail], width=0.12, net="VDD")

# CK trunk m2 + m1 branches
ck_trunk = top.rect(m2, x0=8*COL - 0.06, x1=8*COL + 0.06,
                    y0=-0.12, y1=2*ROW+0.24, net="CK")
for inst in insts:
    top.wire(m1, [inst.pin("CK"), ck_trunk], width=0.10, net="CK")

# D input port -> FF0.D
d_in = top.rect(m1, x0=-0.40, x1=-0.10,
                y0=insts[0].pin("D").cy-0.05, y1=insts[0].pin("D").cy+0.05, net="D")
top.wire(m1, [d_in, insts[0].pin("D")], width=0.10, net="D")

# output ports Q0..Q15
port_x = 8*COL + 0.40
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



