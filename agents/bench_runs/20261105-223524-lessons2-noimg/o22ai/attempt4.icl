pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell o22ai width=10 height=H
  device M0 pmos w=WP l=L d=Y g=A2 s=n1
  device M1 pmos w=WP l=L d=n1 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=n2 g=B2 s=Y
  device M3 nmos w=WN l=L d=n3 g=A2 s=VGND
  device M4 nmos w=WN l=L d=n3 g=B1 s=Y
  device M5 nmos w=WN l=L d=Y g=B2 s=n3
  device M6 pmos w=WP l=L d=VPWR g=B1 s=n2
  device M7 nmos w=WN l=L d=VGND g=A1 s=n3

  dw  = 2*L + 0.81
  gap = 0.80
  nd_a = rect diff w=dw h=WN cx=(cell.cx - (dw+gap)/2) above=ptap
  nd_b = rect diff w=dw h=WN right_of=nd_a space=gap
  pd_a = rect diff w=dw h=WP cx=(cell.cx - (dw+gap)/2) below=ntap
  pd_b = rect diff w=dw h=WP right_of=pd_a space=gap
  nim  = enclose [nd_a, nd_b] nsdm
  pim  = enclose [pd_a, pd_b] psdm

  ga1 = cross [nd_a, pd_a] poly w=L left=(nd_a.left + 0.265)
  ga2 = cross [nd_a, pd_a] poly w=L left=(ga1.right + 0.28)
  gb1 = cross [nd_b, pd_b] poly w=L left=(nd_b.left + 0.265)
  gb2 = cross [nd_b, pd_b] poly w=L left=(gb1.right + 0.28)

  # n row island A: VGND | A1 | n3 | A2 | VGND
  sg  = array licon in=nd_a left_of=ga1
  sn3a= array licon in=nd_a between=[ga1, ga2] net=n3
  dg  = array licon in=nd_a right_of=ga2
  sgl = enclose sg li
  sn3al=enclose sn3a li net=n3
  dgl = enclose dg li
  gnd = strap li from=sgl to=vgnd_li
  gnd2= strap li from=dgl to=vgnd_li

  # n row island B: Y | B1 | n3 | B2 | Y
  syb = array licon in=nd_b left_of=gb1 net=Y
  sn3b= array licon in=nd_b between=[gb1, gb2] net=n3
  syc = array licon in=nd_b right_of=gb2 net=Y
  sybl= enclose syb li net=Y
  sn3bl=enclose sn3b li net=n3
  sycl= enclose syc li net=Y

  # p row island A: VPWR | A1 | n1 | A2 | Y
  sp1 = array licon in=pd_a left_of=ga1
  sn1 = array licon in=pd_a between=[ga1, ga2] net=n1
  sy1 = array licon in=pd_a right_of=ga2 net=Y
  sp1l= enclose sp1 li
  sn1l= enclose sn1 li net=n1
  sy1l= enclose sy1 li net=Y
  pwr = strap li from=sp1l to=vpwr_li

  # p row island B: VPWR | B1 | n2 | B2 | Y
  sp2 = array licon in=pd_b left_of=gb1
  sn2 = array licon in=pd_b between=[gb1, gb2] net=n2
  sy2 = array licon in=pd_b right_of=gb2 net=Y
  sp2l= enclose sp2 li
  sn2l= enclose sn2 li net=n2
  sy2l= enclose sy2 li net=Y
  pwr2= strap li from=sp2l to=vpwr_li

  # internal nets (route on metal, never a strap that crosses another contact column)
  route n1 layers=m1
  route n2 layers=m1
  route n3 layers=m1
  route Y layers=m1,m2

  # gate contacts in the gap between the rows, shifted away from the centre
  cb  = max(nd_a.top + 0.19, sn3al.top + 0.25, dgl.top + 0.25, sybl.top + 0.25, sycl.top + 0.25)
  gca = contact licon cx=(ga1.cx - 0.13) bottom=cb
  gcb = contact licon cx=(ga2.cx + 0.13) bottom=cb
  gcc = contact licon cx=(gb1.cx - 0.13) bottom=cb
  gcd = contact licon cx=(gb2.cx + 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gpd = enclose gcd poly by=minx
  gn  = enclose [gca, gcb, gcc, gcd] npc
  aa  = enclose gca li net=A1
  ab  = enclose gcb li net=A2
  ba  = enclose gcc li net=B1
  bb  = enclose gcd li net=B2
  well y=((nd_a.top + 0.34 + pd_a.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A1
  bm  = contact mcon in=ab
  bp  = enclose bm m1 by=0.06 net=A2
  cm  = contact mcon in=ba
  cp  = enclose cm m1 by=0.06 net=B1
  dm  = contact mcon in=bb
  dp  = enclose dm m1 by=0.06 net=B2
  ym  = contact mcon in=sy1l cy=(sy1l.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A1 in  on=ap
  port A2 in  on=bp
  port B1 in  on=cp
  port B2 in  on=dp
  port Y out on=yp
end
