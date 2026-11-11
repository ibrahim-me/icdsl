pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  # stick plan (gate order A B n1 B A; | = diffusion break)
  #   n: VGND [A] n1 [B] VGND | X [n1] VGND | X [B] n4 [A] VGND
  #   p: VPWR [A] n2 [B] VPWR | X [n1] n2 | n1 [B] n3 [A] VPWR
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 5*L + max(0.28, 0.54 - L) + max(0.80, 0.54 - L) + max(0.80, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g4 = rect poly w=L left=(g3.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g5 = rect poly w=L left=(g4.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  nd3 = rect diff xspan=(g4.left - 0.265, g5.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  pd3 = rect diff xspan=(g4.left - 0.265, g5.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm
  # n row island 1: VGND [A] n1 [B] VGND
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=g1
  c2l = enclose c2 li net=n1
  c3 = array licon in=nd1 right_of=g2
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  # n row island 2: X [n1] VGND
  c4 = array licon in=nd2 left_of=g3
  c4l = enclose c4 li net=X
  c5 = array licon in=nd2 right_of=g3
  c5l = enclose c5 li net=VGND
  c5s = strap li from=c5l to=vgnd_li
  # n row island 3: X [B] n4 [A] VGND
  c6 = array licon in=nd3 left_of=g4
  c6l = enclose c6 li net=X
  c7 = array licon in=nd3 right_of=g4
  c7l = enclose c7 li net=n4
  c8 = array licon in=nd3 right_of=g5
  c8l = enclose c8 li net=VGND
  c8s = strap li from=c8l to=vgnd_li
  # p row island 1: VPWR [A] n2 [B] VPWR
  c9 = array licon in=pd1 left_of=g1
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li
  c10 = array licon in=pd1 right_of=g1
  c10l = enclose c10 li net=n2
  c11 = array licon in=pd1 right_of=g2
  c11l = enclose c11 li net=VPWR
  c11s = strap li from=c11l to=vpwr_li
  # p row island 2: X [n1] n2
  c12 = array licon in=pd2 left_of=g3
  c12l = enclose c12 li net=X
  c13 = array licon in=pd2 right_of=g3
  c13l = enclose c13 li net=n2
  # p row island 3: n1 [B] n3 [A] VPWR
  c14 = array licon in=pd3 left_of=g4
  c14l = enclose c14 li net=n1
  c15 = array licon in=pd3 right_of=g4
  c15l = enclose c15 li net=n3
  c16 = array licon in=pd3 right_of=g5
  c16l = enclose c16 li net=VPWR
  c16s = strap li from=c16l to=vpwr_li
  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25, c7l.top + 0.25, c8l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=n1
  gc4 = contact licon cx=g4.cx bottom=cb
  gp4 = enclose gc4 poly by=minx
  gl4 = enclose gc4 li net=B
  gc5 = contact licon cx=g5.cx bottom=cb
  gp5 = enclose gc5 poly by=minx
  gl5 = enclose gc5 li net=A
  gn = enclose [gc1, gc2, gc3, gc4, gc5] npc
  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  port X out
  route A layers=m1,m2 prefer=m2
  route B layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route X layers=m1,m2 prefer=m2
end
