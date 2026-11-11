pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=10 height=H taps=no
  device M0 pmos w=WP2 l=L d=n1 g=A s=VPWR b=VPB
  device M1 nmos w=WN2 l=L d=n2 g=B s=n3 b=VNB
  device M2 nmos w=WN2 l=L d=n3 g=B s=n4 b=VNB
  device M3 nmos w=WN l=L d=VGND g=n3 s=X b=VNB
  device M4 nmos w=WN2 l=L d=VGND g=A s=n2 b=VNB
  device M5 nmos w=WN2 l=L d=n5 g=A s=VGND b=VNB
  device M6 pmos w=WP2 l=L d=n3 g=B s=n6 b=VPB
  device M7 pmos w=WP2 l=L d=n6 g=C s=VPWR b=VPB
  device M8 pmos w=WP l=L d=VPWR g=n3 s=X b=VPB
  device M9 nmos w=WN2 l=L d=n4 g=C s=VGND b=VNB
  device M10 nmos w=WN2 l=L d=n3 g=C s=n5 b=VNB
  device M11 pmos w=WP2 l=L d=n3 g=C s=n1 b=VPB
  device M12 pmos w=WP2 l=L d=VPWR g=A s=n7 b=VPB
  device M13 pmos w=WP2 l=L d=n7 g=B s=n3 b=VPB

  # gate columns: pitch 0.54 (gap = 0.54 - L); X7 is the taller M3/M8 gate
  X1 = 0.6
  X2 = X1 + 0.54
  X3 = X1 + 1.08
  X4 = X1 + 1.62
  X5 = X1 + 2.16
  X6 = X1 + 2.70
  X7 = X6 + L + max(0.54 - L, 0.40)     # wider gap before the taller M3/M8 gate
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  gy = ((nb + WN + 0.09) + (pt - WP - 0.14)) / 2   # gate-contact height, in the gap

  # diffusion: regular rows (WN2 / WP2) and taller end region under the M3 / M8 gate
  nda = rect diff xspan=(X1 - 0.265, X7 - 0.15) yspan=(nb, nb + WN2)
  ndb = rect diff xspan=(X7 - 0.30, X7 + L + 0.265) yspan=(nb, nb + WN)
  pda = rect diff xspan=(X1 - 0.265, X7 - 0.15) yspan=(pt - WP2, pt)
  pdb = rect diff xspan=(X7 - 0.30, X7 + L + 0.265) yspan=(pt - WP, pt)
  nim = enclose [nda, ndb] nsdm
  pim = enclose [pda, pdb] psdm

  # poly gates, one per gate column, crossing both rows
  g1 = rect poly xspan=(X1, X1 + L) yspan=(0.105, H - 0.105)
  g2 = rect poly xspan=(X2, X2 + L) yspan=(0.105, H - 0.105)
  g3 = rect poly xspan=(X3, X3 + L) yspan=(0.105, H - 0.105)
  g4 = rect poly xspan=(X4, X4 + L) yspan=(0.105, H - 0.105)
  g5 = rect poly xspan=(X5, X5 + L) yspan=(0.105, H - 0.105)
  g6 = rect poly xspan=(X6, X6 + L) yspan=(0.105, H - 0.105)
  g7 = rect poly xspan=(X7, X7 + L) yspan=(0.105, H - 0.105)
  npc1 = rect npc xspan=(X1 - 0.1, X7 + L + 0.1) yspan=(nb + WN + 0.09, pt - WP - 0.14)

  # gate contacts in the gap between the rows
  k1 = contact licon cx=(X1 + L / 2) cy=gy
  k2 = contact licon cx=(X2 + L / 2) cy=gy
  k3 = contact licon cx=(X3 + L / 2) cy=gy
  k4 = contact licon cx=(X4 + L / 2) cy=gy
  k5 = contact licon cx=(X5 + L / 2) cy=gy
  k6 = contact licon cx=(X6 + L / 2) cy=gy
  k7 = contact licon cx=(X7 + L / 2) cy=gy
  pk1 = enclose k1 poly by=minx
  pk2 = enclose k2 poly by=minx
  pk3 = enclose k3 poly by=minx
  pk4 = enclose k4 poly by=minx
  pk5 = enclose k5 poly by=minx
  pk6 = enclose k6 poly by=minx
  pk7 = enclose k7 poly by=minx
  kl1 = enclose k1 li net=B
  kl2 = enclose k2 li net=A
  kl3 = enclose k3 li net=C
  kl4 = enclose k4 li net=B
  kl5 = enclose k5 li net=C
  kl6 = enclose k6 li net=A
  kl7 = enclose k7 li net=n3

  # n-row diffusion contacts: c0 left end, c1..c6 between gates, c7 right of M3
  nc0 = contact licon cx=(X1 - 0.14) cy=(nb + WN2 / 2 + 0.06)
  nc1 = contact licon cx=(X1 + 0.27 + L / 2) cy=(nb + WN2 / 2 + 0.06)
  nc2 = contact licon cx=(X2 + 0.27 + L / 2) cy=(nb + WN2 / 2 + 0.06)
  nc3 = contact licon cx=(X3 + 0.27 + L / 2) cy=(nb + WN2 / 2 + 0.06)
  nc4 = contact licon cx=(X4 + 0.27 + L / 2) cy=(nb + WN2 / 2 + 0.06)
  nc5 = contact licon cx=(X5 + 0.27 + L / 2) cy=(nb + WN2 / 2 + 0.06)
  nc6 = contact licon cx=((X6 + L + X7) / 2) cy=(nb + WN2 / 2 + 0.06)
  nc7 = contact licon cx=(X7 + L + 0.14) cy=(nb + WN / 2 + 0.06)
  nl0 = enclose nc0 li net=n3
  nl1 = enclose nc1 li net=n2
  nl3 = enclose nc3 li net=n4
  nl4 = enclose nc4 li net=n3
  nl5 = enclose nc5 li net=n5
  nl7 = enclose nc7 li net=X
  # VGND source/drain columns: li down to the rail
  nl2 = rect li xspan=(X2 + 0.27 + L / 2 - 0.165, X2 + 0.27 + L / 2 + 0.165) yspan=(-0.165, nb + WN2 / 2 + 0.225) net=VGND
  nl6 = rect li xspan=((X6 + L + X7) / 2 - 0.165, (X6 + L + X7) / 2 + 0.165) yspan=(-0.165, nb + WN2 / 2 + 0.225) net=VGND
  nm2 = contact mcon cx=(X2 + 0.27 + L / 2) cy=0
  nm6 = contact mcon cx=((X6 + L + X7) / 2) cy=0

  # p-row diffusion contacts
  pc0 = contact licon cx=(X1 - 0.14) cy=(pt - WP2 / 2 - 0.06)
  pc1 = contact licon cx=(X1 + 0.27 + L / 2) cy=(pt - WP2 / 2 - 0.06)
  pc2 = contact licon cx=(X2 + 0.27 + L / 2) cy=(pt - WP2 / 2 - 0.06)
  pc3 = contact licon cx=(X3 + 0.27 + L / 2) cy=(pt - WP2 / 2 - 0.06)
  pc4 = contact licon cx=(X4 + 0.27 + L / 2) cy=(pt - WP2 / 2 - 0.06)
  pc5 = contact licon cx=(X5 + 0.27 + L / 2) cy=(pt - WP2 / 2 - 0.06)
  pc6 = contact licon cx=((X6 + L + X7) / 2) cy=(pt - WP2 / 2 - 0.06)
  pc7 = contact licon cx=(X7 + L + 0.14) cy=(pt - WP / 2 - 0.06)
  pl0 = enclose pc0 li net=n3
  pl1 = enclose pc1 li net=n7
  pl3 = enclose pc3 li net=n6
  pl4 = enclose pc4 li net=n3
  pl5 = enclose pc5 li net=n1
  pl7 = enclose pc7 li net=X
  # VPWR source/drain columns: li up to the rail
  pl2 = rect li xspan=(X2 + 0.27 + L / 2 - 0.165, X2 + 0.27 + L / 2 + 0.165) yspan=(pt - WP2 / 2 - 0.225, H + 0.165) net=VPWR
  pl6 = rect li xspan=((X6 + L + X7) / 2 - 0.165, (X6 + L + X7) / 2 + 0.165) yspan=(pt - WP2 / 2 - 0.225, H + 0.165) net=VPWR
  pm2 = contact mcon cx=(X2 + 0.27 + L / 2) cy=H
  pm6 = contact mcon cx=((X6 + L + X7) / 2) cy=H

  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells

  route B layers=m1,m2
  route C layers=m1,m2
  route A layers=m1,m2
  route n3 layers=m1,m2 prefer=m1
  route X layers=m1,m2
  port A in
  port B in
  port C in
  port X out
end
