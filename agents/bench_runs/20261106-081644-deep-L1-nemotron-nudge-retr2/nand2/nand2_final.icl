pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # room for a contact column between gates
  span = 0.53 + 2*L + gap
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B

  # n row: Y | A | n1 | B | VGND
  nd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  # p row: VPWR | A | Y | B | VPWR
  pd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm

  # n row contacts
  cn1 = array licon in=nd left_of=g1          # Y contact (n-row left end)
  cn1l = enclose cn1 li net=Y
  cn2 = array licon in=nd right_of=g2         # VGND contact (n-row right end)
  cn2l = enclose cn2 li net=VGND
  cn2s = strap li from=cn2l to=vgnd_li

  # p row contacts
  cp1 = array licon in=pd left_of=g1          # VPWR contact (p-row left end)
  cp1l = enclose cp1 li net=VPWR
  cp1s = strap li from=cp1l to=vpwr_li
  cp2 = array licon in=pd between=[g1, g2]    # Y contact (p-row middle)
  cp2l = enclose cp2 li net=Y
  cp3 = array licon in=pd right_of=g2         # VPWR contact (p-row right end)
  cp3l = enclose cp3 li net=VPWR
  cp3s = strap li from=cp3l to=vpwr_li

  # gate contacts (lesson 1: cb from n-row items only)
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cn2l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=A
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=B
  gn = enclose [gc1, gc2] npc

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # ports on met1 over gate-contact li
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp

  # Y: n-row left and p-row middle don't line up -> route
  port Y out
  route Y layers=m1,m2
end
