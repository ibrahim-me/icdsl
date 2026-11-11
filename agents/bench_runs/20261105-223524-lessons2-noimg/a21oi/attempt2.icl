pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=(4*L + 2*0.265 + 0.21) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 2*0.265 + 0.21) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # n row: VGND | M0(A2) | n1 | M5(A1) | Y | M3(B1) | VGND
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # A2
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.21)          # A1 (series node n1, no contact)
  gc  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))  # B1 (Y contact column)
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=gc
  snl = enclose sn li
  dnl = enclose dn li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=dnl to=vgnd_li
  # p row: n2 | M4(A2) | VPWR | M1(A1) | n2 | M2(B1) | Y
  gp1 = cross pd poly w=L left=(pd.left + 0.265)                 # A2
  gp2 = cross pd poly w=L left=(gp1.right + max(0.28, 0.54 - L)) # A1
  gp3 = cross pd poly w=L left=(gp2.right + max(0.28, 0.54 - L)) # B1
  s4  = array licon in=pd left_of=gp1
  p4l = enclose s4 li net=n2
  p1  = array licon in=pd between=[gp1, gp2]
  p1l = enclose p1 li net=VPWR
  p2  = array licon in=pd between=[gp2, gp3]
  p2l = enclose p2 li net=n2
  d2  = array licon in=pd right_of=gp3
  d2l = enclose d2 li net=Y
  pwr = strap li from=p1l to=vpwr_li
  p4p = strap li from=p4l to=vpwr_li   # keeps M4's VPWR-side contact on VPWR net
  # gate contacts in the gap between the rows, shifted so pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gc.cx + 0.13) bottom=cb
  gpa = contact licon cx=(gp1.cx - 0.13) bottom=cb
  gpb = contact licon cx=(gp2.cx + 0.13) bottom=cb
  gpc = contact licon cx=(gp3.cx - 0.13) bottom=cb
  gna = enclose [gca, gcb, gcc] poly by=minx
  gnb = enclose [gpa, gpb, gpc] poly by=minx
  gnc = enclose [gca, gcb, gcc, gpa, gpb, gpc] npc
  a1  = enclose gcb li net=A1
  a2  = enclose gca li net=A2
  b1  = enclose gcc li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # internal nets: n1 is the n-row series node (no contact); n2 joins p4l and p2l
  route n2 layers=m1,m2
  # output Y joins n-row dnl and p-row d2l
  route Y layers=m1,m2
  am1 = contact mcon in=a1
  ap1 = enclose am1 m1 by=0.06 net=A1
  am2 = contact mcon in=a2
  ap2 = enclose am2 m1 by=0.06 net=A2
  bm  = contact mcon in=b1
  bp  = enclose bm m1 by=0.06 net=B1
  ym  = contact mcon in=dnl cy=(dnl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y
  port A1 in  on=ap1
  port A2 in  on=ap2
  port B1 in  on=bp
  port Y out  on=yp
end
