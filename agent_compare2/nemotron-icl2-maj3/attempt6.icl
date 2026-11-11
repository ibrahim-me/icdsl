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

  # Gate order (same on both rows): A B | C | n3 | A | B | C
  # NMOS islands:
  #   nd1: g1(A)-g2(B) = M4-M1: VGND-[A]-n2-[B]-n3
  #   nd2: g3(C) = M9: n4-[C]-VGND
  #   nd3: g4(n3) = M3: VGND-[n3]-X
  #   nd4: g5(A) = M5: n5-[A]-VGND
  #   nd5: g6(B) = M2: n3-[B]-n4
  #   nd6: g7(C) = M10: n3-[C]-n5
  # PMOS islands:
  #   pd1: g1(A) = M0: VPWR-[A]-n1
  #   pd2: g2(B) = M13: n7-[B]-n3
  #   pd3: g3(C) = M11: n1-[C]-n3
  #   pd4: g4(n3) = M8: VPWR-[n3]-X
  #   pd5: g5(A) = M12: VPWR-[A]-n7
  #   pd6: g6(C) = M7: VPWR-[C]-n6
  #   pd7: g7(B) = M6: n3-[B]-n6
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # Gate positions: A B | C | n3 | A | B | C
  g1 = rect poly w=L left=(cell.left + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C (break)
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n3 (break)
  g5 = rect poly w=L left=(g4.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A (break)
  g6 = rect poly w=L left=(g5.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B (break)
  g7 = rect poly w=L left=(g6.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C (break)

  # NMOS diffusion islands
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)   # M4 M1
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN2)   # M9
  nd3 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)    # M3
  nd4 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN2)   # M5
  nd5 = rect diff xspan=(g6.left - 0.265, g6.right + 0.265) yspan=(ny0, ny0 + WN2)   # M2
  nd6 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(ny0, ny0 + WN2)   # M10

  # PMOS diffusion islands
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP2, py1)   # M0
  pd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(py1 - WP2, py1)   # M13
  pd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP2, py1)   # M11
  pd4 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)    # M8
  pd5 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(py1 - WP2, py1)   # M12
  pd6 = rect diff xspan=(g6.left - 0.265, g6.right + 0.265) yspan=(py1 - WP2, py1)   # M7
  pd7 = rect diff xspan=(g7.left - 0.265, g7.right + 0.265) yspan=(py1 - WP2, py1)   # M6

  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7] psdm

  # Explicit n-well covering all p-diffs with proper margins
  nw_bottom = min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom, pd5.bottom, pd6.bottom, pd7.bottom) - 0.18
  nw_top = py1 + 0.2
  nw = rect nwell xspan=(cell.left, cell.right) yspan=(nw_bottom, nw_top)

  # NMOS contacts
  # nd1: M4(d=VGND,g=A,s=n2) M1(d=n2,g=B,s=n3)
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=n3

  # nd2: M9(d=n4,g=C,s=VGND)
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=n4
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li

  # nd3: M3(d=VGND,g=n3,s=X)
  c6 = array licon in=nd3 left_of=g4
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li
  c7 = array licon in=nd3 right_of=g4
  c7l = enclose c7 li net=X

  # nd4: M5(d=n5,g=A,s=VGND)
  c8 = array licon in=nd4 left_of=g5
  c8l = enclose c8 li net=n5
  c9 = array licon in=nd4 right_of=g5
  c9l = enclose c9 li net=VGND
  c9s = strap li from=c9l to=vgnd_li

  # nd5: M2(d=n3,g=B,s=n4)
  c10 = array licon in=nd5 left_of=g6
  c10l = enclose c10 li net=n3
  c11 = array licon in=nd5 right_of=g6
  c11l = enclose c11 li net=n4

  # nd6: M10(d=n3,g=C,s=n5)
  c12 = array licon in=nd6 left_of=g7
  c12l = enclose c12 li net=n3
  c13 = array licon in=nd6 right_of=g7
  c13l = enclose c13 li net=n5

  # PMOS contacts
  # pd1: M0(d=n1,g=A,s=VPWR)
  c14 = array licon in=pd1 left_of=g1
  c14l = enclose c14 li net=n1
  c15 = array licon in=pd1 right_of=g1
  c15l = enclose c15 li net=VPWR
  c15s = strap li from=c15l to=vpwr_li

  # pd2: M13(d=n7,g=B,s=n3)
  c16 = array licon in=pd2 left_of=g2
  c16l = enclose c16 li net=n7
  c17 = array licon in=pd2 right_of=g2
  c17l = enclose c17 li net=n3

  # pd3: M11(d=n3,g=C,s=n1)
  c18 = array licon in=pd3 left_of=g3
  c18l = enclose c18 li net=n3
  c19 = array licon in=pd3 right_of=g3
  c19l = enclose c19 li net=n1

  # pd4: M8(d=VPWR,g=n3,s=X)
  c20 = array licon in=pd4 left_of=g4
  c20l = enclose c20 li net=VPWR
  c20s = strap li from=c20l to=vpwr_li
  c21 = array licon in=pd4 right_of=g4
  c21l = enclose c21 li net=X

  # pd5: M12(d=VPWR,g=A,s=n7)
  c22 = array licon in=pd5 left_of=g5
  c22l = enclose c22 li net=VPWR
  c22s = strap li from=c22l to=vpwr_li
  c23 = array licon in=pd5 right_of=g5
  c23l = enclose c23 li net=n7

  # pd6: M7(d=n6,g=C,s=VPWR)
  c24 = array licon in=pd6 left_of=g6
  c24l = enclose c24 li net=n6
  c25 = array licon in=pd6 right_of=g6
  c25l = enclose c25 li net=VPWR
  c25s = strap li from=c25l to=vpwr_li

  # pd7: M6(d=n3,g=B,s=n6)
  c26 = array licon in=pd7 left_of=g7
  c26l = enclose c26 li net=n3
  c27 = array licon in=pd7 right_of=g7
  c27l = enclose c27 li net=n6

  # Gate contacts (cb from n-row items only)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, nd4.top + 0.19,
           nd5.top + 0.19, nd6.top + 0.19,
           c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25,
           c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25,
           c9l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25, c12l.top + 0.25,
           c13l.top + 0.25)
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
  gn = enclose [gc1, gc2, gc3, gc4, gc5, gc6, gc7] npc

  well y=((max(nd1.top, nd2.top, nd3.top, nd4.top, nd5.top, nd6.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom, pd5.bottom, pd6.bottom, pd7.bottom) - 0.18) / 2)

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
  xm = contact mcon in=c21l
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp

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
