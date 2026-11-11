from icdsl.canvas import *

tech = use()
c0, c1 = tech.c0, tech.c1
POLY, DIFF, NWELL = "poly", "diff", "nwell"

def build_fa(c, name="fa"):
    wn, wp, l = 0.36, 0.72, 0.28
    gx = 1.3
    n_row_h = 2.0
    p_row_h = 2.0
    row_gap = 1.0

    col_x = [i * gx for i in range(5)]   # A, B, CIN, CB, SB
    n_y = 0.0
    p_y = n_row_h + row_gap

    transistors = [
        # (name, kind, gate_net, col, row, s_net, d_net)
        ("n0_0","nmos","A",0,0,"VSS","n1"),
        ("n0_1","nmos","B",1,0,"n1","VSS"),
        ("n0_2","nmos","CIN",2,0,"CB","n1"),
        ("n0_3","nmos","B",1,0,"n2","CB"),
        ("n0_4","nmos","A",0,0,"VSS","n2"),
        ("n0_5","nmos","A",0,0,"n3","VSS"),
        ("n0_6","nmos","B",1,0,"VSS","n3"),
        ("n0_7","nmos","CIN",2,0,"n3","VSS"),
        ("n0_8","nmos","CB",3,0,"SB","n3"),
        ("n0_9","nmos","CIN",2,0,"n5","SB"),
        ("n0_10","nmos","B",1,0,"n4","n5"),
        ("n0_11","nmos","A",0,0,"VSS","n4"),
        ("n0_12","nmos","CB",3,0,"COUT","VSS"),
        ("n14","nmos","SB",4,0,"VSS","SUM"),
        ("p0_0","pmos","A",0,1,"VDD","p1"),
        ("p0_1","pmos","B",1,1,"p1","VDD"),
        ("p0_2","pmos","CIN",2,1,"CB","p1"),
        ("p0_3","pmos","B",1,1,"p2","CB"),
        ("p0_4","pmos","A",0,1,"VDD","p2"),
        ("p0_5","pmos","A",0,1,"p3","VDD"),
        ("p0_6","pmos","B",1,1,"VDD","p3"),
        ("p0_7","pmos","CIN",2,1,"p3","VDD"),
        ("p0_8","pmos","CB",3,1,"SB","p3"),
        ("p0_9","pmos","CIN",2,1,"p5","SB"),
        ("p0_10","pmos","B",1,1,"p4","p5"),
        ("p0_11","pmos","A",0,1,"VDD","p4"),
        ("p0_12","pmos","CB",3,1,"COUT","VDD"),
        ("p14","pmos","SB",4,1,"VDD","SUM"),
    ]

    devices = {}
    for tname, kind, gate_net, col, row, snet, dnet in transistors:
        x = col_x[col]
        y = n_y if row == 0 else p_y
        dev = c.mos(kind, w=wn if kind == "nmos" else wp, l=l,
                    gates=gate_net, sd=(snet, dnet), at=(x, y))
        devices[tname] = dev

    # vertical poly strips for each gate-net column
    for col, gate_net in enumerate(["A", "B", "CIN", "CB", "SB"]):
        x = col_x[col]
        c.rect(POLY, x0=x - l / 2, x1=x + l / 2,
               y0=n_y - 0.3, y1=p_y + p_row_h + 0.3, net=gate_net)

    # route internal nodes on c1 with c0 jogs
    net_straps = {}
    for tname, kind, gate_net, col, row, snet, dnet in transistors:
        dev = devices[tname]
        for sd_idx, net in ((0, snet), (1, dnet)):
            if net in ("VSS", "VDD"):
                continue
            net_straps.setdefault(net, []).append(dev.sd[sd_idx])

    for net, straps in net_straps.items():
        if len(straps) < 2:
            continue
        xs = [s.cx for s in straps]
        ys = [s.cy for s in straps]
        cx = sum(xs) / len(xs)
        y0 = min(ys) - 0.25
        y1 = max(ys) + 0.25
        c.rect(c1, x0=cx - 0.13, x1=cx + 0.13, y0=y0, y1=y1, net=net)
        for s in straps:
            jx0 = min(s.cx, cx); jx1 = max(s.cx, cx)
            jy0 = s.cy - 0.13; jy1 = s.cy + 0.13
            c.rect(c0, x0=jx0, x1=jx1, y0=jy0, y1=jy1, net=net)
            c.via(c0, c1, at=(cx, s.cy), net=net)

    # VSS / VDD straps on c0
    c.rect(c0, x0=col_x[0] - 0.6, x1=col_x[-1] + l / 2 + 0.6,
           y0=n_y - 0.3, y1=n_y + n_row_h + 0.3, net="VSS")
    c.rect(c0, x0=col_x[0] - 0.6, x1=col_x[-1] + l / 2 + 0.6,
           y0=p_y - 0.3, y1=p_y + p_row_h + 0.3, net="VDD")

    for tname, kind, gate_net, col, row, snet, dnet in transistors:
        dev = devices[tname]
        for sd_idx, net in ((0, snet), (1, dnet)):
            if net == "VSS" and row == 0:
                c.via(DIFF, c0, at=(dev.sd[sd_idx].cx, dev.sd[sd_idx].cy), net="VSS")
            if net == "VDD" and row == 1:
                c.via(DIFF, c0, at=(dev.sd[sd_idx].cx, dev.sd[sd_idx].cy), net="VDD")

    # nwell around PMOS row
    c.rect(NWELL, x0=col_x[0] - 0.8, x1=col_x[-1] + l / 2 + 0.8,
           y0=p_y - 0.7, y1=p_y + p_row_h + 0.7, net="VDD")

    # taps
    c.tap("ptap", x0=col_x[0] - 0.8, y0=n_y - 1.2,
          x1=col_x[-1] + l / 2 + 0.8, y1=n_y - 0.4, net="VSS")
    c.tap("ntap", x0=col_x[0] - 0.8, y0=p_y + p_row_h + 0.4,
          x1=col_x[-1] + l / 2 + 0.8, y1=p_y + p_row_h + 1.2, net="VDD")

    # extend gate polys for input ports
    for col, gate_net in enumerate(["A", "B", "CIN"]):
        x = col_x[col]
        c.rect(POLY, x0=x - l / 2, x1=x + l / 2,
               y0=p_y + p_row_h + 0.45, y1=p_y + p_row_h + 0.85, net=gate_net)

    # output extensions on c1
    for net in ("COUT", "SUM"):
        if net in net_straps:
            straps = net_straps[net]
            cx = sum(s.cx for s in straps) / len(straps)
            cy = (p_y + p_row_h) / 2
            c.rect(c1, x0=cx - 0.13, x1=col_x[-1] + l / 2 + 1.0,
                   y0=cy - 0.13, y1=cy + 0.13, net=net)

    # ports
    for col, gate_net in enumerate(["A", "B", "CIN"]):
        x = col_x[col]
        c.port(gate_net, on=c.rect(POLY, x0=x - l / 2, x1=x + l / 2,
                                   y0=p_y + p_row_h + 0.65, y1=p_y + p_row_h + 0.85,
                                   net=gate_net), dir="in")

    for net in ("COUT", "SUM"):
        if net in net_straps:
            straps = net_straps[net]
            cx = sum(s.cx for s in straps) / len(straps)
            cy = (p_y + p_row_h) / 2
            c.port(net, on=c.rect(c1, x0=col_x[-1] + l / 2 + 0.3,
                                  x1=col_x[-1] + l / 2 + 1.0,
                                  y0=cy - 0.13, y1=cy + 0.13, net=net), dir="out")

    c.port("VDD", on=c.rect(c0, x0=col_x[-1] + l / 2 - 0.6,
                            x1=col_x[-1] + l / 2 + 0.6,
                            y0=p_y - 0.3, y1=p_y + p_row_h + 0.3, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=col_x[-1] + l / 2 - 0.6,
                            x1=col_x[-1] + l / 2 + 0.6,
                            y0=n_y - 0.3, y1=n_y + n_row_h + 0.3, net="VSS"))

    return c

fa_cell = Cell("fa")
build_fa(fa_cell)

top = Cell("rca8")
pitch_x = 7.0
insts = []
for i in range(8):
    conns = {"VSS": "VSS", "VDD": "VDD",
             "A": f"A{i}", "B": f"B{i}",
             "CIN": "CIN" if i == 0 else f"k{i-1}",
             "COUT": "COUT" if i == 7 else f"k{i}",
             "SUM": f"S{i}"}
    insts.append(top.place(fa_cell, at=(i * pitch_x, 0.0), name=f"XFA{i}", conns=conns))

for i in range(8):
    top.port(f"A{i}", on=insts[i].pin("A"), dir="in")
    top.port(f"B{i}", on=insts[i].pin("B"), dir="in")
    top.port(f"S{i}", on=insts[i].pin("SUM"), dir="out")
top.port("CIN", on=insts[0].pin("CIN"), dir="in")
top.port("COUT", on=insts[7].pin("COUT"), dir="out")
top.port("VDD", on=insts[0].pin("VDD"), dir="inout")
top.port("VSS", on=insts[0].pin("VSS"), dir="inout")

TOP = top
