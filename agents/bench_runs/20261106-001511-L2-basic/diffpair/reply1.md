```icl
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
  place DP at=(0,0)
  tap TP kind=ptap net=VGND cols=2
  place TP below=DP align=center gap=min
  place MT below=TP align=center gap=min

  route tail width=0.3
  route INP width=0.2
  route INN width=0.2
  route VBN width=0.2
  route OUTP width=0.2
  route OUTN width=0.2
  route VGND width=0.3
end
```