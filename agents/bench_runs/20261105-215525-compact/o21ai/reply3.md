```icl
pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.28, 0.54 - L)
  span = 0.53 + 3*L + 2*gap
  x0 = cell.cx - span/2
  x1 = x0 + 0.265
  x2 = x1 + L + gap
  x3 = x2 + L + gap
  nd = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(x1 - 0.265, x3 + L + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm
  g1 = cross [nd, pd] poly w=L left=x1
  g2 = cross [nd, pd] poly w=L left=x2
  g3 = cross [nd, pd] poly w=L left=x3
  c1 = array licon in=nd left_of=g1
  c1l = enclose c1 li net=n2
  c2 = array licon in=nd right_of=g1
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  c3 = array licon in=nd right_of=g2
  c3l = enclose c3 li net=n2
  c4 = array licon in=nd right_of=g3
  c4l = enclose c4 li net=Y
  c5 = array licon in=pd left_of=g1
  c5l = enclose c5 li net=Y
  c6 = array licon in=pd right_of=g2
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd right_of=g3
  c7l = enclose c7 li net=Y
  cb = max(nd.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)
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
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  route n2 layers=m1,m2
  route Y layers=m1,m2
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  ym = contact mcon in=c4l
  yp = enclose ym m1 by=0.06 net=Y
  ym2 = contact mcon in=c7l
  yp2 = enclose ym2 m1 by=0.06 net=Y
  port Y out on=yp
end
```