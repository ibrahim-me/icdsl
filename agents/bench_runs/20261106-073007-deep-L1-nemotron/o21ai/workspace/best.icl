pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  dw  = 4*L + 1.32 + 0.80
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gc  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))

  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=gc
  s1  = array licon in=pd left_of=ga
  my  = array licon in=pd right_of=ga
  s2  = array licon in=pd right_of=gb
  snl = enclose sn li
  dnl = enclose dn li net=Y
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li
  gnd = strap li from=snl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx - 0.1) bottom=cb
  gcc = contact licon cx=(gc.cx - 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A1
  b   = enclose gcb li net=B1
  c   = enclose gcc li net=A2
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A1
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B1
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=A2
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  n1c = array licon in=nd between=[ga, gb]
  n1l = enclose n1c li net=n1
  n1m = contact mcon in=n1l
  n1p = enclose n1m m1 by=0.06 net=n1
  route n1 layers=m1,m2

  port A1 in  on=ap
  port B1 in  on=bp
  port A2 in  on=cp
  port Y out on=yp
end
