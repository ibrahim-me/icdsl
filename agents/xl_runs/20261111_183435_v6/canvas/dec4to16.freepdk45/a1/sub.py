"""dec4to16: 4-to-16 line decoder laid out directly from the SPICE netlist.

The same script runs on sky130A, gf180mcuD and freepdk45; each PDK run has its
own netlist.spice in the working directory. inv and nand4 are uniform CMOS
leaf cells, so from_spice builds them as stick cells and places/wires the top
with rows + the two-layer trunk router.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="dec4to16")
