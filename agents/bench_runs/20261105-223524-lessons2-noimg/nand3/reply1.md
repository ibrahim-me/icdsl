```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=8 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  # n-row: Y | A | n2 | B | n1 | C | VGND  (series stack, no contacts on n1/n2)
  nd  = rect diff w=(3*L + 1.09) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(3*L + 1.09) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # same gate order A, B, C in both rows; 0.28 gate pitch (contact column between gates)
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gc  = cross [nd, pd] poly w=L left=(gb.right + 0.28)

  # n-row contacts: Y (left end), VGND (right end)
  cn  = array licon in=nd left_of=ga
  cg  = array licon in=nd right_of=gc
  cnl = enclose cn li net=Y
  cgl = enclose cg li net=VGND
  gnd = strap li from=cgl to=vgnd_li

  # p-row contacts: VPWR (left end), Y (between A-B), VPWR (between B-C), Y (right end)
  cp0 = array licon in=pd left_of=ga
  cy1 = array licon in=pd between=[ga, gb]
  cp1 = array licon in=pd between=[gb, gc]
  cy2 = array licon in=pd right_of=gc
  cp0l = enclose cp0 li net=VPWR
  cy1l = enclose cy1 li net=Y
  cp1l = enclose cp1 li net=VPWR
  cy2l = enclose cy2 li net=Y
  pwr0 = strap li from=cp0l to=vpwr_li
  pwr1 = strap li from=cp1l to=vpwr_li

  # gate contacts in the gap between the rows, on their own gate lines
  cb = max(nd.top + 0.19, cnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A
  bb  = enclose gcb li net=B
  cc  = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output: join n-side Y (cnl) and p-side Y strips (cy1l, cy2l) on m1/m2
  route Y layers=m1,m2

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=cc
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=cy1l
  yp  = enclose ym m1 by=0.06 net=Y
  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```