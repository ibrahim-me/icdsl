pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  # stick plan (gate order n1, A; no diffusion breaks)
  #   n: X [n1] VGND [A] n1
  #   p: X [n1] VPWR [A] n1
  ny0 = ptap.top + 0.27                 # bottom of the n row
  py1 = ntap.bottom - 0.27              # top of the p row
  span = 0.53 + 2*L + max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  g1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1
  g2 = rect poly w=L left=(g1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  nd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(g1.left - 0.265, g2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm

  # diffusion contact columns
  cn  = array licon in=nd left_of=g1            # n row left end: X
  cnl = enclose cn li net=X
  cp  = array licon in=pd left_of=g1            # p row left end: X
  cpl = enclose cp li net=X
  xst = strap li from=cnl to=cpl net=X          # output X (both rows line up)

  cmn = array licon in=nd between=[g1, g2]      # n row middle: VGND
  cmnl = enclose cmn li net=VGND
  cmns = strap li from=cmnl to=vgnd_li
  cmp = array licon in=pd between=[g1, g2]      # p row middle: VPWR
  cmpl = enclose cmp li net=VPWR
  cmps = strap li from=cmpl to=vpwr_li

  ce  = array licon in=nd right_of=g2           # n row right end: n1
  cel = enclose ce li net=n1
  cep = array licon in=pd right_of=g2           # p row right end: n1
  cepl = enclose cep li net=n1
  n1s = strap li from=cel to=cepl net=n1        # n1 drains line up

  # gate contacts (n-row items only for cb)
  cb = max(nd.top + 0.19, cnl.top + 0.25, cel.top + 0.25)
  gc1 = contact licon cx=g1.cx bottom=cb        # gate n1 contact
  gp1 = enclose gc1 poly by=minx
  gl1 = enclose gc1 li net=n1
  gc2 = contact licon cx=g2.cx bottom=cb        # gate A contact
  gp2 = enclose gc2 poly by=minx
  gl2 = enclose gc2 li net=A
  gn = enclose [gc1, gc2] npc

  # internal net n1: right drain column -> left gate contact (m2 over the cell)
  n1r = contact mcon in=cel
  n1p = enclose n1r m1 by=0.06 net=n1
  n1g = contact mcon in=gl1
  n1g_p = enclose n1g m1 by=0.06 net=n1
  route n1 layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=gl2
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  xm = contact mcon in=xst
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
end
