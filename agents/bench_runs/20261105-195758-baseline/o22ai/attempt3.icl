pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=14 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  nd  = rect diff w=(4*L + 1.63) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.63) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb1 = cross [nd, pd] poly w=L left=(ga2.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(gb1.right + 0.21)
  ga1 = cross [nd, pd] poly w=L left=(gb2.right + 0.28)

  # n row: VGND | A2 | n3 | B1 | Y | B2 | n3 | A1 | VGND
  sn  = array licon in=nd left_of=ga2
  sn3a= array licon in=nd right_of=ga2 left_of=gb1
  sy  = array licon in=nd right_of=gb1 left_of=gb2
  sn3b= array licon in=nd right_of=gb2 left_of=ga1
  sv  = array licon in=nd right_of=ga1
  snl = enclose sn li
  sn3al= enclose sn3a li
  syl = enclose sy li net=Y
  sn3bl= enclose sn3b li
  svl = enclose sv li
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=svl to=vgnd_li
  n3  = strap li from=sn3al to=sn3bl net=n3

  # p row: VPWR | A1 | n1 | A2 | Y | B2 | n2 | B1 | VPWR
  sp  = array licon in=pd left_of=ga1
  sn1 = array licon in=pd right_of=ga1 left_of=ga2
  sy2 = array licon in=pd right_of=ga2 left_of=gb2
  sn2 = array licon in=pd right_of=gb2 left_of=gb1
  sp2 = array licon in=pd right_of=gb1
  spl = enclose sp li
  sn1l= enclose sn1 li
  sy2l= enclose sy2 li net=Y
  sn2l= enclose sn2 li
  spl2= enclose sp2 li
  pwr = strap li from=spl to=vpwr_li
  pwr2= strap li from=spl2 to=vpwr_li

  route Y layers=m1

  # gate contacts in the gap between rows, shifted so pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, sn3al.top + 0.25, syl.top + 0.25,
                 sn3bl.top + 0.25, svl.top + 0.25, spl.top + 0.25, sn1l.top + 0.25,
                 sy2l.top + 0.25, sn2l.top + 0.25, spl2.top + 0.25)
  gca = contact licon cx=(ga2.cx - 0.12) bottom=cb
  gcb = contact licon cx=(gb1.cx - 0.12) bottom=cb
  gcc = contact licon cx=(gb2.cx + 0.12) bottom=cb
  gcd = contact licon cx=(ga1.cx + 0.12) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gpd = enclose gcd poly by=minx
  gna = enclose [gca, gcb, gcc, gcd] npc
  a2  = enclose gca li net=A2
  b1  = enclose gcb li net=B1
  b2  = enclose gcc li net=B2
  a1  = enclose gcd li net=A1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  ym  = contact mcon in=syl cy=(syl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p side=left layer=m2
  port A2 in  on=a2p side=left layer=m2
  port B1 in  on=b1p side=right layer=m2
  port B2 in  on=b2p side=right layer=m2
  port Y out on=yp side=right layer=m2
end
