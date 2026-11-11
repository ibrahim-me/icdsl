pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=8 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gap = max(0.80, 0.54 - L)
  span = 0.53 + 3*L + 2*gap
  x0 = cell.cx - span/2
  gA = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB = rect poly w=L left=(gA.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  gC = rect poly w=L left=(gB.right + gap) yspan=(ny0 - 0.13, py1 + 0.13)
  nd = rect diff xspan=(gA.left - 0.265, gC.right + 0.265) yspan=(ny0, ny0 + WN)
  nim = enclose nd nsdm
  cnY = array licon in=nd left_of=gA
  cnYl = enclose cnY li net=Y
  cnG = array licon in=nd right_of=gC
  cnGl = enclose cnG li net=VGND
  cnGs = strap li from=cnGl to=vgnd_li
  pA = rect diff xspan=(gA.left - 0.265, gA.right + 0.265) yspan=(py1 - WP, py1)
  pB = rect diff xspan=(gB.left - 0.265, gB.right + 0.265) yspan=(py1 - WP, py1)
  pC = rect diff xspan=(gC.left - 0.265, gC.right + 0.265) yspan=(py1 - WP, py1)
  pim = enclose [pA, pB, pC] psdm
  cpAV = array licon in=pA left_of=gA
  cpAVl = enclose cpAV li net=VPWR
  cpAVs = strap li from=cpAVl to=vpwr_li
  cpAY = array licon in=pA right_of=gA
  cpAYl = enclose cpAY li net=Y
  cpBV = array licon in=pB left_of=gB
  cpBVl = enclose cpBV li net=VPWR
  cpBVs = strap li from=cpBVl to=vpwr_li
  cpBY = array licon in=pB right_of=gB
  cpByl = enclose cpBY li net=Y
  cpCV = array licon in=pC left_of=gC
  cpCVl = enclose cpCV li net=VPWR
  cpCVs = strap li from=cpCVl to=vpwr_li
  cpCY = array licon in=pC right_of=gC
  cpCyl = enclose cpCY li net=Y
  cb = max(nd.top + 0.19, cnYl.top + 0.25, cnGl.top + 0.25)
  gcA = contact licon cx=gA.cx bottom=cb
  gpA = enclose gcA poly by=minx
  gcB = contact licon cx=gB.cx bottom=cb
  gpB = enclose gcB poly by=minx
  gcC = contact licon cx=gC.cx bottom=cb
  gpC = enclose gcC poly by=minx
  gn = enclose [gcA, gcB, gcC] npc
  la = enclose gcA li net=A
  lb = enclose gcB li net=B
  lc = enclose gcC li net=C
  well y=((nd.top + 0.34 + pA.bottom - 0.18) / 2)
  route Y layers=m1,m2 prefer=m2
  am = contact mcon in=la
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=lb
  bp = enclose bm m1 by=0.06 net=B
  cm = contact mcon in=lc
  cp = enclose cm m1 by=0.06 net=C
  port A in on=ap
  port B in on=bp
  port C in on=cp
  port Y out
end
