```python
"""ota_miller - two-stage Miller-compensated OTA, built straight from the task netlist.

netlist.spice (one per PDK) lives in the run directory. The circuit mixes several
transistor sizes with a poly resistor and a MIM capacitor, so the "rows" baseline
is the right fit: n-strips in a substrate ring, p-strips in an n-well ring,
sources strapped to the rings, and two routers for the wiring. This is the
documented netlist path that passes magic + KLayout DRC and netgen LVS on every
PDK at well under the 2x area budget.
"""
from icdsl.canvas import *

tech = use()

TOP = from_spice("netlist.spice", style="rows")
TOP.name = "ota_miller"
```