Lay out the analog cell `ota5t`: 5-transistor OTA: NMOS input pair, PMOS mirror load, NMOS tail.
```icl
pdk sky130A
param W=1.0 L=0.5

cell ota5t
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
Layout constraints (measured on the drawn geometry):
  1. M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  2. M3, M4 on a common centroid: the centroids of their fingers coincide
  3. routed wires of OUT and INN at least 0.5 um apart
  4. net tail routed with wires at least 0.4 um wide (narrow necks at pins are fine)
It is checked at the nominal parameters and then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.