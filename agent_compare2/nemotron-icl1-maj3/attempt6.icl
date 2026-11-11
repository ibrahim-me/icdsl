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

  # Gate order: A B C n3 A B C (same poly strips cross both rows)
  # NMOS islands (one transistor each): VGND[A]n2 | n2[B]n3 | n3[B]n4 | n4[C]VGND | VGND[A]n5 | n5[C]n3 | VGND[n3]X
  # PMOS islands (one transistor each): VPWR[A]n1 | n1[C]n3 | n3[B]n6 | n6[C]VPWR | VPWR[A]n7 | n7[B]n3 | X[n3]VPWR

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  # Gate positions (breaks >= 0.80 between islands, >= 0.28 within islands)
  gA1 = rect poly w=L left=(cell.cx/2 - 2.0) yspan=(ny0 - 0.13, py1 + 0.13)
  gB1 = rect poly w=L left=(gA1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gC1 = rect poly w=L left=(gB1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gN  = rect poly w=L left=(gC1.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gA2 = rect poly w=L left=(gN.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gB2 = rect poly w=L left=(gA2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gC2 = rect poly w=L left=(gB2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)

  # NMOS diffusion islands (one per transistor, non-overlapping)
  nd1 = rect diff xspan=(gA1.left - 0.265, gA1.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(gB1.left - 0.265, gB1.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd3 = rect diff xspan=(gB2.left - 0.265, gB2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd4 = rect diff xspan=(gC1.left - 0.265, gC1.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd5 = rect diff xspan=(gA2.left - 0.265, gA2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd6 = rect diff xspan=(gC2.left - 0.265, gC2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd7 = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(ny0, ny0 + WN)

  # PMOS diffusion islands (one per transistor, non-overlapping)
  pd1 = rect diff xspan=(gA1.left - 0.265, gA1.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(gC1.left - 0.265, gC1.right + 0.265) yspan=(py1 - WP2, py1)
  pd3 = rect diff xspan=(gB1.left - 0.265, gB1.right + 0.265) yspan=(py1 - WP2, py1)
  pd4 = rect diff xspan=(gC2.left - 0.265, gC2.right + 0.265) yspan=(py1 - WP2, py1)
  pd5 = rect diff xspan=(gA2.left - 0.265, gA2.right + 0.265) yspan=(py1 - WP2, py1)
  pd6 = rect diff xspan=(gB2.left - 0.265, gB2.right + 0.265) yspan=(py1 - WP2, py1)
  pd7 = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(py1 - WP, py1)

  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7] psdm

  # NMOS contacts
  # Island 1: VGND [A1] n2 (M4: d=VGND g=A s=n2)
  c1_l = array licon in=nd1 left_of=gA1
  c1_l_l = enclose c1_l li net=VGND
  c1_r = array licon in=nd1 right_of=gA1
  c1_r_l = enclose c1_r li net=n2

  # Island 2: n2 [B1] n3 (M1: d=n2 g=B s=n3)
  c2_l = array licon in=nd2 left_of=gB1
  c2_l_l = enclose c2_l li net=n2
  c2_r = array licon in=nd2 right_of=gB1
  c2_r_l = enclose c2_r li net=n3

  # Island 3: n3 [B2] n4 (M2: d=n3 g=B s=n4)
  c3_l = array licon in=nd3 left_of=gB2
  c3_l_l = enclose c3_l li net=n3
  c3_r = array licon in=nd3 right_of=gB2
  c3_r_l = enclose c3_r li net=n4

  # Island 4: n4 [C1] VGND (M9: d=n4 g=C s=VGND)
  c4_l = array licon in=nd4 left_of=gC1
  c4_l_l = enclose c4_l li net=n4
  c4_r = array licon in=nd4 right_of=gC1
  c4_r_l = enclose c4_r li net=VGND

  # Island 5: VGND [A2] n5 (M5: d=n5 g=A s=VGND)
  c5_l = array licon in=nd5 left_of=gA2
  c5_l_l = enclose c5_l li net=VGND
  c5_r = array licon in=nd5 right_of=gA2
  c5_r_l = enclose c5_r li net=n5

  # Island 6: n5 [C2] n3 (M10: d=n3 g=C s=n5)
  c6_l = array licon in=nd6 left_of=gC2
  c6_l_l = enclose c6_l li net=n5
  c6_r = array licon in=nd6 right_of=gC2
  c6_r_l = enclose c6_r li net=n3

  # Island 7: VGND [N] X (M3: d=VGND g=n3 s=X)
  c7_l = array licon in=nd7 left_of=gN
  c7_l_l = enclose c7_l li net=VGND
  c7_r = array licon in=nd7 right_of=gN
  c7_r_l = enclose c7_r li net=X

  # PMOS contacts
  # Island 1: VPWR [A1] n1 (M0: d=n1 g=A s=VPWR)
  d1_l = array licon in=pd1 left_of=gA1
  d1_l_l = enclose d1_l li net=VPWR
  d1_r = array licon in=pd1 right_of=gA1
  d1_r_l = enclose d1_r li net=n1

  # Island 2: n1 [C1] n3 (M11: d=n3 g=C s=n1)
  d2_l = array licon in=pd2 left_of=gC1
  d2_l_l = enclose d2_l li net=n1
  d2_r = array licon in=pd2 right_of=gC1
  d2_r_l = enclose d2_r li net=n3

  # Island 3: n3 [B1] n6 (M6: d=n3 g=B s=n6)
  d3_l = array licon in=pd3 left_of=gB1
  d3_l_l = enclose d3_l li net=n3
  d3_r = array licon in=pd3 right_of=gB1
  d3_r_l = enclose d3_r li net=n6

  # Island 4: n6 [C2] VPWR (M7: d=n6 g=C s=VPWR)
  d4_l = array licon in=pd4 left_of=gC2
  d4_l_l = enclose d4_l li net=n6
  d4_r = array licon in=pd4 right_of=gC2
  d4_r_l = enclose d4_r li net=VPWR

  # Island 5: VPWR [A2] n7 (M12: d=VPWR g=A s=n7)
  d5_l = array licon in=pd5 left_of=gA2
  d5_l_l = enclose d5_l li net=VPWR
  d5_r = array licon in=pd5 right_of=gA2
  d5_r_l = enclose d5_r li net=n7

  # Island 6: n7 [B2] n3 (M13: d=n7 g=B s=n3)
  d6_l = array licon in=pd6 left_of=gB2
  d6_l_l = enclose d6_l li net=n7
  d6_r = array licon in=pd6 right_of=gB2
  d6_r_l = enclose d6_r li net=n3

  # Island 7: X [N] VPWR (M8: d=VPWR g=n3 s=X)
  d7_l = array licon in=pd7 left_of=gN
  d7_l_l = enclose d7_l li net=X
  d7_r = array licon in=pd7 right_of=gN
  d7_r_l = enclose d7_r li net=VPWR

  # Supply straps
  s1 = strap li from=c1_l_l to=vgnd_li cy=vgnd_li.cy
  s2 = strap li from=c4_r_l to=vgnd_li cy=vgnd_li.cy
  s3 = strap li from=c5_l_l to=vgnd_li cy=vgnd_li.cy
  s4 = strap li from=c7_l_l to=vgnd_li cy=vgnd_li.cy
  s5 = strap li from=d1_l_l to=vpwr_li cy=vpwr_li.cy
  s6 = strap li from=d4_r_l to=vpwr_li cy=vpwr_li.cy
  s7 = strap li from=d5_l_l to=vpwr_li cy=vpwr_li.cy
  s8 = strap li from=d7_r_l to=vpwr_li cy=vpwr_li.cy

  # Internal net routes
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n6 layers=m1,m2 prefer=m2
  route n7 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2

  # Gate contacts
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, nd4.top + 0.19,
           nd5.top + 0.19, nd6.top + 0.19, nd7.top + 0.19,
           c1_l_l.top + 0.25, c1_r_l.top + 0.25,
           c2_l_l.top + 0.25, c2_r_l.top + 0.25,
           c3_l_l.top + 0.25, c3_r_l.top + 0.25,
           c4_l_l.top + 0.25, c4_r_l.top + 0.25,
           c5_l_l.top + 0.25, c5_r_l.top + 0.25,
           c6_l_l.top + 0.25, c6_r_l.top + 0.25,
           c7_l_l.top + 0.25, c7_r_l.top + 0.25)

  gcA1 = contact licon cx=gA1.cx bottom=cb
  gpA1 = enclose gcA1 poly by=minx
  glA1 = enclose gcA1 li net=A

  gcB1 = contact licon cx=gB1.cx bottom=cb
  gpB1 = enclose gcB1 poly by=minx
  glB1 = enclose gcB1 li net=B

  gcC1 = contact licon cx=gC1.cx bottom=cb
  gpC1 = enclose gcC1 poly by=minx
  glC1 = enclose gcC1 li net=C

  gcN = contact licon cx=gN.cx bottom=cb
  gpN = enclose gcN poly by=minx
  glN = enclose gcN li net=n3

  gcA2 = contact licon cx=gA2.cx bottom=cb
  gpA2 = enclose gcA2 poly by=minx
  glA2 = enclose gcA2 li net=A

  gcB2 = contact licon cx=gB2.cx bottom=cb
  gpB2 = enclose gcB2 poly by=minx
  glB2 = enclose gcB2 li net=B

  gcC2 = contact licon cx=gC2.cx bottom=cb
  gpC2 = enclose gcC2 poly by=minx
  glC2 = enclose gcC2 li net=C

  gn = enclose [gcA1, gcB1, gcC1, gcN, gcA2, gcB2, gcC2] npc

  # Well
  well y=((max(nd1.top, nd2.top, nd3.top, nd4.top, nd5.top, nd6.top, nd7.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom, pd5.bottom, pd6.bottom, pd7.bottom) - 0.18) / 2)

  # Input ports
  am = contact mcon in=glA1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  bm = contact mcon in=glB1
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  cm = contact mcon in=glC1
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp

  # Output port
  port X out
end
