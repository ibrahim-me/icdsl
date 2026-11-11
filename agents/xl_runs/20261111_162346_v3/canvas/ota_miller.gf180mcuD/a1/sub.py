"""ota_miller two-stage Miller OTA, built from the task netlist (rows style).

Fingers are merged into multi-finger strips; nMOS strips sit in a substrate ring
and pMOS strips in an n-well ring (with taps), the poly nulling resistor RZ and
the MIM Miller capacitor CC are placed, and two routers wire everything. The same
script runs on sky130A, gf180mcuD and freepdk45; the netlist file is provided per
PDK as netlist.spice in the run directory.
"""
from icdsl.canvas import *

tech = use()

TOP = from_spice("netlist.spice", top="ota_miller", style="rows")
