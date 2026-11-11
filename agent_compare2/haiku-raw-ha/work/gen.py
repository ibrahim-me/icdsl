import itertools, sys
import klayout.db as kdb

W = 11.04
XG = [0.9 + 1.4 * c for c in range(7)]
LEVELS = [0.47, 0.81, 1.15, 1.49, 1.83, 2.17]
TRACK_NETS = ['n1', 'n2', 'n3', 'n4', 'n5', 'COUT']
# (nmos (L,R), pmos (L,R)) per column, before optional L/R flips (columns 0..5)
COLS = [
    (('n4', 'VGND'), ('n1', 'VPWR')),
    (('n2', 'VGND'), ('n5', 'VPWR')),
    (('n1', 'n2'), ('n3', 'n5')),
    (('n4', 'VGND'), ('VPWR', 'n1')),
    (('n3', 'n4'), ('VPWR', 'COUT')),
    (('VGND', 'COUT'), ('VPWR', 'n3')),
    (('VGND', 'SUM'), ('VPWR', 'SUM')),   # fixed
]
FIXED = {6}
GATE_PAD = {0: 1.6, 2: 4.4, 4: 7.2, 6: 10.0}   # first column of each gate group
GATE_NET = {0: 'A', 2: 'B', 4: 'n1', 6: 'n3'}
NMOS_W = {5: 0.49, 6: 0.49}
PMOS_W = {4: 0.75, 6: 0.75}


def ivl(net, kind, lvl):
    if net == 'VGND':
        return (0.0, 0.795) if kind == 'n' else None
    if net == 'VPWR':
        return (1.875, 2.89) if kind == 'p' else None
    if net == 'SUM':
        return (0.625, 2.045)
    if kind == 'n':
        return (min(0.625, lvl - 0.16), max(0.795, lvl + 0.16))
    return (min(1.875, lvl - 0.16), max(2.045, lvl + 0.16))


def ok_pair(a, b):
    return b[0] - a[1] >= 0.14 - 1e-9 or a[0] - b[1] >= 0.14 - 1e-9


def column_state(c, lv):
    nm0, pm0 = COLS[c]
    opts = [(0, 0)] if c in FIXED else [(a, b) for a in (0, 1) for b in (0, 1)]
    for sn, sp in opts:
        nm = nm0 if sn == 0 else (nm0[1], nm0[0])
        pm = pm0 if sp == 0 else (pm0[1], pm0[0])
        good = True
        for s in (0, 1):
            n, p = nm[s], pm[s]
            if n == p:
                continue
            ia = ivl(n, 'n', lv.get(n, 0)) if n in lv or n in ('VGND',) else None
            ib = ivl(p, 'p', lv.get(p, 0)) if p in lv or p in ('VPWR',) else None
            if n == 'SUM' or p == 'SUM':
                ia = ivl(n, 'n', 0); ib = ivl(p, 'p', 0)
            if ia is None or ib is None:
                continue
            if not ok_pair(ia, ib):
                good = False
                break
        if good:
            return (nm, pm)
    return None


def search():
    for perm in itertools.permutations(LEVELS, len(TRACK_NETS)):
        lv = dict(zip(TRACK_NETS, perm))
        states = {}
        for c in range(7):
            st = column_state(c, lv)
            if st is None:
                break
            states[c] = st
        else:
            return lv, states
    return None, None


def build(lv, states, path):
    ly = kdb.Layout()
    ly.dbu = 0.001
    top = ly.create_cell('ha')
    LAY = dict(nwell=(64, 20), diff=(65, 20), tap=(65, 44), poly=(66, 20), licon=(66, 44),
               npc=(95, 20), nsdm=(93, 44), psdm=(94, 20), li=(67, 20), mcon=(67, 44),
               met1=(68, 20), via=(68, 44), met2=(69, 20), met1l=(68, 5), met1p=(68, 16))
    L = {k: ly.layer(*v) for k, v in LAY.items()}

    def r(v):
        return int(round(v * 1000))

    def box(k, x0, y0, x1, y1):
        top.shapes(L[k]).insert(kdb.Box(r(x0), r(y0), r(x1), r(y1)))

    def text(k, s, x, y):
        top.shapes(L[k]).insert(kdb.Text(s, kdb.Trans(r(x), r(y))))

    def contact(x, yc):
        box('licon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)
        box('li', x - 0.165, yc - 0.085, x + 0.165, yc + 0.085)
        box('mcon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)

    vias = {n: [] for n in TRACK_NETS}

    def via_stub(net, x, lo, hi, lvl):
        box('met1', x - 0.13, lo, x + 0.13, hi)
        box('via', x - 0.075, lvl - 0.075, x + 0.075, lvl + 0.075)
        box('met2', x - 0.16, lvl - 0.13, x + 0.16, lvl + 0.13)
        vias[net].append((x, lvl))

    # rails
    box('met1', 0, -0.17, W, 0.17)
    box('met1p', 0, -0.17, W, 0.17)
    text('met1l', 'VGND', 1.0, 0.0); text('met1p', 'VGND', 1.0, 0.0)
    box('met1', 0, 2.55, W, 2.89)
    box('met1p', 0, 2.55, W, 2.89)
    text('met1l', 'VPWR', 1.0, 2.72); text('met1p', 'VPWR', 1.0, 2.72)

    # n-well and taps
    box('nwell', 0, 1.57, W, 3.025)
    box('tap', 2.8, -0.125, 3.2, 0.125); box('diff', 2.8, -0.125, 3.2, 0.125)
    box('psdm', 2.675, -0.25, 3.325, 0.25)
    contact(3.0, 0.0)
    box('tap', 10.05, 2.595, 10.30, 2.845); box('diff', 10.05, 2.595, 10.30, 2.845)
    box('nsdm', 9.925, 2.47, 10.425, 2.97)
    contact(10.175, 2.72)

    for c in range(7):
        xg = XG[c]
        nm, pm = states[c]
        wn = NMOS_W.get(c, 0.42); ntop = 0.50 + wn
        box('diff', xg - 0.4, 0.50, xg + 0.4, ntop)
        box('nsdm', xg - 0.525, 0.375, xg + 0.525, ntop + 0.125)
        wp = PMOS_W.get(c, 0.42); ptop = 1.75 + wp
        box('diff', xg - 0.4, 1.75, xg + 0.4, ptop)
        box('psdm', xg - 0.525, 1.625, xg + 0.525, ptop + 0.125)
        box('poly', xg - 0.075, 0.37, xg + 0.075, 2.63)
        for s in (0, 1):
            x = xg + (-0.25 if s == 0 else 0.25)
            n, p = nm[s], pm[s]
            contact(x, 0.71)
            contact(x, 1.96)
            # nmos stub
            if n == 'VGND':
                box('met1', x - 0.13, 0.0, x + 0.13, 0.795)
            elif n == 'SUM':
                box('met1', x - 0.13, 0.625, x + 0.13, 2.045)
            else:
                ia = ivl(n, 'n', lv[n])
                via_stub(n, x, ia[0], ia[1], lv[n])
            # pmos stub
            if p == 'VPWR':
                box('met1', x - 0.13, 1.875, x + 0.13, 2.89)
            elif p == 'SUM':
                pass
            else:
                ib = ivl(p, 'p', lv[p])
                if p == n:
                    pass
                else:
                    via_stub(p, x, ib[0], ib[1], lv[p])

    # gate groups: poly bar, pad, contact
    bars = {0: (0.825, 2.375), 2: (3.625, 5.175), 4: (6.425, 7.975), 6: (8.6, 9.375)}
    for c, xp in GATE_PAD.items():
        x0, x1 = bars[c]
        box('poly', x0, 1.2075, x1, 1.3625)
        box('poly', xp - 0.185, 1.10, xp + 0.185, 1.47)
        box('npc', xp - 0.185, 1.10, xp + 0.185, 1.47)
        box('licon', xp - 0.085, 1.20, xp + 0.085, 1.37)
        box('li', xp - 0.165, 1.20, xp + 0.165, 1.37)
        box('mcon', xp - 0.085, 1.20, xp + 0.085, 1.37)
        net = GATE_NET[c]
        if net in ('A', 'B'):
            box('met1', xp - 0.13, 1.125, xp + 0.13, 1.445)
            box('met1p', xp - 0.13, 1.125, xp + 0.13, 1.445)
            text('met1l', net, xp, 1.285); text('met1p', net, xp, 1.285)
        else:
            l = lv[net]
            via_stub(net, xp, min(1.125, l - 0.16), max(1.445, l + 0.16), l)

    # tracks
    for net, pts in vias.items():
        if not pts:
            continue
        l = lv[net]
        xs = [x for x, _ in pts]
        box('met2', min(xs) - 0.16, l - 0.07, max(xs) + 0.16, l + 0.07)
    # pins for signal nets on track (COUT) and SUM
    x, l = vias['COUT'][0]
    box('met1p', x - 0.13, l - 0.16, x + 0.13, l + 0.16)
    text('met1l', 'COUT', x, l); text('met1p', 'COUT', x, l)
    box('met1p', 9.42, 1.125, 9.68, 1.445)
    text('met1l', 'SUM', 9.55, 1.285); text('met1p', 'SUM', 9.55, 1.285)

    ly.write(path)
    return ly


if __name__ == '__main__':
    lv, states = search()
    if lv is None:
        print('NO SOLUTION'); sys.exit(1)
    print('levels', lv)
    for c in range(7):
        print('col', c, 'nmos', states[c][0], 'pmos', states[c][1])
    build(lv, states, sys.argv[1])
    print('written', sys.argv[1])
