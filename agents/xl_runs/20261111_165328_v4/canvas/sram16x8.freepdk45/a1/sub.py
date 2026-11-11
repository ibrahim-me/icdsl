"""16 x 8 6T SRAM array: laid out directly from the netlist (PDK-generic)."""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice")
