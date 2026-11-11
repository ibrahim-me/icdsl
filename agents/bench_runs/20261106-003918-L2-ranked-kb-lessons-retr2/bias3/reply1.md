# NMOS bias mirror: M0 (ref), M1 (1×), M2 (2×) in one 1-D common-centroid row
```icl
pdk sky130A
param W=1.0 L=1.0

cell bias3
  port IREF in side=left
  port I1 out side=right
  port I2 out side=right
  port VGND ground

  nmos M0 w=W l=L nf=2 d=IREF g=IREF s=VGND
  nmos M1 w=W l=L nf=2 d=I1 g=IREF s=VGND
  nmos M2 w=W l=L nf=4 d=I2 g=IREF s=VGND

  interdigitate M0 M1 M2 pattern=ABCCCCBA dummies=1 name=CM
  tap TP kind=ptap net=VGND cols=10
  place CM at=(0, 0)
  place TP below=CM align=center gap=min

  route IREF width=0.3
  route I1 width=0.3
  route I2 width=0.3
  route VGND width=0.3
end
```