# Task: SKY130 layout of `nand3`

Function: Y = !(A & B & C)
Top cell name: `nand3`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-nand3/nand3.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  M0: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=A source=Y  (body = VPWR)
  M1: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=n1 gate=B source=n2  (body = VGND)
  M2: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=VGND gate=C source=n1  (body = VGND)
  M3: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=n2 gate=A source=Y  (body = VGND)
  M4: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=C source=Y  (body = VPWR)
  M5: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=Y gate=B source=VPWR  (body = VPWR)

Ports: inputs A, B, C; output Y; supplies VPWR, VGND.
Standard-cell frame: cell height 2.72 um measured between the rail centres; a VGND met1 rail across the
whole cell width centred on y=0 and a VPWR met1 rail centred on y=2.72 (labelled VGND / VPWR); nmos at
the bottom, pmos at the top in an n-well; the cell carries its own body taps (p-tap under the VGND rail,
n-tap under the VPWR rail, connected to the rails); signal pins as labelled met1 shapes; cell width a
multiple of 0.46 um. Narrower is better, but clean comes first.

## How: write it in ICL
Use the ICL layout language, level 1 (`stdcell` blocks: the template already provides rails, taps and the n-well). Read `/home/ibrahim/claude-workspace/icdsl/AGENTS.md` (the language reference) and the
worked example `/home/ibrahim/claude-workspace/icdsl/examples/l1_param_inv.icl` - no other example files. Put `pdk sky130A` and the device lines in
your file; the top block must be named `nand3`. For detailed feedback use
`/home/ibrahim/claude-workspace/icdsl/bin/icl check <file> --top nand3` (DRC + LVS against your own device lines, object names in
errors) and `bin/icl inspect`. The checker passes the parameters L=0.15 H=2.72 WN=0.49 WP=0.75 with --param, so declare
exactly `param L=0.15 H=2.72 WN=0.49 WP=0.75` in your file and use them in the device lines.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-nand3/nand3.icl nand3 --log /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-nand3
It runs magic DRC (full), netgen LVS against the reference netlist above, and the layout checks; it
prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-nand3/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN, or after 30 checker runs / about 45 minutes of work; keep the
best version at the deliverable path. Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/ (other than your own directory), /tmp/drafts, /tmp/l2refs, and the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
