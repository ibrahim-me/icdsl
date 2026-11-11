```icl
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

  gg  = max(0.28, 0.54 - L)          # gate-to-gate gap (pad pitch 0.54)

  nd1 = rect diff w=0.53+L+0.21+L+0.53 h=WN cx=(cell.left + 0.46 + 0.53 + L/2 + 0.21 + L/2 + 0.53)/2 above=ptap   # n island B1,B2: Y|B1|n1|B2|GND
  nd2 = rect diff w=0.53+L+0.21+L+0.53 h=WN cx=(nd1.cx + 0.53 + L + 0.80 + 0.53 + L + 0.53)/2 above=ptap   # n island A1,A2: Y|A1|n3|A2|GND
  pd1 = rect diff w=0.53+L+0.21+L+0.53 h=WP cx=nd1.cx below=ntap   # p island B1,B2: n2|B1|Y|B2|n2
  pd2 = rect diff w=0.53+L+0.21+L+0.53 h=WP cx=nd2.cx below=ntap   # p island A1,A2: VPWR|A1|n2|A2|VPWR

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  g1 = cross [nd1, pd1] poly w=L left=(nd1.left + 0.265)   # B1
  g2 = cross [nd1, pd1] poly w=L left=(g1.right + gg)      # B2
  g3 = cross [nd2, pd2] poly w=L left=(nd2.left + 0.265)   # A1
  g4 = cross [nd2, pd2] poly w=L left=(g3.right + gg)      # A2

  # n row contacts: island1 Y|B1|n1|B2|GND ; island2 Y|A1|n3|A2|GND
  cy1 = array licon in=nd1 left_of=g1          # Y col (island1)
  cg1 = array licon in=nd1 right_of=g2         # GND col (island1)
  cy2 = array licon in=nd2 left_of=g3          # Y col (island2)
  cg2 = array licon in=nd2 right_of=g4         # GND col (island2)
  cyl = enclose [cy1, cy2] li net=Y
  cgl = enclose [cg1, cg2] li
  sg  = strap li from=cgl to=vgnd_li

  # p row contacts: islandB n2|B1|Y|B2|n2 ; islandA VPWR|A1|n2|A2|VPWR
  cn2b = array licon in=pd1 left_of=g1         # n2 col (islandB left)
  cyb  = array licon in=pd1 between=[g1, g2]   # Y col (islandB middle)
  cn2r = array licon in=pd1 right_of=g2        # n2 col (islandB right)
  cpw  = array licon in=pd2 left_of=g3         # VPWR col (islandA left)
  cn2m = array licon in=pd2 between=[g3, g4]   # n2 col (islandA middle)
  cpw2 = array licon in=pd2 right_of=g4        # VPWR col (islandA right)
  cn2l = enclose [cn2b, cn2r, cn2m] li net=n2
  cbl  = enclose cyb li net=Y
  cpwl = enclose [cpw, cpw2] li
  sp1  = strap li from=cpwl to=vpwr_li

  cb = max(nd1.top + 0.19, cyl.top + 0.25)
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
  ym  = contact mcon in=cbl
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=ap1
  port A2 in  on=ap2
  port B1 in  on=bp1
  port B2 in  on=bp2
  port Y  out on=yp
end
```