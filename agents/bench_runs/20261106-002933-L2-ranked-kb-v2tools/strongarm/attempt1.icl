pdk sky130A
param W=1.0 L=0.15

cell strongarm
  port CLK in side=bottom
  port INP in side=left
  port INN in side=right
  port OUTP out side=top
  port OUTN out side=top
  port VPWR power
  port VGND ground

  nmos M0 w=W l=L nf=4 d=tail g=CLK s=VGND
  nmos M1 w=W l=L nf=2 d=P g=INP s=tail
  nmos M2 w=W l=L nf=2 d=Q g=INN s=tail
  nmos M3 w=W l=L d=OUTN g=OUTP s=P
  nmos M4 w=W l=L d=OUTP g=OUTN s=Q
  pmos M5 w=W l=L d=OUTN g=OUTP s=VPWR
  pmos M6 w=W l=L d=OUTP g=OUTN s=VPWR
  pmos M7 w=W l=L d=OUTN g=CLK s=VPWR
  pmos M8 w=W l=L d=OUTP g=CLK s=VPWR
  pmos M9 w=W l=L d=P g=CLK s=VPWR
  pmos M10 w=W l=L d=Q g=CLK s=VPWR

  place M0 at=(0,0)
  place M1 left_of=M0 align=center gap=0.5
  pair M1 M2 axis=0 gap=min
  place M3 below=M1 align=center gap=0.5
  pair M3 M4 axis=0 gap=min
  place M5 above=M0 align=center gap=0.5 flip=x
  pair M5 M6 axis=0 gap=min
  place M7 above=M5 align=center gap=0.5 flip=x
  pair M7 M8 axis=0 gap=min
  place M9 above=M7 align=center gap=0.5 flip=x
  pair M9 M10 axis=0 gap=min

  guardring GN around=[M0,M1,M2,M3,M4] kind=ptap net=VGND
  guardring GP around=[M5,M6,M7,M8,M9,M10] kind=ntap net=VPWR

  route CLK width=0.3
  route INP width=0.3
  route INN width=0.3
  route tail width=0.4 avoid=INP:0.5,INN:0.5
  route P width=0.3 avoid=Q:0.5
  route Q width=0.3 avoid=P:0.5
  route OUTP OUTN symmetric axis=0 width=0.3
  route VPWR width=0.4
  route VGND width=0.4
end
