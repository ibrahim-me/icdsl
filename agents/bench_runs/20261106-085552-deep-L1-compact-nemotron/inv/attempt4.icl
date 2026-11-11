pdk sky130A
param WN=0.49 WP=0.75 L=0.15 H=2.72

stdcell inv width=2 height=H
  device M0 nmos w=WN l=L d=VGND g=A s=Y
  device M1 pmos w=WP l=L d=VPWR g=A s=Y

  nd = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  pd = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  g = cross [nd, pd] poly w=L

  sn = array licon in=nd left_of=g      # n source = Y
  dn = array licon in=nd right_of=g     # n drain = VGND
  sp = array licon in=pd left_of=g      # p source = Y
  dp = array licon in=pd right_of=g     # p drain = VPWR

  snl = enclose sn li net=Y
  dnl = enclose dn li net=VGND
  spl = enclose sp li net=Y
  dpl = enclose dp li net=VPWR

  y = strap li from=snl to=spl net=Y
  gnd = strap li from=dnl to=vgnd_li
  pwr = strap li from=dpl to=vpwr_li
  tapg = strap li from=ptap to=vgnd_li
  tapp = strap li from=ntap to=vpwr_li

  cb = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25)
  gc = contact licon cx=(g.cx + 0.13) bottom=cb
  gp = enclose gc poly by=minx
  gn = enclose gc npc
  a = enclose gc li net=A

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  am = contact mcon in=a cy=(a.bottom + 0.1)
  ap = enclose am m1 by=0.06 net=A
  ym = contact mcon in=y cy=(y.top - 0.2)
  yp = enclose ym m1 by=0.06 net=Y

  port A in on=ap
  port Y out on=yp
end
