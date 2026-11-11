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
