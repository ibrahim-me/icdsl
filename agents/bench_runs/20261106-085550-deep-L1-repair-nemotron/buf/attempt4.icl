pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=5 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  ny0 = ptap.top + 0.27                 # bottom of the n row (diff-to-tap spacing)
  py1 = ntap.bottom - 0.27              # top of the p row

  gap = max(0.28, 0.54 - L)
  span = 0.53 + 2*L + gap
  x0 = cell.cx - span/2

  g1l = x0 + 0.265                      # gate n1 left edge
  g1r = g1l + L
  g2l = g1r + gap
  g2r = g2l + L

  # single continuous diffusions per row (gates electrically separate the nets)
  nd = rect diff xspan=(x0, x0 + span) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(x0, x0 + span) yspan=(py1 - WP, py1)

  nim = enclose nd nsdm
  pim = enclose pd psdm

  g1 = cross [nd, pd] poly w=L left=g1l ext=(0.13, 0.13)   # gate n1
  g2 = cross [nd, pd] poly w=L left=g2l ext=(0.13, 0.13)   # gate A

  # n-row contacts: X (left of g1), VGND (between g1 and g2), n1 (right of g2)
  cn_x  = array licon in=nd left_of=g1
  cn_xl = enclose cn_x li net=X
  cn_vgnd = array licon in=nd between=[g1, g2]
  cn_vgndl = enclose cn_vgnd li net=VGND
  cn_n1 = array licon in=nd right_of=g2
  cn_n1l = enclose cn_n1 li net=n1

  # p-row contacts: X (left of g1), VPWR (between g1 and g2), n1 (right of g2)
  cp_x  = array licon in=pd left_of=g1
  cp_xl = enclose cp_x li net=X
  cp_vpwr = array licon in=pd between=[g1, g2]
  cp_vpwrl = enclose cp_vpwr li net=VPWR
  cp_n1 = array licon in=pd right_of=g2
  cp_n1l = enclose cp_n1 li net=n1

  # supply straps
  s_vgnd = strap li from=cn_vgndl to=vgnd_li
  s_vpwr = strap li from=cp_vpwrl to=vpwr_li

  # gate contacts: only n-row items in cb (lesson 1)
  cb = max(nd.top + 0.19, cn_xl.top + 0.25, cn_vgndl.top + 0.25, cn_n1l.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=n1
  gc2 = contact licon cx=g2.cx bottom=cb
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A
  gn = enclose [gc1, gc2] npc

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # port A: mcon on gate A contact li
  am = contact mcon in=gl2
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap

  # port X: join n-side and p-side X contacts, pin on routed met1
  sx = strap li from=cn_xl to=cp_xl net=X
  xm = contact mcon in=sx
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp

  # internal net n1: join n-side and p-side n1 contacts + gate contact via route
  route n1 layers=m1,m2 prefer=m2
end
