pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=7 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gapc = max(0.28, 0.54 - L)      # gate gap with a contact column between
  gaps = max(0.21, 0.54 - L)      # gate gap for a series node (no contact)
  x0 = cell.cx - (0.265 + L + gapc + L + gaps + L + 0.265)/2
  g1 = cross [nd, pd] poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = cross [nd, pd] poly w=L left=(g1.right + gapc) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = cross [nd, pd] poly w=L left=(g2.right + gaps) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n2
  nd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # n row: VGND | A | n2 | B | VGND | n2 | X
  cn0 = array licon in=nd left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd right_of=g1
  cn1l = enclose cn1 li net=n2
  cn2 = array licon in=nd right_of=g2
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li
  cn3 = array licon in=nd right_of=g3
  cn3l = enclose cn3 li net=X
  # p row: VPWR | A | n1 | B | n2 | n2 | VPWR
  cp0 = array licon in=pd left_of=g1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp1 = array licon in=pd right_of=g1
  cp1l = enclose cp1 li net=n1
  cp2 = array licon in=pd right_of=g2
  cp2l = enclose cp2 li net=n2
  cp3 = array licon in=pd left_of=g3
  cp3l = enclose cp3 li net=n2
  cp4 = array licon in=pd right_of=g3
  cp4l = enclose cp4 li net=VPWR
  cp4s = strap li from=cp4l to=vpwr_li
  cb = max(nd.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=(g2.cx - 0.1) bottom=(cb + 0.17)
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=(g3.cx + 0.1) bottom=(cb + 0.34)
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n2
  gn = enclose [gc1, gc2, gc3] npc
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route X layers=m1,m2
  port X out
end
