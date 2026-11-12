"""Netlist level: CMOS logic from a transistor netlist, on any PDK that has stick cells.

    from icdsl.canvas.synth import from_spice, stick_auto
    top = from_spice("adder.spice")            # leaf subcircuits -> stick cells, the top -> rows + Router
    nand = stick_auto("nand2", [("nmos", "x", "A", "VSS"), ("nmos", "Y", "B", "x"),
                                ("pmos", "Y", "A", "VDD"), ("pmos", "Y", "B", "VDD")], ports="A B Y")

`stick_auto` chooses the column order and the transistor orientations (fewest diffusion breaks, then
shortest wiring) and calls `stick`. `from_spice` reads a SPICE file or text, builds every transistor-only
subcircuit with `stick_auto`, places the instances of the top subcircuit in rows and routes them with
`Router`. Both are conveniences on top of the canvas: the result is an ordinary Cell that can be placed,
edited and wired like any other, and a cell they cannot build can be drawn by hand next to them.
"""
from __future__ import annotations

import itertools
import os
import random

from .core import Cell, CanvasError
from .stick import stick, rows as _rows
from . import tech as T


# ---------------------------------------------------------------------------------------------- SPICE
def _um(v, default_unit):
    """'0.42' / '0.09u' / '420n' / '4.2e-07' -> um."""
    s = str(v).strip().lower()
    mult = {"u": 1.0, "n": 1e-3, "p": 1e-6, "m": 1e3}
    if s and s[-1] in mult:
        return float(s[:-1]) * mult[s[-1]]
    x = float(s)
    return x * 1e6 if x < 1e-4 else x * default_unit


def parse_spice(text):
    """-> {subckt: dict(pins=[...], elems=[dict(name, nodes, ref, params)])} in file order."""
    lines = []
    for ln in text.splitlines():
        ln = ln.split("$")[0].rstrip()
        if not ln.strip() or ln.lstrip().startswith("*"):
            continue
        if ln.lstrip().startswith("+") and lines:
            lines[-1] += " " + ln.lstrip()[1:]
        else:
            lines.append(ln.strip())
    subs, cur = {}, None
    for ln in lines:
        tok = ln.split()
        head = tok[0].lower()
        if head == ".subckt":
            cur = dict(pins=[x for x in tok[2:] if "=" not in x], elems=[])
            subs[tok[1]] = cur
        elif head == ".ends":
            cur = None
        elif head.startswith(".") or cur is None:
            continue
        else:
            params = dict(x.split("=", 1) for x in tok[1:] if "=" in x)
            plain = [x for x in tok[1:] if "=" not in x]
            if head[0] in "mx" and len(plain) >= 2:
                cur["elems"].append(dict(name=tok[0], nodes=plain[:-1], ref=plain[-1],
                                         params={k.lower(): v for k, v in params.items()}, kind=head[0]))
            else:
                cur["elems"].append(dict(name=tok[0], nodes=plain, ref=None, params=params, kind=head[0]))
    return subs


def _mos_models(t):
    """model name -> (device kind, 'n' | 'p')."""
    out = {}
    nwell = t.roles.get("nwell")
    for kind, rec in t.d.get("devices", {}).items():
        if rec.get("type") == "mos":
            out[rec["model"].lower()] = (kind, "p" if rec.get("well") == nwell and nwell else "n")
    return out


# ---------------------------------------------------------------------------------------------- strips
def _columns(nd, pd):
    """Pair n and p transistors into columns. A device is (d, g, s). Same gate first (most shared
    source/drain nets first), then different gates that share a source/drain net (pass gates)."""
    cols, nfree, pfree = [], list(range(len(nd))), list(range(len(pd)))
    share = lambda a, b: len({a[0], a[2]} & {b[0], b[2]})
    for same_gate in (True, False):
        cand = sorted(((-(share(nd[i], pd[j])), i, j) for i in nfree for j in pfree
                       if (nd[i][1] == pd[j][1]) == same_gate and (same_gate or share(nd[i], pd[j]))))
        for _, i, j in cand:
            if i in nfree and j in pfree:
                cols.append((nd[i], pd[j]))
                nfree.remove(i)
                pfree.remove(j)
    cols += [(nd[i], None) for i in nfree] + [(None, pd[j]) for j in pfree]
    return cols


def _orient(dev, flip):
    if dev is None:
        return None
    return (dev[2], dev[0]) if flip else (dev[0], dev[2])


def _plan(cols, tries=1):
    """Order the columns and orient the transistors. -> list of (cost, order, flips), best first.
    cost = 1000 * diffusion breaks + total horizontal span of the nets (in columns)."""
    n = len(cols)
    ST = [(a, b) for a in (0, 1) for b in (0, 1)]
    ends = [[(_orient(c[0], a), _orient(c[1], b)) for a, b in ST] for c in cols]

    def step(i, s, j, u):            # 1 if a diffusion break is needed between column i (state s) and j (state u)
        for side in (0, 1):
            a, b = ends[i][s][side], ends[j][u][side]
            if a is not None and b is not None and a[1] != b[0]:
                return 1
        return 0
    trans = {}

    def breaks(order):
        best = [0, 0, 0, 0]
        back = []
        for k in range(1, n):
            i, j = order[k - 1], order[k]
            key = (i, j)
            m = trans.get(key)
            if m is None:
                m = trans[key] = [[step(i, s, j, u) for u in range(4)] for s in range(4)]
            nb, bk = [], []
            for u in range(4):
                v, arg = min((best[s] + m[s][u], s) for s in range(4))
                nb.append(v)
                bk.append(arg)
            best = nb
            back.append(bk)
        v, s = min((best[s], s) for s in range(4))
        states = [s]
        for bk in reversed(back):
            s = bk[s]
            states.append(s)
        return v, states[::-1]
    nets_of = [set(x for d in c if d for x in d) for c in cols]

    def span(order):
        lo, hi = {}, {}
        for k, i in enumerate(order):
            for net in nets_of[i]:
                lo.setdefault(net, k)
                hi[net] = k
        return sum(hi[x] - lo[x] for x in lo)

    def cost(order):
        b, st = breaks(order)
        return 1000 * b + span(order), st
    found = {}
    if n <= 7:
        seen_rev = set()
        for order in itertools.permutations(range(n)):
            if order[::-1] in seen_rev:
                continue
            seen_rev.add(order)
            c, st = cost(order)
            found[order] = (c, st)
    else:
        rng = random.Random(7)
        for restart in range(6):
            order = list(range(n))
            if restart:
                rng.shuffle(order)
            c, st = cost(order)
            improved = True
            while improved:
                improved = False
                for i in range(n):
                    for j in range(n):
                        if i == j:
                            continue
                        for kind in (0, 1, 2):
                            o = list(order)
                            if kind == 0:
                                if j < i:
                                    continue
                                o[i], o[j] = o[j], o[i]
                            elif kind == 1:
                                o.insert(j, o.pop(i))
                            else:
                                if j <= i + 1:
                                    continue
                                o[i:j + 1] = o[i:j + 1][::-1]
                            c2, st2 = cost(o)
                            if c2 < c:
                                order, c, st, improved = o, c2, st2, True
            found[tuple(order)] = (c, st)
    ranked = sorted(found.items(), key=lambda kv: (kv[1][0], kv[0]))
    return [(c, list(order), st) for order, (c, st) in ranked[:max(1, tries)]]


def _tokens(cols, order, states):
    """Strip token lists for `stick` (a '-' column is inserted where a diffusion break is needed)."""
    sdn, gn, sdp, gp = ["-"], [], ["-"], []
    for i, s in zip(order, states):
        (dn, dp), (fn, fp) = cols[i], ((s >> 1) & 1, s & 1)
        en, ep = _orient(dn, fn), _orient(dp, fp)
        brk = False
        for sd, e in ((sdn, en), (sdp, ep)):
            if e is not None and sd[-1] not in ("-", e[0]):
                brk = True
        if brk:
            for sd, g, e in ((sdn, gn, en), (sdp, gp, ep)):
                g.append("-")
                sd.append(e[0] if e is not None else "-")
        for sd, g, e, d in ((sdn, gn, en, dn), (sdp, gp, ep, dp)):
            if e is None:
                g.append("-")
                sd.append("-")
            else:
                sd[-1] = e[0]
                g.append(d[1])
                sd.append(e[1])
    inter = lambda sd, g: [x for pair in zip(sd, g + [None]) for x in pair][:-1]
    return inter(sdn, gn), inter(sdp, gp)


def stick_auto(name, devices, ports, wn=None, wp=None, l=None, ntracks=None, power=None, ground=None,
               kinds=("nmos", "pmos"), tech=None, tries=8):
    """A stick cell from a transistor list. devices = [(kind, drain, gate, source), ...] with kind one of
    `kinds` (or 'n' / 'p'). Chooses the column order and orientations, then calls `stick` (same options).
    The chosen strips are in cell.stick['n'] / ['p'] (strings you can copy into a `stick` call and edit)."""
    t = tech or T.current()
    t.planar_only("stick_auto")
    nd = [(d, g, s) for k, d, g, s in devices if k in (kinds[0], "n")]
    pd = [(d, g, s) for k, d, g, s in devices if k in (kinds[1], "p")]
    if len(nd) + len(pd) != len(devices):
        bad = next(k for k, *_ in devices if k not in (kinds[0], kinds[1], "n", "p"))
        raise CanvasError(f"stick_auto {name}: device kind {bad!r} is not one of {kinds}",
                          "pass kinds=(<n kind>, <p kind>) or draw the cell by hand with mos()")
    if not nd and not pd:
        raise CanvasError(f"stick_auto {name}: no transistors")
    cols = _columns(nd, pd)
    last = None
    for cost, order, states in _plan(cols, tries):
        n, p = _tokens(cols, order, states)
        try:
            c = stick(name, n=n, p=p, ports=ports, wn=wn, wp=wp, l=l, ntracks=ntracks, power=power,
                      ground=ground, kinds=kinds, tech=t)
        except CanvasError as e:
            last = e
            continue
        c.stick["n"], c.stick["p"] = " ".join(n), " ".join(p)
        return c
    raise CanvasError(f"stick_auto {name}: no column order gave a buildable stick cell ({last})",
                      "write the two strips yourself with stick(), or draw the cell with mos() and wires")


# ---------------------------------------------------------------------------------------------- hierarchy
def _leaf(name, sub, t, models, ntracks=None):
    devs, w, ln, kinds, bulk = [], {}, set(), {}, {}
    unit = 1.0
    for e in sub["elems"]:
        kind, side = models[e["ref"].lower()]
        d, g, s, b = e["nodes"][:4]
        devs.append((side, d, g, s))
        kinds.setdefault(side, set()).add(kind)
        bulk.setdefault(side, set()).add(b)
        if "w" in e["params"]:
            w.setdefault(side, set()).add(round(_um(e["params"]["w"], unit), 6))
        if "l" in e["params"]:
            ln.add(round(_um(e["params"]["l"], unit), 6))
    for what, vals in (("n width", w.get("n", ())), ("p width", w.get("p", ())), ("gate length", ln),
                       ("n device type", kinds.get("n", ())), ("p device type", kinds.get("p", ()))):
        if len(vals) > 1:
            raise CanvasError(f"from_spice: subcircuit {name} has more than one {what} ({sorted(vals)})",
                              "a stick cell has one width per strip and one gate length: draw this cell with "
                              "mos() or split it into subcircuits")
    sup = t.d.get("supplies", {})
    ground = next(iter(bulk.get("n", [sup.get("ground", "VSS")])))
    power = next(iter(bulk.get("p", [sup.get("power", "VDD")])))
    ports = [x for x in sub["pins"] if x not in (power, ground)]
    kk = (next(iter(kinds.get("n", ["nmos"]))), next(iter(kinds.get("p", ["pmos"]))))
    one = lambda s: next(iter(s)) if s else None
    return stick_auto(name, devs, ports, wn=one(w.get("n")), wp=one(w.get("p")), l=one(ln), ntracks=ntracks,
                      power=power, ground=ground, kinds=kk, tech=t), power, ground


def from_spice(src, top=None, nrows=None, serpentine=True, tech=None, style=None):
    """Build the layout of a transistor-level SPICE netlist (file name or text). Two styles:

    "cells" - logic. Subcircuits made only of MOS transistors with one n width, one p width and one gate
              length become stick cells (`stick_auto`); the top subcircuit is made of instances of those:
              they are placed in `nrows` rows in netlist order (default: the most square arrangement that
              routes) and wired with `Router`. top.leaves = {name: stick cell}. A top subcircuit that is
              itself such a transistor group gives one stick cell.
    "rows"  - any devices of any size (analog): the hierarchy is flattened; fingers of one transistor are
              merged into multi-finger strips, which stand in rows inside tap rings; resistors and MIM
              capacitors stand beside them; the trunk router wires everything (icdsl.canvas.analog).
              A baseline without matching (no interdigitation, no common centroid).

    style=None chooses: "rows" when the top subcircuit holds devices that do not fit a stick cell
    (resistors, capacitors, several widths or lengths), else "cells". The top subcircuit is the last one in
    the file unless top= names it. Every pin of the top subcircuit becomes a port. Returns the top Cell."""
    from .route import Router
    t = tech or T.current()
    t.planar_only("from_spice")
    text = src
    if "\n" not in src and os.path.exists(src):
        with open(src) as f:
            text = f.read()
    subs = parse_spice(text)
    if not subs:
        raise CanvasError("from_spice: no .subckt in the netlist")
    top = top or list(subs)[-1]
    if top not in subs:
        raise CanvasError(f"from_spice: no subcircuit {top!r}", "subcircuits: " + ", ".join(subs))
    models = _mos_models(t)

    def kind_of(name):
        el = subs[name]["elems"]
        mos = [e for e in el if e["ref"] and e["ref"].lower() in models]
        inst = [e for e in el if e["ref"] in subs]
        if len(mos) == len(el) and el:
            return "leaf"
        if len(inst) == len(el) and el:
            return "parent"
        other = next((e for e in el if e not in mos and e not in inst), None)
        raise CanvasError(f"from_spice: subcircuit {name} " + ("is empty" if not el else
                          "mixes transistors and instances of subcircuits" if other is None else
                          f"has an element that is not a transistor: {other['name']} ({other['ref'] or other['kind']})"),
                          'style="cells" needs MOS-only leaf cells and a top made of instances; '
                          'from_spice(..., style="rows") places any mix of transistors, resistors and capacitors')
    from . import analog as _an
    if style not in (None, "cells", "rows"):
        raise CanvasError(f"from_spice: style={style!r}", 'style is "cells", "rows" or None (choose)')

    def device_rows():
        return _an.device_rows(top, _an.flatten(subs, top, t), subs[top]["pins"], tech=t)
    if style == "rows":
        return device_rows()
    fit = {}

    def fits_cells(name):
        """Stick cells can do this subcircuit: MOS-only leaves of one size per polarity, parents of those."""
        if name not in fit:
            fit[name] = False                           # (also stops a subcircuit that contains itself)
            el = subs[name]["elems"]
            if el and all(e["ref"] in subs for e in el):
                fit[name] = all(fits_cells(e["ref"]) for e in el)
            elif el and all(e["ref"] and e["ref"].lower() in models for e in el):
                try:
                    _leaf(name, subs[name], t, models)
                    fit[name] = True
                except CanvasError:
                    pass
                finally:
                    Cell.registry.pop(name, None)
        return fit[name]
    if style is None and not fits_cells(top):
        return device_rows()
    if kind_of(top) == "leaf":
        return _leaf(top, subs[top], t, models)[0]

    # flatten the top down to leaf instances
    flat = []                                           # (leaf subckt, instance name, {pin: net})

    def expand(name, prefix, netmap):
        for e in subs[name]["elems"]:
            child = e["ref"]
            iname = prefix + e["name"].lstrip("xX")
            conns = {}
            for pin, node in zip(subs[child]["pins"], e["nodes"]):
                conns[pin] = netmap.get(node, prefix + node if prefix else node)
            if kind_of(child) == "leaf":
                flat.append((child, iname, conns))
            else:
                expand(child, iname + "_", conns)
    sup = t.d.get("supplies", {})
    expand(top, "", {})
    used = list(dict.fromkeys(f[0] for f in flat))
    # every leaf with the same number of tracks, so that all cells have one height
    first = {n: _leaf(n, subs[n], t, models) for n in used}
    nt = max(c.stick["ntracks"] for c, _, _ in first.values())
    leaves = {}
    for n in used:
        c, power, ground = first[n]
        if c.stick["ntracks"] != nt:
            c = _leaf(n, subs[n], t, models, ntracks=nt)[0]
        leaves[n] = c
    heights = {round(c.stick["H"], 4) for c in leaves.values()}
    if len(heights) > 1:
        raise CanvasError(f"from_spice: the leaf cells have different heights {sorted(heights)} (different "
                          "transistor widths)", "use one n width and one p width in all leaf subcircuits, or "
                          "build the cells with stick_auto() and place them yourself")
    power, ground = first[used[0]][1], first[used[0]][2]
    H = next(iter(leaves.values())).stick["H"]
    widths = [leaves[f[0]].stick["W"] for f in flat]
    total = sum(widths)

    def split(nr):
        """Rows of about equal width, netlist order."""
        out, row, acc, target = [], [], 0.0, total / nr
        for f, w in zip(flat, widths):
            if row and len(out) < nr - 1 and acc + w / 2 > target * (len(out) + 1):
                out.append(row)
                row = []
            row.append(f)
            acc += w
        out.append(row)
        return out
    def unaligned(grid, serp):
        """Nets whose pins are neither all in one row nor all at one column position."""
        where = {}
        for r, row in enumerate(grid):
            row = row[::-1] if serp and r % 2 else row
            for k, (_, _, conns) in enumerate(row):
                for net in conns.values():
                    where.setdefault(net, set()).add((r, k))
        return sum(1 for net, w in where.items() if net not in (power, ground)
                   and len({r for r, _ in w}) > 1 and len({k for _, k in w}) > 1)
    aspect = lambda nr: max(total / nr, nr * H) / min(total / nr, nr * H)
    if nrows:
        cands = [(int(nrows), serpentine)]
    else:
        # the squarer arrangements first, then the elongated ones; in each group the arrangement whose nets
        # line up best (a memory array wants its bit lines in columns), rows as given or serpentine
        allc = [(nr, sp) for nr in range(1, len(flat) + 1) for sp in ((True, False) if serpentine else (False,))]
        key = lambda c: (unaligned(split(c[0]), c[1]), aspect(c[0]), not c[1])
        tier1 = sorted((c for c in allc if aspect(c[0]) <= 2.5), key=key)[:6]
        tier2 = sorted((c for c in allc if 2.5 < aspect(c[0]) <= 10), key=key)[:6]
        cands = tier1 + tier2 or sorted(allc, key=lambda c: aspect(c[0]))[:4]
    err = None
    for nr, serp in cands:
        grid = split(nr)
        cell = Cell(top, t)
        table = [[(leaves[leaf], iname, conns) for leaf, iname, conns in
                  (row[::-1] if serp and r % 2 else row)] for r, row in enumerate(grid)]
        _rows(cell, table, power=power, ground=ground)
        try:
            handles = Router(cell).auto(skip=(power, ground)).run()
        except CanvasError as e:
            err = e
            continue
        missing = []
        for pin in subs[top]["pins"]:
            if pin in (power, ground):
                continue
            if pin in handles:
                cell.port(pin, on=handles[pin])
            else:
                missing.append(pin)
        if missing:
            raise CanvasError(f"from_spice: top pin(s) {', '.join(missing)} connect to no instance")
        cell.leaves = leaves
        cell.nrows, cell.serpentine = nr, serp
        return cell
    raise CanvasError(f"from_spice: {top} did not route with {' / '.join(str(c[0]) for c in cands)} row(s): {err}",
                      "pass nrows= (more rows = shorter rows), or place the leaf cells yourself with rows() "
                      "and wire the failing nets by hand before Router.run()")
