```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=8 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # gate order A2 A1 B2 B1 (same for both rows); n row split into two islands
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  span = 0.53 + 4*L + 3*max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B2
  g4 = rect poly w=L left=(g3.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1

  # n row: VGND | A2 | n3 | A1 | VGND  | 0.80 break  | n3 | B2 | Y | B1 | n3
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose [nd1, nd2] nsdm

  # p row: n1 | A2 | Y | B2 | n2 | B1 | VPWR | A1 | n1
  pd1 = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  pim = enclose [pd1] psdm

  # n island 1: VGND | A2 | n3 | A1 | VGND
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g2
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li

  # n island 2: n3 | B2 | Y | B1 | n3
  c3 = array licon in=nd2 left_of=g3
  c3l = enclose c3 li net=n3
  c4 = array licon in=nd2 right_of=g3
  c4l = enclose c4 li net=Y
  c5 = array licon in=nd2 right_of=g4
  c5l = enclose c5 li net=n3

  # p row: n1 | A2 | Y | B2 | n2 | B1 | VPWR | A1 | n1
  p1 = array licon in=pd1 left_of=g1
  p1l = enclose p1 li net=n1
  p2 = array licon in=pd1 right_of=g1
  p2l = enclose p2 li net=Y
  p3 = array licon in=pd1 right_of=g2
  p3l = enclose p3 li net=n2
  p4 = array licon in=pd1 right_of=g3
  p4l = enclose p4 li net=VPWR
  p4s = strap li from=p4l to=vpwr_li
  p5 = array licon in=pd1 right_of=g4
  p5l = enclose p5 li net=n1

  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B2
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B1
  gn = enclose [gc1, gc2, gc3, gc4] npc

  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)

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
  port Y out
  route Y layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
end
```