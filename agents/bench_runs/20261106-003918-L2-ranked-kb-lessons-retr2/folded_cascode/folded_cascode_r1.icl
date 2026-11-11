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

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=0 name=M34
  interdigitate M5 M6 pattern=ABBA dummies=0 name=M56
  interdigitate M7 M8 pattern=ABBA dummies=0 name=M78
  interdigitate M9 M10 pattern=ABBA dummies=0 name=M910

  tap TP kind=ptap net=VGND cols=24
  place TP at=(0, 0)
  place M56 above=TP align=center gap=min
  place M34 above=M56 align=center gap=min
  place DP above=M34 align=center gap=0.6
  place MT above=DP align=center gap=0.6
  tap TN kind=ntap net=VPWR cols=24
  place TN above=MT align=center gap=min
  place M78 right_of=MT align=center gap=0.6
  tap TN2 kind=ntap net=VPWR cols=24
  place TN2 right_of=M78 align=center gap=min
  place M910 right_of=TN2 align=center gap=min
  tap TN3 kind=ntap net=VPWR cols=24
  place TN3 right_of=M910 align=center gap=min

  route tail width=0.4
  route f1 width=0.4 avoid=OUT:0.5
  route f2 width=0.4 avoid=OUT:0.5
  route x width=0.4 avoid=OUT:0.5
  route y width=0.4 avoid=OUT:0.5
  route z width=0.4 avoid=OUT:0.5
  route OUT width=0.4 avoid=INP:0.5,INN:0.5
end
