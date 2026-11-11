from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, c1 = tech.c0, tech.c1
POLY, DIFF, NWELL = "poly", "diff", "nwell"

# ---------------------------------------------------------------- full adder
def build_fa(c, name="fa"):
    wn, wp, l = 0.36, 0.72, 0.28
    gx = 0.78          # poly pitch
    row_h = 1.6        # row height
    row_gap = 1.1      # gap between n and p rows
    col_x = [0, gx, 2*gx, 3*gx, 4*gx]   # A, B, CIN, CB, SB

    place = [
        # gate A  (col 0)
        ("n0_0","nmos",0,0,"VSS","n1"), ("n0_4","nmos",0,0,"VSS","n2"),
        ("n0_5","nmos",0,0,"n3","VSS"), ("n0_11","nmos",0,0,"VSS","n4"),
        ("p0_0","pmos",0,1,"VDD","p1"), ("p0_4","pmos",0,1,"VDD","p2"),
        ("p0_5","pmos",0,1,"p3","VDD"), ("p0_11","pmos",0,1,"VDD","p4"),
        # gate B  (col 1)
        ("n0_1","nmos",1,0,"n1","VSS"), ("n0_3","nmos",1,0,"n2","CB"),
        ("n0_6","nmos",1,0,"VSS","n3"), ("n0_10","nmos",1,0,"n4","n5"),
        ("p0_1","pmos",1,1,"p1","VDD"), ("p0_3","pmos",1,1,"p2","CB"),
        ("p0_6","pmos",1,1,"VDD","p3"), ("p0_10","pmos",1,1,"p4","p5"),
        # gate CIN (col 2)
        ("n0_2","nmos",2,0,"CB","n1"), ("n0_7","nmos",2,0,"n3","VSS"),
        ("n0_9","nmos",2,0,"n5","SB"),
        ("p0_2","pmos",2,1,"CB","p1"), ("p0_7","pmos",2,1,"p3","VDD"),
        ("p0_9","pmos",2,1,"p5","SB"),
        # gate CB  (col 3)
        ("n0_8","nmos",3,0,"SB","n3"), ("n0_12","nmos",3,0,"COUT","VSS"),
        ("p0_8","pmos",3,1,"SB","p3"), ("p0_12","pmos",3,1,"COUT","VDD"),
        # gate SB  (col 4)
        ("n14","nmos",4,0,"VSS","SUM"),
        ("p14","pmos",4,1,"VDD","SUM"),
    ]

    devices = {}
    for tname, kind, col, row, snet, dnet in place:
        x = col_x[col]
        y = row * (row_h + row_gap)
        dev = c.mos(kind, w=wn if kind=="nmos" else wp, l=l,
                    gates=None, sd=(snet, dnet), at=(x, y))
        devices[tname] = dev

    # vertical poly gates through both rows
    gate_nets = {0:"A", 1:"B", 2:"CIN", 3:"CB", 4:"SB"}
    y0 = -0.15
    y1 = row_h + row_gap + row_h + 0.15
    for col, gnet in gate_nets.items():
        x = col_x[col]
        c.rect(POLY, x0=x-l/2, x1=x+l/2, y0=y0, y1=y1, net=gnet)

    # horizontal c0 straps
    n_y0, n_y1 = -0.1, row_h + 0.1
    p_y0 = row_h + row_gap - 0.1
    p_y1 = p_y0 + row_h + 0.2
    c.rect(c0, x0=col_x[0]-0.5, x1=col_x[-1]+l/2+0.5, y0=n_y0, y1=n_y1, net="VSS")
    c.rect(c0, x0=col_x[0]-0.5, x1=col_x[-1]+l/2+0.5, y0=p_y0, y1=p_y1, net="VDD")

    # well around PMOS row
    wy0, wy1 = p_y0 - 0.6, p_y1 + 0.6
    wx0, wx1 = col_x[0] - 0.8, col_x[-1] + l/2 + 0.8
    c.rect(NWELL, x0=wx0, x1=wx1, y0=wy0, y1=wy1, net="VDD")

    # strap contacts for VSS/VDD source/drain
    for tname, kind, col, row, snet, dnet in place:
        dev = devices[tname]
        if row == 0:
            if snet == "VSS":
                c.via(DIFF, c0, at=(dev.sd[0].cx, n_y1), net="VSS")
            if dnet == "VSS":
                c.via(DIFF, c0, at=(dev.sd[1].cx, n_y1), net="VSS")
        else:
            if snet == "VDD":
                c.via(DIFF, c0, at=(dev.sd[0].cx, p_y0), net="VDD")
            if dnet == "VDD":
                c.via(DIFF, c0, at=(dev.sd[1].cx, p_y0), net="VDD")

    # route internal multi-pin nets on c1 with c0 jogs
    net_pins = {}
    for tname, kind, col, row, snet, dnet in place:
        dev = devices[tname]
        for sd_idx, net in ((0, snet), (1, dnet)):
            if net not in ("VSS", "VDD"):
                net_pins.setdefault(net, []).append((dev, sd_idx))

    for net, pins in net_pins.items():
        if len(pins) < 2:
            continue
        xs = [p[0].sd[p[1]].cx for p in pins]
        ys = [p[0].sd[p[1]].cy for p in pins]
        cx = sum(xs)/len(xs)
        ymin, ymax = min(ys)-0.3, max(ys)+0.3
        c.rect(c1, x0=cx-0.115, x1=cx+0.115, y0=ymin, y1=ymax, net=net)
        for dev, sd_idx in pins:
            sd = dev.sd[sd_idx]
            jx0, jx1 = sorted([sd.cx, cx])
            c.rect(c0, x0=jx0, x1=jx1, y0=sd.cy-0.115, y1=sd.cy+0.115, net=net)
            c.via(c0, c1, at=(cx, sd.cy), net=net)

    # ports: A, B, CIN on poly extended above top row
    for col, gnet in gate_nets.items():
        if gnet in ("A", "B", "CIN"):
            x = col_x[col]
            port_shape = c.rect(POLY, x0=x-l/2, x1=x+l/2,
                                y0=p_y1+0.35, y1=p_y1+0.55, net=gnet)
            c.port(gnet, on=port_shape, dir="in")

    # COUT, SUM: extend c1 trunk to right edge
    for net in ("COUT", "SUM"):
        if net in net_pins:
            pins = net_pins[net]
            cx = sum(p[0].sd[p[1]].cx for p in pins)/len(pins)
            cy = (p_y0 + p_y1)/2
            c.rect(c1, x0=cx-0.115, x1=wx1+0.6, y0=cy-0.115, y1=cy+0.115, net=net)
            c.port(net, on=c.rect(c1, x0=wx1+0.3, x1=wx1+0.6,
                                  y0=cy-0.115, y1=cy+0.115, net=net), dir="out")

    # VDD, VSS ports on straps at right edge
    c.port("VDD", on=c.rect(c0, x0=wx1-0.6, x1=wx1, y0=p_y0, y1=p_y1, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=wx1-0.6, x1=wx1, y0=n_y0, y1=n_y1, net="VSS"))

    return c

# ---------------------------------------------------------------- top cell
fa_cell = build_fa(Cell("fa"))
top = Cell("rca8")

pitch_x = 9.0
start_y = 0.0
insts = []
for i in range(8):
    conns = {"VSS": "VSS", "VDD": "VDD",
             "A": f"A{i}", "B": f"B{i}",
             "CIN": "CIN" if i == 0 else f"k{i-1}",
             "COUT": "COUT" if i == 7 else f"k{i}",
             "SUM": f"S{i}"}
    insts.append(top.place(fa_cell, at=(i*pitch_x, start_y),
                           name=f"XFA{i}", conns=conns))

for i in range(8):
    top.port(f"A{i}", on=insts[i].pin("A"), dir="in")
    top.port(f"B{i}", on=insts[i].pin("B"), dir="in")
    top.port(f"S{i}", on=insts[i].pin("SUM"), dir="out")
top.port("CIN", on=insts[0].pin("CIN"), dir="in")
top.port("COUT", on=insts[7].pin("COUT"), dir="out")
top.port("VDD", on=insts[0].pin("VDD"), dir="inout")
top.port("VSS", on=insts[0].pin("VSS"), dir="inout")

TOP = top
