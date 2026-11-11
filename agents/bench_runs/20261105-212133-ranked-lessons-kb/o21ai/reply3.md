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

  # p-row (below ntap): M4(A1) | M0(A2) | M1(B1)  ->  VPWR | n1 | Y | VPWR
  pd  = rect diff w=min h=WP cx=cell.cx below=ntap
  pim = enclose pd psdm
  gp4 = cross [pd] poly w=L left=(pd.left + 0.265)
  gp0 = cross [pd] poly w=L left=(gp4.right + max(0.28, 0.54 - L))
  gp1 = cross [pd] poly w=L right=(pd.right - 0.265)
  p4  = array licon in=pd left_of=gp4
  p01 = array licon in=pd right_of=gp4
  p02 = array licon in=pd left_of=gp1
  p1  = array licon in=pd right_of=gp1
  p4l = enclose p4 li
  p01l = enclose p01 li net=n1
  p02l = enclose p02 li net=Y
  p1l = enclose p1 li
  p4s = strap li from=p4l to=vpwr_li
  p1s = strap li from=p1l to=vpwr_li

  # n-row (above ptap): M5(A2) | M2(A1) | M3(B1)  ->  n2 | VGND | n2 | Y
  nd  = rect diff w=min h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  gn5 = cross [nd] poly w=L left=(nd.left + 0.265)
  gn2 = cross [nd] poly w=L left=(gn5.right + max(0.28, 0.54 - L))
  gn3 = cross [nd] poly w=L right=(nd.right - 0.265)
  n5  = array licon in=nd left_of=gn5
  n22 = array licon in=nd right_of=gn5
  n23 = array licon in=nd left_of=gn3
  n3  = array licon in=nd right_of=gn3
  n5l = enclose n5 li net=n2
  n22l = enclose n22 li
  n23l = enclose n23 li net=n2
  n3l = enclose n3 li net=Y
  n5s = strap li from=n5l to=vgnd_li
  n22s = strap li from=n22l to=vgnd_li

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, n22l.top + 0.25, n23l.top + 0.25, n5l.top + 0.25, n3l.top + 0.25)
  gc4 = contact licon cx=gp4.cx bottom=cb
  gc0 = contact licon cx=gp0.cx bottom=cb
  gc1 = contact licon cx=gp1.cx bottom=cb
  gc5 = contact licon cx=(gn5.cx - 0.12) bottom=cb
  gc2 = contact licon cx=(gn2.cx + 0.12) bottom=cb
  gc3 = contact licon cx=(gn3.cx - 0.12) bottom=cb
  gp4e = enclose gc4 poly by=minx
  gp0e = enclose gc0 poly by=minx
  gp1e = enclose gc1 poly by=minx
  gn5e = enclose gc5 poly by=minx
  gn2e = enclose gc2 poly by=minx
  gn3e = enclose gc3 poly by=minx
  gne = enclose [gc4, gc0, gc1, gc5, gc2, gc3] npc
  a1l = enclose [gc4, gc2] li net=A1
  a2l = enclose [gc0, gc5] li net=A2
  b1l = enclose [gc1, gc3] li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input pins on p-side gate contacts; route each input on m1,m2 to reach both gates
  a1m = contact mcon in=gc4
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=gc0
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=gc1
  b1p = enclose b1m m1 by=0.06 net=B1
  route A1 layers=m1,m2
  route A2 layers=m1,m2
  route B1 layers=m1,m2

  # internal nets
  route n2 layers=m1
  route Y layers=m1,m2
  ym = contact mcon in=p02l
  yp = enclose ym m1 by=0.06 net=Y
  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out  on=yp
end
```