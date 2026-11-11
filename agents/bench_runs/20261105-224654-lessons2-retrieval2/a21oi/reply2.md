The `strap` failed because the n-row Y drain (right of g2) and p-row Y drain (right of g3) are at different x positions, so they can't be joined by a vertical strap. Per the verified pattern, I label both `net=Y` and use `route Y` instead, with `port Y out` (no `on=`).

```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=7 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  # stick plan (gate order A2 A1 B1; (net) = series node, no contact)
  #   p: n2 [A2] VPWR [A1] n2 [B1] Y
  #   n: VGND [A2] (n1) [A1] Y [B1] VGND
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A2
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A1
  g3 = rect poly w=L left=(g2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B1
  nd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(g1.left - 0.265, g3.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1] nsdm
  pim = enclose [pd1] psdm
  # n row: VGND | A2 | (n1) | A1 | Y | B1 | VGND
  cn0 = array licon in=nd1 left_of=g1
  cn0l = enclose cn0 li net=VGND
  cn0s = strap li from=cn0l to=vgnd_li
  cn2 = array licon in=nd1 right_of=g2
  cn2l = enclose cn2 li net=Y
  cn3 = array licon in=nd1 right_of=g3
  cn3l = enclose cn3 li net=VGND
  cn3s = strap li from=cn3l to=vgnd_li
  # p row: n2 | A2 | VPWR | A1 | n2 | B1 | Y  (n2 split across two columns -> route)
  cp0 = array licon in=pd1 left_of=g1
  cp0l = enclose cp0 li net=n2
  cp1 = array licon in=pd1 right_of=g1
  cp1l = enclose cp1 li net=VPWR
  cp1s = strap li from=cp1l to=vpwr_li
  cp2 = array licon in=pd1 right_of=g2
  cp2l = enclose cp2 li net=n2
  cp3 = array licon in=pd1 right_of=g3
  cp3l = enclose cp3 li net=Y
  cb = max(nd1.top + 0.19, cn0l.top + 0.25, cn2l.top + 0.25, cn3l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A2
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A1
  gc3 = contact licon cx=g3.cx bottom=cb
  gp3 = enclose gc3 poly by=minx
  gl3 = enclose gc3 li net=B1
  gn = enclose [gc1, gc2, gc3] npc
  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)
  # inputs
  a1m = contact mcon in=gl2
  a1p = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1p
  a2m = contact mcon in=gl1
  a2p = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2p
  b1m = contact mcon in=gl3
  b1p = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1p
  # output: n and p drains do not line up -> route Y, pin on routed met1
  port Y out
  route n2 layers=m1,m2 prefer=m2
  route Y layers=m1,m2 prefer=m2
end
```