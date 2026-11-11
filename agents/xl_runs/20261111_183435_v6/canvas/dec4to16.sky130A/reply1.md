```python
"""dec4to16 — 4-to-16 line decoder built straight from the task netlist.

One script for sky130A, gf180mcuD and freepdk45: each PDK run uses its own
netlist.spice (sky130A.spice / gf180mcuD.spice / freepdk45.spice) and its own
device recipes, so the extracted layout matches the netlist device-for-device
(W/L, connectivity, pin names) and the automatic row placement + router stay
inside the area budget.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="dec4to16")
```