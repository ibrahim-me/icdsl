#!/usr/bin/env python3
"""Reference-library comparison for Claude subagents (same conditions as the Nemotron runs):

  A  no library: AGENTS.md, lessons, two generic tapless examples (inv_1, nand2_1), ranked checker
  B  + the two most similar library cells and the whole library (minus the task's family) with a search CLI
  C  B + the deliverable starts as the nearest library cell (libsearch.start_file)

Library conventions (tapless, PDK widths, sweep L 0.15-0.25 / widths x1.25 @ 3.26 / x1.5 @ 3.8).
Writes agent_compare3/<model>-<cond>-<cell>/ with TASK.md and the files it names.
"""
import json
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(ROOT, "agents"))
sys.path.insert(0, os.path.join(ROOT, "bench"))
import libsearch  # noqa: E402

CELLS = ["a21oi_1", "nor4_1", "xnor2_1", "maj3_1"]
SPECS = {c["name"]: c for c in json.load(open(os.path.join(ROOT, "library", "eval_specs.json")))["cells"]}
FORBID = f"""Do NOT read or copy anything outside your own directory except {ROOT}/AGENTS.md, {ROOT}/bin/icl
and the checker command below. In particular not: {ROOT}/library/ (the converted PDK cells - your
directory has the part you may use), the sky130_fd_sc_hd layouts in {ROOT}/pdk/, agents/bench_runs/,
agent_compare*/ (other than your own directory), /tmp. Write only inside your own directory. Do not
launch other agents."""

SEARCH_PY = '''#!/usr/bin/env python3
"""Search this run's reference library:  search.py            (cells most similar to the task's netlist)
                                        search.py <text>     (name or Liberty function fragment)"""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, "{root}/agents")
import libsearch
lib = libsearch.Library("hd")
fam = "{family}"
lib.cells = {{n: c for n, c in lib.cells.items() if c["spec"].get("family") != fam}}
spec = json.load(open(os.path.join(HERE, "task_spec.json")))
q = " ".join(sys.argv[1:])
if q:
    for n in lib.query(q, 10):
        print(lib.summary(n), "->", f"library/{{n}}.icl")
else:
    for s, n in lib.nearest(spec, 8):
        print(lib.summary(n, s), "->", f"library/{{n}}.icl")
'''


def skeleton(c):
    pl = " ".join(f"{k}={v}" for k, v in c["params"].items())
    out = ["pdk sky130A", f"param {pl} L=0.15 H=2.72", "", f"stdcell {c['name']} width=<columns, your choice> height=H taps=no"]
    for d in c["devices"]:
        b = " b=VNB" if d["kind"] == "nmos" else " b=VPB"
        out.append(f"  device {d['name']} {d['kind']} w={d['wparam']} l=L d={d['d']} g={d['g']} s={d['s']}{b}")
    out.append("  <your geometry>")
    out += [f"  port {p} in on=<a li or met1 shape>" for p in c["inputs"]]
    out += [f"  port {p} out on=<a li or met1 shape>" for p in c["outputs"]]
    out.append("end")
    return "\n".join(out)


def make(model, cond, name, lib):
    c = SPECS[name]
    d = os.path.join(HERE, f"{model}-{cond}-{name}")
    os.makedirs(os.path.join(d, "examples"), exist_ok=True)
    shutil.copy(os.path.join(ROOT, "agents", "lessons_stdcell_v3.md"), os.path.join(d, "lessons.md"))
    for n in ("inv_1", "nand2_1"):
        shutil.copy(os.path.join(ROOT, "library", "hd", f"{n}.icl"), os.path.join(d, "examples", f"{n}.icl"))
    json.dump(c, open(os.path.join(d, "task_spec.json"), "w"), indent=1)
    chk = (f"cd {ROOT} && ICL_BENCH={ROOT}/library/eval_specs.json .venv/bin/python bench/agent_check.py "
           f"{d}/{name}.icl {name} --log {d}")
    pts = "L=0.18; L=0.25; widths x1.25 with H=3.26; widths x1.5 with H=3.8"
    t = f"""# Task: SKY130 standard cell `{name}` in ICL

Function: {c['function']}
Inputs: {', '.join(c['inputs'])}; output: {', '.join(c['outputs'])}; internal nets: {', '.join(c['internal_nets']) or 'none'}.
Deliver `{d}/{name}.icl` (block `stdcell {name}`), starting from this skeleton - keep the `pdk`, `param`
and `device` lines exactly:
```icl
{skeleton(c)}
```
Library conventions: the cell is TAPLESS (`taps=no`): the bodies (b=VNB / b=VPB) are tied by the tap cells of
the row, so the tap rules LU.2 / LU.3 / nwell.4 are not checked. Widths are the PDK widths. Rails: met1 VGND
at y=0 and VPWR at y=H, li rails vgnd_li / vpwr_li; no ptap / ntap objects exist. Width: columns of 0.46 um,
enough for L=0.25.

The ICL language: `{ROOT}/AGENTS.md` (level 1, `stdcell`). Notes from reviewing earlier attempts:
`{d}/lessons.md`. Two verified example cells in this style: `{d}/examples/inv_1.icl`, `{d}/examples/nand2_1.icl`.
"""
    if cond in ("B", "C"):
        near = lib.nearest(c, 2)
        os.makedirs(os.path.join(d, "library"), exist_ok=True)
        for n, cc in lib.cells.items():
            if cc["spec"].get("family") != c["family"]:
                shutil.copy(cc["path"], os.path.join(d, "library", f"{n}.icl"))
        for s, n in near:
            shutil.copy(lib.cells[n]["path"], os.path.join(d, "examples", f"library_{n}.icl"))
        open(os.path.join(d, "search.py"), "w").write(SEARCH_PY.format(root=ROOT, family=c["family"]))
        t += f"""
## Reference library
A library of {sum(1 for x in lib.cells.values() if x['spec'].get('family') != c['family'])} verified cells (converted from a real standard-cell library, each DRC/LVS clean over the
whole sweep) is in `{d}/library/`. The two most similar to this task (by transistor structure):
""" + "".join(f"  `{d}/examples/library_{n}.icl`  {lib.summary(n, s)}\n" for s, n in near) + f"""
More: `{ROOT}/.venv/bin/python {d}/search.py` lists the most similar cells; `search.py <text>` searches by
name or function (e.g. `search.py nand`, `search.py "A1&A2"`).
"""
        if cond == "C":
            s, n = near[0]
            start, matched = libsearch.start_file(c, n, lib)
            open(os.path.join(d, f"{name}.icl"), "w").write(start)
            t += f"""
## Start from the nearest library cell
`{d}/{name}.icl` already exists: the verified layout of library cell `{n}` with {name}'s device lines,
parameters and ports put in. {matched} of its {len(lib.cells[n]['spec']['devices'])} transistors correspond to transistors of this cell (net labels were
renamed to match). Edit it into the layout of this cell (add/remove gate columns, contact columns and li
connections so the drawn transistors match the device lines), then check.
"""
    t += f"""
## Checking (this is also the final score)
    {chk} --ranked
magic DRC (full) + netgen LVS against the netlist above (the tap rules waived) + rail checks; `--ranked`
names the statements/objects/lines behind each error with concrete edits. Then the sweep ({pts}):
    {chk} --sweep
`{ROOT}/bin/icl inspect <file> --top {name} --param WN=...` lists every object's position and size.
Positions must follow the parameters (L, WN.., WP.., H) so the sweep is clean too.

## Budget and rules
Stop when the checker says CLEAN and the sweep is clean, or after 25 checker runs / about 45 minutes of
work; keep your best version at the deliverable path.
{FORBID}

## Report (your final message)
Final checker status (first lines) and sweep result, number of checker runs, what was hard (2-4 sentences)"""
    t += (", and which library cells you used and how." if cond in ("B", "C") else ".") + "\n"
    open(os.path.join(d, "TASK.md"), "w").write(t)
    return d


if __name__ == "__main__":
    lib = libsearch.Library("hd")
    model = sys.argv[1] if len(sys.argv) > 1 else "haiku"
    for cond in ("A", "B", "C"):
        for n in CELLS:
            print(make(model, cond, n, lib))
