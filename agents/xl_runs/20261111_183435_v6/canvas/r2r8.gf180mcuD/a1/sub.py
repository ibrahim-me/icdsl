from icdsl.canvas import *

tech = use()                      # PDK from --pdk (gf180mcuD / sky130A)
TOP = from_spice("netlist.spice") # r2r8 ladder; top cell takes the subcircuit name "r2r8"
