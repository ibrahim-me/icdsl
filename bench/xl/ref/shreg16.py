"""16-bit serial-in parallel-out shift register: sixteen static master-slave D flip-flops
(clocked inverters, local clock inverter; 22 transistors each, 352 in total), four rows of four."""
from icdsl.canvas import *
from icdsl.canvas.route import Router

tech = use()
dff = stick("dff",
            n="CKB CK VSS D n1 CKB m CK n2 mb VSS m mb - VSS Q n3 CKB s CK n4 mb VSS s Q",
            p="CKB CK VDD D p1 CK  m CKB p2 mb VDD m mb - VDD Q p3 CK  s CKB p4 mb VDD s Q",
            ports="D CK Q")
top = Cell("shreg16")
grid = []
for r in range(4):
    order = range(4 * r, 4 * r + 4) if r % 2 == 0 else range(4 * r + 3, 4 * r - 1, -1)     # serpentine
    grid.append([(dff, f"FF{i}", dict(D="D" if i == 0 else f"Q{i - 1}", CK="CK", Q=f"Q{i}")) for i in order])
rows(top, grid)
for net, shape in Router(top).auto().run().items():
    top.port(net, on=shape)
TOP = top
