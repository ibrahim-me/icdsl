pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  nd  = rect diff w=(4*L + 1.64) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.64) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # common gate order: B1, B2, A2, A1
  gb1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb2 = cross [nd, pd] poly w=L left=(gb1.right + 0.28)
  ga2 = cross [nd, pd] poly w=L left=(gb2.right + 0.21)
  ga1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # n-row contacts: Y | B1 | n1 | B2 | GND | A2 | n3 | A1 | Y
  cn0 = array licon in=nd left_of=gb1
  cn1 = array licon in=nd right_of=gb1 left_of=gb2
  cn2 = array licon in=nd right_of=gb2 left_of=ga2
  cn3 = array licon in=nd right_of=ga2 left_of=ga1
  cn4 = array licon in=nd right_of=ga1
  cnl0 = enclose cn0 li net=Y
  cnl1 = enclose cn1 li net=n1
  cnl2 = enclose cn2 li net=VGND
  cnl3 = enclose cn3 li net=n3
  cnl4 = enclose cn4 li net=Y

  gndn = strap li from=cnl2 to=vgnd_li
  yn   = strap li from=cnl0 to=cnl4 net=Y

  # p-row contacts: VPWR | A2 | n2 | B2 | Y | B1 | n2 | A1 | VPWR
  cp0 = array licon in=pd left_of=ga2
  cp1 = array licon in=pd right_of=ga2 left_of=gb2
  cp2 = array licon in=pd right_of=gb2 left_of=gb1
  cp3 = array licon in=pd right_of=gb1 left_of=ga1
  cp4 = array licon in=pd right_of=ga1
  cpl0 = enclose cp0 li net=VPWR
  cpl1 = enclose cp1 li net=n2
  cpl2 = enclose cp2 li net=Y
  cpl3 = enclose cp3 li net=n2
  cpl4 = enclose cp4 li net=VPWR

  pwrp = strap li from=cpl0 to=vpwr_li
  pwr2 = strap li from=cpl4 to=vpwr_li
  n2s  = strap li from=cpl1 to=cpl3 net=n2

  # gate contacts in the gap between the rows, pushed outwards so pads clear
  cb = max(nd.top + 0.19, cnl1.top + 0.25, cnl3.top + 0.25, cpl1.top + 0.25, cpl3.top + 0.25)
  gc1 = contact licon cx=(gb1.cx - 0.1) bottom=cb
  gc2 = contact licon cx=(gb2.cx + 0.1) bottom=cb
  gc3 = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gc4 = contact licon cx=(ga1.cx + 0.1) bottom=cb
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gp3 = enclose gc3 poly by=minx
  gp4 = enclose gc4 poly by=minx
  gn  = enclose [gc1, gc2, gc3, gc4] npc
  a1  = enclose gc4 li net=A1
  a2  = enclose gc3 li net=A2
  b1  = enclose gc1 li net=B1
  b2  = enclose gc2 li net=B2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=cpl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end
