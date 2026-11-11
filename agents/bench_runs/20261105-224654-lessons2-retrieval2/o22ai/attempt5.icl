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

  # gate order A1 A2 | B1 B2 (same order crosses both rows)
  # n row: VGND|A1|n3|A2|VGND |break| Y|B1|n3|B2|Y
  # p row: VPWR|A1|n1|A2|Y   |break| VPWR|B1|n2|B2|Y
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.28, 0.54 - L)
  x0 = cell.cx - (2*(0.53 + 2*L + gap) + 0.80)/2
  gA1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gA2 = rect poly w=L left=(gA1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  gB1 = rect poly w=L left=(gA2.right + gap + 0.80) yspan=(ny0 - 0.13, py1 + 0.13)
  gB2 = rect poly w=L left=(gB1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  ndA = rect diff xspan=(gA1.left - 0.265, gA2.right + 0.265) yspan=(ny0, ny0 + WN)
  ndB = rect diff xspan=(gB1.left - 0.265, gB2.right + 0.265) yspan=(ny0, ny0 + WN)
  pdA = rect diff xspan=(gA1.left - 0.265, gA2.right + 0.265) yspan=(py1 - WP, py1)
  pdB = rect diff xspan=(gB1.left - 0.265, gB2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [ndA, ndB] nsdm
  pim = enclose [pdA, pdB] psdm
  # n row island A: VGND | A1 | n3 | A2 | VGND
  cn0 = array licon in=ndA left_of=gA1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=ndA between=[gA1, gA2]
  cn1l = enclose cn1 li net=n3
  cn2 = array licon in=ndA right_of=gA2
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li
  # n row island B: Y | B1 | n3 | B2 | Y
  cn3 = array licon in=ndB left_of=gB1
  cn3l = enclose cn3 li net=Y
  cn4 = array licon in=ndB between=[gB1, gB2]
  cn4l = enclose cn4 li net=n3
  cn5 = array licon in=ndB right_of=gB2
  cn5l = enclose cn5 li net=Y
  # p row island A: VPWR | A1 | n1 | A2 | Y
  cp0 = array licon in=pdA left_of=gA1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp1 = array licon in=pdA between=[gA1, gA2]
  cp1l = enclose cp1 li net=n1
  cp2 = array licon in=pdA right_of=gA2
  cp2l = enclose cp2 li net=Y
  # p row island B: VPWR | B1 | n2 | B2 | Y
  cp3 = array licon in=pdB left_of=gB1
  cp3l = enclose cp3 li net=VPWR
  cp3s = strap li from=cp3l to=vpwr_li
  cp4 = array licon in=pdB between=[gB1, gB2]
  cp4l = enclose cp4 li net=n2
  cp5 = array licon in=pdB right_of=gB2
  cp5l = enclose cp5 li net=Y
  # join all Y pieces with li straps (vertical, aligned columns)
  ys1 = strap li from=cn3l to=cp2l   # n-row Y(left of B1) to p-row Y(right of A2)
  ys2 = strap li from=cn5l to=cp5l   # n-row Y(right of B2) to p-row Y(right of B2)
  cb = max(ndA.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25, cn4l.top + 0.25, cn5l.top + 0.25)
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gpA1 = enclose gcA1 poly by=minx
  glA1 = enclose gcA1 li net=A1
  gcA2 = contact licon cx=gA2.cx bottom=cb
  gpA2 = enclose gcA2 poly by=minx
  glA2 = enclose gcA2 li net=A2
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gpB1 = enclose gcB1 poly by=minx
  glB1 = enclose gcB1 li net=B1
  gcB2 = contact licon cx=gB2.cx bottom=cb
  gpB2 = enclose gcB2 poly by=minx
  glB2 = enclose gcB2 li net=B2
  gn = enclose [gcA1, gcA2, gcB1, gcB2] npc
  well y=((max(ndA.top, ndB.top) + 0.34 + min(pdA.bottom, pdB.bottom) - 0.18) / 2)
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
  ym = contact mcon in=cn5l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
end
