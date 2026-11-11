pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

cell ha
  port VPWR power
  port VGND ground

  # NMOS devices (bottom row)
  nmos M8  w=WN2 l=L d=n2  g=A  s=VGND
  nmos M0  w=WN2 l=L d=n1  g=B  s=n2
  nmos M11 w=WN2 l=L d=n4  g=B  s=VGND
  nmos M4  w=WN2 l=L d=VGND g=A  s=n4
  nmos M1  w=WN2 l=L d=n3  g=n1 s=n4
  nmos M12 w=WN  l=L d=VGND g=n1 s=COUT
  nmos M7  w=WN  l=L d=SUM g=n3 s=VGND

  # PMOS devices (top row, in n-well)
  pmos M13 w=WP2 l=L d=VPWR g=B  s=n1
  pmos M2  w=WP2 l=L d=n1  g=A  s=VPWR
  pmos M6  w=WP2 l=L d=n5  g=A  s=VPWR
  pmos M5  w=WP2 l=L d=n3  g=B  s=n5
  pmos M10 w=WP2 l=L d=VPWR g=n1 s=n3
  pmos M3  w=WP  l=L d=VPWR g=n1 s=COUT
  pmos M9  w=WP  l=L d=SUM g=n3 s=VPWR

  # Rows: nmos below, pmos above
  row M8 M0 M11 M4 M1 M12 M7 gap=1 strap=bottom
  row M13 M2 M6 M5 M10 M3 M9 gap=1 strap=top

  # Ports
  port A  in  side=left  layer=m1
  port B  in  side=left  layer=m1
  port COUT out side=right layer=m1
  port SUM out side=right layer=m1
end