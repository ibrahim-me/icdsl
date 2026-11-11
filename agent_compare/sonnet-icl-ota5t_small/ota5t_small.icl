pdk sky130A
param W=1.0 L=0.5

cell ota5t_small
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port OUT out side=right
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=x g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUT g=INN s=tail
  pmos M3 w=W l=L nf=2 d=x g=x s=VPWR
  pmos M4 w=W l=L nf=2 d=OUT g=x s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  interdigitate M1 M2 pattern=ABBA name=DP
  interdigitate M3 M4 pattern=ABBA name=LD
  place MT at=(0, 0)
  place DP above=MT align=center
  place LD above=DP align=center
  tap TP kind=ptap net=VGND
  tap TN kind=ntap net=VPWR
  place TP right_of=MT
  place TN right_of=LD
end
