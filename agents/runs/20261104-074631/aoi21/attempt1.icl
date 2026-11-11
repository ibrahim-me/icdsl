pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=7 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  dw  = 2*L + 0.81
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  ga  = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  gb  = cross [nd, pd] poly w=L right=(nd.right - 0.265)
  gc  = cross [nd, pd] poly w=L cx=cell.cx

  sn  = array licon in=nd left_of=ga            # Y | n1 | VGND | Y
  dn  = array licon in=nd right_of=gb
  s1  = array licon in=pd left_of=ga            # n2 | VPWR | n2 | Y
  my  = array licon in=pd right_of=ga
  s2  = array licon in=pd right_of=gb
  snl = enclose sn li
  dnl = enclose dn li net=Y
  s1l = enclose s1 li
  myl = enclose my li net=Y
  s2l = enclose s2 li net=n2
  gnd = strap li from=snl to=vgnd_li
  p1  = strap li from=s1l to=vpwr_li
  p2  = strap li from=s2l to=vpwr_li

  cb  = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s1l.top + 0.25, myl.top + 0.25, s2l.top + 0.25)
  gca = contact licon cx=(ga.cx - 0.1) bottom=cb
  gcb = contact licon cx=(gb.cx + 0.1) bottom=cb
  gcc = contact licon cx=gc.cx bottom=cb
  gpa = enclose gca poly by=minx
  gpb = enclose gcb poly by=minx
  gpc = enclose gcc poly by=minx
  gna = enclose [gca, gcb, gcc] npc
  a1  = enclose gca li net=A1
  a2  = enclose gcb li net=A2
  b1  = enclose gcc li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=dnl
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out on=yp
end
