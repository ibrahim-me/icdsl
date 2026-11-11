```python
from icdsl.canvas import *

tech = use()                      # PDK from --pdk / $ICL_PDK (target: gf180mcuD)
TOP = from_spice("netlist.spice") # dec4to16: inv/nand4 stick cells, placed in rows, router-wired
```