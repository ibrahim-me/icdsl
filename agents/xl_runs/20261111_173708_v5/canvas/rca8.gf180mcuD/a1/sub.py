"""rca8: 8-bit ripple-carry adder from the task netlist, canvas netlist level."""
from icdsl.canvas import *

tech = use()                      # PDK from --pdk (gf180mcuD here; same script works on sky130A / freepdk45)
TOP = from_spice("netlist.spice", top="rca8")
