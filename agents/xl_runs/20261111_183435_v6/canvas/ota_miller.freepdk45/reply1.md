```python
"""ota_miller - two-stage Miller-compensated OTA.

Layout is generated directly from the task netlist (netlist.spice, present in
the run directory) with the canvas netlist level. The same script builds on
sky130A, gf180mcuD and freepdk45; on freepdk45 the netlist already uses MOS
devices for the compensation network (M9 = triode resistor, MC = gate
capacitor), so no resistor/MIM recipe is required.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
```