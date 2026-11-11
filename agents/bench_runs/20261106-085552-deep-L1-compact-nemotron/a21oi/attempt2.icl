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
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  nd1 = rect diff xspan=(x0, x0 + span) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(x0, x0 + span) yspan=(py1 - WP, py1)
  nim = enclose nd1 nsdm
  pim = enclose pd1 psdm
  g1 = cross [nd1, pd1] poly w=L left=(x0 + 0.265)
  g2 = cross [nd1, pd1] poly w=L left=(g1.right + max(0.28, 0.54 - L))
  g3 = cross [nd1, pd1] poly w=L left=(g2.right + max(0.28, 0.54 - L))

  # n-row: VGND | A2 | n1(nc) | A1 | Y | B1 | VGND
  sn  = array licon in=nd1 left_of=g1
  sy  = array licon in=nd1 right_of=g2
  sv  = array licon in=nd1 right_of=g3
  snl = enclose sn li net=VGND
  syl = enclose sy li net=Y
  svl = enclose sv li net=VGND
  gnd1 = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li

  # p-row: n2 | A2 | VPWR | A1 | n2 | B1 | Y
  pn2l = array licon in=pd1 left_of=g1
  pvp  = array licon in=pd1 right_of=g1
  pn2r = array licon in=pd1 right_of=g2
  py   = array licon in=pd1 right_of=g3
  pn2ll = enclose pn2l li net=n2
  pvpl = enclose pvp li net=VPWR
  pn2rl = enclose pn2r li net=n2
  pyl  = enclose py li net=Y
  p1 = strap li from=pvpl to=vpwr_li
  route n2 layers=m1,m2
  route Y layers=m1,m2

  cb = max(nd1.top + 0.19, snl.top + 0.25, syl.top + 0.25, svl.top + 0.25)
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
  port Y out
end