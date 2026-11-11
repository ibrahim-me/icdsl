#!/usr/bin/env python3
"""Summarise an LLM standard-cell run: python agents/summarize.py agents/runs/<stamp> [more runs...]"""
import collections
import json
import os
import sys


def fmt(p):
    return f"WN={p['WN']} WP={p['WP']} L={p['L']} H={p['H']}"


def main(dirs):
    for d in dirs:
        s = json.load(open(os.path.join(d, "summary.json")))
        print(f"# run {os.path.basename(d)}  model={s['model']['id']}  api_calls={s.get('api_calls')}")
        if s.get("stopped"):
            print(f"stopped: {s['stopped']}")
        for c in s["cells"]:
            att = " -> ".join(f"{a['status']}" + (f"(drc {a['drc']}, lvs {a['lvs']})" if a.get('drc') is not None else "")
                              for a in c["attempts"])
            print(f"\n## {c['cell']}: nominal {'CLEAN' if c['nominal_clean'] else 'NOT clean'} after "
                  f"{len(c['attempts'])} attempt(s): {att}")
            for i, sw in enumerate(c.get("sweep", [])):
                ok = sum(r["status"] == "CLEAN" for r in sw)
                print(f"   sweep round {i}: {ok}/{len(sw)} clean")
                causes = collections.Counter(r["first_problem"].split(" x")[0] for r in sw if r["status"] != "CLEAN")
                for k, v in causes.most_common(6):
                    print(f"      {v:2d} x {k}")
                bad = [fmt(r["params"]) for r in sw if r["status"] != "CLEAN"]
                if bad:
                    print("      failing:", "; ".join(bad[:8]) + (" ..." if len(bad) > 8 else ""))


if __name__ == "__main__":
    main(sys.argv[1:])
