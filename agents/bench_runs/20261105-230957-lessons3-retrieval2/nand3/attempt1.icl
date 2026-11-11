pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=6 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # stick plan (gate order A B C; (net) = series node, no contact)
  #   n: Y [A] (n2) [B] (n1) [C] VGND |
  #   p: VPWR [A] Y [B] VPWR [C] Y |
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.21, 0.54 - L)             # series node: 0.21, gate pitch: 0.54
  span = 0.53 + 3*L + 2*gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C

  nd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm

  # n row: Y | n2 | n1 | VGND
  c1 = array licon in=nd left_of=g1
  c1l = enclose c1 li net=Y
  c2 = array licon in=nd right_of=g3
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li

  # p row: VPWR | Y | VPWR | Y
  c3 = array licon in=pd left_of=g1
  c3l = enclose c3 li net=VPWR
  c3s = strap li from=c3l to=vpwr_li
  c4 = array licon in=pd right_of=g2
  c4l = enclose c4 li net=VPWR
  c4s = strap li from=c4l to=vpwr_li
  c5 = array licon in=pd right_of=g1
  c5l = enclose c5 li net=Y
  c6 = array licon in=pd right_of=g3
  c6l = enclose c6 li net=Y

  # gate contacts (n-row items only in cb)
  cb = max(nd.top + 0.19, c1l.top + 0.25)
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

  well y=((max(nd.top) + 0.34 + min(pd.bottom) - 0.18) / 2)

  # output: join n-row Y and p-row Y columns, route to met1 pin
  yst = strap li from=c1l to=c5l net=Y
  ym = contact mcon in=c5l
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp

  # inputs
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp
end
