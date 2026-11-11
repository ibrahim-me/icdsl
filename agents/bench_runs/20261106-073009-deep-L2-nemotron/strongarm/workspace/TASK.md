# Task: analog cell `strongarm`

Function: StrongARM latch comparator, drawn mirror-symmetric
Write the layout to `/strongarm.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell strongarm`):
```icl
pdk sky130A
param W=1.0 L=0.15

cell strongarm
  port CLK in side=bottom
  port INP in side=left
  port INN in side=right
  port OUTP out side=top
  port OUTN out side=top
  port VPWR power
  port VGND ground

  nmos M0 w=W l=L nf=4 d=tail g=CLK s=VGND
  nmos M1 w=W l=L nf=2 d=P g=INP s=tail
  nmos M2 w=W l=L nf=2 d=Q g=INN s=tail
  nmos M3 w=W l=L d=OUTN g=OUTP s=P
  nmos M4 w=W l=L d=OUTP g=OUTN s=Q
  pmos M5 w=W l=L d=OUTN g=OUTP s=VPWR
  pmos M6 w=W l=L d=OUTP g=OUTN s=VPWR
  pmos M7 w=W l=L d=OUTN g=CLK s=VPWR
  pmos M8 w=W l=L d=OUTP g=CLK s=VPWR
  pmos M9 w=W l=L d=P g=CLK s=VPWR
  pmos M10 w=W l=L d=Q g=CLK s=VPWR

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4, M5/M6, M7/M8, M9/M10
Checked at the nominal parameters, then at: W=1.0, L=0.3; W=1.0, L=0.3; W=2.0, L=0.15.
