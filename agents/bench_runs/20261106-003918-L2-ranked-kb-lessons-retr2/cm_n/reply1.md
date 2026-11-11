```icl
pdk sky130A
param W=1.0 L=0.5

cell cm_n
  port IREF in side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=IOUT g=IREF s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=CM
  tap TP kind=ptap net=VGND cols=6
  place TP at=(0, 0)
  place CM above=TP align=center

  route IREF width=0.4
  route IOUT width=0.4
end
```