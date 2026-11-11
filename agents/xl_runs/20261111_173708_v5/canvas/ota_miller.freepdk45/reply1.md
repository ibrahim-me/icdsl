```python
from icdsl.canvas import *

tech = use()                      # freepdk45 (target); also portable to sky130A / gf180mcuD
# The netlist file `netlist.spice` (== freepdk45.spice) lives in the run directory.
# It is MOS-only on freepdk45 (RZ -> M9 triode, CC -> MC gate capacitor), so it
# builds on every PDK that has nmos/pmos/ptap/ntap.
TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
```