pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=3 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  nd  = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  g   = cross [nd, pd] poly w=L
  sn  = array licon in=nd left_of=g
  dn  = array licon in=nd right_of=g
  sp  = array licon in=pd left_of=g
  dp  = array licon in=pd right_of=g
  snl = enclose sn li
  dnl = enclose dn li
  spl = enclose sp li
  dpl = enclose dp li
  gnd = strap li from=snl to=vgnd_li
  pwr = strap li from=spl to=vpwr_li
  y   = strap li from=dnl to=dpl net=Y
  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gc  = contact licon left_of=y xspace=0.17 bottom=cb
  gp  = enclose gc poly by=minx
  gn  = enclose gc npc
  a   = enclose gc li net=A
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)
  am  = contact mcon in=a
  ap  = enclose am m1 by=0.06 net=A
  ym  = contact mcon in=y cy=(y.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y
  port A in  on=ap
  port Y out on=yp
end
