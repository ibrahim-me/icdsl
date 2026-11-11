import klayout.db as kdb

# ---------------- PDK: freepdk45 ----------------
GRID = 0.005
DBU = 0.0005

LAYERS = {
    "diff": (1, 0), "pwell": (2, 0), "nwell": (3, 0), "nplus": (4, 0),
    "pplus": (5, 0), "poly": (9, 0), "contact": (10, 0),
    "m1": (11, 0), "via1": (12, 0), "m2": (13, 0),
}
LABEL = {m: (11 + 2 * i, 1) for i, m in enumerate(
    ["m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8", "m9", "m10"])}

CUTS = {
    "contact": dict(size=0.065, space=0.075),
    "via1": dict(size=0.07, space=0.075),
}

# cell pitch
CW, CH = 1.66, 2.46
COLS, ROWS = 8, 16

# cell-internal geometry (um)
# x: bitline direction; y: wordline direction
BL_X = 0.20          # BL  metal1 pad center x
BLB_X = 1.46         # BLB metal1 pad center x
Q_X = 0.62           # Q   strap center x
QB_X = 1.04          # QB  strap center x
VDD_X = 1.24         # VDD strap center x
VSS_X = 0.44         # VSS strap center x
STRAP_W = 0.135      # metal1 strap width (contact 0.065 + 2*0.035 enc)
PAD = 0.065          # contact pad

# diffusion strips (x ranges)
DL_X0, DL_X1 = 0.10, 0.19      # left NMOS strip (Q side), width 0.09
DR_X0, DR_X1 = 1.47, 1.56      # right NMOS strip (QB side)
PL_X0, PL_X1 = 0.53, 0.71      # left PMOS strip (Q side), width 0.18
PR_X0, PR_X1 = 0.95, 1.13      # right PMOS strip (QB side)

# y regions
NMOS_Y0, NMOS_Y1 = 0.20, 0.60      # NMOS active row
PMOS_Y0, PMOS_Y1 = 1.86, 2.26      # PMOS active row
WL_Y = 0.40                        # word line poly (access gate) y
GATE_Y = 2.06                      # PMOS/NMOS gate y (cross-coupled)
Q_Y = 0.90                         # Q node contact y (between NMOS gate and PMOS gate)
QB_Y = 1.56
VSS_Y = 0.72                       # VSS strap contact y on NMOS strip
VDD_Y = 1.74                       # VDD strap contact y on PMOS strip
BL_Y = 1.03                        # BL pad contact y on left NMOS strip
BLB_Y = 1.43                       # BLB pad contact y on right NMOS strip
