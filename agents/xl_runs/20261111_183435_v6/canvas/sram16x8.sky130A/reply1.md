```python
from icdsl.canvas import *

tech = use()                      # sky130A (or gf180mcuD / freepdk45 via --pdk)
# Lay out directly from the task netlist: builds a stick cell for sram6t,
# arrays the 128 instances in 16 rows x 8 columns (one row per word line),
# and routes WL (horizontal trunks) and BL/BLB (vertical columns).
TOP = from_spice("netlist.spice")   # top subcircuit is sram16x8; every top pin becomes a port
```