pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell buf width=8 height=H
  device MN1 nmos w=WN l=L d=n1 g=A s=VGND
  device MP1 pmos w=WP l=L d=n1 g=A s=VPWR
  device MN2 nmos w=WN l=L d=X g=n1 s=VGND
  device MP2 pmos w=WP l=L d=X g=n1 s=VPWR

  nd  = rect diff w=(4*L + 1.62) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.62) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn1 = array licon in=nd left_of=ga
  dn1 = array licon in=nd right_of=ga left_of=gn1
  sn2 = array licon in=nd right_of=gn1
  sp1 = array licon in=pd left_of=ga
  dp1 = array licon in=pd right_of=ga left_of=gn1
  sp2 = array licon in=pd right_of=gn1
  sn1l = enclose sn1 li
  dn1l = enclose dn1 li net=n1
  sn2l = enclose sn2 li
  sp1l = enclose sp1 li
  dp1l = enclose dp1 li net=n1
  sp2l = enclose sp2 li
  gnd1 = strap li from=sn1l to=vgnd_li
  gnd2 = strap li from=sn2l to=vgnd_li
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=sp2l to=vpwr_li

  cb = max(nd.top + 0.19, sn1l.top + 0.25, dn1l.top + 0.25, sn2l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcn = contact licon cx=(gn1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gna = enclose [gca, gcn] npc
  a   = enclose gca li net=A
  n1  = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  n1m = contact mcon in=dn1l
  n1p = enclose n1m m1 by=0.06 net=n1
  n1g = contact mcon in=n1
  n1q = enclose n1g m1 by=0.06 net=n1

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  xm  = contact mcon in=dn1l cy=(dn1l.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port X out on=xp
end
