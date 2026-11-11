from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0                      # first conductor (m1 on freepdk45)
m1 = tech.metal(1)
m2 = tech.metal(2)

# ------------------------------------------------------------------ standard cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y",
            wn=0.09, wp=0.18, l=0.05, ntracks=2)
n4  = stick("nand4",
            n="VSS A x B x C x D Y",
            p="VDD A Y B VDD C Y D VDD",
            ports="A B C D Y", wn=0.09, wp=0.18, l=0.05, ntracks=3)

# ------------------------------------------------------------------ top cell
top = Cell("dec4to16")

def put(cell, name, conns, **kw):
    return top.place(cell, name=name, conns=conns, **kw)

# input inverters, stacked: outputs AB0..AB3
ab = []
for i in range(4):
    ab.append(put(inv, "IA%d" % i, dict(A="A%d" % i, Y="AB%d" % i),
                  above=ab[-1] if ab else None))

# nand4 array: 2 rows x 8 (nets match freepdk45.spice)
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
nands = []
for r in range(2):
    row = []
    for c in range(8):
        k = r * 8 + c
        a, b, cc, d = nand_nets[k]
        row.append(put(n4, "N%d" % k,
                       dict(A=a, B=b, C=cc, D=d, Y="YB%d" % k),
                       right_of=row[-1] if row else None,
                       above=ab[0] if (c == 0 and r == 0) else None))
    nands.append(row)

# output inverters: 2 rows x 8, inputs YBk, outputs Yk
outs = []
for r in range(2):
    row = []
    for c in range(8):
        k = r * 8 + c
        row.append(put(inv, "IY%d" % k,
                       dict(A="YB%d" % k, Y="Y%d" % k),
                       right_of=row[-1] if row else None,
                       above=nands[r][c] if r == 0 else None))
    outs.append(row)

# ------------------------------------------------------------------ routing (c2 columns, c1 trunks, c0 pins)
R = Router(top, v=m2, h=m1, pin_layer=c0)
R.auto()

# ------------------------------------------------------------------ top ports
for nm in ["VSS", "VDD"]:
    top.port(nm)
for i in range(4):
    top.port("A%d" % i, on=ab[i].pin("A"), dir="in")
for k in range(16):
    top.port("Y%d" % k, on=outs[0 if k < 8 else 1][k % 8].pin("Y"), dir="out")

TOP = top
