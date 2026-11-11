pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=7 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # stick plan (gate order A1 A2 B1; (net) = series node, no contact; | = island break)
  #   p: VPWR [A1] n1 [A2] Y [B1] VPWR      (single p row)
  #   n: VGND [A1] n2 [A2] VGND |   n2 [B1] Y   (two n islands, n2 routed between)
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  pim = enclose [pd1] psdm
  # p row: VPWR | A1 | n1 | A2 | Y | B1 | VPWR   (n1, Y series, no contact)
  c1 = array licon in=pd1 left_of=g1
  c1l = enclose c1 li net=VPWR
  c1s = strap li from=c1l to=vpwr_li
  c4 = array licon in=pd1 right_of=g3
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  cp = array licon in=pd1 between=[g2, g3]
  cpl = enclose cp li net=Y
  # n island 1: VGND | A1 | n2 | A2 | VGND   (gates g1, g2)
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  # n island 2: n2 | B1 | Y   (gate g3), 0.80 break from island 1
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose [nd1, nd2] nsdm
  c5 = array licon in=nd1 left_of=g1
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  c6 = array licon in=nd1 right_of=g2
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li
  c7 = array licon in=nd2 left_of=g3
  c7l = enclose c7 li net=n2
  c8 = array licon in=nd2 right_of=g3
  c8l = enclose c8 li net=Y
  cb = max(nd1.top + 0.19, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25)
  # gate contacts: stagger vertically so poly pads keep 0.21 spacing; bottom from n-row only
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A1
  gc2 = contact licon cx=g2.cx bottom=(cb - 0.17)
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A2
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + pd1.bottom - 0.18) / 2)
  a1m = contact mcon in=gl1
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl2
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  ym = contact mcon in=cpl
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route Y layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
end
