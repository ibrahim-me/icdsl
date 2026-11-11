pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  endc = 0.265
  ggap = max(0.28, 0.54 - L)          # gap with a contact column
  gser = max(0.21, 0.54 - L)          # series node gap, no contact
  big  = 0.80                         # A1-B1 gap: p-island spacing + contacts

  # n row: n2 | A2 | VGND | A1 | n2 | B1 | Y
  nd  = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  nim = enclose nd nsdm
  ga2 = cross [nd] poly w=L left=(nd.left + endc)
  ga1 = cross [nd] poly w=L left=(ga2.right + ggap)
  gb1 = cross [nd] poly w=L left=(ga1.right + big)

  nL  = array licon in=nd left_of=ga2          # n2 left of A2 (M5 source)
  nM  = array licon in=nd right_of=ga1         # n2 between A1 and B1 (M2/M3 drain)
  nR  = array licon in=nd right_of=gb1         # Y right of B1 (M3 source)
  nLl = enclose nL li net=n2
  nMl = enclose nM li net=n2
  nRl = enclose nR li net=Y
  nLs = strap li from=nLl to=vgnd_li           # VGND contact column right of A2

  # p row island 1: Y | A2 | n1 | A1 | VPWR   (width WP)
  pd1 = rect diff w=(2*L + gser + 2*endc) h=WP cx=(ga2.cx + ga1.cx)/2 below=ntap
  pim1 = enclose pd1 psdm
  pY1 = array licon in=pd1 left_of=ga2
  pP1 = array licon in=pd1 right_of=ga1
  pY1l = enclose pY1 li net=Y
  pP1l = enclose pP1 li
  pY1s = strap li from=pY1l to=vpwr_li         # VPWR contact column right of A1

  # p row island 2: VPWR | B1 | Y   (width WP2, under B1 only)
  pd2 = rect diff w=(L + 0.53) h=WP2 cx=gb1.cx below=ntap
  pim2 = enclose pd2 psdm
  pP2 = array licon in=pd2 left_of=gb1
  pY2 = array licon in=pd2 right_of=gb1
  pP2l = enclose pP2 li
  pY2l = enclose pY2 li net=Y
  pP2s = strap li from=pP2l to=vpwr_li

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, nLl.top + 0.25, nMl.top + 0.25, nRl.top + 0.25)
  gc2 = contact licon cx=ga2.cx bottom=cb
  gc1 = contact licon cx=ga1.cx bottom=cb
  gcb = contact licon cx=gb1.cx bottom=cb
  ep2 = enclose gc2 poly by=minx
  ep1 = enclose gc1 poly by=minx
  epb = enclose gcb poly by=minx
  enp = enclose [gc2, gc1, gcb] npc
  a2l = enclose gc2 li net=A2
  a1l = enclose gc1 li net=A1
  b1l = enclose gcb li net=B1

  well y=((nd.top + 0.34 + pd1.bottom - 0.18) / 2)

  # input pins: one mcon + met1 pad on each gate contact
  a2m = contact mcon in=a2l
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1l
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1l
  b1p = enclose b1m m1 by=0.06 net=B1

  # internal nets
  route n2 layers=m1,m2
  route Y layers=m1,m2
  ym = contact mcon in=nRl
  yp = enclose ym m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out  on=yp
end
