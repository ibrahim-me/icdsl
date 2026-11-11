from icdsl.canvas import *

tech = use()                      # PDK from --pdk (gf180mcuD here; also sky130A, freepdk45)
TOP = from_spice("netlist.spice", top="shreg16")
