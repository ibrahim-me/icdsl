pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  gpitch = max(0.54, L + 0.28)
  x0 = cell.cx - (0.53 + 3*L + 2*gpitch)/2
  gA = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB = rect poly w=L left=(gA.right + gpitch) yspan=(ny0 - 0.13, py1 + 0.13)
  gN = rect poly w=L left=(gB.right + gpitch) yspan=(ny0 - 0.13, py1 + 0.13)

  ndA = rect diff xspan=(gA.left - 0.265, gB.right + 0.265) yspan=(ny0, ny0 + WN2)
  ndN = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(ny0, ny0 + WN)
  pdA = rect diff xspan=(gA.left - 0.265, gB.right + 0.265) yspan=(py1 - WP2, py1)
  pdN = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [ndA, ndN] nsdm
  pim = enclose [pdA, pdN] psdm

  c1 = array licon in=ndA left_of=gA
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c4 = array licon in=ndA right_of=gB
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=ndN left_of=gN
  c5l = enclose c5 li net=X
  c6 = array licon in=ndN right_of=gN
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li

  c7 = array licon in=pdA left_of=gA
  c7l = enclose c7 li net=VPWR
  c7s = strap li from=c7l to=vpwr_li
  c10 = array licon in=pdA right_of=gB
  c10l = enclose c10 li net=n2
  c12 = array licon in=pdN right_of=gN
  c12l = enclose c12 li net=VPWR
  c12s = strap li from=c12l to=vpwr_li

  cb = max(ndA.top + 0.19, ndN.top + 0.19, c5l.top + 0.25, c6l.top + 0.25, c10l.top + 0.25)
  gcA = contact licon cx=(gA.cx - 0.13) bottom=(cb - 0.08)
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A
  gcB = contact licon cx=(gB.cx + 0.13) bottom=(cb - 0.16)
  gpB = enclose gcB poly by=minx
  glB = enclose gcB li net=B
  gcN = contact licon cx=(gN.cx - 0.13) bottom=(cb - 0.24)
  gpN = enclose gcN poly by=minx
  glN = enclose gcN li net=n2
  gn = enclose [gcA, gcB, gcN] npc

  well y=((max(ndA.top, ndN.top) + 0.34 + min(pdA.bottom, pdN.bottom) - 0.18) / 2)

  am = contact mcon in=glA
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=glB
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  xm = contact mcon in=c5l
  xp = enclose xm m1 by=0.06 net=X
  port X out on=xp
  route n2 layers=m1,m2 prefer=m2
end
