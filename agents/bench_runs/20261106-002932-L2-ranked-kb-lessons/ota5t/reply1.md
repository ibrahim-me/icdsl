```icl
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

  interdigitate M1 M2 pattern=ABBA dummies=0 name=DP
  common_centroid M3 M4 pattern=AB/BA dummies=0 name=CM

  place DP at=(0, 0)
  place CM above=DP align=center gap=min
  place MT below=DP align=center gap=min

  tap TP kind=ptap net=VGND cols=2 below=MT align=center gap=min
  tap TN kind=ntap net=VPWR cols=2 above=CM align=center gap=min

  route tail width=0.4
  route INN width=0.2
  route OUT width=0.2 avoid=INN:0.5
  route VPWR width=0.4
  route VGND width=0.4
end
```