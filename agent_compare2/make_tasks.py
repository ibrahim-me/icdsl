#!/usr/bin/env python3
"""Hard-task comparison: {haiku, sonnet} x {raw, icl0 (ICL, no techniques), icl1 (ICL + techniques)} x
{maj3, ha, folded_cascode, comp_latch}. Writes TASK.md (+ technique files) per run directory."""
import json
import os
import shutil
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agents"))
import importlib.util  # noqa: E402
import agent_check as AC  # noqa: E402
_spec = importlib.util.spec_from_file_location("mt1", os.path.join(ROOT, "agent_compare", "make_tasks.py"))
MT1 = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(MT1)  # rules, layer map, device text

TASKS = ["maj3", "ha", "folded_cascode", "comp_latch"]
FORBID = """Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/, agent_compare2/ (other than your own directory), /tmp (any of it), the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file. Do not launch other agents."""


def constraints_text(T):
    if T["level"] == "l1":
        return ""
    import bench_l2 as B
    return "Layout constraints, measured on your geometry by the checker:\n" + \
        "\n".join(f"  - {B.describe(c)}" for c in T["cell"]["constraints"]) + \
        "\nDummy transistors (drain = source) are allowed and ignored by LVS.\n"


def retrieved(T, task, d):
    """Two verified layouts of similar cells (never the task itself) copied into the run directory."""
    names = []
    if T["level"] == "l1":
        import bench_harness as BH
        import sticks
        import tasks as TK
        cell = next(c for c in BH.BENCH["cells"] if c["name"] == task)
        for c in TK.similar(cell, [x for x in BH.BENCH["cells"] if x["tier"] <= 4], 2):
            open(os.path.join(d, f"verified_{c['name']}.icl"), "w").write(sticks.draft_file(c))
            names.append(c["name"])
    else:
        near = {"folded_cascode": ["ota2s", "cascode_n"], "comp_latch": ["strongarm", "diff_stage"]}[task]
        for n in near:
            shutil.copy(os.path.join(ROOT, "bench", "l2_ref", f"{n}.icl"), os.path.join(d, f"verified_{n}.icl"))
            names.append(n)
    return names


def task_md(task, cond, d):
    T = AC.task_spec(task)
    c = T["cell"]
    ext = "gds" if cond == "raw" else "icl"
    fn = c["function"]
    head = f"""# Task: SKY130 layout of `{task}`

Function: {fn}
Top cell name: `{task}`.  Deliver: `{d}/{task}.{ext}`

Transistors (fixed - LVS compares against exactly this netlist):
{MT1.devices_text(T)}
"""
    if T["level"] == "l1":
        head += f"""
Ports: inputs {', '.join(c['inputs'])}; outputs {', '.join(c['outputs'])}; supplies VPWR, VGND.
Standard-cell frame: cell height 2.72 um between the rail centres; a VGND met1 rail across the whole cell
width centred on y=0 and a VPWR met1 rail centred on y=2.72 (labelled); nmos at the bottom, pmos at the top
in an n-well; the cell carries its own body taps (p-tap under VGND, n-tap under VPWR); signal pins on met1;
cell width a multiple of 0.46 um. The cell must also TILE: copies of it placed edge to edge (and mirrored)
must stay DRC clean, so keep wells/implants/shapes inside the cell or symmetric at its edges.
"""
    else:
        head += f"\nPorts: {', '.join(p['name'] for p in c['ports'])} - each labelled.\n" + constraints_text(T)
    chk = f"cd {ROOT} && .venv/bin/python bench/agent_check.py {d}/{task}.{ext} {task} --log {d}"
    pl = " ".join(f"{k}={v}" for k, v in T["pv"].items())
    if cond == "raw":
        how = f"""
## How: draw raw GDS (no layout language)
Write the GDS yourself, e.g. with Python and KLayout's API (`{ROOT}/.venv/bin/python`, `import klayout.db`),
placing every rectangle with explicit coordinates. Do NOT use the ICL tools (bin/icl, the icdsl package,
AGENTS.md, examples/).
{MT1.LAYERS}

{MT1.RULES}
"""
        check = f"    {chk}"
    else:
        ex = "examples/l1_param_inv.icl" if T["level"] == "l1" else "agents/l2/example_pdp.icl"
        lvl = "level 1 (`stdcell`: the template provides rails, taps and the n-well)" if T["level"] == "l1" \
            else "level 2 (`cell`: PCells, matching patterns, placement, routing)"
        how = f"""
## How: write it in ICL
Use the ICL layout language, {lvl}. Reference: `{ROOT}/AGENTS.md`; worked example `{ROOT}/{ex}`.
Declare exactly `param {pl}` (the checker sets these) and use the parameters in the device lines.
`{ROOT}/bin/icl check <file> --top {task}` gives quick feedback against your own device lines; use
`--out {d}/build` so parallel runs do not share a build directory.
"""
        check = f"    {chk}"
        if cond == "icl1":
            names = retrieved(T, task, d)
            lessons = "lessons_stdcell_v3.md" if T["level"] == "l1" else "lessons_l2.md"
            shutil.copy(os.path.join(ROOT, "agents", lessons), os.path.join(d, "lessons.md"))
            how += f"""
## Extra help available in this run
- `{d}/lessons.md`: notes from reviewing many earlier attempts on this benchmark - read and follow them.
- Verified layouts of similar cells (clean over the whole parameter sweep): {', '.join(f'`{d}/verified_{n}.icl`' for n in names)}.
- Diagnosis: add `--ranked` to the checker - it names the statements/objects/lines behind each error,
  measured gaps vs. rule values, opens/shorts by object name, and concrete edits.
- `{ROOT}/bin/icl inspect <file> --top {task}` lists every object's position and size.
- Robustness: `{chk.split(' --log')[0]} --sweep --log {d}` checks the parameter sweep (L, widths, height);
  make the layout follow the parameters so the sweep is clean too.
- Keep a copy of your best clean version; if a change makes things worse, go back to it.
"""
            check = f"    {chk} --ranked"
    tail = f"""
## Checking (this is also the final score)
{check}
It runs magic DRC (full), netgen LVS against the reference netlist above{', the layout constraints' if T['level'] == 'l2' else ' and the rail checks'};
it prints the problems and logs every run to {d}/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN{' (and the sweep is clean, if you can get it there)' if cond == 'icl1' else ''},
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
{FORBID}

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
"""
    return head + how + tail


if __name__ == "__main__":
    for model in ("haiku", "sonnet"):
        for cond in ("raw", "icl0", "icl1"):
            for task in TASKS:
                d = os.path.join(ROOT, "agent_compare2", f"{model}-{cond}-{task}")
                os.makedirs(d, exist_ok=True)
                open(os.path.join(d, "TASK.md"), "w").write(task_md(task, cond, d))
                print(d)
