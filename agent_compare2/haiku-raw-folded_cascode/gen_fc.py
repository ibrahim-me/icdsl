#!/usr/bin/env python3
# Raw GDS generator for folded_cascode. All coordinates in nm (DBU = 1 nm).
import sys
import klayout.db as db

OUTP = sys.argv[1]
lay = db.Layout()
lay.dbu = 0.001
top = lay.create_cell("folded_cascode")

LAY = dict(
    nwell=(64, 20), diff=(65, 20), tap=(65, 44), poly=(66, 20), licon=(66, 44),
    nsdm=(93, 44), psdm=(94, 20), li=(67, 20), mcon=(67, 44), met1=(68, 20),
    via=(68, 44), met2=(69, 20), met2_lbl=(69, 5), met2_pin=(69, 16),
)
_li = {}


def L_(n):
    if n not in _li:
        _li[n] = lay.layer(*LAY[n])
    return _li[n]


def R(n, x1, y1, x2, y2):
    assert x1 < x2 and y1 < y2, (n, x1, y1, x2, y2)
    top.shapes(L_(n)).insert(db.Box(x1, y1, x2, y2))


def SQ(n, x, y, s):
    R(n, x - s // 2, y - s // 2, x + s // 2, y + s // 2)


def LBL(n, text, x, y):
    top.shapes(L_(n)).insert(db.Text(text, db.Trans(x, y)))


# ---------------- device finger sequences (left -> right) ----------------
# (device, gate net, left column net, right column net, break needs tap)
PM = [
    ('MT', 'VBP', 'VPWR', 'tail', False),
    ('MT', 'VBP', 'tail', 'VPWR', False),
    ('MT', 'VBP', 'VPWR', 'tail', False),
    ('MT', 'VBP', 'tail', 'VPWR', False),
    ('M1', 'INP', 'f1', 'tail', True),
    ('M2', 'INN', 'tail', 'f2', False),
    ('M2', 'INN', 'f2', 'tail', False),
    ('M1', 'INP', 'tail', 'f1', False),
    ('M7', 'x', 'y', 'VPWR', False),
    ('M8', 'x', 'VPWR', 'z', False),
    ('M8', 'x', 'z', 'VPWR', False),
    ('M7', 'x', 'VPWR', 'y', False),
    ('M9', 'VCP', 'x', 'y', True),
    ('M10', 'VCP', 'z', 'OUT', False),
    ('M10', 'VCP', 'OUT', 'z', False),
    ('M9', 'VCP', 'y', 'x', False),
]
NM = [
    ('M3', 'VBN', 'f1', 'VGND', False),
    ('M4', 'VBN', 'VGND', 'f2', False),
    ('M4', 'VBN', 'f2', 'VGND', False),
    ('M3', 'VBN', 'VGND', 'f1', False),
    ('M5', 'VCN', 'x', 'f1', False),
    ('M6', 'VCN', 'f2', 'OUT', False),
    ('M6', 'VCN', 'OUT', 'f2', False),
    ('M5', 'VCN', 'f1', 'x', False),
]

# ---------------- track assignment (y of met2 tracks, nm) ----------------
TOP = dict(INP=2200, INN=2800, VBP=3400, tail=4000, VPWR=4600, y=5200, z=5800,
           VCP=6400, f1=7000, f2=7600, x=8200, OUT=8800)
BOT = dict(f1=-5000, f2=-5600, x=-6200, OUT=-6800, VBN=-7400, VCN=-8000, VGND=-8600)
# trunk x for nets that connect top band to bottom band (nested ordering)
TRUNK = dict(f1=-1600, f2=-2100, x=-2600, OUT=-3100)
PORT_SIDE = dict(INP='top', INN='top', VBP='top', VCP='top', OUT='top', VPWR='top',
                 VBN='bot', VCN='bot', VGND='bot')

PIN_TOP = 1450      # PMOS gate contact y
PIN_SD_P = 500      # PMOS S/D contact y
PIN_SD_N = -3500    # NMOS S/D contact y
PIN_G_N = -4450     # NMOS gate contact y

pins = []           # (net, x, y, side)
all_x = []


def row(F, yd0, yd1, yg, ysd, gpoly, side, is_p):
    cols, gates, islands, taps = [], [], [], []
    cx = 0
    cols.append((cx, F[0][2]))
    isl = cx
    for i, (dev, g, Ln, Rn, tapb) in enumerate(F):
        if i > 0 and F[i - 1][3] != Ln:
            d = 2000 if tapb else 1200
            prev = cx
            cx = cx + d
            islands.append((isl, prev))
            isl = cx
            if tapb:
                taps.append((prev + cx) // 2)
            cols.append((cx, Ln))
        gx = cx + 700
        gates.append((gx, g))
        cx = gx + 700
        cols.append((cx, Rn))
    islands.append((isl, cx))
    for (xa, xb) in islands:
        R('diff', xa - 145, yd0, xb + 145, yd1)
        if is_p:
            R('psdm', xa - 270, yd0 - 125, xb + 270, yd1 + 125)
        else:
            R('nsdm', xa - 270, yd0 - 125, xb + 270, yd1 + 125)
    for (gx, g) in gates:
        R('poly', gx - 250, gpoly[0], gx + 250, gpoly[1])
        pins.append((g, gx, yg, side))
        all_x.append(gx)
    for (x, n) in cols:
        pins.append((n, x, ysd, side))
        all_x.append(x)
    return cols, taps


# ---------------- PMOS band ----------------
pcols, ptaps = row(PM, 0, 1000, PIN_G_N * 0 + PIN_TOP, PIN_SD_P, (-130, 1615), 'top', True)
pxmin = min(x for x, _ in pcols)
pxmax = max(x for x, _ in pcols)
R('nwell', pxmin - 500, -500, pxmax + 500, 1900)
for tx in ptaps:
    R('diff', tx - 210, 290, tx + 210, 710)
    R('tap', tx - 210, 290, tx + 210, 710)
    R('nsdm', tx - 335, 165, tx + 335, 835)
    pins.append(('VPWR', tx, PIN_SD_P, 'top'))
    all_x.append(tx)

# ---------------- NMOS band ----------------
ncols, _ = row(NM, -4000, -3000, PIN_G_N, PIN_SD_N, (-4615, -2870), 'bot', False)
nptaps = [-1200, ncols[-1][0] + 1200]
for px in nptaps:
    R('diff', px - 210, -3710, px + 210, -3290)
    R('tap', px - 210, -3710, px + 210, -3290)
    R('psdm', px - 335, -3835, px + 335, -3165)
    pins.append(('VGND', px, PIN_SD_N, 'bot'))
    all_x.append(px)

# ---------------- tracks and trunks ----------------
nets_top = {}
nets_bot = {}
for (n, x, y, s) in pins:
    (nets_top if s == 'top' else nets_bot).setdefault(n, []).append(x)

track_extent = {}
for side, nets, Tmap in (('top', nets_top, TOP), ('bot', nets_bot, BOT)):
    for n, xs in nets.items():
        T = Tmap[n]
        hi = max(xs)
        lo = min(xs)
        if n in TRUNK and side in ('top', 'bot'):
            lo = min(lo, TRUNK[n])
        track_extent[(n, side)] = (lo, hi, T)
        R('met2', lo - 175, T - 150, hi + 175, T + 150)
        mid = (lo + hi) // 2
        LBL('met2_lbl', n, mid, T)
        if PORT_SIDE.get(n) == side:
            R('met2_pin', lo - 175, T - 150, hi + 175, T + 150)
            LBL('met2_pin', n, mid, T)

for n, tx in TRUNK.items():
    R('met2', tx - 150, BOT[n] - 150, tx + 150, TOP[n] + 150)

# ---------------- pin stacks (licon -> li -> mcon -> met1 stub -> via1) ----------------
for (n, x, y, s) in pins:
    T = TOP[n] if s == 'top' else BOT[n]
    SQ('licon', x, y, 170)
    SQ('li', x, y, 330)
    SQ('mcon', x, y, 170)
    R('met1', x - 160, min(y, T) - 160, x + 160, max(y, T) + 160)
    SQ('via', x, T, 150)

# port pins on pin datatype are added above (met2_pin); nothing else needed

lay.write(OUTP)
print("wrote", OUTP)
