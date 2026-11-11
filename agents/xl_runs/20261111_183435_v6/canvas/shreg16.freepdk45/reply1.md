```python
"""shreg16 - 16-bit shift register: 16 chained dff cells built from the netlist.
Works on sky130A, gf180mcuD and freepdk45 (PDK chosen via --pdk / $ICL_PDK)."""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="shreg16")
```