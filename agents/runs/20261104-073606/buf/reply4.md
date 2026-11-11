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
  gn  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  sn1 = array licon in=nd left_of=ga          # n1 (MN1 drain)
  svn = array licon in=nd right_of=ga left_of=gn   # VGND (MN1 src, MN2 src)
  sxn = array licon in=nd right_of=gn         # X (MN2 drain)
  sp1 = array licon in=pd left_of=ga          # n1 (MP1 drain)
  svp = array licon in=pd right_of=ga left_of=gn   # VPWR (MP1 src, MP2 src)
  sxp = array licon in=pd right_of=gn         # X (MP2 drain)
  sn1l = enclose [sn1, sp1] li net=n1
  svnl = enclose svn li net=VGND
  svpl = enclose svp li net=VPWR
  sxnl = enclose sxn li net=X
  sxpl = enclose sxp li net=X
  gnd  = strap li from=svnl to=vgnd_li
  pwr  = strap li from=svpl to=vpwr_li
  xj   = strap li from=sxnl to=sxpl net=X

  cb   = max(nd.top + 0.19, sn1l.top + 0.25, sxnl.top + 0.25, svnl.top + 0.25)
  gca  = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcn  = contact licon cx=(gn.cx + 0.1) bottom=cb
  gpa  = enclose gca poly by=minx
  gpn  = enclose gcn poly by=minx
  gna  = enclose gca npc
  gnn  = enclose gcn npc
  al   = enclose gca li net=A
  nl   = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am   = contact mcon in=al
  ap   = enclose am m1 by=0.06 net=A
  nm   = contact mcon in=nl
  np   = enclose nm m1 by=0.06 net=n1
  xm   = contact mcon in=sxnl cy=(sxnl.top - 0.3)
  xp   = enclose xm m1 by=0.06 net=X
  n1m  = contact mcon in=sn1l
  n1p  = enclose n1m m1 by=0.06 net=n1
  route n1 layers=m1

  port A in  on=ap
  port X out on=xp
end
```