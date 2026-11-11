```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=7 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  gpitch = 0.54 - L
  dw  = 0.265 + L + gpitch + L + gpitch + L + 0.265
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gpitch)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gpitch)

  # n-row: VGND | A | Y | B | VGND | C | Y  (three parallel nMOS Y->VGND)
  sn  = array licon in=nd left_of=ga
  dn  = array licon in=nd right_of=ga net=Y
  sv  = array licon in=nd right_of=gb
  sy  = array licon in=nd right_of=gc net=Y
  snl = enclose sn li net=VGND
  dnl = enclose dn li net=Y
  svl = enclose sv li net=VGND
  syl = enclose sy li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li

  # p-row: VPWR | A | n1 | B | n2 | C | Y  (series pMOS VPWR->Y)
  sp  = array licon in=pd left_of=ga
  sn2 = array licon in=pd right_of=gb net=n1
  sn3 = array licon in=pd right_of=gc net=n2
  spl = enclose sp li net=VPWR
  n1l = enclose sn2 li net=n1
  n2l = enclose sn3 li net=n2
  pwr = strap li from=spl to=vpwr_li
  n1s = strap li from=n1l to=n2l net=n1

  # gate contacts on their own gates, all in the gap between the rows (no stagger)
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # output Y: n-side drain after C joins p-side drain after C (same column)
  yst = strap li from=syl to=n2l net=Y

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=n2l
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```