pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=5 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  nd  = rect diff w=(3*L + 0.95) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(3*L + 1.09) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gc  = cross [nd, pd] poly w=L left=(gb.right + 0.28)

  cn  = array licon in=nd left_of=ga
  cg  = array licon in=nd right_of=gc
  cnl = enclose cn li net=Y
  cgl = enclose cg li
  gndn = strap li from=cgl to=vgnd_li

  cp1 = array licon in=pd left_of=ga
  cy1 = array licon in=pd right_of=ga
  cy2 = array licon in=pd right_of=gb
  cp2 = array licon in=pd right_of=gc
  cp1l = enclose cp1 li
  cy1l = enclose cy1 li net=Y
  cy2l = enclose cy2 li net=Y
  cp2l = enclose cp2 li
  pwr1 = strap li from=cp1l to=vpwr_li
  pwr2 = strap li from=cp2l to=vpwr_li

  cb  = max(nd.top + 0.19, cnl.top + 0.25, cgl.top + 0.25, cy1l.top + 0.25, cy2l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx)       bottom=cb
  gcc = contact licon cx=(gc.cx + 0.1) bottom=cb
  gna = enclose gca poly by=minx
  gnb = enclose gcb poly by=minx
  gnc = enclose gcc poly by=minx
  gn_all = enclose [gca, gcb, gcc] npc
  aa = enclose gca li net=A
  bb = enclose gcb li net=B
  cc = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=cc
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=cnl cy=(cnl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A in  on=ap side=left layer=m1
  port B in  on=bp side=left layer=m1
  port C in  on=cp side=right layer=m1
  port Y out on=yp side=right layer=m1
end
