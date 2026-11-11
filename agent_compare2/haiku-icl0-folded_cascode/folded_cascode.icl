pdk sky130A
param W=1.0 L=0.5

cell folded_cascode
  port INP  in side=left
  port INN  in side=left
  port VBN  in side=left
  port VCN  in side=right
  port VBP  in side=top
  port VCP  in side=right
  port OUT  out side=right
  port VPWR power
  port VGND ground

  pmos MT  w=W l=L nf=4 d=tail g=VBP s=VPWR
  pmos M1  w=W l=L nf=2 d=f1 g=INP s=tail
  pmos M2  w=W l=L nf=2 d=f2 g=INN s=tail
  nmos M3  w=W l=L nf=2 d=f1 g=VBN s=VGND
  nmos M4  w=W l=L nf=2 d=f2 g=VBN s=VGND
  nmos M5  w=W l=L nf=2 d=x  g=VCN s=f1
  nmos M6  w=W l=L nf=2 d=OUT g=VCN s=f2
  pmos M7  w=W l=L nf=2 d=y  g=x  s=VPWR
  pmos M8  w=W l=L nf=2 d=z  g=x  s=VPWR
  pmos M9  w=W l=L nf=2 d=x  g=VCP s=y
  pmos M10 w=W l=L nf=2 d=OUT g=VCP s=z

  common_centroid M1 M2 pattern=AB/BA name=PAIR
  interdigitate M3 M4 pattern=ABBA name=NSINK
  interdigitate M5 M6 pattern=ABBA name=NCAS
  interdigitate M7 M8 pattern=ABBA name=PLOAD
  interdigitate M9 M10 pattern=ABBA name=PCAS

  place MT at=(0, 0)
  place PAIR below=MT gap=min
  place PCAS right_of=MT gap=min
  place PLOAD below=PCAS gap=min
  place NSINK below=PAIR gap=min
  place NCAS below=NSINK gap=min

  guardring GP around=[MT, PAIR, PCAS, PLOAD] kind=ntap net=VPWR
  guardring GN around=[NSINK, NCAS] kind=ptap net=VGND
end
