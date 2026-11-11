from icdsl.canvas import *

tech = use()                      # sky130A (or gf180mcuD) from --pdk / $ICL_PDK

# Build the R-2R ladder directly from the task netlist (25 unit poly resistors).
# from_spice flattens the hierarchy, places each resistor as a strip with the
# drawn W/L from the netlist, routes all nets, and creates ports for B0..B7,
# OUT and VSS. The top subcircuit is named r2r8, so the top cell is r2r8.
TOP = from_spice("netlist.spice")
