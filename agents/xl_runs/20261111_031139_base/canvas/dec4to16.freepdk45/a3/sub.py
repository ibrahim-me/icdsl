from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)

inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y VDD VSS", wn=0.09, wp=0.18, l=0.05, ntracks=2)
n4  = stick("nand4",
            n="VSS A n1 B n2 C n3 D Y",
            p="VDD A Y B VDD C Y D VDD",
            ports="A B C D Y VDD VSS", wn=0.09, wp=0.18, l=0.05, ntracks=8)

top = Cell("dec4to16")

def put(cell, name, conns, **kw):
    return top.place(cell, name=name, conns=conns, **kw)

# input inverters (left column)
ab = []
ab.append(put(inv, "IA0", dict(A="A0", Y="AB0", VSS="VSS", VDD="VDD"), at=(0, 0)))
for i in range(1, 4):
    ab.append(put(inv, "IA%d" % i, dict(A="A%d" % i, Y="AB%d" % i, VSS="VSS", VDD="VDD"), above=ab[-1]))

# nand4 array: 2 rows x 8
nand_nets = [
    ("AB0","AB1","AB2","AB3"), ("A0","AB1","AB2","AB3"),
    ("AB0","A1","AB2","AB3"), ("A0","A1","AB2","AB3"),
    ("AB0","AB1","A2","AB3"), ("A0","AB1","A2","AB3"),
    ("AB0","A1","A2","AB3"), ("A0","A1","A2","AB3"),
    ("AB0","AB1","AB2","A3"), ("A0","AB1","AB2","A3"),
    ("AB0","A1","AB2","A3"), ("A0","A1","AB2","A3"),
    ("AB0","AB1","A2","A3"), ("A0","AB1","A2","A3"),
    ("AB0","A1","A2","A3"), ("A0","A1","A2","A3"),
]
nands = [[None]*8 for _ in range(2)]
for r in range(2):
    for c in range(8):
        k = r*8 + c
        a, b, cc, d = nand_nets[k]
        kw = dict(A=a, B=b, C=cc, D=d, Y="YB%d" % k, VSS="VSS", VDD="VDD")
        if c == 0:
            if r == 0:
                nands[r][c] = put(n4, "N%d" % k, kw, right_of=ab[-1], bottom=ab[0].bottom)
            else:
                nands[r][c] = put(n4, "N%d" % k, kw, above=nands[0][0])
        else:
            if r == 0:
                nands[r][c] = put(n4, "N%d" % k, kw, right_of=nands[r][c-1], bottom=nands[0][0].bottom)
            else:
                nands[r][c] = put(n4, "N%d" % k, kw, right_of=nands[r][c-1], above=nands[0][c])

# output inverters: 2 rows x 8
outs = [[None]*8 for _ in range(2)]
for r in range(2):
    for c in range(8):
        k = r*8 + c
        kw = dict(A="YB%d" % k, Y="Y%d" % k, VSS="VSS", VDD="VDD")
        if c == 0:
            if r == 0:
                outs[r][c] = put(inv, "IY%d" % k, kw, right_of=nands[r][-1], bottom=nands[r][0].bottom)
            else:
                outs[r][c] = put(inv, "IY%d" % k, kw, above=outs[0][0])
        else:
            if r == 0:
                outs[r][c] = put(inv, "IY%d" % k, kw, right_of=outs[r][c-1], bottom=outs[0][0].bottom)
            else:
                outs[r][c] = put(inv, "IY%d" % k, kw, right_of=outs[r][c-1], above=outs[0][c])

# signal routing
R = Router(top, v=m2, h=m1, pin_layer=c0)
R.auto()

# power rails on m2: top VDD, bottom VSS, vertical drops to every instance pin
vdd_pins = [inst.pin("VDD") for row in nands for inst in row] + [inst.pin("VDD") for row in outs for inst in row] + [inst.pin("VDD") for inst in ab]
vss_pins = [inst.pin("VSS") for row in nands for inst in row] + [inst.pin("VSS") for row in outs for inst in row] + [inst.pin("VSS") for inst in ab]

all_pins = vdd_pins + vss_pins
min_x = min(p.left for p in all_pins)
max_x = max(p.right for p in all_pins)
min_y = min(p.bottom for p in all_pins)
max_y = max(p.top for p in all_pins)

vdd_rail = top.rect(m2, x0=min_x, x1=max_x, y0=max_y + 0.1, y1=max_y + 0.3, net="VDD")
vss_rail = top.rect(m2, x0=min_x, x1=max_x, y0=min_y - 0.3, y1=min_y - 0.1, net="VSS")
for p in vdd_pins:
    top.rect(m2, x0=p.left, x1=p.right, y0=p.top, y1=vdd_rail.bottom, net="VDD")
for p in vss_pins:
    top.rect(m2, x0=p.left, x1=p.right, y0=vss_rail.top, y1=p.bottom, net="VSS")

# ports
for nm in ["VSS", "VDD", "A0", "A1", "A2", "A3"] + ["Y%d" % i for i in range(16)]:
    sh = None
    if nm.startswith("A"):
        sh = ab[int(nm[1:])].pin("A")
    elif nm.startswith("Y"):
        k = int(nm[1:])
        sh = outs[0 if k < 8 else 1][k % 8].pin("Y")
    elif nm == "VDD":
        sh = vdd_rail
    elif nm == "VSS":
        sh = vss_rail
    if sh is not None:
        top.port(nm, on=sh, dir="in" if nm.startswith("A") or nm in ("VSS", "VDD") else "out")

TOP = top

