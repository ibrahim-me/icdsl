```python
from icdsl.canvas import *

tech = use()

# Lay out the two-stage Miller OTA directly from its netlist (rows style:
# handles the several transistor sizes, the poly nulling resistor RZ and the
# MIM Miller capacitor CC). Every top pin (INP INN OUT IB VDD VSS) becomes a
# port; NMOS bodies tie to VSS, PMOS n-wells to VDD via the substrate rings.
TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
```