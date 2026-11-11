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

  # Interdigitated diff pair (M1, M2) - ABBA pattern, no dummies
  interdigitate M1 M2 pattern=ABBA name=DIFFPAIR dummies=0

  # Interdigitated load (M3, M4) - ABBA pattern, no dummies
  interdigitate M3 M4 pattern=ABBA name=LOAD dummies=0

  # Place tail transistor at origin
  place MT at=(0,0)

  # Place diff pair above MT, centered on MT.cx
  place DIFFPAIR above=MT align=center gap=min

  # Place load directly above diff pair (rows on top of each other, gap=min)
  place LOAD above=DIFFPAIR align=center gap=min

  # Taps: ptap for nmos row, ntap for pmos n-well
  tap Tn kind=ptap net=VGND cols=2
  tap Tp kind=ntap net=VPWR cols=2

  # Place ptap below diff pair (sharing width)
  place Tn below=DIFFPAIR align=center gap=min

  # Place ntap above load (sharing width)
  place Tp above=LOAD align=center gap=min

  # Guard ring around everything
  guardring G around=[MT, DIFFPAIR, LOAD, Tn, Tp] kind=ptap net=VGND

  # Routing
  route tail width=0.4
  route x width=0.4

end
