import itertools, gen
from search2 import col_states
import collections
best = collections.Counter()
bestlv = {}
for levs in itertools.product(gen.LEVELS, repeat=6):
    lv = dict(zip(gen.TRACK_NETS, levs))
    feas = tuple(bool(col_states(c, lv)) for c in range(7))
    k = sum(feas)
    best[k] += 1
    if k >= 6 and k not in bestlv:
        bestlv[k] = (lv, feas)
print(best)
for k in sorted(bestlv):
    print(k, bestlv[k])
