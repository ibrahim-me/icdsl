# maj3_1: built from the netlist. Gate order (left to right) is n3, A, C, B, A, C, B in BOTH rows,
# so each row is one diffusion strip: n-row X|VGND|n5|n3|n2|VGND|n4|n3 and p-row X|VPWR|n1|n3|n7|VPWR|n6|n3.
# Nets that join the two rows (X at the left end, n3 via route) are the only long connections.
pdk sky130A
param WN=0.65 WN2=0.42 WP=1.0 WP2=0.42 L=0.15 H=2.72

stdcell maj3_1 width=11 height=H taps=no
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

  # gate columns (left edges), pitch P; every x is measured from x0
  x0 = 0.9
  P = max(L + 0.325, 0.54)            # gate pitch: 0.25 diffusion overhang past M3/M8 must clear the next gate
  g1 = x0
  g2 = x0 + P
  g3 = x0 + 2*P
  g4 = x0 + 3*P
  g5 = x0 + 4*P
  g6 = x0 + 5*P
  g7 = x0 + 6*P
  nb = 0.235                          # bottom of the n row
  pt = H - 0.235                     # top of the p row
  gy = nb + WN + 0.277                # n3 gate contact (G1): 0.19 above n-diff, 0.235 below p-diff
  yA = gy                             # input gate contacts sit at the same height as the n3 contact
  yC = gy
  yB = gy
  xe = g7 + L + 0.4                   # right end of the diffusion
  # node contact centres: between gate i and gate i+1
  m1 = g1 + (P + L) / 2
  m2 = g2 + (P + L) / 2
  m3 = g3 + (P + L) / 2
  m4 = g4 + (P + L) / 2
  m5 = g5 + (P + L) / 2
  m6 = g6 + (P + L) / 2
  m7 = g7 + L + 0.2
  ny = nb + WN2 / 2                   # n-row contact height
  py = pt - WP2 / 2                   # p-row contact height

  # diffusion: left block is the 0.65 / 1.0 wide M3 / M8 channel, the rest is 0.42
  ndL = rect diff xspan=(x0 - 0.59, g1 + L + 0.25) yspan=(nb, nb + WN)
  ndR = rect diff xspan=(g1 + L, xe) yspan=(nb, nb + WN2)
  pdL = rect diff xspan=(x0 - 0.59, g1 + L + 0.25) yspan=(pt - WP, pt)
  pdR = rect diff xspan=(g1 + L, xe) yspan=(pt - WP2, pt)
  nim = enclose [ndL, ndR] nsdm
  pim = enclose [pdL, pdR] psdm

  # poly: one full-height gate per column (crosses both rows) and a pad for its gate contact
  q1 = rect poly xspan=(g1, g1 + L) yspan=(0.105, H - 0.105)
  q2 = rect poly xspan=(g2, g2 + L) yspan=(0.105, H - 0.105)
  q3 = rect poly xspan=(g3, g3 + L) yspan=(0.105, H - 0.105)
  q4 = rect poly xspan=(g4, g4 + L) yspan=(0.105, H - 0.105)
  q5 = rect poly xspan=(g5, g5 + L) yspan=(0.105, H - 0.105)
  q6 = rect poly xspan=(g6, g6 + L) yspan=(0.105, H - 0.105)
  q7 = rect poly xspan=(g7, g7 + L) yspan=(0.105, H - 0.105)
  qp1 = rect poly xspan=(g1 + L/2 - 0.165, g1 + L/2 + 0.165) yspan=(gy - 0.165, gy + 0.165)
  qp2 = rect poly xspan=(g2 + L/2 - 0.165, g2 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165)
  qp3 = rect poly xspan=(g3 + L/2 - 0.165, g3 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165)
  qp4 = rect poly xspan=(g4 + L/2 - 0.165, g4 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165)
  qp5 = rect poly xspan=(g5 + L/2 - 0.165, g5 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165)
  qp6 = rect poly xspan=(g6 + L/2 - 0.165, g6 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165)
  qp7 = rect poly xspan=(g7 + L/2 - 0.165, g7 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165)

  # gate contacts (middle gap) and their local interconnect, labelled by gate net
  gc1 = contact licon cx=(g1 + L/2) cy=gy
  gc2 = contact licon cx=(g2 + L/2) cy=yA
  gc3 = contact licon cx=(g3 + L/2) cy=yC
  gc4 = contact licon cx=(g4 + L/2) cy=yB
  gc5 = contact licon cx=(g5 + L/2) cy=yA
  gc6 = contact licon cx=(g6 + L/2) cy=yC
  gc7 = contact licon cx=(g7 + L/2) cy=yB
  gl1 = rect li xspan=(g1 + L/2 - 0.165, g1 + L/2 + 0.165) yspan=(gy - 0.165, gy + 0.165) net=n3
  gl2 = rect li xspan=(g2 + L/2 - 0.165, g2 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165) net=A
  np2 = rect npc xspan=(g2 + L/2 - 0.165, g2 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165)
  gl3 = rect li xspan=(g3 + L/2 - 0.165, g3 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165) net=C
  np3 = rect npc xspan=(g3 + L/2 - 0.165, g3 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165)
  gl4 = rect li xspan=(g4 + L/2 - 0.165, g4 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165) net=B
  np4 = rect npc xspan=(g4 + L/2 - 0.165, g4 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165)
  gl5 = rect li xspan=(g5 + L/2 - 0.165, g5 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165) net=A
  np5 = rect npc xspan=(g5 + L/2 - 0.165, g5 + L/2 + 0.165) yspan=(yA - 0.165, yA + 0.165)
  gl6 = rect li xspan=(g6 + L/2 - 0.165, g6 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165) net=C
  np6 = rect npc xspan=(g6 + L/2 - 0.165, g6 + L/2 + 0.165) yspan=(yC - 0.165, yC + 0.165)
  gl7 = rect li xspan=(g7 + L/2 - 0.165, g7 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165) net=B
  np7 = rect npc xspan=(g7 + L/2 - 0.165, g7 + L/2 + 0.165) yspan=(yB - 0.165, yB + 0.165)
  np1 = rect npc xspan=(g1 + L/2 - 0.165, g1 + L/2 + 0.165) yspan=(gy - 0.165, gy + 0.165)

  # n row contacts and local interconnect: X | VGND | n5 | n3 | n2 | VGND | n4 | n3
  nc0 = contact licon cx=(x0 - 0.445) cy=ny
  nc1 = contact licon cx=m1 cy=ny
  nc2 = contact licon cx=m2 cy=ny
  nc3 = contact licon cx=m3 cy=ny
  nc4 = contact licon cx=m4 cy=ny
  nc5 = contact licon cx=m5 cy=ny
  nc6 = contact licon cx=m6 cy=ny
  nc7 = contact licon cx=m7 cy=ny
  nl0 = rect li xspan=(x0 - 0.61, x0 - 0.28) yspan=(ny - 0.165, py + 0.165) net=X
  nl1 = rect li xspan=(m1 - 0.165, m1 + 0.165) yspan=(-0.085, 0.75) net=VGND
  nl2 = rect li xspan=(m2 - 0.165, m2 + 0.165) yspan=(ny - 0.165, 0.75) net=n5
  nl3 = rect li xspan=(m3 - 0.165, m3 + 0.165) yspan=(ny - 0.165, 0.75) net=n3
  nl4 = rect li xspan=(m4 - 0.165, m4 + 0.165) yspan=(ny - 0.165, 0.75) net=n2
  nl5 = rect li xspan=(m5 - 0.165, m5 + 0.165) yspan=(-0.085, 0.75) net=VGND
  nl6 = rect li xspan=(m6 - 0.165, m6 + 0.165) yspan=(ny - 0.165, 0.75) net=n4
  nl7 = rect li xspan=(m7 - 0.165, m7 + 0.165) yspan=(ny - 0.165, 0.75) net=n3

  # p row contacts and local interconnect: X | VPWR | n1 | n3 | n7 | VPWR | n6 | n3
  pc0 = contact licon cx=(x0 - 0.445) cy=py
  pc1 = contact licon cx=m1 cy=py
  pc2 = contact licon cx=m2 cy=py
  pc3 = contact licon cx=m3 cy=py
  pc4 = contact licon cx=m4 cy=py
  pc5 = contact licon cx=m5 cy=py
  pc6 = contact licon cx=m6 cy=py
  pc7 = contact licon cx=m7 cy=py
  pl1 = rect li xspan=(m1 - 0.165, m1 + 0.165) yspan=(1.95, H + 0.085) net=VPWR
  pl2 = rect li xspan=(m2 - 0.165, m2 + 0.165) yspan=(1.95, py + 0.165) net=n1
  pl3 = rect li xspan=(m3 - 0.165, m3 + 0.165) yspan=(1.95, py + 0.165) net=n3
  pl4 = rect li xspan=(m4 - 0.165, m4 + 0.165) yspan=(1.95, py + 0.165) net=n7
  pl5 = rect li xspan=(m5 - 0.165, m5 + 0.165) yspan=(1.95, H + 0.085) net=VPWR
  pl6 = rect li xspan=(m6 - 0.165, m6 + 0.165) yspan=(1.95, py + 0.165) net=n6
  pl7 = rect li xspan=(m7 - 0.165, m7 + 0.165) yspan=(1.95, py + 0.165) net=n3

  # supply and output metal
  mc1 = contact mcon cx=m1 cy=0
  mc5 = contact mcon cx=m5 cy=0
  mc6 = contact mcon cx=m1 cy=H
  mc7 = contact mcon cx=m5 cy=H
  well y=(pt - WP - 0.18)
  nwx = rect nwell xspan=(-0.19, cell.right + 0.19) yspan=(nwell.bottom, nwell.top)   # as in the PDK cells

  # nets that join the two rows or several pieces
  route n3 layers=m1,m2
  route A layers=m2,m3
  route B layers=m2,m3
  route C layers=m1,m2

  # pins
  port A in on=gl2
  port B in on=gl4
  port C in on=gl3
  port X out on=nl0
end
