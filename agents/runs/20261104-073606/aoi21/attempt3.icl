pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=7 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  dw  = 4*L + 1.36
  nd  = rect diff w=dw h=WN cx=cell.cx above=ptap
  pd  = rect diff w=dw h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265) yspan=(nd.bottom, pd.top)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + 0.28) yspan=(nd.bottom, pd.top)
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + 0.28) yspan=(nd.bottom, pd.top)

  # n-row: VGND | n1 | Y | VGND  (gates A2, A1, B1)
  sn2 = array licon in=nd left_of=ga2
  sn1 = array licon in=nd right_of=ga2
  sy1 = array licon in=nd right_of=ga1
  sv3 = array licon in=nd right_of=gb1
  sn2l = enclose sn2 li
  sn1l = enclose sn1 li
  sy1l = enclose sy1 li net=Y
  sv3l = enclose sv3 li
  gndn = strap li from=sn2l to=vgnd_li
  gndn2 = strap li from=sv3l to=vgnd_li

  # p-row: n2 | VPWR | n2 | Y  (gates A2, A1, B1)
  pn2a = array licon in=pd left_of=ga2
  ppw  = array licon in=pd right_of=ga2
  pn2b = array licon in=pd right_of=ga1
  py2  = array licon in=pd right_of=gb1
  pn2al = enclose pn2a li net=n2
  ppwl = enclose ppw li
  pn2bl = enclose pn2b li net=n2
  py2l = enclose py2 li net=Y
  pwr1 = strap li from=ppwl to=vpwr_li
  n2st = strap li from=pn2al to=pn2bl cy=pn2al.cy net=n2

  cb = max(nd.top + 0.19, sn2l.top + 0.25, sn1l.top + 0.25, sy1l.top + 0.25,
           sv3l.top + 0.25, pn2al.top + 0.25, ppwl.top + 0.25, pn2bl.top + 0.25,
           py2l.top + 0.25)
  gca2 = contact licon cx=(ga2.cx - 0.1) bottom=cb
  gca1 = contact licon cx=(ga1.cx)       bottom=cb
  gcb1 = contact licon cx=(gb1.cx + 0.1) bottom=cb
  pa2 = enclose gca2 poly by=minx
  pa1 = enclose gca1 poly by=minx
  pb1 = enclose gcb1 poly by=minx
  na2 = enclose [gca2, gca1, gcb1] npc
  a2  = enclose gca2 li net=A2
  a1  = enclose gca1 li net=A1
  b1  = enclose gcb1 li net=B1
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  a2m = contact mcon in=a2
  a2p = enclose a2m m1 by=0.06 net=A2
  a1m = contact mcon in=a1
  a1p = enclose a1m m1 by=0.06 net=A1
  b1m = contact mcon in=b1
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=sy1l cy=(sy1l.top - 0.3)
  yp  = enclose ym m1 by=0.06 net=Y

  port A2 in  on=a2p
  port A1 in  on=a1p
  port B1 in  on=b1p
  port Y  out on=yp
end
