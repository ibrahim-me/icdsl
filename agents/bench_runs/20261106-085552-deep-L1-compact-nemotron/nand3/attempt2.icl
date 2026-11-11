pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=5 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.28, 0.54 - L)
  span = 0.53 + 3*L + 2*gap
  x0 = cell.cx - span/2
  nd1 = rect diff xspan=(x0, x0 + span) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(x0, x0 + span) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  g1 = cross [nd1, pd1] poly w=L left=(x0 + 0.265)
  g2 = cross [nd1, pd1] poly w=L left=(g1.right + gap)
  g3 = cross [nd1, pd1] poly w=L left=(g2.right + gap)

  # n-side: Y [A] (n2) [B] (n1) [C] VGND
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd1 right_of=g3
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li

  # p-side: Y [A] VPWR [B] Y [C] VPWR
  c3 = array licon in=pd1 left_of=g1
  c3l = enclose c3 li net=Y
  c4 = array licon in=pd1 right_of=g1
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  c5 = array licon in=pd1 right_of=g2
  c5l = enclose c5 li net=Y
  c6 = array licon in=pd1 right_of=g3
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li

  # gate contacts above n row
  cb = max(nd1.top + 0.19, c1l.top + 0.25, c2l.top + 0.25)
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

  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  # input ports on m1
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp

  # output Y: route n-side and p-side drains together
  route Y layers=m1,m2
  port Y out
end
