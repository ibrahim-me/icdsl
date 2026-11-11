"""ota_miller - two-stage Miller OTA built straight from the netlist.

The same script runs on every PDK: it reads netlist.spice from the run
directory (sky130A.spice / gf180mcuD.spice / freepdk45.spice as appropriate)
and lets from_spice place the strips, rings, resistor, MIM capacitor and
routing.  Top cell is the subckt name (ota_miller); every top pin becomes a
port.
"""
from icdsl.canvas import *

tech = use()
TOP = from_spice("netlist.spice")
