pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP in side=left
  port INN in side=left
  port VBP in side=top
  port VBN in side=left
  port VCN in side=left
  port VCP in side=top
  port OUT out side=right
  port VPWR power
  port VGND ground

  pmos MT  w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1  w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2  w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3  w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4  w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5  w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6  w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7  w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8  w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9  w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=1 name=SNK
  interdigitate M5 M6 pattern=ABBA dummies=1 name=CN
  interdigitate M7 M8 pattern=ABBA dummies=1 name=LD
  interdigitate M9 M10 pattern=ABBA dummies=1 name=CP

  place MT at=(0, 0)
  place DP below=MT align=center gap=0.6
  place LD right_of=MT gap=1.0 align=top
  place CP below=LD align=center gap=0.6
  guardring GN around=[MT, DP, LD, CP] kind=ntap net=VPWR

  place SNK below=GN align=left gap=1.5
  place CN right_of=SNK gap=0.8 align=top
  guardring GP around=[SNK, CN] kind=ptap net=VGND
end
