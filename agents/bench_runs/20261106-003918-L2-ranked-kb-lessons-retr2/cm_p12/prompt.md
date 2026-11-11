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

Verified example `bias3` (NMOS bias mirror: reference M0, outputs M1 (1x) and M2 (2x), all three on one common centroid; constraints: M0, M1, M2 on a common centroid: the centroids of their fingers coincide) - clean over the whole sweep:
```icl
# NMOS bias mirror: reference + 1x + 2x outputs on one 2-row common centroid
pdk sky130A
param W=1.0 L=1.0

cell bias3
  port IREF in  side=left
  port I1   out side=right
  port I2   out side=right
  port VGND ground

  nmos M0 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M1 w=W l=L nf=2 d=I1   g=IREF s=VGND
  nmos M2 w=W l=L nf=4 d=I2   g=IREF s=VGND

  common_centroid M0 M1 M2 pattern=ABCC/CCBA dummies=1 name=CM
  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place CM above=TP align=center
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