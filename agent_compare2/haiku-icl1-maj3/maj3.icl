pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=11 height=H
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

  # N row (bottom) chain, left to right: VGND M5(A) n5 M10(C) n3 M2(B) n4 M9(C) VGND M4(A) n2 M1(B) n3
  # P row (top) chain, left to right:    VPWR M0(A) n1 M11(C) n3 M6(B) n6 M7(C) VPWR M12(A) n7 M13(B) n3
  # gate columns g1..g6 = A C B C A B (both rows), g7 = n3 (inverter M3 / M8, X on its right)
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 7*L + 5*max(0.28, 0.54 - L) + 0.80
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g4 = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g6 = rect poly w=L left=(g5.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  g7 = rect poly w=L left=(g6.right + 0.80) yspan=(ny0 - 0.13, py1 + 0.13)

  nd1 = rect diff xspan=(g1.left - 0.265, g6.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g6.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # n row contacts
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 between=[g1, g2]
  c2l = enclose c2 li net=n5
  c3 = array licon in=nd1 between=[g2, g3]
  c3l = enclose c3 li net=n3
  c4 = array licon in=nd1 between=[g3, g4]
  c4l = enclose c4 li net=n4
  c5 = array licon in=nd1 between=[g4, g5]
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=nd1 right_of=g6
  c6l = enclose c6 li net=n3

  # p row contacts
  d1 = array licon in=pd1 left_of=g1
  d1l = enclose d1 li net=VPWR
  d1s = strap li from=d1l to=vpwr_li
  d2 = array licon in=pd1 between=[g1, g2]
  d2l = enclose d2 li net=n1
  d3 = array licon in=pd1 between=[g2, g3]
  d3l = enclose d3 li net=n3
  d4 = array licon in=pd1 between=[g3, g4]
  d4l = enclose d4 li net=n6
  d5 = array licon in=pd1 between=[g4, g5]
  d5l = enclose d5 li net=VPWR
  d5s = strap li from=d5l to=vpwr_li
  d6 = array licon in=pd1 right_of=g6
  d6l = enclose d6 li net=n3

  # inverter: N drain/source, P drain/source, output strap on X
  e1 = array licon in=nd2 left_of=g7
  e1l = enclose e1 li net=VGND
  e1s = strap li from=e1l to=vgnd_li
  e2 = array licon in=nd2 right_of=g7
  e2l = enclose e2 li net=X
  f1 = array licon in=pd2 left_of=g7
  f1l = enclose f1 li net=VPWR
  f1s = strap li from=f1l to=vpwr_li
  f2 = array licon in=pd2 right_of=g7
  f2l = enclose f2 li net=X
  xs = strap li from=e2l to=f2l net=X

  # gate contacts in the middle gap (n-row tops and n-row contact li only)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, e1l.top + 0.25, e2l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=C
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=C
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A
  gc6 = contact licon cx=g6.cx bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=B
  gc7 = contact licon cx=(g7.cx - 0.13) bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=n3
  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc

  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  # explicit met1 landings for the n3 pieces so the router starts from a full pad
  q1m = contact mcon in=c3l
  q1p = enclose q1m m1 by=0.06 net=n3
  q2m = contact mcon in=c6l
  q2p = enclose q2m m1 by=0.06 net=n3
  q3m = contact mcon in=d3l
  q3p = enclose q3m m1 by=0.06 net=n3
  q4m = contact mcon in=d6l
  q4p = enclose q4m m1 by=0.06 net=n3
  q5m = contact mcon in=gl7
  q5p = enclose q5m m1 by=0.06 net=n3
  route n3 layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
  route C layers=m1,m2 prefer=m2

  am1 = contact mcon in=gl1
  ap1 = enclose am1 m1 by=0.06 net=A
  port A in on=ap1
  bm1 = contact mcon in=gl6
  bp1 = enclose bm1 m1 by=0.06 net=B
  port B in on=bp1
  cm1 = contact mcon in=gl2
  cp1 = enclose cm1 m1 by=0.06 net=C
  port C in on=cp1
  xm = contact mcon in=xs cy=pd2.cy
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
