```python
"""8-bit ripple-carry adder: layout the task netlist with the canvas netlist level."""
from icdsl.canvas import *

tech = use()                      # sky130A / gf180mcuD / freepdk45 from --pdk
TOP = from_spice("netlist.spice", top="rca8", style="cells")
```