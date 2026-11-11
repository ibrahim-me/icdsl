# Task: SKY130 layout of `comp_latch`

Function: StrongARM comparator with an SR (NAND2) output latch, drawn mirror-symmetric
Top cell name: `comp_latch`.  Deliver: `/comp_latch.rect`

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

## How: draw raw GDS (no layout language)
Raw layout format (write it to /comp_latch.rect; check_layout converts it to GDS):
    rect  <layer> x0 y0 x1 y1        a drawn rectangle, coordinates in um (x0 < x1, y0 < y1)
    label <layer> x y NAME           net name (a text on that layer)
    pin   <layer> x0 y0 x1 y1 NAME   a port: pin rectangle + name (put it on top of a drawn shape)
    # comment
layers: nwell diff tap poly licon npc nsdm psdm li mcon met1 via met2
No layout language: every shape is an explicit rectangle.
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
Call `check_layout('/comp_latch.rect')`: magic DRC (full), netgen LVS against the reference netlist and the layout checks; it prints the problems. Use it as often as your budget allows.

## Budget and rules
Stop as soon as the checker says CLEAN,
or after 40 checker runs / about 60 minutes of work; keep the best version at the deliverable path.
Work only in this workspace.

## Report (your final message)
Final checker status (copy its first lines), number of checker runs, the main difficulties (2-4 sentences).
