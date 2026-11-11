Lay out the analog cell `cm_n`: 1:1 NMOS current mirror (M1 diode-connected reference, M2 output).
```icl
pdk sky130A
param W=1.0 L=0.5

cell cm_n
  port IREF in side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=IOUT g=IREF s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry):
  1. M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
It is checked at the nominal parameters and then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.