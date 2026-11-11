```python
"""rca8 - 8-bit ripple-carry adder built straight from the transistor netlist.

PDK-generic: the same script builds on sky130A, gf180mcuD and freepdk45;
each run directory provides its own netlist.spice (the `fa` subcircuits become
stick cells, the top `rca8` is placed in rows and wired with the router).
"""
from icdsl.canvas import *

tech = use()                      # PDK from --pdk / $ICL_PDK
TOP = from_spice("netlist.spice") # top subcircuit rca8 -> stick cells + rows + router
```