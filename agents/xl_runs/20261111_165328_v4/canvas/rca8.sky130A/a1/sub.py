from icdsl.canvas import *

tech = use()                      # PDK from --pdk (sky130A here)
TOP = from_spice("netlist.spice", top="rca8")
