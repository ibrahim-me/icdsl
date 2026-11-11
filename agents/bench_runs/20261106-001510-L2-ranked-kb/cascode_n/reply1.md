Here is the complete ICL file for `cascode_n`.

```icl
pdk sky130A
param W=1.0 L=0.5

cell cascode_n
  port IREF in side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=n1 g=n1 s=VGND
  nmos M2 w=W l=L nf=2 d=n2 g=n1 s=VGND
  nmos M3 w=W l=L nf=2 d=IREF g=IREF s=n1
  nmos M4 w=W l=L nf=2 d=IOUT g=IREF s=n2

  interdigitate M1 M2 pattern=ABBA dummies=1 name=BOT
  interdigitate M3 M4 pattern=ABBA dummies=1 name=TOP
  place BOT at=(0,0)
  place TOP above=BOT align=center gap=min
  guardring G around=[BOT, TOP] kind=ptap net=VGND

  route VGND width=0.4
  route n1 width=0.4
  route n2 width=0.4
  route IREF width=0.4
  route IOUT width=0.4
end
```