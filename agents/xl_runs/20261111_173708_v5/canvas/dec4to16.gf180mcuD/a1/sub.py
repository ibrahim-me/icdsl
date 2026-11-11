"""dec4to16 - 4-to-16 line decoder, laid out from the SPICE netlist.

Four input inverters, sixteen 4-input NAND gates and sixteen output
inverters are built as stick cells, placed in rows and wired with the
two-layer trunk router. PDK-generic: the same script builds on
sky130A, gf180mcuD and freepdk45.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="dec4to16", style="cells")
