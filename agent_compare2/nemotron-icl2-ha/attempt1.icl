pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=14 height=H
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

  # Gate order: A B n1 A B n1 A B n1 n3 n3 | n3 n3
  # n-row islands: [g1-g9] | [g10-g11] | [g12-g14]
  # p-row islands: [g1-g9] | [g10-g11] | [g12-g14]
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # 14 gates placed left to right
  g1  = rect poly w=L left=(cell.cx - (0.53 + 13*L + 0.28*8 + 0.21*3 + 0.80*2)/2 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2  = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3  = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g4  = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g5  = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g6  = rect poly w=L left=(g5.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g7  = rect poly w=L left=(g6.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g8  = rect poly w=L left=(g7.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g9  = rect poly w=L left=(g8.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g10 = rect poly w=L left=(g9.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3
  g11 = rect poly w=L left=(g10.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3
  g12 = rect poly w=L left=(g11.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3
  g13 = rect poly w=L left=(g12.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3
  g14 = rect poly w=L left=(g13.right + max(0.21, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3

  # n-row diffusions (3 islands)
  nd1 = rect diff xspan=(g1.left - 0.265, g9.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g10.left - 0.265, g11.right + 0.265) yspan=(ny0, ny0 + WN)
  nd3 = rect diff xspan=(g12.left - 0.265, g14.right + 0.265) yspan=(ny0, ny0 + WN)

  # p-row diffusions (3 islands)
  pd1 = rect diff xspan=(g1.left - 0.265, g9.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g10.left - 0.265, g11.right + 0.265) yspan=(py1 - WP, py1)
  pd3 = rect diff xspan=(g12.left - 0.265, g14.right + 0.265) yspan=(py1 - WP, py1)

  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm

  # === n-row contacts ===
  # Island 1 (nd1, gates g1-g9): VGND [A] n2 [B] n1 [n1] n4 [A] VGND [B] n4 [A] n2 [n1] COUT [B] VGND
  c1  = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2  = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3  = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n1
  c4  = array licon in=nd1 right_of=g3
  c4l = enclose c4 li net=n4
  c5  = array licon in=nd1 right_of=g4
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6  = array licon in=nd1 right_of=g5
  c6l = enclose c6 li net=n4
  c7  = array licon in=nd1 right_of=g6
  c7l = enclose c7 li net=n2
  c8  = array licon in=nd1 right_of=g7
  c8l = enclose c8 li net=VGND
  c8s = strap li from=c8l to=vgnd_li
  c9  = array licon in=nd1 right_of=g8
  c9l = enclose c9 li net=n4
  c10 = array licon in=nd1 right_of=g9
  c10l = enclose c10 li net=COUT

  # Island 2 (nd2, gates g10-g11): VGND [n3] SUM [n3] VGND
  c11 = array licon in=nd2 left_of=g10
  c11l = enclose c11 li net=VGND
  c11s = strap li from=c11l to=vgnd_li
  c12 = array licon in=nd2 right_of=g10
  c12l = enclose c12 li net=SUM
  c13 = array licon in=nd2 right_of=g11
  c13l = enclose c13 li net=VGND
  c13s = strap li from=c13l to=vgnd_li

  # Island 3 (nd3, gates g12-g14): VGND [n3] COUT [n3] VGND [n3] VGND
  c14 = array licon in=nd3 left_of=g12
  c14l = enclose c14 li net=VGND
  c14s = strap li from=c14l to=vgnd_li
  c15 = array licon in=nd3 right_of=g12
  c15l = enclose c15 li net=COUT
  c16 = array licon in=nd3 right_of=g13
  c16l = enclose c16 li net=VGND
  c16s = strap li from=c16l to=vgnd_li
  c17 = array licon in=nd3 right_of=g14
  c17l = enclose c17 li net=VGND
  c17s = strap li from=c17l to=vgnd_li

  # === p-row contacts ===
  # Island 1 (pd1, gates g1-g9): VPWR [A] n1 [B] VPWR [n1] COUT [A] n5 [B] n3 [A] VPWR [n1] VPWR [B] n1
  c18 = array licon in=pd1 left_of=g1
  c18l = enclose c18 li net=VPWR
  c18s = strap li from=c18l to=vpwr_li
  c19 = array licon in=pd1 right_of=g1
  c19l = enclose c19 li net=n1
  c20 = array licon in=pd1 right_of=g2
  c20l = enclose c20 li net=VPWR
  c20s = strap li from=c20l to=vpwr_li
  c21 = array licon in=pd1 right_of=g3
  c21l = enclose c21 li net=COUT
  c22 = array licon in=pd1 right_of=g4
  c22l = enclose c22 li net=n5
  c23 = array licon in=pd1 right_of=g5
  c23l = enclose c23 li net=n3
  c24 = array licon in=pd1 right_of=g6
  c24l = enclose c24 li net=VPWR
  c24s = strap li from=c24l to=vpwr_li
  c25 = array licon in=pd1 right_of=g7
  c25l = enclose c25 li net=n1
  c26 = array licon in=pd1 right_of=g8
  c26l = enclose c26 li net=VPWR
  c26s = strap li from=c26l to=vpwr_li
  c27 = array licon in=pd1 right_of=g9
  c27l = enclose c27 li net=n1

  # Island 2 (pd2, gates g10-g11): VPWR [n3] SUM [n3] VPWR
  c28 = array licon in=pd2 left_of=g10
  c28l = enclose c28 li net=VPWR
  c28s = strap li from=c28l to=vpwr_li
  c29 = array licon in=pd2 right_of=g10
  c29l = enclose c29 li net=SUM
  c30 = array licon in=pd2 right_of=g11
  c30l = enclose c30 li net=VPWR
  c30s = strap li from=c30l to=vpwr_li

  # Island 3 (pd3, gates g12-g14): VPWR [n3] VPWR [n3] VPWR [n3] VPWR
  c31 = array licon in=pd3 left_of=g12
  c31l = enclose c31 li net=VPWR
  c31s = strap li from=c31l to=vpwr_li
  c32 = array licon in=pd3 right_of=g12
  c32l = enclose c32 li net=VPWR
  c32s = strap li from=c32l to=vpwr_li
  c33 = array licon in=pd3 right_of=g13
  c33l = enclose c33 li net=VPWR
  c33s = strap li from=c33l to=vpwr_li
  c34 = array licon in=pd3 right_of=g14
  c34l = enclose c34 li net=VPWR
  c34s = strap li from=c34l to=vpwr_li

  # === gate contacts ===
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25,
           c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25,
           c9l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25, c12l.top + 0.25,
           c13l.top + 0.25, c14l.top + 0.25, c15l.top + 0.25, c16l.top + 0.25,
           c17l.top + 0.25)

  gc1  = contact licon cx=g1.cx bottom=cb
  gp1  = enclose gc1 poly by=minx
  gl1  = enclose gc1 li net=A
  gc2  = contact licon cx=g2.cx bottom=cb
  gp2  = enclose gc2 poly by=minx
  gl2  = enclose gc2 li net=B
  gc3  = contact licon cx=g3.cx bottom=cb
  gp3  = enclose gc3 poly by=minx
  gl3  = enclose gc3 li net=n1
  gc4  = contact licon cx=g4.cx bottom=cb
  gp4  = enclose gc4 poly by=minx
  gl4  = enclose gc4 li net=A
  gc5  = contact licon cx=g5.cx bottom=cb
  gp5  = enclose gc5 poly by=minx
  gl5  = enclose gc5 li net=B
  gc6  = contact licon cx=g6.cx bottom=cb
  gp6  = enclose gc6 poly by=minx
  gl6  = enclose gc6 li net=n1
  gc7  = contact licon cx=g7.cx bottom=cb
  gp7  = enclose gc7 poly by=minx
  gl7  = enclose gc7 li net=A
  gc8  = contact licon cx=g8.cx bottom=cb
  gp8  = enclose gc8 poly by=minx
  gl8  = enclose gc8 li net=B
  gc9  = contact licon cx=g9.cx bottom=cb
  gp9  = enclose gc9 poly by=minx
  gl9  = enclose gc9 li net=n1
  gc10 = contact licon cx=g10.cx bottom=cb
  gp10 = enclose gc10 poly by=minx
  gl10 = enclose gc10 li net=n3
  gc11 = contact licon cx=g11.cx bottom=cb
  gp11 = enclose gc11 poly by=minx
  gl11 = enclose gc11 li net=n3
  gc12 = contact licon cx=g12.cx bottom=cb
  gp12 = enclose gc12 poly by=minx
  gl12 = enclose gc12 li net=n3
  gc13 = contact licon cx=g13.cx bottom=cb
  gp13 = enclose gc13 poly by=minx
  gl13 = enclose gc13 li net=n3
  gc14 = contact licon cx=g14.cx bottom=cb
  gp14 = enclose gc14 poly by=minx
  gl14 = enclose gc14 li net=n3

  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7, gc8, gc9, gc10, gc11, gc12, gc13, gc14] npc

  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom) - 0.18) / 2)

  # === ports ===
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port COUT out
  port SUM out

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