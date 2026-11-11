```
from icdsl.canvas import *

tech = use()
assert tech.name == "gf180mcuD", "this script targets gf180mcuD"
TOP = from_spice("netlist.spice", style="rows")

```