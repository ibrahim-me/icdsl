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
  place M1 above=M0 align=left gap=0.2
  mirror M2 of=M1 axis=0
  place M3 above=M1 align=left gap=0.2
  mirror M4 of=M3 axis=0
  place M5 above=M3 align=left gap=3.0
  mirror M6 of=M5 axis=0
  place M7 above=M5 align=left gap=0.2
  mirror M8 of=M7 axis=0
  place M9 above=M7 align=left gap=0.2
  mirror M10 of=M9 axis=0

  guardring GP around=[M0, M1, M2, M3, M4] kind=ptap net=VGND space=0.2
  guardring GN around=[M5, M6, M7, M8, M9, M10] kind=ntap net=VPWR space=0.2

  route INP INN symmetric axis=0 width=0.2
  route OUTP OUTN symmetric axis=0 width=0.3 avoid=INP:0.5,INN:0.5
  route P Q symmetric axis=0 width=0.3
  route CLK width=0.3 avoid=INP:0.4,INN:0.4
  route tail width=0.3
  route VPWR width=0.4
  route VGND width=0.4
end
