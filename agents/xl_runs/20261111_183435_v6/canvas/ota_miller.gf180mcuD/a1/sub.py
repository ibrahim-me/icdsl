from icdsl.canvas import *

tech = use()                      # gf180mcuD (from --pdk / $ICL_PDK)
TOP = from_spice("netlist.spice", style="rows")   # top = ota_miller
