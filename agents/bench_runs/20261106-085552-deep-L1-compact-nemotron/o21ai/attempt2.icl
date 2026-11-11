pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # ---- diffusion rows (n bottom, p top) ----
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  # gate pitch 0.54 (poly pad 0.33); gap between gates = max(contact column, 0.54 - L)
  ggap1 = max(0.28, 0.54 - L)   # between A2 and A1: n-row VGND contact column
  ggap2 = max(0.80, 0.54 - L)   # between A1 and B1: p-row island break (0.80) / n-row n2 contact

  x0 = cell.cx - (0.53 + 3*L + ggap1 + ggap2)/2

  # gates as poly strips crossing both rows
  gA2 = rect poly w=L left=x0 yspan=(ny0 - 0.13, py1 + 0.13)
  gA1 = rect poly w=L left=(gA2.right + ggap1) yspan=(ny0 - 0.13, py1 + 0.13)
  gB1 = rect poly w=L left=(gA1.right + ggap2) yspan=(ny0 - 0.13, py1 + 0.13)

  # n row: one continuous diffusion island, nets n2 | VGND | n2 | Y
  nd = rect diff xspan=(gA2.left - 0.265, gB1.right + 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose nd nsdm

  # p row: two islands (break between A1 and B1)
  pd1 = rect diff xspan=(gA2.left - 0.265, gA1.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(gB1.left - 0.265, gB1.right + 0.265) yspan=(py1 - WP2, py1)
  pim = enclose [pd1, pd2] psdm

  # ---- n-row contacts ----
  cn2l = array licon in=nd left_of=gA2
  cn2l_l = enclose cn2l li net=n2
  cvgnd = array licon in=nd between=[gA2, gA1]
  cvgnd_l = enclose cvgnd li net=VGND
  cvgnd_s = strap li from=cvgnd_l to=vgnd_li
  cn2r = array licon in=nd between=[gA1, gB1]
  cn2r_l = enclose cn2r li net=n2
  cy = array licon in=nd right_of=gB1
  cy_l = enclose cy li net=Y

  # ---- p-row contacts ----
  cpY1 = array licon in=pd1 left_of=gA2
  cpY1_l = enclose cpY1 li net=Y
  cpVPWR1 = array licon in=pd1 right_of=gA1
  cpVPWR1_l = enclose cpVPWR1 li net=VPWR
  cpVPWR1_s = strap li from=cpVPWR1_l to=vpwr_li
  cpVPWR2 = array licon in=pd2 left_of=gB1
  cpVPWR2_l = enclose cpVPWR2 li net=VPWR
  cpVPWR2_s = strap li from=cpVPWR2_l to=vpwr_li
  cpY2 = array licon in=pd2 right_of=gB1
  cpY2_l = enclose cpY2 li net=Y

  # ---- gate contacts (cb from n-row items only) ----
  cb = max(nd.top + 0.19, cn2l_l.top + 0.25, cvgnd_l.top + 0.25, cn2r_l.top + 0.25, cy_l.top + 0.25)
  gcA2 = contact licon cx=gA2.cx bottom=cb
  gpA2 = enclose gcA2 poly by=minx
  glA2 = enclose gcA2 li net=A2
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gpA1 = enclose gcA1 poly by=minx
  glA1 = enclose gcA1 li net=A1
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gpB1 = enclose gcB1 poly by=minx
  glB1 = enclose gcB1 li net=B1
  gn = enclose [gcA2, gcA1, gcB1] npc

  # ---- n-well: bottom 0.34 above n-diff top, 0.18 inside p-diff bottom ----
  well y=((nd.top + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  # ---- input ports (met1 over gate-contact li) ----
  a2m = contact mcon in=glA2
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  a1m = contact mcon in=glA1
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  b1m = contact mcon in=glB1
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p

  # ---- internal net n2: split across diffusion regions -> route in metal ----
  route n2 layers=m1,m2

  # ---- output Y: n and p drains not vertically aligned -> route, port on routed met1 ----
  route Y layers=m1,m2
  port Y out

end
