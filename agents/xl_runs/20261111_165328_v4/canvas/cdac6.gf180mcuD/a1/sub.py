from icdsl.canvas import *

tech = use()                      # gf180mcuD (from --pdk / $ICL_PDK)
TOP = from_spice("netlist.spice") # 64 unit MIM caps, rows style -> cdac6 cell
