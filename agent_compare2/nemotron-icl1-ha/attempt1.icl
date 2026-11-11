pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=12 height=H
  device M0 nmos w=WN2 l=L d=n1 g=B s=n2
  device M1 nmos w=WN2 l=L d=n3 g=n1 s=n4
  device M2 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M3 pmos w=WP l=L d=VPWR g=n1 s=COUT
  device M4 nmos w=WN2 l=L d=VGND g=A s=n4
  device M5 pmos w=WP2 l=L d=n3 g=B s=n5
  device M6 pmos w=WP2 l=L d=n5 g=A s=VPWR
  device M7 nmos w=WN l=L d=SUM g=n3 s=VGND
  device M8 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M9 pmos w=WP l=L d=SUM g=n3 s=VPWR
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M11 nmos w=WN2 l=L d=n4 g=B s=VGND
  device M12 nmos w=WN l=L d=VGND g=n1 s=COUT
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1

  # Gate order (same for both rows): A B A B n1 n3 n1
  # nMOS: VGND [A] n2 [B] n1 | n1 VGND [A] n4 [B] n4 | n4 VGND [n1] n3 | n3 VGND [n3] SUM | SUM VGND [n1] COUT |
  # pMOS: VPWR [A] n1 [B] VPWR | VPWR [A] n5 [B] n3 | n3 VPWR [n1] n3 | n3 VPWR [n3] SUM | SUM VPWR [n1] VPWR |
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  span = 0.53 + 7*L + 6*max(0.28, 0.54 - L)
  x0 = cell.cx - span/2

  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g4 = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g6 = rect poly w=L left=(g5.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3
  g7 = rect poly w=L left=(g6.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1

  # nMOS diffusions
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd3 = rect diff xspan=(g5.left - 0.265, g6.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd4 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN2)

  # pMOS diffusions
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(py1 - WP2, py1)
  pd3 = rect diff xspan=(g5.left - 0.265, g6.right + 0.265) yspan=(py1 - WP, py1)
  pd4 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(py1 - WP2, py1)

  nim = enclose [nd1, nd2, nd3, nd4] nsdm
  pim = enclose [pd1, pd2, pd3, pd4] psdm

  # nMOS contacts
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n1
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=n4
  c6 = array licon in=nd2 right_of=g4
  c6l = enclose c6 li net=n4
  c7 = array licon in=nd3 left_of=g5
  c7l = enclose c7 li net=n4
  c8 = array licon in=nd3 right_of=g5
  c8l = enclose c8 li net=VGND
  c8s = strap li from=c8l to=vgnd_li
  c9 = array licon in=nd3 right_of=g6
  c9l = enclose c9 li net=n3
  c10 = array licon in=nd4 left_of=g7
  c10l = enclose c10 li net=SUM
  c11 = array licon in=nd4 right_of=g7
  c11l = enclose c11 li net=COUT
  c11s = strap li from=c11l to=vgnd_li

  # pMOS contacts
  c12 = array licon in=pd1 left_of=g1
  c12l = enclose c12 li net=VPWR
  c12s = strap li from=c12l to=vpwr_li
  c13 = array licon in=pd1 right_of=g1
  c13l = enclose c13 li net=n1
  c14 = array licon in=pd1 right_of=g2
  c14l = enclose c14 li net=VPWR
  c14s = strap li from=c14l to=vpwr_li
  c15 = array licon in=pd2 left_of=g3
  c15l = enclose c15 li net=VPWR
  c15s = strap li from=c15l to=vpwr_li
  c16 = array licon in=pd2 right_of=g3
  c16l = enclose c16 li net=n5
  c17 = array licon in=pd2 right_of=g4
  c17l = enclose c17 li net=n3
  c18 = array licon in=pd3 left_of=g5
  c18l = enclose c18 li net=n3
  c19 = array licon in=pd3 right_of=g5
  c19l = enclose c19 li net=VPWR
  c19s = strap li from=c19l to=vpwr_li
  c20 = array licon in=pd3 right_of=g6
  c20l = enclose c20 li net=SUM
  c21 = array licon in=pd4 left_of=g7
  c21l = enclose c21 li net=SUM
  c22 = array licon in=pd4 right_of=g7
  c22l = enclose c22 li net=VPWR
  c22s = strap li from=c22l to=vpwr_li

  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, nd4.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25,
           c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25)

  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=A
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=n1
  gc6 = contact licon cx=g6.cx bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=n3
  gc7 = contact licon cx=g7.cx bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=n1

  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc

  well y=((max(nd1.top, nd2.top, nd3.top, nd4.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom) - 0.18) / 2)

  # Ports
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  port COUT out
  port SUM out

  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route COUT layers=m1,m2 prefer=m2
  route SUM layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
end
