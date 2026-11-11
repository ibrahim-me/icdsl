```python
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2 = tech.c0, tech.metal(1), tech.metal(2)

# ------------------------------------------------------------------ cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y",
            ntracks=3, wn=0.42, wp=0.84, l=0.15)
nand4 = stick("nand4",
              n="VSS A x B x C x D Y",
              p="VDD A Y - VDD B Y - VDD C Y - VDD D Y",
              ports="A B C D Y", ntracks=3, wn=0.42, wp=0.84, l=0.15)

# ------------------------------------------------------------------ top
top = Cell("dec4to16")
pitch = nand4.w

# row 0: input inverters A0..A3 -> AB0..AB3
row0 = []
for i in range(4):
    row0.append((inv, f"IA{i}", dict(A=f"A{i}", Y=f"AB{i}")))

# rows 1..4: four NAND4 + four output inverters each
rows = [row0]
for r in range(4):
    row = []
    for j in range(4):
        k = 4 * r + j
        a, b, c_, d = ((k >> s) & 1) for s in range(4))
        row.append((nand4, f"N{k}",
                    dict(A="A0" if a else "AB0",
                         B="A1" if b else "AB1",
                         C="A2" if c_ else "AB2",
                         D="A3" if d else "AB3",
                         Y=f"YB{k}")))
        row.append((inv, f"I{k}", dict(A=f"YB{k}", Y=f"Y{k}")))
    rows.append(row)

conns = {"VDD": "VDD", "VSS": "VSS"}
pl = rows(top, rows, name="dec4to16", conns=conns,
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
    top.port(f"A{i}", on=pl.pin(f"IA{i}", "A", iy=0))
for k in range(16):
    r, j = divmod(k, 4)
    top.port(f"Y{k}", on=pl.pin(f"I{k}", "A", ix=2 * j + 1, iy=r + 1))

top.port("Y0", on=pl.pin("I0", "A", ix=1, iy=1))   # ensure pin exists (harmless dup)

# ------------------------------------------------------------------ routing
rr = Router(top, v=c0, h=m2, pin_layer=m1)
nets = [f"AB{i}" for i in range(4)] + [f"YB{k}" for k in range(16)]
for net in nets:
    pins = []
    for k in range(16):
        r, j = divmod(k, 4)
        inst = f"N{k}"
        if net == f"YB{k}":
            pins.append(pl.pin(inst, "Y", ix=2 * j + 1, iy=r + 1))
            pins.append(pl.pin(f"I{k}", "A", ix=2 * j + 1, iy=r + 1))
        else:
            bit = (k >> int(net[2])) & 1
            name = "A" + net[2] if bit else "AB" + net[2]
            if net.startswith("AB"):
                pins.append(pl.pin(f"IA{int(net[2])}", "Y", iy=0))
            else:
                pins.append(pl.pin(f"IA{int(net[2])}", "A", iy=0))
            for jj in range(4):
                kk = 4 * r + jj
                if ((kk >> int(net[2])) & 1) == bit:
                    pins.append(pl.pin(f"N{kk}", "ABCD"[int(net[2])],
                                       ix=2 * jj + 1, iy=r + 1))
    rr.add(net, *pins)
rr.run()

TOP = top
```