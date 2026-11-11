# 1:2 PMOS current mirror: one row B A B B A B (common centroid in 1-D), dummies at both ends
pdk sky130A
param W=1.0 L=0.5

cell cm_p12
  port IREF in  side=left
  port IOUT out side=right
  port VPWR power

  pmos M1 w=W l=L nf=2 d=IREF g=IREF s=VPWR
  pmos M2 w=W l=L nf=4 d=IOUT g=IREF s=VPWR

  interdigitate M1 M2 pattern=BABBAB dummies=1 name=CM
  tap TN kind=ntap net=VPWR cols=8
  place CM at=(0, 0)
  place TN above=CM align=center
end
