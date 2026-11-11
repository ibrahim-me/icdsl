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

  dw = 2*0.265 + 4*L + 3*max(0.28, 0.54 - L)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(gb2.right + max(0.28, 0.54 - L))
  ga1 = cross [nd, pd] poly w=L left=(gb1.right + max(0.28, 0.54 - L))

  # n-row: n3 | A2 | VGND | B2 | n1 | B1 | Y | A1 | n3
  cn3l = array licon in=nd left_of=ga2
  cvn  = array licon in=nd between=[ga2, gb2] net=VGND
  cn1  = array licon in=nd between=[gb2, gb1] net=n1
  cy   = array licon in=nd between=[gb1, ga1] net=Y
  cn3r = array licon in=nd right_of=ga1 net=n3
  cn3ll = enclose cn3l li net=n3
  cn3rl = enclose cn3r li net=n3
  cvnl = enclose cvn li net=VGND
  cn1l = enclose cn1 li net=n1
  cyl  = enclose cy li net=Y
  route n3 layers=m1,m2
  stg  = strap li from=cvnl to=vgnd_li

  # p-row: VPWR | A2 | n2 | B2 | Y | B1 | n2 | A1 | VPWR
  cvpl = array licon in=pd left_of=ga2 net=VPWR
  cn2a = array licon in=pd between=[ga2, gb2] net=n2
  cy2  = array licon in=pd between=[gb2, gb1] net=Y
  cn2b = array licon in=pd between=[gb1, ga1] net=n2
  cvpr = array licon in=pd right_of=ga1 net=VPWR
  cvpll = enclose cvpl li net=VPWR
  cn2al = enclose cn2a li net=n2
  cyl2  = enclose cy2 li net=Y
  cn2bl = enclose cn2b li net=n2
  cvprl = enclose cvpr li net=VPWR
  route n2 layers=m1,m2
  route Y layers=m1,m2
  stp1 = strap li from=cvpll to=vpwr_li
  stp2 = strap li from=cvprl to=vpwr_li

  # gate contacts: n-row items only in cb; shifted off the n2 strap between gb1 and ga1
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cyl.top + 0.25)
  gca2 = contact licon cx=(ga2.cx - 0.13) bottom=cb
  gcb2 = contact licon cx=(gb2.cx - 0.13) bottom=cb
  gcb1 = contact licon cx=(gb1.cx + 0.13) bottom=cb
  cga1 = contact licon cx=(ga1.cx + 0.13) bottom=cb
  pca2 = enclose gca2 poly by=minx net=A2
  pcb2 = enclose gcb2 poly by=minx net=B2
  pcb1 = enclose gcb1 poly by=minx net=B1
  pga1 = enclose cga1 poly by=minx net=A1
  gn   = enclose [gca2, gcb2, gcb1, cga1] npc

  a2m = contact mcon in=pca2
  a2p = enclose a2m m1 by=0.06 net=A2
  b2m = contact mcon in=pcb2
  b2p = enclose b2m m1 by=0.06 net=B2
  b1m = contact mcon in=pcb1
  b1p = enclose b1m m1 by=0.06 net=B1
  a1m = contact mcon in=pga1
  a1p = enclose a1m m1 by=0.06 net=A1

  ym  = contact mcon in=cyl2 cy=(pd.cy)
  yp  = enclose ym m1 by=0.06 net=Y

  port A2 in on=a2p
  port B2 in on=b2p
  port B1 in on=b1p
  port A1 in on=a1p
  port Y out on=yp

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
end
```