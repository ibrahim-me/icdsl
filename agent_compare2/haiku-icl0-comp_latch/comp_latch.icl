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
  nmos M3  w=W l=L d=OUTN g=OUTP s=P
  nmos M4  w=W l=L d=OUTP g=OUTN s=Q
  pmos M5  w=W l=L d=OUTN g=OUTP s=VPWR
  pmos M6  w=W l=L d=OUTP g=OUTN s=VPWR
  pmos M7  w=W l=L d=OUTN g=CLK  s=VPWR
  pmos M8  w=W l=L d=OUTP g=CLK  s=VPWR
  pmos M9  w=W l=L d=P    g=CLK  s=VPWR
  pmos M10 w=W l=L d=Q    g=CLK  s=VPWR
  nmos MN11 w=W l=L d=QP g=OUTN s=m1
  nmos MN12 w=W l=L d=m1 g=QN   s=VGND
  pmos MP11 w=W l=L d=QP g=OUTN s=VPWR
  pmos MP12 w=W l=L d=QP g=QN   s=VPWR
  nmos MN21 w=W l=L d=QN g=OUTP s=m2
  nmos MN22 w=W l=L d=m2 g=QP   s=VGND
  pmos MP21 w=W l=L d=QN g=OUTP s=VPWR
  pmos MP22 w=W l=L d=QN g=QP   s=VPWR

  place M0 at=(0, 0)
  pair M1 M2 axis=M0.cx above=M0
  pair M3 M4 axis=M0.cx above=M1
  pair M9 M10 axis=M0.cx above=M3
  pair M7 M8 axis=M0.cx above=M9
  pair M5 M6 axis=M0.cx above=M7

  place MN12 left_of=M0 align=bottom
  place MN11 left_of=MN12 align=bottom
  mirror MN22 of=MN12 axis=M0.cx
  mirror MN21 of=MN11 axis=M0.cx

  place MP12 left_of=M9 align=top
  place MP11 left_of=MP12 align=top
  mirror MP22 of=MP12 axis=M0.cx
  mirror MP21 of=MP11 axis=M0.cx

  tap TP kind=ptap net=VGND cols=4
  place TP below=MN11 align=left
  tap TN kind=ntap net=VPWR cols=4
  place TN left_of=MP11 align=top

  route *
end
