# Task: SKY130 layout of `comp_latch`

Function: StrongARM comparator with an SR (NAND2) output latch, drawn mirror-symmetric
Top cell name: `comp_latch`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-icl0-comp_latch/comp_latch.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  M0: nmos  W=1.0 um per finger x 4 finger(s), L=0.15 um   drain=tail gate=CLK source=VGND  (body = VGND)
  M1: nmos  W=1.0 um per finger x 2 finger(s), L=0.15 um   drain=P gate=INP source=tail  (body = VGND)
  M2: nmos  W=1.0 um per finger x 2 finger(s), L=0.15 um   drain=Q gate=INN source=tail  (body = VGND)
  M3: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTN gate=OUTP source=P  (body = VGND)
  M4: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTP gate=OUTN source=Q  (body = VGND)
  M5: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTN gate=OUTP source=VPWR  (body = VPWR)
  M6: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTP gate=OUTN source=VPWR  (body = VPWR)
  M7: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTN gate=CLK source=VPWR  (body = VPWR)
  M8: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=OUTP gate=CLK source=VPWR  (body = VPWR)
  M9: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=P gate=CLK source=VPWR  (body = VPWR)
  M10: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=Q gate=CLK source=VPWR  (body = VPWR)
  MN11: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QP gate=OUTN source=m1  (body = VGND)
  MN12: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=m1 gate=QN source=VGND  (body = VGND)
  MP11: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QP gate=OUTN source=VPWR  (body = VPWR)
  MP12: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QP gate=QN source=VPWR  (body = VPWR)
  MN21: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QN gate=OUTP source=m2  (body = VGND)
  MN22: nmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=m2 gate=QP source=VGND  (body = VGND)
  MP21: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QN gate=OUTP source=VPWR  (body = VPWR)
  MP22: pmos  W=1.0 um per finger x 1 finger(s), L=0.15 um   drain=QN gate=QP source=VPWR  (body = VPWR)

Ports: CLK, INP, INN, QP, QN, VPWR, VGND - each labelled.
Layout constraints, measured on your geometry by the checker:
  - mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4, M5/M6, M7/M8, M9/M10, MN11/MN21, MN12/MN22, MP11/MP21, MP12/MP22
Dummy transistors (drain = source) are allowed and ignored by LVS.

## How: write it in ICL
Use the ICL layout language, level 2 (`cell`: PCells, matching patterns, placement, routing). Reference: `/home/ibrahim/claude-workspace/icdsl/AGENTS.md`; worked example `/home/ibrahim/claude-workspace/icdsl/agents/l2/example_pdp.icl`.
Declare exactly `param W=1.0 L=0.15` (the checker sets these) and use the parameters in the device lines.
`/home/ibrahim/claude-workspace/icdsl/bin/icl check <file> --top comp_latch` gives quick feedback against your own device lines; use
`--out /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-icl0-comp_latch/build` so parallel runs do not share a build directory.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-icl0-comp_latch/comp_latch.icl comp_latch --log /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-icl0-comp_latch
It runs magic DRC (full), netgen LVS against the reference netlist above, the layout constraints;
it prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-icl0-comp_latch/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/, agent_compare2/ (other than your own directory), /tmp (any of it), the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file. Do not launch other agents.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
