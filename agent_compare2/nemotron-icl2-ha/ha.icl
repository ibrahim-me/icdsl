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

  # Gate order: A B A B n1 n1 n3  (7 columns)
  # n-row: g1=A(M8:VGND/n2) g2=B(M0:n2/n1) | g3=A(M4:n4/VGND) g4=B(M11:VGND/n4) g5=n1(M1:n4/n3) | g6=n1(M12:COUT/VGND) g7=n3(M7:VGND/SUM)
  #   breaks: g2-g3 (n1 vs n4), g5-g6 (n3 vs COUT)
  # p-row: g1=A(M2:VPWR/n1) g2=B(M13:n1/VPWR) g3=A(M6:VPWR/n5) g4=B(M5:n5/n3) g5=n1(M10:n3/VPWR) | g6=n1(M3:COUT/VPWR) g7=n3(M9:VPWR/SUM)
  #   break: g5-g6 (VPWR vs COUT)
  #
  # n-row islands: [g1-g2] [g3-g5] [g6-g7]
  # p-row islands: [g1-g5] [g6-g7]

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  gc_gap = max(0.28, 0.54 - L)          # gap between gates with contact column
  br_gap = max(0.80, 0.54 - L)          # gap at diffusion island break

  # 7 gates with breaks at g2-g3 and g5-g6
  span = 0.53 + 7*L + 4*gc_gap + 2*br_gap
  x0 = cell.cx - span/2
  g1  = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2  = rect poly w=L left=(g1.right + gc_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3  = rect poly w=L left=(g2.right + br_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A (n-row break)
  g4  = rect poly w=L left=(g3.right + gc_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g5  = rect poly w=L left=(g4.right + gc_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g6  = rect poly w=L left=(g5.right + br_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1 (break both rows)
  g7  = rect poly w=L left=(g6.right + gc_gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3

  # n-row diffusions (3 islands)
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g3.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd3 = rect diff xspan=(g6.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN)

  # p-row diffusions (2 islands)
  pd1 = rect diff xspan=(g1.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g6.left - 0.265, g7.right + 0.265) yspan=(py1 - WP, py1)

  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2] psdm

  # === n-row contacts ===
  # Island 1 (nd1, gates g1-g2): VGND [A] n2 [B] n1
  c1  = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2  = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3  = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n1

  # Island 2 (nd2, gates g3-g5): n4 [A] VGND [B] n4 [n1] n3
  c4  = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=n4
  c5  = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6  = array licon in=nd2 right_of=g4
  c6l = enclose c6 li net=n4
  c7  = array licon in=nd2 right_of=g5
  c7l = enclose c7 li net=n3

  # Island 3 (nd3, gates g6-g7): COUT [n1] VGND [n3] SUM
  c8  = array licon in=nd3 left_of=g6
  c8l = enclose c8 li net=COUT
  c9  = array licon in=nd3 right_of=g6
  c9l = enclose c9 li net=VGND
  c9s = strap li from=c9l to=vgnd_li
  c10 = array licon in=nd3 right_of=g7
  c10l = enclose c10 li net=SUM

  # === p-row contacts ===
  # Island 1 (pd1, gates g1-g5): VPWR [A] n1 [B] VPWR [A] n5 [B] n3 [n1] VPWR
  c11 = array licon in=pd1 left_of=g1
  c11l = enclose c11 li net=VPWR
  c11s = strap li from=c11l to=vpwr_li
  c12 = array licon in=pd1 right_of=g1
  c12l = enclose c12 li net=n1
  c13 = array licon in=pd1 right_of=g2
  c13l = enclose c13 li net=VPWR
  c13s = strap li from=c13l to=vpwr_li
  c14 = array licon in=pd1 right_of=g3
  c14l = enclose c14 li net=n5
  c15 = array licon in=pd1 right_of=g4
  c15l = enclose c15 li net=n3
  c16 = array licon in=pd1 right_of=g5
  c16l = enclose c16 li net=VPWR
  c16s = strap li from=c16l to=vpwr_li

  # Island 2 (pd2, gates g6-g7): COUT [n1] VPWR [n3] SUM
  c17 = array licon in=pd2 left_of=g6
  c17l = enclose c17 li net=COUT
  c18 = array licon in=pd2 right_of=g6
  c18l = enclose c18 li net=VPWR
  c18s = strap li from=c18l to=vpwr_li
  c19 = array licon in=pd2 right_of=g7
  c19l = enclose c19 li net=SUM

  # === gate contacts (cb uses ONLY n-row items per lesson 1) ===
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25,
           c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25,
           c9l.top + 0.25, c10l.top + 0.25)

  gc1  = contact licon cx=g1.cx bottom=cb
  gp1  = enclose gc1 poly by=minx
  gl1  = enclose gc1 li net=A
  gc2  = contact licon cx=g2.cx bottom=cb
  gp2  = enclose gc2 poly by=minx
  gl2  = enclose gc2 li net=B
  gc3  = contact licon cx=g3.cx bottom=cb
  gp3  = enclose gc3 poly by=minx
  gl3  = enclose gc3 li net=A
  gc4  = contact licon cx=g4.cx bottom=cb
  gp4  = enclose gc4 poly by=minx
  gl4  = enclose gc4 li net=B
  gc5  = contact licon cx=g5.cx bottom=cb
  gp5  = enclose gc5 poly by=minx
  gl5  = enclose gc5 li net=n1
  gc6  = contact licon cx=g6.cx bottom=cb
  gp6  = enclose gc6 poly by=minx
  gl6  = enclose gc6 li net=n1
  gc7  = contact licon cx=g7.cx bottom=cb
  gp7  = enclose gc7 poly by=minx
  gl7  = enclose gc7 li net=n3

  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc

  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  # === ports ===
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  coutm = contact mcon in=c8l
  coutp = enclose coutm m1 by=0.06 net=COUT
  port COUT out on=coutp
  summ = contact mcon in=c10l
  sump = enclose summ m1 by=0.06 net=SUM
  port SUM out on=sump

  # === routing ===
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