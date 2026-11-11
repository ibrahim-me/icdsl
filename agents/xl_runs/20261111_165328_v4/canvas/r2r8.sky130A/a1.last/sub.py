from icdsl.canvas import *

tech = use()
# All-device netlist (25 unit poly resistors): use the rows style, which places
# the resistors and routes them with the two-layer router. Every top pin
# (B0..B7, OUT, VSS) becomes a port; internal net names are free for LVS.
TOP = from_spice("netlist.spice", style="rows")
