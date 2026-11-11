pdk sky130A
param WN=0.49 WP=0.75 WP2=0.52 L=0.15 H=2.72

stdcell o21ai width=10 height=H
  device M0 pmos w=WP l=L d=n1 g=A2 s=Y
  device M1 pmos w=WP2 l=L d=Y g=B1 s=VPWR
  device M2 nmos w=WN l=L d=n2 g=A1 s=VGND
  device M3 nmos w=WN l=L d=n2 g=B1 s=Y
  device M4 pmos w=WP l=L d=VPWR g=A1 s=n1
  device M5 nmos w=WN l=L d=VGND g=A2 s=n2

  # diffusion rows: n-row above p-tap, p-row below n-tap, centred
  nd  = rect diff w=(4*L + 1.85) h=WN cx=cell.cx above=ptap
  pd  = rect diff w=(4*L + 1.85) h=WP cx=cell.cx below=ntap
  nim = enclose nd nsdm
  pim = enclose pd psdm

  # same gate order A2, A1, B1 in both rows; pitch leaves room for a contact column
  ga2 = cross [nd, pd] poly w=L left=(nd.left + 0.265)
  ga1 = cross [nd, pd] poly w=L left=(ga2.right + max(0.28, 0.54 - L))
  gb1 = cross [nd, pd] poly w=L left=(ga1.right + max(0.28, 0.54 - L))

  # n-row: VGND | A2 | n2 | A1 | VGND | B1 | Y  (M2/M5 share n2 column)
  sn  = array licon in=nd left_of=ga2          # VGND (M5 drain)
  dn  = array licon in=nd right_of=ga2         # n2 (M5 source, M2 drain)
  s2  = array licon in=nd left_of=ga1          # VGND (M2 source)
  d3  = array licon in=nd right_of=gb1         # Y (M3 source)
  snl = enclose sn li
  dnl = enclose dn li net=n2
  s2l = enclose s2 li
  d3l = enclose d3 li net=Y
  gndn = strap li from=snl to=vgnd_li
  gnd2 = strap li from=s2l to=vgnd_li
  # M3 drain = n2: contact on the shared n2 column, strap to the Y column
  n2c = contact licon in=nd between=[ga1, gb1] cx=(dnl.cx)
  n2l = enclose n2c li net=n2
  n2y = strap li from=n2l to=d3l

  # p-row: VPWR | A2 | n1 | A1 | Y | B1 | VPWR  (M4/M0 share n1)
  sp  = array licon in=pd left_of=ga2          # VPWR (M4 drain)
  dp  = array licon in=pd right_of=ga2         # n1 (M4 source, M0 drain)
  s0  = array licon in=pd left_of=ga1          # Y (M0 source)
  d1  = array licon in=pd right_of=gb1         # VPWR (M1 source)
  spl = enclose sp li
  dpl = enclose dp li net=n1
  s0l = enclose s0 li net=Y
  d1l = enclose d1 li
  pwr1 = strap li from=spl to=vpwr_li
  pwr2 = strap li from=d1l to=vpwr_li
  # n1 column already shared by M4/M0; Y column shared by M0/M1

  # gate contacts in the gap between the rows (n-row items only in cb)
  cb = max(nd.top + 0.19, snl.top + 0.25, dnl.top + 0.25, s2l.top + 0.25, d3l.top + 0.25)
  gca2 = contact licon cx=(ga2.cx) bottom=cb
  gca1 = contact licon cx=(ga1.cx) bottom=cb
  gcb1 = contact licon cx=(gb1.cx) bottom=cb
  pca2 = enclose gca2 poly by=minx
  pca1 = enclose gca1 poly by=minx
  pcb1 = enclose gcb1 poly by=minx
  gna  = enclose [gca2, gca1, gcb1] npc
  aa   = enclose gca2 li net=A2
  ab   = enclose gca1 li net=A1
  bb   = enclose gcb1 li net=B1

  well y=((nd.top + 0.34 + pd.bottom - 0.18) / 2)

  # supply straps
  p1 = strap li from=dpl to=vpwr_li   # p-row right VPWR (M1 source) - already have pwr2; keep one
  # (d1l is the right VPWR column; spl is the left VPWR column)

  # met1 pins
  a1m = contact mcon in=aa
  a1p = enclose a1m m1 by=0.06 net=A1
  a2m = contact mcon in=ab
  a2p = enclose a2m m1 by=0.06 net=A2
  b1m = contact mcon in=bb
  b1p = enclose b1m m1 by=0.06 net=B1
  ym  = contact mcon in=s0l
  yp  = enclose ym m1 by=0.06 net=Y
  route Y layers=m1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y out on=yp
end
