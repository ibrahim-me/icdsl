```python
from icdsl.canvas import *

tech = use()                      # PDK from --pdk (gf180mcuD here; same script on sky130A / freepdk45)
TOP = from_spice("netlist.spice", style="cells")
```