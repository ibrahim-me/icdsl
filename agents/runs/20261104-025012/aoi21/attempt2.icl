pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=12 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  # nMOS diffs
  ndm = rect diff w=(L + 0.53) h=WN cx=cell.cx above=ptap
  ndn = rect diff w=(L + 0.53) h=WN left_of=ndm space=0.3 above=ptap
  ndp = rect diff w=(L + 0.53) h=WN right_of=ndm space=0.3 above=ptap
  nim = enclose [ndn, ndm, ndp] nsdm

  # pMOS diffs
  pd2 = rect diff w=(L + 0.53) h=WP cx=cell.cx below=ntap
  pd1 = rect diff w=(L + 0.53) h=WP left_of=pd2 space=0.3 below=ntap
  pd3 = rect diff w=(L + 0.53) h=WP right_of=pd2 space=0.3 below=ntap
  pim = enclose [pd1, pd2, pd3] psdm

  # gates
  gA1 = cross [ndn, pd1] poly w=L
  gA2 = cross [ndm, pd2] poly w=L
  gB1 = cross [ndp, pd3] poly w=L

  # nMOS contacts
  cnY = array licon in=ndn left_of=gA1
  cn1 = array licon in=ndn right_of=gA1 left_of=gA2
  cnG = array licon in=ndm right_of=gA2
  cnYb = array licon in=ndp left_of=gB1
  cnV = array licon in=ndp right_of=gB1

  clY = enclose cnY li
  cl1 = enclose cn1 li
  clG = enclose cnG li
  clYb = enclose cnYb li
  clV = enclose cnV li

  # pMOS contacts
  cpP = array licon in=pd1 left_of=gA1
  cp2 = array licon in=pd1 right_of=gA1 left_of=gA2
  cpP2 = array licon in=pd2 left_of=gA2
  cp2b = array licon in=pd2 right_of=gA2
  cpN = array licon in=pd3 left_of=gB1
  cpY = array licon in=pd3 right_of=gB1

  clP = enclose cpP li
  cl2 = enclose cp2 li
  clP2 = enclose cpP2 li
  cl2b = enclose cp2b li
  clN = enclose cpN li
  clYp = enclose cpY li

  # well
  well y=((nim.top + 0.34 + pim.bottom - 0.18) / 2)

  # straps to rails
  stVn = strap li from=clG to=vgnd_li
  stVp = strap li from=clV to=vgnd_li
  stPp = strap li from=clP to=vpwr_li
  stP2 = strap li from=clP2 to=vpwr_li

  # internal nets
  stN1 = strap li from=cl1 to=clG net=n1
  stN2 = strap li from=cl2 to=cl2b to=clN net=n2

  # output Y
  stY = strap li from=clY to=clYb to=clYp net=Y

  # gate inputs on met1
  a1c = contact mcon in=gA1
  a1p = enclose a1c m1 by=0.06 net=A1

  a2c = contact mcon in=gA2
  a2p = enclose a2c m1 by=0.06 net=A2

  b1c = contact mcon in=gB1
  b1p = enclose b1c m1 by=0.06 net=B1

  yc = contact mcon in=stY
  yp = enclose yc m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
