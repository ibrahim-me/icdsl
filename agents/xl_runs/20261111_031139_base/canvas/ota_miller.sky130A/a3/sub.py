from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0; m1 = tech.metal(1); m2 = tech.metal(2)
have_res = "res_poly" in tech.d["devices"]
have_mim = "cap_mim" in tech.d["devices"]

c = Cell("ota_miller")
SP = 0.6

def c0join(net, *objs):
    xs = [o.left for o in objs]; ys = [o.bottom for o in objs]
    xe = [o.right for o in objs]; ye = [o.top for o in objs]
    return c.rect(c0, x0=min(xs), y0=min(ys), x1=max(xe), y1=max(ye), net=net)

def drop(net, c0sh, rail):
    # connect c0 shape to m2 rail via m1 vertical bar + vias
    x = c0sh.cx
    y0 = c0sh.top; y1 = rail.bottom if rail.top > c0sh.top else rail.top
    if abs(y1 - y0) < 0.2: return
    bar = c.rect(m1, x0=x-0.17, x1=x+0.17, y0=min(y0,y1), y1=max(y0,y1), net=net)
    c.via(c0, m1, at=(x, (c0sh.top+c0sh.bottom)/2), net=net)
    c.via(m1, m2, at=(x, (bar.top+bar.bottom)/2), net=net)

# ---------- devices (placement order: each references an already placed one) ----------
M5 = c.mos("nmos", w=2, l=1, nf=4, gates="IB", sd=("VSS","TAIL"), at=(0, 0))
M1 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INN", sd=("TAIL","D1"), at=(M5.diff.left, M5.diff.top + SP))
M2 = c.mos("nmos", w=4, l=0.5, nf=2, gates="INP", sd=("TAIL","D2"), at=(M1.diff.right + SP, M1.diff.bottom))
M8 = c.mos("nmos", w=2, l=1, nf=2, gates="IB", sd=("VSS","IB"), at=(M5.diff.right + SP, M5.diff.bottom))
M3 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD","D1"), at=(M1.diff.left, M1.diff.top + SP))
M4 = c.mos("pmos", w=4, l=1, nf=2, gates="D1", sd=("VDD","D2"), at=(M2.diff.left, M2.diff.top + SP))
M7 = c.mos("nmos", w=2, l=1, nf=8, gates="IB", sd=("VSS","OUT"), at=(M4.diff.right + SP, M5.diff.bottom))
M6 = c.mos("pmos", w=4, l=0.5, nf=8, gates="D2", sd=("VDD","OUT"), at=(M7.diff.left, M7.diff.top + SP))

if have_res:
    RZ = c.resistor("res_poly", w=1, l=8, at=(M6.diff.right + SP, M6.diff.top), orient="v")
else:
    RZ = c.mos("nmos", w=2, l=1, nf=1, gates="VDD", sd=("D2","X"), at=(M6.diff.right + SP, M6.diff.top))
if have_mim:
    CC = c.capacitor("cap_mim", w=20, h=20, at=(RZ.b.right + SP if have_res else RZ.sd[1].right + SP, M6.diff.top))
else:
    CC = c.mos("nmos", w=4, l=1, nf=1, gates="OUT", sd=("X","X"), at=(RZ.b.right + SP if have_res else RZ.sd[1].right + SP, M6.diff.top))

# ---------- c0 joins (device terminals of the same net) ----------
c0join("TAIL", M1.sd[0], M2.sd[0], M5.sd[1])
c0join("D1",   M1.sd[1], M3.sd[1], M3.gates[0], M4.gates[0])
c0join("D2",   M2.sd[1], M4.sd[1], M6.gates[0], RZ.sd[0] if not have_res else RZ.a)
c0join("OUT",  M6.sd[1], M7.sd[1], CC.sd[1] if not have_mim else CC.bottom_pad)
c0join("VDD",  M3.sd[0], M4.sd[0], M6.sd[0])
c0join("VSS",  M5.sd[0], M7.sd[0], M8.sd[0])
c0join("IB",   M5.gates[0], M7.gates[0], M8.gates[0], M8.sd[1])
c0join("X",    RZ.sd[1] if not have_res else RZ.b, CC.sd[0] if not have_mim else CC.top_pad)

# ---------- power rails on m2 ----------
vdd = c.rect(m2, x0=min(M3.well.left, M4.well.left, M6.well.left) - 0.3,
             x1=max(M3.well.right, M4.well.right, M6.well.right) + 0.3,
             y0=max(M3.top, M4.top, M6.top) + 0.3,
             y1=max(M3.top, M4.top, M6.top) + 1.0, net="VDD")
vss = c.rect(m2, x0=min(M1.diff.left, M2.diff.left, M5.diff.left, M7.diff.left, M8.diff.left) - 0.3,
             x1=max(M1.diff.right, M2.diff.right, M5.diff.right, M7.diff.right, M8.diff.right) + 0.3,
             y0=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom) - 1.0,
             y1=min(M1.bottom, M2.bottom, M5.bottom, M7.bottom, M8.bottom) - 0.3, net="VSS")

for s in (M3.sd[0], M4.sd[0], M6.sd[0]): drop("VDD", s, vdd)
for s in (M5.sd[0], M7.sd[0], M8.sd[0]): drop("VSS", s, vss)

# ---------- taps ----------
for mos in (M3, M4, M6):
    if mos.well:
        c.tap("ntap", x0=mos.well.left-0.1, y0=mos.well.bottom-0.1,
              x1=mos.well.right+0.1, y1=mos.well.top+0.1, net="VDD")
c.tap("ptap", x0=min(M1.diff.left,M2.diff.left,M5.diff.left,M7.diff.left,M8.diff.left)-0.1,
      y1=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-0.1,
      x1=max(M1.diff.right,M2.diff.right,M5.diff.right,M7.diff.right,M8.diff.right)+0.1,
      y0=min(M1.diff.bottom,M2.diff.bottom,M5.diff.bottom,M7.diff.bottom,M8.diff.bottom)-1.0, net="VSS")

# ---------- bring INN/INP/IB/OUT to m1 ports ----------
def gate_port(mos, net, name):
    g = mos.gates[0]
    p = c.rect(m1, x0=g.left-0.2, x1=g.right+0.2, y0=g.bottom-0.15, y1=g.top+0.15, net=net)
    c.via(c0, m1, at=(g.cx, (g.bottom+g.top)/2), net=net) if False else None
    # poly->m1 needs licon (poly->li) then mcon; simpler: place m1 over poly with a contact stack
    c.via("poly", c0, at=(g.cx, (g.bottom+g.top)/2), net=net)
    c.via(c0, m1, at=(g.cx, p.bottom - 0.15), net=net)
    c.rect(m1, x0=p.left, x1=p.right, y0=p.bottom-0.3, y1=p.bottom, net=net)
    c.port(name, on=p, dir="in")

gate_port(M1, "INN", "INN")
gate_port(M2, "INP", "INP")

# IB rail on m1
ib = c.rect(m1, x0=min(M5.gates[0].left, M7.gates[0].left, M8.gates[0].left) - 0.2,
            x1=max(M5.gates[0].right, M7.gates[0].right, M8.gates[0].right) + 0.2,
            y0=max(M5.gates[0].top, M7.gates[0].top, M8.gates[0].top) + 0.2,
            y1=max(M5.gates[0].top, M7.gates[0].top, M8.gates[0].top) + 0.8, net="IB")
for g in (M5.gates[0], M7.gates[0], M8.gates[0]):
    c.via("poly", c0, at=(g.cx, (g.bottom+g.top)/2), net="IB")
    c.via(c0, m1, at=(g.cx, ib.bottom - 0.15), net="IB")
c.rect(m1, x0=ib.left, x1=ib.right, y0=ib.bottom-0.3, y1=ib.bottom, net="IB")
c.port("IB", on=ib, dir="in")

# OUT port
outp = c.rect(m1, x0=M6.sd[1].left-0.2, x1=M6.sd[1].right+0.2,
              y0=M6.sd[1].top+0.2, y1=M6.sd[1].top+0.8, net="OUT")
c.via(c0, m1, at=(M6.sd[1].cx, (M6.sd[1].top+M6.sd[1].bottom)/2), net="OUT")
c.via(m1, m2, at=(outp.cx, (outp.top+outp.bottom)/2), net="OUT") if False else None
c.rect(m1, x0=outp.left, x1=outp.right, y0=outp.top, y1=outp.top+0.3, net="OUT")
c.port("OUT", on=outp, dir="out")

c.port("VDD", on=vdd)
c.port("VSS", on=vss)

TOP = c
