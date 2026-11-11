```
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0 = tech.c0

# ---------------------------------------------------------------- standard cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y", ntracks=3)
nand4 = stick("nand4",
              n="VSS A n1 B n2 C n3 D Y",
              p="VDD A Y B VDD C Y D VDD",
              ports="A B C D Y", ntracks=6)

top = Cell("dec4to16")

# input inverters: A0..A3 -> AB0..AB3
inv_in = [top.place(inv, name=f"IA{k}", conns={"A": f"A{k}", "Y": f"AB{k}"}) for k in range(4)]

# 4x4 nand4 array; row r = MSB side, column c = LSB side, index k=r*4+c
nand_inst = [[None] * 4 for _ in range(4)]
for r in range(4):
    for c in range(4):
        k = r * 4 + c
        conns = {"Y": f"YB{k}"}
        for b in range(4):
            bit = (k >> (3 - b)) & 1
            conns[f"{'ABCD'[b]}"] = f"AB{b}" if bit else f"A{b}"
        nand_inst[r][c] = top.place(nand4, name=f"N{k}", conns=conns)

# output inverters: YBk -> Yk
inv_out = [top.place(inv, name=f"I{k}", conns={"A": f"YB{k}", "Y": f"Y{k}"}) for k in range(16)]

# ---------------------------------------------------------------- placement
# rows bottom to top: output inverters, four nand rows, input inverters
rows(top,
     [[(inv_out[k], f"I{k}", {}) for k in range(16)],
      [(nand_inst[3][c], f"N{12 + c}", {}) for c in range(4)],
      [(nand_inst[2][c], f"N{8 + c}", {}) for c in range(4)],
      [(nand_inst[1][c], f"N{4 + c}", {}) for c in range(4)],
      [(nand_inst[0][c], f"N{c}", {}) for c in range(4)],
      [(inv_in[k], f"IA{k}", {}) for k in range(4)]],
     dx=2.2, dy=1.6)

# ---------------------------------------------------------------- routing
R = Router(top)          # pins on c1, columns on c2, trunks on c3

# address lines A0..A3 / AB0..AB3 from input inverters to every nand gate input
gate_pins = {net: [] for b in range(4) for net in (f"A{b}", f"AB{b}")}
for r in range(4):
    for c in range(4):
        k = r * 4 + c
        inst = nand_inst[r][c]
        for b in range(4):
            bit = (k >> (3 - b)) & 1
            net = f"AB{b}" if bit else f"A{b}"
            gate_pins[net].append(inst.pin(f"{'ABCD'[b]}"))
for net, pins in gate_pins.items():
    R.add(net, *pins)

# output lines: nand Y -> output inverter A
for k in range(16):
    R.add(f"YB{k}", nand_inst[k // 4][k % 4].pin("Y"), inv_out[k].pin("A"))

# supplies
vdd_pins = [inv_in[k].pin("VDD") for k in range(4)]
vss_pins = [inv_in[k].pin("VSS") for k in range(4)]
for r in range(4):
    for c in range(4):
        vdd_pins.append(nand_inst[r][c].pin("VDD"))
        vss_pins.append(nand_inst[r][c].pin("VSS"))
for k in range(16):
    vdd_pins.append(inv_out[k].pin("VDD"))
    vss_pins.append(inv_out[k].pin("VSS"))
R.add("VDD", *vdd_pins)
R.add("VSS", *vss_pins)

R.run()

# ---------------------------------------------------------------- top ports
for k in range(4):
    top.port(f"A{k}", on=inv_in[k].pin(f"A{k}"), dir="in")
for k in range(16):
    top.port(f"Y{k}", on=inv_out[k].pin(f"Y{k}"), dir="out")
top.port("VDD", on=vdd_pins[0])
top.port("VSS", on=vss_pins[0])

TOP = top
```