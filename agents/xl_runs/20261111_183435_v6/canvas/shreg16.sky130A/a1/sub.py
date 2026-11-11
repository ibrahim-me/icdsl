from icdsl.canvas import *

tech = use()                      # PDK from --pdk (sky130A / gf180mcuD / freepdk45)
TOP = from_spice("netlist.spice") # dff -> stick cell; shreg16 -> rows + two-layer router
