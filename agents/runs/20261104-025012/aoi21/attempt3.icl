pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=12 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  # nMOS diffs (top row)
  ndm = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  ndn = rect diff w=(L + 0.53) h=WN left_of=ndm space=0.3 above=ptap
  ndp = rect diff w=(L + 0.53) h=WN right_of=ndm space=0.3 above=ptap
  nim = enclose [ndn, ndm, ndp] nsdm

  # pMOS diffs (bottom row)
  pd2 = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  pd1 = rect diff w=(L + 0.53) h=WP left_of=pd2 space=0.3 below=ntap
  pd3 = rect diff w=(L + 0.53) h=WP right_of=pd2 space=0.3 below=ntap
  pim = enclose [pd1, pd2, pd3] psdm

  # gates
  gA1 = cross [ndn, pd1] poly w=L
  gA2 = cross [ndm, pd2] poly w=L
  gB1 = cross [ndp, pd3] poly w=L

  # nMOS contacts
  cnYn = array licon in=ndn left_of=gA1
  cn1n = array licon in=ndn right_of=gA1
  cn1m = array licon in=ndm left_of=gA2
  cnVn = array licon in=ndm right_of=gA2
  cnYp = array licon in=ndp left_of=gB1
  cnVp = array licon in=ndp right_of=gB1

  clYn = enclose cnYn li
  cl1n = enclose cn1n li
  cl1m = enclose cn1m li
  clVn = enclose cnVn li
  clYp = enclose cnYp li
  clVp = enclose cnVp li

  # pMOS contacts
  cpP1 = array licon in=pd1 left_of=gA1
  cp2n = array licon in=pd1 right_of=gA1
  cpP2 = array licon in=pd2 left_of=gA2
  cp2m = array licon in=pd2 right_of=gA2
  cpN  = array licon in=pd3 left_of=gB1
  cpY  = array licon in=pd3 right_of=gB1

  clP1 = enclose cpP1 li
  cl2n = enclose cp2n li
  clP2 = enclose cpP2 li
  cl2m = enclose cp2m li
  clN  = enclose cpN li
  clY  = enclose cpY li

  # well
  well y=((nim.top + 0.34 + pim.bottom - 0.18) / 2)

  # straps to rails
  stVn = strap li from=clVn to=vgnd_li
  stVp = strap li from=clVp to=vgnd_li
  stP1 = strap li from=clP1 to=vpwr_li
  stP2 = strap li from=clP2 to=vpwr_li

  # internal nets
  stN1 = strap li from=cl1n to=cl1m net=n1
  stN2a = strap li from=cl2n to=cl2m net=n2
  stN2b = strap li from=cl2m to=clN net=n2

  # output Y on m1
  yc1 = contact mcon in=clYn
  yc2 = contact mcon in=clY
  yp  = enclose [yc1, yc2] m1 by=0.06 net=Y

  # gate inputs on m1
  a1c = contact mcon in=gA1
  a1p = enclose a1c m1 by=0.06 net=A1

  a2c = contact mcon in=gA2
  a2p = enclose a2c m1 by=0.06 net=A2

  b1c = contact mcon in=gB1
  b1p = enclose b1c m1 by=0.06 net=B1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
