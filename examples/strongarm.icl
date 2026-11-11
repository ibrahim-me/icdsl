# StrongARM latch comparator (11 transistors, cross-coupled latch)
pdk sky130A

cell strongarm
  port CLK  in
  port INP  in
  port INN  in
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M0  w=2.0 l=0.15 nf=2 d=tail g=CLK  s=VGND     # clocked tail
  nmos M1  w=2.0 l=0.15 nf=2 d=P    g=INP  s=tail     # input pair
  nmos M2  w=2.0 l=0.15 nf=2 d=Q    g=INN  s=tail
  nmos M3  w=1.0 l=0.15      d=OUTN g=OUTP s=P        # cross-coupled nmos
  nmos M4  w=1.0 l=0.15      d=OUTP g=OUTN s=Q
  pmos M5  w=1.0 l=0.15      d=OUTN g=OUTP s=VPWR     # cross-coupled pmos
  pmos M6  w=1.0 l=0.15      d=OUTP g=OUTN s=VPWR
  pmos M7  w=1.0 l=0.15      d=OUTN g=CLK  s=VPWR     # reset switches
  pmos M8  w=1.0 l=0.15      d=OUTP g=CLK  s=VPWR
  pmos M9  w=1.0 l=0.15      d=P    g=CLK  s=VPWR
  pmos M10 w=1.0 l=0.15      d=Q    g=CLK  s=VPWR

  row M0
  row M1 M2
  row M3 M4
  row M9 M7 M5 M6 M8 M10
end
