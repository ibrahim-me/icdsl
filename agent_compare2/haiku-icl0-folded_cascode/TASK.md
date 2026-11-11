# Task: SKY130 layout of `folded_cascode`

Function: folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load
Top cell name: `folded_cascode`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-icl0-folded_cascode/folded_cascode.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  MT: pmos  W=1.0 um per finger x 4 finger(s), L=0.5 um   drain=tail gate=VBP source=VPWR  (body = VPWR)
  M1: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=f1 gate=INP source=tail  (body = VPWR)
  M2: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=f2 gate=INN source=tail  (body = VPWR)
  M3: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=f1 gate=VBN source=VGND  (body = VGND)
  M4: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=f2 gate=VBN source=VGND  (body = VGND)
  M5: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=x gate=VCN source=f1  (body = VGND)
  M6: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=OUT gate=VCN source=f2  (body = VGND)
  M7: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=y gate=x source=VPWR  (body = VPWR)
  M8: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=z gate=x source=VPWR  (body = VPWR)
  M9: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=x gate=VCP source=y  (body = VPWR)
  M10: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=OUT gate=VCP source=z  (body = VPWR)

Ports: INP, INN, VBP, VBN, VCN, VCP, OUT, VPWR, VGND - each labelled.
Layout constraints, measured on your geometry by the checker:
  - M1, M2 on a common centroid: the centroids of their fingers coincide
  - M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  - M5 and M6 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  - M7 and M8 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  - M9 and M10 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  - routed wires of OUT and INP at least 0.5 um apart
  - routed wires of OUT and INN at least 0.5 um apart
Dummy transistors (drain = source) are allowed and ignored by LVS.

## How: write it in ICL
Use the ICL layout language, level 2 (`cell`: PCells, matching patterns, placement, routing). Reference: `/home/ibrahim/claude-workspace/icdsl/AGENTS.md`; worked example `/home/ibrahim/claude-workspace/icdsl/agents/l2/example_pdp.icl`.
Declare exactly `param W=1.0 L=0.5` (the checker sets these) and use the parameters in the device lines.
`/home/ibrahim/claude-workspace/icdsl/bin/icl check <file> --top folded_cascode` gives quick feedback against your own device lines; use
`--out /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-icl0-folded_cascode/build` so parallel runs do not share a build directory.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-icl0-folded_cascode/folded_cascode.icl folded_cascode --log /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-icl0-folded_cascode
It runs magic DRC (full), netgen LVS against the reference netlist above, the layout constraints;
it prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-icl0-folded_cascode/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/, agent_compare2/ (other than your own directory), /tmp (any of it), the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file. Do not launch other agents.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
