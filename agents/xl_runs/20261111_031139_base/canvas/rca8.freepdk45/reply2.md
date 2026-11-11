```
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ------------------------------------------------------------------ full adder
fa = Cell("fa")

col_pitch = 0.66
row_pitch = 0.90
n_w, p_w = 0.09, 0.18
gate_l = 0.05

cols = ["A", "B", "CIN", "CB", "SB"]
# per column: list of (source, drain) for nMOS and pMOS (gate = column name)
nstack = {
    "A": [("VSS", "n1"), ("VSS", "n2"), ("n3", "VSS"), ("VSS", "n4")],
    "B": [("n1", "VSS"), ("n2", "CB"), ("VSS", "n3"), ("n4", "n5")],
    "CIN": [("CB", "n1"), ("n3", "VSS"), ("n5", "SB")],
    "CB": [("SB", "n3"), ("COUT", "VSS")],
    "SB": [("VSS", "SUM")],
}
pstack = {
    "A": [("VDD", "p1"), ("VDD", "p2"), ("p3", "VDD"), ("VDD", "p4")],
    "B": [("p1", "VDD"), ("p2", "CB"), ("VDD", "p3"), ("p4", "p5")],
    "CIN": [("CB", "p1"), ("p3", "VDD"), ("p5", "SB")],
    "CB": [("SB", "p3"), ("COUT", "VDD")],
    "SB": [("VDD", "SUM")],
}

devs = []  # (mos, kind, col, row, snet, dnet)

# nMOS bottom half
for ci, col in enumerate(cols):
    for ri, (s, d) in enumerate(nstack[col]):
        m = fa.mos("nmos", w=n_w, l=gate_l, gates=col, sd=(s, d),
                   at=(ci * col_pitch, ri * row_pitch))
        devs.append((m, "n", col, ri, s, d))

# pMOS top half (mirrored vertically)
p_top = len(max(nstack.values(), key=len)) * row_pitch + 0.6
for ci, col in enumerate(cols):
    for ri, (s, d) in enumerate(pstack[col]):
        m = fa.mos("pmos", w=p_w, l=gate_l, gates=col, sd=(s, d),
                   at=(ci * col_pitch, p_top + ri * row_pitch))
        devs.append((m, "p", col, ri, s, d))

fa_bottom = min(m.diff.bottom for m, _, _, _, _, _ in devs)
fa_top = max(m.diff.top for m, _, _, _, _, _ in devs)
fa_left = min(m.diff.left for m, _, _, _, _, _ in devs)
fa_right = max(m.diff.right for m, _, _, _, _, _ in devs)

# collect strap centres per net
from collections import defaultdict
net_straps = defaultdict(list)
for m, kind, col, ri, s, d in devs:
    net_straps[s].append(m.sd[0])
    net_straps[d].append(m.sd[1])

# route each internal net on m1 through its straps
for net, straps in net_straps.items():
    if net in ("VSS", "VDD"):
        continue
    pts = [s.bbox for s in straps]
    fa.wire(m1, [s for s in straps], width=0.15, net=net, first="h")

# rails on m2
rail_h = 0.3
vss = fa.rect(m2, x0=fa_left - 0.1, x1=fa_right + 0.1,
              y0=fa_bottom - rail_h, y1=fa_bottom - 0.05, net="VSS")
vdd = fa.rect(m2, x0=fa_left - 0.1, x1=fa_right + 0.1,
              y0=fa_top + 0.05, y1=fa_top + rail_h, net="VDD")
# connect rails to device source straps
for m, kind, col, ri, s, d in devs:
    strap = m.sd[0]
    if s == "VSS":
        fa.via(c0, m2, at=(strap.cx, (vss.top + strap.top) / 2), net="VSS")
    elif s == "VDD":
        fa.via(c0, m2, at=(strap.cx, (vdd.bottom + strap.bottom) / 2), net="VDD")

# input/output ports: route A, B, CIN to left edge; COUT, SUM to right edge on m1
def port_wire(net, straps, side):
    pts = [s for s in straps]
    fa.wire(m1, pts, width=0.15, net=net, first="h")

fa.port("A", on=net_straps["A"][0] if "A" in net_straps else None)
fa.port("B", on=net_straps["B"][0] if "B" in net_straps else None)
fa.port("CIN", on=net_straps["CIN"][0] if "CIN" in net_straps else None)
fa.port("VSS", on=vss)
fa.port("VDD", on=vdd)
fa.port("COUT", on=net_straps["COUT"][0] if "COUT" in net_straps else None)
fa.port("SUM", on=net_straps["SUM"][0] if "SUM" in net_straps else None)

fa.width = fa_right - fa_left
fa.height = fa_top - fa_bottom + 2 * rail_h

# ------------------------------------------------------------------ top: rca8
top = Cell("rca8")
pitch = fa.width + 0.4
x = 0.0
insts = []
for i in range(8):
    inst = top.place(fa, at=(x, 0), name="FA%d" % i,
                     conns={"A": "A%d" % i, "B": "B%d" % i,
                            "CIN": "CIN" if i == 0 else "k%d" % i,
                            "COUT": "COUT" if i == 7 else "k%d" % (i + 1),
                            "SUM": "S%d" % i, "VDD": "VDD", "VSS": "VSS"})
    insts.append(inst)
    x += pitch

# carry chain on m1
for i in range(7):
    top.wire(m1, [insts[i].pin("COUT"), insts[i + 1].pin("CIN")],
             width=0.15, net="k%d" % (i + 1), first="h")

# global rails
vss = top.rect(m2, x0=0, x1=top.right, y0=-0.8, y1=-0.5, net="VSS")
vdd = top.rect(m2, x0=0, x1=top.right, y0=fa.top + 0.5, y1=fa.top + 0.8, net="VDD")
for inst in insts:
    top.via(c0, m2, at=(inst.pin("VSS").cx, (vss.top + inst.pin("VSS").bottom) / 2), net="VSS")
    top.via(c0, m2, at=(inst.pin("VDD").cx, (vdd.bottom + inst.pin("VDD").top) / 2), net="VDD")

for nm in ("VSS", "VDD"):
    top.port(nm, on={"VSS": vss, "VDD": vdd}[nm])

TOP = top
```