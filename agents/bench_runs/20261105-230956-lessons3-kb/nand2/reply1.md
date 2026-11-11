```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand2 width=6 height=H
  device M0 pmos w=WP l=L d=Y g=A s=VPWR
  device M1 pmos w=WP l=L d=VPWR g=B s=Y
  device M2 nmos w=WN l=L d=VGND g=B s=n1
  device M3 nmos w=WN l=L d=n1 g=A s=Y

  pitch = max(L + 0.28, 0.54)
  dw    = 2*0.265 + 2*L + (pitch - L)
  nd    = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd    = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim   = enclose nd nsdm
  pim   = enclose pd psdm
  ga    = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb    = cross [nd, pd] poly w=L left=(ga.right + (pitch - L))

  sn    = array licon in=nd left_of=ga          # Y (n-side)
  dn    = array licon in=nd right_of=gb         # VGND
  s1    = array licon in=pd left_of=ga          # VPWR
  my    = array licon in=pd between=[ga, gb]    # Y (p-side)
  s2    = array licon in=pd right_of=gb         # VPWR
  snl   = enclose sn li net=Y
  dnl   = enclose dn li
  s1l   = enclose s1 li
  myl   = enclose my li net=Y
  s2l   = enclose s2 li
  gnd   = strap li from=dnl to=vgnd_li
  p1    = strap li from=s1l to=vpwr_li
  p2    = strap li from=s2l to=vpwr_li

  cb    = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gca   = contact licon cx=ga.cx bottom=cb
  gcb   = contact licon cx=gb.cx bottom=cb
  gpa   = enclose gca poly by=minx net=A
  gpb   = enclose gcb poly by=minx net=B
  gn    = enclose [gca, gcb] npc
  al    = enclose gca li net=A
  bl    = enclose gcb li net=B
  well  y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  route Y layers=m1,m2

  am    = contact mcon in=al
  ap    = enclose am m1 by=0.06 net=A
  bm    = contact mcon in=bl
  bp    = enclose bm m1 by=0.06 net=B
  ym    = contact mcon in=myl cy=(pd.cy)
  yp    = enclose ym m1 by=0.06 net=Y
  port A in  on=ap
  port B in  on=bp
  port Y out on=yp
end
```