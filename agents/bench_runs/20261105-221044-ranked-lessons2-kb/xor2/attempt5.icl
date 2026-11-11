pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
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

  gpitch = 0.54
  endc   = 0.265

  # ---------- n-diffusion row ----------
  nd  = rect diff w=(5*L + 6*endc) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm

  ga  = cross [nd] poly w=L left=(nd.left + endc)
  gb1 = cross [nd] poly w=L left=(ga.right + gpitch)
  gn1 = cross [nd] poly w=L left=(gb1.right + gpitch)
  gb2 = cross [nd] poly w=L left=(gn1.right + gpitch)
  ga2 = cross [nd] poly w=L left=(gb2.right + gpitch)

  sn  = array licon in=nd left_of=ga
  dn1 = array licon in=nd between=[ga, gb1] net=n1
  dvg = array licon in=nd between=[gb1, gn1] net=VGND
  dx  = array licon in=nd between=[gn1, gb2] net=X
  dn4 = array licon in=nd between=[gb2, ga2] net=n4
  dvg2= array licon in=nd right_of=ga2 net=VGND

  snl = enclose sn li
  n1l = enclose dn1 li net=n1
  vgl = enclose dvg li net=VGND
  xl  = enclose dx li net=X
  n4l = enclose dn4 li net=n4
  vgl2= enclose dvg2 li net=VGND

  gnd0 = strap li from=snl to=vgnd_li
  gnd1 = strap li from=vgl to=vgnd_li
  gnd2 = strap li from=vgl2 to=vgnd_li

  # ---------- p-diffusion row ----------
  pd  = rect diff w=(5*L + 6*endc) h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm

  gpb = cross [pd] poly w=L left=(pd.left + endc)
  gpa = cross [pd] poly w=L left=(gpb.right + gpitch)
  gpn = cross [pd] poly w=L left=(gpa.right + gpitch)
  gpb2= cross [pd] poly w=L left=(gpn.right + gpitch)
  gpa2= cross [pd] poly w=L left=(gpb2.right + gpitch)

  sp  = array licon in=pd left_of=gpb net=VPWR
  dn2 = array licon in=pd between=[gpb, gpa] net=n2
  dvp = array licon in=pd between=[gpa, gpn] net=VPWR
  dn3 = array licon in=pd between=[gpn, gpb2] net=n3
  dn1p= array licon in=pd between=[gpb2, gpa2] net=n1
  dvp2= array licon in=pd right_of=gpa2 net=VPWR

  spl = enclose sp li net=VPWR
  n2l = enclose dn2 li net=n2
  vpl = enclose dvp li net=VPWR
  n3l = enclose dn3 li net=n3
  n1pl= enclose dn1p li net=n1
  vpl2= enclose dvp2 li net=VPWR

  pwr0 = strap li from=spl to=vpwr_li
  pwr1 = strap li from=vpl to=vpwr_li
  pwr2 = strap li from=vpl2 to=vpwr_li

  # ---------- gate contacts: n-row lower, p-row upper, staggered ----------
  cbn = max(nd.top + 0.19, snl.top + 0.25, n1l.top + 0.25, vgl.top + 0.25, xl.top + 0.25, n4l.top + 0.25, vgl2.top + 0.25)
  cbp = cbn + 0.30

  gca  = contact licon cx=(ga.cx)  bottom=cbn
  gcb1 = contact licon cx=(gb1.cx) bottom=cbn
  gcn1 = contact licon cx=(gn1.cx) bottom=cbn
  gcb2 = contact licon cx=(gb2.cx) bottom=cbn
  gca2 = contact licon cx=(ga2.cx) bottom=cbn

  gcpb = contact licon cx=(gpb.cx) bottom=cbp
  gcpa = contact licon cx=(gpa.cx) bottom=cbp
  gcpn = contact licon cx=(gpn.cx) bottom=cbp
  gcpb2= contact licon cx=(gpb2.cx) bottom=cbp
  gcpa2= contact licon cx=(gpa2.cx) bottom=cbp

  gpan = enclose [gca, gcb1, gcn1, gcb2, gca2] poly by=minx
  gan  = enclose [gca, gcb1, gcn1, gcb2, gca2] npc
  gap  = enclose [gcpb, gcpa, gcpn, gcpb2, gcpa2] poly by=minx
  gapc = enclose [gcpb, gcpa, gcpn, gcpb2, gcpa2] npc

  aa = enclose gca  li net=A
  bb = enclose gcb1 li net=B
  nn = enclose gcn1 li net=n1
  bb2= enclose gcb2 li net=B
  aa2= enclose gca2 li net=A

  pab = enclose gcpb li net=B
  paa = enclose gcpa li net=A
  pnn = enclose gcpn li net=n1
  pbb = enclose gcpb2 li net=B
  paa2= enclose gcpa2 li net=A

  # ---------- n-well ----------
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ---------- internal net joins ----------
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route X  layers=m1,m2

  # ---------- input ports ----------
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B

  port A in  on=ap
  port B in  on=bp
  port X out on=xl
end
