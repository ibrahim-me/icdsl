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

  interdigitate M1 M2 pattern=ABBA name=P12
  interdigitate M3 M4 pattern=ABBA name=P34
  place P12 at=(0, 0)
  place P34 above=P12 align=center gap=min
  guardring GR around=[P12, P34] kind=ptap net=VGND

  route VGND width=0.4
  route n1 width=0.4
  route n2 width=0.4
  route IREF width=0.4
  route IOUT width=0.4
end
```