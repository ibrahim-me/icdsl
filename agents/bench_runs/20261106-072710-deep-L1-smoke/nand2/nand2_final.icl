pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  dw  = 2*0.265 + 2*L + max(0.28, 0.54 - L)
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # Gate order A, B (left to right) in both rows
  # n row: Y | gate A | n1 | gate B | VGND
  # p row: VPWR | gate A | Y | gate B | VPWR
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))

  # n-row contacts: Y (left end), VGND (right end)
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=gb
  # p-row contacts: VPWR (left end), Y (between gates), VPWR (right end)
  s1  = array licon in=pd left_of=ga
  my  = array licon in=pd between=[ga, gb]
  s2  = array licon in=pd right_of=gb

  snl = enclose sn li net=Y
  dnl = enclose dn li net=VGND
  s1l = enclose s1 li net=VPWR
  myl = enclose my li net=Y
  s2l = enclose s2 li net=VPWR

  gnd = strap li from=dnl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  # Gate contacts: only n-row items in cb max (lesson 1)
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gna = enclose [gca, gcb] npc

  a   = enclose gca li net=A
  b   = enclose gcb li net=B

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Ports on met1
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y

  # Join n-side Y (left end) to p-side Y (middle) since they don't line up
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
