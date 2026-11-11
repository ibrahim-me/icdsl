```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=5 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  g1 = rect poly w=L left=(cell.cx - L - 0.28) yspan=(ny0 - 0.13, py1 + 0.13)   # A2
  g2 = rect poly w=L left=(cell.cx) yspan=(ny0 - 0.13, py1 + 0.13)              # A1
  g3 = rect poly w=L left=(cell.cx + 0.28) yspan=(ny0 - 0.13, py1 + 0.13)       # B1
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g2
  c2l = enclose c2 li net=Y
  c3 = array licon in=nd1 right_of=g3
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=pd1 left_of=g1
  c4l = enclose c4 li net=n2
  c5 = array licon in=pd1 right_of=g1
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd1 right_of=g2
  c6l = enclose c6 li net=n2
  c7 = array licon in=pd1 right_of=g3
  c7l = enclose c7 li net=Y
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  ym  = contact mcon in=c2l
  yp  = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  n2m = contact mcon in=c4l
  n2p = enclose n2m m1 by=0.06 net=n2
  route n2 layers=m1,m2
end
```