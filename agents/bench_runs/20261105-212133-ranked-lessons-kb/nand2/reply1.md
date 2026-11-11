```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=4 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  gap = max(0.28, 0.54 - L)
  dw  = 2*0.265 + 2*L + gap
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb = cross [nd, pd] poly w=L left=(ga.right + gap)

  sn  = array licon in=nd left_of=ga     # Y (M3 source)
  dn  = array licon in=nd right_of=gb    # VGND (M2 drain)
  sp  = array licon in=pd left_of=ga     # VPWR (M0 source)
  my  = array licon in=pd right_of=ga    # Y (M0 drain / M1 source)
  s2  = array licon in=pd right_of=gb    # VPWR (M1 drain)

  snl = enclose sn li
  dnl = enclose dn li
  spl = enclose sp li
  myl = enclose my li net=Y
  s2l = enclose s2 li

  gnd = strap li from=snl to=vgnd_li
  p1  = strap li from=spl to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li
  yst = strap li from=dnl to=myl net=Y

  cb = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gn  = enclose [gca, gcb] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B

  route n1 layers=m1,m2
  route Y layers=m1,m2

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  ym  = contact mcon in=myl
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
```