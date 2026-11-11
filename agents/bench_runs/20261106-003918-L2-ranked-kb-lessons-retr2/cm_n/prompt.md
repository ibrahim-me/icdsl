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

Verified example `cascode_n` (NMOS cascode current mirror (M1/M2 bottom pair, M3/M4 cascodes); constraints: M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)) - clean over the whole sweep:
```icl
# NMOS cascode current mirror: both pairs interdigitated ABBA, cascodes stacked above
pdk sky130A
param W=1.0 L=0.5

cell cascode_n
  port IREF in  side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=n1   g=n1   s=VGND
  nmos M2 w=W l=L nf=2 d=n2   g=n1   s=VGND
  nmos M3 w=W l=L nf=2 d=IREF g=IREF s=n1
  nmos M4 w=W l=L nf=2 d=IOUT g=IREF s=n2

  interdigitate M1 M2 pattern=ABBA dummies=1 name=BOT
  interdigitate M3 M4 pattern=ABBA dummies=1 name=TOP
  tap TP kind=ptap net=VGND cols=6
  place TP at=(0, 0)
  place BOT above=TP align=center
  place TOP above=BOT align=center gap=0.6
end
```

Verified example `cm_p12` (1:2 PMOS current mirror (M1 reference, M2 = 2x output); constraints: M1, M2 on a common centroid: the centroids of their fingers coincide) - clean over the whole sweep:
```icl
# 1:2 PMOS current mirror: one row B A B B A B (common centroid in 1-D), dummies at both ends
pdk sky130A
param W=1.0 L=0.5

cell cm_p12
  port IREF in  side=left
  port IOUT out side=right
  port VPWR power

  pmos M1 w=W l=L nf=2 d=IREF g=IREF s=VPWR
  pmos M2 w=W l=L nf=4 d=IOUT g=IREF s=VPWR

  interdigitate M1 M2 pattern=BABBAB dummies=1 name=CM
  tap TN kind=ntap net=VPWR cols=8
  place CM at=(0, 0)
  place TN above=CM align=center
end
```