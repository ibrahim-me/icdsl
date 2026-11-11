"""8-bit ripple-carry adder: eight 28-transistor mirror full adders in two rows (224 transistors)."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
fa = stick("fa",
           n="n1 A VSS B n1 CIN CB B n2 A VSS A n3 B VSS CIN n3 CB SB CIN n5 B n4 A VSS CB COUT - SUM SB VSS",
           p="p1 A VDD B p1 CIN CB B p2 A VDD A p3 B VDD CIN p3 CB SB CIN p5 B p4 A VDD CB COUT - SUM SB VDD",
           ports="A B CIN SUM COUT")


def conns(i):
    return dict(A=f"A{i}", B=f"B{i}", CIN="CIN" if i == 0 else f"k{i}", SUM=f"S{i}",
                COUT="COUT" if i == 7 else f"k{i + 1}")


top = Cell("rca8")
rows(top, [[(fa, f"FA{i}", conns(i)) for i in (0, 1, 2, 3)],
           [(fa, f"FA{i}", conns(i)) for i in (7, 6, 5, 4)]])
for net, shape in Router(top).auto().run().items():
    if not net.startswith("k"):
        top.port(net, on=shape)
TOP = top
