```icl
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

  nd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 3*0.28 + 2*0.265) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order: A2, A1, B1, B2  (n-row chain VGND-n3-Y-n1-VGND)
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + 0.28)
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(gb1.right + 0.28)

  # n-row: M3(A2) M6(A1) M0(B1) M4(B2)  ->  VGND | n3 | Y | n1 | VGND
  sn3 = array licon in=nd left_of=ga2
  sy  = array licon in=nd right_of=ga2 left_of=ga1
  sn1 = array licon in=nd right_of=ga1 left_of=gb1
  sv2 = array licon in=nd right_of=gb1 left_of=gb2
  sv3 = array licon in=nd right_of=gb2
  sn3l = enclose sn3 li net=VGND
  syl  = enclose sy  li net=Y
  sn1l = enclose sn1 li net=n1
  sv2l = enclose sv2 li net=VGND
  sv3l = enclose sv3 li net=VGND
  gndn = strap li from=sn3l to=vgnd_li
  gndn2= strap li from=sv2l to=vgnd_li
  gndn3= strap li from=sv3l to=vgnd_li

  # p-row: M1(A2) M2(A1) M7(B1) M5(B2)  ->  VPWR | n2 | VPWR | Y | n2 | VPWR
  sp1 = array licon in=pd left_of=ga2
  sn2a= array licon in=pd right_of=ga2 left_of=ga1
  sp2 = array licon in=pd right_of=ga1 left_of=gb1
  sy2 = array licon in=pd right_of=gb1 left_of=gb2
  sn2b= array licon in=pd right_of=gb2
  sp1l = enclose sp1 li net=VPWR
  sn2al= enclose sn2a li net=n2
  sp2l = enclose sp2 li net=VPWR
  sy2l = enclose sy2 li net=Y
  sn2bl= enclose sn2b li net=n2
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=sp2l to=vpwr_li
  route n2 layers=m1
  route Y layers=m1

  # gate contacts (n-row items only in cb), on their own gates
  cb = max(nd.top + 0.19, sn3l.top + 0.25, syl.top + 0.25, sn1l.top + 0.25, sv2l.top + 0.25, sv3l.top + 0.25)
  gc2 = contact licon cx=ga2.cx bottom=cb
  gc1 = contact licon cx=ga1.cx bottom=cb
  gb1c= contact licon cx=gb1.cx bottom=cb
  gb2c= contact licon cx=gb2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gp1 = enclose gc1 poly by=minx
  gb1p= enclose gb1c poly by=minx
  gb2p= enclose gb2c poly by=minx
  gn  = enclose [gc2, gc1, gb1c, gb2c] npc
  a2  = enclose gc2 li net=A2
  a1  = enclose gc1 li net=A1
  b1  = enclose gb1c li net=B1
  b2  = enclose gb2c li net=B2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=syl
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y  out on=yp
end
```