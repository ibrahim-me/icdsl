pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell nor3 width=6 height=H
  device M0 nmos w=WN l=L d=Y g=A s=VGND
  device M1 nmos w=WN l=L d=VGND g=B s=Y
  device M2 pmos w=WP l=L d=n1 g=A s=VPWR
  device M3 nmos w=WN l=L d=Y g=C s=VGND
  device M4 pmos w=WP l=L d=Y g=C s=n2
  device M5 pmos w=WP l=L d=n2 g=B s=n1

  gg  = max(0.28, 0.54 - L)             # gate gap: keeps poly contact pads >= 0.21 apart
  dw  = 0.53 + 3*L + 2*gg               # 2 end cols + 3 gates + 2 gate gaps
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L left=(ga.right + gg)
  gc  = cross [nd, pd] poly w=L left=(gb.right + gg)

  # n-row: VGND | A | Y | B | VGND | C | Y
  sn  = array licon in=nd left_of=ga            # VGND (M0 source)
  dn  = array licon in=nd right_of=ga           # Y   (M0 drain / M1 source)
  sv  = array licon in=nd right_of=gb           # VGND (M1 drain / M3 source)
  sy  = array licon in=nd right_of=gc gap=0.30  # Y   (M3 drain), clear of C gate pad
  snl = enclose sn li net=VGND
  dnl = enclose dn li net=Y
  svl = enclose sv li net=VGND
  syl = enclose sy li net=Y
  gnd = strap li from=snl to=vgnd_li
  gnd2 = strap li from=svl to=vgnd_li

  # p-row: VPWR | A | n1 | B | n2 | C | Y
  sp  = array licon in=pd left_of=ga            # VPWR (M2 source)
  sy2 = array licon in=pd right_of=gc gap=0.30  # Y   (M4 drain), clear of C gate pad
  spl = enclose sp li net=VPWR
  syl2= enclose sy2 li net=Y
  pwr = strap li from=spl to=vpwr_li

  # gate contacts on their own gates, staggered vertically so poly pads clear
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, svl.top + 0.25, syl.top + 0.25)
  gca = contact licon cx=ga.cx bottom=cb
  gcb = contact licon cx=gb.cx bottom=(cb + 0.30)
  gcc = contact licon cx=gc.cx bottom=(cb + 0.60)
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gn  = enclose [gca, gcb, gcc] npc
  a   = enclose gca li net=A
  b   = enclose gcb li net=B
  c   = enclose gcc li net=C
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # Y: n-col after C and p-col after C line up; middle n-col (dn) joins via m1/m2 route
  yst = strap li from=syl to=syl2 net=Y
  route Y layers=m1,m2

  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  bm  = contact mcon in=b
  bp  = enclose bm m1 by=0.06 net=B
  cm  = contact mcon in=c
  cp  = enclose cm m1 by=0.06 net=C
  ym  = contact mcon in=syl2
  yp  = enclose ym m1 by=0.06 net=Y

  port A in  on=ap
  port B in  on=bp
  port C in  on=cp
  port Y out on=yp
end
