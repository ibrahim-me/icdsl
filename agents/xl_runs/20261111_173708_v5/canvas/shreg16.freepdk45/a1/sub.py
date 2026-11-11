"""shreg16 - 16-bit shift register: layout straight from the task netlist."""
from icdsl.canvas import *

tech = use()                       # freepdk45 (also sky130A / gf180mcuD via --pdk)
TOP = from_spice("netlist.spice", top="shreg16", style="cells")
