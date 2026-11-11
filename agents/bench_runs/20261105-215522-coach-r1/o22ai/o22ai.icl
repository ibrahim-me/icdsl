pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=10 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  gap1 = max(0.28, 0.54 - L)
  gap2 = max(0.21, 0.54 - L)

  nd  = rect diff w=(2*0.265 + 4*L + 7*gap1 + gap2) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(2*0.265 + 4*L + 7*gap1 + gap2) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # shared gates, order A2 B2 B1 A1 (same in both rows)
  gA2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gB2 = cross [nd, pd] poly w=L left=(gA2.right + gap1)
  gB1 = cross [nd, pd] poly w=L left=(gB2.right + gap1)
  gA1 = cross [nd, pd] poly w=L left=(gB1.right + gap2)

  # p row: n1 | A2 | Y | B2 | n2 | B1 | VPWR | A1 | n1
  pp1 = array licon in=pd left_of=gA2
  pY  = array licon in=pd right_of=gA2 left_of=gB2
  pn2 = array licon in=pd right_of=gB2 left_of=gB1
  pp4 = array licon in=pd right_of=gB1 left_of=gA1
  pp9 = array licon in=pd right_of=gA1

  ppl = enclose pp1 li net=n1
  pYl = enclose pY  li net=Y
  pn2l = enclose pn2 li
  ppl4 = enclose pp4 li net=VPWR
  ppl9 = enclose pp9 li net=n1

  s1 = strap li from=ppl to=vpwr_li
  s2 = strap li from=ppl4 to=vpwr_li
  s3 = strap li from=ppl9 to=ppl net=n1

  # n row: VGND | A2 | n3 | B2 | Y | B1 | n3 | A1 | VGND
  np0 = array licon in=nd left_of=gA2
  nn1 = array licon in=nd right_of=gA2 left_of=gB2
  np2 = array licon in=nd right_of=gB2 left_of=gB1
  nn3 = array licon in=nd right_of=gB1 left_of=gA1
  np4 = array licon in=nd right_of=gA1

  npl0 = enclose np0 li
  nn1l = enclose nn1 li net=n3
  npl2 = enclose np2 li net=Y
  nn3l = enclose nn3 li net=n3
  npl4 = enclose np4 li

  s4 = strap li from=npl0 to=vgnd_li
  s5 = strap li from=npl4 to=vgnd_li
  s6 = strap li from=nn1l to=nn3l net=n3

  route n1 layers=m1,m2
  route n3 layers=m1,m2
  route Y layers=m1,m2

  # gate contacts (bottom from n-row items only)
  cb = max(nd.top + 0.19, nn1l.top + 0.25, npl2.top + 0.25, nn3l.top + 0.25)

  gcA2 = contact licon cx=gA2.cx bottom=cb
  gcB2 = contact licon cx=gB2.cx bottom=cb
  gcB1 = contact licon cx=gB1.cx bottom=cb
  gcA1 = contact licon cx=gA1.cx bottom=cb

  gpoly = enclose [gcA2, gcB2, gcB1, gcA1] poly by=minx
  gnpc  = enclose [gcA2, gcB2, gcB1, gcA1] npc

  a2 = enclose gcA2 li net=A2
  b2 = enclose gcB2 li net=B2
  b1 = enclose gcB1 li net=B1
  a1 = enclose gcA1 li net=A1

  route A1 layers=m1,m2
  route A2 layers=m1,m2
  route B1 layers=m1,m2
  route B2 layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  ym  = contact mcon in=npl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp
end
