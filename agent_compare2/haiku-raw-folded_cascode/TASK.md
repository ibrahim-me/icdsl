# Task: SKY130 layout of `folded_cascode`

Function: folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load
Top cell name: `folded_cascode`.  Deliver: `/home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-folded_cascode/folded_cascode.gds`

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
    cd /home/ibrahim/claude-workspace/icdsl && .venv/bin/python bench/agent_check.py /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-folded_cascode/folded_cascode.gds folded_cascode --log /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-folded_cascode
It runs magic DRC (full), netgen LVS against the reference netlist above, the layout constraints;
it prints the problems and logs every run to /home/ibrahim/claude-workspace/icdsl/agent_compare2/haiku-raw-folded_cascode/checks.jsonl. Run it as often as you like.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Do NOT read or copy: bench/l2_ref/, bench/compare_img/, agents/bench_runs/, agents/sticks.py,
agents/coach/, agent_compare/, agent_compare2/ (other than your own directory), /tmp (any of it), the
sky130_fd_sc_hd library layouts (pdk/.../sky130_fd_sc_hd gds/mag/lef/maglef) - they contain solutions.
Write only inside your own directory; do not modify any other file. Do not launch other agents.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
