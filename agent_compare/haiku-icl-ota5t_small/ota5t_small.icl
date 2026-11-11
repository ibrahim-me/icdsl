pdk sky130A
param W=1.0 L=0.5

cell ota5t_small
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x   g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x   g=x   s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT g=x   s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  interdigitate M1 M2 pattern=ABBA dummies=1 name=DP
  interdigitate M3 M4 pattern=ABBA dummies=1 name=LOAD

  tap TP kind=ptap net=VGND cols=8
  place TP at=(0, 0)
  place MT above=TP align=center
  place DP above=MT align=center
  place LOAD above=DP align=center gap=0.8
  tap TN kind=ntap net=VPWR cols=8
  place TN above=LOAD align=center

  route tail width=0.4
  route OUT width=0.3
end
