pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP  in  side=left
  port INN  in  side=left
  port VBP  in  side=top
  port VBN  in  side=top
  port VCN  in  side=top
  port VCP  in  side=top
  port OUT  out side=right
  port VPWR power side=top
  port VGND ground side=bottom

  # Tail current source (PMOS, 4 fingers)
  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR

  # Input differential pair (PMOS, 2 fingers each) - common centroid
  pmos M1 w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2 w=W l=L nf=2 d=f2 g=INN s=tail

  # NMOS input pair (2 fingers each) - interdigitated ABBA, source=VGND
  nmos M3 w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4 w=W l=L nf=2 d=f2 g=VBN s=VGND

  # NMOS cascode pair (2 fingers each) - interdigitated ABBA
  nmos M5 w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6 w=W l=L nf=2 d=OUT g=VCN s=f2

  # PMOS cascode mirror devices (2 fingers each) - interdigitated ABBA
  pmos M7 w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8 w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9 w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  # Matching structures
  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=1 name=INV
  interdigitate M5 M6 pattern=ABBA dummies=1 name=CASN
  interdigitate M7 M8 pattern=ABBA dummies=1 name=CASP1
  interdigitate M9 M10 pattern=ABBA dummies=1 name=CASP2

  # Placement: tail at top, input pair below it
  place MT at=(0, 0)
  place DP below=MT align=center gap=0.6

  # NMOS row below the input pair
  place INV below=DP align=center gap=0.6

  # NMOS cascode to the right of INV
  place CASN right_of=INV align=bottom gap=0.6

  # PMOS cascode devices above the NMOS cascode
  place CASP1 above=CASN align=center gap=0.6
  place CASP2 right_of=CASP1 align=center gap=0.6

  # Substrate taps
  tap TP kind=ptap net=VGND
  tap TN kind=ntap net=VPWR
  place TP below=INV align=center gap=0.3
  place TN right_of=CASP2 align=center gap=0.3

  # Guard rings for PMOS n-wells
  guardring GR1 around=[MT, DP] kind=ntap net=VPWR space=0.3
  guardring GR2 around=[CASP1, CASP2] kind=ntap net=VPWR space=0.3

  # Routing
  route tail width=0.4
  route f1 width=0.3 avoid=INP:0.5,INN:0.5
  route f2 width=0.3 avoid=INP:0.5,INN:0.5
  route x width=0.3
  route y width=0.3
  route z width=0.3
  route OUT width=0.3 avoid=INP:0.5,INN:0.5
end
