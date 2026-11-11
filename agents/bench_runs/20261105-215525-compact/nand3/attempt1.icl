pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=4 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.21, 0.54 - L)          # series node: no contact column
  x0 = cell.cx - (0.53 + 3*L + 2*gap)/2
  gA = cross [nd, pd] poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB = cross [nd, pd] poly w=L left=(gA.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  gC = cross [nd, pd] poly w=L left=(gB.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  nd = rect diff xspan=(gA.left - 0.265, gC.right + 0.265) yspan=(ny0, ny0 + WN)
  pd = rect diff xspan=(gA.left - 0.265, gC.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # n row: Y | A | n2 | B | n1 | C | VGND  (n1,n2 shared, no contact)
  cn = array licon in=nd left_of=gA
  cnl = enclose cn li net=Y
  cg = array licon in=nd right_of=gC
  cgl = enclose cg li net=VGND
  cgs = strap li from=cgl to=vgnd_li
  # p row: VPWR | B | Y | A | VPWR | C | Y
  cp0 = array licon in=pd left_of=gB
  cp0l = enclose cp0 li net=VPWR
  cp0s = strap li from=cp0l to=vpwr_li
  cp1 = array licon in=pd right_of=gB left_of=gA
  cp1l = enclose cp1 li net=Y
  cp2 = array licon in=pd right_of=gA left_of=gC
  cp2l = enclose cp2 li net=VPWR
  cp2s = strap li from=cp2l to=vpwr_li
  cp3 = array licon in=pd right_of=gC
  cp3l = enclose cp3 li net=Y
  cb = max(nd.top + 0.19, cnl.top + 0.25)
  gcA = contact licon cx=gA.cx bottom=cb
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A
  gcB = contact licon cx=gB.cx bottom=cb
  gpB = enclose gcB poly by=minx
  glB = enclose gcB li net=B
  gcC = contact licon cx=gC.cx bottom=cb
  gpC = enclose gcC poly by=minx
  glC = enclose gcC li net=C
  gn = enclose [gcA, gcB, gcC] npc
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # internal series nets n1 (M1/M2 shared) and n2 (M3/M1 shared)
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  # output Y: n-row left end + p-row middle/right ends
  route Y layers=m1,m2
  am = contact mcon in=glA
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=glB
  bp = enclose bm m1 by=0.06 net=B
  cm = contact mcon in=glC
  cp = enclose cm m1 by=0.06 net=C
  ym = contact mcon in=cnl
  yp = enclose ym m1 by=0.06 net=Y
  port A in on=ap
  port B in on=bp
  port C in on=cp
  port Y out on=yp
end
