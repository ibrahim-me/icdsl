#!/usr/bin/env python3
"""Write TASK.md for every (model, condition, task) run of the ICL vs raw-GDS comparison."""
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "bench"))
sys.path.insert(0, os.path.join(ROOT, "agents"))
import agent_check as AC  # noqa: E402

RULES = """Key SKY130 rules (um): poly width >= L, poly spacing 0.21, poly extends 0.13 past diffusion (endcap),
diffusion extends 0.25 past a gate when a contact sits there; diff/tap width 0.15, diff spacing 0.27
(also to taps); transistor width >= 0.42. licon (contact) exactly 0.17 x 0.17, spacing 0.17;
diff encloses licon by 0.04 (0.06 on one axis); licon to gate 0.055; poly encloses a poly licon by 0.05
(0.08 on one axis); poly licon to diffusion 0.19 (0.235 to p-diffusion); npc (95/20) encloses poly
licons by 0.1. li width/spacing 0.17, li encloses licon by 0.08 on one axis. mcon 0.17 x 0.17, spacing
0.19; met1 width/spacing 0.14, met1 encloses mcon by 0.03 (0.06 on one axis), met1 min area 0.083 um2.
via 0.15 x 0.15, met1/met2 enclose via by 0.055/0.085 on one axis; met2 width/spacing 0.14.
nsdm/psdm enclose diff/tap by 0.125, nsdm and psdm must not overlap; n-diffusion (nmos, ptap) needs
nsdm/psdm as appropriate: nmos diff in nsdm, pmos diff in psdm, ptap (p+ tap) in psdm, ntap (n+ tap)
in nsdm. n-well encloses p-diffusion by 0.18 and n-taps by 0.18; n-diffusion stays 0.34 away from the
n-well; n-well width 0.84, spacing 1.27. Every n-well needs an n-tap and every p-diffusion must be within
15 um of one (latch-up); nmos bodies (substrate) need a p-tap. All coordinates on the 0.005 um grid.
The PDK's own rule decks are in pdk/sky130A/libs.tech/ (magic tech file, KLayout DRC) if you need more."""

LAYERS = """GDS layers (layer/datatype): nwell 64/20, diff 65/20, tap 65/44, poly 66/20, licon 66/44, npc 95/20,
nsdm 93/44, psdm 94/20, li 67/20, mcon 67/44, met1 68/20, via 68/44, met2 69/20.
Net labels: a GDS text with the net name on 67/5 (li), 68/5 (met1) or 69/5 (met2), placed on a shape of
that layer. PORTS additionally need a pin shape + the same text on the pin datatype (li 67/16, met1 68/16,
met2 69/16) - magic only extracts subcircuit pins from the pin datatype. Every port needs one."""

FORBID = """Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/ (other than your own directory), /tmp/drafts, /tmp/l2refs, and the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file."""


def devices_text(T):
    lines = []
    for d in T["cell"]["devices"]:
        if T["level"] == "l1":
            w, l, nf = T["pv"][d["wparam"]], T["pv"]["L"], 1
        else:
            w, l, nf = T["pv"][d["w"]], T["pv"][d["l"]], d["nf"]
        lines.append(f"  {d['name']}: {d['kind']}  W={w} um per finger x {nf} finger(s), L={l} um   "
                     f"drain={d['d']} gate={d['g']} source={d['s']}  (body = {'VGND' if d['kind'] == 'nmos' else 'VPWR'})")
    return "\n".join(lines)


def task_md(task, cond, rundir):
    T = AC.task_spec(task)
    c = T["cell"]
    ext = "icl" if cond == "icl" else "gds"
    fn = c['function'] if task != "ota5t_small" else \
        "5-transistor OTA: NMOS input pair M1/M2, PMOS current-mirror load M3/M4, NMOS tail MT"
    head = f"""# Task: SKY130 layout of `{task}`

Function: {fn}
Top cell name: `{task}`.  Deliver: `{rundir}/{task}.{ext}`

Transistors (fixed - LVS compares against exactly this netlist):
{devices_text(T)}
"""
    if T["level"] == "l1":
        head += f"""
Ports: inputs {', '.join(c['inputs'])}; output {', '.join(c['outputs'])}; supplies VPWR, VGND.
Standard-cell frame: cell height 2.72 um measured between the rail centres; a VGND met1 rail across the
whole cell width centred on y=0 and a VPWR met1 rail centred on y=2.72 (labelled VGND / VPWR); nmos at
the bottom, pmos at the top in an n-well; the cell carries its own body taps (p-tap under the VGND rail,
n-tap under the VPWR rail, connected to the rails); signal pins as labelled met1 shapes; cell width a
multiple of 0.46 um. Narrower is better, but clean comes first.
"""
    else:
        cons = "\n".join(f"  - {x}" for x in [
            "M1 and M2 interdigitated: all their fingers in ONE row, alternating (e.g. ABBA), equal centroids",
            "M3 and M4 interdigitated in the same sense",
            "footprint (bounding box of diff/tap/poly/licon/li/mcon/met1/via/met2) at most 70 um2"])
        head += f"""
Ports: INP, INN, VBN (inputs), OUT (output), VPWR (power), VGND (ground) - each labelled.
Layout constraints, measured on your geometry by the checker:
{cons}
Dummy transistors (drain = source) are allowed and ignored by LVS.
"""
    check = (f"cd {ROOT} && .venv/bin/python bench/agent_check.py {rundir}/{task}.{ext} {task} --log {rundir}")
    if cond == "icl":
        lvl = "level 1 (`stdcell` blocks: the template already provides rails, taps and the n-well)" \
            if T["level"] == "l1" else "level 2 (`cell` blocks: PCells, matching patterns, placement, routing)"
        allowed = "examples/l1_param_inv.icl" if T["level"] == "l1" else "agents/l2/example_pdp.icl"
        pl = " ".join(f"{k}={v}" for k, v in T["pv"].items())
        how = f"""
## How: write it in ICL
Use the ICL layout language, {lvl}. Read `{ROOT}/AGENTS.md` (the language reference) and the
worked example `{ROOT}/{allowed}` - no other example files. Put `pdk sky130A` and the device lines in
your file; the top block must be named `{task}`. For detailed feedback use
`{ROOT}/bin/icl check <file> --top {task}` (DRC + LVS against your own device lines, object names in
errors) and `bin/icl inspect`. The checker passes the parameters {pl} with --param, so declare
exactly `param {pl}` in your file and use them in the device lines.
"""
    else:
        how = f"""
## How: draw raw GDS (no layout language)
Write the GDS yourself, e.g. with Python and KLayout's API (`{ROOT}/.venv/bin/python`, `import klayout.db`),
placing every rectangle with explicit coordinates. Do NOT use the ICL tools (bin/icl, the icdsl package,
AGENTS.md, examples/) - this run measures layout without them.
{LAYERS}

{RULES}
"""
    tail = f"""
## Checking (this is also the final score)
    {check}
It runs magic DRC (full), netgen LVS against the reference netlist above, and the layout checks; it
prints the problems and logs every run to {rundir}/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN, or after 30 checker runs / about 45 minutes of work; keep the
best version at the deliverable path. {FORBID}

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
"""
    return head + how + tail


if __name__ == "__main__":
    for model in ("sonnet", "haiku"):
        for cond in ("icl", "raw"):
            for task in ("nand3", "a21oi", "ota5t_small"):
                d = os.path.join(ROOT, "agent_compare", f"{model}-{cond}-{task}")
                os.makedirs(d, exist_ok=True)
                open(os.path.join(d, "TASK.md"), "w").write(task_md(task, cond, d))
                print(d)
