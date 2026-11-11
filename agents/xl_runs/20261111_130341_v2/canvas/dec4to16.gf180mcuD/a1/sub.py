from icdsl.canvas import *
tech = use()

# Build the decoder layout from the PDK-specific netlist in the run directory.
# from_spice creates stick cells for inv/nand4, places the top subcircuit in
# rows, routes with the two-layer trunk router, and declares ports for all
# top pins (VDD VSS Y0..Y15 A0..A3).
TOP = from_spice("netlist.spice", top="dec4to16")
