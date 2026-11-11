pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor2 width=6 height=H
  device M0 pmos w=WP l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=Y g=A s=VGND
  device M2 nmos w=WN l=L d=VGND g=B s=Y
  device M3 pmos w=WP l=L d=Y g=B s=n1

  dw  = 2*L + max(0.28, 0.54 - L) + 0.53
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))

  sn  = array licon in=nd left_of=ga
  my  = array licon in=nd between=[ga, gb]
  dn  = array licon in=nd right_of=gb
  s1  = array licon in=pd left_of=ga
  s2  = array licon in=pd right_of=gb
  snl = enclose sn li
  myl = enclose my li net=Y
  dnl = enclose dn li
  s1l = enclose s1 li
  s2l = enclose s2 li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=dnl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li

  cb  = max(nd.top + 0.19, snl.top + 0.25, myl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
