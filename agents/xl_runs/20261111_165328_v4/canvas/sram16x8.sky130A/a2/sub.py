from icdsl.canvas import *

tech = use()
c0 = tech.c0
m1 = tech.metal(1)
m2 = tech.metal(2)
top_metal = tech.stack[-1]

# ------------------------------------------------------------------
# 6T SRAM cell: cross-coupled inverters + two access transistors
# ------------------------------------------------------------------
def make_sram6t():
    c = Cell("sram6t")
    # n-strip: 4 nmos (2 pulldown + 2 access), p-strip: 2 pmos pullups
    # Columns aligned so QB-gate and Q-gate line up across n/p strips.
    sc = stick("sram6t_stick",
        n="VSS QB Q WL BL - VSS Q QB WL BLB",
        p="VDD QB Q - - QB Q VDD - -",
        ports="VSS VDD BL BLB WL",
        ntracks=4,
        wn=0.42, wp=0.84, l=0.15)
    c.place(sc, at=(0, 0), name="core")
    # promote cell ports
    for net in ("VSS", "VDD", "BL", "BLB", "WL"):
        p = sc.pin(net)
        c.port(net, on=p, dir="inout")
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
pitch_x = sram6t_w + 0.6   # column pitch (bit lines run in the gap)
pitch_y = sram6t_h + 0.2   # row pitch

insts = {}
for r in range(rows):
    for ccol in range(cols):
        name = f"XB{r}_{ccol}"
        conns = {
            "VSS": "VSS",
            "VDD": "VDD",
            "BL": f"BL{ccol}",
            "BLB": f"BLB{ccol}",
            "WL": f"WL{r}",
        }
        insts[name] = top.place(sram6t,
            at=(ccol * pitch_x, r * pitch_y),
            name=name,
            conns=conns)

# ------------------------------------------------------------------
# Global routing: WL horizontal (m2), BL/BLB vertical (m1), rails (m1)
# ------------------------------------------------------------------
rtr = Router(top, v=m2, h=m1, pin_layer=m1)

# Word lines: one m2 trunk per row, spanning all columns
for r in range(rows):
    wl_pin = insts[f"XB{r}_0"].pin("WL")
    rtr.add(f"WL{r}", wl_pin)

# Bit lines: one m1 trunk per column, spanning all rows
for ccol in range(cols):
    bl_pin = insts[f"XB0_{ccol}"].pin("BL")
    blb_pin = insts[f"XB0_{ccol}"].pin("BLB")
    rtr.add(f"BL{ccol}", bl_pin)
    rtr.add(f"BLB{ccol}", blb_pin)

# Supplies: VDD/VSS rails on m1, spanning the array width
vdd_pin = insts["XB0_0"].pin("VDD")
vss_pin = insts["XB0_0"].pin("VSS")
rtr.add("VDD", vdd_pin)
rtr.add("VSS", vss_pin)

routed = rtr.run()

# ------------------------------------------------------------------
# Top-level ports
# ------------------------------------------------------------------
for net in ("VSS", "VDD"):
    top.port(net, on=routed[net])
for ccol in range(cols):
    top.port(f"BL{ccol}", on=routed[f"BL{ccol}"])
    top.port(f"BLB{ccol}", on=routed[f"BLB{ccol}"])
for r in range(rows):
    top.port(f"WL{r}", on=routed[f"WL{r}"])

TOP = top
