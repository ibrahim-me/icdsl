pdk sky130A
param W=1.0 L=0.3

cell diff_stage
  port INP in side=left
  port INN in side=right
  port VBN in side=bottom
  port VBP in side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos M3 w=W l=L nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=W l=L nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  place MT at=(0,0)
  pair M1 M2 axis=MT.cx above=MT gap=min
  pair M3 M4 axis=MT.cx above=M1 gap=min

  guardring GN around=[M1,M2,MT] kind=ptap net=VGND
  guardring GP around=[M3,M4] kind=ntap net=VPWR

  route tail width=0.4
  route VPWR width=0.4
  route VGND width=0.4
  route INP width=0.2
  route INN width=0.2
  route VBN width=0.2
  route VBP width=0.2
  route OUTP OUTN symmetric axis=MT.cx width=0.2 avoid=INP:0.4,INN:0.4,VBN:0.4,VBP:0.4
end
