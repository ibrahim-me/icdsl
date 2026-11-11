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

  gapg = max(0.28, 0.54 - L)          # gate pitch so gate-contact li/mcon pads clear
  dw   = 5*L + 4*gapg + 2*0.265
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm

  # n-row: VGND |g=n1(M5)| n5 |g=A0(M9)| Y |g=A1(M8)| n3 |g=S(M3)| VGND |g=S(M6)| n1
  gN1  = cross [nd, pd] poly w=L left=(nd.left + 0.265)            # M5(n) / M4(p)
  gA0  = cross [nd, pd] poly w=L left=(gN1.right + gapg)           # M9(n) / M2(p)
  gA1  = cross [nd, pd] poly w=L left=(gA0.right + gapg)           # M8(n) / M7(p)
  gS3  = cross [nd, pd] poly w=L left=(gA1.right + gapg)           # M3(n) / M1(p)
  gS6  = cross [nd, pd] poly w=L left=(gS3.right + gapg)           # M6(n) / M0(p)

  # n-row contacts: VGND | n5 | Y | n3 | VGND | n1
  cn0  = array licon in=nd left_of=gN1
  cn5  = array licon in=nd right_of=gN1 left_of=gA0 net=n5
  cy   = array licon in=nd right_of=gA0 left_of=gA1 net=Y
  cn3  = array licon in=nd right_of=gA1 left_of=gS3 net=n3
  cnV  = array licon in=nd right_of=gS3 left_of=gS6
  cn1  = array licon in=nd right_of=gS6 net=n1
  cn0l = enclose cn0 li
  cn5l = enclose cn5 li net=n5
  cyl  = enclose cy li net=Y
  cn3l = enclose cn3 li net=n3
  cnVl = enclose cnV li
  cn1l = enclose cn1 li net=n1
  gnd1 = strap li from=cn0l to=vgnd_li
  gnd2 = strap li from=cnVl to=vgnd_li

  # p-row: n1 | VPWR | n2 | Y | n4 | VPWR
  cp1  = array licon in=pd left_of=gN1 net=n1
  cpV  = array licon in=pd right_of=gN1 left_of=gA0 net=VPWR
  cp2  = array licon in=pd right_of=gA0 left_of=gA1 net=n2
  cpY  = array licon in=pd right_of=gA1 left_of=gS3 net=Y
  cp4  = array licon in=pd right_of=gS3 left_of=gS6 net=n4
  cpV2 = array licon in=pd right_of=gS6 net=VPWR
  cp1l = enclose cp1 li net=n1
  cpVl = enclose cpV li
  cp2l = enclose cp2 li net=n2
  cpYl = enclose cpY li net=Y
  cp4l = enclose cp4 li net=n4
  cpV2l= enclose cpV2 li
  pwr1 = strap li from=cpVl to=vpwr_li
  pwr2 = strap li from=cpV2l to=vpwr_li

  # gate contacts in the gap between the rows, centred on their own gate line
  cb   = max(nd.top + 0.19, cn0l.top + 0.25, cn5l.top + 0.25, cyl.top + 0.25, cn3l.top + 0.25, cnVl.top + 0.25, cn1l.top + 0.25)
  gcN1 = contact licon cx=gN1.cx bottom=cb
  gcA0 = contact licon cx=gA0.cx bottom=cb
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gcS3 = contact licon cx=gS3.cx bottom=cb
  gcS6 = contact licon cx=gS6.cx bottom=cb
  gpN1 = enclose gcN1 poly by=minx
  gpA0 = enclose gcA0 poly by=minx
  gpA1 = enclose gcA1 poly by=minx
  gpS3 = enclose gcS3 poly by=minx
  gpS6 = enclose gcS6 poly by=minx
  gn   = enclose [gcN1, gcA0, gcA1, gcS3, gcS6] npc
  n1g  = enclose gcN1 li net=n1
  a0   = enclose gcA0 li net=A0
  a1   = enclose gcA1 li net=A1
  s    = enclose [gcS3, gcS6] li net=S

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # internal nets joined on metal
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route n5 layers=m1,m2

  # input ports
  sm   = contact mcon in=s
  sp   = enclose sm m1 by=0.06 net=S
  a0m  = contact mcon in=a0
  a0p  = enclose a0m m1 by=0.06 net=A0
  a1m  = contact mcon in=a1
  a1p  = enclose a1m m1 by=0.06 net=A1
  port S in  on=sp
  port A0 in on=a0p
  port A1 in on=a1p

  # output Y: n-side cyl and p-side cpYl both net=Y, joined by m1
  yc   = contact mcon in=cyl
  yp   = enclose yc m1 by=0.06 net=Y
  yp2  = enclose cpYl m1 by=0.06 net=Y
  route Y layers=m1
  port Y out on=yp
end
