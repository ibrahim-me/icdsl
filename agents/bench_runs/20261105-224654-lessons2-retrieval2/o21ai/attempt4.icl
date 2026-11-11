pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=7 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # stick plan (gate order A2 A1 B1; (net) = series node, no contact)
  #   p: Y [A2] n1 [A1] VPWR [B1] Y
  #   n: VGND [A1] n2 [B1] Y |   VGND [A2] n2
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  pim = enclose [pd1] psdm
  # p row: Y | A2 | n1 | A1 | VPWR | B1 | Y   (n1 series, no contact)
  c1 = array licon in=pd1 left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=pd1 right_of=g2
  c2l = enclose c2 li net=VPWR
  c2s = strap li from=c2l to=vpwr_li
  c3 = array licon in=pd1 right_of=g3
  c3l = enclose c3 li net=Y
  # n island 1: VGND | A1 | n2 | B1 | Y   (gates g2, g3)
  nd1 = rect diff xspan=(g2.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  # n island 2: VGND | A2 | n2   (gate g1), 0.80 break from island 1
  nd2 = rect diff xspan=(g1.left - 0.265 - 0.80, g1.left - 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose [nd1, nd2] nsdm
  c4 = array licon in=nd1 left_of=g2
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=nd1 right_of=g3
  c5l = enclose c5 li net=Y
  c6 = array licon in=nd2 left_of=g1
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li
  cb = max(nd1.top + 0.19, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25)
  # gate contacts: stagger vertically so poly pads keep 0.21 spacing and clear the output strap
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=(g2.cx + 0.13) bottom=(cb - 0.17)
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + pd1.bottom - 0.18) / 2)
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  port Y out
  route Y layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
end
