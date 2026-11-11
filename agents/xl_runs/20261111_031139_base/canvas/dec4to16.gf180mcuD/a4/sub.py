from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()

# ---------------------------------------------------------------- standard cells
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y", ntracks=3)
nand4 = stick("nand4",
              n="VSS A n1 B n2 C n3 D Y",
              p="VDD A Y B VDD C Y D VDD",
              ports="A B C D Y", ntracks=6)

top = Cell("dec4to16")

def nand_conns(k):
    conns = {"Y": f"YB{k}"}
    for b in range(4):
        bit = (k >> (3 - b)) & 1
        conns[f"{'ABCD'[b]}"] = f"AB{b}" if bit else f"A{b}"
    return conns

# rows bottom to top: output inverters, four nand rows, input inverters
insts = rows(top,
    [[(inv, f"I{k}", dict(A=f"YB{k}", Y=f"Y{k}")) for k in range(16)],
     [(nand4, f"N{12 + c}", nand_conns(12 + c)) for c in range(4)],
     [(nand4, f"N{8 + c}", nand_conns(8 + c)) for c in range(4)],
     [(nand4, f"N{4 + c}", nand_conns(4 + c)) for c in range(4)],
     [(nand4, f"N{c}", nand_conns(c)) for c in range(4)],
     [(inv, f"IA{k}", dict(A=f"A{k}", Y=f"AB{k}")) for k in range(4)]])

inst_by_name = {ref.name: ref for row in insts for ref in row}

# ---------------------------------------------------------------- routing
R = Router(top)

# address lines A0..A3 / AB0..AB3 to every nand gate input
gate_pins = {net: [] for b in range(4) for net in (f"A{b}", f"AB{b}")}
for r in range(4):
    for c in range(4):
        k = r * 4 + c
        inst = inst_by_name[f"N{k}"]
        for b in range(4):
            bit = (k >> (3 - b)) & 1
            net = f"AB{b}" if bit else f"A{b}"
            gate_pins[net].append(inst.pin(f"{'ABCD'[b]}"))
for net, pins in gate_pins.items():
    R.add(net, *pins)

# output lines: nand Y -> output inverter A
for k in range(16):
    R.add(f"YB{k}", inst_by_name[f"N{k}"].pin("Y"), inst_by_name[f"I{k}"].pin("A"))

# supplies
vdd_pins = [inst_by_name[f"IA{k}"].pin("VDD") for k in range(4)]
vss_pins = [inst_by_name[f"IA{k}"].pin("VSS") for k in range(4)]
for r in range(4):
    for c in range(4):
        k = r * 4 + c
        vdd_pins.append(inst_by_name[f"N{k}"].pin("VDD"))
        vss_pins.append(inst_by_name[f"N{k}"].pin("VSS"))
for k in range(16):
    vdd_pins.append(inst_by_name[f"I{k}"].pin("VDD"))
    vss_pins.append(inst_by_name[f"I{k}"].pin("VSS"))
R.add("VDD", *vdd_pins)
R.add("VSS", *vss_pins)

R.run()

# ---------------------------------------------------------------- top ports
for k in range(4):
    top.port(f"A{k}", on=inst_by_name[f"IA{k}"].pin(f"A{k}"), dir="in")
for k in range(16):
    top.port(f"Y{k}", on=inst_by_name[f"I{k}"].pin(f"Y{k}"), dir="out")
top.port("VDD", on=vdd_pins[0])
top.port("VSS", on=vss_pins[0])

TOP = top

