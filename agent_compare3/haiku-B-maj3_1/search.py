#!/usr/bin/env python3
"""Search this run's reference library:  search.py            (cells most similar to the task's netlist)
                                        search.py <text>     (name or Liberty function fragment)"""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, "/home/ibrahim/claude-workspace/icdsl/agents")
import libsearch
lib = libsearch.Library("hd")
fam = "maj3"
lib.cells = {n: c for n, c in lib.cells.items() if c["spec"].get("family") != fam}
spec = json.load(open(os.path.join(HERE, "task_spec.json")))
q = " ".join(sys.argv[1:])
if q:
    for n in lib.query(q, 10):
        print(lib.summary(n), "->", f"library/{n}.icl")
else:
    for s, n in lib.nearest(spec, 8):
        print(lib.summary(n, s), "->", f"library/{n}.icl")
