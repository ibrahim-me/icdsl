# Task: SKY130 layout of `maj3`

Function: X = majority(A, B, C) = AB + BC + CA
Top cell name: `maj3`.  Deliver: `/maj3.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  M0: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n1 gate=A source=VPWR  (body = VPWR)
  M1: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n2 gate=B source=n3  (body = VGND)
  M2: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=B source=n4  (body = VGND)
  M3: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=VGND gate=n3 source=X  (body = VGND)
  M4: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=VGND gate=A source=n2  (body = VGND)
  M5: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n5 gate=A source=VGND  (body = VGND)
  M6: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=B source=n6  (body = VPWR)
  M7: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n6 gate=C source=VPWR  (body = VPWR)
  M8: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=n3 source=X  (body = VPWR)
  M9: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n4 gate=C source=VGND  (body = VGND)
  M10: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=C source=n5  (body = VGND)
  M11: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=C source=n1  (body = VPWR)
  M12: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=A source=n7  (body = VPWR)
  M13: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n7 gate=B source=n3  (body = VPWR)

Ports: inputs A, B, C; outputs X; supplies VPWR, VGND.
Standard-cell frame: cell height 2.72 um between the rail centres; a VGND met1 rail across the whole cell
width centred on y=0 and a VPWR met1 rail centred on y=2.72 (labelled); nmos at the bottom, pmos at the top
in an n-well; the cell carries its own body taps (p-tap under VGND, n-tap under VPWR); signal pins on met1;
cell width a multiple of 0.46 um. The cell must also TILE: copies of it placed edge to edge (and mirrored)
must stay DRC clean, so keep wells/implants/shapes inside the cell or symmetric at its edges.

## How: write it in ICL
Use the ICL layout language, level 1 (`stdcell`: the template provides rails, taps and the n-well). Reference: `/AGENTS.md`; worked example `/examples/l1_param_inv.icl`.
Declare exactly `param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42` (the checker sets these) and use the parameters in the device lines.

## Extra help available in this run
- `/lessons.md`: notes from reviewing many earlier attempts on this benchmark - read and follow them.
- Verified layouts of similar cells (clean over the whole parameter sweep): `/verified_mux2i.icl`, `/verified_xor2.icl`.
- check_layout gives a ranked diagnosis: it names the statements/objects/lines behind each error,
  measured gaps vs. rule values, opens/shorts by object name, and concrete edits.
- `inspect_layout(path)` lists every object's position and size.
- Robustness: `check_sweep(path)` checks the parameter sweep (L, widths, height);
  make the layout follow the parameters so the sweep is clean too.
- Keep a copy of your best clean version; if a change makes things worse, go back to it.

## Checking (this is also the final score)
Call `check_layout('/maj3.icl')`: magic DRC (full), netgen LVS against the reference netlist and the layout checks; it prints the problems. Use it as often as your budget allows.

## Budget and rules
Stop as soon as the checker says CLEAN (and the sweep is clean, if you can get it there),
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Work only in this workspace.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
