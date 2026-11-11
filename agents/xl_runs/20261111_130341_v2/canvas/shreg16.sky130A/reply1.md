```python
"""shreg16 - 16-bit shift register laid out directly from the transistor netlist.

The netlist flow builds each MOS-only subcircuit (dff) as a stick cell, places
the top (shreg16) in rows and two-layer trunks it with the Router. One script
for sky130A, gf180mcuD and freepdk45; it reads netlist.spice from the run dir.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="shreg16")
```