"""cdac6 - 6-bit binary-weighted capacitor array (MIM unit caps, shared TOP plate).

Built from the netlist with the canvas rows style: 64 identical cap_mim units,
TOP common to every top plate, bottom plates grouped 32/16/8/4/2/1 onto B5..B0
and the last unit to VSS. Same script builds on sky130A and gf180mcuD.
"""
from icdsl.canvas import *

tech = use()                      # PDK from --pdk (sky130A / gf180mcuD)
TOP = from_spice("netlist.spice") # rows style: cap grid + router + top ports
