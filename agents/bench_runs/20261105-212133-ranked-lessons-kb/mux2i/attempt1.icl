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

  dw  = 5*L + 4*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order: S(S) A0 A1 n1 ; shared segments n1 VPWR n2 Y n4 VPWR (p) / n1 VGND n3 Y n5 VGND (n)
  gS1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)            # M6(n) / M0(p)
  gS2 = cross [nd, pd] poly w=L left=(gS1.right + 0.28)           # M3(n) / M1(p)
  gA0 = cross [nd, pd] poly w=L left=(gS2.right + 0.28)           # M9(n) / M2(p)
  gA1 = cross [nd, pd] poly w=L left=(gA0.right + 0.28)           # M8(n) / M7(p)
  gN1 = cross [nd, pd] poly w=L left=(gA1.right + 0.28)           # M5(n) / M4(p)

  # n-row contacts: VGND | n1 | VGND | n3 | Y | n5 | VGND
  c0  = array licon in=nd left_of=gS1
  c1  = array licon in=nd right_of=gS1 left_of=gS2 net=n1
  c2  = array licon in=nd right_of=gS2 left_of=gA0 net=VGND
  c3  = array licon in=nd right_of=gA0 left_of=gA1 net=n3
  c4  = array licon in=nd right_of=gA1 left_of=gN1 net=Y
  c5  = array licon in=nd right_of=gN1 net=n5
  c6  = array licon in=nd right_of=gN1 net=VGND
  c0l = enclose c0 li
  c1l = enclose c1 li net=n1
  c2l = enclose c2 li
  c3l = enclose c3 li net=n3
  c4l = enclose c4 li net=Y
  c5l = enclose c5 li net=n5
  c6l = enclose c6 li
  gnd1= strap li from=c0l to=vgnd_li
  gnd2= strap li from=c2l to=vgnd_li
  gnd3= strap li from=c6l to=vgnd_li

  # p-row contacts: n1 | VPWR | n2 | Y | n4 | VPWR
  p0  = array licon in=pd left_of=gS1 net=n1
  p1  = array licon in=pd right_of=gS1 left_of=gS2 net=VPWR
  p2  = array licon in=pd right_of=gS2 left_of=gA0 net=n2
  p3  = array licon in=pd right_of=gA0 left_of=gA1 net=Y
  p4  = array licon in=pd right_of=gA1 left_of=gN1 net=n4
  p5  = array licon in=pd right_of=gN1 net=VPWR
  p0l = enclose p0 li net=n1
  p1l = enclose p1 li
  p2l = enclose p2 li net=n2
  p3l = enclose p3 li net=Y
  p4l = enclose p4 li net=n4
  p5l = enclose p5 li
  pwr1= strap li from=p1l to=vpwr_li
  pwr2= strap li from=p5l to=vpwr_li

  # gate contacts in the gap between the rows, on their own gate line
  cb  = max(nd.top + 0.19, c0l.top + 0.25, c1l.top + 0.25, c2l.top + 0.25, c3l.top + 0.25, c4l.top + 0.25, c5l.top + 0.25, c6l.top + 0.25)
  gcS1= contact licon cx=gS1.cx bottom=cb
  gcS2= contact licon cx=(gS2.cx - 0.1) bottom=cb
  gcA0= contact licon cx=(gA0.cx + 0.1) bottom=cb
  gcA1= contact licon cx=(gA1.cx - 0.1) bottom=cb
  gcN1= contact licon cx=(gN1.cx + 0.1) bottom=cb
  gpS1= enclose gcS1 poly by=minx
  gpS2= enclose gcS2 poly by=minx
  gpA0= enclose gcA0 poly by=minx
  gpA1= enclose gcA1 poly by=minx
  gpN1= enclose gcN1 poly by=minx
  gn  = enclose [gcS1, gcS2, gcA0, gcA1, gcN1] npc
  s   = enclose [gcS1, gcS2] li net=S
  a0  = enclose gcA0 li net=A0
  a1  = enclose gcA1 li net=A1
  n1g = enclose gcN1 li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # supply straps
  sm0 = strap li from=p0l to=vpwr_li   # M0 source VPWR (p0l is n1 - fix below)

  # input ports
  sm  = contact mcon in=s
  sp  = enclose sm m1 by=0.06 net=S
  a0m = contact mcon in=a0
  a0p = enclose a0m m1 by=0.06 net=A0
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  port S in  on=sp
  port A0 in on=a0p
  port A1 in on=a1p

  # output Y: n-side c4l and p-side p3l both net=Y, join with m1
  yc  = contact mcon in=c4l
  yp  = enclose yc m1 by=0.06 net=Y
  yp2 = enclose p3l m1 by=0.06 net=Y
  route Y layers=m1
  port Y out on=yp
end
