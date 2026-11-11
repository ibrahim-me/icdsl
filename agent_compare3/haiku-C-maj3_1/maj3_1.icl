# maj3_1: one diffusion island per device (no shared nodes). Each island end has its own licon and
# li pad; internal nets get an explicit mcon + met1 pad (clear of the rails) and are joined with route.
# Gate columns: n3, A, B, B, C, A, C (the n and p device of a column share one poly stripe).
# library conventions: tapless (the row's tap cells tie VNB/VPB), PDK widths; x from the gate columns x1..,
# y from the row edges nb / pt; clean over the sweep L 0.15-0.25, widths x1.25 (H 3.26), x1.5 (H 3.8)
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=18 height=H taps=no
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

  pz = L + 0.83
  x1 = 0.42

  x2 = x1 + pz
  x3 = x2 + pz
  x4 = x3 + pz
  x5 = x4 + pz
  x6 = x5 + pz
  x7 = x6 + pz
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  yg1 = nb + WN + 0.277              # gate contact of col 1 (n3): between the big n and p devices
  ya = pt - WP2 - 0.37               # gate contacts of the A columns (high, near the p row)
  yb = nb + WN2 + 0.345              # gate contacts of the B and C columns (low, near the n row)
  cn1 = nb + WN / 2                  # node contact heights
  cn = nb + WN2 / 2 + 0.045
  cm1 = cn1 + 0.07                   # met1 pad heights (clear of the VGND rail)
  cm = cn + 0.07
  cp1 = pt - WP / 2
  cp = pt - WP2 / 2 - 0.045
  cq1 = cp1 - 0.09                   # met1 pad heights (clear of the VPWR rail)
  cq = cp - 0.09

  # column 1: gate n3; n device VGND-X (WN), p device VPWR-X (WP)
  nd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(nb, nb + WN)
  pd1 = rect diff xspan=(x1 - 0.265, x1 + L + 0.265) yspan=(pt - WP, pt)
  pg1 = rect poly xspan=(x1, x1 + L) yspan=(0.105, H - 0.105)
  gp1 = rect poly xspan=(x1 - 0.06, x1 + L + 0.06) yspan=(yg1 - 0.17, yg1 + 0.17)
  gc1 = contact licon cx=(x1 + L / 2) cy=yg1
  gl1 = rect li xspan=(x1 + L / 2 - 0.165, x1 + L / 2 + 0.165) yspan=(yg1 - 0.165, yg1 + 0.165) net=n3
  gm1 = contact mcon in=gl1
  gmp1 = enclose gm1 m1 by=0.06 net=n3
  gn1 = rect npc xspan=(x1 - 0.1, x1 + L + 0.1) yspan=(yg1 - 0.17, yg1 + 0.17)
  nc1a = contact licon cx=(x1 - 0.14) cy=cn1
  nl1a = rect li xspan=(x1 - 0.305, x1 - 0.025) yspan=(-0.085, cn1 + 0.165) net=VGND
  nm1a = contact mcon cx=(x1 - 0.14) cy=0
  nc1b = contact licon cx=(x1 + L + 0.14) cy=cn1
  nl1b = rect li xspan=(x1 + L + 0.025, x1 + L + 0.305) yspan=(cn1 - 0.165, cm1 + 0.1) net=X
  nm1b = contact mcon cx=(x1 + L + 0.14) cy=cm1
  nmp1b = enclose nm1b m1 by=0.06 net=X
  pc1a = contact licon cx=(x1 - 0.14) cy=cp1
  pl1a = rect li xspan=(x1 - 0.305, x1 - 0.025) yspan=(cp1 - 0.165, H + 0.085) net=VPWR
  pm1a = contact mcon cx=(x1 - 0.14) cy=H
  pc1b = contact licon cx=(x1 + L + 0.14) cy=cp1
  pl1b = rect li xspan=(x1 + L + 0.025, x1 + L + 0.305) yspan=(cq1 - 0.1, cp1 + 0.165) net=X
  pm1b = contact mcon cx=(x1 + L + 0.14) cy=cq1
  pmp1b = enclose pm1b m1 by=0.06 net=X
  # column 2: gate A; n device VGND-n2 (WN2), p device VPWR-n7 (WP2)
  nd2 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(nb, nb + WN2)
  pd2 = rect diff xspan=(x2 - 0.265, x2 + L + 0.265) yspan=(pt - WP2, pt)
  pg2 = rect poly xspan=(x2, x2 + L) yspan=(0.105, H - 0.105)
  gp2 = rect poly xspan=(x2 - 0.06, x2 + L + 0.06) yspan=(ya - 0.17, ya + 0.17)
  gc2 = contact licon cx=(x2 + L / 2) cy=ya
  gl2 = rect li xspan=(x2 + L / 2 - 0.165, x2 + L / 2 + 0.165) yspan=(ya - 0.165, ya + 0.165) net=A
  gm2 = contact mcon in=gl2
  gmp2 = enclose gm2 m1 by=0.06 net=A
  gn2 = rect npc xspan=(x2 - 0.1, x2 + L + 0.1) yspan=(ya - 0.17, ya + 0.17)
  nc2a = contact licon cx=(x2 - 0.14) cy=cn
  nl2a = rect li xspan=(x2 - 0.305, x2 - 0.025) yspan=(-0.085, cn + 0.165) net=VGND
  nm2a = contact mcon cx=(x2 - 0.14) cy=0
  nc2b = contact licon cx=(x2 + L + 0.14) cy=cn
  nl2b = rect li xspan=(x2 + L + 0.025, x2 + L + 0.305) yspan=(cn - 0.165, cm + 0.1) net=n2
  nm2b = contact mcon cx=(x2 + L + 0.14) cy=cm
  nmp2b = enclose nm2b m1 by=0.06 net=n2
  pc2a = contact licon cx=(x2 - 0.14) cy=cp
  pl2a = rect li xspan=(x2 - 0.305, x2 - 0.025) yspan=(cp - 0.165, H + 0.085) net=VPWR
  pm2a = contact mcon cx=(x2 - 0.14) cy=H
  pc2b = contact licon cx=(x2 + L + 0.14) cy=cp
  pl2b = rect li xspan=(x2 + L + 0.025, x2 + L + 0.305) yspan=(cq - 0.1, cp + 0.165) net=n7
  pm2b = contact mcon cx=(x2 + L + 0.14) cy=cq
  pmp2b = enclose pm2b m1 by=0.06 net=n7
  # column 3: gate B; n device n2-n3 (WN2), p device n7-n3 (WP2)
  nd3 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(nb, nb + WN2)
  pd3 = rect diff xspan=(x3 - 0.265, x3 + L + 0.265) yspan=(pt - WP2, pt)
  pg3 = rect poly xspan=(x3, x3 + L) yspan=(0.105, H - 0.105)
  gp3 = rect poly xspan=(x3 - 0.06, x3 + L + 0.06) yspan=(yb - 0.17, yb + 0.17)
  gc3 = contact licon cx=(x3 + L / 2) cy=yb
  gl3 = rect li xspan=(x3 + L / 2 - 0.165, x3 + L / 2 + 0.165) yspan=(yb - 0.165, yb + 0.165) net=B
  gm3 = contact mcon in=gl3
  gmp3 = enclose gm3 m1 by=0.06 net=B
  gn3 = rect npc xspan=(x3 - 0.1, x3 + L + 0.1) yspan=(yb - 0.17, yb + 0.17)
  nc3a = contact licon cx=(x3 - 0.14) cy=cn
  nl3a = rect li xspan=(x3 - 0.305, x3 - 0.025) yspan=(cn - 0.165, cm + 0.1) net=n2
  nm3a = contact mcon cx=(x3 - 0.14) cy=cm
  nmp3a = enclose nm3a m1 by=0.06 net=n2
  nc3b = contact licon cx=(x3 + L + 0.14) cy=cn
  nl3b = rect li xspan=(x3 + L + 0.025, x3 + L + 0.305) yspan=(cn - 0.165, cm + 0.1) net=n3
  nm3b = contact mcon cx=(x3 + L + 0.14) cy=cm
  nmp3b = enclose nm3b m1 by=0.06 net=n3
  pc3a = contact licon cx=(x3 - 0.14) cy=cp
  pl3a = rect li xspan=(x3 - 0.305, x3 - 0.025) yspan=(cq - 0.1, cp + 0.165) net=n7
  pm3a = contact mcon cx=(x3 - 0.14) cy=cq
  pmp3a = enclose pm3a m1 by=0.06 net=n7
  pc3b = contact licon cx=(x3 + L + 0.14) cy=cp
  pl3b = rect li xspan=(x3 + L + 0.025, x3 + L + 0.305) yspan=(cq - 0.1, cp + 0.165) net=n3
  pm3b = contact mcon cx=(x3 + L + 0.14) cy=cq
  pmp3b = enclose pm3b m1 by=0.06 net=n3
  # column 4: gate B; n device n3-n4 (WN2), p device n3-n6 (WP2)
  nd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(nb, nb + WN2)
  pd4 = rect diff xspan=(x4 - 0.265, x4 + L + 0.265) yspan=(pt - WP2, pt)
  pg4 = rect poly xspan=(x4, x4 + L) yspan=(0.105, H - 0.105)
  gp4 = rect poly xspan=(x4 - 0.06, x4 + L + 0.06) yspan=(yb - 0.17, yb + 0.17)
  gc4 = contact licon cx=(x4 + L / 2) cy=yb
  gl4 = rect li xspan=(x4 + L / 2 - 0.165, x4 + L / 2 + 0.165) yspan=(yb - 0.165, yb + 0.165) net=B
  gm4 = contact mcon in=gl4
  gmp4 = enclose gm4 m1 by=0.06 net=B
  gn4 = rect npc xspan=(x4 - 0.1, x4 + L + 0.1) yspan=(yb - 0.17, yb + 0.17)
  nc4a = contact licon cx=(x4 - 0.14) cy=cn
  nl4a = rect li xspan=(x4 - 0.305, x4 - 0.025) yspan=(cn - 0.165, cm + 0.1) net=n3
  nm4a = contact mcon cx=(x4 - 0.14) cy=cm
  nmp4a = enclose nm4a m1 by=0.06 net=n3
  nc4b = contact licon cx=(x4 + L + 0.14) cy=cn
  nl4b = rect li xspan=(x4 + L + 0.025, x4 + L + 0.305) yspan=(cn - 0.165, cm + 0.1) net=n4
  nm4b = contact mcon cx=(x4 + L + 0.14) cy=cm
  nmp4b = enclose nm4b m1 by=0.06 net=n4
  pc4a = contact licon cx=(x4 - 0.14) cy=cp
  pl4a = rect li xspan=(x4 - 0.305, x4 - 0.025) yspan=(cq - 0.1, cp + 0.165) net=n3
  pm4a = contact mcon cx=(x4 - 0.14) cy=cq
  pmp4a = enclose pm4a m1 by=0.06 net=n3
  pc4b = contact licon cx=(x4 + L + 0.14) cy=cp
  pl4b = rect li xspan=(x4 + L + 0.025, x4 + L + 0.305) yspan=(cq - 0.1, cp + 0.165) net=n6
  pm4b = contact mcon cx=(x4 + L + 0.14) cy=cq
  pmp4b = enclose pm4b m1 by=0.06 net=n6
  # column 5: gate C; n device n4-VGND (WN2), p device n6-VPWR (WP2)
  nd5 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(nb, nb + WN2)
  pd5 = rect diff xspan=(x5 - 0.265, x5 + L + 0.265) yspan=(pt - WP2, pt)
  pg5 = rect poly xspan=(x5, x5 + L) yspan=(0.105, H - 0.105)
  gp5 = rect poly xspan=(x5 - 0.06, x5 + L + 0.06) yspan=(yb - 0.17, yb + 0.17)
  gc5 = contact licon cx=(x5 + L / 2) cy=yb
  gl5 = rect li xspan=(x5 + L / 2 - 0.165, x5 + L / 2 + 0.165) yspan=(yb - 0.165, yb + 0.165) net=C
  gm5 = contact mcon in=gl5
  gmp5 = enclose gm5 m1 by=0.06 net=C
  gn5 = rect npc xspan=(x5 - 0.1, x5 + L + 0.1) yspan=(yb - 0.17, yb + 0.17)
  nc5a = contact licon cx=(x5 - 0.14) cy=cn
  nl5a = rect li xspan=(x5 - 0.305, x5 - 0.025) yspan=(cn - 0.165, cm + 0.1) net=n4
  nm5a = contact mcon cx=(x5 - 0.14) cy=cm
  nmp5a = enclose nm5a m1 by=0.06 net=n4
  nc5b = contact licon cx=(x5 + L + 0.14) cy=cn
  nl5b = rect li xspan=(x5 + L + 0.025, x5 + L + 0.305) yspan=(-0.085, cn + 0.165) net=VGND
  nm5b = contact mcon cx=(x5 + L + 0.14) cy=0
  pc5a = contact licon cx=(x5 - 0.14) cy=cp
  pl5a = rect li xspan=(x5 - 0.305, x5 - 0.025) yspan=(cq - 0.1, cp + 0.165) net=n6
  pm5a = contact mcon cx=(x5 - 0.14) cy=cq
  pmp5a = enclose pm5a m1 by=0.06 net=n6
  pc5b = contact licon cx=(x5 + L + 0.14) cy=cp
  pl5b = rect li xspan=(x5 + L + 0.025, x5 + L + 0.305) yspan=(cp - 0.165, H + 0.085) net=VPWR
  pm5b = contact mcon cx=(x5 + L + 0.14) cy=H
  # column 6: gate A; n device n5-VGND (WN2), p device n1-VPWR (WP2)
  nd6 = rect diff xspan=(x6 - 0.265, x6 + L + 0.265) yspan=(nb, nb + WN2)
  pd6 = rect diff xspan=(x6 - 0.265, x6 + L + 0.265) yspan=(pt - WP2, pt)
  pg6 = rect poly xspan=(x6, x6 + L) yspan=(0.105, H - 0.105)
  gp6 = rect poly xspan=(x6 - 0.06, x6 + L + 0.06) yspan=(ya - 0.17, ya + 0.17)
  gc6 = contact licon cx=(x6 + L / 2) cy=ya
  gl6 = rect li xspan=(x6 + L / 2 - 0.165, x6 + L / 2 + 0.165) yspan=(ya - 0.165, ya + 0.165) net=A
  gm6 = contact mcon in=gl6
  gmp6 = enclose gm6 m1 by=0.06 net=A
  gn6 = rect npc xspan=(x6 - 0.1, x6 + L + 0.1) yspan=(ya - 0.17, ya + 0.17)
  nc6a = contact licon cx=(x6 - 0.14) cy=cn
  nl6a = rect li xspan=(x6 - 0.305, x6 - 0.025) yspan=(cn - 0.165, cm + 0.1) net=n5
  nm6a = contact mcon cx=(x6 - 0.14) cy=cm
  nmp6a = enclose nm6a m1 by=0.06 net=n5
  nc6b = contact licon cx=(x6 + L + 0.14) cy=cn
  nl6b = rect li xspan=(x6 + L + 0.025, x6 + L + 0.305) yspan=(-0.085, cn + 0.165) net=VGND
  nm6b = contact mcon cx=(x6 + L + 0.14) cy=0
  pc6a = contact licon cx=(x6 - 0.14) cy=cp
  pl6a = rect li xspan=(x6 - 0.305, x6 - 0.025) yspan=(cq - 0.1, cp + 0.165) net=n1
  pm6a = contact mcon cx=(x6 - 0.14) cy=cq
  pmp6a = enclose pm6a m1 by=0.06 net=n1
  pc6b = contact licon cx=(x6 + L + 0.14) cy=cp
  pl6b = rect li xspan=(x6 + L + 0.025, x6 + L + 0.305) yspan=(cp - 0.165, H + 0.085) net=VPWR
  pm6b = contact mcon cx=(x6 + L + 0.14) cy=H
  # column 7: gate C; n device n3-n5 (WN2), p device n3-n1 (WP2)
  nd7 = rect diff xspan=(x7 - 0.265, x7 + L + 0.265) yspan=(nb, nb + WN2)
  pd7 = rect diff xspan=(x7 - 0.265, x7 + L + 0.265) yspan=(pt - WP2, pt)
  pg7 = rect poly xspan=(x7, x7 + L) yspan=(0.105, H - 0.105)
  gp7 = rect poly xspan=(x7 - 0.06, x7 + L + 0.06) yspan=(yb - 0.17, yb + 0.17)
  gc7 = contact licon cx=(x7 + L / 2) cy=yb
  gl7 = rect li xspan=(x7 + L / 2 - 0.165, x7 + L / 2 + 0.165) yspan=(yb - 0.165, yb + 0.165) net=C
  gm7 = contact mcon in=gl7
  gmp7 = enclose gm7 m1 by=0.06 net=C
  gn7 = rect npc xspan=(x7 - 0.1, x7 + L + 0.1) yspan=(yb - 0.17, yb + 0.17)
  nc7a = contact licon cx=(x7 - 0.14) cy=cn
  nl7a = rect li xspan=(x7 - 0.305, x7 - 0.025) yspan=(cn - 0.165, cm + 0.1) net=n3
  nm7a = contact mcon cx=(x7 - 0.14) cy=cm
  nmp7a = enclose nm7a m1 by=0.06 net=n3
  nc7b = contact licon cx=(x7 + L + 0.14) cy=cn
  nl7b = rect li xspan=(x7 + L + 0.025, x7 + L + 0.305) yspan=(cn - 0.165, cm + 0.1) net=n5
  nm7b = contact mcon cx=(x7 + L + 0.14) cy=cm
  nmp7b = enclose nm7b m1 by=0.06 net=n5
  pc7a = contact licon cx=(x7 - 0.14) cy=cp
  pl7a = rect li xspan=(x7 - 0.305, x7 - 0.025) yspan=(cq - 0.1, cp + 0.165) net=n3
  pm7a = contact mcon cx=(x7 - 0.14) cy=cq
  pmp7a = enclose pm7a m1 by=0.06 net=n3
  pc7b = contact licon cx=(x7 + L + 0.14) cy=cp
  pl7b = rect li xspan=(x7 + L + 0.025, x7 + L + 0.305) yspan=(cq - 0.1, cp + 0.165) net=n1
  pm7b = contact mcon cx=(x7 + L + 0.14) cy=cq
  pmp7b = enclose pm7b m1 by=0.06 net=n1
  nim = enclose [nd1, nd2, nd3, nd4, nd5, nd6, nd7] nsdm
  pim = enclose [pd1, pd2, pd3, pd4, pd5, pd6, pd7] psdm
  well y=((nb + WN + 0.34 + pt - WP - 0.18) / 2)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells
  # routing of the internal nets (their met1 pads carry the net labels)
  route A layers=m1,m2
  route B layers=m1,m2
  route C layers=m1,m2
  route n3 layers=m1,m2
  route X layers=m1,m2
  route n1 layers=m1,m2
  route n2 layers=m1,m2
  route n4 layers=m1,m2
  route n5 layers=m1,m2
  route n6 layers=m1,m2
  route n7 layers=m1,m2
  port A in on=gmp2
  port B in on=gmp3
  port C in on=gmp5
  port X out on=nmp1b
end
