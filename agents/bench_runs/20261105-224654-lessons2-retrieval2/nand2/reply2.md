```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=5 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # stick plan (gate order A B; (net) = series node, no contact; | = break)
  #   p: VPWR [A] Y [B] VPWR |
  #   n: Y [A] n1(nc) [B] VGND |
  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 2*L + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  nd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # n row: Y | A | n1(nc) | B | VGND
  cn1 = array licon in=nd1 left_of=g1
  cn1l = enclose cn1 li net=Y
  cp1 = array licon in=nd1 right_of=g2
  cp1l = enclose cp1 li net=VGND
  cp1s = strap li from=cp1l to=vgnd_li
  # p row: VPWR | A | Y | B | VPWR
  pp1 = array licon in=pd1 left_of=g1
  pp1l = enclose pp1 li net=VPWR
  pp1s = strap li from=pp1l to=vpwr_li
  pyc = array licon in=pd1 right_of=g1
  pycl = enclose pyc li net=Y
  pp2 = array licon in=pd1 right_of=g2
  pp2l = enclose pp2 li net=VPWR
  pp2s = strap li from=pp2l to=vpwr_li
  cb = max(nd1.top + 0.19, cn1l.top + 0.25, cp1l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gn = enclose [gc1, gc2] npc
  well y=((max(nd1.top) + 0.34 + min(pd1.bottom) - 0.18) / 2)
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  route Y layers=m1,m2 prefer=m2
  port Y out
end
```