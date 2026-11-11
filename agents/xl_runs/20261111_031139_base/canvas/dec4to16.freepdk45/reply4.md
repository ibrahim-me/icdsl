```
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0

# Same height for all cells so rows() can stack them with shared rails
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y VDD VSS", wn=0.09, wp=0.18, l=0.05, ntracks=8)
n4  = stick("nand4",
            n="VSS A n1 B n2 C n3 D Y",
            p="VDD A Y B VDD C Y D VDD",
            ports="A B C D Y VDD VSS", wn=0.09, wp=0.18, l=0.05, ntracks=8)

top = Cell("dec4to16")

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

# Rows bottom to top; every other row is mirrored; shared VDD/VSS rails within a row
row0 = [(inv, "IA%d" % i, dict(A="A%d" % i, Y="AB%d" % i, VSS="VSS", VDD="VDD")) for i in range(4)]
row1 = [(n4, "N%d" % k, dict(A=a, B=b, C=c, D=d, Y="YB%d" % k, VSS="VSS", VDD="VDD"))
        for k, (a, b, c, d) in enumerate(nand_nets[:8])]
row2 = [(n4, "N%d" % k, dict(A=a, B=b, C=c, D=d, Y="YB%d" % k, VSS="VSS", VDD="VDD"))
        for k, (a, b, c, d) in enumerate(nand_nets[8:], start=8)]
row3 = [(inv, "IY%d" % k, dict(A="YB%d" % k, Y="Y%d" % k, VSS="VSS", VDD="VDD")) for k in range(8)]
row4 = [(inv, "IY%d" % k, dict(A="YB%d" % k, Y="Y%d" % k, VSS="VSS", VDD="VDD")) for k in range(8, 16)]

insts = rows(top, [row0, row1, row2, row3, row4])

by_name = {inst.name: inst for row in insts for inst in row}

# Route all internal signals (AB*, YB*) with the two-layer trunk router
R = Router(top)
R.auto()

# Top-level ports
for i in range(4):
    top.port("A%d" % i, on=by_name["IA%d" % i].pin("A"), dir="in")
for k in range(16):
    top.port("Y%d" % k, on=by_name["IY%d" % k].pin("Y"), dir="out")

# Power: shared rails from rows() are continuous; bring them to the top level
top.port("VDD", on=by_name["IA0"].pin("VDD"), dir="in")
top.port("VSS", on=by_name["IA0"].pin("VSS"), dir="in")

TOP = top

```