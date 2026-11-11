pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=5 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  # Gate order A2, A1, B1 for both rows:
  # n-row: VGND - A2 - n1 - A1 - Y - B1 - VGND
  # p-row: n2 - A2 - VPWR - A1 - n2 - B1 - Y
  # Diffusion: end contact (0.265) + gate + gap(0.40) + gate + gap(0.40) + gate + end contact(0.265)
  # End margin must be 0.265 + 0.17 + 0.04 = 0.475 for contact enclosure
  endm = 0.475
  gap  = 0.40
  dnw = 2*endm + 3*L + 2*gap
  nd  = rect diff w=dnw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dnw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga2 = cross [nd, pd] poly w=L left=(nd.left + endm)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + gap)
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + gap)

  # n row: VGND(left), n1, Y, VGND(right)
  sn  = array licon in=nd left_of=ga2
  dn1 = array licon in=nd between=[ga2, ga1] net=n1
  dny = array licon in=nd between=[ga1, gb1] net=Y
  sn2 = array licon in=nd right_of=gb1
  # p row: n2(left), VPWR, n2, Y(right)
  sp  = array licon in=pd left_of=ga2 net=n2
  dpwr= array licon in=pd between=[ga2, ga1] net=VPWR
  dn2 = array licon in=pd between=[ga1, gb1] net=n2
  dpy = array licon in=pd right_of=gb1 net=Y

  snl = enclose sn li
  dn1l= enclose dn1 li
  dnyl= enclose dny li
  sn2l= enclose sn2 li
  spl = enclose sp li
  dpwrl= enclose dpwr li
  dn2l= enclose dn2 li
  dpyl= enclose dpy li

  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=sn2l to=vgnd_li
  pwr = strap li from=dpwrl to=vpwr_li

  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y  layers=m1,m2

  cb = max(nd.top + 0.19, snl.top + 0.25, dn1l.top + 0.25, dnyl.top + 0.25, sn2l.top + 0.25)
  gca = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gcb = contact licon cx=(ga1.cx + 0.1) bottom=cb
  gcc = contact licon cx=(gb1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A2
  ab  = enclose gcb li net=A1
  ac  = enclose gcc li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=aa
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=ab
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=ac
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=dnyl
  yp  = enclose ym m1 by=0.06 net=Y
  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port Y  out on=yp
end
