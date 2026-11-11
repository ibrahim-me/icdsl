```python
"""ota_miller two-stage Miller OTA: layout generated directly from the SPICE netlist.

Reads netlist.spice from the run directory (PDK-specific).  Uses the rows style
because the netlist contains several transistor sizes; on freepdk45 the
compensation network is already transistors (M9 = RZ, MC = CC), so the layout
is MOS devices only.  Builds on sky130A, gf180mcuD and freepdk45.
"""
from icdsl.canvas import *

tech = use()

TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
```