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

Verified example `ota2s` (two-stage OTA (no compensation cap): 5T first stage + PMOS common-source second stage with NMOS current-source load; constraints: M1, M2 on a common centroid: the centroids of their fingers coincide; M3, M4 on a common centroid: the centroids of their fingers coincide; net OUT routed with wires at least 0.3 um wide (narrow necks at pins are fine); routed wires of OUT and INP at least 0.6 um apart; routed wires of OUT and INN at least 0.6 um apart) - clean over the whole sweep:
```icl
# Two-stage OTA: 5T first stage (2x2 common-centroid pair and load), PMOS CS second stage
pdk sky130A
param W=1.0 L=0.5

cell ota2s
  port INP  in  side=left
  port INN  in  side=left
  port VBN  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x    g=INP s=tail
  nmos M2 w=W l=L nf=2 d=o1   g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x    g=x   s=VPWR
  pmos M4 w=W l=L nf=2 d=o1   g=x   s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND
  pmos M6 w=W l=L nf=4 d=OUT  g=o1  s=VPWR
  nmos M7 w=W l=L nf=4 d=OUT  g=VBN s=VGND

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD
  tap TP kind=ptap net=VGND cols=16
  place TP at=(0, 0)
  place MT above=TP align=left
  place M7 right_of=MT gap=1.0
  place DP above=MT align=center gap=0.6
  place LOAD above=DP align=center gap=0.8
  place M6 right_of=LOAD align=bottom
  tap TN kind=ntap net=VPWR cols=16
  place TN above=LOAD align=left gap=0.6

  tap TN2 kind=ntap net=VPWR cols=4
  place TN2 above=M6 align=center

  route OUT width=0.3 avoid=INP:0.8,INN:0.8
end
```

Verified example `diffpair` (NMOS differential pair with tail current source; constraints: M1, M2 on a common centroid: the centroids of their fingers coincide; net tail routed with wires at least 0.3 um wide (narrow necks at pins are fine)) - clean over the whole sweep:
```icl
# NMOS differential pair (2x2 common centroid) on a 4-finger tail
pdk sky130A
param W=1.0 L=0.5

cell diffpair
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=bottom
  port OUTP out side=top
  port OUTN out side=top
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place MT above=TP align=center
  place DP above=MT align=center gap=0.6
  route tail width=0.3
end
```