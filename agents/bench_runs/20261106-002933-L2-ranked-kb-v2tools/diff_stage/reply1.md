```icl
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

  # mirror-symmetric placement about x = 0
  place M1 at=(0, 0)
  move M1 dx=-(M1.w + min)/2 dy=0
  pair M1 M2 axis=0 gap=min

  place M3 above=M1 align=center gap=min
  pair M3 M4 axis=0 gap=min

  place MT below=M1 align=center gap=min
  move MT dx=-MT.cx dy=0

  # guard rings
  guardring GR_N around=[M1, M2, MT] kind=ptap net=VGND
  guardring GR_P around=[M3, M4] kind=ntap net=VPWR

  # routing
  route INP from=INP to=M1.g width=0.2
  route INN from=INN to=M2.g width=0.2
  route VBN from=VBN to=MT.g width=0.2
  route VBP from=VBP to=M3.g width=0.2 avoid=INP:0.4,INN:0.4
  route VPWR width=0.4
  route VGND width=0.4
  route tail width=0.4
  route OUTP OUTN symmetric axis=0 width=0.2 avoid=INP:0.5,INN:0.5,VBP:0.5
end
```