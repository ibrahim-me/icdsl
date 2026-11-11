pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=6 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # stick plan (gate order A B C; (net) = series node, no contact; | = break)
  #   p: Y [A] VPWR | VPWR [B] Y | Y [C] VPWR |
  #   n: Y [A] (n2) [B] (n1) [C] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C

  # n-side: one continuous diffusion Y-A-n2-B-n1-C-VGND
  nd1 = rect diff xspan=(g1.left - 0.18, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose [nd1] nsdm

  # p-side: three separate islands (parallel devices, each Y-to-VPWR)
  pd1 = rect diff xspan=(g1.left - 0.265, g1.right + 0.265) yspan=(py1 - WP, py1)   # island A: Y-A-VPWR
  pd2 = rect diff xspan=(g2.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)   # island B: VPWR-B-Y
  pd3 = rect diff xspan=(g3.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)   # island C: Y-C-VPWR
  pim = enclose [pd1, pd2, pd3] psdm

  # n-side contacts
  c1 = array licon in=nd1 left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd1 right_of=g3
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li

  # p-side contacts: island A (gate A): left=Y, right=VPWR
  c3 = array licon in=pd1 left_of=g1
  c3l = enclose c3 li net=Y
  c4 = array licon in=pd1 right_of=g1
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  # p-side contacts: island B (gate B): left=VPWR, right=Y
  c5 = array licon in=pd2 left_of=g2
  c5l = enclose c5 li net=VPWR
  c5s = strap li from=c5l to=vpwr_li
  c6 = array licon in=pd2 right_of=g2
  c6l = enclose c6 li net=Y
  # p-side contacts: island C (gate C): left=Y, right=VPWR
  c7 = array licon in=pd3 left_of=g3
  c7l = enclose c7 li net=Y
  c8 = array licon in=pd3 right_of=g3
  c8l = enclose c8 li net=VPWR
  c8s = strap li from=c8l to=vpwr_li

  # output Y: n-side left contact (c1l) and p-side island B right contact (c6l)
  y = strap li from=c1l to=c6l net=Y

  # gate contacts: cb from n-row items only (lesson 1)
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

  well y=((max(nd1.top, pd1.top, pd2.top, pd3.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom) - 0.18) / 2)

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
  ym = contact mcon in=y
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
