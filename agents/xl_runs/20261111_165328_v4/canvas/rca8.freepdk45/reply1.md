```python
from icdsl.canvas import *

tech = use()                       # PDK from --pdk (freepdk45 here, or sky130A / gf180mcuD)
TOP = from_spice("netlist.spice", top="rca8", style="cells")
TOP.name = "rca8"
```