```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  # stick plan (gate order A2 A1 B2 B1; (net) = series node, no contact)
  #   p: VPWR [A2] n2 [A1] VPWR | VPWR [B2] n2 [B1] Y |
  #   n: VGND [A2] n3 [A1] Y | Y [B1] n1 [B2] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # centre-to-centre pitch for gate-contact pads
  span = 0.53 + 4*L + 3*gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B2
  g4 = rect poly w=L left=(g3.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)   # n island 1: VGND A2 n3 A1 Y
  nd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)   # n island 2: Y B1 n1 B2 VGND
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)   # p island 1: VPWR A2 n2 A1 VPWR
  pd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)   # p island 2: VPWR B2 n2 B1 Y
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  # n island 1 contacts
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n3
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=Y
  # n island 2 contacts
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=Y
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=n1
  c6 = array licon in=nd2 right_of=g4
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li
  # p island 1 contacts
  c7 = array licon in=pd1 left_of=g1
  c7l = enclose c7 li net=VPWR
  c7s = strap li from=c7l to=vpwr_li
  c8 = array licon in=pd1 right_of=g1
  c8l = enclose c8 li net=n2
  c9 = array licon in=pd1 right_of=g2
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li
  # p island 2 contacts
  c10 = array licon in=pd2 left_of=g3
  c10l = enclose c10 li net=VPWR
  c10s = strap li from=c10l to=vpwr_li
  c11 = array licon in=pd2 right_of=g3
  c11l = enclose c11 li net=n2
  c12 = array licon in=pd2 right_of=g4
  c12l = enclose c12 li net=Y
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B2
  gc4 = contact licon cx=(g4.cx - 0.13) bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B1
  gn = enclose [gc1, gc2, gc3, gc4] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl4
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon in=gl3
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  ym = contact mcon in=c12l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route n3 layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
end
```