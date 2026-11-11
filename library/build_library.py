#!/usr/bin/env python3
"""Build the ICL reference library from sky130_fd_sc_hd: lift every cell (icdsl.lift), then verify it.

    python library/build_library.py [--variant bench|hd] [--cells a21oi_1,nand2_1] [--max-dev 14] [--jobs 4]

bench  benchmark conventions (in-cell taps, widths x0.75): sweep check at 6 points
Both use bench/agent_check.py --sweep (magic DRC + netgen LVS vs the PDK netlist + judge + tiling).
hd     library conventions (tapless, PDK widths): sweep check with the tap rules LU.2/LU.3/nwell.4 waived

Writes library/<variant>/<cell>.icl and library/<variant>/index.json
({cell: {status, sweep_ok, sweep_n, notes, ...}}).
"""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import time
from concurrent.futures import ProcessPoolExecutor, as_completed

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "bench"))
PY = os.path.join(ROOT, ".venv", "bin", "python")
TAPLESS_RULES = ("LU.2", "LU.3", "nwell.4")


def one(short, variant, outdir):
    from icdsl.lift import lift, LiftError
    t0 = time.time()
    rec = {"cell": short}
    try:
        txt, info = lift(short, variant)
    except LiftError as e:
        return dict(rec, status="unsupported", why=str(e))
    except Exception as e:
        return dict(rec, status="lift_error", why=repr(e)[:300])
    path = os.path.join(outdir, f"{short}.icl")
    open(path, "w").write(txt)
    rec.update(notes=info["notes"], predicted_conflicts=info["conflicts"], width_cols=info["width"])
    log = os.path.join(outdir, "_check", short)
    os.makedirs(log, exist_ok=True)
    spec_file = os.path.join(HERE, "hd_specs.json" if variant == "bench" else "lib_specs.json")
    env = dict(os.environ, ICL_BENCH=spec_file)
    env.pop("ICL_WAIVE", None)
    if variant == "hd":
        env["ICL_WAIVE"] = ",".join(TAPLESS_RULES)
    p = subprocess.run([PY, os.path.join(ROOT, "bench", "agent_check.py"), path, short, "--sweep", "--log", log],
                       capture_output=True, text=True, timeout=1800, env=env)
    m = re.search(r"sweep: (\d+)/(\d+) points clean", p.stdout)
    ok, n = (int(m.group(1)), int(m.group(2))) if m else (0, 0)
    rec.update(sweep_ok=ok, sweep_n=n, status="clean" if n and ok == n else ("partial" if ok else "fail"),
               points=[l.strip()[:200] for l in p.stdout.splitlines() if l.strip().startswith("{")])
    if not m:
        rec["why"] = (p.stdout + p.stderr)[-300:]
    rec["seconds"] = round(time.time() - t0, 1)
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--variant", default="bench", choices=["bench", "hd"])
    ap.add_argument("--cells", default="")
    ap.add_argument("--max-dev", type=int, default=14)
    ap.add_argument("--jobs", type=int, default=4)
    ap.add_argument("--out", default="")
    a = ap.parse_args()
    specs = json.load(open(os.path.join(HERE, "hd_specs.json")))["cells"]
    names = a.cells.split(",") if a.cells else [c["name"] for c in specs if len(c["devices"]) <= a.max_dev]
    outdir = a.out or os.path.join(HERE, a.variant)
    os.makedirs(outdir, exist_ok=True)
    idx_path = os.path.join(outdir, "index.json")
    index = json.load(open(idx_path)) if os.path.exists(idx_path) else {}
    with ProcessPoolExecutor(a.jobs) as ex:
        futs = {ex.submit(one, n, a.variant, outdir): n for n in names}
        for f in as_completed(futs):
            r = f.result()
            index[r["cell"]] = r
            extra = f"{r.get('sweep_ok')}/{r.get('sweep_n')}"
            print(f"{r['cell']:22s} {r['status']:12s} {extra if r['status'] not in ('unsupported', 'lift_error', 'compile_error', 'check_error') else r.get('why', '')[:90]}",
                  flush=True)
            json.dump(index, open(idx_path, "w"), indent=1)
    from collections import Counter
    print(Counter(r["status"] for r in index.values()))


if __name__ == "__main__":
    main()
