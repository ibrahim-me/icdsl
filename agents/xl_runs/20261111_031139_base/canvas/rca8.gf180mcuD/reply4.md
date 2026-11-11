```
from icdsl.canvas import *

tech = use()
c0, c1, c2 = tech.c0, tech.c1, tech.c2
POLY, DIFF, NWELL = "poly", "diff", "nwell"

PITCH = 0.72          # transistor centre-to-centre x pitch
NY = 0.0              # nMOS row y
PY = 4.6              # pMOS row y
ROW_GAP = PY - NY

# transistor placement order: (n_name, p_name, gate_net)
order = [
    ("n0_0","p0_0","A"), ("n0_1","p0_1","B"), ("n0_2","p0_2","CIN"),
    ("n0_3","p0_3","B"), ("n0_4","p0_4","A"), ("n0_5","p0_5","A"),
    ("n0_6","p0_6","B"), ("n0_7","p0_7","CIN"), ("n0_8","p0_8","CB"),
    ("n0_9","p0_9","CIN"), ("n0_10","p0_10","B"), ("n0_11","p0_11","A"),
    ("n0_12","p0_12","CB"), ("n14","p14","SB"),
]

def build_fa(c, name="fa"):
    devs = {}
    for i, (nn, pn, gnet) in enumerate(order):
        x = i * PITCH
        nd = c.mos("nmos", w=0.36, l=0.28, gates=gnet, sd=("X","X"), at=(x, NY))
        pd = c.mos("pmos", w=0.72, l=0.28, gates=gnet, sd=("X","X"), at=(x, PY))
        devs[nn] = nd; devs[pn] = pd

    # ---- set source/drain nets by reconnecting sd straps ----
    # (mos PCell creates sd straps; we just route metal to them, nets are defined by connections)
    # We do NOT change sd nets here; routing defines connectivity.

    # ---- route gates: metal1 horizontal segments + vias to poly ----
    gate_groups = {}
    for i, (nn, pn, gnet) in enumerate(order):
        gate_groups.setdefault(gnet, []).append((i, devs[nn].gates[0], devs[pn].gates[0]))

    for gnet, glist in gate_groups.items():
        xs = [i * PITCH for i, _, _ in glist]
        x0 = min(xs) - 0.14; x1 = max(xs) + 0.14
        # metal1 strap above the gates (between n and p rows)
        my = (NY + PY) / 2
        c.rect(c1, x0=x0, x1=x1, y0=my - 0.115, y1=my + 0.115, net=gnet)
        for i, ng, pg in glist:
            cx = i * PITCH
            for g in (ng, pg):
                c.via(c0, c1, at=(g.cx, my), net=gnet)
        # port extension for primary inputs
        if gnet in ("A", "B", "CIN"):
            c.rect(POLY, x0=x0, x1=x1, y0=PY + 0.5, y1=PY + 0.9, net=gnet)
            c.rect(c1, x0=x0, x1=x1, y0=PY + 0.9, y1=PY + 1.3, net=gnet)
            c.via(c0, c1, at=((x0 + x1) / 2, PY + 0.9), net=gnet)

    # ---- helper: connect a list of (shape, net) points with metal1 ----
    def route_net(net_name, points, y_layer=c1, via_layer=c0):
        if not points:
            return
        # bounding box of all points
        xs = [p.cx for p in points]
        ys = [p.cy for p in points]
        x0, x1 = min(xs), max(xs)
        y0, y1 = min(ys), max(ys)
        # trunk
        cx = (x0 + x1) / 2
        cy = (y0 + y1) / 2
        c.rect(c1, x0=cx - 0.115, x1=cx + 0.115, y0=y0, y1=y1, net=net_name)
        c.rect(c1, x0=x0, x1=x1, y0=cy - 0.115, y1=cy + 0.115, net=net_name)
        for p in points:
            if abs(p.cx - cx) > 0.01 or abs(p.cy - cy) > 0.01:
                c.rect(c0, x0=min(p.cx, cx) - 0.115, x1=max(p.cx, cx) + 0.115,
                       y0=p.cy - 0.115, y1=p.cy + 0.115, net=net_name)
                c.via(c0, c1, at=(cx, p.cy), net=net_name)
            else:
                c.via(c0, c1, at=(cx, p.cy), net=net_name)

    # ---- collect diffusion pins per net ----
    # Map: net -> list of (shape) to connect
    net_pins = {}
    def add_pin(net, shape):
        if net in ("VSS", "VDD"):
            return
        net_pins.setdefault(net, []).append(shape)

    # nMOS connections
    n_conns = {
        "n0_0": ("VSS", "n1"), "n0_1": ("n1", "VSS"), "n0_2": ("CB", "n1"),
        "n0_3": ("n2", "CB"), "n0_4": ("VSS", "n2"), "n0_5": ("n3", "VSS"),
        "n0_6": ("VSS", "n3"), "n0_7": ("n3", "VSS"), "n0_8": ("SB", "n3"),
        "n0_9": ("n5", "SB"), "n0_10": ("n4", "n5"), "n0_11": ("VSS", "n4"),
        "n0_12": ("COUT", "VSS"), "n14": ("VSS", "SUM"),
    }
    # pMOS connections
    p_conns = {
        "p0_0": ("VDD", "p1"), "p0_1": ("p1", "VDD"), "p0_2": ("CB", "p1"),
        "p0_3": ("p2", "CB"), "p0_4": ("VDD", "p2"), "p0_5": ("p3", "VDD"),
        "p0_6": ("VDD", "p3"), "p0_7": ("p3", "VDD"), "p0_8": ("SB", "p3"),
        "p0_9": ("p5", "SB"), "p0_10": ("p4", "p5"), "p0_11": ("VDD", "p4"),
        "p0_12": ("COUT", "VDD"), "p14": ("VDD", "SUM"),
    }

    for tname, (snet, dnet) in n_conns.items():
        dev = devs[tname]
        add_pin(snet, dev.sd[0]); add_pin(dnet, dev.sd[1])
    for tname, (snet, dnet) in p_conns.items():
        dev = devs[tname]
        add_pin(snet, dev.sd[0]); add_pin(dnet, dev.sd[1])

    # route all internal nets on metal1
    for net, pins in net_pins.items():
        route_net(net, pins)

    # ---- VSS / VDD rails on c0 ----
    xmin = -0.5; xmax = (len(order) - 1) * PITCH + 0.5
    c.rect(c0, x0=xmin, x1=xmax, y0=NY - 0.9, y1=NY - 0.5, net="VSS")
    c.rect(c0, x0=xmin, x1=xmax, y0=PY + 0.72 + 0.5, y1=PY + 0.72 + 0.9, net="VDD")

    # connect nMOS VSS pins to rail
    for tname in n_conns:
        dev = devs[tname]
        snet, dnet = n_conns[tname]
        if snet == "VSS":
            c.via(DIFF, c0, at=(dev.sd[0].cx, NY - 0.7), net="VSS")
        if dnet == "VSS":
            c.via(DIFF, c0, at=(dev.sd[1].cx, NY - 0.7), net="VSS")
    # connect pMOS VDD pins to rail
    for tname in p_conns:
        dev = devs[tname]
        snet, dnet = p_conns[tname]
        if snet == "VDD":
            c.via(DIFF, c0, at=(dev.sd[0].cx, PY + 0.72 + 0.7), net="VDD")
        if dnet == "VDD":
            c.via(DIFF, c0, at=(dev.sd[1].cx, PY + 0.72 + 0.7), net="VDD")

    # ---- nwell around pMOS row ----
    c.rect(NWELL, x0=xmin - 0.6, x1=xmax + 0.6,
           y0=PY - 0.6, y1=PY + 0.72 + 0.6, net="VDD")

    # ---- taps ----
    c.tap("ptap", x0=xmin - 0.6, y0=NY - 1.6,
          x1=xmax + 0.6, y1=NY - 1.0, net="VSS")
    c.tap("ntap", x0=xmin - 0.6, y0=PY + 0.72 + 1.0,
          x1=xmax + 0.6, y1=PY + 0.72 + 1.6, net="VDD")

    # ---- output extensions (COUT, SUM) to right edge ----
    for net in ("COUT", "SUM"):
        if net in net_pins:
            pins = net_pins[net]
            cy = sum(p.cy for p in pins) / len(pins)
            ex = xmax + 1.2
            c.rect(c1, x0=max(p.cx for p in pins) + 0.2, x1=ex,
                   y0=cy - 0.115, y1=cy + 0.115, net=net)

    # ---- ports ----
    for i, (nn, pn, gnet) in enumerate(order):
        if gnet in ("A", "B", "CIN"):
            cx = i * PITCH
            pr = c.rect(POLY, x0=cx - 0.14, x1=cx + 0.14,
                        y0=PY + 0.5, y1=PY + 0.9, net=gnet)
            c.port(f"{gnet}" if i == order.index((nn, pn, gnet)) else None, on=pr, dir="in")

    # Actually create ports properly below in top-level; here just create port shapes
    # COUT / SUM ports
    for net in ("COUT", "SUM"):
        if net in net_pins:
            pins = net_pins[net]
            cy = sum(p.cy for p in pins) / len(pins)
            ex = xmax + 1.2
            pr = c.rect(c1, x0=ex - 0.8, x1=ex,
                        y0=cy - 0.115, y1=cy + 0.115, net=net)
            c.port(net, on=pr, dir="out")

    # VDD / VSS ports
    c.port("VDD", on=c.rect(c0, x0=xmax - 0.6, x1=xmax + 0.6,
                            y0=PY + 0.72 + 0.5, y1=PY + 0.72 + 0.9, net="VDD"), dir="inout")
    c.port("VSS", on=c.rect(c0, x0=xmax - 0.6, x1=xmax + 0.6,
                            y0=NY - 0.9, y1=NY - 0.5, net="VSS"), dir="inout")

    return devs, order, xmax, NY, PY

fa_cell = Cell("fa")
devs, order, xmax, NY, PY = build_fa(fa_cell)

# fix input ports: create one port per unique input net
for gnet in ("A", "B", "CIN"):
    # find first transistor with this gate
    for i, (nn, pn, g) in enumerate(order):
        if g == gnet:
            cx = i * PITCH
            pr = c.rect(POLY, x0=cx - 0.14, x1=cx + 0.14,
                        y0=PY + 0.5, y1=PY + 0.9, net=gnet)
            fa_cell.port(gnet, on=pr, dir="in")
            break

# top level
top = Cell("rca8")
pitch_x = xmax + 2.0
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
```