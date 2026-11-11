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

  # Matching patterns
  common_centroid M1 M2 pattern=AB/BA dummies=0 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=0 name=CS
  interdigitate M5 M6 pattern=ABBA dummies=0 name=CN
  interdigitate M7 M8 pattern=ABBA dummies=0 name=CP1
  interdigitate M9 M10 pattern=ABBA dummies=0 name=CP2

  # Placement: NMOS rows at bottom, PMOS rows at top
  place MT at=(0, 0)
  place DP below=MT align=center gap=min
  place CS below=DP align=center gap=min
  place CN below=CS align=center gap=min
  place CP1 above=MT align=center gap=min
  place CP2 above=CP1 align=center gap=min

  # Taps
  tap TN kind=ptap net=VGND cols=4
  tap TP kind=ntap net=VPWR cols=4
  place TN below=CN align=center gap=min
  place TP above=CP2 align=center gap=min

  # Guard rings
  guardring GN around=[CS, CN] kind=ptap net=VGND
  guardring GP around=[DP, CP1, CP2, MT] kind=ntap net=VPWR

  # Routing
  route tail width=0.4
  route f1 width=0.2
  route f2 width=0.2
  route x width=0.2
  route OUT width=0.2 avoid=INP:0.5,INN:0.5
  route INP width=0.2
  route INN width=0.2
  route VPWR width=0.4
  route VGND width=0.4
  route VBP width=0.2
  route VBN width=0.2
  route VCN width=0.2
  route VCP width=0.2
end
