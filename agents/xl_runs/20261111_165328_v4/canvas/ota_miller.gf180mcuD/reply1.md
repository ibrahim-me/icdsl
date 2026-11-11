```python
"""ota_miller - two-stage Miller-compensated OTA, built from the netlist.

The same script runs on sky130A, gf180mcuD and freepdk45; each PDK is built
with its own netlist.spice (freepdk45 realises RZ as M9 and CC as MC).
"""
from icdsl.canvas import *

tech = use()                      # PDK selected by --pdk / $ICL_PDK

# Netlist level: flatten, merge equal fingers into multi-finger strips, put
# NMOS strips in a substrate (ptap/VSS) ring and PMOS strips in an n-well
# (ntap/VDD) ring, add the poly resistor RZ and MIM capacitor CC, route the
# signals with the two-layer router and declare INP INN OUT IB VDD VSS.
TOP = from_spice("netlist.spice", top="ota_miller")
```