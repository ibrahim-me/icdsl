"""dec4to16: 4-to-16 decoder laid out directly from the netlist.

Same script for sky130A, gf180mcuD and freepdk45: the PDK comes from --pdk,
the netlist (netlist.spice) is read from the run directory.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", style="cells")
