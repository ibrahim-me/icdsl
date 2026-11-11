pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=7 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  # stick plan (gate order A B n1; (net) = series node, no contact; | = break)
  #   p: VPWR [A] (n1) [B] VPWR | VPWR [n1] X
  #   n: n1 [A] (n2) [B] VGND | VGND [n1] X
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=n1
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=X
  c6 = array licon in=pd1 left_of=g1
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd1 between=[g1, g2]
  c7l = enclose c7 li net=n1
  c8 = array licon in=pd1 right_of=g2
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li
  c9 = array licon in=pd2 left_of=g3
  c9l = enclose c9 li net=VPWR
  c10 = array licon in=pd2 right_of=g3
  c10l = enclose c10 li net=X
  xst = strap li from=c5l to=c10l
  cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=(g1.cx - 0.13) bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=(g2.cx - 0.13) bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=(g3.cx - 0.13) bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port X out                       # pin goes on the routed met1 of X
  route n1 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
end
