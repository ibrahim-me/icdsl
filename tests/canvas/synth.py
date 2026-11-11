"""Netlist level: stick_auto (cells from transistor lists, with pass gates) and from_spice on a nested
netlist written in the PDK's own SPICE dialect. No coordinates anywhere in this file."""
from icdsl.canvas import *

tech = use()
N, P = "nmos", "pmos"
leaf = {
    "inv": ([(N, "Y", "A", "VSS"), (P, "Y", "A", "VDD")], "A Y"),
    "nor2": ([(N, "Y", "A", "VSS"), (N, "Y", "B", "VSS"), (P, "x", "A", "VDD"), (P, "Y", "B", "x")], "A B Y"),
    # inverting 2:1 multiplexer with two transmission gates: different n and p gate nets in one column
    "muxi": ([(N, "SB", "S", "VSS"), (P, "SB", "S", "VDD"), (N, "m", "SB", "A"), (P, "m", "S", "A"),
              (N, "m", "S", "B"), (P, "m", "SB", "B"), (N, "Y", "m", "VSS"), (P, "Y", "m", "VDD")], "A B S Y"),
}
text = ""
for name, (devs, ports) in leaf.items():
    probe = stick_auto("probe_" + name, devs, ports)                 # only to get the PDK's device lines
    assert probe.stick["n"] and probe.stick["p"]
    text += probe.subckt().replace("probe_" + name, name)
order = {name: probe_ports for name, probe_ports in
         ((n, text.split(".subckt " + n + " ")[1].split("\n")[0].split()) for n in leaf)}


def inst(iname, cell, **conns):
    return f"X{iname} " + " ".join(conns.get(p, p) for p in order[cell]) + f" {cell}\n"


# slice = mux + inverter (one level of hierarchy), top = 6 slices in a chain + a nor of the two ends
order["slice"] = "VSS VDD A B S Q".split()
text += ".subckt slice VSS VDD A B S Q\n" + inst("m", "muxi", Y="y") + inst("i", "inv", A="y", Y="Q") + ".ends\n"
text += ".subckt chain6 VSS VDD D0 D1 D2 D3 D4 D5 SEL IN OUT ANY\n"
for i in range(6):
    text += inst(f"s{i}", "slice", A=f"D{i}", B="IN" if i == 0 else f"q{i - 1}", S="SEL", Q="OUT" if i == 5 else f"q{i}")
text += inst("n", "nor2", A="q0", B="OUT", Y="ANY") + ".ends\n"

TOP = from_spice(text)
assert TOP.name == "chain6" and set(TOP.leaves) == set(leaf), (TOP.name, TOP.leaves)
assert {"D0", "SEL", "IN", "OUT", "ANY", "VDD", "VSS"} <= set(TOP.ports), sorted(TOP.ports)
assert TOP.count()[1] == 6 * 10 + 4
