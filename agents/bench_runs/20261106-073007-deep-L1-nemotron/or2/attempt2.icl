pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=7 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # Island 1 (M3, M2 / M0, M4): end contacts + gate margin + ga + gap(n2 contact) + gb + gap(VGND/n1 contact) + end contact
  dw1 = 2*0.265 + 2*0.25 + 2*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  # Island 2 (M1 / M5): end contact + gate margin + gn2 + gap(X contact) + end contact
  dw2 = 2*0.265 + 2*0.25 + L + max(0.28, 0.54 - L)
  # Break between islands
  break = 0.80
  dw  = dw1 + break + dw2

  cx  = cell.cx
  nd_left  = cx - dw/2
  nd_right = cx + dw/2

  # n-row islands
  nd1 = rect diff w=dw1 h=WN left=nd_left above=ptap
  nd2 = rect diff w=dw2 h=WN right=nd_right above=ptap
  # p-row islands
  pd1 = rect diff w=dw1 h=WP left=nd_left below=ntap
  pd2 = rect diff w=dw2 h=WP right=nd_right below=ntap

  nim1 = enclose nd1 nsdm
  nim2 = enclose nd2 nsdm
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  # gate order A, B on island 1; n2 on island 2
  ga  = cross [nd1, pd1] poly w=L left=(nd_left + 0.265 + 0.25)
  gb  = cross [nd1, pd1] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gn2 = cross [nd2, pd2] poly w=L right=(nd_right - 0.265 - 0.25)

  # n-row contacts: VGND | n2 | VGND | X | VGND
  sn  = array licon in=nd1 left_of=ga            # VGND (M3 source)
  dn1 = array licon in=nd1 right_of=ga           # n2 (M3 drain = M2 source)
  dn2 = array licon in=nd1 right_of=gb           # VGND (M2 drain)
  dn3 = array licon in=nd2 left_of=gn2           # X (M1 source)
  dn4 = array licon in=nd2 right_of=gn2          # VGND (M1 drain)

  # p-row contacts: VPWR | n1 | n2 | X | VPWR
  sp  = array licon in=pd1 left_of=ga            # VPWR (M0 source)
  dp1 = array licon in=pd1 right_of=ga           # n1 (M0 drain = M4 source)
  dp2 = array licon in=pd1 right_of=gb           # n2 (M4 drain)
  dp3 = array licon in=pd2 left_of=gn2           # X (M5 source)
  dp4 = array licon in=pd2 right_of=gn2          # VPWR (M5 drain)

  snl = enclose sn li
  dn1l = enclose dn1 li net=n2
  dn2l = enclose dn2 li net=VGND
  dn3l = enclose dn3 li net=X
  dn4l = enclose dn4 li net=VGND
  spl = enclose sp li
  dp1l = enclose dp1 li net=n1
  dp2l = enclose dp2 li net=n2
  dp3l = enclose dp3 li net=X
  dp4l = enclose dp4 li net=VPWR

  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dn2l to=vgnd_li
  gnd3 = strap li from=dn4l to=vgnd_li
  pwr = strap li from=spl to=vpwr_li
  pwr2 = strap li from=dp4l to=vpwr_li

  # gate contacts: shift apart to keep poly.2 clearance between neighbouring gates
  cb  = max(nd1.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25, dn4l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcn2 = contact licon cx=(gn2.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn2 = enclose gcn2 poly by=minx
  gn_all = enclose [gca, gcb, gcn2] npc
  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  nn2 = enclose gcn2 li net=n2

  # join internal nets across rows and to gate contacts
  route n1 layers=m1
  route n2 layers=m1
  route X layers=m1

  # well split
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  # port contacts on met1
  am = contact mcon in=aa
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=bb
  bp = enclose bm m1 by=0.06 net=B
  xm = contact mcon in=dn3l
  xp = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
