# SKY130 half adder: SUM = A ^ B, COUT = A & B   (stdcell, level 1)
# Column layout: 7 gate columns shared by an nmos row (bottom) and a pmos row (top).
# Nmos islands: N2 (c1..c3), N1 (c4..c5), N34 (c6..c7); pmos islands likewise.
pdk sky130A
param L=0.15 H=2.72 WN=0.49 WN2=0.42 WP=0.75 WP2=0.42

stdcell ha width=15 height=H
  device M0  nmos w=WN2 l=L d=n1  g=B  s=n2
  device M1  nmos w=WN2 l=L d=n3  g=n1 s=n4
  device M2  pmos w=WP2 l=L d=n1  g=A  s=VPWR
  device M3  pmos w=WP  l=L d=VPWR g=n1 s=COUT
  device M4  nmos w=WN2 l=L d=VGND g=A s=n4
  device M5  pmos w=WP2 l=L d=n3  g=B  s=n5
  device M6  pmos w=WP2 l=L d=n5  g=A  s=VPWR
  device M7  nmos w=WN  l=L d=SUM g=n3 s=VGND
  device M8  nmos w=WN2 l=L d=n2  g=A  s=VGND
  device M9  pmos w=WP  l=L d=SUM g=n3 s=VPWR
  device M10 pmos w=WP2 l=L d=VPWR g=n1 s=n3
  device M11 nmos w=WN2 l=L d=n4  g=B  s=VGND
  device M12 nmos w=WN  l=L d=VGND g=n1 s=COUT
  device M13 pmos w=WP2 l=L d=VPWR g=B s=n1

  # gate columns (poly pitch 0.52 shared node, 1.12 across a diffusion break)
  c1 = 1.05
  c2 = c1 + 0.64
  c3 = c2 + 0.64
  c4 = c3 + 1.12
  c5 = c4 + 0.64
  c6 = c5 + 1.12
  c7 = c6 + 0.64
  yc = 1.23

  # diffusion islands
  dN2 = rect diff w=(c3 - c1 + 0.68) h=WN2 left=(c1 - 0.34) above=ptap
  dN1 = rect diff w=(c5 - c4 + 0.68) h=WN2 left=(c4 - 0.34) above=ptap
  dN3 = rect diff w=(c7 - c6 + 0.68) h=WN  left=(c6 - 0.34) above=ptap
  dP2 = rect diff w=(c3 - c1 + 0.68) h=WP2 left=(c1 - 0.34) below=ntap
  dP1 = rect diff w=(c5 - c4 + 0.68) h=WP2 left=(c4 - 0.34) below=ntap
  dP3 = rect diff w=(c7 - c6 + 0.68) h=WP  left=(c6 - 0.34) below=ntap
  nim = enclose [dN2, dN1, dN3] nsdm
  pim = enclose [dP2, dP1, dP3] psdm
  well y=((dN3.top + 0.34 + dP3.bottom - 0.18) / 2)

  # gates: one poly stripe per column through both rows
  g1 = cross [dN2, dP2] poly w=L cx=c1      # n1 : M1, M10
  g2 = cross [dN2, dP2] poly w=L cx=c2      # A  : M4, M6
  g3 = cross [dN2, dP2] poly w=L cx=c3      # B  : M11, M5
  g4 = cross [dN1, dP1] poly w=L cx=c4      # A  : M8, M2
  g5 = cross [dN1, dP1] poly w=L cx=c5      # B  : M0, M13
  g6 = cross [dN3, dP3] poly w=L cx=c6      # n3 : M7, M9
  g7 = cross [dN3, dP3] poly w=L cx=c7      # n1 : M12, M3

  # gate contacts in the channel
  gc1 = contact licon cx=c1 cy=1.4
  gc2 = contact licon cx=c2 cy=1.4
  gc3 = contact licon cx=c3 cy=1.4
  gc4 = contact licon cx=c4 cy=1.4
  gc5 = contact licon cx=c5 cy=1.4
  gc6 = contact licon cx=c6 cy=yc
  gc7 = contact licon cx=c7 cy=yc
  gp1 = enclose gc1 poly by=minx
  gp2 = enclose gc2 poly by=minx
  gp3 = enclose gc3 poly by=minx
  gp4 = enclose gc4 poly by=minx
  gp5 = enclose gc5 poly by=minx
  gp6 = enclose gc6 poly by=minx
  gp7 = enclose gc7 poly by=minx
  gn1 = enclose gc1 npc
  gn2 = enclose gc2 npc
  gn3 = enclose gc3 npc
  gn4 = enclose gc4 npc
  gn5 = enclose gc5 npc
  gn6 = enclose gc6 npc
  gn7 = enclose gc7 npc
  ga1 = enclose gc1 li net=n1
  ga2 = enclose gc2 li net=A
  ga3 = enclose gc3 li net=B
  ga4 = enclose gc4 li net=A
  ga5 = enclose gc5 li net=B
  ga6 = enclose gc6 li net=n3
  ga7 = enclose gc7 li net=n1
  gm1 = contact mcon in=ga1
  gm2 = contact mcon in=ga2
  gm3 = contact mcon in=ga3
  gm4 = contact mcon in=ga4
  gm5 = contact mcon in=ga5
  gm6 = contact mcon in=ga6
  gm7 = contact mcon in=ga7
  gq1 = enclose gm1 m1 by=0.06 net=n1
  gq2 = enclose gm2 m1 by=0.06 net=A
  gq3 = enclose gm3 m1 by=0.06 net=B
  gq4 = enclose gm4 m1 by=0.06 net=A
  gq5 = enclose gm5 m1 by=0.06 net=B
  gq6 = enclose gm6 m1 by=0.06 net=n3
  gq7 = enclose gm7 m1 by=0.06 net=n1

  # source / drain contacts (nodes with no contact are shared diffusion: n2, n5)
  n2L = array licon in=dN2 left_of=g1       # n3
  n2M1 = array licon in=dN2 between=[g1, g2] # n4
  n2M2 = array licon in=dN2 between=[g2, g3] # VGND
  n2R = array licon in=dN2 right_of=g3      # n4
  n1L = array licon in=dN1 left_of=g4       # VGND
  n1R = array licon in=dN1 right_of=g5      # n1
  n3L = array licon in=dN3 left_of=g6       # SUM
  n3M = array licon in=dN3 between=[g6, g7] # VGND
  n3R = array licon in=dN3 right_of=g7      # COUT
  p2L = array licon in=dP2 left_of=g1       # n3
  p2M1 = array licon in=dP2 between=[g1, g2] # VPWR
  p2R = array licon in=dP2 right_of=g3      # n3
  p1L = array licon in=dP1 left_of=g4       # n1
  p1M = array licon in=dP1 between=[g4, g5] # VPWR
  p1R = array licon in=dP1 right_of=g5      # n1
  p3L = array licon in=dP3 left_of=g6       # SUM
  p3M = array licon in=dP3 between=[g6, g7] # VPWR
  p3R = array licon in=dP3 right_of=g7      # COUT

  # supply straps to the rails
  s1 = enclose n2M2 li
  s2 = enclose n1L li
  s3 = enclose n3M li
  s4 = enclose p2M1 li
  s5 = enclose p1M li
  s6 = enclose p3M li
  gnd1 = strap li from=s1 to=vgnd_li
  gnd2 = strap li from=s2 to=vgnd_li
  gnd3 = strap li from=s3 to=vgnd_li
  pwr1 = strap li from=s4 to=vpwr_li
  pwr2 = strap li from=s5 to=vpwr_li
  pwr3 = strap li from=s6 to=vpwr_li

  # internal nets: li + mcon + met1 landing pad
  l1 = enclose n2L li net=n3
  l2 = enclose n2M1 li net=n4
  l3 = enclose n2R li net=n4
  l4 = enclose n1R li net=n1
  l5 = enclose n3L li net=SUM
  l6 = enclose n3R li net=COUT
  l7 = enclose p2L li net=n3
  l8 = enclose p2R li net=n3
  l9 = enclose p1L li net=n1
  l10 = enclose p1R li net=n1
  l11 = enclose p3L li net=SUM
  l12 = enclose p3R li net=COUT
  m1a = contact mcon in=l1
  m2a = contact mcon in=l2
  m3a = contact mcon in=l3
  m4a = contact mcon in=l4
  m5a = contact mcon in=l5
  m6a = contact mcon in=l6
  m7a = contact mcon in=l7
  m8a = contact mcon in=l8
  m9a = contact mcon in=l9
  m10a = contact mcon in=l10
  m11a = contact mcon in=l11
  m12a = contact mcon in=l12
  q1 = enclose m1a m1 by=0.06 net=n3
  q2 = enclose m2a m1 by=0.06 net=n4
  q3 = enclose m3a m1 by=0.06 net=n4
  q4 = enclose m4a m1 by=0.06 net=n1
  q5 = enclose m5a m1 by=0.06 net=SUM
  q6 = enclose m6a m1 by=0.06 net=COUT
  q7 = enclose m7a m1 by=0.06 net=n3
  q8 = enclose m8a m1 by=0.06 net=n3
  q9 = enclose m9a m1 by=0.06 net=n1
  q10 = enclose m10a m1 by=0.06 net=n1
  q11 = enclose m11a m1 by=0.06 net=SUM
  q12 = enclose m12a m1 by=0.06 net=COUT


  route n1 layers=m1,m2
  route n3 layers=m1,m2
  route n4 layers=m1,m2
  route SUM layers=m1,m2
  route COUT layers=m1,m2
  route A layers=m1,m2
  route B layers=m1,m2

  port A in on=gq2
  port B in on=gq3
  port SUM out on=q5
  port COUT out on=q6
end
