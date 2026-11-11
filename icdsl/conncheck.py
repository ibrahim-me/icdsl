"""Object-level connectivity check (a small LVS that speaks in statement names).

netgen tells you *that* layout and schematic differ; this tells you *which statements* are the
reason, from the drawn geometry:

  * opens  - a net label that ends up in more than one connected piece of metal/diffusion
  * shorts - one connected piece that carries two different net labels
  * devices - every transistor found in the layout (poly crossing diffusion) with the nets on its
    gate / source / drain, matched against the `device` statements

Conductors: diffusion (split by the poly gates that cross it), tap, poly, li, m1..m4; cuts licon,
mcon, via..via3 join the layers they overlap.
"""
from __future__ import annotations

from collections import defaultdict

import klayout.db as kdb

METALS = ["poly", "li", "m1", "m2", "m3", "m4"]
CUT_PAIRS = {"mcon": ("li", "m1"), "via": ("m1", "m2"), "via2": ("m2", "m3"), "via3": ("m3", "m4")}
TEMPLATE = {"vgnd", "vpwr", "vgnd_li", "vpwr_li", "ptap", "ntap", "nwell", "cell", "boundary"}


def _box(r):
    return kdb.Box(r.x0, r.y0, r.x1, r.y1)


def _um(v):
    return round(v / 1000.0, 3)


class Net:
    def __init__(self):
        self.parent = {}

    def find(self, a):
        p = self.parent.setdefault(a, a)
        while p != self.parent[p]:
            self.parent[p] = self.parent[self.parent[p]]
            p = self.parent[p]
        self.parent[a] = p
        return p

    def union(self, a, b):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            self.parent[rb] = ra


def _base(owner):
    """Object name behind a shape owner ('ntap_licon' -> 'ntap', 'route:X' -> 'route X')."""
    if owner.startswith("route:"):
        return "route " + owner[6:]
    return owner


def analyse(shapes, devices=(), lines=None, power=("VPWR", "VGND"), return_nets=False):
    """shapes: geom.Shape list (flattened cell); devices: [(name, kind, d, g, s)];
    lines: object name -> statement line. Returns a dict (see module doc)."""
    lines = lines or {}
    by = defaultdict(list)
    for s in shapes:
        by[s.layer].append(s)

    nodes = []                                 # (layer, polygon, bbox)
    owners = defaultdict(set)                  # node id -> owner names
    labels = defaultdict(set)                  # node id -> net labels

    def add_layer(layer, region):
        ids = []
        for p in region.each():
            nodes.append((layer, kdb.Region(p), p.bbox()))
            ids.append(len(nodes) - 1)
        return ids

    def region(layer):
        r = kdb.Region()
        for s in by.get(layer, ()):
            r.insert(_box(s.rect))
        return r.merged()

    poly = region("poly")
    diff = region("diff")
    layer_ids = {}
    layer_ids["diff"] = add_layer("diff", diff - poly)
    layer_ids["tap"] = add_layer("tap", region("tap"))
    for L in METALS:
        layer_ids[L] = add_layer(L, region(L))

    def hits(layer, box):
        rb = kdb.Region(box)
        return [i for i in layer_ids.get(layer, ())
                if nodes[i][2].touches(box) and not nodes[i][1].interacting(rb).is_empty()]

    # attribute owners / labels to nodes
    for L in ["diff", "tap"] + METALS:
        for s in by.get(L, ()):
            for i in hits(L, _box(s.rect)):
                owners[i].add(_base(s.owner or "?"))
                if s.net:
                    labels[i].add(s.net)

    uf = Net()
    for i in range(len(nodes)):
        uf.find(i)
    cut_owner = []
    for s in by.get("licon", ()):
        b = _box(s.rect)
        top = hits("li", b)
        bot = hits("poly", b) + hits("diff", b) + hits("tap", b)
        for a in top:
            for c in bot:
                uf.union(a, c)
        cut_owner.append((s, top + bot))
    for cut, (lo, hi) in CUT_PAIRS.items():
        for s in by.get(cut, ()):
            b = _box(s.rect)
            ids = hits(lo, b) + hits(hi, b)
            for a in ids[1:]:
                uf.union(ids[0], a)

    comp_nodes = defaultdict(list)
    for i in range(len(nodes)):
        comp_nodes[uf.find(i)].append(i)
    comp_labels = {c: set().union(*(labels[i] for i in ns)) for c, ns in comp_nodes.items()}
    comp_owners = {c: set().union(*(owners[i] for i in ns)) for c, ns in comp_nodes.items()}

    def describe(objs, k=6):
        mine = sorted(o for o in objs if o in lines and lines[o])
        tmpl = sorted(o for o in objs if o not in lines or not lines[o])
        parts = [f"{o} (line {lines[o]})" for o in mine[:k]]
        if len(mine) > k:
            parts.append(f"+{len(mine) - k} more")
        tm = [t for t in tmpl if not t.startswith("route ") and "_" not in t][:3]
        if tm:
            parts.append("template " + "/".join(tm))
        rt = [t for t in tmpl if t.startswith("route ")]
        if rt:
            parts.append(", ".join(sorted(set(rt))))
        return ", ".join(parts) or "unnamed shapes"

    # --- shorts
    shorts = []
    for c, labs in comp_labels.items():
        if len(labs) > 1:
            # where: a single node holding two labels, else name the cut-joined pieces
            where = ""
            for i in comp_nodes[c]:
                if len(labels[i]) > 1:
                    b = nodes[i][2]
                    where = (f"on {nodes[i][0]} around ({_um(b.center().x)}, {_um(b.center().y)}): shapes of "
                             f"{' and '.join(sorted(labels[i]))} overlap/touch there ({describe(owners[i])})")
                    break
            if not where:
                per = []
                for lab in sorted(labs):
                    objs = set().union(*(owners[i] for i in comp_nodes[c] if lab in labels[i]))
                    per.append(f"{lab}: {describe(objs, 3)}")
                where = "joined through contacts/vias: " + "; ".join(per)
            shorts.append({"nets": sorted(labs), "where": where})

    # --- opens
    opens = []
    by_label = defaultdict(list)
    for c, labs in comp_labels.items():
        for lab in labs:
            by_label[lab].append(c)
    for lab, cs in sorted(by_label.items()):
        if len(cs) < 2:
            continue
        pieces = []
        for c in cs:
            pieces.append(describe(comp_owners[c], 4))
        opens.append({"net": lab, "pieces": pieces})

    # --- transistors
    nsdm, psdm = region("nsdm"), region("psdm")
    gates = (poly & diff)
    found = []
    for g in gates.each():
        gb = g.bbox()
        rg = kdb.Region(g)
        kind = "nmos" if not nsdm.interacting(rg).is_empty() else ("pmos" if not psdm.interacting(rg).is_empty()
                                                                     else "?")
        gate_ids = [i for i in layer_ids["poly"] if nodes[i][2].overlaps(gb)]
        sd_ids = [i for i in layer_ids["diff"] if nodes[i][2].touches(gb) and
                  not nodes[i][1].interacting(rg).is_empty()]

        def lab(i):
            c = uf.find(i)
            ls = comp_labels[c]
            if len(ls) == 1:
                return next(iter(ls))
            if len(ls) > 1:
                return "+".join(sorted(ls))      # shorted
            return f"?{c}"                       # unlabelled piece
        gate = lab(gate_ids[0]) if gate_ids else "?nogate"
        pairs = sorted(((lab(i), describe(set().union(*(owners[j] for j in comp_nodes[uf.find(i)]
                                                         if nodes[j][0] == "diff" or nodes[j][0] == "li")) or
                                          comp_owners[uf.find(i)], 3)) for i in sd_ids), key=lambda t: t[0])
        sd = [a for a, _ in pairs]
        gate_owner = describe(set().union(*(owners[i] for i in gate_ids)), 2) if gate_ids else "?"
        found.append({"kind": kind, "x_um": _um(gb.center().x), "y_um": _um(gb.center().y), "gate": gate,
                      "sd": sd, "gate_objects": gate_owner, "sd_objects": [b for _, b in pairs]})

    # --- match against device statements (unlabelled pieces may stand for internal nets)
    bind = {}
    unmatched = []
    pool = list(range(len(found)))
    internal = {n for d in devices for n in (d[2], d[3], d[4])} - set(power)

    def try_match(t, d, g, s):
        for a, b in ((t["sd"][0], t["sd"][1]), (t["sd"][1], t["sd"][0])):
            trial = dict(bind)
            ok = True
            for lay, want in ((t["gate"], g), (a, d), (b, s)):
                if lay == want:
                    continue
                if lay.startswith("?") and want in internal and trial.get(lay, want) == want:
                    trial[lay] = want
                    continue
                ok = False
                break
            if ok:
                return trial
        return None
    for (name, kind, d, g, s) in devices:
        hit = None
        for j in pool:
            t = found[j]
            if t["kind"] == kind and len(t["sd"]) == 2:
                trial = try_match(t, d, g, s)
                if trial is not None:
                    hit = j
                    bind = trial
                    break
        if hit is None:
            unmatched.append({"device": name, "kind": kind, "d": d, "g": g, "s": s})
        else:
            pool.remove(hit)
    extra = [found[j] for j in pool]
    out = {"opens": opens, "shorts": shorts, "transistors": found, "unmatched_devices": unmatched,
           "extra_transistors": extra}
    if return_nets:                    # metal + cut geometry per labelled net (for geometric judges)
        nets = defaultdict(lambda: defaultdict(kdb.Region))
        for i, (lay, reg, _) in enumerate(nodes):
            labs = comp_labels[uf.find(i)]
            if len(labs) == 1 and lay in ("li", "m1", "m2", "m3", "m4"):
                nets[next(iter(labs))][lay] += reg
        for cut, (lo, hi) in list(CUT_PAIRS.items()) + [("licon", ("li", None))]:
            for sh in by.get(cut, ()):
                ids = hits(lo, _box(sh.rect))
                if ids:
                    labs = comp_labels[uf.find(ids[0])]
                    if len(labs) == 1:
                        nets[next(iter(labs))][cut].insert(_box(sh.rect))
        out["nets"] = nets
    return out


def summary(res, max_lines=14):
    """Human/LLM-readable lines, most decisive first."""
    out = []
    for s in res["shorts"]:
        out.append(f"SHORT {' / '.join(s['nets'])}: {s['where']}")
    for o in res["opens"]:
        out.append(f"OPEN net {o['net']} is {len(o['pieces'])} separate pieces: " +
                   " | ".join(f"[{p}]" for p in o["pieces"]) +
                   f" - join them (strap / shared metal / `route {o['net']}`)")
    if res["unmatched_devices"]:
        for u in res["unmatched_devices"]:
            line = (f"DEVICE {u['device']} ({u['kind']} g={u['g']} d={u['d']} s={u['s']}) has no matching "
                    "transistor in the layout")
            near = [t for t in res["extra_transistors"] if t["kind"] == u["kind"] and t["gate"] == u["g"]]
            if near:
                t = near[0]
                have, want = list(t["sd"]), [u["d"], u["s"]]
                for n in list(have):
                    if n in want:
                        want.remove(n)
                        have.remove(n)
                if have and want:
                    line += (f" - the {u['kind']} with gate {u['g']} at x={t['x_um']} has {' and '.join(t['sd'])} on its "
                             f"sides; it needs {u['d']} and {u['s']}: the side labelled {have[0]} should be {want[0]} "
                             f"(wrong net label on that contact column, or the gates are in the wrong order)")
            out.append(line)
        for t in res["extra_transistors"]:
            sd = ", ".join(f"{n} [{o}]" for n, o in zip(t["sd"], t["sd_objects"]))
            out.append(f"  layout {t['kind']} at x={t['x_um']} y={t['y_um']}: gate {t['gate']} "
                       f"[{t['gate_objects']}], source/drain {sd or 'none'}"
                       + ("  (?N = connected to no labelled net: a gate with no contact on it, or a diffusion "
                          "piece with no contact - fine only for a series node)"
                          if any(n.startswith('?') for n in t['sd'] + [t['gate']]) else ""))
    return out[:max_lines]
