pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=3 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  gap = max(0.28, 0.54 - L)
  span = 2*0.265 + 2*L + gap

  nd = rect diff w=span h=WN cx=cell.cx above=ptap
  pd = rect diff w=span h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  g1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  g2 = cross [nd, pd] poly w=L left=(g1.right + gap)

  sn = array licon in=nd left_of=g1
  dn = array licon in=nd right_of=g2
  s1 = array licon in=pd left_of=g1
  my = array licon in=pd right_of=g1
  s2 = array licon in=pd right_of=g2

  snl = enclose sn li net=Y
  dnl = enclose dn li
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li

  gnd = strap li from=dnl to=vgnd_li
  p1 = strap li from=s1l to=vpwr_li
  p2 = strap li from=s2l to=vpwr_li

  cb = max(nd.top + 0.19, snl.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gc2 = contact licon cx=g2.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gn = enclose [gc1, gc2] npc
  a = enclose gc1 li net=A
  b = enclose gc2 li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B
  ym = contact mcon in=myl
  yp = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in on=ap
  port B in on=bp
  port Y out on=yp
end
