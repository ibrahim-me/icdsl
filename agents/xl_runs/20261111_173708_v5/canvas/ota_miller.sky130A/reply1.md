```python
from icdsl.canvas import *

tech = use()                      # PDK from --pdk (sky130A / gf180mcuD / freepdk45)
TOP = from_spice("netlist.spice") # rows style: strips + substrate/n-well rings + routers + ports
```