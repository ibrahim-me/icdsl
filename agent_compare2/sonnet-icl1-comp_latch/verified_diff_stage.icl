# Fully differential stage, mirror-symmetric, guard rings, mirror-image output routing
pdk sky130A
param W=1.0 L=0.3

cell diff_stage
  port INP  in  side=left
  port INN  in  side=right
  port VBN  in  side=bottom
  port VBP  in  side=top
  port OUTP out
  port OUTN out
  port VPWR power
  port VGND ground

  nmos M1 w=W l=L nf=2 d=OUTN g=INP s=tail
  nmos M2 w=W l=L nf=2 d=OUTP g=INN s=tail
  pmos M3 w=W l=L nf=2 d=OUTN g=VBP s=VPWR
  pmos M4 w=W l=L nf=2 d=OUTP g=VBP s=VPWR
  nmos MT w=W l=L nf=4 d=tail g=VBN s=VGND

  place MT at=(0, 0)
  pair  M1 M2 axis=MT.cx above=MT
  pair  M3 M4 axis=MT.cx above=M1 vgap=2.0
  guardring GN around=[MT, M1, M2] kind=ptap net=VGND
  guardring GP around=[M3, M4] kind=ntap net=VPWR

  route OUTN OUTP symmetric axis=MT.cx
end
