# Task: analog cell `ota2s`

Function: two-stage OTA (no compensation cap): 5T first stage + PMOS common-source second stage with NMOS current-source load
Write the layout to `/ota2s.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell ota2s`):
```icl
pdk sky130A
param W=1.0 L=0.5

cell ota2s
  port INP in side=left
  port INN in side=left
  port VBN in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=o1 g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=o1 g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND
  pmos M6 w=W l=L nf=4 d=OUT g=o1 s=VPWR
  nmos M7 w=W l=L nf=4 d=OUT g=VBN s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
  2. M3, M4 on a common centroid: the centroids of their fingers coincide
  3. net OUT routed with wires at least 0.3 um wide (narrow necks at pins are fine)
  4. routed wires of OUT and INP at least 0.6 um apart
  5. routed wires of OUT and INN at least 0.6 um apart
Checked at the nominal parameters, then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.
