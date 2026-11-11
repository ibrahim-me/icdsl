#!/usr/bin/env python3
"""Scoreboard for benchmark runs: python bench/score.py agents/bench_runs/<run> [...]

scratch / repair runs: nominal clean, full-sweep clean, attempt trail.
compact runs: best sweep-clean width vs. the generator draft and the sky130_fd_sc_hd cell.
"""
import json
import os
import sys


def trail(att):
    return " ".join("C" if a.get("status") == "CLEAN" else "E" if a.get("status") == "ERROR"
                    else "-" if a.get("status") == "NO_CODE" else
                    f"{a.get('drc')}{'' if a.get('lvs') else '*'}" +
                    (f"c{a['constraints_failed']}" if a.get("constraints_failed") else "")
                    for a in att)


def score_compact(R, tag):
    res = sorted(R["results"], key=lambda r: (r["tier"], r["cell"]))
    better = sum(bool(r.get("improved")) for r in res)
    print(f"{tag}: narrower than the draft and sweep-clean {better}/{len(res)}, model calls {R.get('api_calls')}")
    tot_d = tot_b = tot_h = 0
    for r in res:
        d, b, h = r.get("draft_width"), r.get("best_width"), r.get("hd_width")
        tot_d += d or 0
        tot_b += b or d or 0
        tot_h += h or 0
        att = " ".join(f"{a.get('width')}{'' if a.get('status') == 'CLEAN' else '!'}"
                       + (f"({a['sweep']}/6)" if 'sweep' in a else "") for a in r.get("attempts", []))
        print(f"  T{r['tier']} {r['cell']:7s} draft {d} um -> best {b} um   (hd {h} um)   attempts: {att}"
              + (f"   [{r['error'][:60]}]" if r.get("error") else ""))
    print(f"  total width: draft {tot_d:.2f} -> best {tot_b:.2f} um (hd library {tot_h:.2f} um, no in-cell taps)")
    print("  (attempt: width, ! = not clean at nominal, (n/6) = sweep points clean)")


def score(run):
    R = json.load(open(os.path.join(run, "results.json")))
    tag = os.path.basename(run.rstrip("/"))
    if R["config"].get("task") == "compact":
        return score_compact(R, tag)
    res = sorted(R["results"], key=lambda r: (r["tier"], r["cell"]))
    rows, nom, full = [], 0, 0
    for r in res:
        att = r.get("attempts", [])
        sw = r.get("sweep_best")
        n_sw = len(r["sweep"][0]) if r.get("sweep") else 6
        nom += bool(r.get("nominal_clean"))
        full += bool(sw is not None and sw == n_sw)
        extra = f" [{r['mutation']}]" if r.get("mutation") else ""
        rows.append(f"  T{r['tier']} {r['cell']:7s}{extra:8s} "
                    f"{'CLEAN@%d' % r['clean_at'] if r.get('clean_at') else ('skip   ' if r.get('skipped') else 'fail   '):8s}"
                    f" sweep {('%d/%d' % (sw, n_sw)) if sw is not None else '-  '}   attempts: {trail(att)}"
                    + (f"   [{r['error'][:60]}]" if r.get("error") else ""))
    print(f"{tag}: nominal clean {nom}/{len(res)}, full sweep clean {full}/{len(res)}, model calls {R.get('api_calls')}")
    print("\n".join(rows))
    print("  (attempt trail: number = DRC count, * = LVS mismatch, cN = N layout constraints failed, "
          "E = compile/route error, C = clean)")


for run in sys.argv[1:]:
    score(run)
    print()
