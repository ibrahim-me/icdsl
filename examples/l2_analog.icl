# Level 2 - analog assembly from PCells: matching patterns, explicit placement, routing intent
pdk sky130A

# 5T OTA with an interdigitated input pair and a common-centroid load mirror
cell ota_matched
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=1.0 l=0.5 nf=2 d=x    g=INP s=tail
  nmos M2 w=1.0 l=0.5 nf=2 d=OUT  g=INN s=tail
  pmos M3 w=1.0 l=0.5 nf=2 d=x    g=x   s=VPWR
  pmos M4 w=1.0 l=0.5 nf=2 d=OUT  g=x   s=VPWR
  nmos MT w=1.0 l=0.5 nf=4 d=tail g=VBN s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=DP          # shared tail source in the middle
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD      # 2x2 common centroid

  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place MT above=TP align=center
  place DP above=MT align=center
  place LOAD above=DP align=center gap=0.8
  tap TN kind=ntap net=VPWR cols=8
  place TN above=LOAD align=center

  route tail width=0.4 maxres=10                 # wide, low-resistance tail
  route OUT  width=0.3 avoid=INN:0.6,INP:0.6      # keep the output away from the inputs
  limit coupling OUT INN max=0.05                 # fF, sidewall estimate
  route VBN shield=VGND                           # shield the bias line with ground wires
end

# Differential stage: mirrored pairs, guard rings, mirror-image routing of the outputs
cell diff_stage
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=bottom
  port VBP  in  side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=1.0 l=0.3 nf=2 d=OUTN g=INP s=tail
  nmos M2 w=1.0 l=0.3 nf=2 d=OUTP g=INN s=tail
  pmos M3 w=1.0 l=0.3 nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=1.0 l=0.3 nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=1.0 l=0.3 nf=4 d=tail g=VBN s=VGND

  place MT at=(0, 0)
  pair  M1 M2 axis=MT.cx above=MT               # M2 = mirror image of M1, minimum legal spacing
  pair  M3 M4 axis=MT.cx above=M1 vgap=2.0     # vgap leaves room for both guard rings
  guardring GN around=[MT, M1, M2] kind=ptap net=VGND
  guardring GP around=[M3, M4] kind=ntap net=VPWR

  route OUTN OUTP symmetric axis=MT.cx           # OUTP is routed as the exact mirror of OUTN
  wire  VBP layer=m2 width=0.2 from=M3.g to=M4.g  # hand-directed: 0.2 um wide, met2 only
  route VBN width=0.2 avoid=OUTN:1.0,OUTP:1.0      # 0.2 um wide and at least 1 um from the outputs
end
