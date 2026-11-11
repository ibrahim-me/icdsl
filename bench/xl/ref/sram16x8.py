"""16-word x 8-bit array of 6T SRAM cells (768 transistors): word lines along the rows, bit-line pairs
down the columns. Cell array only - no decoder, no sense amplifiers."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
bit = stick("sram6t", n="BL WL Q QB VSS Q QB WL BLB", p="- - Q QB VDD Q QB - -", ports="BL BLB WL")
top = Cell("sram16x8")
rows(top, [[(bit, f"B{r}_{c}", dict(BL=f"BL{c}", BLB=f"BLB{c}", WL=f"WL{r}")) for c in range(8)] for r in range(16)])
for net, shape in Router(top).auto().run().items():
    top.port(net, on=shape)
TOP = top
