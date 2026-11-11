```icl
pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell buf width=6 height=H
  device MN1 nmos w=WN l=L d=n1 g=A s=VGND
  device MP1 pmos w=WP l=L d=n1 g=A s=VPWR
  device MN2 nmos w=WN l=L d=X g=n1 s=VGND
  device MP2 pmos w=WP l=L d=X g=n1 s=VPWR

  nd  = rect diff w=(3*L + 1.59) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(3*L + 1.59) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gn  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn1 = array licon in=nd left_of=ga
  sm  = array licon in=nd right_of=ga left_of=gn
  sxn = array licon in=nd right_of=gn
  sp1 = array licon in=pd left_of=ga
  smp = array licon in=pd right_of=ga left_of=gn
  sxp = array licon in=pd right_of=gn
  sn1l = enclose sn1 li net=n1
  sml  = enclose sm li
  sxnl = enclose sxn li net=X
  sp1l = enclose sp1 li
  smpl = enclose smp li
  sxpl = enclose sxp li net=X
  gnd  = strap li from=sml to=vgnd_li
  pwr  = strap li from=smpl to=vpwr_li
  xj   = strap li from=sxnl to=sxpl net=X

  cb   = max(nd.top + 0.19, sn1l.top + 0.25, sxnl.top + 0.25)
  gca  = contact licon cx=ga.cx bottom=cb
  gcn  = contact licon cx=gn.cx bottom=cb
  gpa  = enclose gca poly by=minx
  gpn  = enclose gcn poly by=minx
  gna  = enclose [gca, gcn] npc
  al   = enclose gca li net=A
  nl   = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am   = contact mcon in=al
  ap   = enclose am m1 by=0.06 net=A
  nm   = contact mcon in=nl
  np   = enclose nm m1 by=0.06 net=n1
  xm   = contact mcon in=sxnl cy=(sxnl.top - 0.3)
  xp   = enclose xm m1 by=0.06 net=X
  route n1 layers=m1

  port A in  on=ap
  port X out on=xp
end
```