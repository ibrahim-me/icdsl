```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell xor2 width=10 height=H
  device M0 nmos w=WN l=L d=n1 g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=n1
  device M2 nmos w=WN l=L d=X g=n1 s=VGND
  device M3 pmos w=WP l=L d=n2 g=B s=VPWR
  device M4 pmos w=WP l=L d=VPWR g=A s=n2
  device M5 pmos w=WP l=L d=n1 g=B s=n3
  device M6 pmos w=WP l=L d=n3 g=A s=VPWR
  device M7 nmos w=WN l=L d=n4 g=B s=X
  device M8 pmos w=WP l=L d=n2 g=n1 s=X
  device M9 nmos w=WN l=L d=VGND g=A s=n4

  dw  = 5*L + 4*0.28 + 2*0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # n row: VGND -A- n1 -B- VGND -n1- X -B- n4 -A- VGND  (one contact per shared column)
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gn1 = cross [nd, pd] poly w=L left=(gb.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(gn1.right + 0.28)
  ga2 = cross [nd, pd] poly w=L left=(gb2.right + 0.28)

  sn  = array licon in=nd left_of=ga
  n1l = array licon in=nd between=[ga, gb]
  vgl = array licon in=nd between=[gb, gn1]
  xl  = array licon in=nd between=[gn1, gb2]
  n4l = array licon in=nd between=[gb2, ga2]
  vgr = array licon in=nd right_of=ga2

  snl = enclose sn li
  n1ln= enclose n1l li net=n1
  vgln= enclose vgl li net=VGND
  xln = enclose xl li net=X
  n4ln= enclose n4l li net=n4
  vgrn= enclose vgr li net=VGND

  gndl= strap li from=snl to=vgnd_li
  gndc= strap li from=vgln to=vgnd_li
  gndr= strap li from=vgrn to=vgnd_li

  # p row: VPWR -B- n2 -n1- X -B- n1 -A- n3 -A- VPWR  (col2 n2 series M3/M8, no contact)
  sx  = array licon in=pd left_of=ga
  dn2 = array licon in=pd right_of=ga
  dpw = array licon in=pd right_of=gb
  dpwb= array licon in=pd left_of=gn1
  dn3 = array licon in=pd right_of=gn1
  dn3b= array licon in=pd left_of=gb2
  dpw2= array licon in=pd right_of=gb2

  pwl = enclose [dn2, dpw, dpwb] li net=n2
  p1  = enclose sx li net=VPWR
  p2  = enclose dpw2 li net=VPWR
  n3l = enclose [dn3, dn3b] li net=n3

  pwrl= strap li from=p1 to=vpwr_li
  pwrr= strap li from=p2 to=vpwr_li

  # gate contacts on gate centerlines (keeps licon spacing legal)
  cb  = max(nd.top + 0.19, snl.top + 0.25, n1ln.top + 0.25, xln.top + 0.25, n4ln.top + 0.25, pwl.top + 0.25, n3l.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcn = contact licon cx=gn1.cx bottom=cb
  gcb2= contact licon cx=gb2.cx bottom=cb
  gca2= contact licon cx=ga2.cx bottom=cb

  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpn = enclose gcn poly by=minx
  gpb2= enclose gcb2 poly by=minx
  gpa2= enclose gca2 poly by=minx

  gna = enclose [gca, gcb, gcn, gcb2, gca2] npc

  aa  = enclose gca li net=A
  bb  = enclose gcb li net=B
  nn  = enclose gcn li net=n1
  bb2 = enclose gcb2 li net=B
  aa2 = enclose gca2 li net=A

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=bb
  bp  = enclose bm m1 by=0.06 net=B
  xm  = contact mcon in=xln cy=(xln.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X

  route n2 layers=m1
  route n3 layers=m1

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```