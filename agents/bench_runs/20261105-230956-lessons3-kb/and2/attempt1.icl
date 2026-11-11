pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell and2 width=10 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP2 l=L d=VPWR g=A s=n1
  device M2 nmos w=WN2 l=L d=n1 g=A s=n2
  device M3 pmos w=WP2 l=L d=n1 g=B s=VPWR
  device M4 nmos w=WN2 l=L d=n2 g=B s=VGND
  device M5 pmos w=WP l=L d=VPWR g=n1 s=X

  nd  = rect diff w=min h=WN cx=cell.cx above=ptap
  pd  = rect diff w=min h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # gate order A, B, n1 in both rows
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + max(0.28, 0.54 - L))
  gn  = cross [nd, pd] poly w=L left=(gb.right + max(0.28, 0.54 - L))

  # nMOS: n1 | A | n2 | B | VGND  (island1)   X | n1 | VGND  (island2, M0)
  sn  = array licon in=nd left_of=ga       # n1 (M2 drain)
  dn  = array licon in=nd right_of=gb      # VGND (M4 source)
  s0  = array licon in=nd left_of=gn       # X (M0 source)
  d0  = array licon in=nd right_of=gn      # VGND (M0 drain)
  snl = enclose sn li net=n1
  dnl = enclose dn li
  s0l = enclose s0 li net=X
  d0l = enclose d0 li
  gndn = strap li from=dnl to=vgnd_li
  gnd0 = strap li from=d0l to=vgnd_li

  # pMOS: n1 | A | VPWR | B | n1  (island3)   X | n1 | VPWR  (island4, M5)
  s1  = array licon in=pd left_of=ga       # VPWR (M1 source)
  d1  = array licon in=pd right_of=ga      # n1 (M1 drain)
  s3  = array licon in=pd left_of=gb       # VPWR (M3 source)
  d3  = array licon in=pd right_of=gb      # n1 (M3 drain)
  s5  = array licon in=pd left_of=gn       # X (M5 source)
  d5  = array licon in=pd right_of=gn      # VPWR (M5 drain)
  s1l = enclose s1 li
  d1l = enclose d1 li net=n1
  s3l = enclose s3 li
  d3l = enclose d3 li net=n1
  s5l = enclose s5 li net=X
  d5l = enclose d5 li
  pwr1 = strap li from=s1l to=vpwr_li
  pwr3 = strap li from=s3l to=vpwr_li
  pwr5 = strap li from=d5l to=vpwr_li
  x5   = strap li from=s5l to=d0l net=X    # M5 source X to M0 source/drain X

  # gate contacts (n-row items only for cb), on their own gates
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

  # supply straps
  gndp = strap li from=s1l to=vpwr_li   # placeholder, replaced below
  # (s1l/s3l already strapped to vpwr; dn/d0 to vgnd)

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
