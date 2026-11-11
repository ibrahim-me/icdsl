```python
"""sram16x8 - 16 words x 8 bits of 6T SRAM, built directly from the netlist.

Runs unchanged on sky130A, gf180mcuD and freepdk45 (select with --pdk).
The top subcircuit sram6t becomes a stick cell; sram16x8 is placed in rows
and wired with the two-layer router. Every top pin becomes a port.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice")
```