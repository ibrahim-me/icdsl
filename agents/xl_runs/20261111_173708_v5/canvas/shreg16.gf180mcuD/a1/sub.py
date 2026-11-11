"""shreg16 - 16-bit shift register: sixteen chained dff cells, built straight from the netlist.

One script for sky130A, gf180mcuD and freepdk45: each PDK run directory provides its own
netlist.spice (the PDK's shreg16 netlist).  The top subcircuit becomes the cell named
`shreg16` and its pins become the top ports (VSS VDD D Q11 Q15 Q3 Q7 Q0 Q1 Q10 Q12 Q13 Q14
Q2 Q4 Q5 Q6 Q8 Q9 CK)."""
from icdsl.canvas import *

tech = use()                                   # PDK from --pdk / $ICL_PDK
TOP = from_spice("netlist.spice")              # top subcircuit shreg16 -> cell "shreg16"
