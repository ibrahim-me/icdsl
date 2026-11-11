pdk sky130A
param W=1.0 L=0.15

cell comp_latch
  port CLK  in
  port INP  in
  port INN  in
  port QP   out
  port QN   out
  port VPWR power
  port VGND ground

  nmos M0  w=W l=L nf=4 d=tail g=CLK  s=VGND
  nmos M1  w=W l=L nf=2 d=P    g=INP  s=tail
  nmos M2  w=W l=L nf=2 d=Q    g=INN  s=tail
  nmos M3  w=W l=L nf=1 d=OUTN g=OUTP s=P
  nmos M4  w=W l=L nf=1 d=OUTP g=OUTN s=Q
  pmos M5  w=W l=L nf=1 d=OUTN g=OUTP s=VPWR
  pmos M6  w=W l=L nf=1 d=OUTP g=OUTN s=VPWR
  pmos M7  w=W l=L nf=1 d=OUTN g=CLK  s=VPWR
  pmos M8  w=W l=L nf=1 d=OUTP g=CLK  s=VPWR
  pmos M9  w=W l=L nf=1 d=P    g=CLK  s=VPWR
  pmos M10 w=W l=L nf=1 d=Q    g=CLK  s=VPWR
  nmos MN11 w=W l=L nf=1 d=QP g=OUTN s=m1
  nmos MN12 w=W l=L nf=1 d=m1 g=QN   s=VGND
  pmos MP11 w=W l=L nf=1 d=QP g=OUTN s=VPWR
  pmos MP12 w=W l=L nf=1 d=QP g=QN   s=VPWR
  nmos MN21 w=W l=L nf=1 d=QN g=OUTP s=m2
  nmos MN22 w=W l=L nf=1 d=m2 g=QP   s=VGND
  pmos MP21 w=W l=L nf=1 d=QN g=OUTP s=VPWR
  pmos MP22 w=W l=L nf=1 d=QN g=QP   s=VPWR

  place M0 at=(0, 0)
  pair M1 M2 axis=M0.cx above=M0
  pair M3 M4 axis=M0.cx above=M1
  pair MN12 MN22 axis=M0.cx above=M3
  pair MN11 MN21 axis=M0.cx above=MN12
  pair M9 M10 axis=M0.cx above=MN11 vgap=1.0
  pair M7 M8 axis=M0.cx above=M9
  pair M5 M6 axis=M0.cx above=M7
  pair MP12 MP22 axis=M0.cx above=M5
  pair MP11 MP21 axis=M0.cx above=MP12
  tap TP kind=ptap net=VGND cols=8
  place TP below=M0 align=center
  tap TN kind=ntap net=VPWR cols=8
  place TN above=MP11 align=center
end
