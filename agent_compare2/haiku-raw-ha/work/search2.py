import itertools, gen

def col_states(c, lv):
    nm0, pm0 = gen.COLS[c]
    opts = [(0, 0)] if c in gen.FIXED else [(a, b) for a in (0, 1) for b in (0, 1)]
    out = []
    for sn, sp in opts:
        nm = nm0 if sn == 0 else (nm0[1], nm0[0])
        pm = pm0 if sp == 0 else (pm0[1], pm0[0])
        good = True
        for s in (0, 1):
            n, p = nm[s], pm[s]
            if n == p:
                continue
            ia = gen.ivl(n, 'n', lv.get(n, 0)); ib = gen.ivl(p, 'p', lv.get(p, 0))
            if n == 'SUM' or p == 'SUM':
                continue
            if ia is None or ib is None:
                continue
            if not gen.ok_pair(ia, ib):
                good = False; break
        if good:
            out.append((nm, pm))
    return out

def spans_ok(states, lv):
    xs = {n: [] for n in gen.TRACK_NETS}
    for c, (nm, pm) in states.items():
        for s in (0, 1):
            x = gen.XG[c] + (-0.25 if s == 0 else 0.25)
            for net in (nm[s], pm[s]):
                if net in xs: xs[net].append(x)
    xs['n1'].append(7.2); xs['n3'].append(8.6)
    rng = {n: (min(v) - 0.16, max(v) + 0.16) for n, v in xs.items() if v}
    names = list(rng)
    for a, b in itertools.combinations(names, 2):
        if lv[a] == lv[b]:
            ra, rb = rng[a], rng[b]
            if not (rb[0] - ra[1] >= 0.14 or ra[0] - rb[1] >= 0.14):
                return False
    return True

if __name__ == "__main__":
  pass
found = None
nets = gen.TRACK_NETS
for levs in itertools.product(gen.LEVELS, repeat=len(nets)):
    lv = dict(zip(nets, levs))
    cs = []
    for c in range(7):
        s = col_states(c, lv)
        if not s:
            break
        cs.append(s)
    else:
        for combo in itertools.product(*cs):
            states = {c: combo[c] for c in range(7)}
            if spans_ok(states, lv):
                found = (lv, states); break
        if found:
            break
if found:
    lv, states = found
    print('levels', lv)
    for c in range(7):
        print('col', c, states[c])
else:
    print('none')
