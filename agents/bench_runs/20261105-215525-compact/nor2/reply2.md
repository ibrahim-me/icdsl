```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=3 height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.21, 0.54 - L)
  span = 0.53 + 2*L + gap

  nd = rect diff w=span h=WN cx=cell.cx above=ptap
  pd = rect diff w=span h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  g1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  g2 = cross [nd, pd] poly w=L left=(g1.right + gap)

  cn0 = array licon in=nd left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd right_of=g1
  cn1l = enclose cn1 li net=Y
  cn2 = array licon in=nd right_of=g2
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li

  cp0 = array licon in=pd left_of=g1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp2 = array licon in=pd right_of=g2
  cp2l = enclose cp2 li net=Y

  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gn = enclose [gc1, gc2] npc

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  ym = contact mcon in=cp2l
  yp = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2
  port Y out on=yp
end
```