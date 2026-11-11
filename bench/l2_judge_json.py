#!/usr/bin/env python3
"""Subprocess entry for the level-2 judge: prints one JSON line."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, ROOT)
sys.path.insert(0, os.path.join(ROOT, "bench"))

path, name, pv = sys.argv[1], sys.argv[2], json.loads(sys.argv[3])
try:
    from icdsl.design import compile_file
    import l2_judge
    bench = json.load(open(os.path.join(ROOT, "bench", "l2_cells.json")))
    spec = next(c for c in bench["cells"] if c["name"] == name)
    top, _ = compile_file(path, name, {k: str(v) for k, v in pv.items()})
    r = l2_judge.check(top, spec, pv)
    r.pop("fingers", None)
    print(json.dumps(r))
except Exception as e:
    print(json.dumps({"ok": False, "results": [], "error": repr(e)[:400]}))
