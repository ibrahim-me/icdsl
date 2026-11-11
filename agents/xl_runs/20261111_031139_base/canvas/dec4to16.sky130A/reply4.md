```
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ------------------------------------------------------------------ cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y",
            ntracks=3, wn=0.42, wp=0.84, l=0.15)
nand4 = stick("nand4",
              n="VSS A n1 B n2 C n3 D Y - - - - - -",
              p="VDD A Y - VDD B Y - VDD C Y - VDD D Y",
              ports="A B C D Y", ntracks=3, wn=0.42, wp=0.84, l=0.15)

# ------------------------------------------------------------------ top
top = Cell("dec4to16")

# Row 0: input inverters IA0..IA3 -> AB0..AB3
row0 = [(inv, f"IA{i}", dict(A=f"A{i}", Y=f"AB{i}")) for i in range(4)]

# Rows 1-4: four NAND4 + four output inverters each
rows = [row0]
for r in range(4):
    row = []
    for j in range(4):
        k = 4 * r + j
        conns = {}
        for i in range(4):
            conns["ABCD"[i]] = f"A{i}" if (k >> i) & 1 else f"AB{i}"
        conns["Y"] = f"YB{k}"
        row.append((nand4, f"N{k}", conns))
        row.append((inv, f"I{k}", dict(A=f"YB{k}", Y=f"Y{k}")))
    rows.append(row)

pl = rows(top, rows, name="dec4to16", conns={"VDD": "VDD", "VSS": "VSS"},
          v=c0, h=m2, pin_layer=m1)

# ------------------------------------------------------------------ ports
for net in ("VDD", "VSS"):
    shapes = [s for s in top.shapes if s.net == net and s.layer == c0]
    if shapes:
        b = shapes[0].bbox
        for s in shapes[1:]:
            b = (min(b[0], s.left), min(b[1], s.bottom),
                 max(b[2], s.right), max(b[3], s.top))
        top.port(net, on=c.rect(c0, bbox=b, net=net))

for i in range(4):
    top.port(f"A{i}", on=pl.pin(f"IA{i}", "A"))

for k in range(16):
    top.port(f"Y{k}", on=pl.pin(f"I{k}", "A"))

# ------------------------------------------------------------------ routing
rr = Router(top, v=c0, h=m2, pin_layer=m1)

# ABi: inverter output -> NAND inputs where bit i of k is 0
for i in range(4):
    pins = [pl.pin(f"IA{i}", "Y")]
    for k in range(16):
        if not ((k >> i) & 1):
            pins.append(pl.pin(f"N{k}", "ABCD"[i]))
    rr.add(f"AB{i}", *pins)

# YBk: NAND output -> inverter input
for k in range(16):
    rr.add(f"YB{k}", pl.pin(f"N{k}", "Y"), pl.pin(f"I{k}", "A"))

rr.run()

TOP = top


```