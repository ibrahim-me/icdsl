Lay out the analog cell `folded_cascode`: folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load.
```icl
pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP in side=left
  port INN in side=right
  port VBP in side=top
  port VBN in side=bottom
  port VCN in side=left
  port VCP in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1 w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2 w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3 w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4 w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5 w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6 w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7 w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8 w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9 w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry):
  1. M1, M2 on a common centroid: the centroids of their fingers coincide
  2. M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  3. M5 and M6 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  4. M7 and M8 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  5. M9 and M10 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like)
  6. routed wires of OUT and INP at least 0.5 um apart
  7. routed wires of OUT and INN at least 0.5 um apart
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

Verified example `strongarm` (StrongARM latch comparator, drawn mirror-symmetric; constraints: mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4, M5/M6, M7/M8, M9/M10) - clean over the whole sweep:
```icl
# StrongARM latch comparator, every pair mirrored about the tail's centre line
pdk sky130A
param W=1.0 L=0.15

cell strongarm
  port CLK  in  side=bottom
  port INP  in  side=left
  port INN  in  side=right
  port OUTP out side=top
  port OUTN out side=top
  port VPWR power
  port VGND ground

  nmos M0  w=W l=L nf=4 d=tail g=CLK  s=VGND
  nmos M1  w=W l=L nf=2 d=P    g=INP  s=tail
  nmos M2  w=W l=L nf=2 d=Q    g=INN  s=tail
  nmos M3  w=W l=L      d=OUTN g=OUTP s=P
  nmos M4  w=W l=L      d=OUTP g=OUTN s=Q
  pmos M5  w=W l=L      d=OUTN g=OUTP s=VPWR
  pmos M6  w=W l=L      d=OUTP g=OUTN s=VPWR
  pmos M7  w=W l=L      d=OUTN g=CLK  s=VPWR
  pmos M8  w=W l=L      d=OUTP g=CLK  s=VPWR
  pmos M9  w=W l=L      d=P    g=CLK  s=VPWR
  pmos M10 w=W l=L      d=Q    g=CLK  s=VPWR

  tap TP kind=ptap net=VGND cols=12
  place TP at=(0, 0)
  place M0 above=TP align=center
  pair M1 M2 axis=M0.cx above=M0 vgap=0.6
  pair M3 M4 axis=M0.cx above=M1 vgap=0.6
  pair M5 M6 axis=M0.cx above=M3 vgap=1.6
  pair M7 M8 axis=M0.cx above=M5 vgap=0.6
  pair M9 M10 axis=M0.cx above=M7 vgap=0.6
  guardring GP around=[M5, M6, M7, M8, M9, M10] kind=ntap net=VPWR
end
```