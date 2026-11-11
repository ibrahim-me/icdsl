pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP in side=left
  port INN in side=right
  port VBP in side=top
  port VBN in side=bottom
  port VCN in side=left
  port VCP in side=left
  port OUT out side=right
  port VPWR power
  port VGND ground

  pmos MT w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1 w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2 w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3 w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4 w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5 w=W l=L nf=2 d=x g=VCN s=f1
  nmos M6 w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7 w=W l=L nf=2 d=y g=x s=VPWR
  pmos M8 w=W l=L nf=2 d=z g=x s=VPWR
  pmos M9 w=W l=L nf=2 d=x g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  common_centroid M1 M2 pattern=AB/BA dummies=1 name=CC12
  interdigitate M3 M4 pattern=ABBA dummies=1 name=ID34
  interdigitate M5 M6 pattern=ABBA dummies=1 name=ID56
  interdigitate M7 M8 pattern=ABBA dummies=1 name=ID78
  interdigitate M9 M10 pattern=ABBA dummies=1 name=ID910

  place MT at=(0,0)
  tap T_MT kind=ntap net=VPWR cols=2
  place T_MT below=MT align=center gap=min

  place CC12 below=MT align=center gap=min
  tap T_CC kind=ntap net=VPWR cols=2
  place T_CC below=CC12 align=center gap=min

  place ID34 below=T_CC align=center gap=min
  tap T_N1 kind=ptap net=VGND cols=2
  place T_N1 below=ID34 align=center gap=min

  place ID56 below=T_N1 align=center gap=min
  tap T_N2 kind=ptap net=VGND cols=2
  place T_N2 below=ID56 align=center gap=min

  place ID78 below=T_N2 align=center gap=min
  tap T_78 kind=ntap net=VPWR cols=2
  place T_78 below=ID78 align=center gap=min

  place ID910 below=T_78 align=center gap=min
  tap T_910 kind=ntap net=VPWR cols=2
  place T_910 below=ID910 align=center gap=min

  route tail width=0.4
  route f1 width=0.2
  route f2 width=0.2
  route x width=0.2
  route y width=0.2
  route z width=0.2
  route OUT width=0.2 avoid=INP:0.5,INN:0.5
  route INP width=0.2
  route INN width=0.2
  route VBP width=0.2
  route VBN width=0.2
  route VCN width=0.2
  route VCP width=0.2
  route VPWR width=0.4
  route VGND width=0.4
end
