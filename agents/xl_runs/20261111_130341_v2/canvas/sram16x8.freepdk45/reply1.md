```python
from icdsl.canvas import *

tech = use()                      # freepdk45 (or sky130A / gf180mcuD -- same script)

# The netlist file netlist.spice sits in the script's working directory.
# sram6t is a uniform CMOS cell (one n width, one p width, one gate length) so
# from_spice builds it as a stick cell ("cells" style) and places the 128
# instances of sram16x8 in rows, then wires everything with the two-layer router.
TOP = from_spice("netlist.spice", top="sram16x8", style="cells", nrows=16)

# Make sure the top cell carries the required name.
TOP.name = "sram16x8"
```