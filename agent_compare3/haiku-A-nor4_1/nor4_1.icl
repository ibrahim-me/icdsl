pdk sky130A
param WN=0.65 WP=1.0 L=0.15 H=2.72

stdcell nor4_1 width=7 height=H taps=no
  device M0 nmos w=WN l=L d=VGND g=B s=Y b=VNB
  device M1 pmos w=WP l=L d=n1 g=B s=n2 b=VPB
  device M2 pmos w=WP l=L d=n2 g=A s=VPWR b=VPB
  device M3 nmos w=WN l=L d=Y g=C s=VGND b=VNB
  device M4 nmos w=WN l=L d=VGND g=D s=Y b=VNB
  device M5 pmos w=WP l=L d=n3 g=C s=n1 b=VPB
  device M6 pmos w=WP l=L d=Y g=D s=n3 b=VPB
  device M7 nmos w=WN l=L d=Y g=A s=VGND b=VNB

  # gate order A B C D left to right (same in both rows: one poly stripe per gate)
  pitch = max(L + 0.28, 0.54)
  x1 = 0.5
  xA = x1
  xB = x1 + pitch
  xC = x1 + 2*pitch
  xD = x1 + 3*pitch
  gA = xA + L/2
  gB = xB + L/2
  gC = xC + L/2
  gD = xD + L/2
  nb = 0.235
  nt = nb + WN
  pt = H - 0.235
  pb = pt - WP
  nyc = nb + 0.3                      # n-row contact height (clears the VGND rail, met1.2)
  pyc = pt - 0.3                      # p-row contact height
  myc = pb - 0.32                     # gate contacts: 0.235 clear of p-diffusion (licon.9)
  # column centres: c0 left end, c1..c3 between gates, c4 right end
  c0 = x1 - 0.14
  c1 = xA + (L + pitch) / 2
  c2 = xB + (L + pitch) / 2
  c3 = xC + (L + pitch) / 2
  c4 = xD + L + 0.3

  # diffusion (poly stripes split each row into source/drain islands)
  nd = rect diff xspan=(x1 - 0.265, xD + L + 0.44) yspan=(nb, nt)
  pd = rect diff xspan=(x1 - 0.265, xD + L + 0.44) yspan=(pb, pt)
  nim = enclose [nd] nsdm
  pim = enclose [pd] psdm
  # poly: gate stripes and middle-band pads for the input contacts
  pA = rect poly xspan=(xA, xA + L) yspan=(0.105, H - 0.105)
  pB = rect poly xspan=(xB, xB + L) yspan=(0.105, H - 0.105)
  pC = rect poly xspan=(xC, xC + L) yspan=(0.105, H - 0.105)
  pD = rect poly xspan=(xD, xD + L) yspan=(0.105, H - 0.105)
  qA = rect poly xspan=(gA - 0.165, gA + 0.165) yspan=(nt + 0.11, pb - 0.14)
  qB = rect poly xspan=(gB - 0.165, gB + 0.165) yspan=(nt + 0.11, pb - 0.14)
  qC = rect poly xspan=(gC - 0.165, gC + 0.165) yspan=(nt + 0.11, pb - 0.14)
  qD = rect poly xspan=(gD - 0.165, gD + 0.165) yspan=(nt + 0.11, pb - 0.14)
  npc1 = rect npc xspan=(gA - 0.2, gD + 0.2) yspan=(nt + 0.09, pb - 0.14)

  # input contacts on the gate pads, li pads in the middle band
  gcA = contact licon cx=gA cy=myc
  gcB = contact licon cx=gB cy=myc
  gcC = contact licon cx=gC cy=myc
  gcD = contact licon cx=gD cy=myc
  lA = rect li xspan=(gA - 0.17, gA + 0.17) yspan=(myc - 0.25, myc + 0.25) net=A
  lB = rect li xspan=(gB - 0.17, gB + 0.17) yspan=(myc - 0.25, myc + 0.25) net=B
  lC = rect li xspan=(gC - 0.17, gC + 0.17) yspan=(myc - 0.25, myc + 0.25) net=C
  lD = rect li xspan=(gD - 0.17, gD + 0.17) yspan=(myc - 0.25, myc + 0.25) net=D

  # n row: VGND | Y | VGND | Y | VGND
  nc0 = contact licon cx=c0 cy=nyc
  nc1 = contact licon cx=c1 cy=nyc
  nc2 = contact licon cx=c2 cy=nyc
  nc3 = contact licon cx=c3 cy=nyc
  nc4 = contact licon cx=c4 cy=nyc
  nl0 = rect li xspan=(c0 - 0.115, c0 + 0.115) yspan=(-0.085, nyc + 0.165) net=VGND
  nl1 = rect li xspan=(c1 - 0.115, c1 + 0.115) yspan=(nyc - 0.165, nyc + 0.165) net=Y
  nl2 = rect li xspan=(c2 - 0.115, c2 + 0.115) yspan=(-0.085, nyc + 0.165) net=VGND
  nl3 = rect li xspan=(c3 - 0.115, c3 + 0.115) yspan=(nyc - 0.165, nyc + 0.165) net=Y
  nl4 = rect li xspan=(c4 - 0.115, c4 + 0.115) yspan=(-0.085, nyc + 0.165) net=VGND

  # p row: VPWR | n2 | n1 | n3 | Y
  pc0 = contact licon cx=c0 cy=pyc
  pc1 = contact licon cx=c1 cy=pyc
  pc2 = contact licon cx=c2 cy=pyc
  pc3 = contact licon cx=c3 cy=pyc
  pc4 = contact licon cx=c4 cy=pyc
  pl0 = rect li xspan=(c0 - 0.115, c0 + 0.115) yspan=(pyc - 0.165, H + 0.085) net=VPWR
  pl1 = rect li xspan=(c1 - 0.115, c1 + 0.115) yspan=(pyc - 0.165, pyc + 0.165) net=n2
  pl2 = rect li xspan=(c2 - 0.115, c2 + 0.115) yspan=(pyc - 0.165, pyc + 0.165) net=n1
  pl3 = rect li xspan=(c3 - 0.115, c3 + 0.115) yspan=(pyc - 0.165, pyc + 0.165) net=n3
  pl4 = rect li xspan=(c4 - 0.115, c4 + 0.115) yspan=(pyc - 0.165, pyc + 0.165) net=Y

  # metal: rail contacts
  m0 = contact mcon cx=c0 cy=0
  m2 = contact mcon cx=c2 cy=0
  m4 = contact mcon cx=c4 cy=0
  mt = contact mcon cx=c0 cy=H
  well y=(pb - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells

  # Y: n-row drains (c1, c3) and p-row drain (c4) joined by explicit met1
  ym1 = contact mcon in=nl1
  ym3 = contact mcon in=nl3
  yp4 = contact mcon in=pl4
  ya = rect m1 xspan=(c1 - 0.145, c4 + 0.145) yspan=(nyc - 0.145, nyc + 0.145) net=Y
  yb = rect m1 xspan=(c4 - 0.145, c4 + 0.145) yspan=(nyc - 0.145, pyc + 0.145) net=Y
  port A in on=lA
  port B in on=lB
  port C in on=lC
  port D in on=lD
  port Y out on=yb
end
