```python
"""ota_miller - two-stage Miller OTA laid out from netlist.spice.

Uses the canvas netlist flow (works on sky130A, gf180mcuD and freepdk45):
each MOS-only subcircuit becomes a stick cell, the top subcircuit is placed
in rows and wired with the two-layer router, and every top pin becomes a port.
On freepdk45 the compensation network is MOS-only (M9 = triode resistor, MC =
gate capacitor), exactly as netlist.spice describes.
"""
from icdsl.canvas import *

tech = use()                       # PDK from --pdk / $ICL_PDK (default sky130A)
TOP = from_spice("netlist.spice")  # stick cells + rows + router; ports for INP INN OUT IB VDD VSS
TOP.name = "ota_miller"
```