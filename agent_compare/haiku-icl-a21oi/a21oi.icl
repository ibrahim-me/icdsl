# a21oi: Y = !((A1 & A2) | B1), SKY130A, level-1 stdcell
# Gates A2 | A1 | B1 at x = -0.9 | 0 | +0.9 (cell centre). nmos: VGND A2 n1 A1 Y B1 VGND.
# pmos: n2 A2 VPWR A1 n2 B1 Y. Y leaves the nmos row between A1 and B1, runs right
# along the middle of the gap and climbs to the pmos Y contact at the right end.
pdk sky130A
param L=0.15 H=2.72 WN=0.49 WP=0.75

stdcell a21oi width=8 height=H
  device M0 nmos w=WN l=L d=n1 g=A2 s=VGND
  device M1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device M2 pmos w=WP l=L d=Y g=B1 s=n2
  device M3 nmos w=WN l=L d=VGND g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A2 s=n2
  device M5 nmos w=WN l=L d=Y g=A1 s=n1

  nd  = rect diff w=2.62 h=WN cx=cell.cx above=ptap
  pd  = rect diff w=2.62 h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm
  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  g2 = cross [nd, pd] poly w=L cx=(cell.cx - 0.9)     # A2
  g1 = cross [nd, pd] poly w=L cx=cell.cx             # A1
  g3 = cross [nd, pd] poly w=L cx=(cell.cx + 0.9)     # B1

  # nmos row (bottom): VGND | A2 | n1 | A1 | Y | B1 | VGND
  n0  = contact licon in=nd cx=(cell.cx - 1.115) cy=nd.cy
  ny  = contact licon in=nd cx=(cell.cx + 0.45) cy=nd.cy
  n3  = contact licon in=nd cx=(cell.cx + 1.115) cy=(nd.bottom + 0.15)
  n0l = enclose n0 li
  n3l = enclose n3 li
  nyl = enclose ny li net=Y
  s0  = strap li from=n0l to=vgnd_li
  s3  = strap li from=n3l to=vgnd_li

  # pmos row (top): n2 | VPWR | n2 | Y ; n2 strap sits on the bottom edge
  p0  = contact licon in=pd cx=(cell.cx - 1.115) cy=(pd.bottom + 0.15)
  p2  = contact licon in=pd cx=(cell.cx + 0.215) cy=(pd.bottom + 0.15)
  p1  = contact licon in=pd cx=(cell.cx - 0.45) cy=(pd.top - 0.125)
  p3  = contact licon in=pd cx=(cell.cx + 1.15) cy=(pd.top - 0.125)
  p0l = enclose p0 li
  p2l = enclose p2 li
  p1l = enclose p1 li
  p3l = enclose p3 li net=Y
  ns  = strap li from=p0l to=p2l net=n2
  s1  = strap li from=p1l to=vpwr_li

  # Y route: nmos Y up to a band just above the nmos diffusion, east to x=+1.15, up to pmos Y
  yv1 = rect li w=0.17 cx=(cell.cx + 0.45) bottom=nd.cy top=(nd.top + 0.185) net=Y
  yh  = rect li h=0.17 xspan=(cell.cx + 0.365, cell.cx + 1.235) cy=(nd.top + 0.1) net=Y
  yv2 = rect li w=0.17 cx=(cell.cx + 1.15) bottom=(nd.top + 0.015) top=(pd.top - 0.04) net=Y

  # Gate contacts sit in the mid-gap band: 0.19 clear of both diffusions
  # A2 contact on its own gate line, left of the Y route
  a2c = contact licon in=g2 cy=(nd.top + 0.3)
  a2p = enclose a2c poly by=min
  a2l = enclose a2c li net=A2
  a2m = contact mcon in=a2l
  a2a = enclose a2m m1 by=0.06 net=A2
  port A2 in on=a2a

  # A1 contact on the middle gate line
  a1c = contact licon in=g1 cy=(nd.top + 0.3)
  a1p = enclose a1c poly by=min
  a1l = enclose a1c li net=A1
  a1m = contact mcon in=a1l
  a1a = enclose a1m m1 by=0.06 net=A1
  port A1 in on=a1a

  # B1 contact far right on a poly tail, clear of the Y band (which crosses the B1 gate line)
  b1t = rect poly h=0.27 xspan=(cell.cx + 0.9 - 0.075, cell.cx + 1.6) cy=(nd.top + 0.3)
  b1c = contact licon cx=(cell.cx + 1.6) cy=(nd.top + 0.3)
  b1p = enclose b1c poly by=min
  b1l = enclose b1c li net=B1
  b1m = contact mcon in=b1l
  b1a = enclose b1m m1 by=0.06 net=B1
  port B1 in on=b1a

  # Y output pin on the band
  ym = contact mcon in=yh cx=(cell.cx + 0.95)
  yp = enclose ym m1 by=0.06 net=Y
  port Y out on=yp
end
