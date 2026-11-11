pdk sky130A
param WN=0.52 WP=0.77 L=0.15 H=2.72

stdcell aoi21 width=12 height=H
  device MNA1 nmos w=WN l=L d=Y g=A1 s=n1
  device MNA2 nmos w=WN l=L d=n1 g=A2 s=VGND
  device MNB nmos w=WN l=L d=Y g=B1 s=VGND
  device MPA1 pmos w=WP l=L d=n2 g=A1 s=VPWR
  device MPA2 pmos w=WP l=L d=n2 g=A2 s=VPWR
  device MPB pmos w=WP l=L d=Y g=B1 s=n2

  # ---------- nMOS stack (top diff) ----------
  ndn = rect diff w=(L + 0.53) h=WN cx=cell.cx - 1.15 above=ptap
  ndm = rect diff w=(L + 0.53) h=WN cx=cell.cx        above=ptap
  ndp = rect diff w=(L + 0.53) h=WN cx=cell.cx + 1.15 above=ptap
  nim = enclose [ndn, ndm, ndp] nsdm

  gn1 = cross ndn poly w=L
  gn2 = cross ndm poly w=L
  gn3 = cross ndp poly w=L

  cn1 = array licon in=ndn left_of=gn1
  cn2 = array licon in=ndn right_of=gn1 left_of=gn2
  cn3 = array licon in=ndm right_of=gn2 left_of=gn3
  cn4 = array licon in=ndp right_of=gn3

  cl1 = enclose cn1 li
  cl2 = enclose cn2 li
  cl3 = enclose cn3 li
  cl4 = enclose cn4 li

  # ---------- pMOS stack (bottom diff) ----------
  pd1 = rect diff w=(L + 0.53) h=WP cx=cell.cx - 1.15 below=ntap
  pd2 = rect diff w=(L + 0.53) h=WP cx=cell.cx        below=ntap
  pd3 = rect diff w=(L + 0.53) h=WP cx=cell.cx + 1.15 below=ntap
  pim = enclose [pd1, pd2, pd3] psdm

  gp1 = cross pd1 poly w=L
  gp2 = cross pd2 poly w=L
  gp3 = cross pd3 poly w=L

  cp1 = array licon in=pd1 left_of=gp1
  cp2 = array licon in=pd1 right_of=gp1 left_of=gp2
  cp3 = array licon in=pd2 right_of=gp2 left_of=gp3
  cp4 = array licon in=pd3 right_of=gp3

  cl5 = enclose cp1 li
  cl6 = enclose cp2 li
  cl7 = enclose cp3 li
  cl8 = enclose cp4 li

  # ---------- well ----------
  well y=((nim.top + 0.34 + pim.bottom - 0.18) / 2)

  # ---------- straps / contacts ----------
  gndn = strap li from=cl2 to=vgnd_li
  gndp = strap li from=cl4 to=vgnd_li
  pwr1 = strap li from=cl5 to=vpwr_li
  pwr2 = strap li from=cl8 to=vpwr_li

  y1  = contact mcon in=cl3 net=Y
  y2  = contact mcon in=cl7 net=Y
  yp  = enclose [y1, y2] m1 by=0.06 net=Y

  n1c = contact mcon in=cl2 net=n1
  n1p = enclose n1c m1 by=0.06 net=n1

  n2c = contact mcon in=cl6 net=n2
  n2p = enclose n2c m1 by=0.06 net=n2

  a1c = contact mcon in=gn1 net=A1
  a1p = enclose a1c m1 by=0.06 net=A1

  a2c = contact mcon in=gn2 net=A2
  a2p = enclose a2c m1 by=0.06 net=A2

  b1c = contact mcon in=gn3 net=B1
  b1p = enclose b1c m1 by=0.06 net=B1

  port A1 in  on=a1p
  port A2 in  on=a2p
  port B1 in  on=b1p
  port Y  out on=yp
end
