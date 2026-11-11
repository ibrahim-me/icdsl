"""rca8 8-bit ripple-carry adder: layout straight from the netlist.

One script for sky130A, gf180mcuD and freepdk45; the PDK is chosen with --pdk.
Each `fa` subcircuit becomes one stick cell; the top level is placed in rows
and wired with the two-layer router. Top cell name is `rca8`.
"""
from icdsl.canvas import *

tech = use()                      # PDK from --pdk / $ICL_PDK (default sky130A)
TOP = from_spice("netlist.spice", top="rca8", style="cells")
