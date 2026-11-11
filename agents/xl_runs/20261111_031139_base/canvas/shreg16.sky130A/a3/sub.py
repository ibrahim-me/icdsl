from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- dff cell
def build_dff(c):
    TP = 1.50          # column pitch
    ROWH = 3.20        # row pitch
    NWELL_PAD = 0.30
    X0, Y0 = 0.6, 0.6

    def nfet(name, gate, s, d, col, row):
        return c.mos("nmos", w=0.42, l=0.15, nf=1, gates=gate, sd=(s, d),
                     at=(X0 + col * TP, Y0 + row * ROWH), name=name)

    def pfet(name, gate, s, d, col, row):
        return c.mos("pmos", w=0.84, l=0.15, nf=1, gates=gate, sd=(s, d),
                     at=(X0 + col * TP, Y0 + row * ROWH), name=name)

    # ---- master latch
    mn00 = nfet("mn00", "CK", "VSS", "CKB", 0, 0)
    mn01 = nfet("mn01", "D",  "VSS", "n1",  1, 0)
    mn02 = nfet("mn02", "CKB","n1",  "m",   2, 0)
    mn03 = nfet("mn03", "CK", "m",   "n2",  3, 0)
    mn04 = nfet("mn04", "mb", "n2",  "VSS", 4, 0)
    mn05 = nfet("mn05", "m",  "VSS", "mb",  5, 0)
    mp00 = pfet("mp00", "CK", "VDD", "CKB", 0, 1)
    mp01 = pfet("mp01", "D",  "VDD", "p1",  1, 1)
    mp02 = pfet("mp02", "CK", "p1",  "m",   2, 1)
    mp03 = pfet("mp03", "CKB","m",   "p2",  3, 1)
    mp04 = pfet("mp04", "mb", "p2",  "VDD", 4, 1)
    mp05 = pfet("mp05", "m",  "VDD", "mb",  5, 1)

    # ---- slave latch
    mn70 = nfet("mn70", "Q",  "VSS", "n3",  0, 2)
    mn71 = nfet("mn71", "CKB","n3",  "s",   1, 2)
    mn72 = nfet("mn72", "CK", "s",   "n4",  2, 2)
    mn73 = nfet("mn73", "mb", "n4",  "VSS", 3, 2)
    mn74 = nfet("mn74", "s",  "VSS", "Q",   4, 2)
    mp70 = pfet("mp70", "Q",  "VDD", "p3",  0, 3)
    mp71 = pfet("mp71", "CK", "p3",  "s",   1, 3)
    mp72 = pfet("mp72", "CKB","s",   "p4",  2, 3)
    mp73 = pfet("mp73", "mb", "p4",  "VDD", 3, 3)
    mp74 = pfet("mp74", "s",  "VDD", "Q",   4, 3)

    # nwell over pmos rows
    if mp00.well:
        c.rect(mp00.well.layer,
               x0=mp00.well.left - NWELL_PAD, x1=mp74.well.right + NWELL_PAD,
               y0=min(mp00.well.bottom, mp70.well.bottom) - NWELL_PAD,
               y1=max(mp05.well.top, mp74.well.top) + NWELL_PAD, net="VDD")

    # ---- local interconnect: c0 straps + m1 horizontal rails
    def strap(net, shapes):
        rails = [s for s in shapes if s is not None]
        if not rails:
            return None
        x0 = min(r.left for r in rails); x1 = max(r.right for r in rails)
        y0 = min(r.bottom for r in rails); y1 = max(r.top for r in rails)
        c.rect(c0, x0=x0, x1=x1, y0=y0, y1=y1, net=net)
        r = c.rect(m1, x0=x0 - 0.07, x1=x1 + 0.07, y0=y0 - 0.07, y1=y1 + 0.07, net=net)
        for s in rails:
            c.via(c0, m1, at=((s.left + s.right) / 2, (s.bottom + s.top) / 2), net=net)
        return r

    vss_n = strap("VSS", [mn00.sd[0], mn01.sd[0], mn04.sd[1], mn05.sd[0],
                          mn70.sd[0], mn73.sd[1], mn74.sd[0]])
    vdd_p = strap("VDD", [mp00.sd[0], mp01.sd[0], mp04.sd[1], mp05.sd[1],
                          mp70.sd[0], mp73.sd[1], mp74.sd[1]])

    def con(net, *shapes):
        pts = [(s.cx, s.cy) for s in shapes]
        if len(pts) < 2:
            return
        c.wire(m1, pts, width=0.3, net=net, first="h")
        for s in shapes:
            c.via(c0, m1, at=(s.cx, s.cy), net=net)

    con("CKB", mn00.sd[1], mp00.sd[1])
    con("n1", mn01.sd[1], mn02.sd[0])
    con("p1", mp01.sd[1], mp02.sd[0])
    con("m", mn02.sd[1], mp02.sd[1], mn03.sd[1], mp03.sd[0])
    con("mb", mn04.sd[0], mn05.sd[0], mp04.sd[0], mp05.sd[0],
        mn73.sd[0], mp73.sd[0])
    con("n2", mn03.sd[0], mn04.sd[1])
    con("p2", mp03.sd[1], mp04.sd[1])
    con("n3", mn70.sd[1], mn71.sd[0])
    con("p3", mp70.sd[1], mp71.sd[0])
    con("s", mn71.sd[1], mp71.sd[1], mn72.sd[0], mp72.sd[0],
        mn74.sd[1], mp74.sd[1])
    con("n4", mn72.sd[1], mn73.sd[1])
    con("p4", mp72.sd[1], mp73.sd[1])

    # ---- ports on m1 at top of cell
    d_pin = c.rect(m1, x0=mn01.gates[0].cx - 0.12, x1=mn01.gates[0].cx + 0.12,
                   y0=mn01.gates[0].top, y1=mn01.gates[0].top + 0.75, net="D")
    c.via(c0, m1, at=(mn01.gates[0].cx, mn01.gates[0].top), net="D")
    ck_pin = c.rect(m1, x0=mn00.gates[0].cx - 0.12, x1=mn00.gates[0].cx + 0.12,
                    y0=mn00.gates[0].top, y1=mn00.gates[0].top + 0.75, net="CK")
    c.via(c0, m1, at=(mn00.gates[0].cx, mn00.gates[0].top), net="CK")
    q_pin = c.rect(m1, x0=mn74.gates[0].cx - 0.12, x1=mn74.gates[0].cx + 0.12,
                   y0=mn74.gates[0].top, y1=mn74.gates[0].top + 0.75, net="Q")
    c.via(c0, m1, at=(mn74.gates[0].cx, mn74.gates[0].top), net="Q")

    vss_pin = c.rect(m1, x0=vss_n.left - 0.1, x1=vss_n.right + 0.1,
                     y0=vss_n.top, y1=vss_n.top + 0.75, net="VSS") if vss_n else None
    vdd_pin = c.rect(m1, x0=vdd_p.left - 0.1, x1=vdd_p.right + 0.1,
                     y0=vdd_p.top, y1=vdd_p.top + 0.75, net="VDD") if vdd_p else None

    c.port("D", d_pin, "in"); c.port("CK", ck_pin, "in"); c.port("Q", q_pin, "out")
    if vss_pin: c.port("VSS", vss_pin, "in")
    if vdd_pin: c.port("VDD", vdd_pin, "in")

# ---------------------------------------------------------------- top cell
top = Cell("shreg16")
dff = Cell("dff")
build_dff(dff)

PITCH = 9.6
ROW_H = 15.6

insts = []
for i in range(16):
    insts.append(top.place(dff, at=(i * PITCH, 0), name="FF%d" % i,
                           conns={"VDD": "VDD", "VSS": "VSS",
                                  "CK": "CK", "D": ("D" if i == 0 else "Q%d" % (i - 1)),
                                  "Q": "Q%d" % i}))

def rail(net, insts, portname, y):
    shapes = [i.pin(portname) for i in insts]
    x0 = min(s.left for s in shapes) - 0.2
    x1 = max(s.right for s in shapes) + 0.2
    r = top.rect(m2, x0=x0, x1=x1, y0=y - 0.14, y1=y + 0.14, net=net)
    for s in shapes:
        top.via(m1, m2, at=(s.cx, y), net=net)
    top.port(net, on=r, dir="in" if net in ("D", "CK") else "inout")

rail("VDD", insts, "VDD", ROW_H + 0.9)
rail("VSS", insts, "VSS", ROW_H + 0.9)
rail("CK", insts, "CK", ROW_H + 2.1)
rail("D", insts, "D", ROW_H + 3.3)

for i in range(16):
    qpin = insts[i].pin("Q")
    qtop = top.rect(m2, x0=qpin.left - 0.12, x1=qpin.right + 0.12,
                    y0=ROW_H + 4.5, y1=ROW_H + 5.2, net="Q%d" % i)
    top.via(m1, m2, at=(qpin.cx, ROW_H + 4.5), net="Q%d" % i)
    top.port("Q%d" % i, on=qtop, dir="out")

TOP = top

