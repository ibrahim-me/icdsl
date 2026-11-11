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

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DIFF
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD

  place DIFF at=(0,0)
  place LOAD right_of=DIFF align=center gap=1.20
  place MT below=DIFF align=center gap=1.20
  place M6 right_of=LOAD align=center gap=min
  place M7 below=M6 align=center gap=1.27

  guardring GR_P around=[LOAD, M6] kind=ntap net=VPWR
  guardring GR_N around=[MT, M7] kind=ptap net=VGND

  route OUT width=0.3 avoid=INP:0.6,INN:0.6
  route tail width=0.3
  route x width=0.3
  route o1 width=0.3
end
