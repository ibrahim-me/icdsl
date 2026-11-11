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

  nd  = rect diff w=(5*L + 4*0.28) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(5*L + 4*0.28) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # n row: VGND -A- n1 -B- VGND -n1- X -B- n4 -A- VGND
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + 0.28)
  gn1 = cross [nd, pd] poly w=L left=(gb.right + 0.28)
  gb2 = cross [nd, pd] poly w=L left=(gn1.right + 0.28)
  ga2 = cross [nd, pd] poly w=L left=(gb2.right + 0.28)

  sn  = array licon in=nd left_of=ga
  dn1 = array licon in=nd right_of=ga
  dn1b= array licon in=nd left_of=gb
  dvg = array licon in=nd right_of=gb
  dvgn= array licon in=nd left_of=gn1
  dx  = array licon in=nd right_of=gn1
  dxb = array licon in=nd left_of=gb2
  dn4 = array licon in=nd right_of=gb2
  dn4b= array licon in=nd left_of=ga2
  dvg2= array licon in=nd right_of=ga2

  snl = enclose sn li
  n1l = enclose [dn1, dn1b] li net=n1
  vgl = enclose [dvg, dvgn] li net=VGND
  xl  = enclose [dx, dxb] li net=X
  n4l = enclose [dn4, dn4b] li net=n4
  vgl2= enclose dvg2 li net=VGND

  gnd = strap li from=snl to=vgnd_li
  gnd2= strap li from=vgl to=vgnd_li
  gnd3= strap li from=vgl2 to=vgnd_li

  # p row: X -n1- n2 -B- VPWR -A- n3 -B- n1 -A- VPWR
  sx  = array licon in=pd left_of=ga
  dn2 = array licon in=pd right_of=ga
  dn2b= array licon in=pd left_of=gb
  dpw = array licon in=pd right_of=gb
  dpwb= array licon in=pd left_of=gn1
  dn3 = array licon in=pd right_of=gn1
  dn3b= array licon in=pd left_of=gb2
  dn1p= array licon in=pd right_of=gb2
  dn1pb=array licon in=pd left_of=ga2
  dpw2= array licon in=pd right_of=ga2

  xl2 = enclose [sx] li net=X
  n2l = enclose [dn2, dn2b] li net=n2
  pwl = enclose [dpw, dpwb] li net=VPWR
  n3l = enclose [dn3, dn3b] li net=n3
  n1p = enclose [dn1p, dn1pb] li net=n1
  pwl2= enclose dpw2 li net=VPWR

  pwr = strap li from=pwl to=vpwr_li
  pwr2= strap li from=pwl2 to=vpwr_li

  # gate contacts in the gap between the rows
  cb  = max(nd.top + 0.19, snl.top + 0.25, n1l.top + 0.25, xl.top + 0.25, n4l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcn = contact licon cx=(gn1.cx - 0.1) bottom=cb
  gcb2= contact licon cx=(gb2.cx + 0.1) bottom=cb
  gca2= contact licon cx=(ga2.cx - 0.1) bottom=cb

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
  xm  = contact mcon in=xl cy=(xl.top - 0.3)
  xp  = enclose xm m1 by=0.06 net=X

  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```