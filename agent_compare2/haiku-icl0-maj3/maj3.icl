# maj3: X = AB + BC + CA as a 7-column standard cell (21 x 0.46 um wide)
# Column k holds one nmos and one pmos sharing the same gate poly.
#   col1 A: nmos M4 (VGND|n2),  pmos M12 (VPWR|n7)
#   col2 B: nmos M1 (n2|n3),    pmos M13 (n7|n3)
#   col3 B: nmos M2 (n3|n4),    pmos M6  (n3|n6)
#   col4 C: nmos M9 (n4|VGND),  pmos M7  (n6|VPWR)
#   col5 n3: nmos M3 (VGND|X) WN,  pmos M8 (VPWR|X) WP
#   col6 C: nmos M10 (n3|n5),   pmos M11 (n3|n1)
#   col7 A: nmos M5 (n5|VGND),  pmos M0  (n1|VPWR)
pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=21 height=H
  device M4  nmos w=WN2 l=L d=VGND g=A  s=n2
  device M1  nmos w=WN2 l=L d=n2   g=B  s=n3
  device M2  nmos w=WN2 l=L d=n3   g=B  s=n4
  device M9  nmos w=WN2 l=L d=n4   g=C  s=VGND
  device M3  nmos w=WN  l=L d=VGND g=n3 s=X
  device M10 nmos w=WN2 l=L d=n3   g=C  s=n5
  device M5  nmos w=WN2 l=L d=n5   g=A  s=VGND
  device M12 pmos w=WP2 l=L d=VPWR g=A  s=n7
  device M13 pmos w=WP2 l=L d=n7   g=B  s=n3
  device M6  pmos w=WP2 l=L d=n3   g=B  s=n6
  device M7  pmos w=WP2 l=L d=n6   g=C  s=VPWR
  device M8  pmos w=WP  l=L d=VPWR g=n3 s=X
  device M11 pmos w=WP2 l=L d=n3   g=C  s=n1
  device M0  pmos w=WP2 l=L d=n1   g=A  s=VPWR

  # ---- column 1 (x=0.69): gate A ----
  nd1  = rect diff w=(L + 0.53) h=WN2 cx=0.69 above=ptap
  pd1  = rect diff w=(L + 0.53) h=WP2 cx=0.69 below=ntap
  nim1 = enclose nd1 nsdm
  pim1 = enclose pd1 psdm
  g1   = cross [nd1, pd1] poly w=L
  sn1  = array licon in=nd1 left_of=g1
  dn1  = array licon in=nd1 right_of=g1
  sp1  = array licon in=pd1 left_of=g1
  dp1  = array licon in=pd1 right_of=g1
  snl1 = enclose sn1 li net=VGND
  dnl1 = enclose dn1 li net=n2
  spl1 = enclose sp1 li net=VPWR
  dpl1 = enclose dp1 li net=n7
  r1n  = strap li from=snl1 to=vgnd_li
  r1p  = strap li from=spl1 to=vpwr_li
  gc1  = contact licon cx=0.69 cy=1.23
  gp1  = enclose gc1 poly by=minx
  gn1  = enclose gc1 npc
  ga1  = enclose gc1 li net=A

  # ---- column 2 (x=2.07): gate B ----
  nd2  = rect diff w=(L + 0.53) h=WN2 cx=2.07 above=ptap
  pd2  = rect diff w=(L + 0.53) h=WP2 cx=2.07 below=ntap
  nim2 = enclose nd2 nsdm
  pim2 = enclose pd2 psdm
  g2   = cross [nd2, pd2] poly w=L
  sn2  = array licon in=nd2 left_of=g2
  dn2  = array licon in=nd2 right_of=g2
  sp2  = array licon in=pd2 left_of=g2
  dp2  = array licon in=pd2 right_of=g2
  snl2 = enclose sn2 li net=n2
  dnl2 = enclose dn2 li net=n3
  spl2 = enclose sp2 li net=n7
  dpl2 = enclose dp2 li net=n3
  gc2  = contact licon cx=2.07 cy=1.23
  gp2  = enclose gc2 poly by=minx
  gn2  = enclose gc2 npc
  ga2  = enclose gc2 li net=B

  # ---- column 3 (x=3.45): gate B ----
  nd3  = rect diff w=(L + 0.53) h=WN2 cx=3.45 above=ptap
  pd3  = rect diff w=(L + 0.53) h=WP2 cx=3.45 below=ntap
  nim3 = enclose nd3 nsdm
  pim3 = enclose pd3 psdm
  g3   = cross [nd3, pd3] poly w=L
  sn3  = array licon in=nd3 left_of=g3
  dn3  = array licon in=nd3 right_of=g3
  sp3  = array licon in=pd3 left_of=g3
  dp3  = array licon in=pd3 right_of=g3
  snl3 = enclose sn3 li net=n3
  dnl3 = enclose dn3 li net=n4
  spl3 = enclose sp3 li net=n3
  dpl3 = enclose dp3 li net=n6
  gc3  = contact licon cx=3.45 cy=1.23
  gp3  = enclose gc3 poly by=minx
  gn3  = enclose gc3 npc
  ga3  = enclose gc3 li net=B

  # ---- column 4 (x=4.83): gate C ----
  nd4  = rect diff w=(L + 0.53) h=WN2 cx=4.83 above=ptap
  pd4  = rect diff w=(L + 0.53) h=WP2 cx=4.83 below=ntap
  nim4 = enclose nd4 nsdm
  pim4 = enclose pd4 psdm
  g4   = cross [nd4, pd4] poly w=L
  sn4  = array licon in=nd4 left_of=g4
  dn4  = array licon in=nd4 right_of=g4
  sp4  = array licon in=pd4 left_of=g4
  dp4  = array licon in=pd4 right_of=g4
  snl4 = enclose sn4 li net=n4
  dnl4 = enclose dn4 li net=VGND
  spl4 = enclose sp4 li net=n6
  dpl4 = enclose dp4 li net=VPWR
  r4n  = strap li from=dnl4 to=vgnd_li
  r4p  = strap li from=dpl4 to=vpwr_li
  gc4  = contact licon cx=4.83 cy=1.23
  gp4  = enclose gc4 poly by=minx
  gn4  = enclose gc4 npc
  ga4  = enclose gc4 li net=C

  # ---- column 5 (x=6.21): gate n3, nmos WN, pmos WP ----
  nd5  = rect diff w=(L + 0.53) h=WN cx=6.21 above=ptap
  pd5  = rect diff w=(L + 0.53) h=WP cx=6.21 below=ntap
  nim5 = enclose nd5 nsdm
  pim5 = enclose pd5 psdm
  g5   = cross [nd5, pd5] poly w=L
  sn5  = array licon in=nd5 left_of=g5
  dn5  = array licon in=nd5 right_of=g5
  sp5  = array licon in=pd5 left_of=g5
  dp5  = array licon in=pd5 right_of=g5
  snl5 = enclose sn5 li net=VGND
  dnl5 = enclose dn5 li net=X
  spl5 = enclose sp5 li net=VPWR
  dpl5 = enclose dp5 li net=X
  r5n  = strap li from=snl5 to=vgnd_li
  r5p  = strap li from=spl5 to=vpwr_li
  gc5  = contact licon cx=6.21 cy=1.23
  gp5  = enclose gc5 poly by=minx
  gn5  = enclose gc5 npc
  ga5  = enclose gc5 li net=n3

  # ---- column 6 (x=7.59): gate C ----
  nd6  = rect diff w=(L + 0.53) h=WN2 cx=7.59 above=ptap
  pd6  = rect diff w=(L + 0.53) h=WP2 cx=7.59 below=ntap
  nim6 = enclose nd6 nsdm
  pim6 = enclose pd6 psdm
  g6   = cross [nd6, pd6] poly w=L
  sn6  = array licon in=nd6 left_of=g6
  dn6  = array licon in=nd6 right_of=g6
  sp6  = array licon in=pd6 left_of=g6
  dp6  = array licon in=pd6 right_of=g6
  snl6 = enclose sn6 li net=n3
  dnl6 = enclose dn6 li net=n5
  spl6 = enclose sp6 li net=n3
  dpl6 = enclose dp6 li net=n1
  gc6  = contact licon cx=7.59 cy=1.23
  gp6  = enclose gc6 poly by=minx
  gn6  = enclose gc6 npc
  ga6  = enclose gc6 li net=C

  # ---- column 7 (x=8.97): gate A ----
  nd7  = rect diff w=(L + 0.53) h=WN2 cx=8.97 above=ptap
  pd7  = rect diff w=(L + 0.53) h=WP2 cx=8.97 below=ntap
  nim7 = enclose nd7 nsdm
  pim7 = enclose pd7 psdm
  g7   = cross [nd7, pd7] poly w=L
  sn7  = array licon in=nd7 left_of=g7
  dn7  = array licon in=nd7 right_of=g7
  sp7  = array licon in=pd7 left_of=g7
  dp7  = array licon in=pd7 right_of=g7
  snl7 = enclose sn7 li net=n5
  dnl7 = enclose dn7 li net=VGND
  spl7 = enclose sp7 li net=n1
  dpl7 = enclose dp7 li net=VPWR
  r7n  = strap li from=dnl7 to=vgnd_li
  r7p  = strap li from=dpl7 to=vpwr_li
  gc7  = contact licon cx=8.97 cy=1.23
  gp7  = enclose gc7 poly by=minx
  gn7  = enclose gc7 npc
  ga7  = enclose gc7 li net=A

  # ---- pins (met1) ----
  am  = contact mcon in=ga1
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=ga2
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=ga4
  cp  = enclose cm m1 by=0.06 net=C
  xm  = contact mcon in=dnl5
  xp  = enclose xm m1 by=0.06 net=X

  # ---- internal nets ----
  route A layers=m1,m2
  route B layers=m1,m2
  route C layers=m1,m2
  route X layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route n5 layers=m1,m2
  route n1 layers=m1,m2
  route n6 layers=m1,m2
  route n7 layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port X out on=xp
end
