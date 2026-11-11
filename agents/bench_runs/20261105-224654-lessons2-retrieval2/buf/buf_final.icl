pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # stick plan (gate order A, n1; | = diffusion island break)
  #   p: VPWR [A] n1 | X [n1] VPWR
  #   n: VGND [A] n1 | VGND [n1] X
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.83, 0.54 - L)             # island break: separates n1 node from M0's VGND side
  span = 0.53 + 2*L + gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  nd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(ny0, ny0 + WN)   # M2 island
  nd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)   # M0 island
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP, py1)   # M1 island
  pd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)   # M3 island
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n1
  c3 = array licon in=nd2 left_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd2 right_of=g2
  c4l = enclose c4 li net=X
  c5 = array licon in=pd1 left_of=g1
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd1 right_of=g1
  c6l = enclose c6 li net=n1
  c7 = array licon in=pd2 left_of=g2
  c7l = enclose c7 li net=X
  c8 = array licon in=pd2 right_of=g2
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c4l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=n1
  gn = enclose [gc1, gc2] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  route n1 layers=m1,m2
  route X layers=m1,m2
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  port X out
end
