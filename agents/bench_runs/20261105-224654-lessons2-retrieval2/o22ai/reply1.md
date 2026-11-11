```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=9 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # stick plan (gate order A2 A1 B1 B2; (net) = series node, no contact)
  #   p: n1 [A2] VPWR [A1] n1 | n2 [B1] VPWR [B2] n2 | Y
  #   n: VGND [A2] n3 [A1] Y [B1] n3 [B2] VGND
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.28, 0.54 - L)
  x0 = cell.cx - (0.53 + 4*L + 3*gap + 0.80)/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # A2
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # A1
  g3 = rect poly w=L left=(g2.right + gap + 0.80) yspan=(ny0 - 0.13, py1 + 0.13)   # B1
  g4 = rect poly w=L left=(g3.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # B2
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g2
  c2l = enclose c2 li net=Y
  c3 = array licon in=nd2 left_of=g3
  c3l = enclose c3 li net=Y
  c4 = array licon in=nd2 right_of=g4
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=pd1 left_of=g1
  c5l = enclose c5 li net=n1
  c6 = array licon in=pd1 right_of=g1
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd1 right_of=g2
  c7l = enclose c7 li net=n1
  c8 = array licon in=pd2 left_of=g3
  c8l = enclose c8 li net=n2
  c9 = array licon in=pd2 right_of=g3
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li
  c10 = array licon in=pd2 right_of=g4
  c10l = enclose c10 li net=n2
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B2
  gn = enclose [gc1, gc2, gc3, gc4] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon in=gl4
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  ym = contact mcon in=c2l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
end
```