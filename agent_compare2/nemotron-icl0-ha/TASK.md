# Task: SKY130 layout of `ha`

Function: half adder: SUM = A ^ B, COUT = A & B
Top cell name: `ha`.  Deliver: `/ha.icl`

Transistors (fixed - LVS compares against exactly this netlist):
  M0: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n1 gate=B source=n2  (body = VGND)
  M1: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=n1 source=n4  (body = VGND)
  M2: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n1 gate=A source=VPWR  (body = VPWR)
  M3: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=n1 source=COUT  (body = VPWR)
  M4: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=VGND gate=A source=n4  (body = VGND)
  M5: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n3 gate=B source=n5  (body = VPWR)
  M6: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n5 gate=A source=VPWR  (body = VPWR)
  M7: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=SUM gate=n3 source=VGND  (body = VGND)
  M8: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n2 gate=A source=VGND  (body = VGND)
  M9: pmos  W=0.75 um per finger x 1 finger(s), L=0.15 um   drain=SUM gate=n3 source=VPWR  (body = VPWR)
  M10: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=n1 source=n3  (body = VPWR)
  M11: nmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=n4 gate=B source=VGND  (body = VGND)
  M12: nmos  W=0.49 um per finger x 1 finger(s), L=0.15 um   drain=VGND gate=n1 source=COUT  (body = VGND)
  M13: pmos  W=0.42 um per finger x 1 finger(s), L=0.15 um   drain=VPWR gate=B source=n1  (body = VPWR)

Ports: inputs A, B; outputs COUT, SUM; supplies VPWR, VGND.
Standard-cell frame: cell height 2.72 um between the rail centres; a VGND met1 rail across the whole cell
width centred on y=0 and a VPWR met1 rail centred on y=2.72 (labelled); nmos at the bottom, pmos at the top
in an n-well; the cell carries its own body taps (p-tap under VGND, n-tap under VPWR); signal pins on met1;
cell width a multiple of 0.46 um. The cell must also TILE: copies of it placed edge to edge (and mirrored)
must stay DRC clean, so keep wells/implants/shapes inside the cell or symmetric at its edges.

## How: write it in ICL
Use the ICL layout language, level 1 (`stdcell`: the template provides rails, taps and the n-well). Reference: `/AGENTS.md`; worked example `/examples/l1_param_inv.icl`.
Declare exactly `param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42` (the checker sets these) and use the parameters in the device lines.

## Checking (this is also the final score)
Call `check_layout('/ha.icl')`: magic DRC (full), netgen LVS against the reference netlist and the layout checks; it prints the problems. Use it as often as your budget allows.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Work only in this workspace.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
