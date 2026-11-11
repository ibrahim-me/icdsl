```
from icdsl.canvas import *

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)

# ------------------------------------------------------------------
# 6T SRAM cell: cross-coupled inverters + two access transistors
# ------------------------------------------------------------------
def make_sram6t():
    c = Cell("sram6t")
    # n-strip: 4 nmos (2 access + 2 pulldown), single merged chain.
    #   col1: access BL-Q   (gate WL)
    #   col2: pulldown Q-VSS(gate QB)   shares Q diffusion with col1
    #   col3: pulldown VSS-QB(gate Q)   shares VSS with col2
    #   col4: access QB-BLB (gate WL)   shares QB with col3
    n = "BL WL Q QB VSS Q QB WL BLB"          # 9 entries: sd gate sd gate ... sd
    # p-strip: 2 pmos pullups, same 9-entry length.
    #   col1: pu_Q   (gate QB, sd Q/VDD)
    #   col4: pu_QB  (gate Q,  sd VDD/QB)
    p = "Q QB VDD - - - VDD Q QB"             # 9 entries, '-' = no device/diffusion
    sc = stick("sram6t_stick",
        n=n, p=p,
        ports="VSS VDD BL BLB WL",
        ntracks=4,
        wn=0.42, wp=0.84, l=0.15)
    c.place(sc, at=(0, 0), name="core")
    for net in ("VSS", "VDD", "BL", "BLB", "WL"):
        c.port(net, on=sc.pin(net), dir="inout")
    return c

sram6t = make_sram6t()
sram6t_w = sram6t.stick["W"]
sram6t_h = sram6t.stick["H"]

# ------------------------------------------------------------------
# Top: 16 rows (WL) x 8 columns (BL/BLB)
# ------------------------------------------------------------------
top = Cell("sram16x8")

cols = 8
rows = 16
pitch_x = sram6t_w + 0.6
pitch_y = sram6t_h + 0.2

insts = {}
for r in range(rows):
    for ccol in range(cols):
        name = f"XB{r}_{ccol}"
        insts[name] = top.place(sram6t,
            at=(ccol * pitch_x, r * pitch_y),
            name=name,
            conns={"VSS": "VSS", "VDD": "VDD",
                   "BL": f"BL{ccol}", "BLB": f"BLB{ccol}",
                   "WL": f"WL{r}"})

# ------------------------------------------------------------------
# Global routing: WL horizontal (m2), BL/BLB vertical (m1), rails (m1)
# ------------------------------------------------------------------
rtr = Router(top, v=m2, h=m1, pin_layer=m1)

for r in range(rows):
    rtr.add(f"WL{r}", insts[f"XB{r}_0"].pin("WL"))

for ccol in range(cols):
    rtr.add(f"BL{ccol}",  insts[f"XB0_{ccol}"].pin("BL"))
    rtr.add(f"BLB{ccol}", insts[f"XB0_{ccol}"].pin("BLB"))

rtr.add("VDD", insts["XB0_0"].pin("VDD"))
rtr.add("VSS", insts["XB0_0"].pin("VSS"))

routed = rtr.run()

for net in ("VSS", "VDD"):
    top.port(net, on=routed[net])
for ccol in range(cols):
    top.port(f"BL{ccol}",  on=routed[f"BL{ccol}"])
    top.port(f"BLB{ccol}", on=routed[f"BLB{ccol}"])
for r in range(rows):
    top.port(f"WL{r}", on=routed[f"WL{r}"])

TOP = top
```