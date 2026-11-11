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
  # p row: VPWR | M1(A1) | n2 | M2(B1) | Y  (island 1); VPWR | M4(A2) | n2 (island 2)
  gp1 = cross pd poly w=L left=(pd.left + 0.265)                 # A1
  gp2 = cross pd poly w=L left=(gp1.right + max(0.28, 0.54 - L)) # B1
  gp3 = cross pd poly w=L left=(pd.right - 0.265 - L)            # A2
  sp1 = array licon in=pd left_of=gp1
  my1 = array licon in=pd between=[gp1, gp2]
  my2 = array licon in=pd right_of=gp2
  s4  = array licon in=pd left_of=gp3
  d4  = array licon in=pd right_of=gp3
  sp1l = enclose sp1 li
  my1l = enclose my1 li net=n2
  my2l = enclose my2 li net=Y
  s4l  = enclose s4 li
  d4l  = enclose d4 li net=n2
  p1  = strap li from=sp1l to=vpwr_li
  p4  = strap li from=s4l to=vpwr_li
  p4d = strap li from=d4l to=vpwr_li   # keeps M4's n2-side contact on VPWR net? no, d4 is n2
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
  # internal net n1: n-row series node (no contact) to p-side is not used; n1 is purely n-row internal
  # internal net n2: join p-side strips my1l and d4l
  route n2 layers=m1,m2
  # output Y: n-row dnl and p-row my2l
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
