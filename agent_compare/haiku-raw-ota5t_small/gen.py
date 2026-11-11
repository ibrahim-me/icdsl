import klayout.db as db

OUT = "/home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-raw-ota5t_small/ota5t_small.gds"

def um(v):
    return int(round(v * 1000))

ly = db.Layout()
ly.dbu = 0.001
top = ly.create_cell("ota5t_small")

def LY(l, d):
    return ly.layer(l, d)

NWELL = LY(64, 20); DIFF = LY(65, 20); TAP = LY(65, 44); POLY = LY(66, 20)
LICON = LY(66, 44); NPC = LY(95, 20); NSDM = LY(93, 44); PSDM = LY(94, 20)
LI = LY(67, 20); MCON = LY(67, 44); MET1 = LY(68, 20); VIA = LY(68, 44); MET2 = LY(69, 20)
LI_T = LY(67, 5); MET1_T = LY(68, 5); MET2_T = LY(69, 5)
MET1_P = LY(68, 16); MET2_P = LY(69, 16)

def box(l, x0, y0, x1, y1):
    top.shapes(l).insert(db.Box(um(x0), um(y0), um(x1), um(y1)))

def sq(l, x, y, h):
    box(l, x - h, y - h, x + h, y + h)

def label(l, s, x, y):
    top.shapes(l).insert(db.Text(s, db.Trans(um(x), um(y))))

def diff_contact(x, y):
    # licon + li pad + mcon, met1 pad added separately
    sq(LICON, x, y, 0.085)
    sq(LI, x, y, 0.165)
    sq(MCON, x, y, 0.085)
    sq(MET1, x, y, 0.165)

def gate_contact(x, y):
    sq(LICON, x, y, 0.085)
    sq(NPC, x, y, 0.185)
    sq(LI, x, y, 0.165)
    sq(MCON, x, y, 0.085)

def via(x, y):
    sq(VIA, x, y, 0.075)

X0 = 1.0
gx = [X0 + 0.78 * i for i in range(4)]
cg = [g + 0.25 for g in gx]
cr0 = X0 - 0.25
cr1 = X0 + 0.64
cr2 = X0 + 1.42
cr3 = X0 + 2.20
cr4 = X0 + 3.09
ntx = X0 + 4.05

# ---- wells / implants ----
box(NWELL, X0 - 0.58, 2.62, X0 + 4.38, 3.98)
box(NSDM, X0 - 0.525, -1.725, X0 + 3.365, 1.125)   # NMOS + MT n+ implant
box(PSDM, X0 - 0.525, 2.675, X0 + 3.365, 3.925)    # PMOS p+ implant
box(NSDM, X0 + 3.775, 2.875, X0 + 4.325, 3.725)    # n-tap implant
box(PSDM, X0 - 0.725, -3.175, X0 + 3.565, -2.425)  # p-tap implant

# ---- diffusion ----
box(DIFF, X0 - 0.4, 0.0, X0 + 3.24, 1.0)     # NMOS pair
box(DIFF, X0 - 0.4, -1.6, X0 + 3.24, -0.6)   # MT
box(DIFF, X0 - 0.4, 2.8, X0 + 3.24, 3.8)     # PMOS pair
box(DIFF, X0 + 3.9, 3.0, X0 + 4.2, 3.6)      # n-tap
box(TAP, X0 + 3.9, 3.0, X0 + 4.2, 3.6)
box(DIFF, X0 - 0.6, -3.05, X0 + 3.44, -2.55)   # p-tap
box(TAP, X0 - 0.6, -3.05, X0 + 3.44, -2.55)

# ---- poly gates ----
for i in range(4):
    box(POLY, gx[i], -0.13, gx[i] + 0.5, 1.53)   # NMOS M1/M2
    box(POLY, gx[i], -2.13, gx[i] + 0.5, -0.47)  # MT
    box(POLY, gx[i], 2.67, gx[i] + 0.5, 4.33)    # PMOS M3/M4

# ---- diffusion contacts + met1 pads ----
for x in (cr0, cr1, cr2, cr3, cr4):
    for y in (0.5, -1.1, 3.3):
        diff_contact(x, y)
        sq(MET1, x, y, 0.165)
diff_contact(ntx, 3.3); sq(MET1, ntx, 3.3, 0.165)
for x in (cr0, cr2, cr4):
    diff_contact(x, -2.8); sq(MET1, x, -2.8, 0.165)

# ---- gate contacts ----
for i in (0, 3):
    gate_contact(cg[i], 1.36)
for i in (1, 2):
    gate_contact(cg[i], 1.36)
for i in range(4):
    gate_contact(cg[i], -1.96)
    gate_contact(cg[i], 4.16)

# INP gates: met1 column + vias to met2 strap at y 1.85
for i in (0, 3):
    box(MET1, cg[i] - 0.14, 1.195, cg[i] + 0.14, 2.01)
    via(cg[i], 1.85)
# INN gates
for i in (1, 2):
    box(MET1, cg[i] - 0.14, 1.195, cg[i] + 0.14, 2.51)
    via(cg[i], 2.35)
# PMOS x gates
for i in range(4):
    box(MET1, cg[i] - 0.14, 4.0, cg[i] + 0.14, 4.715)
    via(cg[i], 4.55)
# MT VBN gates
for i in range(4):
    box(MET1, cg[i] - 0.14, -2.415, cg[i] + 0.14, -1.795)
    via(cg[i], -2.25)

# ---- met2 straps ----
box(MET2, cg[0] - 0.165, 1.68, cg[3] + 0.165, 2.02)     # INP
box(MET2, cg[1] - 0.165, 2.18, cg[2] + 0.165, 2.52)     # INN
box(MET2, cr0 - 0.165, 4.38, cr4 + 0.165, 4.72)         # x (PMOS gates + drains)
box(MET2, cg[0] - 0.165, -2.42, cg[3] + 0.165, -2.08)   # VBN

# ---- met1 wires ----
via(cr0, 4.55); via(cr4, 4.55)
box(MET1, cr0 - 0.165, 0.335, cr0 + 0.165, 4.715)       # x
box(MET1, cr4 - 0.165, 0.335, cr4 + 0.165, 4.715)       # x
box(MET1, cr2 - 0.1, 0.335, cr2 + 0.1, 3.465)           # OUT
box(MET1, cr1 - 0.165, -1.265, cr1 + 0.165, 0.665)      # tail
box(MET1, cr3 - 0.165, -1.265, cr3 + 0.165, 0.665)      # tail
box(MET1, cr1 - 0.165, -0.4, cr3 + 0.165, -0.2)         # tail strap
box(MET1, cr1 - 0.1, 3.135, cr1 + 0.1, 5.25)            # VPWR
box(MET1, cr3 - 0.1, 3.135, cr3 + 0.1, 5.25)            # VPWR
box(MET1, ntx - 0.1, 3.135, ntx + 0.1, 5.25)            # VPWR (n-tap)
box(MET1, cr1 - 0.1, 4.95, ntx + 0.1, 5.25)             # VPWR strap
box(MET1, cr0 - 0.165, -2.965, cr0 + 0.165, -0.935)     # VGND
box(MET1, cr4 - 0.165, -2.965, cr4 + 0.165, -0.935)     # VGND
box(MET1, cr2 - 0.1, -2.8, cr2 + 0.1, -0.935)           # VGND
box(MET1, cr0 - 0.165, -2.965, cr4 + 0.165, -2.635)     # VGND strap

# ---- labels ----
label(MET2_T, "INP", cg[0], 1.85)
label(MET2_P, "INP", cg[0], 1.85)
box(MET2_P, cg[0] - 0.165, 1.68, cg[3] + 0.165, 2.02)
label(MET2_T, "INN", cg[1], 2.35)
label(MET2_P, "INN", cg[1], 2.35)
box(MET2_P, cg[1] - 0.165, 2.18, cg[2] + 0.165, 2.52)
label(MET2_T, "VBN", cg[0], -2.25)
label(MET2_P, "VBN", cg[0], -2.25)
box(MET2_P, cg[0] - 0.165, -2.42, cg[3] + 0.165, -2.08)
label(MET1_T, "OUT", cr2, 1.0)
label(MET1_P, "OUT", cr2, 1.0)
box(MET1_P, cr2 - 0.1, 0.9, cr2 + 0.1, 1.1)
label(MET1_T, "x", cr0, 3.8)
label(MET1_T, "tail", cr1, 0.0)
label(MET1_T, "VPWR", cr1, 5.1)
label(MET1_P, "VPWR", cr1, 5.1)
box(MET1_P, cr1 - 0.1, 4.95, ntx + 0.1, 5.25)
label(MET1_T, "VGND", cr0, -2.8)
label(MET1_P, "VGND", cr0, -2.8)
box(MET1_P, cr0 - 0.165, -2.965, cr4 + 0.165, -2.635)

ly.write(OUT)
print("wrote", OUT)
