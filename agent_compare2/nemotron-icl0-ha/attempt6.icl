pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=20 height=H taps=yes
  # ===== Device declarations for LVS =====
  device M8  nmos w=WN2 l=L d=n2  g=A  s=VGND
  device M0  nmos w=WN2 l=L d=n1  g=B  s=n2
  device M11 nmos w=WN2 l=L d=n4  g=B  s=VGND
  device M4  nmos w=WN2 l=L d=VGND g=A  s=n4
  device M1  nmos w=WN2 l=L d=n3  g=n1 s=n4
  device M12 nmos w=WN  l=L d=VGND g=n1 s=COUT
  device M7  nmos w=WN  l=L d=SUM g=n3 s=VGND
  device M13 pmos w=WP2 l=L d=VPWR g=B  s=n1
  device M2  pmos w=WP2 l=L d=n1  g=A  s=VPWR
  device M6  pmos w=WP2 l=L d=n5  g=A  s=VPWR
  device M5  pmos w=WP2 l=L d=n3  g=B  s=n5
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M3  pmos w=WP  l=L d=VPWR g=n1 s=COUT
  device M9  pmos w=WP  l=L d=SUM g=n3 s=VPWR

  # ===== Ports =====
  port A  in  side=left  layer=m1
  port B  in  side=left  layer=m1
  port COUT out side=right layer=m1
  port SUM out side=right layer=m1
end