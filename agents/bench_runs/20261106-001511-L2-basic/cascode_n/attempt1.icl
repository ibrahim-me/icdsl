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

  interdigitate M1 M2 pattern=ABBA dummies=1 name=M12
  interdigitate M3 M4 pattern=ABBA dummies=1 name=M34

  place M12 at=(0,0)
  place M34 above=M12 align=center gap=min

  tap TP kind=ptap net=VGND cols=2
  place TP below=M12 align=center gap=min

  route n1 width=0.3
  route n2 width=0.3
  route IREF width=0.3
  route IOUT width=0.3
  route VGND width=0.5
end
