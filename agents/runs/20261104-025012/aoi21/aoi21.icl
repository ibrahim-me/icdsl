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

  # nMOS diff contacts
  cnYn = array licon in=ndn left_of=gA1
  cn1n = array licon in=ndn right_of=gA1
  cn1m = array licon in=ndm left_of=gA2
  cnVn = array licon in=ndm right_of=gA2
  cnYp = array licon in=ndp left_of=gB1
  cnVp = array licon in=ndp right_of=gB1

  clYn = enclose cnYn li by=0.08
  cl1n = enclose cn1n li by=0.08
  cl1m = enclose cn1m li by=0.08
  clVn = enclose cnVn li by=0.08
  clYp = enclose cnYp li by=0.08
  clVp = enclose cnVp li by=0.08

  # pMOS diff contacts
  cpP1 = array licon in=pd1 left_of=gA1
  cp2n = array licon in=pd1 right_of=gA1
  cpP2 = array licon in=pd2 left_of=gA2
  cp2m = array licon in=pd2 right_of=gA2
  cpN  = array licon in=pd3 left_of=gB1
  cpY  = array licon in=pd3 right_of=gB1

  clP1 = enclose cpP1 li by=0.08
  cl2n = enclose cp2n li by=0.08
  clP2 = enclose cpP2 li by=0.08
  cl2m = enclose cp2m li by=0.08
  clN  = enclose cpN li by=0.08
  clY  = enclose cpY li by=0.08

  # well
  well y=((nim.top + 0.34 + pim.bottom - 0.18) / 2)

  # straps to rails
  stVn = strap li from=clVn to=vgnd_li
  stVp = strap li from=clVp to=vgnd_li
  stP1 = strap li from=clP1 to=vpwr_li
  stP2 = strap li from=clP2 to=vpwr_li

  # internal nets n1, n2
  stN1 = strap li from=cl1n to=cl1m net=n1
  stN2a = strap li from=cl2n to=cl2m net=n2
  stN2b = strap li from=cl2m to=clN net=n2

  # output Y strap
  stY = strap li from=clYn to=clYp to=clY net=Y

  # gate input contacts: licon on poly -> li -> mcon -> m1
  gcA1 = contact licon in=gA1
  glA1 = enclose gcA1 li by=0.08
  gmA1 = contact mcon in=glA1
  a1p  = enclose gmA1 m1 by=0.06 net=A1

  gcA2 = contact licon in=gA2
  glA2 = enclose gcA2 li by=0.08
  gmA2 = contact mcon in=glA2
  a2p  = enclose gmA2 m1 by=0.06 net=A2

  gcB1 = contact licon in=gB1
  glB1 = enclose gcB1 li by=0.08
  gmB1 = contact mcon in=glB1
  b1p  = enclose gmB1 m1 by=0.06 net=B1

  # output Y pin on m1
  yc = contact mcon in=stY
  yp = enclose yc m1 by=0.06 net=Y

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
