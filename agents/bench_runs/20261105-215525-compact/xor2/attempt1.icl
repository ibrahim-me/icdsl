pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap_cc = max(0.28, 0.54 - L)      # contact column between gates
  gap_nc = max(0.21, 0.54 - L)      # series node, no contact between gates
  span = 0.53 + 5*L + 3*gap_cc + gap_nc
  x0 = cell.cx - span/2

  # gate order: A B n1 B A  (each gate crosses both rows)
  g1 = cross [nd, pd] poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  g2 = cross [nd, pd] poly w=L left=(g1.right + gap_cc) yspan=(ny0 - 0.13, py1 + 0.13)
  g3 = cross [nd, pd] poly w=L left=(g2.right + gap_cc) yspan=(ny0 - 0.13, py1 + 0.13)
  g4 = cross [nd, pd] poly w=L left=(g3.right + gap_nc) yspan=(ny0 - 0.13, py1 + 0.13)
  g5 = cross [nd, pd] poly w=L left=(g4.right + gap_cc) yspan=(ny0 - 0.13, py1 + 0.13)

  nd = rect diff xspan=(g1.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g1.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # n-row: VGND A n1 B VGND n1 X B n4 A VGND
  sn  = array licon in=nd left_of=g1
  c1  = array licon in=nd right_of=g1
  c2  = array licon in=nd right_of=g2
  c3  = array licon in=nd right_of=g3
  c4  = array licon in=nd right_of=g4
  c5  = array licon in=nd right_of=g5
  snl = enclose sn li net=VGND
  c1l = enclose c1 li net=n1
  c2l = enclose c2 li net=VGND
  c3l = enclose c3 li net=X
  c4l = enclose c4 li net=n4
  c5l = enclose c5 li net=VGND
  snl_s = strap li from=snl to=vgnd_li
  c2l_s = strap li from=c2l to=vgnd_li
  c5l_s = strap li from=c5l to=vgnd_li

  # p-row: VPWR A n2 B VPWR n1 X B n1 A VPWR
  sp  = array licon in=pd left_of=g1
  d1  = array licon in=pd right_of=g1
  d2  = array licon in=pd right_of=g2
  d3  = array licon in=pd right_of=g3
  d4  = array licon in=pd right_of=g4
  d5  = array licon in=pd right_of=g5
  spl = enclose sp li net=VPWR
  d1l = enclose d1 li net=n2
  d2l = enclose d2 li net=VPWR
  d3l = enclose d3 li net=n1
  d4l = enclose d4 li net=n1
  d5l = enclose d5 li net=VPWR
  spl_s = strap li from=spl to=vpwr_li
  d2l_s = strap li from=d2l to=vpwr_li
  d5l_s = strap li from=d5l to=vpwr_li

  # gate contacts in gap between rows (n-row items only in cb)
  cb = max(nd.top + 0.19, snl.top + 0.25, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gc2 = contact licon cx=g2.cx bottom=cb
  gc3 = contact licon cx=g3.cx bottom=cb
  gc4 = contact licon cx=g4.cx bottom=cb
  gc5 = contact licon cx=g5.cx bottom=cb
  gp1 = enclose gc1 poly by=minx net=A
  gp2 = enclose gc2 poly by=minx net=B
  gp3 = enclose gc3 poly by=minx net=n1
  gp4 = enclose gc4 poly by=minx net=B
  gp5 = enclose gc5 poly by=minx net=A
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output X: n-side c3l and p-side d4l do not align -> route on m1/m2
  xm = contact mcon in=c3l
  xp = enclose xm m1 by=0.06 net=X
  route X layers=m1,m2

  # internal nets n1, n2, n3, n4: label the li straps, route on m1/m2
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2

  # input ports A and B on met1 over their gate-contact li
  am = contact mcon in=gp1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gp2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port X out on=xp
end
