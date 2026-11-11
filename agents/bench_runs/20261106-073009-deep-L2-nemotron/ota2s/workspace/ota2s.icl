pdk sky130A
param W=1.0 L=0.5

cell ota2s
  port INP in side=left
  port INN in side=left
  port VBN in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=o1 g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=o1 g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND
  pmos M6 w=W l=L nf=4 d=OUT g=o1 s=VPWR
  nmos M7 w=W l=L nf=4 d=OUT g=VBN s=VGND

  # Tail current source at origin
  place MT at=(0, 0)

  # Differential pair M1/M2: 2x2 common centroid, placed above MT
  common_centroid M1 M2 pattern=AB/BA name=DIFF
  place DIFF above=MT align=center gap=min

  # Current mirror load M3/M4: 2x2 common centroid, placed above DIFF
  common_centroid M3 M4 pattern=AB/BA name=LOAD
  place LOAD above=DIFF align=center gap=min

  # Second stage: M6 (PMOS CS) above LOAD, M7 (NMOS load) below MT
  place M6 above=LOAD align=center gap=min
  place M7 below=MT align=center gap=min

  # Taps: ptap for NMOS, ntap for PMOS well
  tap TPT kind=ptap net=VGND cols=4
  place TPT below=M7 align=center gap=min
  tap TNT kind=ntap net=VPWR cols=4
  place TNT above=M6 align=center gap=min

  # Guard ring around everything
  guardring GR around=[MT, DIFF, LOAD, M6, M7] kind=ptap net=VGND space=0.3

  # Routing
  route tail width=0.4
  route x width=0.4
  route o1 width=0.4
  route OUT width=0.3 avoid=INP:0.6,INN:0.6
end
