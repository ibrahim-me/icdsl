```icl
pdk sky130A
param W=1.0 L=0.5

cell ota5t_small
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
  interdigitate M3 M4 pattern=ABBA dummies=1 name=PLOAD

  place DIFF at=(0,0)
  place PLOAD above=DIFF align=center gap=min
  place MT below=DIFF align=center gap=min

  guardring GP around=[DIFF, MT] kind=ptap net=VGND
  guardring GN around=[PLOAD] kind=ntap net=VPWR

  route INP width=0.2
  route INN width=0.2
  route VBN width=0.2
  route OUT width=0.2
  route x width=0.2
  route tail width=0.2
  route VPWR width=0.4
  route VGND width=0.4
end
```