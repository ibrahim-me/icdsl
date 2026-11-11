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

  # stick plan (gate order S A0 n1 A1 S; | = diffusion break)
  #   p: n1 [S] VPWR [A0] n2 | Y [A1] n4 [n1] VPWR |
  #   n: VGND [S] n3 | VGND [n1] n5 [A0] Y [A1] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 5*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L) + max(0.80, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A0
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate S
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g4.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g4.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # n row: VGND | S | n3 | break | VGND | n1 | n5 | A0 | Y | A1 | VGND
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n3
  c3 = array licon in=nd2 left_of=g4
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd2 right_of=g4
  c4l = enclose c4 li net=Y
  c5 = array licon in=nd2 right_of=g5
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  # p row: n1 | S | VPWR | A0 | n2 | break | Y | A1 | n4 | n1 | VPWR
  c6 = array licon in=pd1 left_of=g1
  c6l = enclose c6 li net=n1
  c7 = array licon in=pd1 right_of=g1
  c7l = enclose c7 li net=VPWR
  c7s = strap li from=c7l to=vpwr_li
  c8 = array licon in=pd1 right_of=g2
  c8l = enclose c8 li net=n2
  c9 = array licon in=pd2 left_of=g4
  c9l = enclose c9 li net=Y
  c10 = array licon in=pd2 right_of=g4
  c10l = enclose c10 li net=n4
  c11 = array licon in=pd2 right_of=g5
  c11l = enclose c11 li net=VPWR
  c11s = strap li from=c11l to=vpwr_li
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=S
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A0
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n1
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=A1
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=S
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  sm = contact mcon in=gl1
  sp = enclose sm m1 by=0.06 net=S
  port S in on=sp
  a0m = contact mcon in=gl2
  a0p = enclose a0m m1 by=0.06 net=A0
  port A0 in on=a0p
  a1m = contact mcon in=gl4
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  ym = contact mcon in=c4l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
  route n5 layers=m1,m2 prefer=m2
end
