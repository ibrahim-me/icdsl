pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=5 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  # stick plan (gate order A B C; (net) = series node, no contact)
  #   p: VPWR [A] (n1) [B] (n2) [C] Y |
  #   n: VGND [A] Y [B] VGND [C] Y |
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # gate pitch: contact column + pad clearance
  span = 0.53 + 3*L + gap + gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  g3 = rect poly w=L left=(g2.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate C
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm

  # n row: VGND | A | Y | B | VGND | C | Y
  cn0 = array licon in=nd1 left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn1 = array licon in=nd1 between=[g1, g2]
  cn1l = enclose cn1 li net=Y
  cn2 = array licon in=nd1 between=[g2, g3]
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li
  cn3 = array licon in=nd1 right_of=g3
  cn3l = enclose cn3 li net=Y

  # p row: VPWR | A | n1 | B | n2 | C | Y  (n1, n2 are series nodes, no contact)
  cp0 = array licon in=pd1 left_of=g1
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp3 = array licon in=pd1 right_of=g3
  cp3l = enclose cp3 li net=Y

  cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn1l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25)
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

  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  cm = contact mcon in=gl3
  cp = enclose cm m1 by=0.06 net=C
  port C in on=cp

  route Y layers=m1,m2 prefer=m2
  port Y out
end
