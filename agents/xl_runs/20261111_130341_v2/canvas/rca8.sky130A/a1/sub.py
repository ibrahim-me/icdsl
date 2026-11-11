"""rca8 - 8-bit ripple-carry adder from the transistor netlist.

Canvas netlist flow (section 8): the MOS-only `fa` subcircuit becomes a
stick cell, the top `rca8` is placed in rows and wired with the two-layer
router. PDK-generic: reads netlist.spice for the selected --pdk.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", top="rca8")
