# Task: SKY130 layout of `ha`

Function: half adder: SUM = A ^ B, COUT = A & B
Top cell name: `ha`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-ha/ha.gds`

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

## How: draw raw GDS (no layout language)
Write the GDS yourself, e.g. with Python and KLayout's API (`/home/ibrahim/claude-workspace/icdsl/.venv/bin/python`, `import klayout.db`),
placing every rectangle with explicit coordinates. Do NOT use the ICL tools (bin/icl, the icdsl package,
AGENTS.md, examples/).
GDS layers (layer/datatype): nwell 64/20, diff 65/20, tap 65/44, poly 66/20, licon 66/44, npc 95/20,
nsdm 93/44, psdm 94/20, li 67/20, mcon 67/44, met1 68/20, via 68/44, met2 69/20.
Net labels: a GDS text with the net name on 67/5 (li), 68/5 (met1) or 69/5 (met2), placed on a shape of
that layer. PORTS additionally need a pin shape + the same text on the pin datatype (li 67/16, met1 68/16,
met2 69/16) - magic only extracts subcircuit pins from the pin datatype. Every port needs one.

Key SKY130 rules (um): poly width >= L, poly spacing 0.21, poly extends 0.13 past diffusion (endcap),
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
The PDK's own rule decks are in pdk/sky130A/libs.tech/ (magic tech file, KLayout DRC) if you need more.

## Checking (this is also the final score)
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-ha/ha.gds ha --log /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-ha
It runs magic DRC (full), netgen LVS against the reference netlist above and the rail checks;
it prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare2/sonnet-raw-ha/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/, agent_compare2/ (other than your own directory), /tmp (any of it), the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file. Do not launch other agents.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
