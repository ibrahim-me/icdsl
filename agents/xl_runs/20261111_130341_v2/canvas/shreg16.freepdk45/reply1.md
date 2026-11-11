```python
# shreg16: lay out the transistor netlist directly; works on sky130A, gf180mcuD and freepdk45.
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", nrows=1)
```