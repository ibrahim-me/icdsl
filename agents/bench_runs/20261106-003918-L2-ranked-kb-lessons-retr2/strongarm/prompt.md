Lay out the analog cell `strongarm`: StrongARM latch comparator, drawn mirror-symmetric.
```icl
pdk sky130A
param W=1.0 L=0.15

cell strongarm
  port CLK in side=bottom
  port INP in side=left
  port INN in side=right
  port OUTP out side=top
  port OUTN out side=top
  port VPWR power
  port VGND ground

  nmos M0 w=W l=L nf=4 d=tail g=CLK s=VGND
  nmos M1 w=W l=L nf=2 d=P g=INP s=tail
  nmos M2 w=W l=L nf=2 d=Q g=INN s=tail
  nmos M3 w=W l=L d=OUTN g=OUTP s=P
  nmos M4 w=W l=L d=OUTP g=OUTN s=Q
  pmos M5 w=W l=L d=OUTN g=OUTP s=VPWR
  pmos M6 w=W l=L d=OUTP g=OUTN s=VPWR
  pmos M7 w=W l=L d=OUTN g=CLK s=VPWR
  pmos M8 w=W l=L d=OUTP g=CLK s=VPWR
  pmos M9 w=W l=L d=P g=CLK s=VPWR
  pmos M10 w=W l=L d=Q g=CLK s=VPWR

  <patterns, placement, taps, routing>
end
```
Layout constraints (measured on the drawn geometry):
  1. mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4, M5/M6, M7/M8, M9/M10
It is checked at the nominal parameters and then at: W=1.0, L=0.3; W=1.0, L=0.3; W=2.0, L=0.15.

Verified example `folded_cascode` (folded-cascode OTA: PMOS input pair + PMOS tail, NMOS current sinks, NMOS cascodes, PMOS cascoded mirror load; constraints: M1, M2 on a common centroid: the centroids of their fingers coincide; M3 and M4 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M5 and M6 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M7 and M8 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); M9 and M10 interdigitated: all their fingers in ONE row, alternating, with equal centroids (ABBA-like); routed wires of OUT and INP at least 0.5 um apart; routed wires of OUT and INN at least 0.5 um apart) - clean over the whole sweep:
```icl
# Folded-cascode OTA: PMOS pair (2x2 common centroid) on a PMOS tail, NMOS sinks and cascodes
# interdigitated, PMOS cascoded mirror interdigitated, output kept off the inputs
pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP  in  side=left
  port INN  in  side=right
  port VBP  in  side=top
  port VBN  in  side=bottom
  port VCN  in  side=left
  port VCP  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  pmos MT  w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1  w=W l=L nf=2 d=f1   g=INP s=tail
  pmos M2  w=W l=L nf=2 d=f2   g=INN s=tail
  nmos M3  w=W l=L nf=2 d=f1   g=VBN s=VGND
  nmos M4  w=W l=L nf=2 d=f2   g=VBN s=VGND
  nmos M5  w=W l=L nf=2 d=x    g=VCN s=f1
  nmos M6  w=W l=L nf=2 d=OUT  g=VCN s=f2
  pmos M7  w=W l=L nf=2 d=y    g=x   s=VPWR
  pmos M8  w=W l=L nf=2 d=z    g=x   s=VPWR
  pmos M9  w=W l=L nf=2 d=x    g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT  g=VCP s=z

  interdigitate M3 M4 pattern=ABBA dummies=1 name=SINK
  interdigitate M5 M6 pattern=ABBA dummies=1 name=CASN
  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  interdigitate M7 M8 pattern=ABBA dummies=1 name=MIR
  interdigitate M9 M10 pattern=ABBA dummies=1 name=CASP

  tap TP kind=ptap net=VGND cols=10
  place TP at=(0, 0)
  place SINK above=TP align=center
  place CASN above=SINK align=center
  place MIR right_of=SINK align=bottom gap=1.0
  place CASP above=MIR align=center
  guardring GP around=[MIR, CASP] kind=ntap net=VPWR
  place DP above=CASN align=center gap=1.0
  place MT above=DP align=center
  tap TN2 kind=ntap net=VPWR cols=8
  place TN2 above=MT align=center

  route OUT avoid=INP:0.6,INN:0.6
end
```

Verified example `diff_stage` (fully differential stage: NMOS pair, PMOS current-source loads, NMOS tail - drawn mirror-symmetric with guard rings; constraints: mirror symmetry about ONE vertical axis for the pairs M1/M2, M3/M4; the routing of OUTP is the mirror image of the routing of OUTN; a closed ptap guard ring around M1, M2, MT; a closed ntap guard ring around M3, M4) - clean over the whole sweep:
```icl
# Fully differential stage, mirror-symmetric, guard rings, mirror-image output routing
pdk sky130A
param W=1.0 L=0.3

cell diff_stage
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=bottom
  port VBP  in  side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos M3 w=W l=L nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=W l=L nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  place MT at=(0, 0)
  pair  M1 M2 axis=MT.cx above=MT
  pair  M3 M4 axis=MT.cx above=M1 vgap=2.0
  guardring GN around=[MT, M1, M2] kind=ptap net=VGND
  guardring GP around=[M3, M4] kind=ntap net=VPWR

  route OUTN OUTP symmetric axis=MT.cx
end
```