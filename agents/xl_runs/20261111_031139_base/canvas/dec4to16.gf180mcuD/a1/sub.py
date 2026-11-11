from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
c0, m1, m2, m3 = tech.c0, tech.metal(1), tech.metal(2), tech.metal(3)

# ---------------------------------------------------------------- standard cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y", ntracks=3)
# nand4: 4 nmos in series (pull-down), 4 pmos in parallel (pull-up).
# p-strip alternates VDD/Y diffusions so every gate is between VDD and Y.
nand4 = stick("nand4",
              n="VSS A n1 B n2 C n3 D Y",
              p="VDD A Y B VDD C Y D VDD",
              ports="A B C D Y", ntracks=3)

# ---------------------------------------------------------------- top cell
top = Cell("dec4to16")

# address inverters: A0..A3 -> AB0..AB3  (left side)
inv_in = []
for k in range(4):
    inst = top.place(inv, name=f"IA{k}", conns={"A": f"A{k}", "Y": f"AB{k}"})
    inv_in.append(inst)

# 4x4 array of nand4 gates. Row r (MSB A3..A0), column c (LSB).
# YB index = r*4 + c. Inputs: for bit b, AB[b] if bit set else A[b].
nand_inst = [[None] * 4 for _ in range(4)]
for r in range(4):
    for c in range(4):
        k = r * 4 + c
        conns = {"Y": f"YB{k}"}
        for b in range(4):
            bit = (k >> (3 - b)) & 1
            conns[f"{'ABCD'[b]}"] = f"AB{b}" if bit else f"A{b}"
        nand_inst[r][c] = top.place(nand4, name=f"N{k}", conns=conns)

# output inverters: YBk -> Yk (right side)
inv_out = []
for k in range(16):
    inst = top.place(inv, name=f"I{k}", conns={"A": f"YB{k}", "Y": f"Y{k}"})
    inv_out.append(inst)

# ---------------------------------------------------------------- placement
# rows bottom-to-top: output inverters, nand4 rows (mirrored alternately), input inverters
rows(top,
     [[(inv_out[k], f"I{k}", {}) for k in range(16)],
      [(nand_inst[3][c], f"N{12 + c}", {}) for c in range(4)],
      [(nand_inst[2][c], f"N{8 + c}", {}) for c in range(4)],
      [(nand_inst[1][c], f"N{4 + c}", {}) for c in range(4)],
      [(nand_inst[0][c], f"N{c}", {}) for c in range(4)],
      [(inv_in[k], f"IA{k}", {}) for k in range(4)]],
     dx=1.6, dy=1.2)

# ---------------------------------------------------------------- global routing
R = Router(top, v=m2, h=m2, pin_layer=m1)

# address lines: A0..A3 and AB0..AB3 run vertically (m2) to every nand4 gate
for b in range(4):
    for net in (f"A{b}", f"AB{b}"):
        pins = [top.place(inv, name=f"IA{b}", conns={}).pin(f"{'AB' if net.startswith('AB') else 'A'}{b}") if False else None][0]
# simpler: collect gate pins of all nand4 instances
gate_pins = {net: [] for b in range(4) for net in (f"A{b}", f"AB{b}")}
for r in range(4):
    for c in range(4):
        inst = nand_inst[r][c]
        for b in range(4):
            bit = (r * 4 + c >> (3 - b)) & 1
            net = f"AB{b}" if bit else f"A{b}"
            gate_pins[net].append(inst.pin(f"{'ABCD'[b]}"))

for net, pins in gate_pins.items():
    R.add(net, *pins)

# output lines: YBk -> output inverter input A
for k in range(16):
    np_ = nand_inst[k // 4][k % 4]
    ip_ = inv_out[k]
    R.add(f"YB{k}", np_.pin("Y"), ip_.pin("A"))

# supplies
vdd_pins = [inv_in[k].pin("VDD") for k in range(4)] + \
           [nand_inst[r][c].pin("VDD") for r in range(4) for c in range(4)] + \
           [inv_out[k].pin("VDD") for k in range(16)]
vss_pins = [inv_in[k].pin("VSS") for k in range(4)] + \
           [nand_inst[r][c].pin("VSS") for r in range(4) for c in range(4)] + \
           [inv_out[k].pin("VSS") for k in range(16)]
R.add("VDD", *vdd_pins)
R.add("VSS", *vss_pins)

R.run()

# ---------------------------------------------------------------- top ports
for k in range(4):
    top.port(f"A{k}", on=inv_in[k].pin(f"A{k}"), dir="in")
    top.port(f"AB{k}", on=inv_in[k].pin(f"AB{k}"), dir="in")
for k in range(16):
    top.port(f"Y{k}", on=inv_out[k].pin(f"Y{k}"), dir="out")
top.port("VDD", on=R.add if False else top.place(inv, name="X", conns={}).pin("VDD") if False else None)

TOP = top
