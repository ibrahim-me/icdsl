```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=(3*L + 1.09) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(3*L + 1.09) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.21, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + max(0.28, 0.54 - L))

  sn  = array licon in=nd left_of=ga2
  cy  = array licon in=nd right_of=ga1
  se  = array licon in=nd right_of=gb1
  snl = enclose sn li
  yl  = enclose cy li net=Y
  sel = enclose se li
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=sel to=vgnd_li

  s1l = array licon in=pd left_of=ga2
  s1l = enclose s1l li net=n2
  p1  = array licon in=pd right_of=ga2
  p1  = enclose p1 li
  p1s = strap li from=p1 to=vpwr_li
  s2l = array licon in=pd left_of=gb1
  s2l = enclose s2l li net=n2
  ylp = array licon in=pd right_of=gb1
  ylp = enclose ylp li net=Y

  route n2 layers=m1,m2
  route Y layers=m1,m2

  cb = max(nd.top + 0.19, snl.top + 0.25, yl.top + 0.25)
  gca = contact licon cx=ga2.cx bottom=cb
  gcb = contact licon cx=gb1.cx bottom=cb
  gcc = contact licon cx=ga1.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a2  = enclose gca li net=A2
  b1  = enclose gcb li net=B1
  a1  = enclose gcc li net=A1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  ym  = contact mcon in=yl
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out on=yp
end
```