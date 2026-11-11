```icl
pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nand3 width=6 height=H
  device M0 pmos w=WP l=L d=VPWR g=A s=Y
  device M1 nmos w=WN l=L d=n1 g=B s=n2
  device M2 nmos w=WN l=L d=VGND g=C s=n1
  device M3 nmos w=WN l=L d=n2 g=A s=Y
  device M4 pmos w=WP l=L d=VPWR g=C s=Y
  device M5 pmos w=WP l=L d=Y g=B s=VPWR

  gap = max(0.28, 0.54 - L)
  dw  = 2*0.265 + 3*L + 2*gap
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gap)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gap)

  # n-side: Y | A | n2 | B | n1 | C | VGND
  sn  = array licon in=nd left_of=ga   net=Y
  sv  = array licon in=nd right_of=gc  net=VGND
  snl = enclose sn li net=Y
  dvl = enclose sv li
  gnd = strap li from=dvl to=vgnd_li

  # p-side: VPWR | A | Y | B | Y | C | VPWR
  sp1 = array licon in=pd left_of=ga   net=VPWR
  sy1 = array licon in=pd right_of=ga  net=Y
  sy2 = array licon in=pd right_of=gb  net=Y
  sp2 = array licon in=pd right_of=gc  net=VPWR
  sp1l = enclose sp1 li net=VPWR
  sy1l = enclose sy1 li net=Y
  sy2l = enclose sy2 li net=Y
  sp2l = enclose sp2 li net=VPWR
  pwr1 = strap li from=sp1l to=vpwr_li
  pwr2 = strap li from=sp2l to=vpwr_li

  cb = max(nd.top + 0.19, snl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=a
  ap = enclose am m1 by=0.06 net=A
  bm = contact mcon in=b
  bp = enclose bm m1 by=0.06 net=B
  cm = contact mcon in=c
  cp = enclose cm m1 by=0.06 net=C
  ym = contact mcon in=sy1l
  yp = enclose ym m1 by=0.06 net=Y
  route Y layers=m1,m2

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
```