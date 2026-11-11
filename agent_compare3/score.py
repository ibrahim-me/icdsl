#!/usr/bin/env python3
"""Re-score every agent_compare3 run independently: sweep check of the deliverable (library conventions)
and the number of checker runs the agent made.  python agent_compare3/score.py [model]"""
import json
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
PY = os.path.join(ROOT, ".venv", "bin", "python")


def score(d, cell):
    f = os.path.join(d, f"{cell}.icl")
    if not os.path.exists(f):
        return {"file": False}
    env = dict(os.environ, ICL_BENCH=os.path.join(ROOT, "library", "eval_specs.json"))
    env.pop("ICL_WAIVE", None)
    log = os.path.join(d, "_score")
    os.makedirs(log, exist_ok=True)
    p = subprocess.run([PY, os.path.join(ROOT, "bench", "agent_check.py"), f, cell, "--sweep", "--log", log],
                       capture_output=True, text=True, timeout=1800, env=env)
    m = re.search(r"sweep: (\d+)/(\d+)", p.stdout)
    pts = [l.strip() for l in p.stdout.splitlines() if l.strip().startswith("{")]
    ok, n = (int(m.group(1)), int(m.group(2))) if m else (0, 5)
    nominal = bool(pts) and pts[0].endswith("CLEAN")
    checks = sum(1 for _ in open(os.path.join(d, "checks.jsonl"))) if os.path.exists(os.path.join(d, "checks.jsonl")) else 0
    sweeps = sum(1 for _ in open(os.path.join(d, "sweeps.jsonl"))) if os.path.exists(os.path.join(d, "sweeps.jsonl")) else 0
    return {"file": True, "nominal": nominal, "sweep_ok": ok, "sweep_n": n, "checks": checks, "sweeps": sweeps,
            "first_problem": "" if nominal else (pts[0][:160] if pts else p.stdout[-200:])}


def main():
    model = sys.argv[1] if len(sys.argv) > 1 else "haiku"
    out = {}
    for name in sorted(os.listdir(HERE)):
        m = re.match(rf"{model}-([ABC])-(.+)$", name)
        if not m:
            continue
        r = score(os.path.join(HERE, name), m.group(2))
        out[name] = r
        print(f"{name:24s} {r}")
    json.dump(out, open(os.path.join(HERE, f"{model}_scores.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
