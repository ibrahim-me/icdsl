pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  # Gate order: A B A B n1 (same for both rows)
  gap1 = max(0.28, 0.54 - L)
  gap2 = max(0.28, 0.54 - L)
  gap3 = max(0.21, 0.54 - L)
  gap4 = max(0.80, 0.54 - L)
  span = 0.53 + 5*L + gap1 + gap2 + gap3 + gap4
  x0 = cell.cx - span/2

  # Absolute gate positions
  g1_left = x0 + 0.265
  g2_left = g1_left + L + gap1
  g3_left = g2_left + L + gap2
  g4_left = g3_left + L + gap3
  g5_left = g4_left + L + gap4

  # N-row diffusion islands: nd1 covers gates g1-g4 (A B A B), nd2 covers gate g5 (n1)
  nd1 = rect diff xspan=(g1_left - 0.265, g4_left + L + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g5_left - 0.265, g5_left + L + 0.265) yspan=(ny0, ny0 + WN)

  # P-row diffusion islands: pd1 covers gates g1-g4 (A B A B), pd2 covers gate g5 (n1)
  pd1 = rect diff xspan=(g1_left - 0.265, g4_left + L + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g5_left - 0.265, g5_left + L + 0.265) yspan=(py1 - WP, py1)

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  g1 = cross [nd1, pd1] poly w=L left=g1_left ext=0.13   # gate A
  g2 = cross [nd1, pd1] poly w=L left=g2_left ext=0.13   # gate B
  g3 = cross [nd1, pd1] poly w=L left=g3_left ext=0.13   # gate A
  g4 = cross [nd1, pd1] poly w=L left=g4_left ext=0.13   # gate B
  g5 = cross [nd2, pd2] poly w=L left=g5_left ext=0.13   # gate n1

  # N-row contacts:
  # Island 1 (g1-g4 = A B A B): VGND | A | n1 | B | VGND | A | n4 | B | X
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n1
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd1 right_of=g3
  c4l = enclose c4 li net=n4
  c5 = array licon in=nd1 right_of=g4
  c5l = enclose c5 li net=X

  # Island 2 (g5 = n1): VGND | n1 | X
  c6 = array licon in=nd2 left_of=g5
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li
  c7 = array licon in=nd2 right_of=g5
  c7l = enclose c7 li net=X
  c7s = strap li from=c7l to=vgnd_li

  # P-row contacts:
  # Island 1 (g1-g4 = A B A B): VPWR | B | n2 | A | VPWR | A | n3 | B | n1
  c8 = array licon in=pd1 left_of=g1
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li
  c9 = array licon in=pd1 right_of=g1
  c9l = enclose c9 li net=n2
  c10 = array licon in=pd1 right_of=g2
  c10l = enclose c10 li net=VPWR
  c10s = strap li from=c10l to=vpwr_li
  c11 = array licon in=pd1 right_of=g3
  c11l = enclose c11 li net=VPWR
  c11s = strap li from=c11l to=vpwr_li
  c12 = array licon in=pd1 right_of=g4
  c12l = enclose c12 li net=n1

  # Island 2 (g5 = n1): n1 | n1 | n2
  c13 = array licon in=pd2 left_of=g5
  c13l = enclose c13 li net=n1
  c14 = array licon in=pd2 right_of=g5
  c14l = enclose c14 li net=n2

  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25)

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

  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc

  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  xm = contact mcon in=c5l
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp

  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
end
