import itertools, math, sys
import klayout.db as kdb

OUT = sys.argv[1]
shapes = []   # (layer, x0, y0, x1, y1, net)
texts = []    # (layer, text, x, y)

def R(layer, x0, y0, x1, y1, net=None):
    shapes.append((layer, round(min(x0, x1), 4), round(min(y0, y1), 4),
                   round(max(x0, x1), 4), round(max(y0, y1), 4), net))

LAYERS = {'nwell': (64, 20), 'diff': (65, 20), 'tap': (65, 44), 'poly': (66, 20),
          'licon': (66, 44), 'npc': (95, 20), 'nsdm': (93, 44), 'psdm': (94, 20),
          'li': (67, 20), 'mcon': (67, 44), 'met1': (68, 20), 'via': (68, 44),
          'met2': (69, 20), 'met2pin': (69, 16), 'met2lab': (69, 5)}

# horizontal met2 tracks: band L (below N row), M (between rows), U (above P row)
LOWER = {'tail': -0.6, 'P': -1.1, 'Q': -1.6, 'OUTN': -2.1, 'OUTP': -2.6,
         'm1': -3.1, 'm2': -3.6, 'QP': -4.1, 'QN': -4.6, 'VGND': -5.1}
MID = {'CLK': 2.3, 'INP': 2.8, 'INN': 3.3, 'OUTN': 3.8, 'OUTP': 4.3, 'QN': 4.8, 'QP': 5.3}
UPPER = {'P': 8.8, 'Q': 9.3, 'OUTN': 9.8, 'OUTP': 10.3, 'QP': 10.8, 'QN': 11.3, 'VPWR': 11.8}
BANDS = {'L': LOWER, 'M': MID, 'U': UPPER}
tracks = {}

def tr(band, net):
    key = (band, net)
    if key not in tracks:
        tracks[key] = {'y': BANDS[band][net], 'xs': []}
    return tracks[key]

def via_at(x, band, net):
    ty = BANDS[band][net]
    R('via', x - 0.075, ty - 0.075, x + 0.075, ty + 0.075, net)
    R('met2', x - 0.16, ty - 0.16, x + 0.16, ty + 0.16, net)
    tr(band, net)['xs'].append(x)

def contact(xc, yc, net, kind):
    R('licon', xc - 0.085, yc - 0.085, xc + 0.085, yc + 0.085, net)
    R('li', xc - 0.165, yc - 0.165, xc + 0.165, yc + 0.165, net)
    R('mcon', xc - 0.085, yc - 0.085, xc + 0.085, yc + 0.085, net)
    R('met1', xc - 0.145, yc - 0.145, xc + 0.145, yc + 0.145, net)
    if kind == 'poly':
        R('npc', xc - 0.185, yc - 0.185, xc + 0.185, yc + 0.185)

def route(xc, yc, net, band):
    ty = BANDS[band][net]
    R("met1", xc - 0.16, min(yc, ty) - 0.16, xc + 0.16, max(yc, ty) + 0.16, net)
    via_at(xc, band, net)

def mos(nf, x0, yb, regions, gate, gfin, row):
    W = 0.95 + 0.55 * (nf - 1)
    up = (row == 'N')
    R('diff', x0, yb, x0 + W, yb + 1.0)
    if up:
        R('nsdm', x0 - 0.125, yb - 0.125, x0 + W + 0.125, yb + 1.125)
    else:
        R('psdm', x0 - 0.125, yb - 0.125, x0 + W + 0.125, yb + 1.125)
    gl = [x0 + 0.4 + 0.55 * k for k in range(nf)]
    for g in gl:
        if up:
            R('poly', g, yb - 0.13, g + 0.15, yb + 1.13, gate)
        else:
            R('poly', g, yb - 1.13, g + 0.15, yb + 1.13, gate)
    bx0, bx1 = gl[0] - 0.225, gl[-1] + 0.15 + 0.225
    if up:
        R('poly', bx0, yb + 1.13, bx1, yb + 1.6, gate)
        gy = yb + 1.36
    else:
        R('poly', bx0, yb - 1.6, bx1, yb - 1.13, gate)
        gy = yb - 1.36
    gx = gl[gfin] + 0.075
    contact(gx, gy, gate, 'poly')
    route(gx, gy, gate, 'M')
    for j in range(nf + 1):
        l = x0 if j == 0 else gl[j - 1] + 0.15
        r = x0 + W if j == nf else gl[j]
        cx = (l + r) / 2
        sy = yb + 0.5
        contact(cx, sy, regions[j], 'diff')
        route(cx, sy, regions[j], 'L' if up else 'U')

def tap_n(xc, yc, net):  # p+ tap (ptap) for NMOS body or n+ tap (ntap)
    pass

# ---------------- rows ----------------
Ny = 0.0
Py = 7.2
# NMOS row (x0 = left edge of diffusion)
mos(1, -8.05, Ny, ['VGND', 'm1'], 'QN', 0, 'N')     # MN12
mos(1, -6.5, Ny, ['m1', 'QP'], 'OUTN', 0, 'N')      # MN11
mos(1, -4.95, Ny, ['P', 'OUTN'], 'OUTP', 0, 'N')    # M3
mos(2, -3.4, Ny, ['P', 'tail', 'P'], 'INP', 0, 'N') # M1 (2 fingers)
mos(4, -1.3, Ny, ['tail', 'VGND', 'tail', 'VGND', 'tail'], 'CLK', 0, 'N')  # M0 (4 fingers)
mos(2, 1.9, Ny, ['Q', 'tail', 'Q'], 'INN', 1, 'N')  # M2 (2 fingers)
mos(1, 4.0, Ny, ['OUTP', 'Q'], 'OUTN', 0, 'N')      # M4
mos(1, 5.55, Ny, ['QN', 'm2'], 'OUTP', 0, 'N')      # MN21
mos(1, 7.1, Ny, ['m2', 'VGND'], 'QP', 0, 'N')       # MN22

# PMOS row
mos(1, -7.45, Py, ['VPWR', 'QP'], 'QN', 0, 'P')     # MP12
mos(1, -5.9, Py, ['VPWR', 'QP'], 'OUTN', 0, 'P')    # MP11
mos(1, -4.35, Py, ['VPWR', 'OUTN'], 'CLK', 0, 'P')  # M7
mos(1, -2.8, Py, ['VPWR', 'OUTN'], 'OUTP', 0, 'P')  # M5
mos(1, -1.25, Py, ['P', 'VPWR'], 'CLK', 0, 'P')     # M9
mos(1, 0.3, Py, ['VPWR', 'Q'], 'CLK', 0, 'P')       # M10
mos(1, 1.85, Py, ['OUTP', 'VPWR'], 'OUTN', 0, 'P')  # M6
mos(1, 3.4, Py, ['OUTP', 'VPWR'], 'CLK', 0, 'P')    # M8
mos(1, 4.95, Py, ['QN', 'VPWR'], 'OUTP', 0, 'P')    # MP21
mos(1, 6.5, Py, ['QN', 'VPWR'], 'QP', 0, 'P')       # MP22

# ---------------- taps, wells ----------------
R('tap', -9.375, 0.25, -8.875, 0.75)
R('psdm', -9.5, 0.125, -8.75, 0.875)
contact(-9.125, 0.5, 'VGND', 'diff'); route(-9.125, 0.5, 'VGND', 'L')
R('tap', 8.875, 0.25, 9.375, 0.75)
R('psdm', 8.75, 0.125, 9.5, 0.875)
contact(9.125, 0.5, 'VGND', 'diff'); route(9.125, 0.5, 'VGND', 'L')
R('tap', -8.775, Py + 0.25, -8.275, Py + 0.75)
R('nsdm', -8.9, Py + 0.125, -8.15, Py + 0.875)
contact(-8.525, Py + 0.5, 'VPWR', 'diff'); route(-8.525, Py + 0.5, 'VPWR', 'U')
R('tap', 8.275, Py + 0.25, 8.775, Py + 0.75)
R('nsdm', 8.15, Py + 0.125, 8.9, Py + 0.875)
contact(8.525, Py + 0.5, 'VPWR', 'diff'); route(8.525, Py + 0.5, 'VPWR', 'U')
R('nwell', -9.1, Py - 0.3, 9.1, Py + 1.3)

# ---------------- body bus columns (left of cell) ----------------
XB = {'P': -9.6, 'Q': -10.1, 'OUTN': -10.6, 'OUTP': -11.1, 'QP': -11.6, 'QN': -12.1}
for n, x in XB.items():
    ys = []
    for band, dct in (('L', LOWER), ('M', MID), ('U', UPPER)):
        if n in dct:
            via_at(x, band, n)
            ys.append(dct[n])
    R("met1", x - 0.16, min(ys) - 0.16, x + 0.16, max(ys) + 0.16, n)

# ---------------- tracks ----------------
for (band, net), t in tracks.items():
    R('met2', min(t['xs']) - 0.16, t['y'] - 0.07, max(t['xs']) + 0.16, t['y'] + 0.07, net)

# ---------------- labels and pins ----------------
def label_net(net, band, x=None):
    t = tracks[(band, net)]
    xx = t['xs'][0] if x is None else x
    texts.append(('met2lab', net, xx, t['y']))

for net, band in [('tail', 'L'), ('P', 'L'), ('Q', 'L'), ('OUTN', 'U'), ('OUTP', 'U'),
                  ('m1', 'L'), ('m2', 'L'), ('QP', 'U'), ('QN', 'U'), ('CLK', 'M'),
                  ('INP', 'M'), ('INN', 'M'), ('VGND', 'L'), ('VPWR', 'U')]:
    label_net(net, band)

PINS = [('VGND', 'L', -9.125), ('VPWR', 'U', -8.525), ('CLK', 'M', -3.875),
        ('INP', 'M', -2.925), ('INN', 'M', 2.925), ('QP', 'U', -11.6), ('QN', 'U', -12.1)]
for net, band, x in PINS:
    ty = BANDS[band][net]
    R('met2pin', x - 0.1, ty - 0.1, x + 0.1, ty + 0.1, net)
    texts.append(('met2pin', net, x, ty))
    texts.append(('met2lab', net, x, ty))

# ---------------- write GDS ----------------
ly = kdb.Layout()
ly.dbu = 0.001
top = ly.create_cell('comp_latch')
lidx = {k: ly.layer(*v) for k, v in LAYERS.items()}
def I(v):
    return int(round(v * 1000))
for lay, x0, y0, x1, y1, net in shapes:
    top.shapes(lidx[lay]).insert(kdb.Box(I(x0), I(y0), I(x1), I(y1)))
for lay, text, x, y in texts:
    top.shapes(lidx[lay]).insert(kdb.Text(text, kdb.Trans(I(x), I(y))))
ly.write(OUT)

# ---------------- simple short / spacing check ----------------
SP = {'met1': 0.14, 'met2': 0.14, 'li': 0.17}
bad = 0
for lay, sp in SP.items():
    S = [s for s in shapes if s[0] == lay and s[5] is not None]
    for a, b in itertools.combinations(S, 2):
        if a[5] == b[5]:
            continue
        dx = max(b[1] - a[3], a[1] - b[3], 0)
        dy = max(b[2] - a[4], a[2] - b[4], 0)
        d = math.hypot(dx, dy)
        if d < sp - 1e-9:
            bad += 1
            if bad < 40:
                print('CONFLICT', lay, a[5], b[5], [round(v, 3) for v in a[1:5]], [round(v, 3) for v in b[1:5]], 'gap', round(d, 3))
print('conflicts:', bad, 'shapes:', len(shapes))
