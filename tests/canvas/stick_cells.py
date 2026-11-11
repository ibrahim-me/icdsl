"""Stick cells on any PDK: inverter, NAND2, NOR2, clocked inverter (split gates), all in one row."""
from icdsl.canvas import *
from icdsl.canvas.stick import stick, rows

tech = use()
K = dict(ntracks=5)
inv = stick("inv", n="VSS A Y", p="VDD A Y", ports="A Y", **K)
nand2 = stick("nand2", n="VSS A x B Y", p="VDD A Y B VDD", ports="A B Y", **K)
nor2 = stick("nor2", n="VSS A Y B VSS", p="VDD A x B Y", ports="A B Y", **K)
cinv = stick("cinv", n="VSS D x CK Y", p="VDD D z CKB Y", ports="D CK CKB Y", **K)

top = Cell("stick_cells")
rows(top, [[(inv, "I0", dict(A="a0", Y="y0")), (nand2, "I1", dict(A="a1", B="b1", Y="y1"))],
           [(nor2, "I2", dict(A="a2", B="b2", Y="y2")), (cinv, "I3", dict(D="d3", CK="ck", CKB="ckb", Y="y3"))]])
for inst in top.refs:
    for port in inst.cell.port_order:
        if port not in ("VDD", "VSS"):
            top.port(inst.net_of(port), on=inst.pin(port))
TOP = top
