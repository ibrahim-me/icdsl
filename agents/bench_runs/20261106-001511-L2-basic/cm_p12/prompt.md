Lay out the analog cell `cm_p12`: 1:2 PMOS current mirror (M1 reference, M2 = 2x output).
```icl
pdk sky130A
param W=1.0 L=0.5

cell cm_p12
  port IREF in side=left
  port IOUT out side=right
  port VPWR power

  pmos M1 w=W l=L nf=2 d=IREF g=IREF s=VPWR
  pmos M2 w=W l=L nf=4 d=IOUT g=IREF s=VPWR

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
It is checked at the nominal parameters and then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.