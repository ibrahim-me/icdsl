# Task: SKY130 layout of `ota5t_small`

Function: 5-transistor OTA: NMOS input pair M1/M2, PMOS current-mirror load M3/M4, NMOS tail MT
Top cell name: `ota5t_small`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-ota5t_small/ota5t_small.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  M1: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=x gate=INP source=tail  (body = VGND)
  M2: nmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=OUT gate=INN source=tail  (body = VGND)
  M3: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=x gate=x source=VPWR  (body = VPWR)
  M4: pmos  W=1.0 um per finger x 2 finger(s), L=0.5 um   drain=OUT gate=x source=VPWR  (body = VPWR)
  MT: nmos  W=1.0 um per finger x 4 finger(s), L=0.5 um   drain=tail gate=VBN source=VGND  (body = VGND)

Ports: INP, INN, VBN (inputs), OUT (output), VPWR (power), VGND (ground) - each labelled.
Layout constraints, measured on your geometry by the checker:
  - M1 and M2 interdigitated: all their fingers in ONE row, alternating (e.g. ABBA), equal centroids
  - M3 and M4 interdigitated in the same sense
  - footprint (bounding box of diff/tap/poly/licon/li/mcon/met1/via/met2) at most 70 um2
Dummy transistors (drain = source) are allowed and ignored by LVS.

## How: write it in ICL
Use the ICL layout language, level 2 (`cell` blocks: PCells, matching patterns, placement, routing). Read `/home/ibrahim/claude-workspace/icdsl/AGENTS.md` (the language reference) and the
worked example `/home/ibrahim/claude-workspace/icdsl/agents/l2/example_pdp.icl` - no other example files. Put `pdk sky130A` and the device lines in
your file; the top block must be named `ota5t_small`. For detailed feedback use
`/home/ibrahim/claude-workspace/icdsl/bin/icl check <file> --top ota5t_small` (DRC + LVS against your own device lines, object names in
errors) and `bin/icl inspect`. The checker passes the parameters W=1.0 L=0.5 with --param, so declare
exactly `param W=1.0 L=0.5` in your file and use them in the device lines.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-ota5t_small/ota5t_small.icl ota5t_small --log /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-ota5t_small
It runs magic DRC (full), netgen LVS against the reference netlist above, and the layout checks; it
prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare/haiku-icl-ota5t_small/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN, or after 30 checker runs / about 45 minutes of work; keep the
best version at the deliverable path. Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/ (other than your own directory), /tmp/drafts, /tmp/l2refs, and the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
