"""Netlist level, device rows: from_spice on a netlist that is not logic (several transistor sizes, a
subcircuit used three times, and - where the PDK has the recipes - a resistor and MIM capacitors that
share nets with the transistors). The netlist is written in the PDK's own SPICE dialect. No coordinates."""
from icdsl.canvas import *

tech = use()
HAS_R, HAS_C = "res_poly" in tech.devices, "cap_mim" in tech.devices


def lines(draw):
    """Device lines in the PDK's dialect: draw the devices in a scratch cell and read its netlist."""
    probe = Cell("probe")
    draw(probe)
    Cell.registry.pop("probe", None)
    return "\n".join(probe.subckt().splitlines()[1:-1]) + "\n"


# a transmission gate, n and p of different widths, two fingers each
text = ".subckt sw A B EN ENB VDD VSS\n" + lines(lambda c: (
    c.mos("nmos", w=2, l=0.5, nf=2, gates="EN", sd=("A", "B"), name="MN"),
    c.mos("pmos", w=4, l=0.5, nf=2, gates="ENB", sd=("A", "B"), name="MP", at=(0, 20)))) + ".ends\n"
text += ".subckt sdac IN TOP EN0 EN1 EN2 ENB0 ENB1 ENB2 RST VDD VSS" + ("" if HAS_C else " b0 b1 b2") + "\n"
for i in range(3):
    text += f"Xs{i} IN b{i} EN{i} ENB{i} VDD VSS sw\n"
text += lines(lambda c: c.mos("nmos", w=3, l=1, nf=1, gates="RST", sd=("VSS", "TOP"), name="MR"))
if HAS_R:
    text += lines(lambda c: c.resistor("res_poly", w=1, l=6, nets=("TOP", "VSS"), name="RL",
                                       **({"bulk": "VSS"} if "ppolyf" in tech.device("res_poly")["model"] else {})))
if HAS_C:
    def caps(c):
        for k, net in enumerate(["b0", "b1", "b2", "b2", "VSS"]):
            c.capacitor("cap_mim", w=6, h=6, at=(20 * k, 0), nets=("TOP", net), name=f"C{k}")
    text += lines(caps)
text += ".ends\n"

TOP = from_spice(text)
assert TOP.name == "sdac", TOP.name
assert {"IN", "TOP", "EN0", "ENB2", "RST", "VDD", "VSS"} <= set(TOP.ports), sorted(TOP.ports)
assert len(TOP.strips) == 7, TOP.strips                     # 3 x (n, p) switches + the reset transistor
assert len(TOP.devices) == 3 * 4 + 1 + HAS_R + 5 * HAS_C, len(TOP.devices)
try:
    from_spice(text, style="cells")
except CanvasError as e:
    assert 'style="rows"' in (e.hint or ""), e.hint
else:
    raise AssertionError('style="cells" accepted an analog netlist')
