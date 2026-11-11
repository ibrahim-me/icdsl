pdk sky130A
param W=1.0 L=0.5

cell cm_p12
  port IREF in side=left
  port IOUT out side=right
  port VPWR power

  pmos M1 w=W l=L nf=2 d=IREF g=IREF s=VPWR
  pmos M2 w=W l=L nf=4 d=IOUT g=IREF s=VPWR

  common_centroid M1 M2 pattern=ABB/BBA dummies=0 name=CM
  place CM at=(0, 0)
  tap TN kind=ntap net=VPWR cols=2
  place TN above=CM align=center gap=min

  route IREF width=0.4
  route IOUT width=0.4
  route VPWR width=0.4
end
