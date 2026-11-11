pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  gap = max(0.21, 0.54 - L)
  dw  = 0.53 + 3*L + 2*gap

  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gap)
  gn  = cross [nd, pd] poly w=L left=(gb.right + gap)

  # nMOS: n1 | A | n2 | B | VGND   X | n1 | VGND
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=gb
  s0  = array licon in=nd left_of=gn
  d0  = array licon in=nd right_of=gn
  snl = enclose sn li net=n1
  dnl = enclose dn li
  s0l = enclose s0 li net=X
  d0l = enclose d0 li
  gndn = strap li from=dnl to=vgnd_li
  gnd0 = strap li from=d0l to=vgnd_li

  # pMOS: n1 | A | VPWR | B | n1   X | n1 | VPWR
  s1  = array licon in=pd left_of=ga
  d1  = array licon in=pd right_of=ga
  s3  = array licon in=pd left_of=gb
  d3  = array licon in=pd right_of=gb
  s5  = array licon in=pd left_of=gn
  d5  = array licon in=pd right_of=gn
  s1l = enclose s1 li net=n1
  d1l = enclose d1 li
  s3l = enclose s3 li
  d3l = enclose d3 li net=n1
  s5l = enclose s5 li net=X
  d5l = enclose d5 li
  pwr1 = strap li from=d1l to=vpwr_li
  pwr3 = strap li from=s3l to=vpwr_li
  pwr5 = strap li from=d5l to=vpwr_li
  x5   = strap li from=s5l to=s0l net=X cx=s5l.cx

  cb = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s0l.top + 0.25, d0l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=gn.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gn_all = enclose [gca, gcb, gcn] npc
  al = enclose gca li net=A
  bl = enclose gcb li net=B
  nl = enclose gcn li net=n1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=al
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bl
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=d0l cy=(d0l.cy)
  xp  = enclose xm m1 by=0.06 net=X

  route n1 layers=m1,m2
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
