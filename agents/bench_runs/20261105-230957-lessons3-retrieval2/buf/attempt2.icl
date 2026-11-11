pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  gap = max(0.28, 0.54 - L)             # gate-to-gate gap (contact column + contact pitch)
  span = 2*0.265 + 2*L + gap            # end contacts + 2 gates + gap between them
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g2 = rect poly w=L left=(g1.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  nd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # n row: X | g(n1) | VGND | g(A) | n1
  cn1 = array licon in=nd left_of=g1
  cn1l = enclose cn1 li net=X
  cvn = array licon in=nd between=[g1, g2]
  cvnl = enclose cvn li net=VGND
  cvns = strap li from=cvnl to=vgnd_li
  cnn = array licon in=nd right_of=g2
  cnnl = enclose cnn li net=n1
  # p row: X | g(n1) | VPWR | g(A) | n1
  cp1 = array licon in=pd left_of=g1
  cp1l = enclose cp1 li net=X
  cvp = array licon in=pd between=[g1, g2]
  cvpl = enclose cvp li net=VPWR
  cvps = strap li from=cvpl to=vpwr_li
  cpp = array licon in=pd right_of=g2
  cppl = enclose cpp li net=n1
  # gate contacts in the gap between the rows, on their own gates
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cvnl.top + 0.25, cnnl.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=n1
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A
  gn = enclose [gc1, gc2] npc
  well y=((max(nd.top) + 0.34 + min(pd.bottom) - 0.18) / 2)
  # internal net n1: join n-side and p-side drains (right column) on metal
  route n1 layers=m1,m2
  # output X: met1 pins at diffusion-row height on the left column (clear of gate-contact zone)
  xm = contact mcon in=cn1l cy=nd.cy
  xp = enclose xm m1 by=0.06 net=X
  xm2 = contact mcon in=cp1l cy=pd.cy
  xp2 = enclose xm2 m1 by=0.06 net=X
  route X layers=m1,m2
  am = contact mcon in=gl1
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=gl2
  bp = enclose bm m1 by=0.06 net=B
  xm3 = contact mcon in=cn1l cy=nd.cy
  xp3 = enclose xm3 m1 by=0.06 net=X
  port X out on=xp3
end
