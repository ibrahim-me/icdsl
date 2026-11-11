```icl
pdk sky130A
param WN=0.42 WP=0.59 L=0.15 H=2.72

stdcell buf width=6 height=H
  device M0 nmos w=WN l=L d=VGND g=n1 s=X
  device M1 pmos w=WP l=L d=n1 g=A s=VPWR
  device M2 nmos w=WN l=L d=n1 g=A s=VGND
  device M3 pmos w=WP l=L d=VPWR g=n1 s=X

  dw  = 2*L + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  # n-row: X | M0(g=n1) | VGND | M2(g=A) | n1
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)          # gate A (M2 n, M1 p)
  gn1 = cross [nd, pd] poly w=L left=(ga.right + 0.28)           # gate n1 (M0 n, M3 p), contact column between gates
  sn  = array licon in=nd left_of=ga                             # X contact (M0 source)
  cn  = array licon in=nd right_of=ga left_of=gn1                # VGND contact (M0 drain = M2 source)
  dn  = array licon in=nd right_of=gn1                           # n1 contact (M2 drain)
  sp  = array licon in=pd left_of=ga                             # n1 contact (M1 drain)
  cp  = array licon in=pd right_of=ga left_of=gn1                # VPWR contact (M1 source = M3 drain)
  dp  = array licon in=pd right_of=gn1                           # X contact (M3 source)
  snl = enclose sn li net=X
  cnl = enclose cn li
  dnl = enclose dn li net=n1
  spl = enclose sp li net=n1
  cpl = enclose cp li
  dpl = enclose dp li net=X
  gnd = strap li from=cnl to=vgnd_li
  pwr = strap li from=cpl to=vpwr_li
  route n1 layers=m1,m2                                          # joins n-row and p-row n1 drains
  route X  layers=m1,m2                                          # joins n-row and p-row X drains
  # gate contacts in the gap between the rows
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=ga.cx  bottom=cb
  gcn = contact licon cx=gn1.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpn = enclose gcn poly by=minx
  gn  = enclose [gca, gcn] npc
  aa  = enclose gca li net=A
  nn  = enclose gcn li net=n1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  # ports on met1
  am  = contact mcon in=aa
  ap  = enclose am m1 by=0.06 net=A
  nm  = contact mcon in=nn
  np  = enclose nm m1 by=0.06 net=n1
  xm  = contact mcon in=dpl
  xp  = enclose xm m1 by=0.06 net=X
  port A in  on=ap
  port X out on=xp
end
```