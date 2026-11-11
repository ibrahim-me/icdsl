pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=12 height=H
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

  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + 0.21)
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + 0.28)
  gb1 = cross [nd, pd] poly w=L left=(gb2.right + 0.21)

  # n row: VGND | A1 | A2 | n3 | B2 | B1 | Y
  sn  = array licon in=nd left_of=ga1
  sn3 = array licon in=nd right_of=ga2
  sy  = array licon in=nd right_of=gb1
  snl = enclose sn li
  sn3l= enclose sn3 li
  syl = enclose sy li net=Y
  gnd = strap li from=snl to=vgnd_li

  # p row: VPWR | A1 | n1 | A2 | Y | B2 | n2 | B1 | VPWR
  sp  = array licon in=pd left_of=ga1
  sn1 = array licon in=pd right_of=ga1
  sy2 = array licon in=pd right_of=ga2
  sn2 = array licon in=pd right_of=gb2
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
  cb  = max(nd.top + 0.19, snl.top + 0.25, sn3l.top + 0.25, syl.top + 0.25,
                 spl.top + 0.25, sn1l.top + 0.25, sy2l.top + 0.25, sn2l.top + 0.25, spl2.top + 0.25)
  gca = contact licon cx=(ga1.cx - 0.12) bottom=cb
  gcb = contact licon cx=(ga2.cx + 0.12) bottom=cb
  gcc = contact licon cx=(gb2.cx - 0.12) bottom=cb
  gcd = contact licon cx=(gb1.cx + 0.12) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gpd = enclose gcd poly by=minx
  gna = enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=syl cy=(syl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end
