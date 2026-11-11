pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=5 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  gap = 0.54 - L
  end = 0.265
  dw  = 2*end + 3*L + 2*gap

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + end)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gap)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gap)

  # n row diffusion columns: Y | n2 | n1 | GND
  sy  = array licon in=nd left_of=ga
  sg  = array licon in=nd right_of=gc
  syl = enclose sy li net=Y
  sgl = enclose sg li net=VGND
  gnd = strap li from=sgl to=vgnd_li

  # p row diffusion columns: VPWR | Y | VPWR | Y
  p1  = array licon in=pd left_of=ga
  p2  = array licon in=pd between=[ga, gb]
  p3  = array licon in=pd between=[gb, gc]
  p4  = array licon in=pd right_of=gc
  p1l = enclose p1 li net=VPWR
  p2l = enclose p2 li net=Y
  p3l = enclose p3 li net=VPWR
  p4l = enclose p4 li net=Y
  pw1 = strap li from=p1l to=vpwr_li
  pw3 = strap li from=p3l to=vpwr_li

  # output: n-side Y and p-side Y columns joined by metal route
  yj  = strap li from=syl to=p2l net=Y
  route Y layers=m1

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb  = max(nd.top + 0.19, syl.top + 0.25, sgl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gaa = enclose gca poly by=minx
  gbb = enclose gcb poly by=minx
  gccp= enclose gcc poly by=minx
  gnn = enclose [gca, gcb, gcc] npc
  aa  = enclose gca li net=A
  bb  = enclose gcb li net=B
  cc  = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=cc
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=p2l cy=(p2l.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
