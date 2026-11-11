from icdsl.canvas import *

tech = use()                      # gf180mcuD (or any PDK with sram6t devices)
c0, m1 = tech.c0, tech.metal(1)

# Build the whole 16x8 SRAM from the netlist: one stick cell for sram6t
# (uniform 0.36u nfet / 0.72u pfet, l=0.28u), then 16 placement rows - one
# row per word line - wired by the two-layer router.
TOP = from_spice("netlist.spice", style="cells", nrows=16)

# Top-level pins on metal 1 so they are visible outside the array.
for name in ("VSS", "VDD"):
    shapes = [s for s in TOP.shapes if s.net == name and s.layer == m1]
    if shapes:
        TOP.port(name, on=shapes[0])
for i in range(8):
    for base, layer in (("BL", m1), ("BLB", m1)):
        name = "%s%d" % (base, i)
        shapes = [s for s in TOP.shapes if s.net == name and s.layer == m1]
        if shapes:
            TOP.port(name, on=shapes[0])
for i in range(16):
    name = "WL%d" % i
    shapes = [s for s in TOP.shapes if s.net == name and s.layer in (m1, c0)]
    if shapes:
        TOP.port(name, on=shapes[0])
