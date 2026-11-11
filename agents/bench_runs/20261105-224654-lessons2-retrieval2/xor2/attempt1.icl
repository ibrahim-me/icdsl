pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=12 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  # gate order (each line crosses both rows): A B | n1 B A | n1
  # n islands: N1=[A,B] cols VGND-n1-VGND ; N2=[n1,B,A] cols VGND-X-n4-VGND
  # p islands: P1=[B,A] cols VPWR-n2-VPWR ; P2=[A,B] cols VPWR-n3-n1 ; P3=[n1] cols X-n2
  ny0 = ptap.top + 0.27
  py1 = ntap.bottom - 0.27
  span = 0.53 + 7*L + 4*max(0.28, 0.54 - L)
  x0 = cell.cx - span/2
  gA1 = rect poly w=L left=(x0 + 0.265) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  gB1 = rect poly w=L left=(gA1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  gn1 = rect poly w=L left=(gB1.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1 (island break)
  gB2 = rect poly w=L left=(gn1.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate B
  gA2 = rect poly w=L left=(gB2.right + max(0.28, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate A
  gn2 = rect poly w=L left=(gA2.right + max(0.80, 0.54 - L)) yspan=(ny0 - 0.13, py1 + 0.13)   # gate n1 (island break)

  nd1 = rect diff xspan=(gA1.left - 0.265, gB1.right + 0.265) yspan=(ny0, ny0 + WN)
  nd2 = rect diff xspan=(gn1.left - 0.265, gA2.right + 0.265) yspan=(ny0, ny0 + WN)
  pd1 = rect diff xspan=(gB1.left - 0.265, gA2.right + 0.265) yspan=(py1 - WP, py1)
  pd2 = rect diff xspan=(gn2.left - 0.265, gn2.right + 0.265) yspan=(py1 - WP, py1)
  nim = enclose [nd1, nd2] nsdm
  pim = enclose [pd1, pd2] psdm

  # n island N1: VGND [A] n1 [B] VGND  (M0, M1)
  c0  = array licon in=nd1 left_of=gA1
  c0l = enclose c0 li net=VGND
  c0s = strap li from=c0l to=vgnd_li
  c1  = array licon in=nd1 right_of=gA1
  c1l = enclose c1 li net=n1
  c2  = array licon in=nd1 right_of=gB1
  c2l = enclose c2 li net=VGND
  c2s = strap li from=c2l to=vgnd_li
  # n island N2: VGND [n1] X [B] n4 [A] VGND  (M2, M7, M9)
  c3  = array licon in=nd2 left_of=gn1
  c3l = enclose c3 li net=VGND
  c3s = strap li from=c3l to=vgnd_li
  c4  = array licon in=nd2 right_of=gn1
  c4l = enclose c4 li net=X
  c5  = array licon in=nd2 right_of=gB2
  c5l = enclose c5 li net=n4
  c6  = array licon in=nd2 right_of=gA2
  c6l = enclose c6 li net=VGND
  c6s = strap li from=c6l to=vgnd_li

  # p island P1: VPWR [B] n2 [A] VPWR  (M3, M4)
  c7  = array licon in=pd1 left_of=gB1
  c7l = enclose c7 li net=VPWR
  c7s = strap li from=c7l to=vpwr_li
  c8  = array licon in=pd1 right_of=gB1
  c8l = enclose c8 li net=n2
  c9  = array licon in=pd1 right_of=gA2
  c9l = enclose c9 li net=VPWR
  c9s = strap li from=c9l to=vpwr_li
  # p island P2: VPWR [A] n3 [B] n1  (M6, M5)
  c10 = array licon in=pd1 left_of=gA2
  c10l = enclose c10 li net=VPWR
  c10s = strap li from=c10l to=vpwr_li
  c11 = array licon in=pd1 right_of=gA2
  c11l = enclose c11 li net=n3
  c12 = array licon in=pd1 right_of=gB2
  c12l = enclose c12 li net=n1
  # p island P3: X [n1] n2  (M8)
  c13 = array licon in=pd2 left_of=gn2
  c13l = enclose c13 li net=X
  c14 = array licon in=pd2 right_of=gn2
  c14l = enclose c14 li net=n2

  cb = max(nd1.top + 0.19, c0l.top + 0.25, c1l.top + 0.25, c2l.top + 0.25,
              c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25)
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gpA1 = enclose gcA1 poly by=minx
  ga1  = enclose gcA1 li net=A
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gpB1 = enclose gcB1 poly by=minx
  gb1  = enclose gcB1 li net=B
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gpN1 = enclose gcn1 poly by=minx
  gn1l = enclose gcn1 li net=n1
  gcB2 = contact licon cx=gB2.cx bottom=cb
  gpB2 = enclose gcB2 poly by=minx
  gb2  = enclose gcB2 li net=B
  gcA2 = contact licon cx=gA2.cx bottom=cb
  gpA2 = enclose gcA2 poly by=minx
  ga2  = enclose gcA2 li net=A
  gcn2 = contact licon cx=gn2.cx bottom=cb
  gpN2 = enclose gcn2 poly by=minx
  gn2l = enclose gcn2 li net=n1
  gn   = enclose [gcA1, gcB1, gcn1, gcB2, gcA2, gcn2] npc

  well y=((max(nd1.top, nd2.top) + 0.34 + min(pd1.bottom, pd2.bottom) - 0.18) / 2)

  am = contact mcon in=ga1
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=gb1
  bp = enclose bm m1 by=0.06 net=B
  port A in on=ap
  port B in on=bp
  port X out
  route X layers=m1,m2 prefer=m2
  route n1 layers=m1,m2 prefer=m2
  route n2 layers=m1,m2 prefer=m2
  route n3 layers=m1,m2 prefer=m2
  route n4 layers=m1,m2 prefer=m2
end
