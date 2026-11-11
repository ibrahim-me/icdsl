pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=6 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  gs  = max(0.21, 0.54 - L)          # series gate gap (no contact between)
  roww = 0.53 + 3*L + 2*gs           # both rows: 0.265 end contacts + 3 gates + 2 gaps

  nd  = rect diff w=roww h=WN cx=cell.cx above=ptap
  pd  = rect diff w=roww h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gs)
  gcg = cross [nd, pd] poly w=L left=(gb.right + gs)

  # n-row: Y | A | n2 | B | n1 | C | GND  (series nodes n2, n1 have no contact)
  sn  = array licon in=nd left_of=ga            # Y
  dn  = array licon in=nd right_of=gcg          # GND
  snl = enclose sn li net=Y
  dnl = enclose dn li
  gnd = strap li from=dnl to=vgnd_li

  # p-row: VPWR | A | Y | B | VPWR | C | Y
  s1  = array licon in=pd left_of=ga            # VPWR
  o1  = array licon in=pd between=[ga, gb]      # Y
  o2  = array licon in=pd between=[gb, gcg]     # VPWR
  s3  = array licon in=pd right_of=gcg          # Y
  s1l = enclose s1 li
  o1l = enclose o1 li net=Y
  o2l = enclose o2 li
  s3l = enclose s3 li net=Y
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=o2l to=vpwr_li
  yp  = strap li from=o1l to=s3l net=Y

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gcg.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=o1l
  yp1 = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp1
end
