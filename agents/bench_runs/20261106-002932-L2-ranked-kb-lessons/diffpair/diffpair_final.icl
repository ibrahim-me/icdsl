pdk sky130A
param W=1.0 L=0.5

cell diffpair
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port OUTP out side=top
  port OUTN out side=top
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=DP
  place DP at=(0, 0)
  place MT above=DP align=center gap=min
  tap TP kind=ptap net=VGND cols=2
  place TP below=DP align=center gap=min

  route tail width=0.3
end
