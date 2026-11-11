# 5-transistor OTA: nmos input pair, pmos current-mirror load, nmos tail source
pdk sky130A

cell ota5t
  port INP  in
  port INN  in
  port VBN  in        # tail bias
  port OUT  out
  port VPWR power
  port VGND ground

  nmos MT  w=2.0 l=0.5 nf=2 d=tail g=VBN s=VGND
  nmos M1  w=2.0 l=0.5 nf=2 d=x    g=INP s=tail
  nmos M2  w=2.0 l=0.5 nf=2 d=OUT  g=INN s=tail
  pmos M3  w=2.0 l=0.5 nf=2 d=x    g=x   s=VPWR   # diode-connected mirror input
  pmos M4  w=2.0 l=0.5 nf=2 d=OUT  g=x   s=VPWR

  row MT
  row M1 M2
  row M3 M4
end
