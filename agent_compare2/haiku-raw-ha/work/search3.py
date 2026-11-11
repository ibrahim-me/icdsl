import itertools, sys
import gen, gen2
from gen2 import col_options, XG, TRACK_NETS, LEVELS

def net_xs(sol_items):
    xs = {n: [] for n in TRACK_NETS}
    for c, (nm, pm, ents) in sol_items:
        for s in (0, 1):
            x = XG[c] + (-0.25 if s == 0 else 0.25)
            for kind in ('n', 'p'):
                net, _, layer = ents[(s, kind)]
                if net in xs:
                    xs[net].append(x)
    xs['n1'].append(7.2); xs['n3'].append(10.0)
    return xs

def ok_all(items, lv):
    xs = net_xs(items)
    # via pads at same-ish x for different nets
    pts = []
    for n, v in xs.items():
        for x in v:
            pts.append((x, n))
    # level of each via
    for i in range(len(pts)):
        for j in range(i + 1, len(pts)):
            (x1, n1), (x2, n2) = pts[i], pts[j]
            if n1 != n2 and abs(x1 - x2) < 0.46 and abs(lv[n1] - lv[n2]) < 0.68 - 1e-6:
                return False
    # spans for nets on same level
    rng = {n: (min(v) - 0.16, max(v) + 0.16) for n, v in xs.items() if v}
    names = list(rng)
    for a, b in itertools.combinations(names, 2):
        if abs(lv[a] - lv[b]) < 1e-6:
            ra, rb = rng[a], rng[b]
            if not (rb[0] - ra[1] >= 0.14 or ra[0] - rb[1] >= 0.14):
                return False
    return True

def run():
    for levs in itertools.product(LEVELS, repeat=len(TRACK_NETS)):
        lv = dict(zip(TRACK_NETS, levs))
        opts = []
        for c in range(7):
            o = col_options(c, lv)
            if not o:
                break
            opts.append(o)
        else:
            # backtrack over columns
            def bt(c, chosen):
                if c == 7:
                    return list(chosen)
                for o in opts[c]:
                    chosen.append((c, o))
                    if ok_partial(chosen, lv):
                        r = bt(c + 1, chosen)
                        if r:
                            return r
                    chosen.pop()
                return None
            r = bt(0, [])
            if r:
                return lv, r
    return None, None

def ok_partial(chosen, lv):
    # only the via/span checks among placed columns (spans get rechecked at the end)
    items = [(c, o) for c, o in chosen]
    xs = net_xs(items)
    pts = [(x, n) for n, v in xs.items() for x in v]
    for i in range(len(pts)):
        for j in range(i + 1, len(pts)):
            (x1, n1), (x2, n2) = pts[i], pts[j]
            if n1 != n2 and abs(x1 - x2) < 0.46 and abs(lv[n1] - lv[n2]) < 0.68 - 1e-6:
                return False
    return True

if __name__ == '__main__':
    lv, r = run()
    if lv is None:
        print('NONE'); sys.exit(1)
    items = [(c, o) for c, o in r]
    if not ok_all(items, lv):
        print('span check failed'); sys.exit(1)
    print('levels', lv)
    for c, o in r:
        print('col', c, o[0], o[1], {k: v[2] for k, v in o[2].items()})
