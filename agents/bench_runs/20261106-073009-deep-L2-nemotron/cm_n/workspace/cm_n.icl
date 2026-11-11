pdk sky130A
param W=1.0 L=0.5

cell cm_n
  port IREF in side=left
  port IOUT out side=right
  port VGND ground

  nmos M1 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=IOUT g=IREF s=VGND

  interdigitate M1 M2 pattern=ABBA name=CM
  place CM at=(0,0)

  tap PT kind=ptap net=VGND cols=2
  place PT below=CM align=center gap=min

  route IREF
  route IOUT
  route VGND
end
