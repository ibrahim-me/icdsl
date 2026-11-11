The matched devices are placed in single interdigitated and common-centroid blocks, with body taps and the required tail width / OUT–INN spacing.

```icl
pdk sky130A
param W=1.0 L=0.5

cell ota5t
  port INP in side=left
  port INN in side=right
  port VBN in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=DIFF
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD

  place DIFF at=(0,0)
  place LOAD above=DIFF align=center gap=0.6
  place MT below=DIFF align=center gap=0.6

  tap TP kind=ptap net=VGND cols=2
  place TP below=MT align=center gap=0.6

  tap TN kind=ntap net=VPWR cols=2
  place TN above=LOAD align=center gap=0.6

  route tail width=0.4
  keepout OUT INN dist=0.5
end
```