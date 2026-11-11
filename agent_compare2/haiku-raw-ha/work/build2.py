import sys
import klayout.db as kdb
import gen, gen2

W = gen.W
XG = gen.XG
YN, YP = gen2.YN, gen2.YP
GATE_PAD = gen.GATE_PAD
GATE_NET = gen.GATE_NET


def build(lv, sol, path):
    ly = kdb.Layout(); ly.dbu = 0.001
    top = ly.create_cell('ha')
    LAY = dict(nwell=(64, 20), diff=(65, 20), tap=(65, 44), poly=(66, 20), licon=(66, 44),
               npc=(95, 20), nsdm=(93, 44), psdm=(94, 20), li=(67, 20), mcon=(67, 44),
               met1=(68, 20), via=(68, 44), met2=(69, 20), met1l=(68, 5), met1p=(68, 16))
    L = {k: ly.layer(*v) for k, v in LAY.items()}
    r = lambda v: int(round(v * 1000))

    def box(k, x0, y0, x1, y1):
        top.shapes(L[k]).insert(kdb.Box(r(x0), r(y0), r(x1), r(y1)))

    def text(k, s, x, y):
        top.shapes(L[k]).insert(kdb.Text(s, kdb.Trans(r(x), r(y))))

    def sq(k, x, y, h):   # square-ish helper for contact-size shapes
        box(k, x - h, y - h, x + h, y + h)

    vias = {n: [] for n in gen2.TRACK_NETS}

    def contact_pad(x, yc):
        box('licon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)

    # rails
    box('met1', 0, -0.17, W, 0.17); box('met1p', 0, -0.17, W, 0.17)
    text('met1l', 'VGND', 1.0, 0.0); text('met1p', 'VGND', 1.0, 0.0)
    box('met1', 0, 2.55, W, 2.89); box('met1p', 0, 2.55, W, 2.89)
    text('met1l', 'VPWR', 1.0, 2.72); text('met1p', 'VPWR', 1.0, 2.72)
    # well, taps
    box('nwell', 0, 1.57, W, 3.025)
    box('tap', 2.8, -0.125, 3.2, 0.125); box('diff', 2.8, -0.125, 3.2, 0.125)
    box('psdm', 2.675, -0.25, 3.325, 0.25)
    contact_pad(3.0, 0.0); box('li', 2.835, -0.085, 3.165, 0.085); box('mcon', 2.915, -0.085, 3.085, 0.085)
    box('tap', 10.05, 2.595, 10.30, 2.845); box('diff', 10.05, 2.595, 10.30, 2.845)
    box('nsdm', 9.925, 2.47, 10.425, 2.97)
    contact_pad(10.175, 2.72); box('li', 10.01, 2.635, 10.34, 2.805); box('mcon', 10.09, 2.635, 10.26, 2.805)

    for c in range(7):
        xg = XG[c]
        nm, pm, ents = sol[c]
        wn = gen.NMOS_W.get(c, 0.42); ntop = 0.50 + wn
        box('diff', xg - 0.4, 0.50, xg + 0.4, ntop)
        box('nsdm', xg - 0.525, 0.375, xg + 0.525, ntop + 0.125)
        wp = gen.PMOS_W.get(c, 0.42); ptop = 1.75 + wp
        box('diff', xg - 0.4, 1.75, xg + 0.4, ptop)
        box('psdm', xg - 0.525, 1.625, xg + 0.525, ptop + 0.125)
        box('poly', xg - 0.075, 0.37, xg + 0.075, 2.63)
        for s in (0, 1):
            x = xg + (-0.25 if s == 0 else 0.25)
            for kind in ('n', 'p'):
                net, _, layer = ents[(s, kind)]
                yc = YN if kind == 'n' else YP
                contact_pad(x, yc)
                if net in ('VGND', 'VPWR'):
                    box('li', x - 0.165, yc - 0.085, x + 0.165, yc + 0.085)
                    box('mcon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)
                    m1 = (0.0, 0.795) if net == 'VGND' else (1.875, 2.89)
                    box('met1', x - 0.13, m1[0], x + 0.13, m1[1])
                    continue
                if net == 'SUM':
                    box('li', x - 0.165, yc - 0.085, x + 0.165, yc + 0.085)
                    box('mcon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)
                    box('met1', x - 0.13, 0.625, x + 0.13, 2.045)
                    continue
                lvl = lv[net]
                m1, li, _ = gen2.ivals((net, kind, layer), lv)
                if layer == 'm':
                    box('li', x - 0.165, yc - 0.085, x + 0.165, yc + 0.085)
                    box('mcon', x - 0.085, yc - 0.085, x + 0.085, yc + 0.085)
                    box('met1', x - 0.13, m1[0], x + 0.13, m1[1])
                else:
                    box('li', x - 0.085, li[0], x + 0.085, li[1])
                    box('mcon', x - 0.085, lvl - 0.085, x + 0.085, lvl + 0.085)
                    box('met1', x - 0.13, lvl - 0.16, x + 0.13, lvl + 0.16)
                box('via', x - 0.075, lvl - 0.075, x + 0.075, lvl + 0.075)
                box('met2', x - 0.16, lvl - 0.13, x + 0.16, lvl + 0.13)
                vias[net].append((x, lvl))

    # gate groups
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
            box('met1', xp - 0.13, min(1.125, l - 0.16), xp + 0.13, max(1.445, l + 0.16))
            box('via', xp - 0.075, l - 0.075, xp + 0.075, l + 0.075)
            box('met2', xp - 0.16, l - 0.13, xp + 0.16, l + 0.13)
            vias[net].append((xp, l))

    for net, pts in vias.items():
        l = lv[net]
        xs = [x for x, _ in pts]
        box('met2', min(xs) - 0.16, l - 0.07, max(xs) + 0.16, l + 0.07)

    x, l = vias['COUT'][0]
    box('met1p', x - 0.13, l - 0.16, x + 0.13, l + 0.16)
    text('met1l', 'COUT', x, l); text('met1p', 'COUT', x, l)
    box('met1p', 9.42, 1.125, 9.68, 1.445)
    text('met1l', 'SUM', 9.55, 1.285); text('met1p', 'SUM', 9.55, 1.285)
    ly.write(path)


if __name__ == '__main__':
    lv, sol = gen2.search()
    print('levels', lv)
    build(lv, sol, sys.argv[1])
    print('written', sys.argv[1])
