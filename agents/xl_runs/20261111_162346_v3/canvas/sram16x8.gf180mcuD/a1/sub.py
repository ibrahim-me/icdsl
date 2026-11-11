"""sram16x8: 16 x 8 array of 6T SRAM cells, laid out from the SPICE netlist.

The same script builds on sky130A, gf180mcuD and freepdk45 (PDK selected with --pdk).
sram6t (uniform n/p widths and gate length) becomes a stick cell; the top is placed
in rows in netlist order (16 rows x 8 columns) and wired with the trunk router.
"""
from icdsl.canvas import *

tech = use()

# netlist.spice sits in the directory the script runs in.
TOP = from_spice("netlist.spice")
