from icdsl.canvas import *

tech = use()                      # gf180mcuD (from --pdk / $ICL_PDK)
TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
