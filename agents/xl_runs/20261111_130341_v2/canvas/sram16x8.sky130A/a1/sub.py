from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice", style="cells")
TOP.name = "sram16x8"
