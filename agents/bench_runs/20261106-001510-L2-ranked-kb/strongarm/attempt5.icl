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

  place M0 at=(0,0) align=center
  pair M1 M2 axis=0 above=M0 gap=min
  pair M3 M4 axis=0 above=M0 gap=min
  pair M5 M6 axis=0 above=M0 gap=6.00
  pair M7 M8 axis=0 above=M0 gap=min
  pair M9 M10 axis=0 above=M0 gap=min

  guardring GN around=[M0, M1, M2, M3, M4] kind=ptap net=VGND
  guardring GP around=[M5, M6, M7, M8, M9, M10] kind=ntap net=VPWR

  route CLK width=0.3
  route INP width=0.2
  route INN width=0.2
  route OUTP width=0.2
  route OUTN width=0.2
  route tail width=0.4
  route P width=0.2
  route Q width=0.2
  route VPWR width=0.4
  route VGND width=0.4
end
