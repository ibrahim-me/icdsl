pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=12 height=H
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

  # gates: A B B C n3 | C A
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  span = 0.53 + 7*L + max(0.28, 0.54 - L) + 0.52 + 2*max(0.21, 0.54 - L) + max(0.43, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  g2 = rect poly w=L left=(g1.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g4 = rect poly w=L left=(g3.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g5 = rect poly w=L left=(g4.right + 0.52) yspan=(ny0 - 0.13, py1 + 0.13)
  g6 = rect poly w=L left=(g5.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g7 = rect poly w=L left=(g6.right + max(0.43, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  ndA = rect diff xspan=(g1.left - 0.265, (g4.right + 0.26)) yspan=(ny0, ny0 + WN2)
  ndB = rect diff xspan=((g4.right + 0.26), g5.right + 0.265) yspan=(ny0, ny0 + WN)
  ndC = rect diff xspan=(g6.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN2)
  pdA = rect diff xspan=(g1.left - 0.265, (g4.right + 0.26)) yspan=(py1 - WP2, py1)
  pdB = rect diff xspan=((g4.right + 0.26), g5.right + 0.265) yspan=(py1 - WP, py1)
  pdC = rect diff xspan=(g6.left - 0.265, g7.right + 0.265) yspan=(py1 - WP2, py1)
  nim = enclose [ndA, ndB, ndC] nsdm
  pim = enclose [pdA, pdB, pdC] psdm

  # n row
  n1c = array licon in=ndA left_of=g1
  n1l = enclose n1c li net=VGND
  n1s = strap li from=n1l to=vgnd_li
  n2c = array licon in=ndA between=[g2, g3]
  n2l = enclose n2c li net=n3
  n3c = array licon in=ndA between=[g4, g5]
  n3l = enclose n3c li net=VGND
  n3s = strap li from=n3l to=vgnd_li
  n4c = array licon in=ndB right_of=g5
  n4l = enclose n4c li net=X
  n5c = array licon in=ndC left_of=g6
  n5l = enclose n5c li net=n3
  n6c = array licon in=ndC right_of=g7
  n6l = enclose n6c li net=VGND
  n6s = strap li from=n6l to=vgnd_li
  # p row
  p1c = array licon in=pdA left_of=g1
  p1l = enclose p1c li net=VPWR
  p1s = strap li from=p1l to=vpwr_li
  p2c = array licon in=pdA between=[g2, g3]
  p2l = enclose p2c li net=n3
  p3c = array licon in=pdA between=[g4, g5]
  p3l = enclose p3c li net=VPWR
  p3s = strap li from=p3l to=vpwr_li
  p4c = array licon in=pdB right_of=g5
  p4l = enclose p4c li net=X
  p5c = array licon in=pdC left_of=g6
  p5l = enclose p5c li net=n3
  p6c = array licon in=pdC right_of=g7
  p6l = enclose p6c li net=VPWR
  p6s = strap li from=p6l to=vpwr_li

  n3v = strap li from=n5l to=p5l
  cb = max(ndA.top + 0.19, ndB.top + 0.19, ndC.top + 0.19, n1l.top + 0.25, n2l.top + 0.25, n3l.top + 0.25, n4l.top + 0.25, n5l.top + 0.25, n6l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=C
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=n3
  gc6 = contact licon cx=(g6.cx + 0.13) bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=C
  gc7 = contact licon cx=(g7.cx + 0.13) bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=A
  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc
  well y=((max(ndA.top, ndB.top, ndC.top) + 0.34 + min(pdA.bottom, pdB.bottom, pdC.bottom) - 0.18) / 2)

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bs = strap li from=gl2 to=gl3
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl4
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  port X out
  route A layers=m1,m2 prefer=m2
  route C layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
end
