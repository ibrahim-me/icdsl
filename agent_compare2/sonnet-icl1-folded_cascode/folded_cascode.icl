pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP  in  side=left
  port INN  in  side=left
  port VBP  in  side=left
  port VBN  in  side=left
  port VCN  in  side=left
  port VCP  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  pmos MT  w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1  w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2  w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3  w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4  w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5  w=W l=L nf=2 d=x  g=VCN s=f1
  nmos M6  w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7  w=W l=L nf=2 d=y  g=x   s=VPWR
  pmos M8  w=W l=L nf=2 d=z  g=x   s=VPWR
  pmos M9  w=W l=L nf=2 d=x  g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  interdigitate M3 M4 pattern=ABBA dummies=1 name=N1
  interdigitate M5 M6 pattern=ABBA dummies=1 name=N2
  interdigitate M7 M8 pattern=ABBA dummies=1 name=P1
  interdigitate M9 M10 pattern=ABBA dummies=1 name=P2
  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP

  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place N1 above=TP align=center
  place N2 above=N1 align=center gap=0.6
  place P2 above=N2 align=center gap=0.8
  tap TM kind=ntap net=VPWR cols=8
  place TM above=P2 align=center gap=0.6
  place P1 above=TM align=center gap=0.6
  place DP above=P1 align=center gap=0.6
  place MT above=DP align=center gap=0.6
  tap TN kind=ntap net=VPWR cols=8
  place TN above=MT align=center gap=0.6

  route OUT width=0.3 avoid=INP:0.8,INN:0.8
end
