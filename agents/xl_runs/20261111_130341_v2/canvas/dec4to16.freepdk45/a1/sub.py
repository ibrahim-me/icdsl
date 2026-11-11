from icdsl.canvas import *

tech = use()                       # freepdk45 from --pdk / $ICL_PDK
TOP = from_spice("netlist.spice", top="dec4to16")
TOP.name = "dec4to16"
