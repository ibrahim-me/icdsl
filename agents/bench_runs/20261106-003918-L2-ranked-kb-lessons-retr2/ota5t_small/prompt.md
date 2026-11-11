Lay out the analog cell `ota5t_small`: 5-transistor OTA as ota5t, but inside an area budget.
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
Layout constraints (measured on the drawn geometry):
  1. M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  2. M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  3. cell area (bounding box) within the budget: W=1.0,L=0.5: 86.0 um2, W=1.0,L=1.0: 117.0 um2, W=1.0,L=0.15: 55.0 um2, W=2.0,L=0.5: 113.0 um2
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

Verified example `cm_n` (1:1 NMOS current mirror (M1 diode-connected reference, M2 output); constraints: M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)) - clean over the whole sweep:
```icl
# 1:1 NMOS current mirror, ABBA with dummies
pdk sky130A
param W=1.0 L=0.5

cell cm_n
  port IREF in  side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=IOUT g=IREF s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=CM
  tap TP kind=ptap net=VGND cols=6
  place TP at=(0, 0)
  place CM above=TP align=center
end
```