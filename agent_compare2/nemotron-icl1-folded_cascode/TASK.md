# Task: SKY130 layout of `folded_cascode`

Function: folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load
Top cell name: `folded_cascode`.  Deliver: `/folded_cascode.icl`

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
Use the ICL layout language, level 2 (`cell`: PCells, matching patterns, placement, routing). Reference: `/AGENTS.md`; worked example `/examples/example_pdp.icl`.
Declare exactly `param W=1.0 L=0.5` (the checker sets these) and use the parameters in the device lines.

## Extra help available in this run
- `/lessons.md`: notes from reviewing many earlier attempts on this benchmark - read and follow them.
- Verified layouts of similar cells (clean over the whole parameter sweep): `/verified_ota2s.icl`, `/verified_cascode_n.icl`.
- check_layout gives a ranked diagnosis: it names the statements/objects/lines behind each error,
  measured gaps vs. rule values, opens/shorts by object name, and concrete edits.
- `inspect_layout(path)` lists every object's position and size.
- Robustness: `check_sweep(path)` checks the parameter sweep (L, widths, height);
  make the layout follow the parameters so the sweep is clean too.
- Keep a copy of your best clean version; if a change makes things worse, go back to it.

## Checking (this is also the final score)
Call `check_layout('/folded_cascode.icl')`: magic DRC (full), netgen LVS against the reference netlist and the layout checks; it prints the problems. Use it as often as your budget allows.

## Budget and rules
Stop as soon as the checker says CLEAN (and the sweep is clean, if you can get it there),
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Work only in this workspace.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
