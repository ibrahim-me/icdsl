pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  # stick plan (gate order S A0 S n1 A1; | = diffusion break between every gate)
  #   p: VPWR [S] n1 | Y [A0] n2 | n2 [S] VPWR | VPWR [n1] n4 | n4 [A1] Y
  #   n: n3 [S] VGND | Y [A0] n5 | VGND [S] n1 | VGND [n1] n5 | n3 [A1] Y
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 5*L + max(0.80, 0.54 - L) + max(0.80, 0.54 - L) + max(0.80, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S (M0/M3)
  g2 = rect poly w=L left=(g1.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A0
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S (M1/M6)
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g5 = rect poly w=L left=(g4.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  # n row: each gate is its own island (breaks between all gates)
  nd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  nd4 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  nd5 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  # p row: each gate is its own island
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  pd4 = rect diff xspan=(g4.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  pd5 = rect diff xspan=(g5.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2, nd3, nd4, nd5] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5] psdm
  # n row contacts: nd1 has n3 (left of g1), VGND (right of g1)
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=n3
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  # nd2 has Y (left of g2), n5 (right of g2)
  c3 = array licon in=nd2 left_of=g2
  c3l = enclose c3 li net=Y
  c4 = array licon in=nd2 right_of=g2
  c4l = enclose c4 li net=n5
  # nd3 has VGND (left of g3), n1 (right of g3)
  c5 = array licon in=nd3 left_of=g3
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=nd3 right_of=g3
  c6l = enclose c6 li net=n1
  # nd4 has VGND (left of g4), n5 (right of g4)
  c7 = array licon in=nd4 left_of=g4
  c7l = enclose c7 li net=VGND
  c7s = strap li from=c7l to=vgnd_li
  c8 = array licon in=nd4 right_of=g4
  c8l = enclose c8 li net=n5
  # nd5 has n3 (left of g5), Y (right of g5)
  c9 = array licon in=nd5 left_of=g5
  c9l = enclose c9 li net=n3
  c10 = array licon in=nd5 right_of=g5
  c10l = enclose c10 li net=Y
  # p row contacts: pd1 has VPWR (left of g1), n1 (right of g1)
  c11 = array licon in=pd1 left_of=g1
  c11l = enclose c11 li net=VPWR
  c11s = strap li from=c11l to=vpwr_li
  c12 = array licon in=pd1 right_of=g1
  c12l = enclose c12 li net=n1
  # pd2 has Y (left of g2), n2 (right of g2)
  c13 = array licon in=pd2 left_of=g2
  c13l = enclose c13 li net=Y
  c14 = array licon in=pd2 right_of=g2
  c14l = enclose c14 li net=n2
  # pd3 has n2 (left of g3), VPWR (right of g3)
  c15 = array licon in=pd3 left_of=g3
  c15l = enclose c15 li net=n2
  c16 = array licon in=pd3 right_of=g3
  c16l = enclose c16 li net=VPWR
  c16s = strap li from=c16l to=vpwr_li
  # pd4 has VPWR (left of g4), n4 (right of g4)
  c17 = array licon in=pd4 left_of=g4
  c17l = enclose c17 li net=VPWR
  c17s = strap li from=c17l to=vpwr_li
  c18 = array licon in=pd4 right_of=g4
  c18l = enclose c18 li net=n4
  # pd5 has n4 (left of g5), Y (right of g5)
  c19 = array licon in=pd5 left_of=g5
  c19l = enclose c19 li net=n4
  c20 = array licon in=pd5 right_of=g5
  c20l = enclose c20 li net=Y
  # gate contacts
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25, c9l.top + 0.25, c10l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=S
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A0
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=S
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=n1
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A1
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc
  # well
  well y=((max(nd1.top, nd2.top, nd3.top, nd4.top, nd5.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom, pd4.bottom, pd5.bottom) - 0.18) / 2)
  # ports
  sm = contact mcon in=gl1
  sp = enclose sm m1 by=0.06 net=S
  port S in on=sp
  a0m = contact mcon in=gl2
  a0p = enclose a0m m1 by=0.06 net=A0
  port A0 in on=a0p
  a1m = contact mcon in=gl5
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  ym = contact mcon in=c20l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  # routes for internal nets
  route S layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
end
