Lay out the analog cell `ota2s`: two-stage OTA (no compensation cap): 5T first stage + PMOS common-source second stage with NMOS current-source load.
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
Layout constraints (measured on the drawn geometry):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
  2. M3, M4 on a common centroid: the centroids of their fingers coincide
  3. net OUT routed with wires at least 0.3 um wide (narrow necks at pins are fine)
  4. routed wires of OUT and INP at least 0.6 um apart
  5. routed wires of OUT and INN at least 0.6 um apart
It is checked at the nominal parameters and then at: W=1.0, L=1.0; W=1.0, L=0.15; W=2.0, L=0.5.

Verified example `ota5t` (5-transistor OTA: NMOS input pair, PMOS mirror load, NMOS tail; constraints: M1 and M2 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M3, M4 on a common centroid: the centroids of their fingers coincide; routed wires of OUT and INN at least 0.5 um apart; net tail routed with wires at least 0.4 um wide (narrow necks at pins are fine)) - clean over the whole sweep:
```icl
# 5T OTA: interdigitated input pair, common-centroid load mirror, wide tail, output kept off the inputs
pdk sky130A
param W=1.0 L=0.5

cell ota5t
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x    g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT  g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x    g=x   s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT  g=x   s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=DP
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD
  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place MT above=TP align=center
  place DP above=MT align=center
  place LOAD above=DP align=center gap=0.8
  tap TN kind=ntap net=VPWR cols=8
  place TN above=LOAD align=center

  route tail width=0.4
  route OUT  width=0.3 avoid=INN:0.6,INP:0.6
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