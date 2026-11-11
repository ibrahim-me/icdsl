# Task: SKY130 layout of `comp_latch`

Function: StrongARM comparator with an SR (NAND2) output latch, drawn mirror-symmetric
Top cell name: `comp_latch`.  Deliver: `/comp_latch.icl`

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
Use the ICL layout language, level 2 (`cell`: PCells, matching patterns, placement, routing). Reference: `/AGENTS.md`; worked example `/examples/example_pdp.icl`.
Declare exactly `param W=1.0 L=0.15` (the checker sets these) and use the parameters in the device lines.

## Extra help available in this run
- `/lessons.md`: notes from reviewing many earlier attempts on this benchmark - read and follow them.
- Verified layouts of similar cells (clean over the whole parameter sweep): `/verified_strongarm.icl`, `/verified_diff_stage.icl`.
- check_layout gives a ranked diagnosis: it names the statements/objects/lines behind each error,
  measured gaps vs. rule values, opens/shorts by object name, and concrete edits.
- `inspect_layout(path)` lists every object's position and size.
- Robustness: `check_sweep(path)` checks the parameter sweep (L, widths, height);
  make the layout follow the parameters so the sweep is clean too.
- Keep a copy of your best clean version; if a change makes things worse, go back to it.

## Checking (this is also the final score)
Call `check_layout('/comp_latch.icl')`: magic DRC (full), netgen LVS against the reference netlist and the layout checks; it prints the problems. Use it as often as your budget allows.

## Budget and rules
Stop as soon as the checker says CLEAN (and the sweep is clean, if you can get it there),
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Work only in this workspace.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
