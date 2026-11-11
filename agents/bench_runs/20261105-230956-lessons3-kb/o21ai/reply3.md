```icl
pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  nd  = rect diff w=(3*L + 1.34) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(3*L + 1.34) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order A2, A1, B1 - same for both rows; centred gate contacts
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + max(0.28, 0.54 - L))

  # n-row: n2 | A2 | VGND | A1 | n2 | B1 | Y
  sn2 = array licon in=nd left_of=ga2
  sv  = array licon in=nd between=[ga2, ga1]
  sn2b= array licon in=nd between=[ga1, gb1]
  sy  = array licon in=nd right_of=gb1
  sn2l = enclose sn2 li net=n2
  svl  = enclose sv li
  sn2bl= enclose sn2b li net=n2
  syl  = enclose sy li net=Y
  gndn = strap li from=svl to=vgnd_li

  # p-row: Y | A2 | n1 | A1 | VPWR | B1 | Y
  sp0  = array licon in=pd left_of=ga2
  sn1  = array licon in=pd between=[ga2, ga1]
  svp  = array licon in=pd between=[ga1, gb1]
  sp3  = array licon in=pd right_of=gb1
  sp0l = enclose sp0 li net=Y
  sn1l = enclose sn1 li net=n1
  svpl = enclose svp li
  sp3l = enclose sp3 li net=Y
  pwr  = strap li from=svpl to=vpwr_li

  # gate contacts centred on their own gates (n-row items only in cb)
  cb = max(nd.top + 0.19, sn2l.top + 0.25, sn2bl.top + 0.25, syl.top + 0.25)
  gca2 = contact licon cx=ga2.cx bottom=cb
  gca1 = contact licon cx=ga1.cx bottom=cb
  gcb1 = contact licon cx=gb1.cx bottom=cb
  pa2 = enclose gca2 poly by=minx
  pa1 = enclose gca1 poly by=minx
  pb1 = enclose gcb1 poly by=minx
  gn  = enclose [gca2, gca1, gcb1] npc
  la2 = enclose gca2 li net=A2
  la1 = enclose gca1 li net=A1
  lb1 = enclose gcb1 li net=B1

  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route Y layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=la2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=la1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=lb1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=sp3l
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
```