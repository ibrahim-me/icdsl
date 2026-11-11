pdk sky130A
param W=1.0 L=0.5

cell ota5t
  port INP in side=left
  port INN in side=right
  port VBN in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  # Matching: NMOS input pair interdigitated ABBA (one row, alternating, equal centroids)
  interdigitate M1 M2 pattern=ABBA name=INP
  # PMOS mirror load: common centroid, finger centroids coincide
  common_centroid M3 M4 pattern=AB/BA name=LOAD

  # Placement: tail at centre, input pair above it, PMOS load above the pair
  place MT at=(0, 0)
  place INP above=MT align=center gap=min
  place LOAD above=INP align=center gap=min

  # Taps: ptap for NMOS region, ntap for PMOS n-well
  tap TP kind=ptap net=VGND cols=4
  tap TN kind=ntap net=VPWR cols=4

  # Guard rings
  guardring GN around=[INP, MT] kind=ptap net=VGND
  guardring GP around=[LOAD] kind=ntap net=VPWR

  # Routing: wide tail, OUT kept 0.5 um away from INN
  route tail width=0.4
  route OUT width=0.2 avoid=INN:0.5
  route INP width=0.2
  route INN width=0.2
  route VBN width=0.2
  route x width=0.2
  route VPWR width=0.2
  route VGND width=0.2
end
