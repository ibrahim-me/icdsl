pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  # diffusion width: end contacts + gates + gap between gates (series node on n row, Y contact on p row)
  dw  = 2*L + 0.53 + max(0.28, 0.54 - L)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gates: same order A then B on both rows, crossing both diffusions
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))

  # n-row contacts: Y | n1(series, no contact) | VGND
  sn  = array licon in=nd left_of=ga            # Y contact (left end)
  dn  = array licon in=nd right_of=gb           # VGND contact (right end)
  snl = enclose sn li net=Y
  dnl = enclose dn li

  # p-row contacts: VPWR | Y(shared, has contact) | VPWR
  sp  = array licon in=pd left_of=ga            # VPWR contact (left end)
  my  = array licon in=pd between=[ga, gb]      # Y contact (middle, shared)
  s2  = array licon in=pd right_of=gb           # VPWR contact (right end)
  s1l = enclose sp li
  myl = enclose my li net=Y
  s2l = enclose s2 li

  # supply straps
  gnd = strap li from=dnl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  # gate contacts: above n-row, pushed away from the output route
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, myl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # input ports on met1
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B

  # output Y: n-side (snl, left end) and p-side (myl, middle) don't line up -> route
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port Y out
end
