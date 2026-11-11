```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=(4*L + 2*0.265 + 0.21 + 0.28) h=WN cx=cell.cx above=ptap
  pd1 = rect diff w=(3*L + 2*0.265 + 0.28) h=WP cx=(nd.cx + 0.42) below=ntap
  pd2 = rect diff w=(2*L + 2*0.265) h=WP cx=(nd.cx - 0.42) below=ntap
  nim = enclose nd nsdm
  pim1= enclose pd1 psdm
  pim2= enclose pd2 psdm
  # n row: VGND | M0(A2) | n1 | M5(A1) | Y | M3(B1) | VGND
  ga  = cross [nd, pd2] poly w=L left=(nd.left + 0.265)          # A2
  gb  = cross [nd, pd1] poly w=L left=(ga.right + max(0.21, 0.54 - L))  # A1 (series node n1)
  gc  = cross [nd, pd1] poly w=L left=(gb.right + max(0.28, 0.54 - L))  # B1 (Y contact)
  sn  = array licon in=nd left_of=ga
  dy  = array licon in=nd between=[gb, gc]
  sr  = array licon in=nd right_of=gc
  snl = enclose sn li
  dyl = enclose dy li net=Y
  srl = enclose sr li
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=srl to=vgnd_li
  # p row island 1: VPWR | M1(A1) | n2 | M2(B1) | Y   (under gb, gc)
  sp1 = array licon in=pd1 left_of=gb
  my1 = array licon in=pd1 between=[gb, gc]
  my2 = array licon in=pd1 right_of=gc
  sp1l = enclose sp1 li
  my1l = enclose my1 li net=n2
  my2l = enclose my2 li net=Y
  pwr1= strap li from=sp1l to=vpwr_li
  # p row island 2: VPWR | M4(A2) | n2   (under ga)
  s4  = array licon in=pd2 left_of=ga
  d4  = array licon in=pd2 right_of=ga
  s4l = enclose s4 li net=VPWR
  d4l = enclose d4 li net=n2
  pwr2= strap li from=s4l to=vpwr_li
  # gate contacts in the gap between the rows, shifted so pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, dyl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gc.cx + 0.13) bottom=cb
  gna = enclose gca poly by=minx
  gnb = enclose gcb poly by=minx
  gnc = enclose gcc poly by=minx
  gndc= enclose [gca, gcb, gcc] npc
  a1  = enclose gcb li net=A1
  a2  = enclose gca li net=A2
  b1  = enclose gcc li net=B1
  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)
  # internal nets
  route n2 layers=m1,m2
  route Y layers=m1,m2
  am1 = contact mcon in=a1
  ap1 = enclose am1 m1 by=0.06 net=A1
  am2 = contact mcon in=a2
  ap2 = enclose am2 m1 by=0.06 net=A2
  bm  = contact mcon in=b1
  bp  = enclose bm m1 by=0.06 net=B1
  ym  = contact mcon in=dyl cy=(dyl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y
  port A1 in  on=ap1
  port A2 in  on=ap2
  port B1 in  on=bp
  port Y out  on=yp
end
```