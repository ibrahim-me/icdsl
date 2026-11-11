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

  # PMOS tail current source
  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR

  # PMOS input pair (common centroid)
  pmos M1 w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2 w=W l=L nf=2 d=f2 g=INN s=tail

  # NMOS current sinks (interdigitated)
  nmos M3 w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4 w=W l=L nf=2 d=f2 g=VBN s=VGND

  # NMOS cascodes (interdigitated)
  nmos M5 w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6 w=W l=L nf=2 d=OUT g=VCN s=f2

  # PMOS cascoded mirror load
  pmos M7 w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8 w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9 w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  # Matching structures
  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=1 name=CS
  interdigitate M5 M6 pattern=ABBA dummies=1 name=CA
  interdigitate M7 M8 pattern=ABBA dummies=1 name=MIR
  interdigitate M9 M10 pattern=ABBA dummies=1 name=CC

  # Taps
  tap TP kind=ptap net=VGND cols=16
  tap TN kind=ntap net=VPWR cols=16

  # Placement: NMOS at bottom, PMOS at top
  place TP at=(0, 0)
  place CS above=TP align=center
  place CA above=CS align=center gap=0.6
  place DP above=CA align=center gap=0.6
  place MT above=DP align=center gap=0.6
  place TN above=MT align=center gap=0.6
  place MIR above=TN align=center gap=0.6
  place CC above=MIR align=center gap=0.6

  # Routing
  route tail width=0.4
  route f1 width=0.3 avoid=INP:0.5,INN:0.5
  route f2 width=0.3 avoid=INP:0.5,INN:0.5
  route x width=0.3
  route OUT width=0.3 avoid=INP:0.5,INN:0.5
end
