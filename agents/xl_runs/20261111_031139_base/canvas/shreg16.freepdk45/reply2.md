```
from icdsl.canvas import *
from icdsl.canvas.route import Router

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

# ---- placement grid (two columns: nmos left, pmos right)
xn, xp = 0.28, 0.92          # device origins
y0 = 0.0
pitch = 0.62                 # row pitch (device height + spacing)

# row : (nmos name, gate, s, d) | (pmos name, gate, s, d)
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

# ---- local clock inverter (n00/p00) -> CKB
ckb = dff.rect(c0,
    x0=min(tr["n00"].sd[1].left, tr["p00"].sd[1].left),
    x1=max(tr["n00"].sd[1].right, tr["p00"].sd[1].right),
    y0=min(tr["n00"].sd[1].bottom, tr["p00"].sd[1].bottom),
    y1=max(tr["n00"].sd[1].top, tr["p00"].sd[1].top), net="CKB")

def join(shapes, net):
    return dff.rect(c0,
        x0=min(s.left for s in shapes), x1=max(s.right for s in shapes),
        y0=min(s.bottom for s in shapes), y1=max(s.top for s in shapes), net=net)

# internal c0 nets
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

# ---- rails
vss = dff.rect(c0, x0=xn - 0.18, x1=xp + WP + 0.18, y0=y0 - 0.12, y1=y0, net="VSS")
vdd = dff.rect(c0, x0=xn - 0.18, x1=xp + WP + 0.18, y0=y0 + (len(rows)-1)*pitch,
               y1=y0 + (len(rows)-1)*pitch + 0.12, net="VDD")

for nm in ["n01","n04","n05","n70","n73","n74"]:
    dff.rect(c0, x0=tr[nm].sd[1].left, x1=tr[nm].sd[1].right,
             y0=min(tr[nm].sd[1].bottom, vss.top), y1=vss.top, net="VSS")
for pm in ["p01","p04","p05","p70","p73","p74"]:
    dff.rect(c0, x0=tr[pm].sd[1].left, x1=tr[pm].sd[1].right,
             y0=vdd.bottom, y1=max(tr[pm].sd[1].top, vdd.bottom), net="VDD")

# ---- bring CK, D, Q to m1 (c0=m1 here; gates are poly -> contact to m1)
def gate_to_m1(trname, net, y_rail_bottom, y_rail_top):
    g = tr[trname].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=y_rail_bottom, y1=y_rail_top, net=net)
    dff.via(c0, m1, at=(g.cx, (g.bottom + y_rail_top) / 2), net=net, dir="v")

# CK vertical m1 rail at nmos gate column
ck_rail = dff.rect(m1, x0=xn - 0.06, x1=xn + WN + 0.06,
                   y0=y0 - 0.12, y1=y0 + (len(rows)-1)*pitch + 0.12, net="CK")
for nm in ["n00","n03","n72"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_rail.bottom, y1=ck_rail.top, net="CK")
    dff.via(c0, m1, at=(g.cx, (g.bottom + ck_rail.top) / 2), net="CK", dir="v")
for pm in ["p00","p02","p71"]:
    g = tr[pm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=ck_rail.bottom, y1=ck_rail.top, net="CK")
    dff.via(c0, m1, at=(g.cx, (g.top + ck_rail.bottom) / 2), net="CK", dir="v")

# D horizontal m1 at row 0
d_rail = dff.rect(m1, x0=xn - 0.2, x1=xp + WP + 0.2,
                  y0=y0 + 0.14, y1=y0 + 0.24, net="D")
for nm in ["n01","p01"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=d_rail.bottom, y1=d_rail.top, net="D")
    dff.via(c0, m1, at=(g.cx, (g.bottom + d_rail.top) / 2), net="D", dir="v")

# Q horizontal m1 at last row
q_rail = dff.rect(m1, x0=xn - 0.2, x1=xp + WP + 0.2,
                  y0=y0 + (len(rows)-1)*pitch + 0.14,
                  y1=y0 + (len(rows)-1)*pitch + 0.24, net="Q")
for nm in ["n70","p70"]:
    g = tr[nm].gates[0]
    dff.rect(m1, x0=g.left, x1=g.right, y0=q_rail.bottom, y1=q_rail.top, net="Q")
    dff.via(c0, m1, at=(g.cx, (g.top + q_rail.bottom) / 2), net="Q", dir="v")

# ---- ports
dff.port("D", on=d_rail, dir="in")
dff.port("CK", on=ck_rail, dir="in")
dff.port("Q", on=q_rail, dir="out")
dff.port("VSS", on=vss)
dff.port("VDD", on=vdd)

dff_w = xp + WP + 0.30
dff_h = (len(rows)-1) * pitch + 0.24

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