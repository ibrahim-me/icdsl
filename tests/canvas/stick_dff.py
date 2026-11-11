"""Static CMOS D flip-flop (22 T, clocked inverters with split gates) + mirror full adder (28 T) + 6T SRAM cell."""
from icdsl.canvas import *

tech = use()
NT = 10
dff = stick("dff",
            n="CKB CK VSS D n1 CKB m CK n2 mb VSS m mb - VSS Q n3 CKB s CK n4 mb VSS s Q",
            p="CKB CK VDD D p1 CK  m CKB p2 mb VDD m mb - VDD Q p3 CK  s CKB p4 mb VDD s Q",
            ports="D CK Q", ntracks=NT)
fa = stick("fa",
           n="n1 A VSS B n1 CIN CB B n2 A VSS A n3 B VSS CIN n3 CB SB CIN n5 B n4 A VSS CB COUT - SUM SB VSS",
           p="p1 A VDD B p1 CIN CB B p2 A VDD A p3 B VDD CIN p3 CB SB CIN p5 B p4 A VDD CB COUT - SUM SB VDD",
           ports="A B CIN SUM COUT", ntracks=NT)
bit = stick("sram6t", n="BL WL Q QB VSS Q QB WL BLB", p="- - Q QB VDD Q QB - -", ports="BL BLB WL", ntracks=NT)
top = Cell("stick_dff")
insts = rows(top, [[(cell, f"U{i}", {p: f"u{i}_{p}" for p in cell.port_order if p not in ("VDD", "VSS")})]
                   for i, cell in enumerate((dff, fa, bit))])
for r in insts.values():
    for p in r.cell.port_order:
        if p not in ("VDD", "VSS"):
            top.port(r.net_of(p), on=r.pin(p))
TOP = top
