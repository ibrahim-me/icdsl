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

  # ===== NMOS diffusions (bottom row, above vgnd rail) =====
  nd8  = rect diff w=(L + 0.53) h=WN2 left=cell.left above=vgnd
  g8   = cross nd8 poly w=L
  nd0  = rect diff w=(L + 0.53) h=WN2 right_of=nd8
  g0   = cross nd0 poly w=L
  nd11 = rect diff w=(L + 0.53) h=WN2 right_of=nd0
  g11  = cross nd11 poly w=L
  nd4  = rect diff w=(L + 0.53) h=WN2 right_of=nd11
  g4   = cross nd4 poly w=L
  nd1  = rect diff w=(L + 0.53) h=WN2 right_of=nd4
  g1   = cross nd1 poly w=L
  nd12 = rect diff w=(L + 0.53) h=WN2 right_of=nd1
  g12  = cross nd12 poly w=L
  nd7  = rect diff w=(L + 0.53) h=WN right_of=nd12
  g7   = cross nd7 poly w=L

  # ===== PMOS diffusions (top row, below vpwr rail) =====
  pd13 = rect diff w=(L + 0.53) h=WP2 left=cell.left below=vpwr
  g13  = cross pd13 poly w=L
  pd2  = rect diff w=(L + 0.53) h=WP2 right_of=pd13
  g2   = cross pd2 poly w=L
  pd6  = rect diff w=(L + 0.53) h=WP2 right_of=pd2
  g6   = cross pd6 poly w=L
  pd5  = rect diff w=(L + 0.53) h=WP2 right_of=pd6
  g5   = cross pd5 poly w=L
  pd10 = rect diff w=(L + 0.53) h=WP2 right_of=pd5
  g10  = cross pd10 poly w=L
  pd3  = rect diff w=(L + 0.53) h=WP right_of=pd10
  g3   = cross pd3 poly w=L
  pd9  = rect diff w=(L + 0.53) h=WP right_of=pd3
  g9   = cross pd9 poly w=L

  # ===== Implants =====
  nim8  = enclose nd8 nsdm
  nim0  = enclose nd0 nsdm
  nim11 = enclose nd11 nsdm
  nim4  = enclose nd4 nsdm
  nim1  = enclose nd1 nsdm
  nim12 = enclose nd12 nsdm
  nim7  = enclose nd7 nsdm
  pim13 = enclose pd13 psdm
  pim2  = enclose pd2 psdm
  pim6  = enclose pd6 psdm
  pim5  = enclose pd5 psdm
  pim10 = enclose pd10 psdm
  pim3  = enclose pd3 psdm
  pim9  = enclose pd9 psdm

  # ===== n-well =====
  well y=((nd8.top + 0.34 + pd13.bottom - 0.18) / 2)

  # ===== Contacts (licon) =====
  # NMOS
  c8s  = contact licon in=nd8 right_of=g8   # n2
  c8d  = contact licon in=nd8 left_of=g8    # VGND
  c8g  = contact licon left_of=g8 bottom=max(nd8.top + 0.19)
  c0s  = contact licon in=nd0 left_of=g0    # n2 shared with M8
  c0d  = contact licon in=nd0 right_of=g0   # n1
  c0g  = contact licon left_of=g0 bottom=max(nd0.top + 0.19)
  c11s = contact licon in=nd11 left_of=g11  # VGND
  c11d = contact licon in=nd11 right_of=g11 # n4
  c11g = contact licon left_of=g11 bottom=max(nd11.top + 0.19)
  c4s  = contact licon in=nd4 right_of=g4   # n4 shared with M11
  c4d  = contact licon in=nd4 left_of=g4    # VGND
  c4g  = contact licon left_of=g4 bottom=max(nd4.top + 0.19)
  c1s  = contact licon in=nd1 left_of=g1    # n4 shared
  c1d  = contact licon in=nd1 right_of=g1   # n3
  c1g  = contact licon left_of=g1 bottom=max(nd1.top + 0.19)
  c12s = contact licon in=nd12 left_of=g12  # COUT
  c12d = contact licon in=nd12 right_of=g12 # VGND
  c12g = contact licon left_of=g12 bottom=max(nd12.top + 0.19)
  c7s  = contact licon in=nd7 left_of=g7    # VGND
  c7d  = contact licon in=nd7 right_of=g7   # SUM
  c7g  = contact licon left_of=g7 bottom=max(nd7.top + 0.19)

  # PMOS
  c13s = contact licon in=pd13 right_of=g13 # n1
  c13d = contact licon in=pd13 left_of=g13  # VPWR
  c13g = contact licon left_of=g13 bottom=max(pd13.bottom - 0.19)
  c2s  = contact licon in=pd2 left_of=g2    # VPWR
  c2d  = contact licon in=pd2 right_of=g2   # n1 shared with M13
  c2g  = contact licon left_of=g2 bottom=max(pd2.bottom - 0.19)
  c6s  = contact licon in=pd6 left_of=g6    # VPWR
  c6d  = contact licon in=pd6 right_of=g6   # n5
  c6g  = contact licon left_of=g6 bottom=max(pd6.bottom - 0.19)
  c5s  = contact licon in=pd5 right_of=g5   # n5 shared with M6
  c5d  = contact licon in=pd5 left_of=g5    # n3
  c5g  = contact licon left_of=g5 bottom=max(pd5.bottom - 0.19)
  c10s = contact licon in=pd10 right_of=g10 # n3 shared with M5
  c10d = contact licon in=pd10 left_of=g10  # VPWR
  c10g = contact licon left_of=g10 bottom=max(pd10.bottom - 0.19)
  c3s  = contact licon in=pd3 right_of=g3   # COUT
  c3d  = contact licon in=pd3 left_of=g3    # VPWR
  c3g  = contact licon left_of=g3 bottom=max(pd3.bottom - 0.19)
  c9s  = contact licon in=pd9 left_of=g9    # VPWR
  c9d  = contact licon in=pd9 right_of=g9   # SUM
  c9g  = contact licon left_of=g9 bottom=max(pd9.bottom - 0.19)

  # ===== Metal1 over contacts =====
  m8s = enclose c8s m1 by=0.06 net=n2
  m8d = enclose c8d m1 by=0.06 net=VGND
  m8g = enclose c8g m1 by=0.06 net=A
  m0s = enclose c0s m1 by=0.06 net=n2
  m0d = enclose c0d m1 by=0.06 net=n1
  m0g = enclose c0g m1 by=0.06 net=B
  m11s = enclose c11s m1 by=0.06 net=VGND
  m11d = enclose c11d m1 by=0.06 net=n4
  m11g = enclose c11g m1 by=0.06 net=B
  m4s = enclose c4s m1 by=0.06 net=n4
  m4d = enclose c4d m1 by=0.06 net=VGND
  m4g = enclose c4g m1 by=0.06 net=A
  m1s = enclose c1s m1 by=0.06 net=n4
  m1d = enclose c1d m1 by=0.06 net=n3
  m1g = enclose c1g m1 by=0.06 net=n1
  m12s = enclose c12s m1 by=0.06 net=COUT
  m12d = enclose c12d m1 by=0.06 net=VGND
  m12g = enclose c12g m1 by=0.06 net=n1
  m7s = enclose c7s m1 by=0.06 net=VGND
  m7d = enclose c7d m1 by=0.06 net=SUM
  m7g = enclose c7g m1 by=0.06 net=n3
  m13s = enclose c13s m1 by=0.06 net=n1
  m13d = enclose c13d m1 by=0.06 net=VPWR
  m13g = enclose c13g m1 by=0.06 net=B
  m2s = enclose c2s m1 by=0.06 net=VPWR
  m2d = enclose c2d m1 by=0.06 net=n1
  m2g = enclose c2g m1 by=0.06 net=A
  m6s = enclose c6s m1 by=0.06 net=VPWR
  m6d = enclose c6d m1 by=0.06 net=n5
  m6g = enclose c6g m1 by=0.06 net=A
  m5s = enclose c5s m1 by=0.06 net=n5
  m5d = enclose c5d m1 by=0.06 net=n3
  m5g = enclose c5g m1 by=0.06 net=B
  m10s = enclose c10s m1 by=0.06 net=n3
  m10d = enclose c10d m1 by=0.06 net=VPWR
  m10g = enclose c10g m1 by=0.06 net=n1
  m3s = enclose c3s m1 by=0.06 net=COUT
  m3d = enclose c3d m1 by=0.06 net=VPWR
  m3g = enclose c3g m1 by=0.06 net=n1
  m9s = enclose c9s m1 by=0.06 net=VPWR
  m9d = enclose c9d m1 by=0.06 net=SUM
  m9g = enclose c9g m1 by=0.06 net=n3

  # ===== Connect shared nets with m1 straps =====
  strap m1 from=m8s to=m0s cy=m8s.cy
  strap m1 from=m0d to=m13s cy=m0d.cy
  strap m1 from=m13s to=m2d cy=m13s.cy
  strap m1 from=m2d to=m1g cy=m2d.cy
  strap m1 from=m1g to=m12g cy=m1g.cy
  strap m1 from=m12g to=m10g cy=m12g.cy
  strap m1 from=m10g to=m3g cy=m10g.cy
  strap m1 from=m11d to=m4s cy=m11d.cy
  strap m1 from=m4s to=m1s cy=m4s.cy
  strap m1 from=m1d to=m5d cy=m1d.cy
  strap m1 from=m5d to=m7g cy=m5d.cy
  strap m1 from=m7g to=m9g cy=m7g.cy
  strap m1 from=m6d to=m5s cy=m6d.cy
  strap m1 from=m12s to=m3s cy=m12s.cy
  strap m1 from=m7d to=m9d cy=m7d.cy
  strap m1 from=m8g to=m4g cy=m8g.cy
  strap m1 from=m4g to=m2g cy=m4g.cy
  strap m1 from=m0g to=m11g cy=m0g.cy
  strap m1 from=m11g to=m13g cy=m11g.cy
  strap m1 from=m13g to=m5g cy=m13g.cy

  # ===== Ports =====
  port A  in  on=m8g
  port B  in  on=m0g
  port COUT out on=m12s
  port SUM out on=m7d
end