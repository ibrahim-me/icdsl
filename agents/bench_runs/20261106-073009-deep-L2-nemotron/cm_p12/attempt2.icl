pdk sky130A
param W=1.0 L=0.5

cell cm_p12
  port IREF in side=left
  port IOUT out side=right
  port VPWR power

  pmos M1 w=W l=L nf=2 d=IREF g=IREF s=VPWR
  pmos M2 w=W l=L nf=4 d=IOUT g=IREF s=VPWR

  interdigitate M1 M2 pattern=ABBBBA name=CM
  place CM at=(0,0)

  tap T kind=ntap net=VPWR cols=6
  place T above=CM gap=min align=center

  route IREF width=0.4
  route IOUT width=0.4
  route VPWR width=0.4
end
