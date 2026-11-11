# Task: analog cell `diff_stage`

Function: fully differential stage: NMOS pair, PMOS current-source loads, NMOS tail - drawn mirror-symmetric with guard rings
Write the layout to `/diff_stage.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell diff_stage`):
```icl
pdk sky130A
param W=1.0 L=0.3

cell diff_stage
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port VBP in side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos M3 w=W l=L nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=W l=L nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4
  2. the routing of OUTP is the mirror image of the routing of OUTN
  3. a closed ptap guard ring around M1, M2, MT
  4. a closed ntap guard ring around M3, M4
Checked at the nominal parameters, then at: W=1.0, L=0.6; W=1.0, L=0.15; W=2.0, L=0.3.
