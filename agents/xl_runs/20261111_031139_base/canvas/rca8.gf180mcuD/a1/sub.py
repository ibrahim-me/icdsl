from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, c1 = tech.c0, tech.c1
POLY, DIFF, NWELL = "poly", "diff", "nwell"

# ---------------------------------------------------------------- full adder
def build_fa(c, name="fa"):
    # ---- device sizes (from netlist) ---------------------------------
    wn, wp, l = 0.36, 0.72, 0.28
    # placement grid
    gx = 0.78          # poly pitch (gate + space + contact room)
    row_h = 1.6        # row height (diffusion + contacts)
    row_gap = 1.1      # gap between n and p rows
    col_x = [0, gx, 2*gx, 3*gx, 4*gx]   # A, B, CIN, CB, SB

    # transistor placement: (name, kind, gate_col, row, s_net, d_net)
    # row 0 = NMOS (bottom), row 1 = PMOS (top)
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

    # ---- connect gates (poly) ----------------------------------------
    gate_nets = {0:"A", 1:"B", 2:"CIN", 3:"CB", 4:"SB"}
    for col, gnet in gate_nets.items():
        x = col_x[col]
        # vertical poly strip through both rows
        y0 = 0 - 0.15
        y1 = row_h + row_gap + row_h + 0.15
        c.rect(POLY, x0=x-l/2, x1=x+l/2, y0=y0, y1=y1, net=gnet)

    # ---- diffusion straps on c0 (horizontal, per row) ----------------
    # NMOS row: VSS strap
    n_y0 = 0 - 0.1; n_y1 = row_h + 0.1
    c.rect(c0, x0=col_x[0]-0.5, x1=col_x[-1]+l/2+0.5, y0=n_y0, y1=n_y1, net="VSS")
    # PMOS row: VDD strap
    p_y0 = row_h + row_gap - 0.1; p_y1 = row_h + row_gap + row_h + 0.1
    c.rect(c0, x0=col_x[0]-0.5, x1=col_x[-1]+l/2+0.5, y0=p_y0, y1=p_y1, net="VDD")

    # ---- well around PMOS row ----------------------------------------
    wy0 = p_y0 - 0.6; wy1 = p_y1 + 0.6
    wx0 = col_x[0] - 0.8; wx1 = col_x[-1] + l/2 + 0.8
    c.rect(NWELL, x0=wx0, x1=wx1, y0=wy0, y1=wy1, net="VDD")

    # ---- contacts from diffusion to c0 straps ------------------------
    def strap_contact(dev, sd_idx, strap_net):
        sd = dev.sd[sd_idx]
        # contact centered on the diffusion, on the strap line
        cx = sd.cx
        cy = n_y1 if strap_net=="VSS" else p_y0
        cy = min(max(cy, n_y0 if strap_net=="VSS" else p_y0),
                 n_y1 if strap_net=="VSS" else p_y1)
        c.via(DIFF, c0, at=(cx, cy), net=strap_net)

    # connect each transistor's source/drain to straps or route later
    # We'll route internal nodes with metal; strap connections:
    for tname, kind, col, row, snet, dnet in place:
        dev = devices[tname]
        if snet == "VSS" and row == 0:
            strap_contact(dev, 0, "VSS")
        if dnet == "VSS" and row == 0:
            strap_contact(dev, 1, "VSS")
        if snet == "VDD" and row == 1:
            strap_contact(dev, 0, "VDD")
        if dnet == "VDD" and row == 1:
            strap_contact(dev, 1, "VDD")

    # ---- route internal nodes on c1 (vertical) with c0 jogs -----------
    # internal nodes: n1..n5, p1..p5, CB, SB, COUT, SUM
    # We route each net that connects multiple devices.
    net_pins = {}   # net -> list of (device, sd_idx)
    for tname, kind, col, row, snet, dnet in place:
        dev = devices[tname]
        for sd_idx, net in ((0, snet), (1, dnet)):
            if net not in ("VSS", "VDD"):
                net_pins.setdefault(net, []).append((dev, sd_idx))

    for net, pins in net_pins.items():
        if len(pins) < 2:
            continue
        # route on c1: vertical trunk at average x, horizontal c0 jogs to each pin
        xs = [p[0].sd[p[1]].cx for p in pins]
        ys = [p[0].sd[p[1]].cy for p in pins]
        cx = sum(xs)/len(xs)
        ymin = min(ys) - 0.3; ymax = max(ys) + 0.3
        c.rect(c1, x0=cx-0.115, x1=cx+0.115, y0=ymin, y1=ymax, net=net)
        for dev, sd_idx in pins:
            sd = dev.sd[sd_idx]
            # c0 jog from pin to c1 trunk
            jx0 = min(sd.cx, cx); jx1 = max(sd.cx, cx)
            jy0 = sd.cy - 0.115; jy1 = sd.cy + 0.115
            c.rect(c0, x0=jx0, x1=jx1, y0=jy0, y1=jy1, net=net)
            c.via(c0, c1, at=(cx, sd.cy), net=net)

    # ---- ports --------------------------------------------------------
    # A, B, CIN: poly gates (extend poly above top row for port access)
    for col, gnet in gate_nets.items():
        if gnet in ("A", "B", "CIN"):
            x = col_x[col]
            c.rect(POLY, x0=x-l/2, x1=x+l/2, y0=p_y1+0.15, y1=p_y1+0.55, net=gnet)
            c.port(gnet, on=c.rect(POLY, x0=x-l/2, x1=x+l/2,
                                   y0=p_y1+0.35, y1=p_y1+0.55, net=gnet), dir="in")

    # COUT, SUM: on c1 trunk (route to right edge)
    for net in ("COUT", "SUM"):
        if net in net_pins:
            pins = net_pins[net]
            cx = sum(p[0].sd[p[1]].cx for p in pins)/len(pins)
            cy = (p_y0 + p_y1)/2
            # extend c1 to right edge
            c.rect(c1, x0=cx-0.115, x1=wx1+0.6, y0=cy-0.115, y1=cy+0.115, net=net)
            c.port(net, on=c.rect(c1, x0=wx1+0.3, x1=wx1+0.6,
                                  y0=cy-0.115, y1=cy+0.115, net=net), dir="out")

    # VDD, VSS ports on straps
    c.port("VDD", on=c.rect(c0, x0=wx1-0.6, x1=wx1, y0=p_y0, y1=p_y1, net="VDD"))
    c.port("VSS", on=c.rect(c0, x0=wx1-0.6, x1=wx1, y0=n_y0, y1=n_y1, net="VSS"))

    return c, devices

# ---------------------------------------------------------------- top cell
top = Cell("rca8")
fa_cell, _ = build_fa(Cell("fa"))

# place 8 full adders in a row
pitch_x = 9.0   # horizontal pitch between full adders
start_y = 0.0
insts = []
for i in range(8):
    conns = {"VSS": "VSS", "VDD": "VDD",
             "A": f"A{i}", "B": f"B{i}",
             "CIN": "CIN" if i == 0 else f"k{i-1}",
             "COUT": "COUT" if i == 7 else f"k{i}",
             "SUM": f"S{i}"}
    inst = top.place(fa_cell, at=(i*pitch_x, start_y), name=f"XFA{i}", conns=conns)
    insts.append(inst)

# top-level ports
for i in range(8):
    top.port(f"A{i}", on=insts[i].pin("A"), dir="in")
    top.port(f"B{i}", on=insts[i].pin("B"), dir="in")
    top.port(f"S{i}", on=insts[i].pin("SUM"), dir="out")
top.port("CIN", on=insts[0].pin("CIN"), dir="in")
top.port("COUT", on=insts[7].pin("COUT"), dir="out")
top.port("VDD", on=insts[0].pin("VDD"), dir="inout")
top.port("VSS", on=insts[0].pin("VSS"), dir="inout")

TOP = top
