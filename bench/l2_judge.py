#!/usr/bin/env python3
"""Judge for the level-2 benchmark: checks layout constraints on the DRAWN geometry.

The model's statements (interdigitate, pair, symmetric, ...) are not trusted. Every transistor
finger is found as poly crossing diffusion (icdsl.conncheck), assigned to a benchmark device by its
kind and gate/source/drain nets (dummies - drain == source - are ignored), and the constraints are
evaluated on finger positions and on the routed metal. LVS (netgen, independent reference) is what
proves the nets are right; this judge proves the arrangement.

    python bench/l2_judge.py <file.icl> <cell> [--param K=V ...]
"""
from __future__ import annotations

import json
import math
import os
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)

TOL = 0.06          # um: centroid / axis tolerance (about half a manufacturing grid step of 0.115/2)


def _rect_dist(a, b):
    dx = max(b.x0 - a.x1, a.x0 - b.x1, 0)
    dy = max(b.y0 - a.y1, a.y0 - b.y1, 0)
    return math.hypot(dx, dy) / 1000.0


def fingers(top, devices):
    """device name -> [(x_um, y_um)], plus unassigned fingers."""
    from icdsl import conncheck
    res = conncheck.analyse(top.all_shapes(True), [], {})
    out = defaultdict(list)
    stray = []
    for t in res["transistors"]:
        if len(t["sd"]) != 2 or t["sd"][0] == t["sd"][1]:
            continue                                    # dummy (or broken)
        hit = None
        for d in devices:
            if d["kind"] == t["kind"] and d["g"] == t["gate"] and sorted([d["d"], d["s"]]) == sorted(t["sd"]):
                hit = d["name"]
                break
        if hit:
            out[hit].append((t["x_um"], t["y_um"]))
        else:
            stray.append(t)
    return out, stray


def centroid(pts):
    return (sum(p[0] for p in pts) / len(pts), sum(p[1] for p in pts) / len(pts))


def _route_shapes(top, net):
    return [s for s in top.all_shapes(True)
            if s.net == net and (s.owner.startswith("route:") or s.owner.startswith("wire:"))
            and "pinpad" not in s.kinds and s.layer in ("m1", "m2", "m3", "m4")]


def check(top, spec, pv=None, fg=None, stray=None):
    devs = spec["devices"]
    if fg is None:
        fg, stray = fingers(top, devs)
    stray = stray or []
    results = []
    rr = getattr(top, "route_report", None) or {}
    nets_rep = rr.get("nets", {})

    def res(c, ok, detail):
        results.append({"constraint": c, "ok": bool(ok), "detail": detail})

    for d in devs:
        n = len(fg.get(d["name"], []))
        if n != d["nf"]:
            res({"type": "fingers", "device": d["name"]}, False,
                f"{d['name']}: found {n} finger(s) with {d['kind']} g={d['g']} d/s={d['d']}/{d['s']}, expected {d['nf']}")
    for c in spec["constraints"]:
        t = c["type"]
        if t in ("interdigitated", "common_centroid"):
            names = c["devices"]
            missing = [n for n in names if not fg.get(n)]
            if missing:
                res(c, False, f"no fingers found for {', '.join(missing)}")
                continue
            cents = {n: centroid(fg[n]) for n in names}
            ref = cents[names[0]]
            off = max(max(abs(cents[n][0] - ref[0]), abs(cents[n][1] - ref[1])) for n in names)
            desc = ", ".join(f"{n} centroid ({cents[n][0]:.3f}, {cents[n][1]:.3f})" for n in names)
            if t == "common_centroid":
                res(c, off <= TOL, f"{desc}; max offset {off:.3f} um (allowed {TOL})")
                continue
            ys = {round(p[1], 2) for n in names for p in fg[n]}
            seq = "".join(chr(ord("A") + names.index(n)) for x, n in
                          sorted((p[0], n) for n in names for p in fg[n]))
            changes = sum(1 for a, b in zip(seq, seq[1:]) if a != b)
            ok = len(ys) == 1 and changes >= 2 and off <= TOL
            why = []
            if len(ys) != 1:
                why.append(f"fingers are in {len(ys)} rows (y = {sorted(ys)}), need one row")
            if changes < 2:
                why.append(f"order {seq} is not interleaved")
            if off > TOL:
                why.append(f"centroids differ by {off:.3f} um")
            res(c, ok, f"order left to right {seq} ({', '.join(f'{chr(65 + i)}={n}' for i, n in enumerate(names))}); "
                       f"{desc}" + ("; " + "; ".join(why) if why else ""))
        elif t == "mirror_symmetric":
            axes, bad, desc = [], [], []
            for a, b in c["pairs"]:
                if not fg.get(a) or not fg.get(b):
                    bad.append(f"{a}/{b}: fingers missing")
                    continue
                ca, cb = centroid(fg[a]), centroid(fg[b])
                ax = (ca[0] + cb[0]) / 2
                axes.append(ax)
                desc.append(f"{a}/{b} axis x={ax:.3f}" + (f", y differs by {abs(ca[1]-cb[1]):.3f}"
                                                         if abs(ca[1] - cb[1]) > TOL else ""))
                if abs(ca[1] - cb[1]) > TOL:
                    bad.append(f"{a}/{b} not at the same height")
                xa = sorted(p[0] for p in fg[a])
                xb = sorted(2 * ax - p[0] for p in fg[b])
                if len(xa) == len(xb) and max(abs(p - q) for p, q in zip(xa, xb)) > TOL:
                    bad.append(f"{a}/{b} finger positions are not mirror images")
            if axes and max(axes) - min(axes) > TOL:
                bad.append(f"the pairs use different axes ({min(axes):.3f} .. {max(axes):.3f})")
            res(c, not bad, "; ".join(desc + bad))
        elif t == "guard_ring":
            import klayout.db as kdb
            pts = [p for n in c["devices"] for p in fg.get(n, [])]
            if not pts:
                res(c, False, "devices not found")
                continue
            box = kdb.Box(int(min(p[0] for p in pts) * 1000), int(min(p[1] for p in pts) * 1000),
                          int(max(p[0] for p in pts) * 1000), int(max(p[1] for p in pts) * 1000))
            imp = "psdm" if c["kind"] == "ptap" else "nsdm"
            taps = kdb.Region()
            impl = kdb.Region()
            for s in top.all_shapes(True):
                if s.layer == "tap":
                    taps.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
                elif s.layer == imp:
                    impl.insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
            taps = (taps.merged() & impl.merged()).merged()
            ok = False
            for p in taps.each():
                if p.holes() > 0:
                    for h in range(p.holes()):
                        hb = kdb.Polygon([q for q in p.each_point_hole(h)]).bbox()
                        if hb.contains(box.p1) and hb.contains(box.p2):
                            ok = True
            res(c, ok, f"{'a closed' if ok else 'no closed'} {c['kind']} ring around {', '.join(c['devices'])}")
        elif t == "route_width":
            n = nets_rep.get(c["net"])
            if not n:
                res(c, False, f"net {c['net']} has no routed wires (route it with width={c['min']})")
                continue
            w = min(n["width_um"].values())
            res(c, w >= c["min"] - 1e-6, f"net {c['net']} routed {n['width_um']} um wide (need >= {c['min']})")
        elif t == "maxres":
            n = nets_rep.get(c["net"])
            ok = bool(n) and n["res_ohm"] <= c["max"]
            res(c, ok, f"net {c['net']} worst pin-to-pin {n['res_ohm'] if n else '?'} ohm (max {c['max']})")
        elif t == "spacing":
            a, b = c["nets"]
            sa, sb = _route_shapes(top, a), _route_shapes(top, b)
            if not sa or not sb:
                res(c, True, f"{a}/{b}: one of them has no routed wires - nothing to keep apart")
                continue
            # pin landings and the stretch of wire within the keep-out distance of a landing are exempt,
            # as for the router (two pins 0.46 um apart could never meet a larger keep-out)
            import klayout.db as kdb
            dmin = int(round(c["min"] * 1000))
            zone = kdb.Region()
            for z in top.all_shapes(True):
                if "pinpad" in z.kinds and z.net in (a, b):
                    zone.insert(kdb.Box(z.rect.x0, z.rect.y0, z.rect.x1, z.rect.y1))
            zone = zone.sized(dmin)
            worst = None
            for L in ("m1", "m2", "m3", "m4"):
                ra, rb = kdb.Region(), kdb.Region()
                for x in sa:
                    if x.layer == L:
                        ra.insert(kdb.Box(x.rect.x0, x.rect.y0, x.rect.x1, x.rect.y1))
                for y in sb:
                    if y.layer == L:
                        rb.insert(kdb.Box(y.rect.x0, y.rect.y0, y.rect.x1, y.rect.y1))
                if ra.is_empty() or rb.is_empty():
                    continue
                ra, rb = ra.merged() - zone, rb.merged() - zone
                for ep in ra.separation_check(rb, dmin).each():
                    dist = ep.distance() / 1000
                    if worst is None or dist < worst[0]:
                        worst = (dist, L, ep.bbox().center())
            if worst is None:
                res(c, True, f"routed wires of {a} and {b} are at least {c['min']} um apart (outside the pin "
                             f"escape zones)")
            else:
                res(c, False, f"wires of {a} and {b} come {worst[0]:.3f} um apart on {worst[1]} near "
                              f"({worst[2].x/1000:.2f}, {worst[2].y/1000:.2f}) (need >= {c['min']}, away from pins)")
        elif t == "route_symmetric":
            import klayout.db as kdb
            a, b = c["nets"]
            sa, sb = _route_shapes(top, a), _route_shapes(top, b)
            if not sa or not sb:
                res(c, False, f"{a} and {b} must both be routed")
                continue
            ra, rb = defaultdict(kdb.Region), defaultdict(kdb.Region)
            for s in sa:
                ra[s.layer].insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
            for s in sb:
                rb[s.layer].insert(kdb.Box(s.rect.x0, s.rect.y0, s.rect.x1, s.rect.y1))
            allx = [s.rect.x0 for s in sa + sb] + [s.rect.x1 for s in sa + sb]
            # axis: from the mirror-symmetric pairs if any, else the middle of both nets
            ax2 = None
            for cc in spec["constraints"]:
                if cc["type"] == "mirror_symmetric":
                    p = cc["pairs"][0]
                    if fg.get(p[0]) and fg.get(p[1]):
                        ax2 = int(round((centroid(fg[p[0]])[0] + centroid(fg[p[1]])[0]) * 1000))
            if ax2 is None:
                ax2 = min(allx) + max(allx)
            inter = union = 0
            for L in set(ra) | set(rb):
                ma = ra[L].merged().transformed(kdb.Trans(kdb.Trans.M90, ax2, 0)) if L in ra else kdb.Region()
                mb = rb[L].merged() if L in rb else kdb.Region()
                inter += (ma & mb).area()
                union += (ma + mb).merged().area()
            score = inter / union if union else 0
            res(c, score >= 0.9, f"{b} vs mirror image of {a}: {100 * score:.0f}% overlap (need >= 90%)")
        elif t == "area":
            a = top.width * top.height / 1e6
            mx = c["max"]
            if isinstance(mx, dict):
                want = {k: float(v) for k, v in (pv or {}).items()}
                hit = None
                for key, v in mx.items():
                    kv = dict(x.split("=") for x in key.split(","))
                    if all(abs(float(kv[k]) - want.get(k, -1)) < 1e-6 for k in kv):
                        hit = v
                mx = hit if hit is not None else min(mx.values())
            res(c, a <= mx + 1e-6, f"cell is {top.width/1000:.2f} x {top.height/1000:.2f} um = {a:.1f} um2 "
                                   f"(budget {mx} um2 at these parameters)")
        else:
            res(c, False, f"unknown constraint type {t}")
    if stray:
        res({"type": "devices"}, False, "transistors that match no device: " +
            "; ".join(f"{t['kind']} g={t['gate']} s/d={'/'.join(t['sd'])} at ({t['x_um']}, {t['y_um']})"
                      for t in stray[:4]))
    return {"ok": all(r["ok"] for r in results), "results": results,
            "fingers": {k: v for k, v in fg.items()}}


def main():
    from icdsl.design import compile_file
    args = sys.argv[1:]
    path, cell = args[0], args[1]
    params = {}
    for i, a in enumerate(args):
        if a == "--param":
            k, v = args[i + 1].split("=")
            params[k] = v
    bench = json.load(open(os.path.join(ROOT, "bench", "l2_cells.json")))
    spec = next(c for c in bench["cells"] if c["name"] == cell)
    top, _ = compile_file(path, cell, params)
    r = check(top, spec)
    for x in r["results"]:
        print("OK  " if x["ok"] else "FAIL", x["constraint"]["type"], "-", x["detail"])
    print("JUDGE", "PASS" if r["ok"] else "FAIL")


if __name__ == "__main__":
    main()
