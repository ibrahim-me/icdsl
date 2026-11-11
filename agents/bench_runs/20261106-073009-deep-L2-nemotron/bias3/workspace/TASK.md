# Task: analog cell `bias3`

Function: NMOS bias mirror: reference M0, outputs M1 (1x) and M2 (2x), all three on one common centroid
Write the layout to `/bias3.icl`, starting from this skeleton (keep the `pdk`, `param`, `port` and
device lines exactly; the block must be `cell bias3`):
```icl
pdk sky130A
param W=1.0 L=1.0

cell bias3
  port IREF in side=left
  port I1 out side=right
  port I2 out side=right
  port VGND ground

  nmos M0 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M1 w=W l=L nf=2 d=I1 g=IREF s=VGND
  nmos M2 w=W l=L nf=4 d=I2 g=IREF s=VGND

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry by the checker, not taken from your statements):
  1. M0, M1, M2 on a common centroid: the centroids of their fingers coincide
Checked at the nominal parameters, then at: W=1.0, L=2.0; W=1.0, L=0.15; W=2.0, L=1.0.
