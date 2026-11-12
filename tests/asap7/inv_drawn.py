"""ASAP7 (7 nm FinFET), drawn shape by shape: an inverter (3 fins per transistor) next to a tap column,
with the geometry of the PDK's 7.5-track cells INVx1 and TAPCELL. No device helper is used - only
rect() on the PDK layers - so this is the reference for what the deck accepts and for the extraction.
Judges: the ASAP7 KLayout DRC deck, KLayout extraction, netgen LVS."""
from icdsl.canvas import *

tech = use("asap7")
c = Cell("inv_drawn")
H = 270                                           # cell height, nm
WI, WT = 162, 108                                 # inverter: 3 gate pitches, tap column: 2 gate pitches
W = WI + WT


def R(layer, x0, y0, x1, y1, net=None, dx=0):
    return c.rect(layer, x0=(x0 + dx) / 1000, y0=y0 / 1000, x1=(x1 + dx) / 1000, y1=y1 / 1000, net=net)


# ---- shared by the row: fins on the 27 nm grid, supply rails (m1 over lig), n-well over the upper half
for k in range(10):
    R("fin", 0, 10 + 27 * k, W, 17 + 27 * k)
R("nwell", 0, 135, W, 270, "VDD")
vss = R("m1", 0, -9, W, 9, "VSS")
vdd = R("m1", 0, 261, W, 279, "VDD")
R("lig", 0, -8, W, 8, "VSS")
R("lig", 0, 262, W, 278, "VDD")
R("gcut", 0, -22, W, 22)                          # cuts every gate under the rails
R("gcut", 0, 248, W, 292)

# ---- inverter
R("nselect", 0, 0, WI, 135)
R("pselect", 0, 135, WI, 270)
for x in (17, 71, 125):                           # dummy gate, the transistor gate, dummy gate
    R("gate", x, -5, x + 20, 275, "A" if x == 71 else None)
R("gcut", 0, 113, 54, 157)                        # the dummy gates are cut between n and p
R("gcut", 108, 113, 162, 157)
R("active", 46, 27, 116, 108)                     # 3 fins each
R("active", 46, 162, 116, 243)
for x in (42, 96):
    R("sdt", x, 27, x + 24, 108)
    R("sdt", x, 162, x + 24, 243)
R("lisd", 42, 0, 66, 108, "VSS")                  # sources reach the rails on lisd
R("lisd", 42, 162, 66, 270, "VDD")
R("lisd", 96, 27, 120, 108, "Y")
R("lisd", 96, 162, 120, 243, "Y")
R("lig", 54, 124, 93, 146, "A")                   # gate contact
for x, y in ((45, -9), (45, 261), (99, -9), (99, 261), (55, 126), (99, 27), (99, 225)):
    R("v0", x, y, x + 18, y + 18)
a = R("m1", 18, 27, 36, 243, "A")
R("m1", 18, 27, 55, 45, "A")
R("m1", 18, 225, 55, 243, "A")
R("m1", 18, 126, 78, 144, "A")
y = R("m1", 126, 27, 144, 243, "Y")
R("m1", 94, 27, 144, 45, "Y")
R("m1", 94, 225, 144, 243, "Y")

# ---- tap column: p+ in the substrate (VSS), n+ in the n-well (VDD); note the swapped selects
R("pselect", 0, 0, WT, 135, dx=WI)
R("nselect", 0, 135, WT, 270, dx=WI)
for x in (17, 71):
    R("gate", x, -5, x + 20, 275, dx=WI)
R("gcut", 0, 113, WT, 157, dx=WI)
R("active", 46, 27, 62, 108, dx=WI)
R("active", 46, 162, 62, 243, dx=WI)
R("sdt", 42, 27, 66, 108, dx=WI)
R("sdt", 42, 162, 66, 243, dx=WI)
R("lisd", 42, 0, 66, 108, "VSS", dx=WI)
R("lisd", 42, 162, 66, 270, "VDD", dx=WI)
R("v0", 45, -9, 63, 9, dx=WI)
R("v0", 45, 261, 63, 279, dx=WI)

c.set_boundary(0, 0, W / 1000, H / 1000)
c.port("A", on=a, dir="in")
c.port("Y", on=y, dir="out")
c.port("VDD", on=vdd, dir="power")
c.port("VSS", on=vss, dir="ground")
c.device("MN", "nmos_rvt", ["Y", "A", "VSS", "VSS"], prefix="M", w=0.081, l=0.020)
c.device("MP", "pmos_rvt", ["Y", "A", "VDD", "VDD"], prefix="M", w=0.081, l=0.020)
TOP = c
