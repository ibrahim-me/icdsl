from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- dff cell
dff = Cell("dff")

# NMOS pulldown network (all w=0.09, l=0.05)
t = {}
for name, gate, s, d in [
    ("n00","CK","CKB","VSS"), ("n01","D","VSS","n1"),
    ("n02","CKB","n1","m"),    ("n03","CK","m","n2"),
    ("n04","mb","n2","VSS"),   ("n05","m","VSS","mb"),
    ("n70","Q","VSS","n3"),    ("n71","CKB","n3","s"),
    ("n72","CK","s","n4"),     ("n73","mb","n4","VSS"),
    ("n74","s","VSS","Q"),
]:
    t[name] = dff.mos("nmos", w=0.09, l=0.05, gates=gate, sd=(s, d), contacts=[c0])

# PMOS pullup network (all w=0.18, l=0.05)
for name, gate, s, d in [
    ("p00","CK","CKB","VDD"), ("p01","D","VDD","p1"),
    ("p02","CK","p1","m"),    ("p03","CKB","m","p2"),
    ("p04","mb","p2","VDD"),  ("p05","m","VDD","mb"),
    ("p70","Q","VDD","p3"),   ("p71","CK","p3","s"),
    ("p72","CKB","s","p4"),   ("p73","mb","p4","VDD"),
    ("p74","s","VDD","Q"),
]:
    t[name] = dff.mos("pmos", w=0.18, l=0.05, gates=gate, sd=(s, d), contacts=[c0])

# ---- compact placement: two columns (nmos left, pmos right), shared rails
pitch = 0.42          # transistor column pitch
row_h = 0.62          # diffusion row height
xn = 0.30             # nmos column x
xp = xn + pitch       # pmos column x

def place_nmos(name, row, gate_x=None):
    tr = t[name]
    tr.place(at=(xn, row * row_h), orient="R0")

def place_pmos(name, row):
    tr = t[name]
    tr.place(at=(xp, row * row_h), orient="MX")

# Row assignment (diffusion sharing where possible)
# NMOS column
place_nmos("n01", 0)   # D-VSS-n1
place_nmos("n00", 1)   # VSS-CK-CKB
place_nmos("n02", 1)   # CKB-n1-m  (shares n1 with n01? different row - no)
place_nmos("n03", 2)   # CK-m-n2
place_nmos("n04", 2)   # mb-n2-VSS (shares n2 with n03)
place_nmos("n05", 3)   # m-VSS-mb
place_nmos("n71", 3)   # CKB-n3-s
place_nmos("n72", 4)   # CK-s-n4
place_nmos("n73", 4)   # mb-n4-VSS (shares n4 with n72)
place_nmos("n70", 5)   # Q-VSS-n3
place_nmos("n74", 5)   # s-VSS-Q

# PMOS column
place_pmos("p01", 0)   # D-VDD-p1
place_pmos("p00", 1)   # VDD-CK-CKB
place_pmos("p02", 1)   # CK-p1-m
place_pmos("p03", 2)   # CKB-m-p2
place_pmos("p04", 2)   # mb-p2-VDD (shares p2 with p03)
place_pmos("p05", 3)   # m-VDD-mb
place_pmos("p71", 3)   # CK-p3-s
place_pmos("p72", 4)   # CKB-s-p4
place_pmos("p73", 4)   # mb-p4-VDD (shares p4 with p72)
place_pmos("p70", 5)   # Q-VDD-p3
place_pmos("p74", 5)   # s-VDD-Q

# ---- local clock inverter: n00 + p00 already placed, connect CKB
ckb = dff.rect(c0, x0=t["n00"].sd[1].left, x1=t["p00"].sd[1].right,
               y0=min(t["n00"].sd[1].bottom, t["p00"].sd[1].bottom),
               y1=max(t["n00"].sd[1].top, t["p00"].sd[1].top), net="CKB")

# ---- internal nets: m, mb, s, n1, n2, n3, n4, p1, p2, p3, p4
def c0_join(shapes, net):
    x0 = min(s.left for s in shapes); x1 = max(s.right for s in shapes)
    y0 = min(s.bottom for s in shapes); y1 = max(s.top for s in shapes)
    return dff.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)

# m: n02.sd[0], n03.sd[1], p02.sd[0], p03.sd[1], n05.sd[0], p05.sd[0]
c0_join([t["n02"].sd[0], t["n03"].sd[1], t["p02"].sd[0], t["p03"].sd[1],
         t["n05"].sd[0], t["p05"].sd[0]], "m")
# mb: n04.sd[0], n05.sd[1], p04.sd[0], p05.sd[1], n73.sd[0], p73.sd[0]
c0_join([t["n04"].sd[0], t["n05"].sd[1], t["p04"].sd[0], t["p05"].sd[1],
         t["n73"].sd[0], t["p73"].sd[0]], "mb")
# s: n71.sd[1], n72.sd[0], p71.sd[1], p72.sd[0], n74.sd[0], p74.sd[0]
c0_join([t["n71"].sd[1], t["n72"].sd[0], t["p71"].sd[1], t["p72"].sd[0],
         t["n74"].sd[0], t["p74"].sd[0]], "s")
# n1: n01.sd[0], n02.sd[1]
c0_join([t["n01"].sd[0], t["n02"].sd[1]], "n1")
# n2: n03.sd[0], n04.sd[1]
c0_join([t["n03"].sd[0], t["n04"].sd[1]], "n2")
# n3: n70.sd[0], n71.sd[0]
c0_join([t["n70"].sd[0], t["n71"].sd[0]], "n3")
# n4: n72.sd[0], n73.sd[1]
c0_join([t["n72"].sd[0], t["n73"].sd[1]], "n4")
# p1: p01.sd[0], p02.sd[1]
c0_join([t["p01"].sd[0], t["p02"].sd[1]], "p1")
# p2: p03.sd[0], p04.sd[1]
c0_join([t["p03"].sd[0], t["p04"].sd[1]], "p2")
# p3: p70.sd[0], p71.sd[1]
c0_join([t["p70"].sd[0], t["p71"].sd[1]], "p3")
# p4: p72.sd[0], p73.sd[1]
c0_join([t["p72"].sd[0], t["p73"].sd[1]], "p4")

# ---- rails
vss = dff.rect(c0, x0=xn - 0.15, x1=xp + pitch + 0.15,
               y0=0, y1=6 * row_h, net="VSS")
vdd = dff.rect(c0, x0=xn - 0.15, x1=xp + pitch + 0.15,
               y0=6 * row_h, y1=7 * row_h, net="VDD")

# connect all nmos sources to VSS, pmos sources to VDD
for nm in ["n01", "n04", "n05", "n70", "n73", "n74"]:
    dff.rect(c0, x0=t[nm].sd[1].left, x1=t[nm].sd[1].right,
             y0=min(t[nm].sd[1].bottom, vss.top), y1=vss.top, net="VSS")
for pm in ["p01", "p04", "p05", "p70", "p73", "p74"]:
    dff.rect(c0, x0=t[pm].sd[1].left, x1=t[pm].sd[1].right,
             y0=vdd.bottom, y1=max(t[pm].sd[1].top, vdd.bottom), net="VDD")

# ---- CK routing: vertical m1 at gate columns
ck_m1 = dff.rect(m1, x0=xn - 0.05, x1=xn + 0.15,
                 y0=0, y1=7 * row_h, net="CK")
# connect CK to nmos gates (n00,n03,n72) and pmos gates (p00,p02,p71)
for nm in ["n00", "n03", "n72"]:
    g = t[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_m1.bottom, y1=ck_m1.top, net="CK")
    dff.via(c0, m1, at=(g.cx, (g.bottom + ck_m1.top) / 2), net="CK", dir="v")
for pm in ["p00", "p02", "p71"]:
    g = t[pm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_m1.bottom, y1=ck_m1.top, net="CK")
    dff.via(c0, m1, at=(g.cx, (g.top + ck_m1.bottom) / 2), net="CK", dir="v")

# ---- D input: m1 horizontal at row 0
d_m1 = dff.rect(m1, x0=xn - 0.2, x1=xp + pitch + 0.2,
                y0=0 * row_h + 0.08, y1=0 * row_h + 0.18, net="D")
# connect to n01 and p01 gates
for nm in ["n01", "p01"]:
    g = t[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=d_m1.bottom, y1=d_m1.top, net="D")
    dff.via(c0, m1, at=(g.cx, (g.bottom + d_m1.top) / 2), net="D", dir="v")

# ---- Q output: m1 horizontal at row 5
q_m1 = dff.rect(m1, x0=xn - 0.2, x1=xp + pitch + 0.2,
                y0=5 * row_h + 0.08, y1=5 * row_h + 0.18, net="Q")
for nm in ["n70", "p70"]:
    g = t[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=q_m1.bottom, y1=q_m1.top, net="Q")
    dff.via(c0, m1, at=(g.cx, (g.top + q_m1.bottom) / 2), net="Q", dir="v")

# ---- ports
dff.port("D", on=d_m1, dir="in")
dff.port("CK", on=ck_m1, dir="in")
dff.port("Q", on=q_m1, dir="out")
dff.port("VSS", on=vss)
dff.port("VDD", on=vdd)

dff_w = xp + pitch + 0.3
dff_h = 7 * row_h

# ---------------------------------------------------------------- top cell
top = Cell("shreg16")

# place 16 dffs: 2 rows of 8, serpentine (Q of row0 feeds D of row1 etc.)
col_pitch = dff_w + 0.25
row_pitch = dff_h + 0.35

insts = []
for i in range(16):
    r = i // 8
    cidx = i % 8
    x = cidx * col_pitch + (col_pitch - dff_w) / 2
    y = r * row_pitch
    if r == 1:
        x = (7 - cidx) * col_pitch + (col_pitch - dff_w) / 2  # mirror x for serpentine
    inst = top.place(dff, at=(x, y), name=f"FF{i}",
                     conns={"VSS": "VSS", "VDD": "VDD", "D": f"D{i}", "CK": "CK", "Q": f"Q{i}"})
    insts.append(inst)

# chain: Q[i] -> D[i+1]
for i in range(15):
    top.wire(m1, [insts[i].pin("Q"), insts[i + 1].pin("D")], width=0.1, net=f"chain{i}")

# primary D -> FF0.D, CK to all
top.wire(m1, [top.port("D") if hasattr(top, 'port') else None], width=0.1)

# ---- rails and ports
vss_rail = top.rect(m1, x0=0, x1=15 * col_pitch + col_pitch, y0=-0.3, y1=0, net="VSS")
vdd_rail = top.rect(m1, x0=0, x1=15 * col_pitch + col_pitch, y0=2 * row_pitch, y1=2 * row_pitch + 0.3, net="VDD")

for inst in insts:
    top.wire(m1, [inst.pin("VSS"), vss_rail], width=0.15, net="VSS")
    top.wire(m1, [inst.pin("VDD"), vdd_rail], width=0.15, net="VDD")

# CK: vertical m2 trunk, m1 branches to each FF
ck_trunk = top.rect(m2, x0=15 * col_pitch + col_pitch - 0.2, x1=15 * col_pitch + col_pitch + 0.2,
                    y0=-0.3, y1=2 * row_pitch + 0.6, net="CK")
for inst in insts:
    top.wire(m1, [inst.pin("CK"), ck_trunk], width=0.1, net="CK")

# ---- output ports (Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15)
q_order = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
port_x = 15 * col_pitch + col_pitch + 0.5
port_y_step = (2 * row_pitch + 0.6) / 16
for i, ff_idx in enumerate(q_order):
    inst = insts[ff_idx]
    py = inst.pin("Q").cy
    top.wire(m1, [inst.pin("Q"), (port_x, py)], width=0.1, net=f"Q{ff_idx}")
    top.port(f"Q{ff_idx}", on=top.rect(m1, x0=port_x - 0.15, x1=port_x + 0.15,
                                        y0=py - 0.05, y1=py + 0.05, net=f"Q{ff_idx}"))

# D and CK ports
top.port("D", on=top.rect(m1, x0=-0.5, x1=-0.2, y0=insts[0].pin("D").cy - 0.05,
                          y1=insts[0].pin("D").cy + 0.05, net="D"))
top.port("CK", on=ck_trunk)
top.port("VSS", on=vss_rail)
top.port("VDD", on=vdd_rail)

TOP = top
