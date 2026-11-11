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

  # shared gate order (left to right): S | n1 | A0 | A1 | S
  # n-row segments: n1 | VGND | n5 | Y | n3 | VGND   (M6,M5,M9,M8,M3)
  # p-row segments: VPWR | n4 | Y | n2 | VPWR | n1   (M4,M7,M2,M1,M0)
  gS6  = cross [nd, pd] poly w=L left=(nd.left + 0.265)            # M6(n) / M0(p)
  gN1  = cross [nd, pd] poly w=L left=(gS6.right + gapg)           # M5(n) / M4(p)
  gA0  = cross [nd, pd] poly w=L left=(gN1.right + gapg)           # M9(n) / M2(p)
  gA1  = cross [nd, pd] poly w=L left=(gA0.right + gapg)           # M8(n) / M7(p)
  gS3  = cross [nd, pd] poly w=L left=(gA1.right + gapg)           # M3(n) / M1(p)

  # n-row contacts: n1 | VGND | n5 | Y | n3 | VGND
  cn1  = array licon in=nd left_of=gS6 net=n1
  cnV  = array licon in=nd right_of=gS6 left_of=gN1
  cn5  = array licon in=nd right_of=gN1 left_of=gA0 net=n5
  cy   = array licon in=nd right_of=gA0 left_of=gA1 net=Y
  cn3  = array licon in=nd right_of=gA1 left_of=gS3 net=n3
  cnV2 = array licon in=nd right_of=gS3
  cn1l = enclose cn1 li net=n1
  cnVl = enclose cnV li
  cn5l = enclose cn5 li net=n5
  cyl  = enclose cy li net=Y
  cn3l = enclose cn3 li net=n3
  cnV2l= enclose cnV2 li
  gnd1 = strap li from=cnVl to=vgnd_li
  gnd2 = strap li from=cnV2l to=vgnd_li

  # p-row contacts: VPWR | n4 | Y | n2 | VPWR | n1
  cpV  = array licon in=pd left_of=gS6 net=VPWR
  cp4  = array licon in=pd right_of=gS6 left_of=gN1 net=n4
  cpY  = array licon in=pd right_of=gN1 left_of=gA0 net=Y
  cp2  = array licon in=pd right_of=gA0 left_of=gA1 net=n2
  cpV2 = array licon in=pd right_of=gA1 left_of=gS3 net=VPWR
  cp1  = array licon in=pd right_of=gS3 net=n1
  cpVl = enclose cpV li
  cp4l = enclose cp4 li net=n4
  cpYl = enclose cpY li net=Y
  cp2l = enclose cp2 li net=n2
  cpV2l= enclose cpV2 li
  cp1l = enclose cp1 li net=n1
  pwr1 = strap li from=cpVl to=vpwr_li
  pwr2 = strap li from=cpV2l to=vpwr_li

  # gate contacts in the gap between the rows, centred on their own gate line
  cb   = max(nd.top + 0.19, cn1l.top + 0.25, cnVl.top + 0.25, cn5l.top + 0.25, cyl.top + 0.25, cn3l.top + 0.25, cnV2l.top + 0.25)
  gcS6 = contact licon cx=gS6.cx bottom=cb
  gcN1 = contact licon cx=gN1.cx bottom=cb
  gcA0 = contact licon cx=gA0.cx bottom=cb
  gcA1 = contact licon cx=gA1.cx bottom=cb
  gcS3 = contact licon cx=gS3.cx bottom=cb
  gpS6 = enclose gcS6 poly by=minx
  gpN1 = enclose gcN1 poly by=minx
  gpA0 = enclose gcA0 poly by=minx
  gpA1 = enclose gcA1 poly by=minx
  gpS3 = enclose gcS3 poly by=minx
  gn   = enclose [gcS6, gcN1, gcA0, gcA1, gcS3] npc
  s    = enclose [gcS6, gcS3] li net=S
  n1g  = enclose gcN1 li net=n1
  a0   = enclose gcA0 li net=A0
  a1   = enclose gcA1 li net=A1

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
