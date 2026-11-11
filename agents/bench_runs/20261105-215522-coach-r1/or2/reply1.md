```icl
pdk sky130A
param WN=0.49 WN2=0.42 WP=0.75 WP2=0.42 L=0.15 H=2.72

stdcell or2 width=9 height=H
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR
  device M1 nmos w=WN l=L d=VGND g=n2 s=X
  device M2 nmos w=WN2 l=L d=VGND g=B s=n2
  device M3 nmos w=WN2 l=L d=n2 g=A s=VGND
  device M4 pmos w=WP2 l=L d=n2 g=B s=n1
  device M5 pmos w=WP l=L d=VPWR g=n2 s=X

  gapg = max(0.28, 0.60 - L)
  ndw  = 3*L + 2*0.265 + 2*gapg
  nd   = rect diff w=ndw h=WN cx=cell.cx above=ptap
  pd   = rect diff w=ndw h=WP cx=cell.cx below=ntap
  nim  = enclose nd nsdm
  pim  = enclose pd psdm
  # gate order left->right: n2, A, B  (pitch >= 0.60 so poly contact pads clear)
  gn2  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga   = cross [nd, pd] poly w=L left=(gn2.right + gapg)
  gb   = cross [nd, pd] poly w=L left=(ga.right + gapg)
  # n-diff columns: c0=X c1=VGND c2=n2 c3=VGND
  dxn  = array licon in=nd left_of=gn2
  dvn  = array licon in=nd right_of=gn2 left_of=ga
  dn2n = array licon in=nd right_of=ga left_of=gb
  dvn2 = array licon in=nd right_of=gb
  # p-diff columns: c0=X c1=VPWR c2=n1 c3=n2
  dxp  = array licon in=pd left_of=gn2
  dvp  = array licon in=pd right_of=gn2 left_of=ga
  dn1p = array licon in=pd right_of=ga left_of=gb
  dn2p = array licon in=pd right_of=gb
  dxnl = enclose dxn li net=X
  dvnl = enclose dvn li
  dn2nl= enclose dn2n li net=n2
  dvn2l= enclose dvn2 li
  dxpl = enclose dxp li net=X
  dvpl = enclose dvp li
  dn1pl= enclose dn1p li net=n1
  dn2pl= enclose dn2p li net=n2
  xst  = strap li from=dxnl to=dxpl net=X
  gnd1 = strap li from=dvnl to=vgnd_li
  gnd2 = strap li from=dvn2l to=vgnd_li
  pwr1 = strap li from=dvpl to=vpwr_li
  route n2 layers=m1,m2
  # gate contacts in gap between rows, on their own gate lines (n-row items only in cb)
  cb   = max(nd.top + 0.19, dxnl.top + 0.25, dvnl.top + 0.25, dn2nl.top + 0.25, dvn2l.top + 0.25)
  gn2c = contact licon cx=(gn2.cx + 0.13) bottom=cb
  gac  = contact licon cx=(ga.cx + 0.13) bottom=cb
  gbc  = contact licon cx=(gb.cx + 0.13) bottom=cb
  gn2p = enclose gn2c poly by=minx
  gap  = enclose gac poly by=minx
  gbp  = enclose gbc poly by=minx
  gn   = enclose [gn2c, gac, gbc] npc
  an2  = enclose gn2c li net=n2
  aa   = enclose gac li net=A
  ab   = enclose gbc li net=B
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # input ports on met1
  bm   = contact mcon in=ab
  bp   = enclose bm m1 by=0.06 net=B
  am   = contact mcon in=aa
  ap   = enclose am m1 by=0.06 net=A
  # output X on met1 (n-side and p-side X straps already joined)
  xm   = contact mcon in=dxnl
  xp   = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port B in  on=bp
  port X out on=xp
end
```