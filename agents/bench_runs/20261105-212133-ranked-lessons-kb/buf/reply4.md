```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  gapg = max(0.28, 0.54 - L)          # gate pitch >= 0.54 so poly pads keep 0.21
  dw   = 0.53 + 2*L + gapg            # 2 end contacts + 2 gates + inter-gate gap
  nd   = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm
  # both rows left->right: X | g(n1) | supply | g(A) | n1
  gn1  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga   = cross [nd, pd] poly w=L left=(gn1.right + gapg)

  sn   = array licon in=nd left_of=gn1
  sp   = array licon in=pd left_of=gn1
  cn   = array licon in=nd cx=(gn1.cx + ga.cx)/2
  cp   = array licon in=pd cx=(gn1.cx + ga.cx)/2
  dn   = array licon in=nd right_of=ga
  dp   = array licon in=pd right_of=ga
  snl  = enclose sn li net=X
  spl  = enclose sp li net=X
  cnl  = enclose cn li
  cpl  = enclose cp li
  dnl  = enclose dn li net=n1
  dpl  = enclose dp li net=n1
  xst  = strap li from=snl to=spl
  gnd  = strap li from=cnl to=vgnd_li
  pwr  = strap li from=cpl to=vpwr_li
  n1s  = strap li from=dnl to=dpl

  cb   = max(nd.top + 0.19, snl.top + 0.25, cnl.top + 0.25, dnl.top + 0.25)
  gca  = contact licon cx=ga.cx   bottom=cb
  gcn  = contact licon cx=gn1.cx  bottom=cb
  gpa  = enclose gca poly by=minx
  gpn  = enclose gcn poly by=minx
  gn   = enclose [gca, gcn] npc
  aa   = enclose gca li net=A
  nn   = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am   = contact mcon in=aa
  ap   = enclose am m1 by=0.06 net=A
  nm   = contact mcon in=nn
  np   = enclose nm m1 by=0.06 net=n1
  xm   = contact mcon in=snl
  xp   = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
```