# Task: analog cell `diffpair`

Function: NMOS differential pair with tail current source
Write the layout to `/diffpair.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell diffpair`):
```icl
pdk sky130A
param W=1.0 L=0.5

cell diffpair
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port OUTP out side=top
  port OUTN out side=top
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
  2. net tail routed with wires at least 0.3 um wide (narrow necks at pins are fine)
Checked at the nominal parameters, then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.
