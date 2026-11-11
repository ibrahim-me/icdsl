pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=9 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # single gate order A2 B1 B2 A1 crossing both rows
  # n row regions: VGND |A2| n3 |B1| Y |B2| n3 |A1| VGND
  # p row regions: VPWR|A2| Y  |B1| n2|B2| n1 |A1| VPWR
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.28, 0.54 - L)
  x0 = cell.cx - (0.53 + 4*L + 3*gap)/2
  gA2 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB1 = rect poly w=L left=(gA2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  gB2 = rect poly w=L left=(gB1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  gA1 = rect poly w=L left=(gB2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  nd = rect diff xspan=(gA2.left - 0.265, gA1.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(gA2.left - 0.265, gA1.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm
  # n row contacts
  cn0 = array licon in=nd left_of=gA2
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd between=[gA2, gB1]
  cn1l = enclose cn1 li net=n3
  cn2 = array licon in=nd between=[gB1, gB2]
  cn2l = enclose cn2 li net=Y
  cn3 = array licon in=nd between=[gB2, gA1]
  cn3l = enclose cn3 li net=n3
  cn4 = array licon in=nd right_of=gA1
  cn4l = enclose cn4 li net=VGND
  cn4s = strap li from=cn4l to=vgnd_li
  # p row contacts
  cp0 = array licon in=pd left_of=gA2
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp1 = array licon in=pd between=[gA2, gB1]
  cp1l = enclose cp1 li net=Y
  cp2 = array licon in=pd between=[gB1, gB2]
  cp2l = enclose cp2 li net=n2
  cp3 = array licon in=pd between=[gB2, gA1]
  cp3l = enclose cp3 li net=n1
  cp4 = array licon in=pd right_of=gA1
  cp4l = enclose cp4 li net=VPWR
  cp4s = strap li from=cp4l to=vpwr_li
  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25, cn4l.top + 0.25)
  gcA2 = contact licon cx=gA2.cx bottom=cb
  gpA2 = enclose gcA2 poly by=minx
  glA2 = enclose gcA2 li net=A2
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gpB1 = enclose gcB1 poly by=minx
  glB1 = enclose gcB1 li net=B1
  gcB2 = contact licon cx=gB2.cx bottom=cb
  gpB2 = enclose gcB2 poly by=minx
  glB2 = enclose gcB2 li net=B2
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gpA1 = enclose gcA1 poly by=minx
  glA1 = enclose gcA1 li net=A1
  gn = enclose [gcA2, gcB1, gcB2, gcA1] npc
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  a1m = contact mcon in=glA1
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=glA2
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=glB1
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon in=glB2
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  ym = contact mcon in=cn2l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
end
