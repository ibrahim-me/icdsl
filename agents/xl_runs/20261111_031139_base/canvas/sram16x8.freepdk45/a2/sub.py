from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ---------------------------------------------------------------- 6T cell
def sram6t(c, wl, bl, blb, vdd, vss, at=(0, 0), name="sram6t"):
    x0, y0 = at
    nw, pw, l = 0.09, 0.18, 0.05
    tp = 0.34          # gate pitch
    yn = y0 + 0.12     # nfet row
    yp = yn + 0.62     # pfet row

    # --- transistors (default c0 straps on source/drain columns) ---
    a  = c.mos("nmos", w=nw, l=l, nf=1, gates=wl, sd=(bl,  "Q"),  at=(x0,     yn))
    d1 = c.mos("nmos", w=nw, l=l, nf=1, gates="QB", sd=("Q", vss), at=(x0+tp, yn))
    d2 = c.mos("nmos", w=nw, l=l, nf=1, gates="Q",  sd=("QB",vss), at=(x0+2*tp,yn))
    b  = c.mos("nmos", w=nw, l=l, nf=1, gates=wl, sd=(blb, "QB"), at=(x0+3*tp,yn))
    p1 = c.mos("pmos", w=pw, l=l, nf=1, gates="QB", sd=(vdd,"Q"),  at=(x0+tp, yp))
    p2 = c.mos("pmos", w=pw, l=l, nf=1, gates="Q",  sd=("QB",vdd), at=(x0+2*tp,yp))

    # wells
    c.rect("pwell", x0=min(a.diff.left,d1.diff.left,d2.diff.left,b.diff.left)-0.10,
             x1=max(a.diff.right,d1.diff.right,d2.diff.right,b.diff.right)+0.10,
             y0=min(a.diff.bottom,d1.diff.bottom,d2.diff.bottom,b.diff.bottom)-0.10,
             y1=max(a.diff.top,d1.diff.top,d2.diff.top,b.diff.top)+0.10)
    c.rect("nwell", x0=min(p1.diff.left,p2.diff.left)-0.10,
             x1=max(p1.diff.right,p2.diff.right)+0.10,
             y0=min(p1.diff.bottom,p2.diff.bottom)-0.10,
             y1=max(p1.diff.top,p2.diff.top)+0.10, net=vdd)

    def m1strap(shapes, net):
        """join a list of c0/poly shapes with m1 + vias (spanning tree by x then y)"""
        ss = [s for s in shapes if s is not None]
        for i in range(1, len(ss)):
            s, t = ss[i-1], ss[i]
            r = c.rect(m1, x0=min(s.left,t.left), x1=max(s.right,t.right),
                       y0=min(s.bottom,t.bottom), y1=max(s.top,t.top), net=net)
            c.via(c0, m1, at=(r.cx, r.cy), net=net, dir="h")

    # Q node: a.sd[1] d1.sd[0] p1.sd[1] and gates of d2,p2
    m1strap([a.sd[1], d1.sd[0], p1.sd[1], d2.gates[0], p2.gates[0]], "Q")
    # QB node: b.sd[1] d2.sd[0] p2.sd[0] and gates of d1,p1
    m1strap([b.sd[1], d2.sd[0], p2.sd[0], d1.gates[0], p1.gates[0]], "QB")

    # supplies: strap p1.sd[0]/p2.sd[1] to VDD rail, d1.sd[1]/d2.sd[1] to VSS rail
    c.rect(m1, x0=p1.sd[0].left, x1=p2.sd[1].right,
           y0=min(p1.sd[0].bottom,p2.sd[1].bottom),
           y1=max(p1.sd[0].top,p2.sd[1].top), net=vdd)
    c.rect(m1, x0=d1.sd[1].left, x1=d2.sd[1].right,
           y0=min(d1.sd[1].bottom,d2.sd[1].bottom),
           y1=max(d1.sd[1].top,d2.sd[1].top), net=vss)
    c.via(c0, m1, at=(p1.sd[0].cx, p1.sd[0].cy), net=vdd, dir="h")
    c.via(c0, m1, at=(p2.sd[1].cx, p2.sd[1].cy), net=vdd, dir="h")
    c.via(c0, m1, at=(d1.sd[1].cx, d1.sd[1].cy), net=vss, dir="h")
    c.via(c0, m1, at=(d2.sd[1].cx, d2.sd[1].cy), net=vss, dir="h")

    # word line on m1 across the cell
    c.rect(m1, x0=x0-0.04, x1=x0+4*tp+0.04,
           y0=yn+0.30, y1=yn+0.30+0.11, net=wl)

    # bit-line contacts on m2 (via1 from c0 sd strap)
    c.via(m1, m2, at=(a.sd[0].cx, a.sd[0].cy+0.30), net=bl, dir="v")
    c.via(m1, m2, at=(b.sd[0].cx, b.sd[0].cy+0.30), net=blb, dir="v")

    # cell ports (on c0 straps / m1)
    c.port(vdd, on=p1.sd[0], dir="in")
    c.port(vss, on=d1.sd[1], dir="in")
    c.port(wl, on=a.gates[0], dir="in")
    c.port(bl, on=a.sd[0], dir="in")
    c.port(blb, on=b.sd[0], dir="in")

    bb = c.bbox
    return type("C", (), {"bbox":bb,"width":bb[2]-bb[0],"height":bb[3]-bb[1],
                          "left":bb[0],"right":bb[2],"bottom":bb[1],"top":bb[3]})()

# ---------------------------------------------------------------- top
top = Cell("sram16x8")
cols, rows = 8, 16
cp = sram6t(Cell("__tmp__"), "WL", "BL", "BLB", "VDD", "VSS", at=(0, 0))
pitch_x, pitch_y = 1.55, 1.49

insts = []
for r in range(rows):
    for cc in range(cols):
        insts.append(top.place(cp, at=(cc*pitch_x, r*pitch_y),
                               name=f"XB{r}_{cc}",
                               conns={"VDD":"VDD","VSS":"VSS",
                                      "BL":f"BL{cc}","BLB":f"BLB{cc}","WL":f"WL{r}"}))

# bit lines on m2 (vertical, one per column, true+bar side by side)
for cc in range(cols):
    bls  = [inst.pin("BL",  ix=cc, iy=r) for r in range(rows)]
    blbs = [inst.pin("BLB", ix=cc, iy=r) for r in range(rows)]
    y0 = min(p.bottom for p in bls+blbs) - 0.05
    y1 = max(p.top   for p in bls+blbs) + 0.05
    top.rect(m2, x0=bls[0].cx-0.06, x1=bls[0].cx+0.06, y0=y0, y1=y1, net=f"BL{cc}")
    top.rect(m2, x0=bls[0].cx+pitch_x/2-0.06, x1=bls[0].cx+pitch_x/2+0.06,
             y0=y0, y1=y1, net=f"BLB{cc}")

# word lines on m1 (horizontal, one per row)
for r in range(rows):
    wls = [inst.pin("WL", ix=c, iy=r) for c in range(cols)]
    x0 = min(p.left  for p in wls) - 0.05
    x1 = max(p.right for p in wls) + 0.05
    y  = wls[0].cy
    top.rect(m1, x0=x0, x1=x1, y0=y-0.055, y1=y+0.055, net=f"WL{r}")

# global supply rails on m2
vdds = [inst.pin("VDD", ix=c, iy=r) for r in range(rows) for c in range(cols)]
vsss = [inst.pin("VSS", ix=c, iy=r) for r in range(rows) for c in range(cols)]
x0 = min(p.left  for p in vdds+vsss) - 0.05
x1 = max(p.right for p in vdds+vsss) + 0.05
yv = min(p.bottom for p in vdds) - 0.05
ys = max(p.top   for p in vsss) + 0.05
top.rect(m2, x0=x0, x1=x1, y0=yv-0.055, y1=yv+0.055, net="VDD")
top.rect(m2, x0=x0, x1=x1, y0=ys-0.055, y1=ys+0.055, net="VSS")

# top-level pins
for name, y in (("VDD", yv), ("VSS", ys)):
    top.port(name, on=top.rect(m2, x0=x0, x1=x1, y0=y-0.055, y1=y+0.055, net=name))
for cc in range(cols):
    for suf, net in (("BL", f"BL{cc}"), ("BLB", f"BLB{cc}")):
        x = cc*pitch_x + (0 if suf=="BL" else pitch_x/2)
        top.port(net, on=top.rect(m2, x0=x-0.06, x1=x+0.06,
                                  y0=y0-0.2, y1=y1+0.2, net=net))
for r in range(rows):
    y = r*pitch_y + cp.height/2
    top.port(f"WL{r}", on=top.rect(m1, x0=x0-0.2, x1=x1+0.2,
                                   y0=y-0.055, y1=y+0.055, net=f"WL{r}"))

TOP = top
