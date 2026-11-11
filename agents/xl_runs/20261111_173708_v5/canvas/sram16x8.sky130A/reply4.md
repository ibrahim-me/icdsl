```python
from icdsl.canvas import *

tech = use()
c0, c1, c2, c3 = tech.c0, tech.c1, tech.c2, tech.c3

# ===== Build sram6t cell (6T SRAM bit cell) =====
sram6t = stick_auto("sram6t", [
    ("nmos", "Q",   "WL", "BL"),   # access: Q-BL
    ("nmos", "VSS", "QB", "Q"),    # pulldown Q
    ("nmos", "QB",  "Q",  "VSS"),  # pulldown QB
    ("nmos", "BLB", "WL", "QB"),   # access: QB-BLB
    ("pmos", "Q",   "QB", "VDD"),  # pullup Q
    ("pmos", "VDD", "Q",  "QB"),   # pullup QB
], ports="VSS VDD BL BLB WL")

cw = sram6t.bbox.w
ch = sram6t.bbox.h

# ===== Top cell: 16 rows x 8 columns =====
top = Cell("sram16x8")
insts = {}
for row in range(16):
    for col in range(8):
        name = f"XB{row}_{col}"
        insts[name] = top.place(sram6t, at=(col * cw, row * ch), name=name,
                                conns={"VSS": "VSS", "VDD": "VDD",
                                       "BL": f"BL{col}", "BLB": f"BLB{col}",
                                       "WL": f"WL{row}"})

# ===== Word lines: horizontal on c2, one per row =====
for row in range(16):
    net = f"WL{row}"
    y = row * ch + ch * 0.5
    top.wire(c2, [(0, y), (8 * cw, y)], width=max(tech.width(c2), 0.6), net=net, first="h")
    for col in range(8):
        pin = insts[f"XB{row}_{col}"].pin("WL")
        top.via(c1, c2, at=(pin.cx, y), net=net)

# ===== Bit lines: vertical on c3, one per column =====
for col in range(8):
    x = col * cw + cw * 0.5
    for suffix in ("BL", "BLB"):
        net = f"{suffix}{col}"
        top.wire(c3, [(x, 0), (x, 16 * ch)], width=max(tech.width(c3), 0.6), net=net, first="v")
        for row in range(16):
            pin = insts[f"XB{row}_{col}"].pin(suffix)
            top.via(c1, c3, at=(x, pin.cy), net=net)

# ===== VDD / VSS rails: horizontal on c2, one pair per row =====
for row in range(16):
    y = row * ch + ch * 0.5
    top.wire(c2, [(0, y + ch * 0.25), (8 * cw, y + ch * 0.25)],
             width=max(tech.width(c2), 0.6), net="VDD", first="h")
    top.wire(c2, [(0, y - ch * 0.25), (8 * cw, y - ch * 0.25)],
             width=max(tech.width(c2), 0.6), net="VSS", first="h")
    for col in range(8):
        inst = insts[f"XB{row}_{col}"]
        top.via(c1, c2, at=(inst.pin("VDD").cx, y + ch * 0.25), net="VDD")
        top.via(c1, c2, at=(inst.pin("VSS").cx, y - ch * 0.25), net="VSS")

# ===== Top-level ports =====
for row in range(16):
    top.port(f"WL{row}", on=top.wire(c2, [(0, row * ch + ch * 0.5), (8 * cw, row * ch + ch * 0.5)],
                                     width=max(tech.width(c2), 0.6), net=f"WL{row}", first="h"))
for col in range(8):
    x = col * cw + cw * 0.5
    top.port(f"BL{col}", on=top.wire(c3, [(x, 0), (x, 16 * ch)],
                                     width=max(tech.width(c3), 0.6), net=f"BL{col}", first="v"))
    top.port(f"BLB{col}", on=top.wire(c3, [(x + cw * 0.25, 0), (x + cw * 0.25, 16 * ch)],
                                      width=max(tech.width(c3), 0.6), net=f"BLB{col}", first="v"))
top.port("VDD", on=top.rect(c2, x0=0, x1=8 * cw, y0=16 * ch + 0.5, y1=16 * ch + 1.0, net="VDD"))
top.port("VSS", on=top.rect(c2, x0=0, x1=8 * cw, y0=-1.0, y1=-0.5, net="VSS"))

TOP = top
```