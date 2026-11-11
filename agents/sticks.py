"""Algorithmic first draft for a level-1 standard cell (a starting point, not a constraint).

From the transistor netlist it builds a stick diagram - one poly column per gate, n devices in a
row above the p-tap, p devices in a row below the n-tap - choosing the gate order and device
orientations that let neighbours share diffusion (fewest diffusion breaks, then fewest nets that
need routing). It then writes an ordinary, fully editable ICL `stdcell` using only the level-1
verbs (rect / enclose / array / contact / strap / route / well / port), with every position
derived from the parameters WN.., WP.., L and H.

    python agents/sticks.py nand3            # print the draft for one benchmark cell
"""
from __future__ import annotations

import itertools
import json
import math
import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SUPPLY = {"VPWR", "VGND"}
NEED = {"c": 0.28, "u": 0.21, "b": 0.80}   # min L-to-L gap: contact / uncontacted node / diffusion break
PAD_PITCH = 0.54                            # gate-contact poly pads (0.33) + poly spacing (0.21)


def _chain(slots):
    """Orient devices in one row to share as many diffusion nodes as possible.

    slots: list of device dicts or None. Returns (breaks, orient list of (left_net, right_net) or None)."""
    INF = 10 ** 9
    n = len(slots)
    # dp[i][o] = (cost, prev_o)
    dp = [dict() for _ in range(n)]
    for i, d in enumerate(slots):
        opts = [None] if d is None else [(d["s"], d["d"]), (d["d"], d["s"])]
        for o in opts:
            best = (INF, None)
            if i == 0:
                best = (0, None)
            else:
                for po, (pc, _) in dp[i - 1].items():
                    shared = (o is not None and po is not None and po[1] == o[0]
                              and slots[i - 1]["wparam"] == d["wparam"])
                    c = pc + (0 if shared else 1)
                    if c < best[0]:
                        best = (c, po)
            dp[i][o] = best
    o = min(dp[-1], key=lambda k: dp[-1][k][0])
    cost = dp[-1][o][0]
    orient = [None] * n
    for i in range(n - 1, -1, -1):
        orient[i] = o
        o = dp[i][o][1]
    return cost, orient


def _rows(order, orient_n, orient_p, cols):
    """Per row: list of islands (start col, end col, wparam) and node list."""
    out = {}
    for row, orient in (("n", orient_n), ("p", orient_p)):
        isl, nodes = [], []           # nodes: (gap index -1..k-1 between col i and i+1, net, kind)
        cur = None
        for i, ci in enumerate(order):
            d = cols[ci][row]
            o = orient[i]
            if d is None:
                if cur:
                    isl.append(cur)
                    cur = None
                continue
            if cur and orient[i - 1] is not None and orient[i - 1][1] == o[0] and \
                    cols[order[i - 1]][row]["wparam"] == d["wparam"]:
                cur[1] = i
                nodes.append((i - 1, o[0], "shared"))
            else:
                if cur:
                    isl.append(cur)
                    nodes.append((cur[1], orient[cur[1]][1], "end_r"))
                cur = [i, i, d["wparam"]]
                nodes.append((i - 1, o[0], "end_l"))
        if cur:
            isl.append(cur)
            nodes.append((cur[1], orient[cur[1]][1], "end_r"))
        out[row] = (isl, nodes)
    return out


def plan(cell):
    devs = cell["devices"]
    by_g = defaultdict(lambda: {"nmos": [], "pmos": []})
    for d in devs:
        by_g[d["g"]][d["kind"]].append(d)
    gates = list(by_g)
    # pairing alternatives for gate nets that drive several devices
    pairings = []
    for g in gates:
        ns, ps = by_g[g]["nmos"], by_g[g]["pmos"]
        alts = []
        for perm in itertools.permutations(range(len(ps))):
            cols = []
            for i in range(max(len(ns), len(ps))):
                cols.append({"g": g, "n": ns[i] if i < len(ns) else None,
                             "p": ps[perm[i]] if i < len(ps) and i < len(perm) else (ps[i] if i < len(ps) else None)})
            alts.append(cols)
        pairings.append(alts[:6])
    term = defaultdict(int)          # source/drain terminal count per net
    for d in devs:
        term[d["d"]] += 1
        term[d["s"]] += 1
    gate_nets = {d["g"] for d in devs}
    ports = set(cell["inputs"]) | set(cell["outputs"])
    best = None
    for combo in itertools.product(*pairings):
        cols = [c for group in combo for c in group]
        k = len(cols)
        perms = itertools.permutations(range(k)) if k <= 7 else [tuple(range(k))]
        for order in perms:
            bn, on = _chain([cols[i]["n"] for i in order])
            bp, op = _chain([cols[i]["p"] for i in order])
            rows = _rows(order, on, op, cols)
            contacted = defaultdict(int)
            for row in ("n", "p"):
                for (gi, net, kind) in rows[row][1]:
                    if kind != "shared" or net in SUPPLY or net in ports or net in gate_nets or term[net] > 2:
                        contacted[net] += 1
            routes = sum(max(0, v - 1) for n, v in contacted.items() if n not in SUPPLY)
            routes += sum(1 for g in gate_nets if g in contacted)          # internal gate nets
            cost = 100 * (bn + bp) + 10 * routes
            if best is None or cost < best[0]:
                best = (cost, order, on, op, cols, rows)
    cost, order, on, op, cols, rows = best
    return {"cols": [cols[i] for i in order], "orient": {"n": on, "p": op}, "rows": rows,
            "term": dict(term), "gate_nets": gate_nets, "ports": ports, "cost": cost}


def draft_file(cell, P=None):
    P = P or plan(cell)
    cols, rows = P["cols"], P["rows"]
    k = len(cols)
    term, gate_nets, ports = P["term"], P["gate_nets"], P["ports"]

    def needs_contact(net, kind):
        return kind != "shared" or net in SUPPLY or net in ports or net in gate_nets or term.get(net, 0) > 2

    # gap requirements
    gap_need = []
    for i in range(k - 1):
        need = 0.21
        for row in ("n", "p"):
            isl, nodes = rows[row]
            inside = any(a <= i and i + 1 <= b for (a, b, w) in isl)
            touches = any(a <= i <= b for (a, b, w) in isl) and any(a <= i + 1 <= b for (a, b, w) in isl)
            if inside:
                nd = [x for x in nodes if x[0] == i and x[2] == "shared"]
                need = max(need, NEED["c"] if nd and needs_contact(nd[0][1], "shared") else NEED["u"])
            elif touches or any(a <= i <= b for (a, b, w) in isl) and any(a <= i + 1 <= b for (a, b, w) in isl):
                need = max(need, NEED["b"])
            else:
                ends_here = any(b == i for (a, b, w) in isl) or any(a == i + 1 for (a, b, w) in isl)
                if ends_here:
                    need = max(need, 0.265 + 0.075 + 0.05)
        gap_need.append(need)

    def gap_expr(i):
        return f"max({gap_need[i]:.2f}, {PAD_PITCH} - L)"

    # cell width for the worst case L = 0.25
    span25 = 0.53 + k * 0.25 + sum(max(g, PAD_PITCH - 0.25) for g in gap_need)
    width = math.ceil((span25 + 0.7) / 0.46)

    plan_txt = []
    for row in ("p", "n"):
        isl, nodes = rows[row]
        s = []
        for i, c in enumerate(cols):
            left = [x for x in nodes if x[0] == i - 1]
            for (gi, net, kind) in left:
                s.append(net if needs_contact(net, kind) else f"({net})")
            s.append(f"[{c['g']}]" if c[row] else "  .  ")
            right = [x for x in nodes if x[0] == i and x[2] == "end_r"]
            for (gi, net, kind) in right:
                s.append(net)
                s.append("|")
        plan_txt.append(f"#   {row}: " + " ".join(s))
    L = []
    L.append("pdk sky130A")
    L.append("param " + " ".join(f"{p}={v}" for p, v in cell["params"].items()) + " L=0.15 H=2.72")
    L.append("")
    L.append(f"stdcell {cell['name']} width={width} height=H")
    for d in cell["devices"]:
        L.append(f"  device {d['name']} {d['kind']} w={d['wparam']} l=L d={d['d']} g={d['g']} s={d['s']}")
    L.append("")
    L.append(f"  # stick plan (gate order {' '.join(c['g'] for c in cols)}; (net) = series node, no contact; | = break)")
    L += ["  " + t for t in plan_txt]
    L.append("  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)")
    L.append("  py1 = ntap.bottom - 0.27              # top of the p row")
    span = "0.53 + " + f"{k}*L" + "".join(f" + {gap_expr(i)}" for i in range(k - 1))
    L.append(f"  span = {span}")
    L.append("  x0 = cell.cx - span/2")
    for i in range(k):
        left = "x0 + 0.265" if i == 0 else f"g{i}.right + {gap_expr(i - 1)}"
        L.append(f"  g{i + 1} = rect poly w=L left=({left}) yspan=(ny0 - 0.13, py1 + 0.13)   # gate {cols[i]['g']}")
    # islands
    names = {"n": [], "p": []}
    for row in ("n", "p"):
        isl, nodes = rows[row]
        for j, (a, b, wp) in enumerate(isl):
            nm = f"{row}d{j + 1}"
            names[row].append((nm, a, b))
            ys = f"(ny0, ny0 + {wp})" if row == "n" else f"(py1 - {wp}, py1)"
            L.append(f"  {nm} = rect diff xspan=(g{a + 1}.left - 0.265, g{b + 1}.right + 0.265) yspan={ys}")
    L.append(f"  nim = enclose [{', '.join(n for n, a, b in names['n'])}] nsdm")
    L.append(f"  pim = enclose [{', '.join(n for n, a, b in names['p'])}] psdm")
    # contact columns
    strips = defaultdict(list)       # net -> li strip names
    nli = []
    cnt = 0
    for row in ("n", "p"):
        isl, nodes = rows[row]
        for (gi, net, kind) in nodes:
            if not needs_contact(net, kind):
                continue
            cnt += 1
            if kind == "end_l":
                col, side = gi + 1, "left_of"
            else:
                col, side = gi, "right_of"
            isle = next(n for (n, a, b) in names[row] if a <= col <= b)
            c = f"c{cnt}"
            L.append(f"  {c} = array licon in={isle} {side}=g{col + 1}")
            L.append(f"  {c}l = enclose {c} li net={net}")
            strips[net].append(f"{c}l")
            if row == "n":
                nli.append(f"{c}l")
            if net == "VGND":
                L.append(f"  {c}s = strap li from={c}l to=vgnd_li")
            elif net == "VPWR":
                L.append(f"  {c}s = strap li from={c}l to=vpwr_li")
    # gate contacts in the band above the n row
    tops = [f"{n}.top + 0.19" for n, a, b in names["n"]] + [f"{s}.top + 0.25" for s in nli]
    L.append(f"  cb = max({', '.join(tops)})")
    for i, c in enumerate(cols):
        L.append(f"  gc{i + 1} = contact licon cx=g{i + 1}.cx bottom=cb")
        L.append(f"  gp{i + 1} = enclose gc{i + 1} poly by=minx")
        L.append(f"  gl{i + 1} = enclose gc{i + 1} li net={c['g']}")
        strips[c["g"]].append(f"gl{i + 1}")
    L.append(f"  gn = enclose [{', '.join(f'gc{i + 1}' for i in range(k))}] npc")
    pn = [n for n, a, b in names["p"]]
    L.append(f"  well y=((max({', '.join(n + '.top' for n, a, b in names['n'])}) + 0.34 + "
             f"min({', '.join(p + '.bottom' for p in pn)}) - 0.18) / 2)")
    # pins
    for p in cell["inputs"]:
        i = next(i for i, c in enumerate(cols) if c["g"] == p)
        L.append(f"  {p.lower()}m = contact mcon in=gl{i + 1}")
        L.append(f"  {p.lower()}p = enclose {p.lower()}m m1 by=0.06 net={p}")
        L.append(f"  port {p} in on={p.lower()}p")
    for p in cell["outputs"]:
        if len(strips[p]) > 1:
            L.append(f"  port {p} out                       # pin goes on the routed met1 of {p}")
            continue
        s = strips[p][0]
        cy = f"({s}.bottom + 0.2)" if s in nli else f"({s}.top - 0.2)"
        L.append(f"  {p.lower()}m = contact mcon in={s} cy={cy}")
        L.append(f"  {p.lower()}p = enclose {p.lower()}m m1 by=0.06 net={p}")
        L.append(f"  port {p} out on={p.lower()}p")
    multi = [n for n, ss in strips.items() if n not in SUPPLY and (len(ss) > 1)]
    for n in multi:
        L.append(f"  route {n} layers=m1,m2 prefer=m2")
    L.append("end")
    return "\n".join(L) + "\n"


def main():
    spec = json.load(open(os.path.join(ROOT, "bench", "cells.json")))
    names = sys.argv[1:] or [c["name"] for c in spec["cells"]]
    for c in spec["cells"]:
        if c["name"] in names:
            print(draft_file(c))


if __name__ == "__main__":
    main()
