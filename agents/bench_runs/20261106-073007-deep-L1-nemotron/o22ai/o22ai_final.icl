pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=15 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  gap = max(0.28, 0.54 - L)
  brk = 0.80
  iw  = 0.265 + L + 0.265

  # p row islands: VPWR | n1 | Y | n2 | VPWR
  pd1 = rect diff w=iw h=WP left=(cell.cx - 2*(iw+brk) - iw/2) below=ntap net=VPWR
  pd2 = rect diff w=iw h=WP right_of=pd1 gap=brk below=ntap net=n1
  pd3 = rect diff w=iw h=WP right_of=pd2 gap=brk below=ntap net=Y
  pd4 = rect diff w=iw h=WP right_of=pd3 gap=brk below=ntap net=n2
  pd5 = rect diff w=iw h=WP right_of=pd4 gap=brk below=ntap net=VPWR

  # n row islands: n3 | VGND | n3 | Y | n3
  nd1 = rect diff w=iw h=WN left=(cell.cx - 2*(iw+brk) - iw/2) above=ptap net=n3
  nd2 = rect diff w=iw h=WN right_of=nd1 gap=brk above=ptap net=VGND
  nd3 = rect diff w=iw h=WN right_of=nd2 gap=brk above=ptap net=n3
  nd4 = rect diff w=iw h=WN right_of=nd3 gap=brk above=ptap net=Y
  nd5 = rect diff w=iw h=WN right_of=nd4 gap=brk above=ptap net=n3

  pim = enclose [pd1, pd2, pd3, pd4, pd5] psdm
  nim = enclose [nd1, nd2, nd3, nd4, nd5] nsdm

  ga  = cross [nd1, pd1] poly w=L
  gb  = cross [nd2, pd2] poly w=L left=(ga.right + brk)
  gc  = cross [nd3, pd3] poly w=L left=(gb.right + brk)
  gd  = cross [nd4, pd4] poly w=L left=(gc.right + brk)

  # p row contacts: VPWR | n1 | Y | n2 | VPWR
  sp  = array licon in=pd1 net=VPWR
  c1  = array licon in=pd2 net=n1
  cy  = array licon in=pd3 net=Y
  c2  = array licon in=pd4 net=n2
  ep  = array licon in=pd5 net=VPWR

  # n row contacts: n3 | VGND | n3 | Y | n3
  sn  = array licon in=nd1 net=n3
  cn3 = array licon in=nd2 net=VGND
  ev  = array licon in=nd3 net=n3
  cn3b= array licon in=nd4 net=Y
  en  = array licon in=nd5 net=n3

  spl = enclose sp li net=VPWR
  c1l = enclose c1 li net=n1
  cyl = enclose cy li net=Y
  c2l = enclose c2 li net=n2
  epl = enclose ep li net=VPWR

  snl = enclose sn li net=n3
  cn3l= enclose cn3 li net=VGND
  evl = enclose ev li net=n3
  cn3bl= enclose cn3b li net=Y
  enl = enclose en li net=n3

  gnd = strap li from=cn3l to=vgnd_li cx=cn3l.cx
  pwr = strap li from=spl to=vpwr_li cx=spl.cx
  pv  = strap li from=epl to=vpwr_li cx=epl.cx
  nv  = strap li from=enl to=vgnd_li cx=enl.cx

  route n3 layers=m1
  route Y layers=m1

  cb  = max(nd1.top + 0.19, snl.top + 0.25, cn3l.top + 0.25, evl.top + 0.25, cn3bl.top + 0.25, enl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.1) bottom=cb
  gcd = contact licon cx=(gd.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gpd = enclose gcd poly by=minx
  gna = enclose [gca, gcb, gcc, gcd] npc

  aa  = enclose gca li net=A1
  ab  = enclose gcb li net=A2
  ac  = enclose gcc li net=B2
  ad  = enclose gcd li net=B1

  well y=((nd1.top + 0.34 + pd1.bottom - 0.18) / 2)

  aam = contact mcon in=aa
  aap = enclose aam m1 by=0.06 net=A1
  abm = contact mcon in=ab
  abp = enclose abm m1 by=0.06 net=A2
  acm = contact mcon in=ac
  acp = enclose acm m1 by=0.06 net=B2
  adm = contact mcon in=ad
  adp = enclose adm m1 by=0.06 net=B1

  ym  = contact mcon in=cyl
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=aap
  port A2 in  on=abp
  port B1 in  on=adp
  port B2 in  on=acp
  port Y out on=yp
end
