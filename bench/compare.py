#!/usr/bin/env python3
"""One line per run: python bench/compare.py agents/bench_runs/<run> ...

Shows task, technique flags, cells solved (nominal / whole sweep) and model calls, so runs with
different techniques can be compared side by side."""
import json
import os
import sys


def flags(c):
    f = (["AGENTIC(deepagents)"] if c.get("harness") == "deepagents" else []) + \
        [f"feedback={c.get('feedback')}", f"images={c.get('images')}"]
    if c.get("keep_best"):
        f.append("keep-best")
    if c.get("lessons"):
        tag = os.path.basename(c["lessons"]).replace("lessons_stdcell", "").replace(".md", "").strip("_")
        f.append("lessons=" + (tag or "v1"))
    if c.get("examples"):
        f.append(f"examples={c['examples']}")
    if c.get("draft"):
        f.append("draft")
    if c.get("resume"):
        f.append("resume")
    if c.get("coach_dir"):
        f.append("coach")
    return " ".join(f)


print(f"{'run':38s} {'task':8s} {'solved':>7s} {'sweep':>6s} {'calls':>5s}  techniques")
for run in sys.argv[1:]:
    R = json.load(open(os.path.join(run, "results.json")))
    c = R["config"]
    res = R["results"]
    task = c.get("task", "scratch")
    if task == "compact":
        ok = sum(bool(r.get("improved")) for r in res)
        print(f"{os.path.basename(run.rstrip('/')):38s} {task:8s} {ok:>3d}/{len(res):<3d} {'':>6s} {R.get('api_calls', 0):>5d}  "
              f"{flags(c)}  (narrower than the draft, sweep-clean)")
        continue
    nom = sum(bool(r.get("nominal_clean")) and not r.get("skipped") for r in res)
    skip = sum(bool(r.get("skipped")) for r in res)
    full = sum(r.get("sweep_best") is not None and r.get("sweep") and r["sweep_best"] == len(r["sweep"][0])
               for r in res)
    n = len(res) - skip
    print(f"{os.path.basename(run.rstrip('/')):38s} {task:8s} {nom:>3d}/{n:<3d} {full:>3d}/{n:<2d} {R.get('api_calls', 0):>5d}  "
          f"{flags(c)}" + (f"  ({skip} already clean, skipped)" if skip else ""))
