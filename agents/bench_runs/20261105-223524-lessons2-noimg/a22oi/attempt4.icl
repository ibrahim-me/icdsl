pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  gg  = max(0.28, 0.54 - L)

  nd1 = rect diff w=(2*L + gg + 0.53) h=WN left=(cell.left + 0.46) above=ptap
  nd2 = rect diff w=(2*L + gg + 0.53) h=WN left=(nd1.right + 0.80) above=ptap
  pd1 = rect diff w=(2*L + gg + 0.53) h=WP left=(cell.left + 0.46) below=ntap
  pd2 = rect diff w=(2*L + gg + 0.53) h=WP left=(nd1.right + 0.80) below=ntap

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  g1 = cross [nd1, pd1] poly w=L left=(nd1.left + 0.265)   # B1
  g2 = cross [nd1, pd1] poly w=L left=(g1.right + gg)      # B2
  g3 = cross [nd2, pd2] poly w=L left=(nd2.left + 0.265)   # A1
  g4 = cross [nd2, pd2] poly w=L left=(g3.right + gg)      # A2

  # n row: island1 Y|B1|n1|B2|GND ; island2 Y|A1|n3|A2|GND
  cy1 = array licon in=nd1 left_of=g1
  cn1 = array licon in=nd1 between=[g1, g2]
  cg1 = array licon in=nd1 right_of=g2
  cy2 = array licon in=nd2 left_of=g3
  cn3 = array licon in=nd2 between=[g3, g4]
  cg2 = array licon in=nd2 right_of=g4
  cyl1 = enclose cy1 li net=Y
  cyl2 = enclose cy2 li net=Y
  cnl  = enclose cn1 li net=n1
  c3l  = enclose cn3 li net=n3
  cgl1 = enclose cg1 li
  cgl2 = enclose cg2 li
  sg1  = strap li from=cgl1 to=vgnd_li
  sg2  = strap li from=cgl2 to=vgnd_li

  # p row: islandB n2|B1|Y|B2|n2 ; islandA VPWR|A1|n2|A2|VPWR
  cn2b = array licon in=pd1 left_of=g1
  cyb  = array licon in=pd1 between=[g1, g2]
  cn2r = array licon in=pd1 right_of=g2
  cpw  = array licon in=pd2 left_of=g3
  cn2m = array licon in=pd2 between=[g3, g4]
  cpw2 = array licon in=pd2 right_of=g4
  cn2bl = enclose cn2b li net=n2
  cn2rl = enclose cn2r li net=n2
  cbl   = enclose cyb li net=Y
  cn2ml = enclose cn2m li net=n2
  cpwl  = enclose cpw li
  cpw2l = enclose cpw2 li
  sp1   = strap li from=cpwl to=vpwr_li
  sp2   = strap li from=cpw2l to=vpwr_li

  cb = max(nd1.top + 0.19, cyl1.top + 0.25, cyl2.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gc2 = contact licon cx=g2.cx bottom=cb
  gc3 = contact licon cx=g3.cx bottom=cb
  gc4 = contact licon cx=g4.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gp3 = enclose gc3 poly by=minx
  gp4 = enclose gc4 poly by=minx
  gn  = enclose [gc1, gc2, gc3, gc4] npc
  a1  = enclose gc3 li net=A1
  a2  = enclose gc4 li net=A2
  b1  = enclose gc1 li net=B1
  b2  = enclose gc2 li net=B2

  well y=((nd1.top + 0.34 + pd2.bottom - 0.18) / 2)

  route Y layers=m1,m2
  route n2 layers=m1,m2

  am1 = contact mcon in=a1
  ap1 = enclose am1 m1 by=0.06 net=A1
  am2 = contact mcon in=a2
  ap2 = enclose am2 m1 by=0.06 net=A2
  bm1 = contact mcon in=b1
  bp1 = enclose bm1 m1 by=0.06 net=B1
  bm2 = contact mcon in=b2
  bp2 = enclose bm2 m1 by=0.06 net=B2
  ym  = contact mcon in=cyl1
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=ap1
  port A2 in  on=ap2
  port B1 in  on=bp1
  port B2 in  on=bp2
  port Y  out on=yp
end
