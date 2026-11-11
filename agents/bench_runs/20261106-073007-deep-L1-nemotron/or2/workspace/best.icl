pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=6 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # diffusion width: 2 end contacts (0.265 each) + 3 gates (L each) + 2 gaps between gates (0.28 each)
  dw  = 2*0.265 + 3*L + 2*0.28
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order A, B, n2 for both rows
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gn2 = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))

  # n-row contacts: VGND | A | n2 | B | Y(n1) | X
  sn  = array licon in=nd left_of=ga            # VGND column
  dn1 = array licon in=nd right_of=ga           # n2 column (M3 drain)
  dn2 = array licon in=nd right_of=gb           # n2 column (M2 source / M1 drain area)
  dn3 = array licon in=nd right_of=gn2          # X column (M1 drain)
  # p-row contacts: VPWR | A | n1 | B | n1 | X
  sp  = array licon in=pd left_of=ga            # VPWR column
  dp1 = array licon in=pd right_of=ga           # n1 column (M0 drain)
  dp2 = array licon in=pd right_of=gb           # n1 column (M4 drain)
  dp3 = array licon in=pd right_of=gn2          # X column (M5 source)

  snl = enclose sn li
  dn1l = enclose dn1 li net=n2
  dn2l = enclose dn2 li net=n2
  dn3l = enclose dn3 li net=X
  spl = enclose sp li
  dp1l = enclose dp1 li net=n1
  dp2l = enclose dp2 li net=n1
  dp3l = enclose dp3 li net=X

  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=spl to=vpwr_li

  # gate contacts: bottom above n-row + li strips, contacts on their own gates
  cb  = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gcn2 = contact licon cx=(gn2.cx - 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn2 = enclose gcn2 poly by=minx
  gn_all = enclose [gca, gcb, gcn2] npc
  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  nn2 = enclose gcn2 li net=n2

  # output: join n-side X drain (dn3l) and p-side X source (dp3l) with route
  route X layers=m1

  # well split
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

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
