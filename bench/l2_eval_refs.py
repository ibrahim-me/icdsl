#!/usr/bin/env python3
"""Check the hand-written level-2 reference solutions: nominal + sweep, DRC, LVS, judge."""
import concurrent.futures as cf
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import l2_common as C

names = sys.argv[1:] or [c["name"] for c in C.BENCH["cells"]]


def one(name):
    cell = C.cell_spec(name)
    path = os.path.join(C.ROOT, "bench", "l2_ref", f"{name}.icl")
    if not os.path.exists(path):
        return name, "missing", []
    pts = []
    for i, pt in enumerate(C.BENCH["sweep"]):
        pv = C.point_params(cell, pt)
        rep = C.run_check(path, cell, pv, f"/tmp/l2refs/{name}/p{i}")
        bad = ""
        if rep.get("status") == "ERROR":
            bad = rep.get("error", "")[:150]
        elif rep.get("status") != "CLEAN":
            bad = f"drc={rep['drc']['violations']} lvs={rep['lvs']['match']} " + "; ".join(
                r["detail"][:120] for r in rep.get("judge", {}).get("results", []) if not r["ok"])
        pts.append((pv, rep.get("status"), bad, rep.get("size_um")))
    return name, pts[0][1], pts


with cf.ThreadPoolExecutor(3) as ex:
    for name, st, pts in ex.map(one, names):
        ok = sum(1 for p in pts if p[1] == "CLEAN")
        print(f"{name:10s} nominal {st:12s} sweep {ok}/{len(pts)}  size {pts[0][3] if pts else ''}")
        for pv, s, bad, _ in pts:
            if s != "CLEAN":
                print(f"     {pv}: {s} {bad}")
