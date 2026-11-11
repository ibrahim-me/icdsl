```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=8 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  span = 0.53 + 3*L + max(0.28, 0.54 - L) + max(0.80, 0.54 - L)
  x0 = cell.cx - span/2
  gA = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)
  gB = rect poly w=L left=(gA.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)
  gN = rect poly w=L left=(gB.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)

  nd1 = rect diff xspan=(gA.left - 0.265, gA.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd2 = rect diff xspan=(gB.left - 0.265, gB.right + 0.265) yspan=(ny0, ny0 + WN2)
  nd3 = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(gA.left - 0.265, gA.right + 0.265) yspan=(py1 - WP2, py1)
  pd2 = rect diff xspan=(gB.left - 0.265, gB.right + 0.265) yspan=(py1 - WP2, py1)
  pd3 = rect diff xspan=(gN.left - 0.265, gN.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2, nd3] nsdm
  pim = enclose [pd1, pd2, pd3] psdm

  c1 = array licon in=nd1 left_of=gA
  c1l = enclose c1 li net=VGND
  c1s = strap li from=c1l to=vgnd_li
  c2 = array licon in=nd1 right_of=gA
  c2l = enclose c2 li net=n2
  c3 = array licon in=nd2 left_of=gB
  c3l = enclose c3 li net=n2
  c4 = array licon in=nd2 right_of=gB
  c4l = enclose c4 li net=VGND
  c4s = strap li from=c4l to=vgnd_li
  c5 = array licon in=nd3 left_of=gN
  c5l = enclose c5 li net=X
  c6 = array licon in=nd3 right_of=gN
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li

  c7 = array licon in=pd1 left_of=gA
  c7l = enclose c7 li net=VPWR
  c7s = strap li from=c7l to=vpwr_li
  c8 = array licon in=pd1 right_of=gA
  c8l = enclose c8 li net=n1
  c9 = array licon in=pd2 left_of=gB
  c9l = enclose c9 li net=n1
  c10 = array licon in=pd2 right_of=gB
  c10l = enclose c10 li net=n2
  c11 = array licon in=pd3 left_of=gN
  c11l = enclose c11 li net=X
  c12 = array licon in=pd3 right_of=gN
  c12l = enclose c12 li net=VPWR
  c12s = strap li from=c12l to=vpwr_li

  cb = max(nd1.top + 0.19, nd2.top + 0.19, nd3.top + 0.19, c2l.top + 0.25, c3l.top + 0.25, c10l.top + 0.25, c11l.top + 0.25)
  gcA = contact licon cx=gA.cx bottom=cb
  gpA = enclose gcA poly by=minx
  glA = enclose gcA li net=A
  gcB = contact licon cx=gB.cx bottom=cb
  gpB = enclose gcB poly by=minx
  glB = enclose gcB li net=B
  gcN = contact licon cx=gN.cx bottom=cb
  gpN = enclose gcN poly by=minx
  glN = enclose gcN li net=n2
  gn = enclose [gcA, gcB, gcN] npc

  well y=((max(nd1.top, nd2.top, nd3.top) + 0.34 + min(pd1.bottom, pd2.bottom, pd3.bottom) - 0.18) / 2)

  am = contact mcon in=glA
  ap = enclose am m1 by=0.06 net=A
  port A in on=ap
  bm = contact mcon in=glB
  bp = enclose bm m1 by=0.06 net=B
  port B in on=bp
  route X layers=m1,m2 prefer=m2
  port X out
  route n2 layers=m1,m2 prefer=m2
end
```