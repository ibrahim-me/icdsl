pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=5 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27

  gap = max(0.28, 0.54 - L)

  end = 0.26
  span = 2*end + 3*L + 2*gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + end) yspan=(ny0 - 0.13, py1 + 0.13)
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)

  nd1 = rect diff xspan=(g1.left - end, g3.right + end) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - end, g3.right + end) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=Y
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd1 right_of=g3
  c4l = enclose c4 li net=Y
  c5 = array licon in=pd1 left_of=g1
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd1 right_of=g3
  c6l = enclose c6 li net=Y

  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=C
  gn = enclose [gc1, gc2, gc3] npc

  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp

  port Y out
  route Y layers=m1,m2 prefer=m2
end
