pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=8 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  gap_ab = max(0.28, 0.54 - L)
  gap_bc = 0.80

  ndl_w = 0.265 + L + gap_ab + L + 0.265
  ndr_w = 0.265 + L + 0.265
  dw  = ndl_w + gap_bc + ndr_w

  ndl = rect diff w=ndl_w h=WN cx=(cell.cx - dw/2 + ndl_w/2) above=ptap
  ndr = rect diff w=ndr_w h=WN right_of=ndl gap=gap_bc above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose ndl nsdm
  nim2 = enclose ndr nsdm
  pim = enclose pd psdm

  ga = cross [ndl, pd] poly w=L left=(ndl.left + 0.265)
  gb = cross [ndl, pd] poly w=L left=(ga.right + gap_ab)
  gc = cross [ndr, pd] poly w=L left=(ndr.left + 0.265)

  # n-row left island: VGND-A1-n2-A2
  sn  = array licon in=ndl left_of=ga
  n2c = array licon in=ndl between=[ga, gb]
  dnl = array licon in=ndl right_of=gb
  snl = enclose sn li
  n2l = enclose n2c li net=n2
  dnll = enclose dnl li net=VGND

  # n-row right island: Y-B1-n2
  n3c = array licon in=ndr left_of=gc
  n4c = array licon in=ndr right_of=gc
  n3l = enclose n3c li net=Y
  n4l = enclose n4c li net=n2

  # p-row: VPWR-A1-n1-A2-Y-B1-VPWR
  s1  = array licon in=pd left_of=ga
  d1  = array licon in=pd right_of=ga
  n1c = array licon in=pd between=[ga, gb]
  yc  = array licon in=pd between=[gb, gc]
  s3  = array licon in=pd right_of=gc
  s1l = enclose s1 li net=n1
  d1l = enclose d1 li net=VPWR
  n1l = enclose n1c li net=n1
  yl  = enclose yc li net=Y
  s3l = enclose s3 li net=VPWR

  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dnll to=vgnd_li
  p1  = strap li from=d1l to=vpwr_li
  p2  = strap li from=s3l to=vpwr_li

  cb  = max(ndl.top + 0.19, snl.top + 0.25, n2l.top + 0.25, dnll.top + 0.25, n3l.top + 0.25, n4l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A1
  b   = enclose gcb li net=A2
  c   = enclose gcc li net=B1
  well y=((ndl.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A1
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=A2
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=B1

  ym  = contact mcon in=yl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  n1m = contact mcon in=n1l
  n1p = enclose n1m m1 by=0.06 net=n1
  route n1 layers=m1,m2

  n2m = contact mcon in=n2l
  n2p = enclose n2m m1 by=0.06 net=n2
  route n2 layers=m1,m2

  port A1 in  on=ap
  port A2 in  on=bp
  port B1 in  on=cp
  port Y out on=yp
end
