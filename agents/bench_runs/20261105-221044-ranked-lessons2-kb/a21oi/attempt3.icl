pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  dw  = 2*0.265 + 2*max(0.28, 0.54 - L) + 3*L
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)        # A2
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))   # A1
  gc  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))   # B1

  # NMOS: VGND | A2 | n1 | A1 | Y | B1 | VGND
  sn  = array licon in=nd left_of=ga
  cn  = array licon in=nd between=[ga, gb] net=n1
  yn  = array licon in=nd between=[gb, gc] net=Y
  se  = array licon in=nd right_of=gc
  snl = enclose sn li
  cnl = enclose cn li net=n1
  ynl = enclose yn li net=Y
  sel = enclose se li
  gnd = strap li from=snl to=vgnd_li
  gnde= strap li from=sel to=vgnd_li

  # PMOS: n2 | A2 | VPWR | A1 | n2 | B1 | Y
  sp  = array licon in=pd left_of=ga net=n2
  cp  = array licon in=pd between=[ga, gb] net=VPWR
  np  = array licon in=pd between=[gb, gc] net=n2
  yp  = array licon in=pd right_of=gc net=Y
  spl = enclose sp li net=n2
  cpl = enclose cp li net=VPWR
  npl = enclose np li net=n2
  ypl = enclose yp li net=Y
  p1  = strap li from=cpl to=vpwr_li

  cb  = max(nd.top + 0.19, snl.top + 0.25, cnl.top + 0.25, ynl.top + 0.25, sel.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A2
  ab  = enclose gcb li net=A1
  bb  = enclose gcc li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  route n2 layers=m1,m2
  route Y layers=m1,m2

  am1 = contact mcon in=aa
  ap1 = enclose am1 m1 by=0.06 net=A2
  bm1 = contact mcon in=ab
  bp1 = enclose bm1 m1 by=0.06 net=A1
  cm1 = contact mcon in=bb
  cp1 = enclose cm1 m1 by=0.06 net=B1
  ym1 = contact mcon in=ypl
  yp1 = enclose ym1 m1 by=0.06 net=Y

  port A1 in  on=bp1
  port A2 in  on=ap1
  port B1 in  on=cp1
  port Y out on=yp1
end
