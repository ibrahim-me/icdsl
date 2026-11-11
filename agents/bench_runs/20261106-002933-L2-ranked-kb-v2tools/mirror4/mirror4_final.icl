pdk sky130A
param W=1.0 L=1.0

cell mirror4
  port IREF in side=left
  port I1 out side=right
  port I2 out side=right
  port I3 out side=right
  port VGND ground

  nmos M0 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M1 w=W l=L nf=2 d=I1 g=IREF s=VGND
  nmos M2 w=W l=L nf=2 d=I2 g=IREF s=VGND
  nmos M3 w=W l=L nf=2 d=I3 g=IREF s=VGND

  common_centroid M0 M1 M2 M3 pattern=ABCD/DCBA dummies=1 name=CM
  place CM at=(0,0)
  guardring GR around=[CM] kind=ptap net=VGND
end
