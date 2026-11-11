pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=9 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  # common gate order A1 A2 B2 B1 works for both rows
  nd  = rect diff w=(4*L + 4*0.265 + 3*0.28) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 4*0.265 + 3*0.28) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # NMOS columns: n3 VGND n3 Y n3 ; gates A1 A2 B2 B1
  ga1 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga2 = cross [nd, pd] poly w=L left=(ga1.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(ga2.right + 0.28)
  gb1 = cross [nd, pd] poly w=L left=(gb2.right + 0.28)

  # NMOS contact columns
  n3a = array licon in=nd left_of=ga1
  gnd = array licon in=nd between=[ga1, ga2]
  n3b = array licon in=nd between=[ga2, gb2]
  y   = array licon in=nd between=[gb2, gb1]
  n3c = array licon in=nd right_of=gb1
  n3al = enclose n3a li net=n3
  gndl = enclose gnd li
  n3bl = enclose n3b li net=n3
  yl   = enclose y li net=Y
  n3cl = enclose n3c li net=n3
  gnds = strap li from=gndl to=vgnd_li

  # PMOS columns: VPWR n1 Y n2 VPWR ; gates A1 A2 B2 B1
  pwr = array licon in=pd left_of=ga1
  n1  = array licon in=pd between=[ga1, ga2]
  yp  = array licon in=pd between=[ga2, gb2]
  n2  = array licon in=pd between=[gb2, gb1]
  pwr2= array licon in=pd right_of=gb1
  pwrl = enclose pwr li
  n1l  = enclose n1 li
  ypl  = enclose yp li net=Y
  n2l  = enclose n2 li
  pwr2l= enclose pwr2 li
  pwrs = strap li from=pwrl to=vpwr_li
  pwrs2= strap li from=pwr2l to=vpwr_li

  # join the three n3 columns and the two Y columns
  route n3 layers=m1,m2
  route Y layers=m1,m2

  # gate contacts in the gap between the rows, on their own gates
  cb = max(nd.top + 0.19, n3al.top + 0.25, n3bl.top + 0.25, n3cl.top + 0.25, yl.top + 0.25)
  gca = contact licon cx=ga1.cx bottom=cb
  gcb = contact licon cx=ga2.cx bottom=cb
  gcc = contact licon cx=gb2.cx bottom=cb
  gcd = contact licon cx=gb1.cx bottom=cb
  pca = enclose gca poly by=minx
  pcb = enclose gcb poly by=minx
  pcc = enclose gcc poly by=minx
  pcd = enclose gcd poly by=minx
  gn  = enclose [gca, gcb, gcc, gcd] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b2  = enclose gcc li net=B2
  b1  = enclose gcd li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b2m = contact mcon in=b2
  b2p = enclose b2m m1 by=0.06 net=B2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=yl
  yp_ = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port B2 in  on=b2p
  port Y out on=yp_
end
