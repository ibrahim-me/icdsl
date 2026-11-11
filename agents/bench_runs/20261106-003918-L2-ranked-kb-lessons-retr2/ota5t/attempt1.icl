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

  interdigitate M1 M2 pattern=ABBA dummies=0 name=DIFF
  common_centroid M3 M4 pattern=AB/BA dummies=0 name=LOAD

  tap TP kind=ptap net=VGND cols=16
  place TP at=(0, 0)
  place MT above=TP align=center
  place DIFF above=MT align=center gap=0.6

  tap TN kind=ntap net=VPWR cols=16
  place LOAD above=DIFF align=center gap=0.6
  place TN above=LOAD align=center gap=0.6

  route tail width=0.4
  route OUT avoid=INN:0.5
end
