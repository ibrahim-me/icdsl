# Two-stage OTA: 5T first stage (2x2 common-centroid pair and load), PMOS CS second stage
pdk sky130A
param W=1.0 L=0.5

cell ota2s
  port INP  in  side=left
  port INN  in  side=left
  port VBN  in  side=left
  port OUT  out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x    g=INP s=tail
  nmos M2 w=W l=L nf=2 d=o1   g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x    g=x   s=VPWR
  pmos M4 w=W l=L nf=2 d=o1   g=x   s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND
  pmos M6 w=W l=L nf=4 d=OUT  g=o1  s=VPWR
  nmos M7 w=W l=L nf=4 d=OUT  g=VBN s=VGND

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  common_centroid M3 M4 pattern=AB/BA dummies=1 name=LOAD
  tap TP kind=ptap net=VGND cols=16
  place TP at=(0, 0)
  place MT above=TP align=left
  place M7 right_of=MT gap=1.0
  place DP above=MT align=center gap=0.6
  place LOAD above=DP align=center gap=0.8
  place M6 right_of=LOAD align=bottom
  tap TN kind=ntap net=VPWR cols=16
  place TN above=LOAD align=left gap=0.6

  tap TN2 kind=ntap net=VPWR cols=4
  place TN2 above=M6 align=center

  route OUT width=0.3 avoid=INP:0.8,INN:0.8
end
