# Task: analog cell `ota5t_small`

Function: 5-transistor OTA as ota5t, but inside an area budget
Write the layout to `/ota5t_small.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell ota5t_small`):
```icl
pdk sky130A
param W=1.0 L=0.5

cell ota5t_small
  port INP in side=left
  port INN in side=right
  port VBN in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  2. M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  3. cell area (bounding box) within the budget: W=1.0,L=0.5: 86.0 um2, W=1.0,L=1.0: 117.0 um2, W=1.0,L=0.15: 55.0 um2, W=2.0,L=0.5: 113.0 um2
Checked at the nominal parameters, then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.
