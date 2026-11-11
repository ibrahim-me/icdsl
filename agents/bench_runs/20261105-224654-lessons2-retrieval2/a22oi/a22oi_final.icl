pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a22oi width=7 height=H
  device M0 nmos w=WN l=L d=n1 g=B1 s=Y
  device M1 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device M2 pmos w=WP l=L d=VPWR g=A1 s=n2
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=VGND g=B2 s=n1
  device M5 pmos w=WP l=L d=Y g=B2 s=n2
  device M6 nmos w=WN l=L d=Y g=A1 s=n3
  device M7 pmos w=WP l=L d=n2 g=B1 s=Y

  # gate order A2 A1 B1 B2
  # n (single chain): VGND |A2| n3 |A1| Y |B1| n1 |B2| VGND
  # p (two islands, break between A1 and B1):
  #   VPWR |A2| n2 |A1| VPWR   |   Y |B1| n2 |B2| Y   (n2 and Y joined by route)
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gapp = max(0.80, 0.54 - L)          # p-diff break gap (diff spacing 0.27)
  gaps = max(0.28, 0.54 - L)          # normal inter-gate gap
  span = 0.53 + 4*L + 2*gaps + gapp
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # A2
  g2 = rect poly w=L left=(g1.right + gaps) yspan=(ny0 - 0.13, py1 + 0.13)   # A1
  g3 = rect poly w=L left=(g2.right + gapp) yspan=(ny0 - 0.13, py1 + 0.13)   # B1
  g4 = rect poly w=L left=(g3.right + gaps) yspan=(ny0 - 0.13, py1 + 0.13)   # B2

  nd = rect diff xspan=(g1.left - 0.265, g4.right + 0.265) yspan=(ny0, ny0 + WN)
  pda = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pdb = rect diff xspan=(g3.left - 0.265, g4.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pda, pdb] psdm

  # n-row contacts
  cn0 = array licon in=nd left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd right_of=g1
  cn1l = enclose cn1 li net=n3
  cn2 = array licon in=nd right_of=g2
  cn2l = enclose cn2 li net=Y
  cn3 = array licon in=nd right_of=g3
  cn3l = enclose cn3 li net=n1
  cn4 = array licon in=nd right_of=g4
  cn4l = enclose cn4 li net=VGND
  cn4s = strap li from=cn4l to=vgnd_li

  # p-row contacts (island A: VPWR n2 VPWR ; island B: Y n2 Y)
  cp0 = array licon in=pda left_of=g1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp1 = array licon in=pda right_of=g1
  cp1l = enclose cp1 li net=n2
  cp2 = array licon in=pda right_of=g2
  cp2l = enclose cp2 li net=VPWR
  cp2s = strap li from=cp2l to=vpwr_li
  cp3 = array licon in=pdb left_of=g3
  cp3l = enclose cp3 li net=Y
  cp4 = array licon in=pdb right_of=g3
  cp4l = enclose cp4 li net=n2
  cp5 = array licon in=pdb right_of=g4
  cp5l = enclose cp5 li net=Y

  # gate contacts (n-row items only in cb)
  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25, cn4l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B2
  gn = enclose [gc1, gc2, gc3, gc4] npc

  well y=((max(nd.top) + 0.34 + min(pda.bottom) - 0.18) / 2)

  # ports
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  b2m = contact mcon in=gl4
  b2p = enclose b2m m1 by=0.06 net=B2
  port B2 in on=b2p
  port Y out

  # internal / output nets
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
end
