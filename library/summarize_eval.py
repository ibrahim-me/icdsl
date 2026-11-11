#!/usr/bin/env python3
"""Summarise the reference-library comparison: one deep_harness run per condition.

    python library/summarize_eval.py RUN_A RUN_B RUN_C [--names A,B,C]

Per cell: nominal clean, sweep points clean, model calls, checks, minutes; per condition: totals.
"""
import json
import os
import sys


def load(d):
    r = json.load(open(os.path.join(d, "results.json")))
    return {x["cell"]: x for x in r["results"]}, r


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    names = ["A no library", "B library retrieval", "C edit nearest"]
    if "--names" in sys.argv:
        names = sys.argv[sys.argv.index("--names") + 1].split(",")
        args = [a for a in args if a != sys.argv[sys.argv.index("--names") + 1]]
    runs = [load(d) for d in args]
    cells = []
    for res, _ in runs:
        for c in res:
            if c not in cells:
                cells.append(c)
    npts = None
    out = ["| cell | " + " | ".join(names[:len(runs)]) + " |", "|---|" + "---|" * len(runs)]
    tot = [{"full": 0, "nom": 0, "calls": 0, "checks": 0, "pts": 0, "n": 0, "sec": 0} for _ in runs]
    for c in cells:
        row = [c]
        for i, (res, _) in enumerate(runs):
            r = res.get(c)
            if r is None:
                row.append("-")
                continue
            sw = r.get("sweep") or [[]]
            n = len(sw[0]) or npts or 5
            npts = n
            ok = r.get("sweep_best", 0) if r.get("nominal_clean") else 0
            t = tot[i]
            t["n"] += 1
            t["nom"] += bool(r.get("nominal_clean"))
            t["full"] += ok == n
            t["pts"] += ok
            t["calls"] += r.get("calls", 0)
            t["checks"] += r.get("checks", 0)
            t["sec"] += r.get("seconds", 0)
            extra = ""
            if r.get("start_from"):
                extra = f" (from {r['start_from']})"
            stop = r.get("stop", "")
            flag = " *" if stop.startswith("error") else ""
            row.append(f"{ok}/{n}{' ok' if ok == n else ''}, {r.get('calls', 0)} calls{extra}{flag}")
        out.append("| " + " | ".join(row) + " |")
    out.append("| **clean over the sweep** | " + " | ".join(f"**{t['full']}/{t['n']}**" for t in tot) + " |")
    out.append("| nominal clean | " + " | ".join(f"{t['nom']}/{t['n']}" for t in tot) + " |")
    out.append("| sweep points clean | " + " | ".join(f"{t['pts']}/{t['n'] * (npts or 5)}" for t in tot) + " |")
    out.append("| model calls (avg) | " + " | ".join(f"{t['calls']} ({t['calls'] / max(t['n'], 1):.1f})" for t in tot) + " |")
    out.append("| check_layout calls | " + " | ".join(str(t["checks"]) for t in tot) + " |")
    out.append("| agent minutes | " + " | ".join(f"{t['sec'] / 60:.0f}" for t in tot) + " |")
    print("\n".join(out))


if __name__ == "__main__":
    main()
