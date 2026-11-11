#!/usr/bin/env python3
"""Score the hard-task comparison: re-check every deliverable with the shared checker (fresh log),
sweep the ICL files, and tabulate per model x condition x task, plus the agents' own effort."""
import glob
import json
import os
import subprocess
import sys

D = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(D)
PY = os.path.join(ROOT, ".venv", "bin", "python")
usage = json.load(open(os.path.join(D, "usage.json"))) if os.path.exists(os.path.join(D, "usage.json")) else {}
rows = []
only = sys.argv[1:]
for d in sorted(glob.glob(os.path.join(D, "*-*-*"))):
    if not os.path.isdir(d):
        continue
    name = os.path.basename(d)
    if only and not any(o in name for o in only):
        continue
    model, cond, task = name.split("-", 2)
    ext = "gds" if cond == "raw" else "icl"
    deliver = os.path.join(d, f"{task}.{ext}")
    checks = [json.loads(l) for l in open(os.path.join(d, "checks.jsonl"))] if os.path.exists(os.path.join(d, "checks.jsonl")) else []
    rec, sweep = None, "-"
    if os.path.exists(deliver):
        fl = os.path.join(d, "final_score")
        if os.path.exists(fl):
            subprocess.run(["rm", "-rf", fl])
        os.makedirs(fl)
        subprocess.run([PY, os.path.join(ROOT, "bench", "agent_check.py"), deliver, task, "--log", fl],
                       capture_output=True, text=True, timeout=1200)
        recs = [json.loads(l) for l in open(os.path.join(fl, "checks.jsonl"))]
        rec = recs[-1] if recs else None
        if ext == "icl" and rec and rec.get("status") == "CLEAN":
            r = subprocess.run([PY, os.path.join(ROOT, "bench", "agent_check.py"), deliver, task, "--sweep", "--log", fl],
                               capture_output=True, text=True, timeout=2400)
            last = [l for l in r.stdout.splitlines() if l.startswith("sweep:")]
            sweep = last[-1].split()[1] if last else "?"
    u = usage.get(name, {})
    run_json = os.path.join(d, "run.json")
    if os.path.exists(run_json):                       # free-model runs record their own effort
        rj = json.load(open(run_json))
        u = dict(u, model_calls=rj.get("model_calls"), minutes=rj.get("minutes"))
    status = (rec or {}).get("status", "no file")
    if status == "VIOLATIONS":
        status = f"drc={rec.get('drc')} lvs={'ok' if rec.get('lvs') else 'FAIL'} cons={rec.get('constraints_failed')}"
    rows.append({"run": name, "model": model, "cond": cond, "task": task, "final": status,
                 "clean": (rec or {}).get("status") == "CLEAN", "size_um": (rec or {}).get("size_um"),
                 "checks": len(checks), "sweep": sweep, **{k: u.get(k) for k in ("tokens", "tool_uses", "minutes", "model_calls")}})
    print(f"{name:34s} {status:32s} {str((rec or {}).get('size_um')):16s} checks={len(checks):<3d} sweep={sweep:5s} "
          f"tok={u.get('tokens', '-')} tools={u.get('tool_uses', '-')} calls={u.get('model_calls', '-')} min={u.get('minutes', '-')}",
          flush=True)
json.dump(rows, open(os.path.join(D, "results.json" if not only else "results_partial.json"), "w"), indent=1)
