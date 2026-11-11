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

  interdigitate M1 M2 pattern=ABBA dummies=0 name=IP
  common_centroid M3 M4 pattern=AB/BA dummies=0 name=PL

  place MT at=(0,0)
  place IP above=MT align=center gap=min
  place PL above=IP align=center gap=min

  tap PT kind=ptap net=VGND cols=2
  place PT below=MT align=center gap=min

  tap NT kind=ntap net=VPWR cols=2
  place NT above=PL align=center gap=min

  route tail width=0.4
  route OUT avoid=INN:0.5
  route VPWR width=0.4
  route VGND width=0.4
end
```