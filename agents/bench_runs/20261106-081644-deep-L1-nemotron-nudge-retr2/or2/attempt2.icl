pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=8 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  # stick plan (gate order A B n2; | = diffusion break)
  #   n: VGND | A | n2 | B | VGND | | X | n2 | VGND   (break between VGND and X)
  #   p: VPWR | A | n1 | B | n2 | | X | n2 | VPWR      (break between n2 and X)
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.80, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n2

  # n row: island 1 = VGND | A | n2 | B | VGND  (g1..g2), island 2 = X | n2 | VGND  (g3)
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  # p row: island 1 = VPWR | A | n1 | B | n2  (g1..g2), island 2 = X | n2 | VPWR  (g3)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP2, py1)

  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # n row island 1 contacts: VGND | A | n2 | B | VGND
  c1 = array licon in=nd1 left_of=g1           # VGND
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g2          # VGND
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li

  # n row island 2 contacts: X | n2 | VGND
  c3 = array licon in=nd2 left_of=g3           # X (output)
  c3l = enclose c3 li net=X
  c4 = array licon in=nd2 right_of=g3          # VGND
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li

  # p row island 1 contacts: VPWR | A | n1 | B | n2
  c5 = array licon in=pd1 left_of=g1           # VPWR
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd1 right_of=g2          # n2 (internal net, diffusion)
  c6l = enclose c6 li net=n2

  # p row island 2 contacts: X | n2 | VPWR
  c7 = array licon in=pd2 left_of=g3           # X (output)
  c7l = enclose c7 li net=X
  c8 = array licon in=pd2 right_of=g3          # VPWR
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li

  # gate contacts (in the gap between rows, below the li straps)
  cb = max(nd1.top + 0.19, nd2.top + 0.19, c1l.top + 0.25, c2l.top + 0.25,
           c3l.top + 0.25, c4l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25)
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

  # output: n-side X (c3l) and p-side X (c7l) may not line up; route X
  port X out
  route X layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
end
