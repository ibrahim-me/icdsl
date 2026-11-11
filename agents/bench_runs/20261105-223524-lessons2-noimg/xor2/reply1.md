```icl
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

  # ---------- n-diffusion row (5 devices, one chain) ----------
  nd  = rect diff w=(5*L + 6*0.265) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm

  gA0 = cross [nd] poly w=L left=(nd.left + 0.265)
  gB1 = cross [nd] poly w=L left=(gA0.right + 0.28)
  gn1 = cross [nd] poly w=L left=(gB1.right + 0.21)
  gB7 = cross [nd] poly w=L left=(gn1.right + 0.28)
  gA9 = cross [nd] poly w=L left=(gB7.right + 0.21)

  cV0 = array licon in=nd left_of=gA0
  cn1 = array licon in=nd between=[gA0, gB1]
  cV2 = array licon in=nd between=[gB1, gn1]
  cX3 = array licon in=nd between=[gn1, gB7] net=X
  cn4 = array licon in=nd between=[gB7, gA9]
  cV5 = array licon in=nd right_of=gA9

  cV0l = enclose cV0 li
  cn1l = enclose cn1 li net=n1
  cV2l = enclose cV2 li
  cX3l = enclose cX3 li net=X
  cn4l = enclose cn4 li net=n4
  cV5l = enclose cV5 li

  stV0 = strap li from=cV0l to=vgnd_li
  stV2 = strap li from=cV2l to=vgnd_li
  stV5 = strap li from=cV5l to=vgnd_li

  # ---------- p-diffusion row (two islands) ----------
  dwp = 3*L + 4*0.265
  pd1 = rect diff w=dwp h=WP cx=(cell.cx - 0.6) below=ntap
  pd2 = rect diff w=dwp h=WP cx=(cell.cx + 0.6) below=ntap
  pim1 = enclose pd1 psdm
  pim2 = enclose pd2 psdm

  # island 1: M4(A) - M3(B) - M8(n1)
  gA4 = cross [pd1] poly w=L left=(pd1.left + 0.265)
  gB3 = cross [pd1] poly w=L left=(gA4.right + 0.28)
  gn8 = cross [pd1] poly w=L left=(gB3.right + 0.28)

  cN2a = array licon in=pd1 left_of=gA4
  cVP1 = array licon in=pd1 between=[gA4, gB3]
  cN2b = array licon in=pd1 between=[gB3, gn8] net=n2
  cX8  = array licon in=pd1 right_of=gn8 net=X

  cN2al = enclose cN2a li net=n2
  cVP1l = enclose cVP1 li
  cN2bl = enclose cN2b li net=n2
  cX8l  = enclose cX8 li net=X

  stVP1 = strap li from=cVP1l to=vpwr_li

  # island 2: M6(A) - M5(B)
  gA6 = cross [pd2] poly w=L left=(pd2.left + 0.265)
  gB5 = cross [pd2] poly w=L left=(gA6.right + 0.28)

  cVP2 = array licon in=pd2 left_of=gA6
  cN3  = array licon in=pd2 between=[gA6, gB5] net=n3
  cN1b = array licon in=pd2 right_of=gB5 net=n1

  cVP2l = enclose cVP2 li
  cN3l  = enclose cN3 li net=n3
  cN1bl = enclose cN1b li net=n1

  stVP2 = strap li from=cVP2l to=vpwr_li

  # ---------- gate contacts (n-row items only for cb) ----------
  cb = max(nd.top + 0.19, cn1l.top + 0.25, cX3l.top + 0.25)

  gcA0 = contact licon cx=gA0.cx bottom=cb
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gcn1 = contact licon cx=gn1.cx bottom=cb
  gcB7 = contact licon cx=gB7.cx bottom=cb
  gcA9 = contact licon cx=gA9.cx bottom=cb

  gpA0 = enclose gcA0 poly by=minx
  gpB1 = enclose gcB1 poly by=minx
  gpN1 = enclose gcn1 poly by=minx
  gpB7 = enclose gcB7 poly by=minx
  gpA9 = enclose gcA9 poly by=minx

  gnall = enclose [gcA0, gcB1, gcn1, gcB7, gcA9] npc

  a0 = enclose gcA0 li net=A
  b1 = enclose gcB1 li net=B
  n1g = enclose gcn1 li net=n1
  b7 = enclose gcB7 li net=B
  a9 = enclose gcA9 li net=A

  # p-side gate contacts
  cbp = max(pd1.top + 0.19, cN2al.top + 0.25, cX8l.top + 0.25,
            pd2.top + 0.19, cN3l.top + 0.25, cN1bl.top + 0.25)

  gcA4 = contact licon cx=gA4.cx bottom=cbp
  gcB3 = contact licon cx=gB3.cx bottom=cbp
  gcN8 = contact licon cx=gn8.cx bottom=cbp
  gcA6 = contact licon cx=gA6.cx bottom=cbp
  gcB5 = contact licon cx=gB5.cx bottom=cbp

  gpA4 = enclose gcA4 poly by=minx
  gpB3 = enclose gcB3 poly by=minx
  gpN8 = enclose gcN8 poly by=minx
  gpA6 = enclose gcA6 poly by=minx
  gpB5 = enclose gcB5 poly by=minx

  gnpall = enclose [gcA4, gcB3, gcN8, gcA6, gcB5] npc

  a4 = enclose gcA4 li net=A
  b3 = enclose gcB3 li net=B
  n8 = enclose gcN8 li net=n1
  a6 = enclose gcA6 li net=A
  b5 = enclose gcB5 li net=B

  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  # ---------- metal1 pins and internal routing ----------
  am0 = contact mcon in=a0
  ap0 = enclose am0 m1 by=0.06 net=A
  am1 = contact mcon in=a4
  ap1 = enclose am1 m1 by=0.06 net=A
  route A layers=m1,m2

  bm0 = contact mcon in=b1
  bp0 = enclose bm0 m1 by=0.06 net=B
  bm1 = contact mcon in=b3
  bp1 = enclose bm1 m1 by=0.06 net=B
  route B layers=m1,m2

  nm0 = contact mcon in=n1g
  np0 = enclose nm0 m1 by=0.06 net=n1
  nm1 = contact mcon in=n8
  np1 = enclose nm1 m1 by=0.06 net=n1
  route n1 layers=m1,m2

  n3m = contact mcon in=cN3l
  n3p = enclose n3m m1 by=0.06 net=n3

  n4m = contact mcon in=cn4l
  n4p = enclose n4m m1 by=0.06 net=n4

  n2m = contact mcon in=cN2bl
  n2p = enclose n2m m1 by=0.06 net=n2

  xm  = contact mcon in=cX3l cy=(cX3l.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X
  xm2 = contact mcon in=cX8l cy=(cX8l.top - 0.3)
  xp2 = enclose xm2 m1 by=0.06 net=X
  route X layers=m1,m2

  port A in  on=ap0
  port B in  on=bp0
  port X out on=xp
end
```