```python
"""cdac6 - 6-bit binary-weighted capacitor array.

Built straight from the netlist (canvas netlist level). The same script is
run for sky130A and gf180mcuD; each PDK run provides its own netlist.spice
in the working directory, which from_spice reads.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice")
```