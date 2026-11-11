import klayout.db as db
OUT = "/home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-raw-nand3/nand3.gds"
LAY = {'nwell':(64,20),'diff':(65,20),'tap':(65,44),'poly':(66,20),'licon':(66,44),
       'npc':(95,20),'nsdm':(93,44),'psdm':(94,20),'li':(67,20),'mcon':(67,44),
       'met1':(68,20),'via':(68,44),'met2':(69,20),'li_lbl':(67,5),'met1_lbl':(68,5),'met1_pin':(68,16),'met1_pinrect':(68,16)}

ly = db.Layout(); ly.dbu = 0.001
top = ly.create_cell("nand3")
L = {k: ly.layer(*v) for k, v in LAY.items()}

def R(layer, x1, y1, x2, y2):
    x1, x2 = sorted((x1, x2)); y1, y2 = sorted((y1, y2))
    top.shapes(L[layer]).insert(db.Box(round(x1*1000), round(y1*1000), round(x2*1000), round(y2*1000)))

def T(layer, text, x, y):
    top.shapes(L[layer]).insert(db.Text(text, db.Trans(round(x*1000), round(y*1000))))

def licon(x1, y1):           # 0.17 contact, lower-left corner
    R('licon', x1, y1, x1+0.17, y1+0.17)

def mcon(x1, y1):
    R('mcon', x1, y1, x1+0.17, y1+0.17)

def li_stack(x1, y1, li_box, met_box):
    """li pad + mcon + met1 pad for a contact at (x1,y1) (lower-left of licon)."""
    R('li', *li_box)
    mcon(x1, y1)
    R('met1', *met_box)


def PIN(text, box, x, y):
    """pin rectangle on met1 pin datatype (68/16) over the met1 shape, plus text on 68/16 and 68/5"""
    R('met1_pinrect', *box)
    T('met1_pin', text, x, y)
    T('met1_lbl', text, x, y)

XL, XR = -0.30, 2.00
YG0, YG1 = 0.0, 2.72
W_RAIL = 0.34

# ---- rails (met1), centred on y=0 and y=2.72
R('met1', XL, -0.17, XR, 0.17)
R('met1', XL, 2.55, XR, 2.89)
PIN('VGND', (XL, -0.17, XR, 0.17), 0.10, 0.0)
PIN('VPWR', (XL, 2.55, XR, 2.89), 0.10, 2.72)

# ---- n-well (pmos + n-tap)
R('nwell', -0.24, 1.395, 1.70, 3.025)

# ---- body taps
# p-tap under VGND rail
R('diff', -0.06, -0.125, 1.52, 0.125)
R('tap', -0.06, -0.125, 1.52, 0.125)
R('psdm', -0.185, -0.25, 1.645, 0.25)
for x in (0.43,):
    licon(x, -0.085)
    R('li', x-0.08, -0.165, x+0.25, 0.165)
    mcon(x, -0.085)
# n-tap under VPWR rail
R('diff', -0.06, 2.595, 1.52, 2.845)
R('tap', -0.06, 2.595, 1.52, 2.845)
R('nsdm', -0.185, 2.47, 1.645, 2.97)
for x in (0.43,):
    licon(x, 2.635)
    R('li', x-0.08, 2.555, x+0.25, 2.885)
    mcon(x, 2.635)

# ---- nmos: diff y 0.42..0.91 (W=0.49), nsdm
R('diff', -0.06, 0.42, 1.52, 0.91)
R('nsdm', -0.185, 0.295, 1.645, 1.035)
# ---- pmos: diff y 1.575..2.325 (W=0.75), psdm
R('diff', -0.06, 1.575, 1.52, 2.325)
R('psdm', -0.185, 1.45, 1.645, 2.45)

# ---- gate poly stripes (C, B, A) and input poly pads
GC, GB, GA = (0.225, 0.375), (0.655, 0.805), (1.085, 1.235)
R('poly', GC[0], 0.29, GC[1], 2.455)
R('poly', GB[0], 0.29, GB[1], 2.455)
R('poly', GA[0], 0.29, GA[1], 2.455)
R('poly', 0.05, 1.02, GC[1], 1.35)      # C pad (extends left)
R('poly', 0.605, 1.02, 0.875, 1.35)     # B pad (centred)
R('poly', GA[0], 1.02, 1.92, 1.35)      # A pad (extends right)

# input poly contacts + li + met1 pads, input labels
# C
licon(0.10, 1.10)
li_stack(0.10, 1.10, (0.02, 1.02, 0.35, 1.35), (0.02, 1.035, 0.37, 1.335))
PIN('C', (0.02, 1.035, 0.37, 1.335), 0.18, 1.185)
# B
licon(0.655, 1.10)
li_stack(0.655, 1.10, (0.575, 1.02, 0.905, 1.35), (0.57, 1.035, 0.91, 1.335))
PIN('B', (0.57, 1.035, 0.91, 1.335), 0.74, 1.185)
# A
licon(1.70, 1.10)
li_stack(1.70, 1.10, (1.62, 1.02, 1.95, 1.35), (1.67, 0.99, 1.90, 1.38))
PIN('A', (1.67, 0.99, 1.90, 1.38), 1.785, 1.185)

# ---- nmos source/drain contacts: c0 = VGND (x 0..0.17), c3 = Y (x 1.29..1.46)
# nmos S/D nodes n1 (x .43-.60) and n2 (.86-1.03) are internal: no contact
licon(0.00, 0.58)
R('li', -0.08, 0.50, 0.25, 0.83)
mcon(0.00, 0.58)
R('met1', -0.06, 0.10, 0.23, 0.82)      # stub to VGND rail

licon(1.29, 0.58)
R('li', 1.21, 0.50, 1.54, 0.83)
mcon(1.29, 0.58)

# ---- pmos S/D contacts
# p0 (x 0..0.17) VPWR, top edge
licon(0.00, 2.115)
R('li', -0.08, 2.035, 0.25, 2.365)
mcon(0.00, 2.115)
R('met1', -0.06, 2.055, 0.23, 2.60)     # stub to VPWR rail
# p2 (x .86..1.03) VPWR, top edge
licon(0.86, 2.115)
R('li', 0.78, 2.035, 1.11, 2.365)
mcon(0.86, 2.115)
R('met1', 0.80, 2.055, 1.09, 2.60)
# p1 (x .43..0.60) Y, bottom edge
licon(0.43, 1.62)
R('li', 0.35, 1.54, 0.68, 1.87)
mcon(0.43, 1.62)
# p3 (x 1.29..1.46) Y, bottom edge
licon(1.29, 1.62)
R('li', 1.21, 1.54, 1.54, 1.87)
mcon(1.29, 1.62)

# ---- Y routing: met1 band across pmos bottom contacts + vertical stripe down to nmos c3
R('met1', 0.37, 1.56, 1.52, 1.85)
R('met1', 1.23, 0.50, 1.52, 1.85)
PIN('Y', (0.37, 1.56, 1.52, 1.85), 0.90, 1.70)

ly.write(OUT)
print("wrote", OUT)
