pdk sky130A
param L=0.15 H=2.72 WN=0.49 WP=0.75

stdcell a21oi width=5 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=1.91 h=WN cx=cell.cx above=ptap
  pd  = rect diff w=1.91 h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  g1  = cross [nd, pd] poly w=L left=(nd.left+0.265)
  g2  = cross [nd, pd] poly w=L left=(g1.right+0.35)
  g3  = cross [nd, pd] poly w=L left=(g2.right+0.58)
  # nmos contacts: c0 VGND, c1 n1, c2 Y, c3 VGND
  n0 = array licon in=nd left_of=g1
  n1 = array licon in=nd between=[g1,g2]
  n2 = array licon in=nd between=[g2,g3]
  n3 = array licon in=nd right_of=g3
  p0 = array licon in=pd left_of=g1
  p1 = array licon in=pd between=[g1,g2]
  p2 = array licon in=pd between=[g2,g3]
  p3 = array licon in=pd right_of=g3
  n0l = enclose n0 li
  n1l = enclose n1 li
  n2l = enclose n2 li net=Y
  n3l = enclose n3 li
  p0l = enclose p0 li
  p1l = enclose p1 li
  p2l = enclose p2 li
  p3l = enclose p3 li net=Y
  s0 = strap li from=n0l to=vgnd_li
  s3 = strap li from=n3l to=vgnd_li
  s1 = strap li from=p1l to=vpwr_li

  # gate contacts
  gc1 = contact licon cx=g1.cx bottom=(nd.top + 0.19)
  gc2 = contact licon cx=g2.cx bottom=(nd.top + 0.19)
  gc3 = contact licon cx=g3.cx bottom=(nd.top + 0.19)
  gp1 = enclose gc1 poly by=min
  gp2 = enclose gc2 poly by=min
  gp3 = enclose gc3 poly by=min
  gn1 = enclose [gc1, gc2, gc3] npc
  gl1 = enclose gc1 li net=A2
  gl2 = enclose gc2 li net=A1
  gl3 = enclose gc3 li net=B1
  gm1 = contact mcon in=gl1
  gm2 = contact mcon in=gl2
  gm3 = contact mcon in=gl3
  gq1 = enclose gm1 m1 by=(0.03, 0.1) net=A2
  gq2 = enclose gm2 m1 by=(0.03, 0.1) net=A1
  gq3 = enclose gm3 m1 by=(0.03, 0.1) net=B1
  port A2 in on=gq1
  port A1 in on=gq2
  port B1 in on=gq3
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # Y
  ym1 = contact mcon in=n2l
  ym2 = contact mcon in=p3l cy=(p3l.top - 0.3)
  yp1 = enclose ym1 m1 by=(0.03, 0.06) net=Y
  yv = rect m1 w=0.14 cx=ym1.cx bottom=ym1.cy top=1.65 net=Y
  yh = rect m1 top=1.65 left=(yv.left) right=(ym2.cx + 0.115) bottom=1.51 net=Y
  yv2 = rect m1 w=0.23 cx=ym2.cx bottom=1.51 top=(ym2.cy + 0.145) net=Y
  # n2
  nm0 = contact mcon in=p0l cy=(p0l.top - 0.3)
  nm1 = contact mcon in=p2l cy=(p2l.top - 0.3)
  nbar = rect m1 left=(nm0.cx - 0.115) right=(nm1.cx + 0.115) cy=nm0.cy h=0.29 net=n2
  port Y out on=yv2
end
