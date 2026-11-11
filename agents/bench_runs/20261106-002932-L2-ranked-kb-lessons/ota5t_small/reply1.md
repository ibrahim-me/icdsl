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

  # matched input pair: one shared diffusion row, ABBA, equal centroids
  interdigitate M1 M2 pattern=ABBA dummies=0 name=DIFF
  # matched current-mirror load: one shared diffusion row, ABBA, equal centroids
  interdigitate M3 M4 pattern=ABBA dummies=0 name=LOAD

  # stack: pmos load row over nmos diff row, tail device below the diff row
  place DIFF at=(0, 0)
  place LOAD above=DIFF align=center gap=min
  place MT below=DIFF align=center gap=min

  # substrate tie for the nmos devices, inside the same p-substrate region
  tap TP kind=ptap net=VGND cols=2
  place TP below=MT align=center gap=min
  # n-well tie for the pmos load, inside the same n-well island
  tap TN kind=ntap net=VPWR cols=2
  place TN above=LOAD align=center gap=min

  route INP width=0.2
  route INN width=0.2
  route VBN width=0.2
  route OUT width=0.2
  route tail width=0.4
  route x width=0.4
end
```