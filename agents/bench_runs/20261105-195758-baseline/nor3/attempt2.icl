pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=7 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  dw  = 3*L + 1.09
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L cx=cell.cx
  gc  = cross [nd, pd] poly w=L right=(nd.right - 0.265)

  # n row: Y | A | VGND | B | Y | C | VGND  (three parallel pulldowns Y-VGND)
  dn0 = array licon in=nd left_of=ga
  dn1 = array licon in=nd right_of=ga left_of=gb
  dn2 = array licon in=nd right_of=gb left_of=gc
  dn3 = array licon in=nd right_of=gc
  dn0l = enclose dn0 li net=Y
  dn1l = enclose dn1 li
  dn2l = enclose dn2 li net=Y
  dn3l = enclose dn3 li
  y1  = strap li from=dn0l to=dn2l net=Y
  gnd = strap li from=dn1l to=vgnd_li
  gnd2= strap li from=dn3l to=vgnd_li

  # p row: VPWR | A | n1 | B | n2 | C | Y  (series pullup chain)
  sp  = array licon in=pd left_of=ga
  m1  = array licon in=pd right_of=ga left_of=gb
  m2  = array licon in=pd right_of=gb left_of=gc
  dy  = array licon in=pd right_of=gc
  spl = enclose sp li
  m1l = enclose m1 li
  m2l = enclose m2 li
  dyl = enclose dy li net=Y
  pwr = strap li from=spl to=vpwr_li
  n1s = strap li from=m1l to=m2l net=n1
  y2  = strap li from=dyl to=dn0l net=Y

  # gate contacts on each gate line, fanned out so poly pads clear each other
  cb  = max(nd.top + 0.19, dn0l.top + 0.25, dn1l.top + 0.25, dn2l.top + 0.25, dn3l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.13) bottom=cb
  gcb = contact licon cx=gb.cx bottom=cb
  gcc = contact licon cx=(gc.cx + 0.13) bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=dyl cy=(dyl.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
