```icl
pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell buf width=6 height=H
  device MN1 nmos w=WN l=L d=n1 g=A s=VGND
  device MP1 pmos w=WP l=L d=n1 g=A s=VPWR
  device MN2 nmos w=WN l=L d=X g=n1 s=VGND
  device MP2 pmos w=WP l=L d=X g=n1 s=VPWR

  dw  = 2*L + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn1 = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn1 = array licon in=nd left_of=ga
  mn1 = array licon in=nd right_of=ga left_of=gn1
  sxn = array licon in=nd right_of=gn1
  sp1 = array licon in=pd left_of=ga
  mp1 = array licon in=pd right_of=ga left_of=gn1
  sxp = array licon in=pd right_of=gn1
  sn1l = enclose sn1 li
  mn1l = enclose mn1 li net=n1
  sxnl = enclose sxn li net=X
  sp1l = enclose sp1 li
  mp1l = enclose mp1 li net=n1
  sxpl = enclose sxp li net=X
  gnd = strap li from=sn1l to=vgnd_li
  pwr = strap li from=sp1l to=vpwr_li

  cb = max(nd.top + 0.19, sn1l.top + 0.25, mn1l.top + 0.25, sxnl.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcn = contact licon cx=(gn1.cx + 0.1) bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gnn = enclose gcn npc
  a   = enclose gca li net=A
  n1g = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  mn1m = contact mcon in=mn1l cx=mn1l.cx
  mn1p = enclose mn1m m1 by=0.06 net=n1
  mp1m = contact mcon in=mp1l cx=mp1l.cx
  mp1p = enclose mp1m m1 by=0.06 net=n1
  n1m  = contact mcon in=n1g cx=n1g.cx
  n1p  = enclose n1m m1 by=0.06 net=n1
  route n1 layers=m1

  xnm = contact mcon in=sxnl cx=sxnl.cx
  xnp = enclose xnm m1 by=0.06 net=X
  xpm = contact mcon in=sxpl cx=sxpl.cx
  xpp = enclose xpm m1 by=0.06 net=X
  route X layers=m1

  am  = contact mcon in=a cx=a.cx
  ap  = enclose am m1 by=0.06 net=A

  port A in  on=ap
  port X out on=xnp
end
```