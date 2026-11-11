```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell mux2i width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=S s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=S s=n2
  device M2 pmos w=WP l=L d=n2 g=A0 s=Y
  device M3 nmos w=WN l=L d=VGND g=S s=n3
  device M4 pmos w=WP l=L d=n4 g=n1 s=VPWR
  device M5 nmos w=WN l=L d=n5 g=n1 s=VGND
  device M6 nmos w=WN l=L d=n1 g=S s=VGND
  device M7 pmos w=WP l=L d=Y g=A1 s=n4
  device M8 nmos w=WN l=L d=Y g=A1 s=n3
  device M9 nmos w=WN l=L d=n5 g=A0 s=Y

  nd  = rect diff w=4.0 h=WN cx=cell.cx above=ptap
  pd  = rect diff w=4.0 h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # shared gate order (works for both rows): S | n1 | A0 | A1 | S ; pitch 0.54 um
  gS1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gN1 = cross [nd, pd] poly w=L left=(gS1.right + max(0.28, 0.54 - L))
  gA0 = cross [nd, pd] poly w=L left=(gN1.right + max(0.28, 0.54 - L))
  gA1 = cross [nd, pd] poly w=L left=(gA0.right + max(0.28, 0.54 - L))
  gS2 = cross [nd, pd] poly w=L left=(gA1.right + max(0.28, 0.54 - L))

  # n-row slots: n1 | VGND | n5 | Y | n3 | VGND
  c0n = array licon in=nd left_of=gS1
  c1n = array licon in=nd between=[gS1, gN1]
  c2n = array licon in=nd between=[gN1, gA0] net=n5
  c3n = array licon in=nd between=[gA0, gA1] net=Y
  c4n = array licon in=nd between=[gA1, gS2] net=n3
  c5n = array licon in=nd right_of=gS2
  c0nl = enclose c0n li net=n1
  c1nl = enclose c1n li net=VGND
  c2nl = enclose c2n li net=n5
  c3nl = enclose c3n li net=Y
  c4nl = enclose c4n li net=n3
  c5nl = enclose c5n li net=VGND
  gndn = strap li from=c1nl to=vgnd_li
  gndn2 = strap li from=c5nl to=vgnd_li

  # p-row slots: VPWR | VPWR | n4 | Y | n2 | VPWR
  c0p = array licon in=pd left_of=gS1
  c1p = array licon in=pd between=[gS1, gN1]
  c2p = array licon in=pd between=[gN1, gA0] net=n4
  c3p = array licon in=pd between=[gA0, gA1] net=Y
  c4p = array licon in=pd between=[gA1, gS2] net=n2
  c5p = array licon in=pd right_of=gS2
  c0pl = enclose c0p li net=VPWR
  c1pl = enclose c1p li net=VPWR
  c2pl = enclose c2p li net=n4
  c3pl = enclose c3p li net=Y
  c4pl = enclose c4p li net=n2
  c5pl = enclose c5p li net=VPWR
  pwrp = strap li from=c0pl to=vpwr_li
  pwrp2 = strap li from=c5pl to=vpwr_li

  # gate contacts: n-row items only in cb; shifted right so pads keep 0.21 poly gap
  cb = max(nd.top + 0.19, c1nl.top + 0.25, c2nl.top + 0.25, c3nl.top + 0.25, c4nl.top + 0.25)
  gcS1 = contact licon cx=(gS1.cx - 0.09) bottom=cb
  gcN1 = contact licon cx=(gN1.cx - 0.09) bottom=cb
  gcA0 = contact licon cx=(gA0.cx - 0.09) bottom=cb
  gcA1 = contact licon cx=(gA1.cx - 0.09) bottom=cb
  gcS2 = contact licon cx=(gS2.cx - 0.09) bottom=cb
  gpS1 = enclose gcS1 poly by=minx
  gpN1 = enclose gcN1 poly by=minx
  gpA0 = enclose gcA0 poly by=minx
  gpA1 = enclose gcA1 poly by=minx
  gpS2 = enclose gcS2 poly by=minx
  gn   = enclose [gcS1, gcN1, gcA0, gcA1, gcS2] npc
  sL   = enclose gcS1 li net=S
  n1L  = enclose gcN1 li net=n1
  a0L  = enclose gcA0 li net=A0
  a1L  = enclose gcA1 li net=A1
  sR   = enclose gcS2 li net=S

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input pins
  sm = contact mcon in=sL
  sp = enclose sm m1 by=0.06 net=S
  n1m = contact mcon in=n1L
  n1p = enclose n1m m1 by=0.06 net=n1
  a0m = contact mcon in=a0L
  a0p = enclose a0m m1 by=0.06 net=A0
  a1m = contact mcon in=a1L
  a1p = enclose a1m m1 by=0.06 net=A1

  # output and internal nets joined by metal
  ym = contact mcon in=c3nl
  yp = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2
  route n1 layers=m1,m2
  route S layers=m1,m2

  port S in  on=sp
  port n1 in on=n1p
  port A0 in on=a0p
  port A1 in on=a1p
  port Y out on=yp
end
```