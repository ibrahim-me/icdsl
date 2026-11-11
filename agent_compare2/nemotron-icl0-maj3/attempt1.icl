pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=20 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4
  device M3 nmos w=WN l=L d=VGND g=n3 s=X
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3

end