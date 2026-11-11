import itertools, sys
import klayout.db as kdb
import gen

W = gen.W
XG = gen.XG
LEVELS = gen.LEVELS
TRACK_NETS = gen.TRACK_NETS
COLS = gen.COLS
GATE_PAD = gen.GATE_PAD
GATE_NET = gen.GATE_NET
NMOS_W = gen.NMOS_W
PMOS_W = gen.PMOS_W
YN, YP = 0.71, 1.96


def ivals(entry, lv):
    """entry: (net, kind, layer). returns (met1_interval or None, li_interval, track_level or None)."""
    net, kind, layer = entry
    yc = YN if kind == 'n' else YP
    if net in ('VGND', 'VPWR'):
        m1 = (0.0, 0.795) if net == 'VGND' else (1.875, 2.89)
        li = (yc - 0.085, yc + 0.085)
        return m1, li, None
    if net == 'SUM':
        return (0.565, 2.105), (yc - 0.085, yc + 0.085), None
    l = lv[net]
    if layer == 'm':
        m1 = (min(yc - 0.145, l - 0.16), max(yc + 0.145, l + 0.16))
        li = (yc - 0.085, yc + 0.085)
    else:
        m1 = (l - 0.16, l + 0.16)
        li = (min(yc, l) - 0.085, max(yc, l) + 0.085)
    return m1, li, l


def conflict(a, b, sp):
    return not (b[0] - a[1] >= sp - 1e-9 or a[0] - b[1] >= sp - 1e-9)


def col_options(c, lv):
    nm0, pm0 = COLS[c]
    res = []
    orders = [(0, 0)] if c in gen.FIXED else [(a, b) for a in (0, 1) for b in (0, 1)]
    for sn, sp in orders:
        nm = nm0 if sn == 0 else (nm0[1], nm0[0])
        pm = pm0 if sp == 0 else (pm0[1], pm0[0])
        for ln in ((0, 1) for _ in range(2)):
            pass
        # layer choices per side for nmos and pmos
        lay_choices = []
        for s in (0, 1):
            for kind, net in (('n', nm[s]), ('p', pm[s])):
                lay_choices.append(['m'] if net in ('VGND', 'VPWR', 'SUM') else ['m', 'l'])
        for lays in itertools.product(*lay_choices):
            ents = []
            i = 0
            for s in (0, 1):
                ents.append(('nside', s, (nm[s], 'n', lays[i]))); i += 1
                ents.append(('pside', s, (pm[s], 'p', lays[i]))); i += 1
            ok = True
            for s in (0, 1):
                ne = ents[2 * s][2]; pe = ents[2 * s + 1][2]
                if ne[0] == pe[0]:
                    continue
                m_n, li_n, _ = ivals(ne, lv); m_p, li_p, _ = ivals(pe, lv)
                if conflict(m_n, m_p, 0.14) or conflict(li_n, li_p, 0.17):
                    ok = False; break
            if ok:
                res.append((nm, pm, {(s, k): e for (_, s, e) in ents for k in [e[1]]}))
    return res


def via_list(sol, lv):
    out = []
    for c, (nm, pm, ents) in sol.items():
        for s in (0, 1):
            x = XG[c] + (-0.25 if s == 0 else 0.25)
            for kind in ('n', 'p'):
                net, _, layer = ents[(s, kind)]
                if net in lv:
                    out.append((x, net, lv[net]))
    out.append((7.2, 'n1', lv['n1']))
    out.append((10.0, 'n3', lv['n3']))
    return out


def vias_ok(sol, lv):
    vl = via_list(sol, lv)
    for i in range(len(vl)):
        for j in range(i + 1, len(vl)):
            x1, n1_, l1 = vl[i]; x2, n2_, l2 = vl[j]
            if n1_ == n2_:
                continue
            if abs(x1 - x2) < 0.46 and abs(l1 - l2) < 0.68 - 1e-6:
                return False
    return True


def search():
    for perm in itertools.permutations(LEVELS, len(TRACK_NETS)):
        lv = dict(zip(TRACK_NETS, perm))
        opts = {}
        for c in range(7):
            o = col_options(c, lv)
            if not o:
                break
            opts[c] = o
        else:
            for combo in itertools.product(*[opts[c] for c in range(7)]):
                sol = {c: combo[c] for c in range(7)}
                if vias_ok(sol, lv):
                    return lv, sol
    return None, None


if __name__ == '__main__':
    lv, sol = search()
    if lv is None:
        print('NO SOLUTION'); sys.exit(1)
    print('levels', lv)
    for c in range(7):
        print('col', c, sol[c][0], sol[c][1], {k: v[2] for k, v in sol[c][2].items()})
