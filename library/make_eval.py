#!/usr/bin/env python3
"""Evaluation tasks for the reference-library comparison (library conventions: tapless, PDK widths).

Ten sky130_fd_sc_hd cells of 6-14 transistors. For each task the harness's library leaves out the
task's whole function family (drive strengths and inverted-input variants), so an agent never sees
the cell it is asked to build. Every task has a converted, sweep-clean reference in library/hd/
(proof that it is solvable in these conventions).

    python library/make_eval.py          # -> library/eval_specs.json
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agents"))
import hd_spec  # noqa: E402
import libsearch  # noqa: E402

CELLS = ["a21oi_1", "o211ai_1", "a31oi_1", "nor4_1", "a22oi_1", "xnor2_1", "a2bb2oi_1", "mux2i_1",
         "maj3_1", "ha_1"]


def main():
    cells = []
    for i, n in enumerate(CELLS):
        s = hd_spec.spec_for(n, scale=1.0)
        s["function"] = libsearch.describe(n) or s["function"]
        nd = len(s["devices"])
        s["tier"] = 1 if nd <= 6 else 2 if nd <= 8 else 3 if nd <= 10 else 4
        cells.append(s)
    out = os.path.join(HERE, "eval_specs.json")
    json.dump(hd_spec.lib_doc(cells), open(out, "w"), indent=1)
    for c in cells:
        print(f"T{c['tier']} {c['name']:10s} {len(c['devices']):2d}T  {c['function']}")
    print("->", out)


if __name__ == "__main__":
    main()
