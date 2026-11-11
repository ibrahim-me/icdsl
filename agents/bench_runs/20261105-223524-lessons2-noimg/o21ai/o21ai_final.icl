pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  nd  = rect diff w=(4*L + 1.85) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.85) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order A1, A2, B1 in both rows; pitch keeps 0.33 poly pads clear
  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))

  # n-row: c0=n2(edge) | A1 | c1=VGND | A2 | c2=n2 | B1 | c3=Y(edge)
  sn2 = array licon in=nd left_of=ga1
  svg = array licon in=nd right_of=ga1
  sn2b= array licon in=nd right_of=ga2
  sy  = array licon in=nd right_of=gb1
  sn2l = enclose sn2 li net=n2
  svgl = enclose svg li
  sn2bl= enclose sn2b li net=n2
  syl  = enclose sy li net=Y
  gndn = strap li from=svgl to=vgnd_li

  # p-row: c0=VPWR(edge) | A1 | c1=n1 | A2 | c2=Y | B1 | c3=VPWR(edge)
  spw = array licon in=pd left_of=ga1
  sn1 = array licon in=pd right_of=ga1
  sy2 = array licon in=pd right_of=ga2
  spw2= array licon in=pd right_of=gb1
  spwl = enclose spw li
  sn1l = enclose sn1 li net=n1
  syl2 = enclose sy2 li net=Y
  spw2l= enclose spw2 li
  pwr1 = strap li from=spwl to=vpwr_li
  pwr2 = strap li from=spw2l to=vpwr_li

  # gate contacts in gap between rows (n-row items only in cb)
  cb = max(nd.top + 0.19, sn2l.top + 0.25, svgl.top + 0.25, sn2bl.top + 0.25, syl.top + 0.25)
  gc1 = contact licon cx=(ga1.cx) bottom=cb
  gc2 = contact licon cx=(ga2.cx) bottom=cb
  gc3 = contact licon cx=(gb1.cx) bottom=cb
  pg1 = enclose gc1 poly by=minx
  pg2 = enclose gc2 poly by=minx
  pg3 = enclose gc3 poly by=minx
  gn  = enclose [gc1, gc2, gc3] npc
  a1  = enclose gc1 li net=A1
  a2  = enclose gc2 li net=A2
  b1  = enclose gc3 li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # n2 is split across c0 and c2; join with m1/m2
  route n2 layers=m1,m2
  # Y: n-row c3 and p-row c2 do not line up; join with m1/m2, pin on routed met1
  route Y layers=m1,m2

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=syl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out on=yp
end
