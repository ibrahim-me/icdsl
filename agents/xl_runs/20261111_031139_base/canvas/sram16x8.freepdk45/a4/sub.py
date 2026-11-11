from icdsl.canvas import *

tech = use()
c0, m1, m2, m3 = tech.c0, tech.metal(1), tech.metal(2), tech.metal(3)

# ---------------------------------------------------------------- 6T cell
def sram6t(name="sram6t"):
    c = Cell(name)
    nw, pw, l = 0.09, 0.18, 0.05
    tp = 0.34
    yn = 0.30
    yp = yn + 0.70

    a  = c.mos("nmos", w=nw, l=l, nf=1, gates="WL", sd=("BL",  "Q"),  at=(0,     yn))
    d1 = c.mos("nmos", w=nw, l=l, nf=1, gates="QB", sd=("Q",  "VSS"), at=(tp,   yn))
    d2 = c.mos("nmos", w=nw, l=l, nf=1, gates="Q",  sd=("QB", "VSS"), at=(2*tp, yn))
    b  = c.mos("nmos", w=nw, l=l, nf=1, gates="WL", sd=("BLB", "QB"), at=(3*tp, yn))
    p1 = c.mos("pmos", w=pw, l=l, nf=1, gates="QB", sd=("VDD", "Q"),  at=(tp,   yp))
    p2 = c.mos("pmos", w=pw, l=l, nf=1, gates="Q",  sd=("QB", "VDD"), at=(2*tp, yp))

    # wells
    c.rect("pwell", x0=min(a.diff.left,d1.diff.left,d2.diff.left,b.diff.left)-0.10,
             x1=max(a.diff.right,d1.diff.right,d2.diff.right,b.diff.right)+0.10,
             y0=min(a.diff.bottom,d1.diff.bottom,d2.diff.bottom,b.diff.bottom)-0.10,
             y1=max(a.diff.top,d1.diff.top,d2.diff.top,b.diff.top)+0.10)
    c.rect("nwell", x0=min(p1.diff.left,p2.diff.left)-0.10,
             x1=max(p1.diff.right,p2.diff.right)+0.10,
             y0=min(p1.diff.bottom,p2.diff.bottom)-0.10,
             y1=max(p1.diff.top,p2.diff.top)+0.10, net="VDD")

    # Q node on m1 (c0 == m1 on freepdk45)
    q = c.rect(m1, x0=min(a.sd[1].left, d1.sd[0].left, p1.sd[1].left),
               x1=max(a.sd[1].right, d1.sd[0].right, p1.sd[1].right),
               y0=min(a.sd[1].bottom, d1.sd[0].bottom, p1.sd[1].bottom),
               y1=max(a.sd[1].top, d1.sd[0].top, p1.sd[1].top), net="Q")
    c.via("poly", m1, at=(d2.gates[0].cx, q.cy), net="Q")
    c.via("poly", m1, at=(p2.gates[0].cx, q.cy), net="Q")

    # QB node on m1
    qb = c.rect(m1, x0=min(b.sd[1].left, d2.sd[0].left, p2.sd[0].left),
                x1=max(b.sd[1].right, d2.sd[0].right, p2.sd[0].right),
                y0=min(b.sd[1].bottom, d2.sd[0].bottom, p2.sd[0].bottom),
                y1=max(b.sd[1].top, d2.sd[0].top, p2.sd[0].top), net="QB")
    c.via("poly", m1, at=(d1.gates[0].cx, qb.cy), net="QB")
    c.via("poly", m1, at=(p1.gates[0].cx, qb.cy), net="QB")

    # VDD / VSS straps on m1
    c.rect(m1, x0=p1.sd[0].left, x1=p2.sd[1].right,
           y0=min(p1.sd[0].bottom, p2.sd[1].bottom),
           y1=max(p1.sd[0].top, p2.sd[1].top), net="VDD")
    c.rect(m1, x0=d1.sd[1].left, x1=d2.sd[1].right,
           y0=min(d1.sd[1].bottom, d2.sd[1].bottom),
           y1=max(d1.sd[1].top, d2.sd[1].top), net="VSS")

    # word line on m1 across the cell, contacts to access gates
    wl = c.rect(m1, x0=0.02, x1=4*tp-0.02,
                y0=yn+0.28, y1=yn+0.28+0.10, net="WL")
    c.via("poly", m1, at=(a.gates[0].cx, wl.cy), net="WL")
    c.via("poly", m1, at=(b.gates[0].cx, wl.cy), net="WL")

    # cell ports (all on m1 / c0)
    c.port("VDD", on=p1.sd[0], dir="in")
    c.port("VSS", on=d1.sd[1], dir="in")
    c.port("WL",  on=wl, dir="in")
    c.port("BL",  on=a.sd[0], dir="in")
    c.port("BLB", on=b.sd[0], dir="in")

    bb = c.bbox
    return c

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
cols, rows = 8, 16
cell = sram6t()
pitch_x, pitch_y = 1.55, 1.49

insts = {}
for r in range(rows):
    for cc in range(cols):
        insts[(r, cc)] = top.place(cell, at=(cc*pitch_x, r*pitch_y),
                                   name=f"XB{r}_{cc}",
                                   conns={"VDD":"VDD","VSS":"VSS",
                                          "BL":f"BL{cc}","BLB":f"BLB{cc}","WL":f"WL{r}"})

# bit lines on m2 (vertical), vias from cell m1 ports
for cc in range(cols):
    for suf in ("BL", "BLB"):
        pts = [insts[(r, cc)].pin(suf) for r in range(rows)]
        x0 = min(p.cx for p in pts) - 0.04
        x1 = max(p.cx for p in pts) + 0.04
        y0 = min(p.bottom for p in pts) - 0.05
        y1 = max(p.top   for p in pts) + 0.05
        top.rect(m2, x0=x0, x1=x1, y0=y0, y1=y1, net=f"{suf}{cc}")
        for p in pts:
            top.via(m1, m2, at=(p.cx, p.cy), net=f"{suf}{cc}")

# word lines on m1 (horizontal)
for r in range(rows):
    pts = [insts[(r, cc)].pin("WL") for cc in range(cols)]
    x0 = min(p.left  for p in pts) - 0.05
    x1 = max(p.right for p in pts) + 0.05
    y0 = min(p.bottom for p in pts) - 0.05
    y1 = max(p.top   for p in pts) + 0.05
    top.rect(m1, x0=x0, x1=x1, y0=y0, y1=y1, net=f"WL{r}")

# supply rails on m3 (horizontal), vias from cell m1 ports
for net, port in (("VDD", "VDD"), ("VSS", "VSS")):
    pts = [insts[(r, cc)].pin(port) for r in range(rows) for cc in range(cols)]
    x0 = min(p.left  for p in pts) - 0.05
    x1 = max(p.right for p in pts) + 0.05
    y0 = min(p.bottom for p in pts) - 0.05
    y1 = max(p.top   for p in pts) + 0.05
    cy = (y0 + y1) / 2
    top.rect(m3, x0=x0, x1=x1, y0=cy-0.055, y1=cy+0.055, net=net)
    for p in pts:
        top.via(m1, m3, at=(p.cx, cy), net=net)

# top-level pins
x0 = min(insts[(r, cc)].pin("VDD").left  for r in range(rows) for cc in range(cols)) - 0.05
x1 = max(insts[(r, cc)].pin("VDD").right for r in range(rows) for cc in range(cols)) + 0.05
for net, port in (("VDD", "VDD"), ("VSS", "VSS")):
    pts = [insts[(r, cc)].pin(port) for r in range(rows) for cc in range(cols)]
    cy = (min(p.bottom for p in pts) + max(p.top for p in pts)) / 2
    top.port(net, on=top.rect(m3, x0=x0, x1=x1, y0=cy-0.055, y1=cy+0.055, net=net))
for cc in range(cols):
    for suf in ("BL", "BLB"):
        pts = [insts[(r, cc)].pin(suf) for r in range(rows)]
        x = pts[0].cx
        y0 = min(p.bottom for p in pts) - 0.2
        y1 = max(p.top   for p in pts) + 0.2
        top.port(f"{suf}{cc}", on=top.rect(m2, x0=x-0.04, x1=x+0.04, y0=y0, y1=y1, net=f"{suf}{cc}"))
for r in range(rows):
    pts = [insts[(r, cc)].pin("WL") for cc in range(cols)]
    y = pts[0].cy
    top.port(f"WL{r}", on=top.rect(m1, x0=x0-0.2, x1=x1+0.2,
                                   y0=y-0.055, y1=y+0.055, net=f"WL{r}"))

TOP = top
