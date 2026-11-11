from icdsl.canvas import *

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- full adder
fa = Cell("fa")

PITCH = 0.9
YN = 0.0          # nMOS row origin y
YP = 5.6          # pMOS row origin y

n_list = [
    ("n0_0", "A",  ("VSS","n1")),
    ("n0_1", "B",  ("n1","VSS")),
    ("n0_2", "CIN",("CB","n1")),
    ("n0_3", "B",  ("n2","CB")),
    ("n0_4", "A",  ("VSS","n2")),
    ("n0_5", "A",  ("n3","VSS")),
    ("n0_6", "B",  ("VSS","n3")),
    ("n0_7", "CIN",("n3","VSS")),
    ("n0_8", "SB", ("CB","n3")),
    ("n0_9", "CIN",("n5","SB")),
    ("n0_10","B",  ("n4","n5")),
    ("n0_11","A",  ("VSS","n4")),
    ("n0_12","CB", ("COUT","VSS")),
    ("n14",  "SB", ("VSS","SUM")),
]
p_list = [
    ("p0_0","A",("VDD","p1")),
    ("p0_1","B",("p1","VDD")),
    ("p0_2","CIN",("CB","p1")),
    ("p0_3","B",("p2","CB")),
    ("p0_4","A",("VDD","p2")),
    ("p0_5","A",("p3","VDD")),
    ("p0_6","B",("VDD","p3")),
    ("p0_7","CIN",("p3","VDD")),
    ("p0_8","SB",("CB","p3")),
    ("p0_9","CIN",("p5","SB")),
    ("p0_10","B",("p4","p5")),
    ("p0_11","A",("VDD","p4")),
    ("p0_12","CB",("COUT","VDD")),
    ("p14", "SB",("VDD","SUM")),
]

nmos = {}
for i,(name,gate,sd) in enumerate(n_list):
    nmos[name] = fa.mos("nmos", w=0.42, gates=gate, sd=sd, at=(i*PITCH, YN))
pmos = {}
for i,(name,gate,sd) in enumerate(p_list):
    pmos[name] = fa.mos("pmos", w=0.84, gates=gate, sd=sd, at=(i*PITCH, YP))

# connect n and p gates in each column (same net) with vertical poly bridge
for i in range(len(n_list)):
    ng = nmos[n_list[i][0]].gates[0]
    pg = pmos[p_list[i][0]].gates[0]
    x0 = min(ng.left, pg.left) - 0.02
    x1 = max(ng.right, pg.right) + 0.02
    y0 = min(ng.bottom, pg.bottom)
    y1 = max(ng.top, pg.top)
    fa.rect("poly", x0=x0, x1=x1, y0=y0, y1=y1, net=n_list[i][1])

def term_shapes(net):
    """collect c0 sd straps and poly gates belonging to net"""
    c0s, polys = [], []
    for m in list(nmos.values()) + list(pmos.values()):
        for s in m.sd:
            if s.net == net:
                c0s.append(s)
        for g in m.gates:
            if g.net == net:
                polys.append(g)
    return c0s, polys

def li_connect(net, c0s, polys, rail_y):
    """run a c0 rail at rail_y, connect c0 straps and poly gates (via licon)"""
    alls = c0s + polys
    if not alls:
        return None
    x0 = min(s.left for s in alls) - 0.15
    x1 = max(s.right for s in alls) + 0.15
    rail = fa.rect(c0, x0=x0, x1=x1, y0=rail_y, y1=rail_y + 0.34, net=net)
    for s in c0s:
        fa.rect(c0, x0=s.left, x1=s.right, y0=min(s.bottom, rail_y),
                y1=max(s.top, rail_y + 0.34), net=net)
    for g in polys:
        fa.via("poly", c0, at=(g.cx, rail_y + 0.17), net=net, dir="v")
        fa.rect(c0, x0=g.left - 0.05, x1=g.right + 0.05,
                y0=rail_y, y1=rail_y + 0.34, net=net)
    return rail

# internal nets: route c0 rails in the gap between n and p rows
rail_y = 2.6
for net in ("n1","n2","n3","n4","n5","p1","p2","p3","p4","p5","CB","SB","COUT","SUM"):
    c0s, polys = term_shapes(net)
    li_connect(net, c0s, polys, rail_y)

# VSS / VDD rails: strap all source terminals
vss_shapes, vdd_shapes = [], []
for m in list(nmos.values()) + list(pmos.values()):
    for s in m.sd:
        if s.net == "VSS":
            vss_shapes.append(s)
        elif s.net == "VDD":
            vdd_shapes.append(s)
vss_rail = li_connect("VSS", vss_shapes, [], rail_y - 1.0)
vdd_rail = li_connect("VDD", vdd_shapes, [], rail_y + 1.4)

# taps
ntap = fa.tap("ntap", x0=nmos["n0_0"].diff.left - 0.3, y0=vss_rail.bottom - 1.0,
              x1=nmos["n0_12"].diff.right + 0.3, y1=vss_rail.bottom - 0.4, net="VSS")
ptap = fa.tap("ptap", x0=pmos["p0_0"].diff.left - 0.3, y0=vdd_rail.top + 0.4,
              x1=pmos["p0_12"].diff.right + 0.3, y1=vdd_rail.top + 1.0, net="VDD")
if ntap.well and ptap.well:
    fa.rect(ntap.well.layer, x0=min(ntap.well.left, ptap.well.left),
            x1=max(ntap.well.right, ptap.well.right), y0=ntap.well.bottom, y1=ptap.well.top, net="VDD")

fa_w = (len(n_list) - 1) * PITCH + max(nmos["n0_12"].diff.right, pmos["p0_12"].diff.right,
                                       ntap.well.right if ntap.well else 0,
                                       ptap.well.right if ptap.well else 0,
                                       vss_rail.right if vss_rail else 0,
                                       vdd_rail.right if vdd_rail else 0) - min(
    nmos["n0_0"].diff.left, pmos["p0_0"].diff.left,
    vss_rail.left if vss_rail else 0,
    vdd_rail.left if vdd_rail else 0)
fa_h = max(vdd_rail.top if vdd_rail else 0, ptap.well.top if ptap.well else 0) - min(
    vss_rail.bottom if vss_rail else 0, ntap.well.bottom if ntap.well else 0)

# ports (gate polys + output diffusions)
fa.port("A", on=nmos["n0_0"].gates[0], dir="in")
fa.port("B", on=nmos["n0_1"].gates[0], dir="in")
fa.port("CIN", on=nmos["n0_2"].gates[0], dir="in")
fa.port("COUT", on=nmos["n0_12"].sd[0], dir="out")
fa.port("SUM", on=nmos["n14"].sd[1], dir="out")
fa.port("VDD", on=vdd_rail)
fa.port("VSS", on=vss_rail)

# ---------------------------------------------------------------- top rca8
top = Cell("rca8")
insts = []
x = 0.0
for i in range(8):
    cin = "CIN" if i == 0 else ("COUT" if i == 7 else f"k{i}")
    cout = "COUT" if i == 7 else f"k{i+1}"
    conns = {"VSS": "VSS", "VDD": "VDD", "A": f"A{i}", "B": f"B{i}",
             "CIN": cin, "COUT": cout, "SUM": f"S{i}"}
    insts.append(top.place(fa, at=(x, 0), name=f"U{i}", conns=conns))
    x += fa_w + 0.6

vss_r = top.rect(c0, x0=0, x1=x, y0=-1.2, y1=-0.4, net="VSS")
vdd_r = top.rect(c0, x0=0, x1=x, y0=fa_h + 0.4, y1=fa_h + 1.2, net="VDD")
for it in insts:
    top.rect(c0, x0=it.pin("VSS").left, x1=it.pin("VSS").right,
             y0=min(it.pin("VSS").top, vss_r.bottom), y1=max(it.pin("VSS").top, vss_r.bottom), net="VSS")
    top.rect(c0, x0=it.pin("VDD").left, x1=it.pin("VDD").right,
             y0=min(it.pin("VDD").bottom, vdd_r.top), y1=max(it.pin("VDD").bottom, vdd_r.top), net="VDD")

for i, it in enumerate(insts):
    top.wire(m1, [it.pin("A"), (it.pin("A").cx, vss_r.bottom - 0.9)], width=0.3, net=f"A{i}")
    top.wire(m1, [it.pin("B"), (it.pin("B").cx, vss_r.bottom - 0.9)], width=0.3, net=f"B{i}")
    top.wire(m1, [it.pin("SUM"), (it.pin("SUM").cx, fa_h + 1.9)], width=0.3, net=f"S{i}")
top.wire(m1, [insts[0].pin("CIN"), (insts[0].pin("CIN").cx, vss_r.bottom - 0.9)], width=0.3, net="CIN")
top.wire(m1, [insts[7].pin("COUT"), (insts[7].pin("COUT").cx, fa_h + 1.9)], width=0.3, net="COUT")

for i in range(7):
    a = insts[i].pin("COUT"); b = insts[i+1].pin("CIN")
    top.wire(m2, [a, (a.cx, fa_h/2), (b.cx, fa_h/2), b], width=0.3, net=f"k{i+1}")

top.port("VSS", on=vss_r)
top.port("VDD", on=vdd_r)
for i in range(8):
    it = insts[i]
    top.port(f"A{i}", on=top.rect(m1, x0=it.pin("A").left-0.1, x1=it.pin("A").right+0.1,
                                   y0=vss_r.bottom-0.9, y1=vss_r.bottom-0.5, net=f"A{i}"))
    top.port(f"B{i}", on=top.rect(m1, x0=it.pin("B").left-0.1, x1=it.pin("B").right+0.1,
                                   y0=vss_r.bottom-0.9, y1=vss_r.bottom-0.5, net=f"B{i}"))
    top.port(f"S{i}", on=top.rect(m1, x0=it.pin("SUM").left-0.1, x1=it.pin("SUM").right+0.1,
                                   y0=fa_h+1.5, y1=fa_h+1.9, net=f"S{i}"))
top.port("CIN", on=top.rect(m1, x0=insts[0].pin("CIN").left-0.1, x1=insts[0].pin("CIN").right+0.1,
                            y0=vss_r.bottom-0.9, y1=vss_r.bottom-0.5, net="CIN"))
top.port("COUT", on=top.rect(m1, x0=insts[7].pin("COUT").left-0.1, x1=insts[7].pin("COUT").right+0.1,
                             y0=fa_h+1.5, y1=fa_h+1.9, net="COUT"))

TOP = top


