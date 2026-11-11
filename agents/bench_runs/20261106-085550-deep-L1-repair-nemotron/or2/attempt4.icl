pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=8 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  # gate order A, B, n2 - same for both rows; pitch >= 0.54 centre-to-centre
  gpitch = max(0.28, 0.54 - L)
  gbreak = max(0.80, 0.54 - L)
  span = 2*0.265 + 3*L + 2*gpitch + gbreak
  x0 = cell.cx - span/2
  g1x = x0 + 0.265 + L/2                # centre of gate A
  g2x = g1x + L + gpitch                # centre of gate B
  g3x = g2x + L + gbreak                # centre of gate n2

  # gate edges
  g1l = g1x - L/2
  g1r = g1x + L/2
  g2l = g2x - L/2
  g2r = g2x + L/2
  g3l = g3x - L/2
  g3r = g3x + L/2

  # n row diffusions (0.265 end contacts beyond outer gates)
  nd1 = rect diff xspan=(g1l - 0.265, g2r + 0.265) yspan=(ny0, ny0 + WN2)   # VGND-A-n2-B-VGND (M2,M3)
  nd2 = rect diff xspan=(g3l - 0.265, g3r + 0.265) yspan=(ny0, ny0 + WN)     # VGND-n2-X (M1)
  # p row diffusions
  pd1 = rect diff xspan=(g1l - 0.265, g2r + 0.265) yspan=(py1 - WP2, py1)    # VPWR-A-n1-B-n2 (M0,M4)
  pd2 = rect diff xspan=(g3l - 0.265, g3r + 0.265) yspan=(py1 - WP, py1)     # X-n2-VPWR (M5)

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # gates cross both rows
  g1 = cross [nd1, pd1] poly w=L cx=g1x
  g2 = cross [nd1, pd1] poly w=L cx=g2x
  g3 = cross [nd2, pd2] poly w=L cx=g3x

  # n row contacts
  c1 = array licon in=nd1 left_of=g1              # VGND contact (M3.s)
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1             # n2 contact (M3.d / M2.s)
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd1 right_of=g2             # VGND contact (M2.d)
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4 = array licon in=nd2 left_of=g3              # VGND contact (M1.d)
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=nd2 right_of=g3             # X contact (M1.s)
  c5l = enclose c5 li net=X

  # p row contacts
  c6 = array licon in=pd1 left_of=g1              # VPWR contact (M0.s)
  c6l = enclose c6 li net=VPWR
  c6s = strap li from=c6l to=vpwr_li
  c7 = array licon in=pd1 right_of=g2             # n2 contact (M4.d)
  c7l = enclose c7 li net=n2
  c8 = array licon in=pd2 left_of=g3              # X contact (M5.s)
  c8l = enclose c8 li net=X
  c9 = array licon in=pd2 right_of=g3             # VPWR contact (M5.d)
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li

  # gate contacts: only n-row items in cb max (lesson 1)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n2
  gn = enclose [gc1, gc2, gc3] npc

  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  # input ports
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  # internal net n2: drain li strips + gate contact li, all net=n2, then route
  route n2 layers=m1,m2

  # output X: n-side (c5l) and p-side (c8l) drains, route them together
  route X layers=m1,m2
  xm = contact mcon in=c5l
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp

end