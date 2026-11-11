pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=8 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  dw  = 4*L + 4*0.265 + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gc  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))
  gd  = cross [nd, pd] poly w=L left=(gc.right + max(0.28, 0.54 - L))

  # p row: VPWR | A1 | n1 | A2 | Y | B2 | n2 | B1 | VPWR
  sp  = array licon in=pd left_of=ga
  c1  = array licon in=pd between=[ga, gb]
  cy  = array licon in=pd between=[gb, gc] net=Y
  c2  = array licon in=pd between=[gc, gd]
  ep  = array licon in=pd right_of=gd

  # n row: n3 | A1 | VGND | A2 | n3 | B2 | Y | B1 | n3
  sn  = array licon in=nd left_of=ga
  cn3 = array licon in=nd between=[ga, gb] net=n3
  ev  = array licon in=nd between=[gb, gc]
  cn3b= array licon in=nd between=[gc, gd] net=n3
  en  = array licon in=nd right_of=gd

  spl = enclose sp li
  c1l = enclose c1 li net=n1
  cyl = enclose cy li net=Y
  c2l = enclose c2 li net=n2
  epl = enclose ep li

  snl = enclose sn li
  cn3l= enclose cn3 li net=n3
  evl = enclose ev li
  cn3bl= enclose cn3b li net=n3
  enl = enclose en li

  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=spl to=vpwr_li
  pv  = strap li from=epl to=vpwr_li
  nv  = strap li from=enl to=vgnd_li

  n1s = strap li from=c1l to=cyl net=n1
  n2s = strap li from=c2l to=cyl net=n2

  cb  = max(nd.top + 0.19, snl.top + 0.25, cn3l.top + 0.25, evl.top + 0.25, cn3bl.top + 0.25, enl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.1) bottom=cb
  gcd = contact licon cx=(gd.cx - 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gpd = enclose gcd poly by=minx
  gna = enclose [gca, gcb, gcc, gcd] npc

  aa  = enclose gca li net=A1
  ab  = enclose gcb li net=A2
  ac  = enclose gcc li net=B2
  ad  = enclose gcd li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

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
  route Y layers=m1

  port A1 in  on=aap
  port A2 in  on=abp
  port B1 in  on=adp
  port B2 in  on=acp
  port Y out on=yp
end
