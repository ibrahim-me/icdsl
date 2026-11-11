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

  place M0 at=(0, 0)
  pair M1 M2 axis=M0.cx above=M0 vgap=2.0
  pair M3 M4 axis=M0.cx above=M1 vgap=2.0
  pair M5 M6 axis=M0.cx above=M3 vgap=2.0
  pair M7 M8 axis=M0.cx above=M5 vgap=2.0
  pair M9 M10 axis=M0.cx above=M7 vgap=2.0

  guardring GN around=[M0, M1, M2, M3, M4] kind=ptap net=VGND
  guardring GP around=[M5, M6, M7, M8, M9, M10] kind=ntap net=VPWR

  route INP INN symmetric axis=M0.cx width=0.2
  route P Q symmetric axis=M0.cx width=0.2 avoid=OUTP:0.5,OUTN:0.5
  route OUTP width=0.2 avoid=INP:0.5,INN:0.5
  route OUTN width=0.2 avoid=INP:0.5,INN:0.5
  route CLK width=0.4 avoid=INP:0.5,INN:0.5,OUTP:0.5,OUTN:0.5
  route tail width=0.4
  route VPWR width=0.4
  route VGND width=0.4
end
