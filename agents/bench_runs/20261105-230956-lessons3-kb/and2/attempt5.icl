pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  gap = max(0.28, 0.56 - L)
  wl  = 0.53 + 2*L + gap

  nd1 = rect diff w=wl h=WN right=(cell.cx - 0.40) above=ptap
  nd2 = rect diff w=wl h=WN left=(cell.cx + 0.40) above=ptap
  pd1 = rect diff w=wl h=WP right=(cell.cx - 0.40) below=ntap
  pd2 = rect diff w=wl h=WP left=(cell.cx + 0.40) below=ntap
  nim1 = enclose nd1 nsdm
  nim2 = enclose nd2 nsdm
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  ga = cross [nd1, pd1] poly w=L left=(nd1.left + 0.265)
  gb = cross [nd1, pd1] poly w=L left=(ga.right + gap)
  gn = cross [nd2, pd2] poly w=L left=(nd2.left + 0.265)

  # n-side left island: n1 | A | n2 | B | VGND
  sn  = array licon in=nd1 left_of=ga
  sn2 = array licon in=nd1 between=[ga, gb]
  dn  = array licon in=nd1 right_of=gb
  # n-side right island: X | n1 | VGND
  s0  = array licon in=nd2 left_of=gn
  d0  = array licon in=nd2 right_of=gn
  snl = enclose sn li net=n1
  sn2l = enclose sn2 li net=n2
  dnl = enclose dn li net=VGND
  s0l = enclose s0 li net=X
  d0l = enclose d0 li net=VGND
  gndn = strap li from=dnl to=vgnd_li
  gnd0 = strap li from=d0l to=vgnd_li

  # p-side left island: VPWR | A | n1 | B | VPWR
  s1  = array licon in=pd1 left_of=ga
  d1  = array licon in=pd1 between=[ga, gb]
  s3  = array licon in=pd1 right_of=gb
  # p-side right island: X | n1 | VPWR
  s5  = array licon in=pd2 left_of=gn
  d5  = array licon in=pd2 right_of=gn
  s1l = enclose s1 li net=VPWR
  d1l = enclose d1 li net=n1
  s3l = enclose s3 li net=VPWR
  s5l = enclose s5 li net=X
  d5l = enclose d5 li net=VPWR
  pwr1 = strap li from=s1l to=vpwr_li
  pwr3 = strap li from=s3l to=vpwr_li
  pwr5 = strap li from=d5l to=vpwr_li
  x5   = strap li from=s5l to=s0l net=X cx=(s5l.cx)

  cb = max(nd1.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s0l.top + 0.25, d0l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=(gn.cx + 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gn_all = enclose [gca, gcb, gcn] npc
  al = enclose gca li net=A
  bl = enclose gcb li net=B
  nl = enclose gcn li net=n1

  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  am  = contact mcon in=al
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bl
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=s0l cy=(s0l.cy)
  xp  = enclose xm m1 by=0.06 net=X

  route n1 layers=m1,m2
  route X layers=m1,m2
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
