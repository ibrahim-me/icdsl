```python
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
```