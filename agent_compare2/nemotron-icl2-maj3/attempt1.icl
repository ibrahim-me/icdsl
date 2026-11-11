pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell maj3 width=14 height=H
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

  # stick plan (gate order A B C n3 A B C n3; | = diffusion break)
  #   p: VPWR [A] n1 [B] n6 [C] VPWR | n3 [C] n1 [A] VPWR | n7 [B] n3 | VPWR [n3] X |
  #   n: VGND [A] n2 [B] n3 [B] n4 [C] VGND | VGND [A] n5 [C] n3 [C] n3 | VGND [n3] X |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # Gate positions (same order on both rows): A B C n3 | A B C n3
  g1 = rect poly w=L left=(cell.left + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3 (break)
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g6 = rect poly w=L left=(g5.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g7 = rect poly w=L left=(g6.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  g8 = rect poly w=L left=(g7.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3 (break)

  # NMOS diffusion islands
  # Island 1: g1(A) g2(B) g3(B) g3(C) - M4 M1 M2 M9
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN2)
  # Island 2: g5(A) g7(C) - M5 M10
  nd2 = rect diff xspan=(g5.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN2)
  # Island 3: g8(n3) - M3
  nd3 = rect diff xspan=(g8.left - 0.265, g8.right + 0.265) yspan=(ny0, ny0 + WN)

  # PMOS diffusion islands
  # Island 1: g1(A) g2(B) g3(C) - M0 M6 M7
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP2, py1)
  # Island 2: g4(n3) g5(A) g7(C) - M8 M12 M11
  pd2 = rect diff xspan=(g4.left - 0.265, g7.right + 0.265) yspan=(py1 - WP, py1)
  # Island 3: g6(B) g8(n3) - M13 M8
  pd3 = rect diff xspan=(g6.left - 0.265, g8.right + 0.265) yspan=(py1 - WP2, py1)

  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm

  # NMOS contacts
  # nd1: M4(d=VGND,g=A,s=n2) M1(d=n2,g=B,s=n3) M2(d=n3,g=B,s=n4) M9(d=n4,g=C,s=VGND)
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n3
  c4 = array licon in=nd1 right_of=g3
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li

  # nd2: M5(d=n5,g=A,s=VGND) M10(d=n3,g=C,s=n5)
  c5 = array licon in=nd2 left_of=g5
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=nd2 right_of=g5
  c6l = enclose c6 li net=n5
  c7 = array licon in=nd2 right_of=g7
  c7l = enclose c7 li net=n3

  # nd3: M3(d=VGND,g=n3,s=X)
  c8 = array licon in=nd3 left_of=g8
  c8l = enclose c8 li net=VGND
  c8s = strap li from=c8l to=vgnd_li
  c9 = array licon in=nd3 right_of=g8
  c9l = enclose c9 li net=X

  # PMOS contacts
  # pd1: M0(d=n1,g=A,s=VPWR) M6(d=n3,g=B,s=n6) M7(d=n6,g=C,s=VPWR)
  c10 = array licon in=pd1 left_of=g1
  c10l = enclose c10 li net=VPWR
  c10s = strap li from=c10l to=vpwr_li
  c11 = array licon in=pd1 right_of=g1
  c11l = enclose c11 li net=n1
  c12 = array licon in=pd1 right_of=g2
  c12l = enclose c12 li net=n6
  c13 = array licon in=pd1 right_of=g3
  c13l = enclose c13 li net=VPWR
  c13s = strap li from=c13l to=vpwr_li

  # pd2: M8(d=VPWR,g=n3,s=X) M12(d=VPWR,g=A,s=n7) M11(d=n3,g=C,s=n1)
  c14 = array licon in=pd2 left_of=g4
  c14l = enclose c14 li net=X
  c15 = array licon in=pd2 right_of=g4
  c15l = enclose c15 li net=n7
  c16 = array licon in=pd2 right_of=g5
  c16l = enclose c16 li net=VPWR
  c16s = strap li from=c16l to=vpwr_li
  c17 = array licon in=pd2 right_of=g7
  c17l = enclose c17 li net=n1

  # pd3: M13(d=n7,g=B,s=n3) M8(d=VPWR,g=n3,s=X)
  c18 = array licon in=pd3 left_of=g6
  c18l = enclose c18 li net=n3
  c19 = array licon in=pd3 right_of=g6
  c19l = enclose c19 li net=n7
  c20 = array licon in=pd3 right_of=g8
  c20l = enclose c20 li net=VPWR
  c20s = strap li from=c20l to=vpwr_li

  # Gate contacts (cb from n-row items only)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25,
           c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25,
           c8l.top + 0.25, c9l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=C
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=n3
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A
  gc6 = contact licon cx=g6.cx bottom=cb
  gp6 = enclose gc6 poly by=minx
  gl6 = enclose gc6 li net=B
  gc7 = contact licon cx=g7.cx bottom=cb
  gp7 = enclose gc7 poly by=minx
  gl7 = enclose gc7 li net=C
  gc8 = contact licon cx=g8.cx bottom=cb
  gp8 = enclose gc8 poly by=minx
  gl8 = enclose gc8 li net=n3
  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7, gc8] npc

  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom) - 0.18) / 2)

  # Ports
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  port X out

  # Routes
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route n6 layers=m1,m2 prefer=m2
  route n7 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
  route C layers=m1,m2 prefer=m2
end
