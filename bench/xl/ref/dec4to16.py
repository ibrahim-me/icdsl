"""4-to-16 decoder with enable-free active-high outputs: 4 input inverters, 16 x (NAND4 + inverter); 168 transistors."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
NT = 5
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y", ntracks=NT)
nand4 = stick("nand4", n="VSS A x1 B x2 C x3 D Y", p="VDD A Y B VDD C Y D VDD", ports="A B C D Y", ntracks=NT)
top = Cell("dec4to16")
grid = []
for r in range(4):
    row = [(inv, f"IA{r}", dict(A=f"A{r}", Y=f"AB{r}"))]
    for k in range(4 * r, 4 * r + 4):
        sel = {p: (f"A{b}" if (k >> b) & 1 else f"AB{b}") for b, p in enumerate("ABCD")}
        row.append((nand4, f"N{k}", dict(sel, Y=f"YB{k}")))
        row.append((inv, f"I{k}", dict(A=f"YB{k}", Y=f"Y{k}")))
    grid.append(row)
rows(top, grid)
for net, shape in Router(top).auto().run().items():
    if not net.startswith(("AB", "YB")):
        top.port(net, on=shape)
TOP = top
